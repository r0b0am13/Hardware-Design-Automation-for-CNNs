# File paths
input_file = "RAW_Terminal_Output.txt"  # Change this to your actual file path
conv_file_with_time = "BIN_Convolution_TS.txt"
maxpool_file_with_time = "BIN_Maxpool_TS.txt"
conv_file_no_time = "BIN_Convolution.txt"
maxpool_file_no_time = "BIN_Maxpool.txt"

# Lists for storing convolution and maxpool outputs
conv_data = []
maxpool_data = []

# Read and process the file
with open(input_file, "r") as file:
    for line in file:
        parts = line.strip().split(" | ")
        time_stamp = int(parts[0].split(": ")[1])
        binary_value = parts[1].split(": ")[1]

        # Categorize based on type
        if "Convolution Output" in parts[1]:
            conv_data.append((time_stamp, binary_value))
        elif "MaxPool Output" in parts[1]:
            maxpool_data.append((time_stamp, binary_value))

# Sort data based on timestamp
sorted_conv_data = sorted(conv_data, key=lambda x: x[0])  # Sort by timestamp
sorted_maxpool_data = sorted(maxpool_data, key=lambda x: x[0])  # Sort by timestamp

# Save sorted convolution output with timestamp
with open(conv_file_with_time, "w") as f:
    for time_stamp, binary_value in sorted_conv_data:
        f.write(f"Time: {time_stamp} | {binary_value}\n")

# Save sorted maxpool output with timestamp
with open(maxpool_file_with_time, "w") as f:
    for time_stamp, binary_value in sorted_maxpool_data:
        f.write(f"Time: {time_stamp} | {binary_value}\n")

# Save sorted convolution output without timestamp
with open(conv_file_no_time, "w") as f:
    for _, binary_value in sorted_conv_data:
        f.write(f"{binary_value}\n")

# Save sorted maxpool output without timestamp
with open(maxpool_file_no_time, "w") as f:
    for _, binary_value in sorted_maxpool_data:
        f.write(f"{binary_value}\n")

print("Files created successfully!")
