vlib work
vlib activehdl

vlib activehdl/xil_defaultlib

vmap xil_defaultlib activehdl/xil_defaultlib

vlog -work xil_defaultlib  -v2k5 \
"../../../bd/Full_CNN/ip/Full_CNN_Convolution_0_0/sim/Full_CNN_Convolution_0_0.v" \
"../../../bd/Full_CNN/ip/Full_CNN_Maxpool_0_0/sim/Full_CNN_Maxpool_0_0.v" \
"../../../bd/Full_CNN/ip/Full_CNN_ImageBuf_KernelSlider_0_0/sim/Full_CNN_ImageBuf_KernelSlider_0_0.v" \
"../../../bd/Full_CNN/ip/Full_CNN_zyNet_0_0/sim/Full_CNN_zyNet_0_0.v" \
"../../../bd/Full_CNN/ip/Full_CNN_ConvWeightBiasModule_0_0/sim/Full_CNN_ConvWeightBiasModule_0_0.v" \
"../../../bd/Full_CNN/ip/Full_CNN_ConvSlider_0/sim/Full_CNN_ConvSlider_0.v" \
"../../../bd/Full_CNN/ip/Full_CNN_DataConverter_0_0/sim/Full_CNN_DataConverter_0_0.v" \
"../../../bd/Full_CNN/sim/Full_CNN.v" \


vlog -work xil_defaultlib \
"glbl.v"

