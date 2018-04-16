#run simulation to verify 32-bit mem and initialized to all zeroes
proc AddWaves {} {
	;#Add waves we're interested in to the Wave window
   add wave -position end  sim:/pipelinestages/clk
add wave -position end  sim:/pipelinestages/instruction_IN
add wave -position end  sim:/pipelinestages/instruction_OUT
add wave -position end  sim:/pipelinestages/IF_ID_PC_IN
add wave -position end  sim:/pipelinestages/IF_ID_PC_OUT
add wave -position end  sim:/pipelinestages/R1_ID
add wave -position end  sim:/pipelinestages/R2_ID
add wave -position end  sim:/pipelinestages/ALU_function_id
add wave -position end  sim:/pipelinestages/use_imm_ID_EX_IN
add wave -position end  sim:/pipelinestages/use_imm_ID_EX_OUT
add wave -position end  sim:/pipelinestages/r1_address_in
add wave -position end  sim:/pipelinestages/r2_address_in
add wave -position end  sim:/pipelinestages/r1_address_ID_EX_OUT
add wave -position end  sim:/pipelinestages/r2_address_ID_EX_OUT
add wave -position end  sim:/pipelinestages/imm_ID_EX_IN
add wave -position end  sim:/pipelinestages/imm_ID_EX_OUT
add wave -position end  sim:/pipelinestages/writeback_register_ID_EX_IN
add wave -position end  sim:/pipelinestages/writeback_register_ID_EX_OUT
add wave -position end  sim:/pipelinestages/ALU_result_IN
add wave -position end  sim:/pipelinestages/ALU_result_OUT
add wave -position end  sim:/pipelinestages/writeback_register_EX_MEM_IN
add wave -position end  sim:/pipelinestages/writeback_register_EX_MEM_OUT
add wave -position end  sim:/pipelinestages/output_register_MEM_WB_IN
add wave -position end  sim:/pipelinestages/output_register_MEM_WB_OUT
add wave -position end  sim:/pipelinestages/writeback_register_MEM_WB_IN
add wave -position end  sim:/pipelinestages/writeback_register_MEM_WB_OUT
add wave -position end  sim:/pipelinestages/writeback_data_OUT

}

vlib work

;# Compile components if any

vcom pipelineStages.vhd

;# Start simulation
vsim pipelineStages

;# Generate a clock with 1ns period
force -deposit clk 0 0 ns, 1 0.5 ns -repeat 1 ns

;# Add the waves
AddWaves

;# Run for 800 ns
run 1000 ns
