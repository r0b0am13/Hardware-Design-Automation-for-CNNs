from PIL import Image
image_path = 'number_3.jpeg'
memfile_path = "image_mem.memfile"

def convert_image_to_memfile(image_path, memfile_path):
    # Open the image
    img = Image.open(image_path).convert('L')  # Convert to grayscale (8-bit)
    
    # Ensure the image is 28x28 pixels
    if img.size != (28, 28):
        raise ValueError("The image must be 28x28 pixels.")
    
    # Open the .memfile for writing
    with open(memfile_path, 'w') as memfile:
        # Iterate over each pixel in the image
        for y in range(28):
            for x in range(28):
                # Get the grayscale value (0-255)
                pixel_value = img.getpixel((x, y))
                
                # Write the pixel value in binary to the file (8 bits)
                memfile.write(f"{pixel_value:08b}\n")  # Write as 8-bit binary

# Example usage
convert_image_to_memfile(image_path, memfile_path)