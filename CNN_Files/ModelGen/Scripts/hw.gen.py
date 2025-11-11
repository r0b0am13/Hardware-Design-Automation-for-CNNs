# stage2_hw_gen.py
"""
Stage 2: software_model.json → hardware_model.json
--------------------------------------------------
Generates hardware-level JSON from software description JSON.

✓ Separate counters for Conv / Pool / NN layers
✓ Conv MIF names match 'Memory_Files/mif' convention
✓ Neural network section includes full layer information
✓ NN file structure consistent with per-neuron MIF generation
"""

import json
from pathlib import Path


# --------------------------- CONFIG --------------------------- #

GLOBAL_DEFAULTS = {
    "DATA_WIDTH": 16,
    "FRACTION_SIZE": 14,
    "SIGNED": 1,
    "GUARD_TYPE": 2
}


# --------------------------- BLOCK BUILDERS --------------------------- #

def make_imgbuf_block(name, layer, prev_out, stride, channels, kernel_size):
    """Create ImageBufferChnl block JSON."""
    return {
        name: {
            "module": "ImageBufferChnl",
            "parameters": {
                "KERNEL_SIZE": kernel_size,
                "DATA_WIDTH": "DATA_WIDTH",
                "COLUMN_NUM": layer["input_shape"][0],
                "ROW_NUM": layer["input_shape"][1],
                "STRIDE": stride,
                "CHANNELS": channels
            },
            "inputs": {
                "clock": {"name": "clock", "width": 1},
                "sreset_n": {"name": "sreset_n", "width": 1},
                "data_valid": {"name": "data_valid" if prev_out == "data_in" else f"{prev_out}_valid", "width": 1},
                "data_in": {"name": prev_out, "width": "DATA_WIDTH"}
            },
            "outputs": {
                "data_out": {"name": f"{name}_out", "width": "DATA_WIDTH"},
                "kernel_out": {"name": f"kernel_out_{name}", "width": f"DATA_WIDTH * {kernel_size} * {kernel_size}"},
                "kernel_valid": {"name": f"kernel_valid_{name}", "width": 1}
            }
        }
    }


def make_conv_block(name, layer, ibuf_name, conv_block_num):
    """Create ConvChnl block JSON with correct MIF filenames."""
    k = layer["kernel_size"]
    return {
        name: {
            "module": "ConvChnl",
            "parameters": {
                "KERNEL_SIZE": k,
                "CHANNELS": layer["input_channels"],
                "DATA_WIDTH": "DATA_WIDTH",
                "FRACTION_SIZE": "FRACTION_SIZE",
                "SIGNED": "SIGNED",
                "ACTIVATION": layer.get("activation", "none"),
                "GUARD_TYPE": "GUARD_TYPE"
            },
            "files": {
                "weights_file": f"c_{conv_block_num}_w.mif",
                "biases_file": f"c_{conv_block_num}_b.mif"
            },
            "inputs": {
                "clock": {"name": "clock", "width": 1},
                "sreset_n": {"name": "sreset_n", "width": 1},
                "data_valid": {"name": f"kernel_valid_{ibuf_name}", "width": 1},
                "kernel_in": {"name": f"kernel_out_{ibuf_name}", "width": f"DATA_WIDTH * {k} * {k}"}
            },
            "outputs": {
                "conv_out": {"name": f"{name}_out", "width": "DATA_WIDTH"},
                "conv_valid": {"name": f"{name}_valid", "width": 1}
            }
        }
    }


