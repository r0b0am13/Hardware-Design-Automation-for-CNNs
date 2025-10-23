onbreak {quit -force}
onerror {quit -force}

asim +access +r +m+Full_CNN -L xil_defaultlib -L unisims_ver -L unimacro_ver -L secureip -O5 xil_defaultlib.Full_CNN xil_defaultlib.glbl

do {wave.do}

view wave
view structure

do {Full_CNN.udo}

run -all

endsim

quit -force
