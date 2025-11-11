# stage1_sw_gen.py
"""
Stage 1: TensorFlow/Keras model → software_model.json
---------------------------------
Generates a hardware-friendly JSON description of the network.
"""


# ---------------- CONFIG ---------------- #
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

# ---------------- UTILITY FUNCTIONS ---------------- #

def _shape_to_list(shape):
    """Converts TensorShape/tuple to a clean Python list."""
    if shape is None:
        return None
    return [int(s) if s is not None else None for s in shape]

def _scalarize(param):
    """Convert tuple/list params like (3,3) -> 3 (requires square kernels)."""
    if isinstance(param, (list, tuple)):
        if len(set(param)) == 1:
            return param[0]
        raise ValueError(f"⚠️ Only square kernels supported, got {param}")
    return param

def _infer_layer_shapes(model):
    """Run dummy inference to infer input/output tensor shapes per layer."""
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
    """Extracts simplified hardware-useful info per layer."""
    ltype = layer.__class__.__name__
    cfg = layer.get_config()
    data = {"name": layer.name, "type": ltype}

    # ---------------- Shapes ---------------- #
    if len(in_shape) == 4:
        _, in_h, in_w, in_c = in_shape
        data["input_shape"] = [in_h, in_w]
        data["input_channels"] = in_c
    elif len(in_shape) == 2:
        _, n = in_shape
        data["input_shape"] = [n]
        data["input_channels"] = 1

    if len(out_shape) == 4:
        _, out_h, out_w, out_c = out_shape
        data["output_shape"] = [out_h, out_w]
        data["output_channels"] = out_c
    elif len(out_shape) == 2:
        _, n = out_shape
        data["output_shape"] = [n]
        data["output_channels"] = n

    # ---------------- Parameters ---------------- #
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

    # ---------------- Activation ---------------- #
    act = cfg.get("activation", None)
    valid_acts = SUPPORTED_LAYERS.get(ltype, {}).get("valid_activations", [])
    if act and act not in valid_acts:
        raise ValueError(f"Unsupported activation '{act}' for layer {layer.name}")
    if act:
        data["activation"] = act

    return data

# ---------------- MAIN FUNCTION ---------------- #

def generate_software_json(model_path, out_path="software_model.json"):
    """Generates the software_model.json from a Keras model file."""
    print(f"📥 Loading Keras model: {model_path}")
    model = tf.keras.models.load_model(model_path, compile=False)

    print(f"⚙️ Inferring layer shapes...")
    layer_shapes = _infer_layer_shapes(model)

    print(f"🧩 Extracting layer configurations...")
    layers_out = []
    for layer, (in_s, out_s) in zip(model.layers, layer_shapes):
        ltype = layer.__class__.__name__
        if ltype not in SUPPORTED_LAYERS:
            print(f"⚠️ Skipping unsupported layer type: {ltype}")
            continue
        info = _extract_layer_info(layer, in_s, out_s)
        layers_out.append(info)

    out_json = {
        "model_name": model.name,
        "layers": layers_out
    }

    Path(out_path).write_text(json.dumps(out_json, indent=2))
    print(f"✅ Software model JSON written to {out_path}")
    return out_json

# ---------------- Example Run ---------------- #
if __name__ == "__main__":
    generate_software_json("model1.keras", "software_model.json")