def make_maxpool_block(name, layer, ibuf_name):
    """Create MaxpoolChnl block JSON."""
    k = layer["pool_size"]
    return {
        name: {
            "module": "MaxpoolChnl",
            "parameters": {
                "KERNEL_SIZE": k,
                "DATA_WIDTH": "DATA_WIDTH",
                "SIGNED": "SIGNED",
                "CHANNELS": layer["input_channels"]
            },
            "inputs": {
                "clock": {"name": "clock", "width": 1},
                "sreset_n": {"name": "sreset_n", "width": 1},
                "data_valid": {"name": f"kernel_valid_{ibuf_name}", "width": 1},
                "kernel_in": {"name": f"kernel_out_{ibuf_name}", "width": f"DATA_WIDTH * {k} * {k}"}
            },
            "outputs": {
                "maxp_out": {"name": f"{name}_out", "width": "DATA_WIDTH"},
                "maxp_valid": {"name": f"{name}_valid", "width": 1}
            }
        }
    }


def make_maxfinder_block(prev_out_signal, num_outputs):
    """Create maxFinder block as final classifier stage."""
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


def build_nn_block(prev_out_signal, dense_layers):
    """
    Build NN structure describing Dense layers.
    File naming remains consistent with neuron-per-MIF generation.
    """
    nn_layers = []
    for i, layer in enumerate(dense_layers, start=1):
        entry = {
            "name": f"dense_L{i}",
            "num_inputs": layer["input_shape"][0],
            "num_neurons": layer["units"],
            "activation": layer.get("activation", "none"),
            # NOTE: MIF file naming convention placeholders
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


# --------------------------- MAIN CONVERSION --------------------------- #

def generate_hardware_json(input_file="software_model.json", output_file="hardware_model.json"):
    """Main Stage 2 entry point."""
    print(f"📄 Reading {input_file} ...")
    with open(input_file, "r") as f:
        model = json.load(f)

    layers = model["layers"]
    globals_ = GLOBAL_DEFAULTS.copy()

    top = {
        "module": "CNN",
        "hardware parameters": globals_,
        "inputs": {
            "clock": 1,
            "sreset_n": 1,
            "data_in": "DATA_WIDTH",
            "data_valid": 1
        },
        "outputs": {
            "class_idx": "log2(NUM_INPUTS)",
            "class_valid": 1
        }
    }

    # Independent counters
    conv_idx = 1
    pool_idx = 1
    dense_layers = []
    prev_out = "data_in"

    for layer in layers:
        ltype = layer["type"]

        if ltype == "Conv2D":
            ibuf_name = f"ImageBuffer_Conv{conv_idx}"
            conv_name = f"Conv{conv_idx}"

            top.update(make_imgbuf_block(
                ibuf_name, layer, prev_out,
                stride=layer["stride"],
                channels=layer["input_channels"],
                kernel_size=layer["kernel_size"]
            ))
            top.update(make_conv_block(conv_name, layer, ibuf_name, conv_idx))

            prev_out = f"{conv_name}_out"
            conv_idx += 1

        elif ltype == "MaxPooling2D":
            ibuf_name = f"ImageBuffer_Maxpool{pool_idx}"
            pool_name = f"Maxpool{pool_idx}"

            top.update(make_imgbuf_block(
                ibuf_name, layer, prev_out,
                stride=layer["stride"],
                channels=layer["input_channels"],
                kernel_size=layer["pool_size"]
            ))
            top.update(make_maxpool_block(pool_name, layer, ibuf_name))

            prev_out = f"{pool_name}_out"
            pool_idx += 1

        elif ltype == "Flatten":
            continue

        elif ltype == "Dense":
            dense_layers.append(layer)

    # Add NN and MaxFinder
    if dense_layers:
        top["NN"] = build_nn_block(prev_out, dense_layers)
        last_layer = dense_layers[-1]
        num_outputs = last_layer["units"]
        top.update(make_maxfinder_block("nn_out", num_outputs))
    else:
        top["outputs"] = {
            "data_out": prev_out,
            "data_valid": f"{prev_out}_valid"
        }

    final_json = {"Hardware_model": {"top": top}}

    Path(output_file).write_text(json.dumps(final_json, indent=2))
    print(f"✅ Hardware model written to {output_file}")

if __name__ == "__main__":
    generate_hardware_json("software_model.json", "hardware_model.json")