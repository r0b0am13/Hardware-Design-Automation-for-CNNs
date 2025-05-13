# Hardware Design Automation for CNNs (Ongoing)

### This project focusses on automatically converting the parameters of a pre-trained CNN model to a scalable hardware description controlled with parameters.

## Current File Locations

- Verilog Testbenches in **Vivado_File/Simulation_Sources.** 
- Current Verilog Design Files in **Vivado_Files/Design_Sources/current.**
- Old Verilog Design Files in **Vivado_Files/Design_Sources/old.**
- Trained CNN with respective saved models and parameters in **CNN_Files.**
- All testing data for convolution/maxpool is in **Testing.**

## Current Progress
 - Design of modular blocks for FP Adders,Multipliers and Comparators.
 - Working parameterized Image Buffers, Convolution and Maxpool blocks.
 - Tested Combined Convolution and Maxpool blocks with 6x6 and 28x28 image with average accuracy upto 4th decimal places.
 - Joined NN and Conv/Maxpool block for a complete CNN.

## Changes to do :-
  - Testing the complete CNN on simulation and hardware and fix the complete flow of data.






