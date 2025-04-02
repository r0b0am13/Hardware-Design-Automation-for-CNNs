input_file1 = "FP_Convolution.txt"
input_file2 = "FP_Maxpool.txt"
# Read the file and reverse the lines
with open(input_file1, "r") as f:
    lines1 = f.readlines()
with open(input_file2, "r") as f:
    lines2 = f.readlines()


# Write the reversed lines back to the same file
with open(input_file1, "w") as f:
    f.writelines(lines1[::-1])
f.close()
with open(input_file2, "w") as f:
    f.writelines(lines2[::-1])

f.close()

print(f"File '{input_file1}' and '{input_file2}' has been updated with reversed lines.")