from modelgen import ModelGen

model = ModelGen("model.keras",out_dir="CNN3")
model.generate_software_json()
model.compile(data_width=16, fraction_bits=14, signed=1, guard_type=3)
model.gen_files(save_index=True)
model.build()

