# Function to convert 16-bit binary to fixed-point (signed, 14-bit fraction)
def binary_to_fixed_point(binary_str):
    # Convert to signed integer (16-bit)
    value = int(binary_str, 2)
    if value >= 2**15:  # Check if negative (MSB is 1)
        value -= 2**16  # Convert to signed representation

    # Convert to fixed point with 14-bit fractional part
    fixed_point_value = value / (2**14)
    return fixed_point_value

# File paths
input_file = "Output.txt"  # Change this to your actual file path
conv_output_file = "Sorted_Convolution_Output.txt"
maxpool_output_file = "Sorted_MaxPool_Output.txt"

# Lists for storing convolution and maxpool outputs
conv_data = []
maxpool_data = []

# Read and process the file
with open(input_file, "r") as file:
    for line in file:
        parts = line.strip().split(" | ")
        time_stamp = int(parts[0].split(": ")[1])
        binary_value = parts[1].split(": ")[1]

        # Convert to fixed point
        fixed_point_value = binary_to_fixed_point(binary_value)

        # Categorize based on type
        if "Convolution Output" in parts[1]:
            conv_data.append((time_stamp, fixed_point_value))
        elif "MaxPool Output" in parts[1]:
            maxpool_data.append((time_stamp, fixed_point_value))

# Sort data based on timestamp
sorted_conv_data = sorted(conv_data, key=lambda x: x[0])  # Sort by timestamp
sorted_maxpool_data = sorted(maxpool_data, key=lambda x: x[0])  # Sort by timestamp

# Save sorted convolution output
with open(conv_output_file, "w") as f:
    for time_stamp, value in sorted_conv_data:
        f.write(f"Time: {time_stamp} | Fixed Point Output: {value:.6f}\n")

# Save sorted maxpool output
with open(maxpool_output_file, "w") as f:
    for time_stamp, value in sorted_maxpool_data:
        f.write(f"Time: {time_stamp} | Fixed Point Output: {value:.6f}\n")

print(f"Sorted data saved:\n- {conv_output_file}\n- {maxpool_output_file}")
