def q2_14_to_float(binary_str):
    """Convert 16-bit signed Q2.14 binary string to float."""
    # Parse as signed integer
    val = int(binary_str, 2)
    if val & (1 << 15):  # If sign bit set
        val -= 1 << 16   # Convert to negative (2's complement)
    return val / (1 << 14)

# Read from file
input_file_conv = "conv_outputs_b.txt"
output_file_conv = "conv_outputs_hw.txt"
input_file_max = "maxpool_outputs_b.txt"
output_file_max = "maxp_outputs_hw.txt"

with open(input_file_conv, "r") as infile, open(output_file_conv, "w") as outfile:
    for line in infile:
        binary_str = line.strip()
        if not binary_str:
            continue
        float_val = q2_14_to_float(binary_str)
        outfile.write(f"{float_val:.8f}\n")
        
print(f"Conversion complete. Output saved to '{output_file_conv}'.")        
        
with open(input_file_max, "r") as infile, open(output_file_max, "w") as outfile:
    for line in infile:
        binary_str = line.strip()
        if not binary_str:
            continue
        float_val = q2_14_to_float(binary_str)
        outfile.write(f"{float_val:.8f}\n")

print(f"Conversion complete. Output saved to '{output_file_max}'.")