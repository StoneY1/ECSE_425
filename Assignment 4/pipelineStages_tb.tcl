#run simulation to verify 32-bit mem and initialized to all zeroes
proc AddWaves {} {
	;#Add waves we're interested in to the Wave window
   add wave -position end  sim:/pipelinestages_tb/clk
add wave -position end  sim:/pipelinestages_tb/instruction_IN
add wave -position end  sim:/pipelinestages_tb/instruction_OUT
add wave -position end  sim:/pipelinestages_tb/IF_ID_PC_IN
add wave -position end  sim:/pipelinestages_tb/IF_ID_PC_OUT
add wave -position end  sim:/pipelinestages_tb/R1_ID
add wave -position end  sim:/pipelinestages_tb/R2_ID
add wave -position end  sim:/pipelinestages_tb/ALU_function_id
add wave -position end  sim:/pipelinestages_tb/use_imm_ID_EX_IN
add wave -position end  sim:/pipelinestages_tb/imm_ID_EX_IN
add wave -position end  sim:/pipelinestages_tb/ALU_result_IN


    
}

vlib work

;# Compile components if any
vcom pipelinestages_tb.vhd
vcom pipelinestages.vhd

;# Start simulation
vsim pipelinestages_tb

;# Generate a clock with 1ns period
force -deposit clk 0 0 ns, 1 0.5 ns -repeat 1 ns

;# Add the waves
AddWaves

;# Run for 800 ns
run 10000 ns
