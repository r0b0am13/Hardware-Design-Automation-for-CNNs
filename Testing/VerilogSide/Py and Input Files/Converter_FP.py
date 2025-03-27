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
input_file = "Raw_Terminal_Output.txt"  # Change this to your actual file path
conv_output_file = "FP_Convolution.txt"
maxpool_output_file = "FP_Maxpool.txt"

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
        print(fixed_point_value)

        # Categorize based on type
        if "Convolution Output" in parts[1]:
            conv_data.append((time_stamp, fixed_point_value))
        elif "MaxPool Output" in parts[1]:
            maxpool_data.append((time_stamp, fixed_point_value))

# Sort data based on timestamp
sorted_conv_data = sorted(conv_data, key=lambda x: x[0])  # Sort by timestamp
sorted_maxpool_data = sorted(maxpool_data, key=lambda x: x[0])  # Sort by timestamp

# Save only fixed-point values for convolution output
with open(conv_output_file, "w") as f:
    for _, value in sorted_conv_data:
        f.write(f"{value:.15f}\n")

# Save only fixed-point values for maxpool output
with open(maxpool_output_file, "w") as f:
    for _, value in sorted_maxpool_data:
        f.write(f"{value:.15f}\n")
