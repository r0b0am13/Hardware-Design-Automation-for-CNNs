

sw_conv_file = "1_conv2d_output.txt"
sw_max_file = "2_max_pooling2d_output.txt"
hw_conv_file = "conv_outputs_hw.txt"
hw_max_file = "maxp_outputs_hw.txt"

tolerance = 0.01602
conv_match = 0
conv_miss = 0
max_match = 0
max_miss = 0
highest_diff_max = 0.0
highest_diff_conv = 0.0
average_diff_conv = 0.0
average_diff_max = 0.0
print("Software file (conv): ", sw_conv_file ,"\nHardware file (conv): ", hw_conv_file,"\nSoftware file (max): ", sw_max_file ,"\nHardware file (max): ", hw_max_file)
print()
print(f"Using tolerance: {tolerance}")
print()
with open(sw_conv_file, "r") as f_sw_conv, open(hw_conv_file, "r") as f_hw_conv:
    sw_conv_lines = f_sw_conv.readlines()
    hw_conv_lines = f_hw_conv.readlines()
    if(len(sw_conv_lines) != len(hw_conv_lines)):
        print("Error: Number of lines in software and hardware conv output files do not match.")
        exit(1)

    for i, (sw_line, hw_line) in enumerate(zip(sw_conv_lines, hw_conv_lines)):
        sw_value = float(sw_line.strip())
        hw_value = float(hw_line.strip())

        if(abs(sw_value - hw_value) > highest_diff_conv):
            highest_diff_conv = abs(sw_value - hw_value)
        
        average_diff_conv += abs(sw_value - hw_value)
        
        if abs(sw_value - hw_value) > tolerance:
            print(f"Mismatch in conv output at line {i+1}: SW={sw_value}, HW={hw_value}")
            conv_miss += 1
        else:
            conv_match += 1
    average_diff_conv = average_diff_conv / len(sw_conv_lines)

with open(sw_max_file, "r") as f_sw_max, open(hw_max_file, "r") as f_hw_max:
    sw_max_lines = f_sw_max.readlines()
    hw_max_lines = f_hw_max.readlines()
    
    if(len(sw_max_lines) != len(hw_max_lines)):
        print("Error: Number of lines in software and hardware max pool output files do not match.")
        exit(1)

    for i, (sw_line, hw_line) in enumerate(zip(sw_max_lines, hw_max_lines)):
        sw_value = float(sw_line.strip())
        hw_value = float(hw_line.strip())
        
        if(abs(sw_value - hw_value) > highest_diff_max):
            highest_diff_max = abs(sw_value - hw_value)
        
        average_diff_max += abs(sw_value - hw_value)    
        
        if abs(sw_value - hw_value) > tolerance:
            print(f"Mismatch in max pool output at line {i+1}: SW={sw_value}, HW={hw_value}")
            max_miss += 1
        else:
            max_match += 1
    average_diff_max = average_diff_max / len(sw_max_lines)

print("Comparison Summary:")
print(f"Conv Output - Matches: {conv_match}, Mismatches: {conv_miss}, \nHighest Difference: {highest_diff_conv}, Average Difference: {average_diff_conv},\n Hit Rate: {conv_match / (conv_match + conv_miss) * 100:.2f}%, Number of samples: {len(sw_conv_lines)}")
print(f"Max Pool Output - Matches: {max_match}, Mismatches: {max_miss},\n Highest Difference: {highest_diff_max}, Average Difference: {average_diff_max},\n Hit Rate: {max_match / (max_match + max_miss) * 100:.2f}%", f"Number of samples: {len(sw_max_lines)}")
            