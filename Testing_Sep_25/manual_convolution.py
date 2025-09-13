#!/usr/bin/env python3
"""
Manual Convolution Implementation
Performs 3x3 convolution with stride=1 and ReLU activation from scratch
Compares results with TensorFlow output
"""

import numpy as np
from PIL import Image

def manual_convolution_3x3(image, kernel, bias, stride=1):
    """
    Perform 3x3 convolution manually without using any ML libraries

    Args:
        image: 2D numpy array (28x28)
        kernel: 2D numpy array (3x3) 
        bias: float value
        stride: int, convolution stride

    Returns:
        output: 2D numpy array after convolution and ReLU
    """
    img_h, img_w = image.shape
    kernel_h, kernel_w = kernel.shape

    # Calculate output dimensions
    out_h = (img_h - kernel_h) // stride + 1  # (28-3)//1 + 1 = 26
    out_w = (img_w - kernel_w) // stride + 1  # (28-3)//1 + 1 = 26

    # Initialize output array
    output = np.zeros((out_h, out_w))

    print(f"Input image shape: {image.shape}")
    print(f"Kernel shape: {kernel.shape}")
    print(f"Output shape: {output.shape}")

    # Perform convolution
    for i in range(out_h):
        for j in range(out_w):
            # Extract the region of interest
            start_i = i * stride
            start_j = j * stride
            end_i = start_i + kernel_h
            end_j = start_j + kernel_w

            # Get the image patch
            image_patch = image[start_i:end_i, start_j:end_j]

            # Element-wise multiplication and sum (convolution)
            conv_value = np.sum(image_patch * kernel) + bias

            # Apply ReLU activation
            output[i, j] = max(0, conv_value)

    return output

def load_kernel_from_file(filename):
    """Load 3x3 kernel weights and bias from text file"""
    weights = []
    bias = 0.0

    with open(filename, 'r') as f:
        lines = f.readlines()

    for line in lines:
        line = line.strip()
        if line.startswith('bias:'):
            bias = float(line.split(':')[1])
        else:
            weights.append(float(line))

    # Reshape weights to 3x3 kernel
    kernel = np.array(weights).reshape(3, 3)

    print(f"Loaded kernel:\n{kernel}")
    print(f"Loaded bias: {bias}")

    return kernel, bias

def load_tensorflow_output(filename):
    """Load TensorFlow convolution output for comparison"""
    output = []
    with open(filename, 'r') as f:
        for line in f:
            row = [float(x) for x in line.strip().split()]
            output.append(row)

    return np.array(output)

def main():
    print("=== Manual Convolution Implementation ===\n")

    # Load the original image
    try:
        img = Image.open('sample_digit.jpg').convert('L')
        image_array = np.array(img).astype(np.float32) / 255.0
        print(f"Loaded image with shape: {image_array.shape}")
    except FileNotFoundError:
        print("Error: sample_digit.jpg not found!")
        return

    # Load kernel weights and bias
    try:
        kernel, bias = load_kernel_from_file('kernel.txt')
    except FileNotFoundError:
        print("Error: kernel.txt not found! Run the notebook first.")
        return

    # Perform manual convolution
    print("\nPerforming manual convolution...")
    manual_output = manual_convolution_3x3(image_array, kernel, bias)

    # Save manual convolution output
    with open('manual_conv_output.txt', 'w') as f:
        for row in manual_output:
            f.write(' '.join(f'{x:.8f}' for x in row) + '\n')

    print(f"Saved manual convolution output to manual_conv_output.txt")

    # Load TensorFlow output for comparison
    try:
        tf_output = load_tensorflow_output('conv_output.txt')
        print(f"\nTensorFlow output shape: {tf_output.shape}")
        print(f"Manual output shape: {manual_output.shape}")

        # Compare outputs
        if tf_output.shape == manual_output.shape:
            diff = np.abs(tf_output - manual_output)
            max_diff = np.max(diff)
            mean_diff = np.mean(diff)

            print(f"\n=== Comparison Results ===")
            print(f"Maximum difference: {max_diff:.10f}")
            print(f"Mean difference: {mean_diff:.10f}")

            if max_diff < 1e-6:
                print("✅ SUCCESS: Manual and TensorFlow outputs match!")
            else:
                print("⚠️  WARNING: Outputs differ significantly")

            # Show sample values
            print(f"\nSample comparison (first 3x3 region):")
            print("TensorFlow output:")
            print(tf_output[:3, :3])
            print("Manual output:")
            print(manual_output[:3, :3])
            print("Difference:")
            print(diff[:3, :3])

        else:
            print("❌ ERROR: Shape mismatch between TensorFlow and manual outputs")

    except FileNotFoundError:
        print("Warning: conv_output.txt not found, cannot compare with TensorFlow output")

    # Display some statistics
    print(f"\n=== Manual Convolution Statistics ===")
    print(f"Min value: {np.min(manual_output):.6f}")
    print(f"Max value: {np.max(manual_output):.6f}")
    print(f"Mean value: {np.mean(manual_output):.6f}")
    print(f"Number of zeros (ReLU effect): {np.sum(manual_output == 0)}")
    print(f"Number of positive values: {np.sum(manual_output > 0)}")

if __name__ == "__main__":
    main()
