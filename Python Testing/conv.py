import torch
import numpy as np
import pandas as pd
from PIL import Image
import torchvision.transforms as transforms

def conv_single_step(a_slice_prev, W, b):
    """
    Arguments:
    a_slice_prev -- slice of input data of shape (f, f, n_C_prev)
    W -- Weight parameters contained in a window - matrix of shape (f, f, n_C_prev)
    b -- Bias parameters contained in a window - matrix of shape (1, 1, 1)

    Returns:
    Z -- a scalar value, the result of convolving the sliding window (W, b) on a slice x of the input data
    """

    # Element-wise product between a_slice_prev and W
    s = a_slice_prev * W

    # Sum over all entries of the volume s
    Z = np.sum(s)

    # Add bias b to Z
    Z += b

    return Z[0,0]

def conv_forward(A_prev, W, b):
    """
    Arguments:
    A_prev -- output activations of the previous layer,
        numpy array of shape (m, n_H_prev, n_W_prev, n_C_prev)
    W -- Weights, numpy array of shape (f, f, n_C_prev, n_C)
    b -- Biases, numpy array of shape (1, 1, 1, n_C)

    Returns:
    Z -- conv output, numpy array of shape (m, n_H, n_W, n_C)
    """

    n_H_prev, n_W_prev = 28, 28

    # Retrieve dimensions from W's shape
    (f, f) = W.shape

    # Compute the dimensions of the CONV output volume
    n_H = n_H_prev - f + 1
    n_W = n_W_prev - f + 1

    # Initialize the output volume Z with zeros
    Z = np.zeros((n_H, n_W))

    for h in range(n_H):
        vert_start = h
        vert_end = vert_start + f

        for w in range(n_W):
            horiz_start = w
            horiz_end = horiz_start + f

            a_slice_prev = A_prev[:, vert_start:vert_end, horiz_start:horiz_end]
            a_slice_prev = a_slice_prev.reshape(f, f)
            Z[h, w] = conv_single_step(a_slice_prev, W, b)

    return Z


def pool_forward(A_prev):
    """
    Implements the forward pass of the pooling layer

    Arguments:
    A_prev -- Input data, numpy array of shape (m, n_H_prev, n_W_prev, n_C_prev)

    Returns:
    A -- output of the pool layer, a numpy array of shape (m, n_H, n_W, n_C)
    """

    n_H_prev, n_W_prev = 28, 28
    f = 2
    stride = 2

    # Define the dimensions of the output
    n_H = int((n_H_prev - f) / stride)
    n_W = int((n_W_prev - f) / stride)

    # Initialize output matrix A
    A = np.zeros((n_H, n_W))
    count = 1
    for h in range(n_H):
        vert_start = h * stride
        vert_end = vert_start + f

        for w in range(n_W):
            horiz_start = w * stride
            horiz_end = horiz_start + f

            a_slice_prev = A_prev[vert_start:vert_end, horiz_start:horiz_end]

            A[h,w] = np.max(a_slice_prev)

    return A

# Read a PIL image
image = Image.open('number_3.jpeg')

# Define a transform to convert PIL
transform = transforms.Compose([
    transforms.PILToTensor()
])

# Convert the PIL image to Torch tensor
img_tensor = transform(image)
img_tensor = img_tensor / 255.0

img_tensor = img_tensor.numpy()

conv_weights = pd.read_csv('Weights_Biases/conv2d.csv', header=None)
conv_bias = pd.read_csv('Weights_Biases/conv2d_bias.csv', header=None)

conv_weights = np.array(conv_weights)
conv_bias = np.array(conv_bias)

l = []
m = []

for i in range(0, 32):
    weights_temp = conv_weights[9*i:9*(i+1)]
    weights_temp = weights_temp.reshape((3, 3))
    bias_temp = conv_bias[i:i+1]

    conv_forward_1 = conv_forward(img_tensor, weights_temp, bias_temp)
    max_pool_1 = pool_forward(conv_forward_1)
    l.append(conv_forward_1)
    m.append(max_pool_1)


l = np.array(l)
m = np.array(m)

l = l.reshape(-1,1)
m = m.reshape(-1,1)

l = pd.DataFrame(l)
m = pd.DataFrame(m)

l.to_csv('conv2d.csv', index=False)
m.to_csv('max_pool.csv', index=False)
