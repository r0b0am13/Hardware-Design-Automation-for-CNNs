import tensorflow as tf
import json
import numpy as np
import os

# Suppress TensorFlow logging for a cleaner output
os.environ['TF_CPP_MIN_LOG_LEVEL'] = '2'

def export_model_to_json(model, filename="model_structure.json"):
    """
    Exports a TensorFlow/Keras model to a structured JSON file.
    It separates the model's architecture (config) from its parameters (weights).
    It now includes the output shape for every layer.
    """
    config = {"layers": []}
    weights_data = {}

    # --- Handle the Input Shape from the model itself ---
    try:
        # Get shape without the batch size (which can be None)
        input_shape = list(model.input_shape[1:])
    except AttributeError:
        print("Warning: Could not determine model.input_shape. Falling back to first layer's input.")
        input_shape = list(model.layers[0].get_input_at(0).shape[1:])

    config["layers"].append({
        "type": "Input",
        "name": "input_0",
        "shape": input_shape,
    })

    # Process all layers in the provided model
    for i, layer in enumerate(model.layers):
        layer_class_name = layer.__class__.__name__
        layer_name = f"{layer.name}_{i}"
        
        # A more robust way to get output shape, removing the None batch dimension
        output_shape = list(layer.output.shape[1:])

        layer_config = {"name": layer_name, "type": layer_class_name, "output_shape": output_shape}
        
        # --- Layer-specific configuration ---
        if isinstance(layer, tf.keras.layers.Conv2D):
            if layer.get_weights(): # Ensure layer has weights
                layer_weights, layer_biases = layer.get_weights()
                layer_config.update({
                    "filters": layer.filters,
                    "kernel_size": layer.kernel_size,
                    "strides": layer.strides,
                    "padding": layer.padding,
                    "activation": tf.keras.activations.serialize(layer.activation)
                })
                weights_data[layer_name] = {
                    "weights": layer_weights.tolist(),
                    "biases": layer_biases.tolist()
                }
        elif isinstance(layer, (tf.keras.layers.MaxPooling2D, tf.keras.layers.AveragePooling2D)):
            layer_config.update({
                "pool_size": layer.pool_size,
                "strides": layer.strides,
                "padding": layer.padding
            })
        elif isinstance(layer, tf.keras.layers.Flatten):
            # Flatten layer now correctly reports its output shape
            pass
        elif isinstance(layer, tf.keras.layers.Dense):
            if layer.get_weights(): # Ensure layer has weights
                layer_weights, layer_biases = layer.get_weights()
                layer_config.update({
                    "neurons": layer.units,
                    "activation": tf.keras.activations.serialize(layer.activation)
                })
                weights_data[layer_name] = {
                    "weights": layer_weights.tolist(),
                    "biases": layer_biases.tolist()
                }
        else:
            layer_config["details"] = "Layer type not fully supported for detailed view."

        config["layers"].append(layer_config)

    final_model_data = {"config": config, "weights": weights_data}

    with open(filename, "w") as f:
        json.dump(final_model_data, f, indent=4)

    print(f"Model structure successfully saved to {filename}")

# --- Main execution block ---
if __name__ == '__main__':
    # --- USER CONFIGURATION ---
    # <<< PLEASE CHANGE THIS PATH to your model file (.h5 or .keras) >>>
    MODEL_PATH = "model.keras"
    OUTPUT_FILENAME = "model_structure.json"
    # --- END OF USER CONFIGURATION ---

    if not os.path.exists(MODEL_PATH):
        print(f"Error: Model file not found at '{MODEL_PATH}'")
        print("Please update the 'MODEL_PATH' variable in the script.")
        exit(1)

    print(f"Loading model from '{MODEL_PATH}'...")
    try:
        # Load the model. For some models, compiling might be needed to build them fully.
        model = tf.keras.models.load_model(MODEL_PATH, compile=False)
        model.summary()

        print(f"\nExporting model structure to '{OUTPUT_FILENAME}'...")
        export_model_to_json(model, filename=OUTPUT_FILENAME)

    except Exception as e:
        print(f"\nAn error occurred while loading or processing the model: {e}")
        exit(1)