from modelgen import ModelGen

# model_mnist = ModelGen("model_mnist.keras",out_dir="MNIST_Model32")
# model_mnist.setInputFormat(in_width=8, in_frac=0, in_signed=0)
# model_mnist.generate_software_json()
# model_mnist.compile(data_width=32, fraction_bits=20, signed=1, guard_type=3)
# model_mnist.gen_files(save_index=True)
# model_mnist.build()



# model_gray = ModelGen("model_gray.keras",out_dir="CIFAR_Gray_Model_Neuron1")
# model_gray.setInputFormat(in_width=8, in_frac=0, in_signed=0)
# model_gray.generate_software_json()
# model_gray.compile(data_width=24, fraction_bits=14, signed=1, guard_type=3)
# model_gray.gen_files(save_index=True)
# model_gray.build()

model_rgb = ModelGen("model_rgb.keras",out_dir="CIFAR_RGB_Model24_Neuron1_v2")
model_rgb.setInputFormat(in_width=8, in_frac=0, in_signed=0)
model_rgb.generate_software_json()
model_rgb.compile(data_width=24, fraction_bits=16, signed=1, guard_type=3)
model_rgb.gen_files(save_index=True)
model_rgb.build()

