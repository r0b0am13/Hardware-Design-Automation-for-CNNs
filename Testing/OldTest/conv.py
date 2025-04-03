import torch
import numpy as np
import pandas as pd
from PIL import Image
import torchvision.transforms as transforms

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
    n_H_prev, n_W_prev = A_prev.shape

    # Retrieve dimensions from W's shape
    (f, f) = W.shape

    # Compute the dimensions of the CONV output volume
    n_H = n_H_prev - f + 1
    n_W = n_W_prev - f + 1

    print(n_H, n_W)
    # Initialize the output volume Z with zeros
    Z = np.zeros((n_H, n_W))

    for h in range(n_H):
        vert_start = h
        vert_end = vert_start + f

        for w in range(n_W):
            horiz_start = w
            horiz_end = horiz_start + f

            a_slice_prev = A_prev[vert_start:vert_end, horiz_start:horiz_end]
            Z[h, w] = np.sum(a_slice_prev * W) + b[0, 0]

    return Z

def pool_forward(A_prev):
    """
    Implements the forward pass of the pooling layer

    Arguments:
    A_prev -- Input data, numpy array of shape (m, n_H_prev, n_W_prev, n_C_prev)

    Returns:
    A -- output of the pool layer, a numpy array of shape (m, n_H, n_W, n_C)
    """

    n_H_prev, n_W_prev = A_prev.shape
    f = 2
    stride = 2

    # Define the dimensions of the output
    n_H = int((n_H_prev - f) / stride) + 1
    n_W = int((n_W_prev - f) / stride) + 1

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
image = Image.open('6x6img.jpg').convert('L')


# Convert the PIL image to Torch tensor
img_tensor =  np.array(image)
img_tensor = img_tensor / 256.0
img_tensor = np.flip(img_tensor, axis=1)
img_tensor = np.flip(img_tensor, axis=0)


conv_weights = pd.read_csv('weights6x6.csv', header=None)
conv_bias = pd.read_csv('bias6x6.csv', header=None)

conv_weights = np.array(conv_weights)
conv_bias = np.array(conv_bias)

l = []
m = []

weights_temp = conv_weights[:9]
weights_temp = weights_temp.reshape((3, 3))
weights_temp = np.flip(weights_temp, axis = 1)
weights_temp = np.flip(weights_temp, axis = 0)


bias_temp = conv_bias[:1]

conv_forward_1 = conv_forward(img_tensor, weights_temp, bias_temp)
conv_forward_1 = np.clip(conv_forward_1, -1, 1)
print(conv_forward_1)
max_pool_1 = pool_forward(conv_forward_1)
print(max_pool_1)

l.append(conv_forward_1)
m.append(max_pool_1)


l = np.array(l)
m = np.array(m)

l = l.reshape(-1,1)
m = m.reshape(-1,1)

l = pd.DataFrame(l)
m = pd.DataFrame(m)
#
# l.to_csv('conv2d6x6.csv', header=None, index=None)
# m.to_csv('max_pool6x6.csv', header=None, index=None)
