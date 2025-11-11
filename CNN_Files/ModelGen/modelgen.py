"""
modelgen.py

Unified ModelGen class:
  - Stage 1: Keras -> software_model.json
  - Stage 2: software_model.json -> hardware_model.json
  - Stage 3: Generate Memory files (mif/csv)
  - Stage 4: Build HDL (RTL Verilog files) using build_rtl_v5 logic


Usage:
from modelgen import ModelGen
mg = ModelGen("model.keras", out_dir="project_output")
mg.generate_software_json()
mg.compile(data_width=16, fraction_bits=14, signed=1, guard_type=2)
mg.gen_files(save_index=True)
mg.build()
"""

import json
import shutil
from pathlib import Path

import numpy as np
import tensorflow as tf


# ----------------------------
# Layer support and helpers
# ----------------------------
SUPPORTED_LAYERS = {
    "Conv2D": {
        "supported": ["filters", "kernel_size", "strides", "activation"],
        "valid_activations": ["relu", None],
    },
    "MaxPooling2D": {
        "supported": ["pool_size", "strides"]
    },
    "Dense": {
        "supported": ["units", "activation"],
        "valid_activations": ["relu", "sigmoid", "softmax"],
    },
    "Flatten": {"supported": []},
}


def _shape_to_list(shape):
    if shape is None:
        return None
    return [int(s) if s is not None else None for s in shape]


def _scalarize(param):
    if isinstance(param, (list, tuple)):
        if len(set(param)) == 1:
            return param[0]
        raise ValueError(f"⚠️ Only square kernels / uniform strides supported, got {param}")
    return param


def _infer_layer_shapes(model):
    # Try to infer input shape
    if hasattr(model, "inputs") and model.inputs:
        input_shape = [1 if s is None else s for s in model.inputs[0].shape]
    elif hasattr(model, "input_shape") and model.input_shape:
        input_shape = [1 if s is None else s for s in model.input_shape]
    else:
        raise ValueError("❌ Could not infer model input shape.")

    dummy_input = tf.zeros(input_shape)
    x = dummy_input
    layer_shapes = []
    for layer in model.layers:
        in_shape = _shape_to_list(x.shape)
        x = layer(x)
        out_shape = _shape_to_list(x.shape)
        layer_shapes.append((in_shape, out_shape))
    return layer_shapes


def _extract_layer_info(layer, in_shape, out_shape):
    ltype = layer.__class__.__name__
    cfg = layer.get_config()
    data = {"name": layer.name, "type": ltype}

    # shapes
    if in_shape is None:
        raise ValueError("Input shape inference failed.")
    if len(in_shape) == 4:
        _, in_h, in_w, in_c = in_shape
        data["input_shape"] = [in_h, in_w]
        data["input_channels"] = in_c
    elif len(in_shape) == 2:
        _, n = in_shape
        data["input_shape"] = [n]
        # Preserve channel information for Flatten (inherit from previous layer)
        if layer.__class__.__name__ == "Flatten" and hasattr(layer, '_inbound_nodes') and layer._inbound_nodes:
            prev_layer = layer._inbound_nodes[0].inbound_layers
            if not isinstance(prev_layer, list):
                prev_layer = [prev_layer]
            if prev_layer and hasattr(prev_layer[0], 'output_shape'):
                prev_out_shape = _shape_to_list(prev_layer[0].output_shape)
                if len(prev_out_shape) == 4:
                    _, h, w, c = prev_out_shape
                    data["input_channels"] = c
                else:
                    data["input_channels"] = 1
            else:
                data["input_channels"] = 1
        else:
            data["input_channels"] = 1


    if len(out_shape) == 4:
        _, out_h, out_w, out_c = out_shape
        data["output_shape"] = [out_h, out_w]
        data["output_channels"] = out_c
    elif len(out_shape) == 2:
        _, n = out_shape
        data["output_shape"] = [n]
        data["output_channels"] = n

    # parameters
    for key in SUPPORTED_LAYERS.get(ltype, {}).get("supported", []):
        if key in cfg:
            val = cfg[key]
            if key == "strides":
                data["stride"] = _scalarize(val)
            elif key == "kernel_size":
                data["kernel_size"] = _scalarize(val)
            elif key == "pool_size":
                data["pool_size"] = _scalarize(val)
            else:
                data[key] = val

    act = cfg.get("activation", None)
    valid_acts = SUPPORTED_LAYERS.get(ltype, {}).get("valid_activations", [])
    if act and act not in valid_acts:
        raise ValueError(f"Unsupported activation '{act}' for layer {layer.name}")
    if act:
        data["activation"] = act

    return data


# ----------------------------
# Fixed-point / MIF helpers
# ----------------------------
def quantize_to_fixed_raw(value, fraction_bits, data_width, signed=True):
    scaled = value * (2 ** fraction_bits)
    q = int(round(scaled))
    if signed:
        max_val = 2 ** (data_width - 1) - 1
        min_val = -(2 ** (data_width - 1))
        q = max(min(q, max_val), min_val)
        if q < 0:
            q = (1 << data_width) + q
    else:
        max_val = 2 ** data_width - 1
        q = max(min(q, max_val), 0)
    return q


def int_to_bin(value, data_width):
    return format(value, f"0{data_width}b")


# ----------------------------
# Hardware JSON builder helpers (Conv2D / Max2D)
# ----------------------------
GLOBAL_DEFAULTS = {
    "DATA_WIDTH": 16,
    "FRACTION_SIZE": 14,
    "SIGNED": 1,
    "GUARD_TYPE": 2
}


