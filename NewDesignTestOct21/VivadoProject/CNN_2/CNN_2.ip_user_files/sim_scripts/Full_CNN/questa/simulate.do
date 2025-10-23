onbreak {quit -f}
onerror {quit -f}

vsim -lib xil_defaultlib Full_CNN_opt

do {wave.do}

view wave
view structure
view signals

do {Full_CNN.udo}

run -all

quit -force
