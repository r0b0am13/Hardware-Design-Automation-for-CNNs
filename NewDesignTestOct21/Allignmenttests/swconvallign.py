import numpy as np

# ----------------------------- CONFIG -----------------------------
IMAGE_FILE = "number_5.memfile"      # Each pixel: 8-bit binary string (1 per line)
KERNEL_FILE = "conv2d.csv"           # 3x3 kernel weights
BIAS = -5.383880436420440674e-02

PATCHES_OUT = "patches.csv"
CONV_OUT = "conv_outputs_sw.csv"
# ------------------------------------------------------------------

def load_image(filename):
    data = []
    with open(filename, "r") as f:
        for line in f:
            bits = line.strip()
            if bits:
                # Convert 8-bit binary string -> integer
                val = int(bits, 2)
                data.append(val)
    img = np.array(data, dtype=np.float32).reshape(28, 28)
    img /= 256.0  # normalization
    return img

def load_kernel(filename):
    data = []
    with open(filename, "r") as f:
        for line in f:
            if line.strip():
                data.extend(map(float, line.strip().split(',')))  # CSV-based
    kernel = np.array(data, dtype=np.float32).reshape(3, 3)
    return kernel

def save_patches_and_conv(image, kernel, bias):
    with open(PATCHES_OUT, "w") as out_patches, open(CONV_OUT, "w") as out_conv:
        rows, cols = image.shape
        ksize = kernel.shape[0]
        for i in range(rows - ksize + 1):
            for j in range(cols - ksize + 1):
                patch = image[i:i+ksize, j:j+ksize]
                patch_flat = patch.flatten()
                out_patches.write(",".join(f"{v:.6f}" for v in patch_flat) + "\n")
                conv_val = np.sum(patch * kernel) + bias
                out_conv.write(f"{conv_val:.6f}\n")

    print(f"Saved patches → {PATCHES_OUT}")
    print(f"Saved convolution outputs → {CONV_OUT}")

def main():
    image = load_image(IMAGE_FILE)
    kernel = load_kernel(KERNEL_FILE)
    save_patches_and_conv(image, kernel, BIAS)

if __name__ == "__main__":
    main()
