import os

def convert_q2_14_file(input_file, output_file):
    """Convert a 16-bit signed Q2.14 binary text file to fractional float values."""
    
    def q2_14_to_float(binary_str):
        val = int(binary_str, 2)
        if val & (1 << 15):  # if sign bit set
            val -= (1 << 16)
        return val / (1 << 14)

    # Ensure the output directory exists
    os.makedirs(os.path.dirname(output_file), exist_ok=True)

    with open(input_file, "r") as f_in, open(output_file, "w") as f_out:
        for line in f_in:
            parts = line.strip().split()
            if not parts:
                continue
            binary_str = parts[-1]
            if len(binary_str) == 16 and all(c in "01" for c in binary_str):
                float_val = q2_14_to_float(binary_str)
                f_out.write(f"{float_val:.6f}\n")


if __name__ == "__main__":
    input_file = "Layer1.txt"
    output_file = "FracOuts/Layer1frac.txt"
    convert_q2_14_file(input_file, output_file)

    input_file = "Layer2.txt"
    output_file = "FracOuts/Layer2frac.txt"
    convert_q2_14_file(input_file, output_file)

    input_file = "Layer3.txt"
    output_file = "FracOuts/Layer3frac.txt"
    convert_q2_14_file(input_file, output_file)
