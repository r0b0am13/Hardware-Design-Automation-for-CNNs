import numpy as np

conv_output = np.loadtxt("conv_output.txt")   # 2D array
flat_output = conv_output.flatten()           # 1D array

conv_h = np.loadtxt("conv_h.txt")             # Already 1D
flat_h = conv_h.flatten()                     # Just to be consistent

threshold = 0.009
print("Number of elements:", len(flat_output),"and", len(flat_h))
hits = 0
misses = 0
for i in range(len(flat_output)):
    flat_h[i] = flat_h[i] if flat_h[i] > 0 else 0
    if abs(flat_output[i] - flat_h[i]) > threshold:
        misses += 1
    else:
        hits += 1
print(f"Hits: {hits}, Misses: {misses} at Threshold: {threshold}")