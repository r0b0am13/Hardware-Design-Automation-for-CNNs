# ModelGen – CNN-to-Hardware Generation Tool

ModelGen is a Python-based utility that converts a trained Keras CNN model into a complete FPGA-ready hardware package. It automatically produces:

- `software_model.json` – extracted layer definitions  
- `hardware_model.json` – hardware architecture mapping  
- Quantized memory files (`.mif` and `.csv`)  
- Synthesizable RTL Verilog modules  
- Optional wrapper top-level for input format conversion  

---

## 1. Requirements

### Python Packages
```
tensorflow
numpy
```

Install using:
```
pip install tensorflow numpy
```

### Required Verilog Modules (in `designFiles/`)
```
Conv2D.v
Max2D.v
neuron.v
maxFinder.v

FP_Adder.v
FP_Multiplier.v
FP_Comparator.v

line_buffer.v
pixel_buffer.v
imageBuffer.v
imageBufferChnl.v

ConvolChnl.v
Conv_SIC.v
Conv_MIC.v

Maxpool.v
MaxpoolChnl.v

Weight_Memory.v
relu.v

DataConverter.v
Data_MIC_Converter.v
```

---

## 2. Project Structure

### Before Running ModelGen
```
project_root/
├── model.keras
├── modelgen.py
└── designFiles/
    └── all required .v modules
```

### After Running ModelGen
```
project_output/
├── software_model.json
├── hardware_model.json
├── Memory_Files/
│   ├── mif/
│   └── csv/
├── rtl/
│   ├── Layer_1.v
│   ├── Layer_2.v
│   └── <project>_top.v
└── hw/
    ├── all .v files
    ├── all .mif files
    └── optional <project>.v wrapper
```

---

## 3. Usage

Below is the minimal script for generating all required files:

```python
from modelgen import ModelGen

mg = ModelGen("model.keras", out_dir="project_output")

# Stage 1: Extract software layer model
mg.generate_software_json()

# Stage 2: Build hardware JSON architecture
mg.compile(data_width=16, fraction_bits=14, signed=1, guard_type=2)

# Stage 3: Generate weight & bias memory files
mg.gen_files(save_index=True)

# (Optional) Input format conversion
mg.setInputFormat(in_width=12, in_frac=6, in_signed=1)

# Stage 4: Generate RTL + package hardware
mg.build()
```

---

## 4. Meaning of Each Stage

### **1. generate_software_json()**
Extracts model topology from the `.keras` file  
→ Produces `software_model.json`.

### **2. compile()**
Maps software layers into hardware blocks  
→ Produces `hardware_model.json`.

### **3. gen_files()**
Generates `.mif` and `.csv` memory files  
→ Creates `Memory_Index.json`.

### **4. build()**
Generates all RTL modules and packages them into `/hw/`  
→ Final FPGA-ready hardware design.

---

## 5. Summary

ModelGen enables:

```
Keras model → JSON descriptions → Memory files → RTL → FPGA-ready system
```

It simplifies CNN hardware generation for research, FPGA prototyping, and coursework.

