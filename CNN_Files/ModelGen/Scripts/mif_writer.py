# mif_writer.py
"""
MIF Writer Utility (Final Stable Version)
-----------------------------------------
Generates .mif (binary) and .csv (float) files for Conv2D and Dense (neuron)
layers, and optionally saves a Memory_Index.json describing all files.

Features:
---------
• Writes binary data in .mif (ready for $readmemb).
• Cleans previous output folder automatically.
• Uses default output folder 'Memory_Files' if none provided.
• Optionally saves a JSON index file when save_index=True.
• Returns nothing (pure side-effect operation).
"""

import shutil
import json
import numpy as np
from pathlib import Path


# ------------------ Fixed-Point Conversion ------------------ #
def quantize_to_fixed(value, fraction_bits, data_width, signed=True):
    """Convert float → fixed-point integer (two’s complement)."""
    scaled = value * (2 ** fraction_bits)
    q = int(round(scaled))

    if signed:
        max_val = 2 ** (data_width - 1) - 1
        min_val = -(2 ** (data_width - 1))
        q = max(min(q, max_val), min_val)
        if q < 0:
            q = (1 << data_width) + q  # two's complement
    else:
        max_val = 2 ** data_width - 1
        q = max(min(q, max_val), 0)

    return q


def int_to_bin(value, data_width):
    """Convert integer to zero-padded binary string."""
    return format(value, f"0{data_width}b")


def write_list(filepath, values, data_width, fmt="mif"):
    """Write values to file (.mif for binary, .csv for floats)."""
    Path(filepath).parent.mkdir(exist_ok=True, parents=True)
    with open(filepath, "w") as f:
        if fmt == "mif":
            for val in values:
                f.write(int_to_bin(val, data_width) + "\n")
        elif fmt == "csv":
            for val in values:
                f.write(f"{val}\n")


# ------------------ Conv2D Export ------------------ #
def generate_conv_mif_files(weights, biases, conv_block_num, data_width, fraction_bits, signed, base_dir):
    """Generate .mif/.csv files for a Conv2D layer."""
    w = np.array(weights)
    b = np.array(biases)
    k_h, k_w, in_ch, out_ch = w.shape
    ordered_values = []

    # Order: OC major → IC → kernel (kernel position fastest)
    for oc in range(out_ch):
        for ic in range(in_ch):
            for kh in range(k_h):
                for kw in range(k_w):
                    ordered_values.append(float(w[kh, kw, ic, oc]))

    q_weights = [quantize_to_fixed(v, fraction_bits, data_width, signed) for v in ordered_values]
    q_biases = [quantize_to_fixed(float(x), fraction_bits, data_width, signed) for x in b]

    mif_dir = Path(base_dir) / "mif"
    csv_dir = Path(base_dir) / "csv"

    # File paths
    w_mif = mif_dir / f"c_{conv_block_num}_w.mif"
    b_mif = mif_dir / f"c_{conv_block_num}_b.mif"
    w_csv = csv_dir / f"c_{conv_block_num}_w.csv"
    b_csv = csv_dir / f"c_{conv_block_num}_b.csv"

    write_list(w_mif, q_weights, data_width, fmt="mif")
    write_list(b_mif, q_biases, data_width, fmt="mif")
    write_list(w_csv, ordered_values, data_width, fmt="csv")
    write_list(b_csv, b.tolist(), data_width, fmt="csv")

    print(f"✅ Conv block {conv_block_num}: {len(q_weights)} weights, {len(q_biases)} biases")

    return {
        "conv_block": conv_block_num,
        "weights_mif": str(w_mif),
        "biases_mif": str(b_mif),
        "weights_csv": str(w_csv),
        "biases_csv": str(b_csv)
    }


