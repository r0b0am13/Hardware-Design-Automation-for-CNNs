from PIL import Image
import numpy as np
import pandas

image_path = '6x6img.jpg'
gray = Image.open(image_path).convert('L')
image_array = np.array(gray)
norm_image = image_array/256
norm_image = np.flip(norm_image, axis=1)
norm_image = np.flip(norm_image, axis=0)

row,column = norm_image.shape

Kernel_size = 3
stride_size = 2
weights=pandas.read_csv('weights6x6.csv', header=None)
weights = np.array(weights)
bias = pandas.read_csv('bias6x6.csv', header=None)
bias = np.array(bias)
weights = weights.reshape((3,3))
weights = weights[:9]
weights = np.flip(weights, axis=1)
weights = np.flip(weights, axis=0)
print("\nBias:\n")
print(bias,"\n")
print("Weights:\n")
print(weights,  "\n")

output_rows = row - (Kernel_size - 1)
output_columns = column - (Kernel_size - 1)
output = np.zeros((output_rows, output_columns))
print(norm_image)

for i in range(output_rows):
    for j in range(output_columns):
        region = norm_image[i:i+Kernel_size, j:j+Kernel_size] 
        conv_result = np.sum(region * weights) + bias[0, 0]
        output[i, j] = conv_result


print("Convolution Outputs:\n")
print(output,   "\n")


pool_rows = output_rows // stride_size
pool_columns = output_columns // stride_size
pooled_output = np.zeros((pool_rows, pool_columns))

for i in range(pool_rows):
    for j in range(pool_columns):
        region = output[i*stride_size:i*stride_size+stride_size, j*stride_size:j*stride_size+stride_size]
        pooled_output[i, j] = np.max(region)
print("Maxpool Outputs:\n")
print(pooled_output,"\n")

# Write convolution outputs to a file
with open('convolution_output.txt', 'w') as conv_file:
    for row in output:
        for value in row:
            conv_file.write(f"{value}\n")

# Write maxpool outputs to a file
with open('maxpool_output.txt', 'w') as pool_file:
    for row in pooled_output:
        for value in row:
            pool_file.write(f"{value}\n")