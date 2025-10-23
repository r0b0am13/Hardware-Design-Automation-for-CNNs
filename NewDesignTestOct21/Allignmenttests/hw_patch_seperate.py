import struct

# ----------------------------- CONFIG -----------------------------
INPUT_FILE = "kernel_out_conv_b.txt"   # Each line: 144-bit binary string (9x16)
OUTPUT_FILE = "hardware_decoded.csv" # Each line: 9 comma-separated float values
FRACTION_BITS = 14                   # Q2.14 format
WORD_BITS = 16
# ------------------------------------------------------------------

def q_format_to_float(bin_str, frac_bits):
    """Convert signed fixed-point binary string to float."""
    val = int(bin_str, 2)
    if val & (1 << (len(bin_str) - 1)):  # sign bit check
        val -= (1 << len(bin_str))       # two's complement
    return val / (1 << frac_bits)

def decode_file(infile, outfile):
    with open(infile, "r") as f_in, open(outfile, "w") as f_out:
        for line in f_in:
            bits = line.strip()
            if len(bits) != 9 * WORD_BITS:
                continue  # skip malformed lines

            floats = []
            for i in range(0, len(bits), WORD_BITS):
                segment = bits[i:i+WORD_BITS]
                floats.append(q_format_to_float(segment, FRACTION_BITS))

            f_out.write(",".join(f"{x:.6f}" for x in floats) + "\n")

    print(f"Decoded file saved → {outfile}")

def main():
    decode_file(INPUT_FILE, OUTPUT_FILE)

if __name__ == "__main__":
    main()
