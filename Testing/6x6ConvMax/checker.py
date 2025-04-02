Conv_SW = 'convolution_output.txt'
Conv_HW = 'FP_Convolution.txt'
Max_SW = 'maxpool_output.txt'
Max_HW = 'FP_Maxpool.txt'
Threshold = 0.0004

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

print("Convolution Hits: ", Conv_Hit)
print("Convolution Misses: ", Conv_Miss)
print("Maxpool Hits: ", Max_Hit)
print("Maxpool Misses: ", Max_Miss)

print("Convolution Average Difference: ", f"{Conv_Diff_Avg:.16f}")
print("Maxpool Average Difference: ", f"{Max_Diff_Avg:.16f}")