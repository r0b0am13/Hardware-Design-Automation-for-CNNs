import re

# --------------------------- CONFIG ---------------------------
INPUT_FILE = "layer1.txt"
OUTPUT_FILE = "output.txt"
BITS = 16
FRACTION_BITS = 14
# ---------------------------------------------------------------

def q_to_float(binary_str, fraction_bits):
    """Convert a signed Qm.n binary string to float (two's complement)."""
    val = int(binary_str, 2)
    # If MSB is 1 → negative number (two's complement)
    if val & (1 << (len(binary_str) - 1)):
        val -= (1 << len(binary_str))
    return val / (2 ** fraction_bits)

def extract_binaries(text):
    """Extract all 16-bit binary sequences from text."""
    return re.findall(r'\b[01]{16}\b', text)

def main():
    with open(INPUT_FILE, 'r') as f:
        text = f.read()

    binaries = extract_binaries(text)
    reals = [q_to_float(b, FRACTION_BITS) for b in binaries]

    with open(OUTPUT_FILE, 'w') as f:
        for b, r in zip(binaries, reals):
            f.write(f"{b}  {r:.6f}\n")

    print(f"Extracted {len(binaries)} binary values → saved to '{OUTPUT_FILE}'.")

if __name__ == "__main__":
    main()
