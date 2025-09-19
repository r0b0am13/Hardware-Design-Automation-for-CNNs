#!/usr/bin/env python3
"""
Script to convert CNN weights and biases from text format to fixed-point binary format

Usage:
    python3 convert_weights_biases.py

Then modify the input filename in the script or call:
    process_weights_biases_file("your_weights_file.txt")
"""

import numpy as np
import os

def float_to_fixed_point(value, integer_bits=2, fractional_bits=14):
    """
    Convert floating point to fixed point representation

    Args:
        value: floating point value to convert
        integer_bits: number of bits for integer part (default: 2)
        fractional_bits: number of bits for fractional part (default: 14)

    Returns:
        fixed point integer value
    """
    scale_factor = 2 ** fractional_bits
    max_value = (2 ** (integer_bits + fractional_bits - 1)) - 1
    min_value = -(2 ** (integer_bits + fractional_bits - 1))

    fixed_point_value = int(round(value * scale_factor))

    # Clamp to valid range
    if fixed_point_value > max_value:
        fixed_point_value = max_value
    elif fixed_point_value < min_value:
        fixed_point_value = min_value

    return fixed_point_value

def save_fixed_point_binary(values, filename):
    """
    Save values as 16-bit binary strings to file

    Args:
        values: numpy array or list of float values
        filename: output filename
    """
    # Create directory if needed
    os.makedirs(os.path.dirname(filename) if os.path.dirname(filename) else '.', exist_ok=True)

    with open(filename, 'w') as f:
        for value in values:
            fixed_point_value = float_to_fixed_point(value)

            # Handle negative numbers with two's complement
            if fixed_point_value < 0:
                # Convert to unsigned 16-bit representation  
                unsigned_value = (1 << 16) + fixed_point_value
            else:
                unsigned_value = fixed_point_value

            # Format as 16-bit binary string
            binary_value = format(unsigned_value & 0xFFFF, '016b')
            f.write(binary_value + '\n')

def parse_weights_biases_file(filename):
    """
    Parse the text file containing weights and biases.

    Expected format:
        # layer_name weights
        weight_values_on_multiple_lines

        # layer_name bias  
        bias_values_on_one_or_multiple_lines

    Args:
        filename: path to the text file

    Returns:
        dict: {layer_name: {'weights': array, 'biases': array}}
    """
    layers_data = {}
    current_section = None
    current_data = []

    try:
        with open(filename, 'r') as f:
            lines = f.readlines()
    except FileNotFoundError:
        print(f"Error: File '{filename}' not found!")
        return {}

    for line_num, line in enumerate(lines, 1):
        line = line.strip()

        # Skip empty lines
        if not line:
            continue

        # Check if this is a comment line indicating a new section
        if line.startswith('#'):
            # Save previous section data if exists
            if current_section is not None and current_data:
                try:
                    # Parse the section name to determine layer and type
                    section_parts = current_section.lower().split()
                    if len(section_parts) >= 2:
                        layer_name = section_parts[0]  # e.g., 'dense1'
                        data_type = section_parts[1]   # 'weights' or 'biases'

                        # Flatten the collected data
                        flattened_data = []
                        for row in current_data:
                            flattened_data.extend(row)

                        # Initialize layer dict if not exists
                        if layer_name not in layers_data:
                            layers_data[layer_name] = {}

                        layers_data[layer_name][data_type] = np.array(flattened_data)
                        print(f"Parsed {layer_name} {data_type}: {len(flattened_data)} values")
                except Exception as e:
                    print(f"Warning: Could not parse section '{current_section}': {e}")

            # Start new section
            current_section = line[1:].strip()  # Remove '#' and strip
            current_data = []
        else:
            # Parse numerical data
            try:
                numbers = [float(x) for x in line.split() if x.strip()]
                if numbers:  # Only add non-empty rows
                    current_data.append(numbers)
            except ValueError as e:
                print(f"Warning: Could not parse line {line_num}: '{line}' - {e}")

    # Don't forget the last section
    if current_section is not None and current_data:
        try:
            section_parts = current_section.lower().split()
            if len(section_parts) >= 2:
                layer_name = section_parts[0]
                data_type = section_parts[1]

                flattened_data = []
                for row in current_data:
                    flattened_data.extend(row)

                if layer_name not in layers_data:
                    layers_data[layer_name] = {}

                layers_data[layer_name][data_type] = np.array(flattened_data)
                print(f"Parsed {layer_name} {data_type}: {len(flattened_data)} values")
        except Exception as e:
            print(f"Warning: Could not parse final section '{current_section}': {e}")

    return layers_data

def process_weights_biases_file(input_filename, output_directory="Bin_Float_WB"):
    """
    Main function to convert weights/biases text file to colleague's binary format

    Args:
        input_filename: Path to your text file with weights and biases
        output_directory: Directory where binary files will be saved (default: "Bin_Float_WB")
    """
    print(f"Converting weights and biases from: {input_filename}")
    print(f"Output directory: {output_directory}")
    print("-" * 50)

    # Parse the input file
    layers_data = parse_weights_biases_file(input_filename)

    if not layers_data:
        print("No data found in input file!")
        return

    # Create output directory
    os.makedirs(output_directory, exist_ok=True)

    # Process each layer
    total_files = 0
    for layer_name, layer_data in layers_data.items():
        print(f"\nProcessing {layer_name}...")

        # Save weights
        if 'weights' in layer_data:
            weights = layer_data['weights']
            weights_filename = f"{output_directory}/{layer_name}_weights.bin"
            save_fixed_point_binary(weights, weights_filename)
            print(f"  ✓ Saved {len(weights)} weights to {weights_filename}")
            total_files += 1

        # Save bias 
        if 'bias' in layer_data:
            biases = layer_data['bias']
            biases_filename = f"{output_directory}/{layer_name}_biases.bin"
            save_fixed_point_binary(biases, biases_filename)
            print(f"  ✓ Saved {len(biases)} biases to {biases_filename}")
            total_files += 1

    print(f"\n" + "="*50)
    print(f"SUCCESS: Created {total_files} binary files in '{output_directory}/'")
    print(f"Format: 16-bit binary (2 integer bits, 14 fractional bits)")

if __name__ == "__main__":
    # Change this to your actual weights file path
    input_file = "dense.txt"  # <-- UPDATE THIS with your file name

    # Check if file exists, otherwise prompt user
    if not os.path.exists(input_file):
        print(f"File '{input_file}' not found.")
        input_file = input("Enter the path to your weights and biases text file: ").strip()

    # Process the file
    process_weights_biases_file(input_file)
