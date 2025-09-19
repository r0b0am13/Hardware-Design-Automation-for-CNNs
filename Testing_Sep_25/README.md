# Setup and first testing

This testing is done to only verify the working of the tensorflow convolution before comparing with the actual verilog implementation.

The `simple_cnn_digit.ipynb` has code that creates the `sample_digit.jpg` picture for the number 3, and trains a simple CNN to recognise it.

The weights and biases of the convolution layer are stored in the `kernel.txt` file, and its output is stored in `conv_output.txt`.

It also stores the actual dense neural network weights and biases in `dense.txt`, which can be used later.

Create a virtual environment and source it using
```bash
python3 -m venv .venv           ##Assuming you have a working python3 installation on your machine
source .venv/bin/activate
```

Then install the minimum numpy and Pillow libraries to run manual convolution using
```bash
pip3 install numpy PIL
```
To run the manual convolution, you need to navigate to this folder in terminal and run
```bash
python3 manual_convolution.py
```

The `manual_convolution.py` is just a script that takes the weights and biases from `kernel.txt` and performs a manual convolution on the `sample_digit.jpg`.

The output of this is stored in `manual_conv_output.txt`, and the script automatically compares this with the `conv_output.txt` file and prints the comparison in a user friendly format to the terminal.

# Saving the dense NN weights and biases to separate files

The earlier python script in the `simple_cnn_digit.ipynb` saved all the weights and biases of the `dense1` and `dense2` layers into a single `dense.txt` file.

However, since we need to use fixed point numbers to implement on the FPGA board, we need to convert these into fixed point values.

The final numbers will consist of 16 bits. 2 integer bits and 14 fraction bits.

For this, the script `convert_weights_biases_txt_to_bin.py` is used.

It reads all the weights and biases in the `dense.txt` file, converts them to floating point numbers, and saves them in their individual files `dense1_weights.bin`, `dense1_biases.bin`, `dense2_weights.bin` and `dense2_biases.bin` in the `Bin_Float_WB/` directory.
