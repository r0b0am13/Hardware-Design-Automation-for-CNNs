# Hardware Design Automation for CNNs (Ongoing)

### This project focusses on automatically converting the parameters of a pre-trained CNN model to a scalable hardware description controlled with parameters.

## Current File Locations

### Verilog Testbenches in Vivado_File/Simulation_Sources. 
### Current Verilog Design Files in Vivado_Files/Design_Sources/current.
### Old Verilog Design Files in Vivado_Files/Design_Sources/old.
### Trained CNN with respective saved models and parameters in CNN_Files.

## Changes to do :-

### Software
- Make python based convolution tester for FP values of trained model.

### Hardware
  - Complete FP_Adder.v for saturation logic and ensure parameterisation across files.
  - Another Image buffer and MaxPool System (paramterised)
  - Combine all to make a single Convolution & Maxpool Block (with image input and autoprocess for convolution)


