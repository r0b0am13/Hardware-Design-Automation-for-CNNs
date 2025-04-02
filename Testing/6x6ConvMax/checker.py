Conv_SW = 'convolution_output.txt'
Conv_HW = 'FP_Convolution.txt'
Max_SW = 'maxpool_output.txt'
Max_HW = 'FP_Maxpool.txt'
Image_size = 6
Kernel_size = 3
Maxpool_size = 2
Threshold = 0.0004
statistics_path = 'statistics.txt'

with open(Conv_HW, 'r') as f1, open(Conv_SW, 'r') as f2:
        Conv_HW_lines = [float(line.strip()) for line in f1]
        Conv_SW_lines = [float(line.strip()) for line in f2]

with open(Max_HW, 'r') as f1, open(Max_SW, 'r') as f2:
        Max_HW_lines = [float(line.strip()) for line in f1]
        Max_SW_lines = [float(line.strip()) for line in f2]

Conv_Hit = 0
Conv_Miss = 0
Max_Hit = 0
Max_Miss = 0
Conv_Sum = 0
Max_Sum = 0

    

for i in range(len(Conv_HW_lines)):
    Conv_Sum += abs(Conv_HW_lines[i] - Conv_SW_lines[i])
    if abs(Conv_HW_lines[i] - Conv_SW_lines[i]) < Threshold:
        Conv_Hit += 1
    else:
        Conv_Miss += 1
    

for i in range(len(Max_HW_lines)):
    Max_Sum += abs(Max_HW_lines[i] - Max_SW_lines[i])
    if abs(Max_HW_lines[i] - Max_SW_lines[i]) < Threshold:
        Max_Hit += 1
    else:   
        Max_Miss += 1

Conv_Diff_Avg = Conv_Sum / len(Conv_HW_lines)
Max_Diff_Avg = Max_Sum / len(Max_HW_lines)

with open(statistics_path, 'w') as stats_file:
    stats_file.write("\nStatistics: \n")
    stats_file.write(f"Input image size: {Image_size} x {Image_size}\n")
    stats_file.write(f"Number of pixels: {Image_size * Image_size}\n")
    stats_file.write(f"Kernel size: {Kernel_size} x {Kernel_size}\n")
    stats_file.write(f"Maxpool size: {Maxpool_size} x {Maxpool_size}\n")
    stats_file.write(f"Threshold: {Threshold}\n\n")
    stats_file.write(f"Number of Convolution Output: {len(Conv_HW_lines)}\n")
    stats_file.write(f"Number of Maxpool Output: {len(Max_HW_lines)}\n\n")
    stats_file.write(f"Convolution Hits: {Conv_Hit}\n")
    stats_file.write(f"Convolution Misses: {Conv_Miss}\n")
    stats_file.write(f"Maxpool Hits: {Max_Hit}\n")
    stats_file.write(f"Maxpool Misses: {Max_Miss}\n\n")
    stats_file.write(f"Convolution Average Difference: {Conv_Diff_Avg:.16f}\n")
    stats_file.write(f"Maxpool Average Difference: {Max_Diff_Avg:.16f}\n")