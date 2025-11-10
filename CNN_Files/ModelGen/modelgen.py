import tensorflow as tf
import json
import os
import sys

MODEL_PATH = "model.keras"
OUT_PATH = "hardware_model.json"

# ========== Hardware Support Specification ==========
SUPPORTED_LAYERS = {
    "Conv2D": {
        "supported": ["filters", "kernel_size", "strides", "input_shape", "input_channels", "activation"],
        "valid_activations": ["relu", None]
    },
    "MaxPooling2D": {
        "supported": ["pool_size", "strides", "input_shape"]
    },
    "Dense": {
        "supported": ["units", "activation"],
        "valid_activations": ["relu", "sigmoid", "softmax"]
    },
    "Flatten": {
        "supported": []
    }
}
# =====================================================

def check_conv2d(layer, cfg):
    errors = []
    if cfg.get("padding", "valid") != "valid":
        errors.append(f"Conv2D '{layer.name}' uses padding='{cfg['padding']}' — not supported.")
    act = cfg.get("activation", None)
    if act not in SUPPORTED_LAYERS["Conv2D"]["valid_activations"]:
        errors.append(f"Conv2D '{layer.name}' uses activation='{act}' — only relu or None supported.")
    return errors

def check_maxpool(layer, cfg):
    errors = []
    if cfg.get("padding", "valid") != "valid":
        errors.append(f"MaxPool '{layer.name}' uses padding='{cfg['padding']}' — not supported.")
    return errors

def check_dense(layer, cfg):
    errors = []
    act = cfg.get("activation", None)
    if act and act not in SUPPORTED_LAYERS["Dense"]["valid_activations"]:
        errors.append(f"Dense '{layer.name}' uses activation='{act}' — only relu, sigmoid, softmax supported.")
    return errors

def extract_layer(layer, model_input_shape=None):
    """Extract relevant info for supported layers"""
    ltype = layer.__class__.__name__
    cfg = layer.get_config()
    layer_data = {"name": layer.name, "type": ltype}

    # Try to extract shapes robustly
    try:
        layer_data["input_shape"] = layer.input_shape
    except Exception:
        try:
            layer_data["input_shape"] = layer.input.get_shape().as_list()
        except Exception:
            layer_data["input_shape"] = None

    try:
        layer_data["output_shape"] = layer.output_shape
    except Exception:
        try:
            layer_data["output_shape"] = layer.output.get_shape().as_list()
        except Exception:
            layer_data["output_shape"] = None

    # Add supported parameters
    supported_params = SUPPORTED_LAYERS.get(ltype, {}).get("supported", [])
    for key in supported_params:
        if key in cfg:
            layer_data[key] = cfg[key]

    # ---- Added: derive input_channels more reliably ----
    if ltype == "Conv2D":
        in_ch = None
        # Try from layer
        try:
            in_ch = layer.input_shape[-1]
        except Exception:
            pass
        # Try from symbolic tensor
        if in_ch is None:
            try:
                in_ch = layer.input.get_shape().as_list()[-1]
            except Exception:
                pass
        # Try from model input (for first layer)
        if in_ch is None and model_input_shape is not None:
            in_ch = model_input_shape[-1]
        layer_data["input_channels"] = int(in_ch) if in_ch is not None else "unknown"
    # ----------------------------------------------------

    return layer_data


def main():
    print("🔍 Loading model...")
    try:
        model = tf.keras.models.load_model(MODEL_PATH, compile=False)
    except Exception as e:
        print(f"❌ Failed to load model: {e}")
        sys.exit(1)

    hardware_layers = []
    all_errors = []

    print("✅ Model loaded. Checking layer compatibility...\n")

    for layer in model.layers:
        ltype = layer.__class__.__name__
        cfg = layer.get_config()

        if ltype not in SUPPORTED_LAYERS:
            all_errors.append(f"Layer '{layer.name}' of type '{ltype}' is not supported in hardware.")
            continue

        # Check layer-specific rules
        if ltype == "Conv2D":
            all_errors.extend(check_conv2d(layer, cfg))
        elif ltype == "MaxPooling2D":
            all_errors.extend(check_maxpool(layer, cfg))
        elif ltype == "Dense":
            all_errors.extend(check_dense(layer, cfg))

        # Build clean layer info
        hardware_layers.append(extract_layer(layer))

    # Print any issues
    if all_errors:
        print("⚠️  Compatibility issues found:\n")
        for err in all_errors:
            print("  -", err)
        print("\n❌ Hardware export aborted due to unsupported features.")
        sys.exit(1)
    else:
        print("✅ All layers compatible with hardware.\n")

    # Save JSON
    hw_model = {"model_name": model.name, "layers": hardware_layers}
    with open(OUT_PATH, "w") as f:
        json.dump(hw_model, f, indent=2)

    print(f"💾 Hardware model configuration saved to '{OUT_PATH}'")

if __name__ == "__main__":
    main()