def _make_conv2d_block(name, layer, conv_idx,
                       prev_out_sig="data_in", prev_valid_sig="data_valid",
                       data_width_sym="DATA_WIDTH", frac_sym="FRACTION_SIZE",
                       signed_sym="SIGNED", guard_sym="GUARD_TYPE"):
    """
    Create Conv2D block JSON (with previous layer output connections).
    """
    activation_flag = 1 if layer.get("activation", "").lower() == "relu" else 0

    params = {
        "KERNEL_SIZE": layer["kernel_size"],
        "COLUMN_NUM": layer["input_shape"][0],
        "ROW_NUM": layer["input_shape"][1],
        "STRIDE": layer["stride"],
        "INPUT_CHANNELS": layer["input_channels"],
        "OUTPUT_CHANNELS": layer.get("output_channels", layer.get("filters", 1)),
        "DATA_WIDTH": data_width_sym,
        "FRACTION_SIZE": frac_sym,
        "SIGNED": signed_sym,
        "ACTIVATION": activation_flag,
        "GUARD_TYPE": guard_sym,
        "WEIGHT_FILE": f"c_{conv_idx}_w.mif",
        "BIAS_FILE": f"c_{conv_idx}_b.mif"
    }

    return {
        name: {
            "module": "Conv2D",
            "parameters": params,
            "inputs": {
                "clock": {"name": "clock", "width": 1},
                "sreset_n": {"name": "sreset_n", "width": 1},
                "data_valid": {"name": prev_valid_sig, "width": 1},
                "data_in": {"name": prev_out_sig, "width": data_width_sym}
            },
            "outputs": {
                "conv_out": {"name": f"{name}_out", "width": data_width_sym},
                "conv_valid": {"name": f"{name}_valid", "width": 1}
            },
            "files": {
                "weights_file": params["WEIGHT_FILE"],
                "biases_file": params["BIAS_FILE"]
            }
        }
    }





def _make_max2d_block(name, layer, pool_idx,
                      prev_out_sig="data_in", prev_valid_sig="data_valid",
                      data_width_sym="DATA_WIDTH", signed_sym="SIGNED"):
    """
    Create Max2D block JSON (with previous layer output connections).
    """
    params = {
        "KERNEL_SIZE": layer["pool_size"],
        "DATA_WIDTH": data_width_sym,
        "COLUMN_NUM": layer["input_shape"][0],
        "ROW_NUM": layer["input_shape"][1],
        "STRIDE": layer["stride"],
        "CHANNELS": layer["input_channels"],
        "SIGNED": signed_sym
    }

    return {
        name: {
            "module": "Max2D",
            "parameters": params,
            "inputs": {
                "clock": {"name": "clock", "width": 1},
                "sreset_n": {"name": "sreset_n", "width": 1},
                "data_valid": {"name": prev_valid_sig, "width": 1},
                "data_in": {"name": prev_out_sig, "width": data_width_sym}
            },
            "outputs": {
                "maxp_out": {"name": f"{name}_out", "width": data_width_sym},
                "maxp_valid": {"name": f"{name}_valid", "width": 1}
            }
        }
    }




def _make_maxfinder_block(prev_out_signal, num_outputs):
    return {
        "maxFinder": {
            "module": "maxFinder",
            "parameters": {
                "NUM_INPUTS": num_outputs,
                "DATA_WIDTH": "DATA_WIDTH",
                "SIGNED": "SIGNED"
            },
            "inputs": {
                "clock": {"name": "clock", "width": 1},
                "sreset_n": {"name": "sreset_n", "width": 1},
                "data_valid": {"name": f"{prev_out_signal}_valid", "width": 1},
                "data_in": {"name": prev_out_signal, "width": f"DATA_WIDTH * {num_outputs}"}
            },
            "outputs": {
                "class_idx": {"name": "class_idx", "width": "log2(NUM_INPUTS)"},
                "valid": {"name": "class_valid", "width": 1}
            }
        }
    }


def _build_nn_block(prev_out_signal, dense_layers, prev_channels):
    """
    Build NN metadata. Adds:
      - name
      - num_inputs (flattened size)
      - input_channels (from last conv/pool)
      - num_neurons
      - activation
      - weight/bias filename patterns
    """
    nn_layers = []
    for i, layer in enumerate(dense_layers, start=1):
        # For the first dense layer after flatten, inherit real channel count
        if i == 1:
            input_ch = prev_channels
        else:
            # All subsequent dense layers are fully connected → single channel
            input_ch = 1

        entry = {
            "name": f"dense_L{i}",
            "num_inputs": layer["input_shape"][0],
            "input_channels": input_ch,
            "num_neurons": layer["units"],
            "activation": layer.get("activation", "none"),
            "weight_file_pattern": f"w_{i}_<neuron>.mif",
            "bias_file_pattern": f"b_{i}_<neuron>.mif"
        }
        nn_layers.append(entry)


    return {
        "Build": True,
        "globals": {
            "DATA_WIDTH": "DATA_WIDTH",
            "FRACTION_SIZE": "FRACTION_SIZE",
            "SIGNED": "SIGNED"
        },
        "io": {
            "input_signal": prev_out_signal,
            "input_valid": f"{prev_out_signal}_valid",
            "output_signal": "nn_out",
            "output_valid": "nn_valid"
        },
        "layers": nn_layers
    }


