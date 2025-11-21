
weights_file = "conv2d.csv"
biases_file  = "conv2d_bias.csv"
output_file  = "ConvWeightBiasModule.v"
module_name  = "ConvWeightBiasModule"

KERNEL_SIZE = 3        # adjust as needed
DATA_WIDTH  = 16
FRAC_BITS   = 14
SIGNED      = True

def float_to_q(value):
    """Convert float to signed Q2.14 integer."""
    scaled = int(round(float(value) * (1 << FRAC_BITS)))
    max_val = (1 << (DATA_WIDTH - 1)) - 1
    min_val = -(1 << (DATA_WIDTH - 1))
    if scaled > max_val: scaled = max_val
    elif scaled < min_val: scaled = (1 << DATA_WIDTH) + scaled  # 2's complement
    return scaled & ((1 << DATA_WIDTH) - 1)

# Read data
def read_values(filename):
    with open(filename, "r") as f:
        return [float(line.strip()) for line in f if line.strip()]

weights = read_values(weights_file)
biases  = read_values(biases_file)

if len(biases) != 1:
    print("⚠️ Note: Only first bias value will be used for single Bias output.")

bias_val = biases[0]

# Generate Verilog
with open(output_file, "w") as f:
    f.write("`timescale 1ns / 1ps\n\n")
    f.write(f"module {module_name} #(\n")
    f.write(f"    parameter KERNEL_SIZE = {KERNEL_SIZE},\n")
    f.write(f"    parameter DATA_WIDTH  = {DATA_WIDTH}\n")
    f.write("    )(\n")
    f.write("    output wire [DATA_WIDTH*KERNEL_SIZE*KERNEL_SIZE-1:0] Weights,\n")
    f.write("    output wire [DATA_WIDTH-1:0] Bias\n")
    f.write("    );\n\n")

    f.write(f"    wire [DATA_WIDTH-1:0] WeightsP [0:KERNEL_SIZE*KERNEL_SIZE-1];\n\n")

    # Bias
    q_bias = float_to_q(bias_val)
    f.write(f"    assign Bias = {DATA_WIDTH}'b{q_bias:0{DATA_WIDTH}b}; // {bias_val}\n\n")

    # Weights
    f.write("    // Weights assignments (Q2.16)\n")
    for i, val in enumerate(weights):
        q_val = float_to_q(val)
        f.write(f"    assign WeightsP[{i}] = {DATA_WIDTH}'b{q_val:0{DATA_WIDTH}b}; // {val}\n")

    # Generate block (preserve your logic)
    f.write("\n    genvar i;\n")
    f.write("    generate\n")
    f.write("        for(i = 0; i < KERNEL_SIZE*KERNEL_SIZE; i = i + 1) begin\n")
    f.write("            assign Weights[(i+1)*DATA_WIDTH-1 : i*DATA_WIDTH] = WeightsP[KERNEL_SIZE*KERNEL_SIZE-1-i];\n")
    f.write("        end\n")
    f.write("    endgenerate\n\n")
    f.write("endmodule\n")

print(f"✅ Generated {output_file} with {len(weights)} weights and 1 bias in Q2.16 format.")
