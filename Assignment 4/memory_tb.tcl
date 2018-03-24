#run simulation to verify 32-bit mem and initialized to all zeroes
proc AddWaves {} {
	;#Add waves we're interested in to the Wave window
    add wave -position end sim:/memory_tb/clk
    add wave -position end sim:/memory_tb/writedata

    add wave -position end sim:/memory_tb/address
    add wave -position end sim:/memory_tb/memwrite
    add wave -position end sim:/memory_tb/memread
    add wave -position end sim:/memory_tb/readdata
    add wave -position end sim:/memory_tb/waitrequest
    
}

vlib work

;# Compile components if any
vcom memory_tb.vhd
vcom memory.vhd

;# Start simulation
vsim memory_tb

;# Generate a clock with 1ns period
force -deposit clk 0 0 ns, 1 0.5 ns -repeat 1 ns

;# Add the waves
AddWaves

;# Run for 800 ns
run 1000ns