# ----------------------------
# ModelGen class
# ----------------------------
class ModelGen:
    def __init__(self, model_path, out_dir="project_output"):
        """
        model_path : path to .keras model file
        out_dir    : project folder where Memory_Files will be created
        """
        self.model_path = Path(model_path)
        self.out_dir = Path(out_dir)
        self.memory_root = self.out_dir / "Memory_Files"
        self.software_json_path = self.out_dir / "software_model.json"
        self.hardware_json_path = self.out_dir / "hardware_model.json"
        self.hardware_params = GLOBAL_DEFAULTS.copy()
        self.software_json = None
        self.hardware_json = None

    # ---------------- Stage 1 ----------------
    def generate_software_json(self, out_path=None):
        if out_path is None:
            out_path = self.software_json_path
        model = tf.keras.models.load_model(str(self.model_path), compile=False)
        layer_shapes = _infer_layer_shapes(model)
        layers_out = []
        for layer, (in_s, out_s) in zip(model.layers, layer_shapes):
            ltype = layer.__class__.__name__
            if ltype not in SUPPORTED_LAYERS:
                # keep backward compatibility: skip unknown layers
                continue
            info = _extract_layer_info(layer, in_s, out_s)
            layers_out.append(info)
        # Ensure Dense after Flatten inherits correct channel count
        for i in range(1, len(layers_out)):
            prev_layer = layers_out[i - 1]
            curr_layer = layers_out[i]
            if curr_layer["type"] == "Dense" and prev_layer["type"] == "Flatten":
                curr_layer["input_channels"] = prev_layer["input_channels"]

        out_json = {"model_name": model.name, "layers": layers_out}
        Path(out_path).parent.mkdir(parents=True, exist_ok=True)
        Path(out_path).write_text(json.dumps(out_json, indent=2))
        self.software_json = out_json
        self.software_json_path = Path(out_path)
        print(f"✅ Software model JSON written to {out_path}")

    # ---------------- Stage 2 ----------------
    def compile(self, data_width=16, fraction_bits=14, signed=1, guard_type=2, add_mif_prefix=False):
        """
        Generate hardware_model.json with proper layer chaining.
        """
        self.hardware_params = {
            "DATA_WIDTH": data_width,
            "FRACTION_SIZE": fraction_bits,
            "SIGNED": signed,
            "GUARD_TYPE": guard_type
        }

        if self.software_json is None:
            if self.software_json_path.exists():
                self.software_json = json.loads(self.software_json_path.read_text())
            else:
                raise RuntimeError("software_model.json not found — run generate_software_json first.")

        layers = self.software_json["layers"]
        conv_idx, pool_idx = 1, 1
        dense_layers = []
        prev_out, prev_valid = "data_in", "data_valid"
        prev_channels = 1

        top = {
            "module": "CNN",
            "hardware parameters": self.hardware_params,
            "inputs": {"clock": 1, "sreset_n": 1, "data_in": "DATA_WIDTH", "data_valid": 1},
            "outputs": {"class_idx": "log2(NUM_INPUTS)", "class_valid": 1}
        }

        for layer in layers:
            ltype = layer["type"]

            if ltype == "Conv2D":
                conv_name = f"Conv{conv_idx}"
                block = _make_conv2d_block(conv_name, layer, conv_idx,
                                        prev_out_sig=prev_out,
                                        prev_valid_sig=prev_valid)
                top.update(block)
                prev_out, prev_valid = f"{conv_name}_out", f"{conv_name}_valid"
                prev_channels = layer.get("output_channels", prev_channels)
                conv_idx += 1

            elif ltype == "MaxPooling2D":
                pool_name = f"Maxpool{pool_idx}"
                block = _make_max2d_block(pool_name, layer, pool_idx,
                                        prev_out_sig=prev_out,
                                        prev_valid_sig=prev_valid)
                top.update(block)
                prev_out, prev_valid = f"{pool_name}_out", f"{pool_name}_valid"
                prev_channels = layer.get("output_channels", prev_channels)
                pool_idx += 1

            elif ltype == "Flatten":
                continue

            elif ltype == "Dense":
                dense_layers.append(layer)

        # NN + maxFinder hookup
        if dense_layers:
            top["NN"] = _build_nn_block(prev_out, dense_layers, prev_channels)
            last_layer = dense_layers[-1]
            num_outputs = last_layer["units"]
            top.update(_make_maxfinder_block("nn_out", num_outputs))
        else:
            top["outputs"] = {"data_out": prev_out, "data_valid": prev_valid}

        hw = {"Hardware_model": {"top": top}}
        self.hardware_json = hw
        self.hardware_json_path.parent.mkdir(parents=True, exist_ok=True)
        self.hardware_json_path.write_text(json.dumps(hw, indent=2))
        print(f"✅ Hardware model JSON written to {self.hardware_json_path}")


    # ---------------- Stage 3 ----------------
    def gen_files(self, save_index=True):
        """
        Generate MIF and CSV files for weights and biases:
         - Conv layers: one weights MIF (c_<i>_w.mif) and one biases MIF (c_<i>_b.mif)
         - Dense layers: each neuron gets w_<layer>_<neuron>.mif and b_<layer>_<neuron>.mif
        Files written to: <out_dir>/Memory_Files/mif  and <out_dir>/Memory_Files/csv
        """
        model = tf.keras.models.load_model(str(self.model_path), compile=False)

        data_width = int(self.hardware_params["DATA_WIDTH"])
        fraction_bits = int(self.hardware_params["FRACTION_SIZE"])
        signed = bool(self.hardware_params["SIGNED"])

        mem_root = self.memory_root
        if mem_root.exists():
            shutil.rmtree(mem_root)
            print(f"🧹 Removed existing folder: {mem_root}")
        (mem_root / "mif").mkdir(parents=True, exist_ok=True)
        (mem_root / "csv").mkdir(parents=True, exist_ok=True)

        generated = {"conv_blocks": [], "nn_layers": []}
        conv_block = 1
        dense_layer = 1

        def qfix(v):
            return quantize_to_fixed_raw(v, fraction_bits, data_width, signed)

        def write_file(path_obj, arr, mode):
            path_obj.parent.mkdir(parents=True, exist_ok=True)
            with open(path_obj, "w") as f:
                if mode == "mif":
                    for val in arr:
                        f.write(int_to_bin(int(val), data_width) + "\n")
                else:
                    for val in arr:
                        f.write(f"{val}\n")

        for layer in model.layers:
            ltype = layer.__class__.__name__

            if ltype == "Conv2D":
                w, b = layer.get_weights()
                w, b = np.array(w), np.array(b)
                k_h, k_w, in_c, out_c = w.shape
                # ordering: out_channel major, then in_channel, then kh, kw (kernel pos fastest)
                ordered = []
                for oc in range(out_c):
                    for ic in range(in_c):
                        for kh in range(k_h):
                            for kw in range(k_w):
                                ordered.append(float(w[kh, kw, ic, oc]))
                qw = [qfix(v) for v in ordered]
                qb = [qfix(float(x)) for x in b]

                w_mif = mem_root / "mif" / f"c_{conv_block}_w.mif"
                b_mif = mem_root / "mif" / f"c_{conv_block}_b.mif"
                w_csv = mem_root / "csv" / f"c_{conv_block}_w.csv"
                b_csv = mem_root / "csv" / f"c_{conv_block}_b.csv"

                write_file(w_mif, qw, "mif")
                write_file(b_mif, qb, "mif")
                write_file(w_csv, ordered, "csv")
                write_file(b_csv, b.tolist(), "csv")

                generated["conv_blocks"].append({
                    "conv_block": conv_block,
                    "weights_mif": str(w_mif),
                    "biases_mif": str(b_mif),
                    "weights_csv": str(w_csv),
                    "biases_csv": str(b_csv)
                })
                print(f"✅ Conv block {conv_block}: {len(qw)} weights, {len(qb)} biases")
                conv_block += 1

            elif ltype == "Dense":
                w, b = layer.get_weights()
                w, b = np.array(w), np.array(b)
                in_dim, out_dim = w.shape
                neuron_entries = []
                for neuron in range(out_dim):
                    weights_list = [float(w[inp, neuron]) for inp in range(in_dim)]
                    bias_val = float(b[neuron])
                    qw = [qfix(v) for v in weights_list]
                    qb = qfix(bias_val)

                    w_mif = mem_root / "mif" / f"w_{dense_layer}_{neuron}.mif"
                    b_mif = mem_root / "mif" / f"b_{dense_layer}_{neuron}.mif"
                    w_csv = mem_root / "csv" / f"w_{dense_layer}_{neuron}.csv"
                    b_csv = mem_root / "csv" / f"b_{dense_layer}_{neuron}.csv"

                    write_file(w_mif, qw, "mif")
                    write_file(b_mif, [qb], "mif")
                    write_file(w_csv, weights_list, "csv")
                    write_file(b_csv, [bias_val], "csv")

                    neuron_entries.append({
                        "neuron": neuron,
                        "weights_mif": str(w_mif),
                        "bias_mif": str(b_mif),
                        "weights_csv": str(w_csv),
                        "bias_csv": str(b_csv)
                    })
                generated["nn_layers"].append({"layer": dense_layer, "neurons": neuron_entries})
                print(f"✅ Dense layer {dense_layer}: {out_dim} neurons")
                dense_layer += 1

            else:
                # skip or ignore Flatten, etc.
                continue

        if save_index:
            index_file = mem_root / "Memory_Index.json"
            with open(index_file, "w") as f:
                json.dump(generated, f, indent=2)
            print(f"🗂️  Saved index file: {index_file}")

        print(f"📁 All memory files saved in: {mem_root.resolve()}")

    # ---------------- Stage 4 ----------------
    def build(self):
        """
        Stage 4: Full RTL builder integrated.
        Generates:
        - <out_dir>/rtl/Layer_1.v, Layer_2.v, ...
        - <out_dir>/rtl/{PROJECT_NAME}_top.v  (human readable)
        Copies dependencies from designFiles/ (prefer self.out_dir/designFiles then ./designFiles)
        Packages <out_dir>/hw with all .v (from rtl/) and .mif (from Memory_Files/mif/)
        """
        from pathlib import Path
        import shutil, json, os

        OUT = Path(self.out_dir)
        PROJECT_NAME = OUT.name
        RTL_DIR = OUT / "rtl"
        HW_DIR = OUT / "hw"

        # Find designFiles directory (prefer project-specific then repo root)
        DESIGN_DIR = OUT / "designFiles"
        if not DESIGN_DIR.exists():
            DESIGN_DIR = Path("designFiles")
        vprint = print

        # dependencies base (same as earlier)
        DEPENDENCY_BASE = {
            "Conv2D": ["FP_Adder.v", "FP_Multiplier.v", "ConvMemory.v", "Conv_SIC.v", "Conv_MIC.v", "relu.v"],
            "Max2D": ["FP_Comparator.v", "Maxpool.v"],
            "neuron": ["FP_Adder.v", "FP_Multiplier.v", "Weight_Memory.v", "relu.v"],
            "maxFinder": []
        }

        def copy_if_exists(src_path: Path, dst_dir: Path):
            if not src_path.exists():
                vprint(f"⚠ design file missing: {src_path}")
                return False
            dst = dst_dir / src_path.name
            if dst.exists() and dst.stat().st_size == src_path.stat().st_size:
                return True
            shutil.copy2(src_path, dst)
            vprint(f"→ Copied {src_path.name} -> {dst_dir}")
            return True

        def resolve_and_copy(mod, rtl_dir=RTL_DIR):
            # try several candidate filenames
            candidates = [f"{mod}.v"]
            if mod.lower() in ("conv2d","convch","convolchnl","convchnl"):
                candidates += ["Conv2D.v","ConvolChnl.v","ConvChnl.v"]
            found = False
            for c in candidates:
                src = DESIGN_DIR / c
                if src.exists():
                    copy_if_exists(src, rtl_dir)
                    found = True
                    break
            if not found:
                vprint(f"⚠ Could not locate module source for {mod} (tried {candidates})")
            # copy dependency base
            for dep in DEPENDENCY_BASE.get(mod, []):
                copy_if_exists(DESIGN_DIR / dep, rtl_dir)

        def ensure_keys(d, keys, ctx):
            for k in keys:
                if k not in d:
                    raise KeyError(f"[{ctx}] Missing mandatory parameter: '{k}'")

        def derive_prev_output_channels(top):
            # find block immediately before NN and try to derive output channels
            keys = list(top.keys())
            try:
                idx = keys.index("NN")
            except ValueError:
                raise KeyError("NN block missing in JSON")
            prev_block = None
            for k in reversed(keys[:idx]):
                if isinstance(top[k], dict) and "module" in top[k]:
                    prev_block = top[k]
                    break
            if prev_block is None:
                raise KeyError("Could not find block before NN to derive output channels")
            params = prev_block.get("parameters", {})
            if "OUTPUT_CHANNELS" in params:
                return int(params["OUTPUT_CHANNELS"])
            if "OUTPUT_CHANNEL" in params:
                return int(params["OUTPUT_CHANNEL"])
            if "CHANNELS" in params:
                return int(params["CHANNELS"])
            outs = prev_block.get("outputs", {})
            data_width = int(top["hardware parameters"]["DATA_WIDTH"])
            for oname, od in outs.items():
                w = od.get("width", None)
                if isinstance(w, int):
                    if w == data_width:
                        return 1
                    if w % data_width == 0:
                        return w // data_width
                if isinstance(w, str) and "*" in w:
                    parts = [p.strip() for p in w.split("*")]
                    try:
                        if parts[-1].isdigit():
                            return int(parts[-1])
                    except:
                        pass
            raise KeyError("Could not derive output channels from preceding block. Add OUTPUT_CHANNELS/CHANNELS to block parameters.")

        # Layer file generator (writes Layer_<i>.v)
        def gen_layer_file(idx, layer, hw_params, first_layer_input_channels=None):
            name = f"Layer_{idx}"
            DW = int(hw_params["DATA_WIDTH"])
            FRAC = int(hw_params["FRACTION_SIZE"])
            weightIntWidth = DW - FRAC
            SIGMOID_SIZE = hw_params.get("SIGMOID_SIZE", 10)

            # determine input channels
            if "input_channels" in layer:
                in_ch = int(layer["input_channels"])
            else:
                if idx == 1:
                    if first_layer_input_channels is None:
                        raise KeyError(f"Layer_{idx} missing 'input_channels' and couldn't derive it")
                    in_ch = int(first_layer_input_channels)
                else:
                    vprint(f"⚠ Layer_{idx} missing input_channels; defaulting to 1")
                    in_ch = 1

            NN = int(layer["num_neurons"])
            numW = int(layer["num_inputs"])
            act = layer.get("activation", "relu")
            wpat = layer.get("weight_file_pattern", f"w_{idx}_<neuron>.mif")
            bpat = layer.get("bias_file_pattern", f"b_{idx}_<neuron>.mif")

            lines = []
            lines.append("// =============================================================")
            lines.append(f"// {name} — {layer.get('name','layer')}, act={act}, neurons={NN}")
            lines.append("// =============================================================")
            lines.append(f"module {name} #(")
            lines.append(f"    parameter NN = {NN},")
            lines.append(f"    parameter numWeight = {numW},")
            lines.append(f"    parameter dataWidth = {DW},")
            lines.append(f"    parameter layerNum = {idx},")
            lines.append(f"    parameter sigmoidSize = {SIGMOID_SIZE},")
            lines.append(f"    parameter weightIntWidth = {weightIntWidth},")
            lines.append(f"    parameter input_channels = {in_ch},")
            lines.append(f"    parameter actType = \"{act}\"")
            lines.append(f")(")
            lines.append(f"    input           clk,")
            lines.append(f"    input           rst,")
            lines.append(f"    input           weightValid,")
            lines.append(f"    input           biasValid,")
            lines.append(f"    input  [31:0]   weightValue,")
            lines.append(f"    input  [31:0]   biasValue,")
            lines.append(f"    input  [31:0]   config_layer_num,")
            lines.append(f"    input  [31:0]   config_neuron_num,")
            lines.append(f"    input           x_valid,")
            lines.append(f"    input  [input_channels*dataWidth-1:0] x_in,")
            lines.append(f"    output [NN-1:0] o_valid,")
            lines.append(f"    output [NN*dataWidth-1:0] x_out")
            lines.append(f");")
            lines.append("")

            for n in range(NN):
                wfile = wpat.replace("<neuron>", str(n))
                bfile = bpat.replace("<neuron>", str(n))
                lines.append(f"    neuron #(")
                lines.append(f"        .input_channels(input_channels),")
                lines.append(f"        .numWeight(numWeight),")
                lines.append(f"        .layerNo({idx}),")
                lines.append(f"        .neuronNo({n}),")
                lines.append(f"        .dataWidth(dataWidth),")
                lines.append(f"        .sigmoidSize(sigmoidSize),")
                lines.append(f"        .weightIntWidth(weightIntWidth),")
                lines.append(f"        .actType(actType),")
                lines.append(f"        .weightFile(\"{wfile}\"),")
                lines.append(f"        .biasFile(\"{bfile}\")")
                lines.append(f"    ) n_{n} (")
                lines.append(f"        .clk(clk),")
                lines.append(f"        .rst(rst),")
                lines.append(f"        .myinput(x_in),")
                lines.append(f"        .weightValid(weightValid),")
                lines.append(f"        .biasValid(biasValid),")
                lines.append(f"        .weightValue(weightValue),")
                lines.append(f"        .biasValue(biasValue),")
                lines.append(f"        .config_layer_num(config_layer_num),")
                lines.append(f"        .config_neuron_num(config_neuron_num),")
                lines.append(f"        .myinputValid(x_valid),")
                lines.append(f"        .out(x_out[{n}*dataWidth +: dataWidth]),")
                lines.append(f"        .outvalid(o_valid[{n}])")
                lines.append(f"    );")
                lines.append("")

            lines.append("endmodule")
            (RTL_DIR / f"{name}.v").write_text("\n".join(lines))
            vprint(f"✓ Wrote {name}.v")

        # --------------------------------------
        # Read hardware JSON and start building
        # --------------------------------------
        if RTL_DIR.exists():
            shutil.rmtree(RTL_DIR)
        RTL_DIR.mkdir(parents=True, exist_ok=True)
        vprint(f"Building RTL in: {RTL_DIR}")

        if not self.hardware_json_path.exists():
            raise FileNotFoundError(f"{self.hardware_json_path} not found — run compile() first")

        top = json.loads(self.hardware_json_path.read_text())["Hardware_model"]["top"]

        # copy some common dependencies (neuron, maxFinder, Conv2D/Max2D sources if exist)
        for m in ["Conv2D", "Max2D", "neuron", "maxFinder"]:
            resolve_and_copy(m, RTL_DIR)

        # ---------- instantiate blocks up to NN ----------
        keys = list(top.keys())
        prev_block_name = None
        prev_block = None
        # We'll collect signal names for NN input
        for k in keys:
            if k in ("hardware parameters","inputs","outputs","module","NN","maxFinder"):
                continue
            blk = top[k]
            if not isinstance(blk, dict) or "module" not in blk:
                continue
            mod = blk["module"]
            params = blk.get("parameters", {})
            inputs = blk.get("inputs", {})
            outputs = blk.get("outputs", {})

            # Conv2D
            if mod.lower() == "conv2d":
                required = ["KERNEL_SIZE","COLUMN_NUM","ROW_NUM","STRIDE","INPUT_CHANNELS","OUTPUT_CHANNELS","DATA_WIDTH","FRACTION_SIZE","SIGNED","ACTIVATION","GUARD_TYPE","WEIGHT_FILE","BIAS_FILE"]
                ensure_keys(params, required, f"{k} Conv2D")
                out_ch = int(params["OUTPUT_CHANNELS"])
                conv_out_sig = outputs.get("conv_out", {}).get("name", f"{k}_out")
                conv_valid_sig = outputs.get("conv_valid", {}).get("name", f"{k}_valid")

                lines = [
                    "    // ------------------------------------------------------------",
                    f"    // {k}: Conv2D",
                    "    // ------------------------------------------------------------",
                    f"    wire [{out_ch}*DATA_WIDTH-1:0] {conv_out_sig};",
                    f"    wire {conv_valid_sig};",
                    ""
                ]
                # params
                for pname, pval in params.items():
                    if pname in ("WEIGHT_FILE","BIAS_FILE"):
                        lines.append(f"    // param .{pname} => \"{pval}\"")
                    else:
                        lines.append(f"    // param .{pname} => {pval}")
                # instance
                lines += [
                    f"    Conv2D #(",
                    # actual param list (pass literal for symbolic params)
                ]
                # formatted param list
                for pname, pval in params.items():
                    if pname in ("WEIGHT_FILE","BIAS_FILE"):
                        lines.append(f"        .{pname}(\"{pval}\"),")
                    else:
                        lines.append(f"        .{pname}({pval}),")
                lines[-1] = lines[-1].rstrip(',')
                lines += [
                    f"    ) {k} (",
                    f"        .clock(clock),",
                    f"        .sreset_n(sreset_n),",
                    f"        .data_valid({inputs.get('data_valid',{}).get('name','data_valid')}),",
                    f"        .data_in({inputs.get('data_in',{}).get('name','data_in')}),",
                    f"        .conv_out({conv_out_sig}),",
                    f"        .conv_valid({conv_valid_sig})",
                    f"    );",
                    ""
                ]
                with open(RTL_DIR / f"{k}.v", "w") as f:
                    f.write("\n".join(lines))
                prev_block_name, prev_block = k, blk
                vprint(f"✓ Wrote {k}.v")

            # Max2D
            elif mod.lower() == "max2d":
                required = ["KERNEL_SIZE","DATA_WIDTH","COLUMN_NUM","ROW_NUM","STRIDE","CHANNELS","SIGNED"]
                ensure_keys(params, required, f"{k} Max2D")
                out_ch = int(params["CHANNELS"])
                max_out_sig = outputs.get("maxp_out", {}).get("name", f"{k}_out")
                max_valid_sig = outputs.get("maxp_valid", {}).get("name", f"{k}_valid")

                lines = [
                    "    // ------------------------------------------------------------",
                    f"    // {k}: Max2D",
                    "    // ------------------------------------------------------------",
                    f"    wire [{out_ch}*DATA_WIDTH-1:0] {max_out_sig};",
                    f"    wire {max_valid_sig};",
                    ""
                ]
                for pname, pval in params.items():
                    lines.append(f"    // param .{pname} => {pval}")
                lines += [
                    f"    Max2D #("
                ]
                for pname, pval in params.items():
                    lines.append(f"        .{pname}({pval}),")
                lines[-1] = lines[-1].rstrip(',')
                lines += [
                    f"    ) {k} (",
                    f"        .clock(clock),",
                    f"        .sreset_n(sreset_n),",
                    f"        .data_valid({inputs.get('data_valid',{}).get('name','data_valid')}),",
                    f"        .data_in({inputs.get('data_in',{}).get('name','data_in')}),",
                    f"        .maxp_out({max_out_sig}),",
                    f"        .maxp_valid({max_valid_sig})",
                    f"    );",
                    ""
                ]
                with open(RTL_DIR / f"{k}.v", "w") as f:
                    f.write("\n".join(lines))
                prev_block_name, prev_block = k, blk
                vprint(f"✓ Wrote {k}.v")

            else:
                # Generic shallow instantiation (declare outputs and instantiate)
                lines = [
                    "    // ------------------------------------------------------------",
                    f"    // {k}: {mod} (generic)",
                    "    // ------------------------------------------------------------",
                ]
                # declare outputs
                for oname, od in outputs.items():
                    signame = od.get("name", oname)
                    w = od.get("width", "DATA_WIDTH")
                    lines.append(f"    // output {signame} width={w}")
                lines += [
                    f"    {mod} #("
                ]
                for pname, pval in params.items():
                    if isinstance(pval, str) and (pval.endswith(".mif") or pval.endswith(".bin")):
                        lines.append(f"        .{pname}(\"{pval}\"),")
                    else:
                        lines.append(f"        .{pname}({pval}),")
                if params:
                    lines[-1] = lines[-1].rstrip(',')
                lines += [
                    f"    ) {k} (",
                    f"        .clock(clock),",
                    f"        .sreset_n(sreset_n),"
                ]
                for iname, idesc in inputs.items():
                    conn = idesc.get("name", iname)
                    lines.append(f"        .{iname}({conn}),")
                for oname, od in outputs.items():
                    conn = od.get("name", oname)
                    lines.append(f"        .{oname}({conn}),")
                # remove trailing comma
                lines[-1] = lines[-1].rstrip(',')
                lines += [
                    f"    );",
                    ""
                ]
                with open(RTL_DIR / f"{k}.v", "w") as f:
                    f.write("\n".join(lines))
                prev_block_name, prev_block = k, blk
                vprint(f"✓ Wrote {k}.v")

        # At this point prev_block is the block immediately before NN
        if prev_block is None:
            raise KeyError("No block found before NN; cannot connect NN input")

        # Determine first_in_ch
        nn_block = top.get("NN", {})
        if not nn_block.get("Build", False):
            raise KeyError("NN Build flag not set or NN block missing")
        layers = nn_block.get("layers", [])
        if not layers:
            raise KeyError("No layers listed in NN block")

        if "input_channels" in layers[0]:
            first_in_ch = int(layers[0]["input_channels"])
        else:
            first_in_ch = derive_prev_output_channels(top)
            vprint(f"Derived first layer input_channels = {first_in_ch} from previous block '{prev_block_name}'")

        # Generate Layer_X.v files (unrolled neurons)
        for i, layer in enumerate(layers, start=1):
            gen_layer_file(i, layer, top["hardware parameters"], first_layer_input_channels=first_in_ch if i==1 else None)
            resolve_and_copy("neuron", RTL_DIR)

        # Generate {PROJECT_NAME}_top.v (full top with FSMs and NN chaining)
        # We'll create a readable top file using the same logic as earlier v5
        hwp = top.get("hardware parameters", {})
        ensure_keys(hwp, ["DATA_WIDTH","FRACTION_SIZE","SIGNED","GUARD_TYPE"], "hardware parameters")
        DW = int(hwp["DATA_WIDTH"])
        FRAC = int(hwp["FRACTION_SIZE"])

        tlines = []
        tlines.append("// =============================================================")
        tlines.append(f"// Auto-generated {PROJECT_NAME}_top (readable, JSON-driven)")
        tlines.append("// =============================================================")
        tlines.append(f"module {PROJECT_NAME}_top #(")
        tlines.append(f"    parameter DATA_WIDTH = {DW},")
        tlines.append(f"    parameter FRACTION_SIZE = {hwp['FRACTION_SIZE']},")
        tlines.append(f"    parameter SIGNED = {hwp['SIGNED']},")
        tlines.append(f"    parameter GUARD_TYPE = {hwp['GUARD_TYPE']}")
        tlines.append(f")(")
        tlines.append(f"    input wire clock,")
        tlines.append(f"    input wire sreset_n,")
        tlines.append(f"    input wire [DATA_WIDTH-1:0] data_in,")
        tlines.append(f"    input wire data_valid,")
        tlines.append(f"    output wire [3:0] class_idx,")
        tlines.append(f"    output wire class_valid")
        tlines.append(");")
        tlines.append("")
        tlines.append("    wire reset = ~sreset_n;")
        tlines.append("")

        # Rebuild block wiring in the top file in order (up to NN)
        prev_block_name2 = None
        prev_block2 = None
        for k in keys:
            if k in ("hardware parameters","inputs","outputs","module","NN","maxFinder"):
                continue
            blk = top[k]
            if not isinstance(blk, dict) or "module" not in blk:
                continue
            params = blk.get("parameters", {})
            inputs = blk.get("inputs", {})
            outputs = blk.get("outputs", {})
            mod = blk["module"]

            if mod.lower() == "conv2d":
                out_ch = int(params["OUTPUT_CHANNELS"])
                conv_out_sig = outputs.get("conv_out", {}).get("name", f"{k}_out")
                conv_valid_sig = outputs.get("conv_valid", {}).get("name", f"{k}_valid")
                tlines.append("    // ------------------------------------------------------------")
                tlines.append(f"    // {k}: Conv2D")
                tlines.append("    // ------------------------------------------------------------")
                tlines.append(f"    wire [{out_ch}*DATA_WIDTH-1:0] {conv_out_sig};")
                tlines.append(f"    wire {conv_valid_sig};")
                tlines.append(f"    Conv2D #(")
                for pname, pval in params.items():
                    if pname in ("WEIGHT_FILE","BIAS_FILE"):
                        tlines.append(f"        .{pname}(\"{pval}\"),")
                    else:
                        tlines.append(f"        .{pname}({pval}),")
                tlines[-1] = tlines[-1].rstrip(',')
                tlines.append(f"    ) {k} (")
                tlines.append(f"        .clock(clock),")
                tlines.append(f"        .sreset_n(sreset_n),")
                tlines.append(f"        .data_valid({inputs.get('data_valid',{}).get('name','data_valid')}),")
                tlines.append(f"        .data_in({inputs.get('data_in',{}).get('name','data_in')}),")
                tlines.append(f"        .conv_out({conv_out_sig}),")
                tlines.append(f"        .conv_valid({conv_valid_sig})")
                tlines.append(f"    );")
                tlines.append("")
                prev_block_name2, prev_block2 = k, blk

            elif mod.lower() == "max2d":
                out_ch = int(params["CHANNELS"])
                max_out_sig = outputs.get("maxp_out", {}).get("name", f"{k}_out")
                max_valid_sig = outputs.get("maxp_valid", {}).get("name", f"{k}_valid")
                tlines.append("    // ------------------------------------------------------------")
                tlines.append(f"    // {k}: Max2D")
                tlines.append("    // ------------------------------------------------------------")
                tlines.append(f"    wire [{out_ch}*DATA_WIDTH-1:0] {max_out_sig};")
                tlines.append(f"    wire {max_valid_sig};")
                tlines.append(f"    Max2D #(")
                for pname, pval in params.items():
                    tlines.append(f"        .{pname}({pval}),")
                tlines[-1] = tlines[-1].rstrip(',')
                tlines.append(f"    ) {k} (")
                tlines.append(f"        .clock(clock),")
                tlines.append(f"        .sreset_n(sreset_n),")
                tlines.append(f"        .data_valid({inputs.get('data_valid',{}).get('name','data_valid')}),")
                tlines.append(f"        .data_in({inputs.get('data_in',{}).get('name','data_in')}),")
                tlines.append(f"        .maxp_out({max_out_sig}),")
                tlines.append(f"        .maxp_valid({max_valid_sig})")
                tlines.append(f"    );")
                tlines.append("")
                prev_block_name2, prev_block2 = k, blk

        # determine prev_data and prev_valid for NN
        prev_outputs = prev_block.get("outputs", {})
        # pick first data-like signal and a valid signal
        out_names = [od.get("name", oname) for oname, od in prev_outputs.items()]
        prev_data_sig = None
        prev_valid_sig = None
        for nm in out_names:
            if nm and ("conv_out" in nm or "maxp_out" in nm or "data_out" in nm or "kernel_out" in nm):
                prev_data_sig = nm
                break
        for nm in out_names:
            if nm and ("conv_valid" in nm or "maxp_valid" in nm or "data_valid" in nm or "valid" in nm):
                if nm != prev_data_sig:
                    prev_valid_sig = nm
                    break
        if prev_data_sig is None:
            # fallback to first output
            prev_data_sig = out_names[0]
        if prev_valid_sig is None:
            prev_valid_sig = out_names[1] if len(out_names) > 1 else prev_data_sig + "_valid"

        tlines.append("    // ------------------------------------------------------------")
        tlines.append("    // Neural Network Layers (with IDLE/SEND FSMs between layers)")
        tlines.append("    // ------------------------------------------------------------")
        tlines.append("    localparam IDLE = 1'b0;")
        tlines.append("    localparam SEND = 1'b1;")
        tlines.append("")

        prev_data = prev_data_sig
        prev_valid = prev_valid_sig

        prev_num_neurons = None
        SIGMOID_SIZE = int(hwp.get("SIGMOID_SIZE", 10))
        weightIntWidth = DW - FRAC

        for i, layer in enumerate(layers, start=1):
            NN = int(layer["num_neurons"])
            numWeight = int(layer["num_inputs"])
            act = layer.get("activation", "relu")
            if "input_channels" in layer:
                in_ch = int(layer["input_channels"])
            else:
                if i == 1:
                    in_ch = first_in_ch
                else:
                    in_ch = prev_num_neurons or 1
            prev_num_neurons = NN

            tlines.append(f"    // ------------------------------------------------------------")
            tlines.append(f"    // Layer {i} — {layer.get('name','layer')} ({act.upper()}, {NN} neurons)")
            tlines.append(f"    // ------------------------------------------------------------")
            tlines.append(f"    wire [{NN-1}:0] o{i}_valid;")
            tlines.append(f"    wire [{NN}*DATA_WIDTH-1:0] x{i}_out;")
            tlines.append(f"    reg  [{NN}*DATA_WIDTH-1:0] holdData_{i};")
            tlines.append(f"    reg  [DATA_WIDTH-1:0] out_data_{i};")
            tlines.append(f"    reg  data_out_valid_{i};")
            tlines.append("")
            tlines.append(f"    Layer_{i} #(")
            tlines.append(f"        .NN({NN}),")
            tlines.append(f"        .numWeight({numWeight}),")
            tlines.append(f"        .dataWidth(DATA_WIDTH),")
            tlines.append(f"        .layerNum({i}),")
            tlines.append(f"        .sigmoidSize({SIGMOID_SIZE}),")
            tlines.append(f"        .weightIntWidth({weightIntWidth}),")
            tlines.append(f"        .input_channels({in_ch}),")
            tlines.append(f"        .actType(\"{act}\")")
            tlines.append(f"    ) L{i} (")
            tlines.append(f"        .clk(clock),")
            tlines.append(f"        .rst(reset),")
            tlines.append(f"        .weightValid(weightValid),")
            tlines.append(f"        .biasValid(biasValid),")
            tlines.append(f"        .weightValue(weightValue),")
            tlines.append(f"        .biasValue(biasValue),")
            tlines.append(f"        .config_layer_num(config_layer_num),")
            tlines.append(f"        .config_neuron_num(config_neuron_num),")
            tlines.append(f"        .x_valid({prev_valid}),")
            tlines.append(f"        .x_in({prev_data}),")
            tlines.append(f"        .o_valid(o{i}_valid),")
            tlines.append(f"        .x_out(x{i}_out)")
            tlines.append(f"    );")
            tlines.append("")
            # FSM
            tlines.append(f"    reg state_{i};")
            tlines.append(f"    integer count_{i};")
            tlines.append(f"    always @(posedge clock) begin")
            tlines.append(f"        if (reset) begin")
            tlines.append(f"            state_{i} <= IDLE;")
            tlines.append(f"            count_{i} <= 0;")
            tlines.append(f"            data_out_valid_{i} <= 0;")
            tlines.append(f"        end else begin")
            tlines.append(f"            case (state_{i})")
            tlines.append(f"                IDLE: begin")
            tlines.append(f"                    count_{i} <= 0;")
            tlines.append(f"                    data_out_valid_{i} <= 0;")
            tlines.append(f"                    if (o{i}_valid[0] == 1'b1) begin")
            tlines.append(f"                        holdData_{i} <= x{i}_out;")
            tlines.append(f"                        state_{i} <= SEND;")
            tlines.append(f"                    end")
            tlines.append(f"                end")
            tlines.append(f"                SEND: begin")
            tlines.append(f"                    out_data_{i} <= holdData_{i}[DATA_WIDTH-1:0];")
            tlines.append(f"                    holdData_{i} <= holdData_{i} >> DATA_WIDTH;")
            tlines.append(f"                    count_{i} <= count_{i} + 1;")
            tlines.append(f"                    data_out_valid_{i} <= 1;")
            tlines.append(f"                    if (count_{i} == {NN}) begin")
            tlines.append(f"                        state_{i} <= IDLE;")
            tlines.append(f"                        data_out_valid_{i} <= 0;")
            tlines.append(f"                    end")
            tlines.append(f"                end")
            tlines.append(f"            endcase")
            tlines.append(f"        end")
            tlines.append(f"    end")
            tlines.append("")

            prev_data = f"out_data_{i}"
            prev_valid = f"data_out_valid_{i}"

        # final layer handling + maxFinder
        last_layer = layers[-1]
        last_act = last_layer.get("activation","").lower()
        last_NN = int(last_layer["num_neurons"])
        if last_act in ("softmax","hardmax"):
            tlines.append("    // ------------------------------------------------------------")
            tlines.append("    // Final-layer packed hold + maxFinder")
            tlines.append("    // ------------------------------------------------------------")
            tlines.append(f"    reg [{last_NN}*DATA_WIDTH-1:0] holdData_final;")
            tlines.append(f"    always @(posedge clock) begin")
            tlines.append(f"        if (o{len(layers)}_valid[0] == 1'b1)")
            tlines.append(f"            holdData_final <= x{len(layers)}_out;")
            tlines.append(f"    end")
            tlines.append("")
            if "maxFinder" in top:
                mf = top["maxFinder"]
                mp = mf.get("parameters", {})
                ensure_keys(mp, ["NUM_INPUTS","DATA_WIDTH","SIGNED"], "maxFinder parameters")
                tlines.append(f"    maxFinder #(")
                tlines.append(f"        .NUM_INPUTS({mp['NUM_INPUTS']}),")
                tlines.append(f"        .DATA_WIDTH(DATA_WIDTH),")
                tlines.append(f"        .SIGNED(SIGNED)")
                tlines.append(f"    ) mFind (")
                tlines.append(f"        .i_clk(clock),")
                tlines.append(f"        .i_data(x{len(layers)}_out),")
                tlines.append(f"        .i_valid(o{len(layers)}_valid),")
                tlines.append(f"        .o_data(class_idx),")
                tlines.append(f"        .o_data_valid(class_valid)")
                tlines.append(f"    );")
                resolve_and_copy("maxFinder", RTL_DIR)
            else:
                raise KeyError("maxFinder block missing in top JSON")
        else:
            tlines.append("    // Final layer isn't softmax/hardmax — streamed outputs available at prev_data/prev_valid")
            tlines.append("")

        tlines.append("endmodule")
        (RTL_DIR / f"{PROJECT_NAME}_top.v").write_text("\n".join(tlines))
        vprint(f"✓ Wrote rtl/{PROJECT_NAME}_top.v")

        # ---------------------------------------
        # packaging: clean hw folder and copy files
        # ---------------------------------------
        if HW_DIR.exists():
            shutil.rmtree(HW_DIR)
        HW_DIR.mkdir(parents=True, exist_ok=True)

        # copy all .v into hw
        for vfile in RTL_DIR.glob("*.v"):
            shutil.copy2(vfile, HW_DIR / vfile.name)
        # copy dependency .v too
        for dv in RTL_DIR.glob("*.v"):
            # already copied; kept for compatibility if dependencies were stored elsewhere
            pass

        # copy all .mif from Memory_Files/mif
        mif_dir = self.memory_root / "mif"
        if mif_dir.exists():
            for m in mif_dir.glob("*.mif"):
                shutil.copy2(m, HW_DIR / m.name)

        vprint(f"📦 HW folder packaged: {HW_DIR.resolve()}")
