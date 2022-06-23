onbreak {quit -f}
onerror {quit -f}

vsim -t 1ps -lib xil_defaultlib SerializationFifo_opt

do {wave.do}

view wave
view structure
view signals

do {SerializationFifo.udo}

run -all

quit -force
