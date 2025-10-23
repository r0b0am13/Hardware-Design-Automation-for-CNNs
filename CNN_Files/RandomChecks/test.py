import tensorflow as tf
import networkx as nx
import matplotlib.pyplot as plt

# ====== Load or build your model ======
from tensorflow import keras

model = keras.models.Sequential([
    keras.Input(shape=(28, 28, 1)),
    keras.layers.Conv2D(1, (3, 3), activation='relu', padding='valid'),
    keras.layers.MaxPooling2D(pool_size=(2, 2), strides=2, padding='valid'),
    keras.layers.Flatten(),
    keras.layers.Dense(64, activation='relu'),
    keras.layers.Dense(32, activation='relu'),
    keras.layers.Dense(10, activation='softmax')
])

# OPTIONAL: Load weights if you trained the model
model.load_weights("model.keras")

# ====== Select layers to visualize ======
# You can list Dense layer *indexes* (0 = first Dense, 1 = second Dense, etc.)
# For example: [0] = only first Dense, [0, 1] = first and second Dense, etc.
layers_to_visualize = [0]  # 👈 change this list to pick layers

# ====== Extract chosen Dense layers ======
all_dense_layers = [layer for layer in model.layers if isinstance(layer, tf.keras.layers.Dense)]
chosen_layers = [all_dense_layers[i] for i in layers_to_visualize]

# ====== Build the neuron graph ======
G = nx.DiGraph()
pos = {}
layer_nodes = []
x_spacing = 6

for li, layer in enumerate(chosen_layers):
    W, B = layer.get_weights()
    input_count, output_count = W.shape
    curr_nodes = []

    # Create neuron nodes for this layer
    for j in range(output_count):
        node_id = f"L{li}_N{j}"
        G.add_node(node_id, bias=B[j])
        curr_nodes.append(node_id)
        pos[node_id] = (li * x_spacing, -j * 2)

    # First selected layer → treat inputs as "Flatten output"
    if li == 0:
        prev_nodes = [f"Input_{i}" for i in range(input_count)]
        for i, node in enumerate(prev_nodes):
            G.add_node(node, bias=None)
            pos[node] = ((li - 1) * x_spacing, -i * 2)
    else:
        prev_nodes = layer_nodes[-1]

    # Add edges with weights
    for i, prev_node in enumerate(prev_nodes):
        for j, curr_node in enumerate(curr_nodes):
            weight_val = W[i, j]
            G.add_edge(prev_node, curr_node, weight=f"{weight_val:.2f}")

    layer_nodes.append(curr_nodes)

# ====== Draw the graph ======
plt.figure(figsize=(20, 12))
nx.draw(
    G,
    pos,
    with_labels=False,
    node_color='lightblue',
    node_size=800,
    arrows=False
)

# Draw weights on edges
edge_labels = nx.get_edge_attributes(G, 'weight')
nx.draw_networkx_edge_labels(G, pos, edge_labels=edge_labels, font_size=5, label_pos=0.5)

# Show biases near neurons
for node, data in G.nodes(data=True):
    if data['bias'] is not None:
        x, y = pos[node]
        plt.text(x + 0.4, y, f"b={data['bias']:.2f}", fontsize=5, color='red')

plt.title("Neuron-level Visualization of Selected Dense Layers", fontsize=14)
plt.axis("off")
plt.tight_layout()
plt.show()