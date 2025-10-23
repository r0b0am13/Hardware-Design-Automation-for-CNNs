vlib questa_lib/work
vlib questa_lib/msim

vlib questa_lib/msim/xil_defaultlib

vmap xil_defaultlib questa_lib/msim/xil_defaultlib

vlog -work xil_defaultlib  \
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