# ------------------ Dense Export (Per Neuron) ------------------ #
def generate_dense_mif_files(weights, biases, layer_number, data_width, fraction_bits, signed, base_dir):
    """Generate per-neuron .mif/.csv files for one Dense layer."""
    w = np.array(weights)
    b = np.array(biases)
    in_dim, out_dim = w.shape

    mif_dir = Path(base_dir) / "mif"
    csv_dir = Path(base_dir) / "csv"

    neuron_files = []
    for neuron in range(out_dim):
        weights_list = [float(w[inp, neuron]) for inp in range(in_dim)]
        bias_val = float(b[neuron])

        q_weights = [quantize_to_fixed(v, fraction_bits, data_width, signed) for v in weights_list]
        q_bias = quantize_to_fixed(bias_val, fraction_bits, data_width, signed)

        # File paths
        w_mif = mif_dir / f"w_{layer_number}_{neuron}.mif"
        b_mif = mif_dir / f"b_{layer_number}_{neuron}.mif"
        w_csv = csv_dir / f"w_{layer_number}_{neuron}.csv"
        b_csv = csv_dir / f"b_{layer_number}_{neuron}.csv"

        write_list(w_mif, q_weights, data_width, fmt="mif")
        write_list(b_mif, [q_bias], data_width, fmt="mif")
        write_list(w_csv, weights_list, data_width, fmt="csv")
        write_list(b_csv, [bias_val], data_width, fmt="csv")

        neuron_files.append({
            "neuron": neuron,
            "weights_mif": str(w_mif),
            "bias_mif": str(b_mif),
            "weights_csv": str(w_csv),
            "bias_csv": str(b_csv)
        })

        print(f"✅ Neuron {neuron} in layer {layer_number}: "
              f"{len(weights_list)} weights, 1 bias")

    return {"layer": layer_number, "neurons": neuron_files}


# ------------------ Master Export ------------------ #
def export_mifs_from_keras(model_path,
                           data_width=16,
                           fraction_bits=14,
                           signed=True,
                           base_dir=None,
                           save_index=True):
    """
    Generates .mif (binary) and .csv (float) files for Conv2D and Dense layers.
    Cleans output folder each run. Optionally saves Memory_Index.json.
    Returns nothing.
    """
    import tensorflow as tf
    model = tf.keras.models.load_model(model_path, compile=False)

    # Default folder
    if base_dir is None:
        base_dir = "Memory_Files"

    base_dir = Path(base_dir)

    # Clean existing folder
    if base_dir.exists():
        shutil.rmtree(base_dir)
        print(f"🧹 Removed existing folder: {base_dir}")

    (base_dir / "mif").mkdir(parents=True, exist_ok=True)
    (base_dir / "csv").mkdir(parents=True, exist_ok=True)

    conv_block_num = 1
    nn_layer_num = 1
    generated = {"conv_blocks": [], "nn_layers": []}

    # Generate MIFs
    for layer in model.layers:
        ltype = layer.__class__.__name__

        if ltype == "Conv2D":
            w, b = layer.get_weights()
            files = generate_conv_mif_files(w, b, conv_block_num, data_width, fraction_bits, signed, base_dir)
            generated["conv_blocks"].append(files)
            conv_block_num += 1

        elif ltype == "Dense":
            w, b = layer.get_weights()
            files = generate_dense_mif_files(w, b, nn_layer_num, data_width, fraction_bits, signed, base_dir)
            generated["nn_layers"].append(files)
            nn_layer_num += 1

        else:
            continue

    # Optional JSON index
    if save_index:
        index_path = base_dir / "Memory_Index.json"
        with open(index_path, "w") as f:
            json.dump(generated, f, indent=2)
        print(f"🗂️  Saved index file: {index_path}")

    print(f"\n📁 All files generated under: {base_dir.resolve()}")
    # No return value (intentional)
    return


if __name__ == "__main__":
    export_mifs_from_keras(
    model_path="model.keras",
    data_width=16,
    fraction_bits=14,
    signed=True,
    save_index=True   # set False to skip Memory_Index.json
)