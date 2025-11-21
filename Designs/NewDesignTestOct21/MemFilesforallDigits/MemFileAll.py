import os
from PIL import Image

# Input and output folder paths
input_folder = "imageFiles"
output_folder = "memFiles"
image_size = (28, 28)

# Ensure output folder exists
os.makedirs(output_folder, exist_ok=True)

def convert_image_to_memfile(image_path, memfile_path, image_size):
    """Convert one 28x28 grayscale image to a .mem file with 8-bit binary values."""
    img = Image.open(image_path).convert('L')  # Convert to grayscale (8-bit)

    if img.size != image_size:
        raise ValueError(f"{os.path.basename(image_path)} must be 28x28 pixels.")

    with open(memfile_path, 'w') as memfile:
        for y in range(image_size[1]):
            for x in range(image_size[0]):
                pixel_value = img.getpixel((x, y))
                memfile.write(f"{pixel_value:08b}\n")  # Write 8-bit binary per pixel

# Loop through all images in input_folder
for filename in os.listdir(input_folder):
    if filename.lower().endswith((".png", ".jpg", ".jpeg", ".bmp")):
        input_path = os.path.join(input_folder, filename)
        output_name = os.path.splitext(filename)[0] + ".mem"
        output_path = os.path.join(output_folder, output_name)

        convert_image_to_memfile(input_path, output_path, image_size)
        print(f"Converted: {filename} → {output_name}")

print("✅ All images converted successfully!")