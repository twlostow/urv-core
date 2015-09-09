onerror {resume}
quietly WaveActivateNextPane {} 0
add wave -noupdate -group D /main/DUT/decode/clk_i
add wave -noupdate -group D /main/DUT/decode/rst_i
add wave -noupdate -group D /main/DUT/decode/d_stall_i
add wave -noupdate -group D /main/DUT/decode/d_kill_i
add wave -noupdate -group D /main/DUT/decode/d_stall_req_o
add wave -noupdate -group D /main/DUT/decode/x_load_hazard_o
add wave -noupdate -group D /main/DUT/decode/f_ir_i
add wave -noupdate -group D /main/DUT/decode/f_pc_i
add wave -noupdate -group D /main/DUT/decode/f_valid_i
add wave -noupdate -group D /main/DUT/decode/x_valid_o
add wave -noupdate -group D /main/DUT/decode/x_pc_o
add wave -noupdate -group D /main/DUT/decode/rf_rs1_o
add wave -noupdate -group D /main/DUT/decode/rf_rs2_o
add wave -noupdate -group D /main/DUT/decode/x_rs1_o
add wave -noupdate -group D /main/DUT/decode/x_rs2_o
add wave -noupdate -group D /main/DUT/decode/x_rd_o
add wave -noupdate -group D /main/DUT/decode/x_shamt_o
add wave -noupdate -group D /main/DUT/decode/x_fun_o
add wave -noupdate -group D /main/DUT/decode/x_opcode_o
add wave -noupdate -group D /main/DUT/decode/x_shifter_sign_o
add wave -noupdate -group D /main/DUT/decode/x_is_signed_compare_o
add wave -noupdate -group D /main/DUT/decode/x_is_signed_alu_op_o
add wave -noupdate -group D /main/DUT/decode/x_is_add_o
add wave -noupdate -group D /main/DUT/decode/x_is_shift_o
add wave -noupdate -group D /main/DUT/decode/x_is_load_o
add wave -noupdate -group D /main/DUT/decode/x_is_store_o
add wave -noupdate -group D /main/DUT/decode/x_is_undef_o
add wave -noupdate -group D /main/DUT/decode/x_rd_source_o
add wave -noupdate -group D /main/DUT/decode/x_rd_write_o
add wave -noupdate -group D /main/DUT/decode/x_csr_sel_o
add wave -noupdate -group D /main/DUT/decode/x_csr_imm_o
add wave -noupdate -group D /main/DUT/decode/x_is_csr_o
add wave -noupdate -group D /main/DUT/decode/x_is_eret_o
add wave -noupdate -group D /main/DUT/decode/x_alu_op1_o
add wave -noupdate -group D /main/DUT/decode/x_alu_op2_o
add wave -noupdate -group D /main/DUT/decode/x_use_op1_o
add wave -noupdate -group D /main/DUT/decode/x_use_op2_o
add wave -noupdate -group D /main/DUT/decode/f_rs1
add wave -noupdate -group D /main/DUT/decode/f_rs2
add wave -noupdate -group D /main/DUT/decode/x_rs1
add wave -noupdate -group D /main/DUT/decode/x_rs2
add wave -noupdate -group D /main/DUT/decode/x_rd
add wave -noupdate -group D /main/DUT/decode/x_opcode
add wave -noupdate -group D /main/DUT/decode/x_valid
add wave -noupdate -group D /main/DUT/decode/x_is_shift
add wave -noupdate -group D /main/DUT/decode/x_rd_write
add wave -noupdate -group D /main/DUT/decode/x_ir
add wave -noupdate -group D /main/DUT/decode/d_opcode
add wave -noupdate -group D /main/DUT/decode/load_hazard
add wave -noupdate -group D /main/DUT/decode/d_fun
add wave -noupdate -group D /main/DUT/decode/d_is_shift
add wave -noupdate -group D /main/DUT/decode/x_is_mul
add wave -noupdate -group D /main/DUT/decode/d_is_mul
add wave -noupdate -group D /main/DUT/decode/inserting_nop
add wave -noupdate -group D /main/DUT/decode/load_hazard_d
add wave -noupdate -group D /main/DUT/decode/d_imm_i
add wave -noupdate -group D /main/DUT/decode/d_imm_s
add wave -noupdate -group D /main/DUT/decode/d_imm_b
add wave -noupdate -group D /main/DUT/decode/d_imm_u
add wave -noupdate -group D /main/DUT/decode/d_imm_j
add wave -noupdate -group D /main/DUT/decode/x_imm
add wave -noupdate -expand -group X /main/DUT/execute/clk_i
add wave -noupdate -expand -group X /main/DUT/execute/rst_i
add wave -noupdate -expand -group X /main/DUT/execute/x_stall_i
add wave -noupdate -expand -group X /main/DUT/execute/x_kill_i
add wave -noupdate -expand -group X /main/DUT/execute/x_stall_req_o
add wave -noupdate -expand -group X /main/DUT/execute/d_pc_i
add wave -noupdate -expand -group X /main/DUT/execute/d_rd_i
add wave -noupdate -expand -group X /main/DUT/execute/d_fun_i
add wave -noupdate -expand -group X /main/DUT/execute/rf_rs1_value_i
add wave -noupdate -expand -group X /main/DUT/execute/rf_rs2_value_i
add wave -noupdate -expand -group X /main/DUT/execute/d_valid_i
add wave -noupdate -expand -group X /main/DUT/execute/d_load_hazard_i
add wave -noupdate -expand -group X /main/DUT/execute/d_opcode_i
add wave -noupdate -expand -group X /main/DUT/execute/d_shifter_sign_i
add wave -noupdate -expand -group X /main/DUT/execute/d_is_csr_i
add wave -noupdate -expand -group X /main/DUT/execute/d_is_eret_i
add wave -noupdate -expand -group X /main/DUT/execute/d_csr_imm_i
add wave -noupdate -expand -group X /main/DUT/execute/d_csr_sel_i
add wave -noupdate -expand -group X /main/DUT/execute/d_imm_i
add wave -noupdate -expand -group X /main/DUT/execute/d_is_signed_compare_i
add wave -noupdate -expand -group X /main/DUT/execute/d_is_signed_alu_op_i
add wave -noupdate -expand -group X /main/DUT/execute/d_is_add_i
add wave -noupdate -expand -group X /main/DUT/execute/d_is_shift_i
add wave -noupdate -expand -group X /main/DUT/execute/d_is_load_i
add wave -noupdate -expand -group X /main/DUT/execute/d_is_store_i
add wave -noupdate -expand -group X /main/DUT/execute/d_is_divide_i
add wave -noupdate -expand -group X /main/DUT/execute/d_is_undef_i
add wave -noupdate -expand -group X /main/DUT/execute/d_alu_op1_i
add wave -noupdate -expand -group X /main/DUT/execute/d_alu_op2_i
add wave -noupdate -expand -group X /main/DUT/execute/d_use_op1_i
add wave -noupdate -expand -group X /main/DUT/execute/d_use_op2_i
add wave -noupdate -expand -group X /main/DUT/execute/d_rd_source_i
add wave -noupdate -expand -group X /main/DUT/execute/d_rd_write_i
add wave -noupdate -expand -group X /main/DUT/execute/f_branch_target_o
add wave -noupdate -expand -group X /main/DUT/execute/f_branch_take_o
add wave -noupdate -expand -group X /main/DUT/execute/w_load_hazard_o
add wave -noupdate -expand -group X /main/DUT/execute/irq_i
add wave -noupdate -expand -group X /main/DUT/execute/w_fun_o
add wave -noupdate -expand -group X /main/DUT/execute/w_load_o
add wave -noupdate -expand -group X /main/DUT/execute/w_store_o
add wave -noupdate -expand -group X /main/DUT/execute/w_valid_o
add wave -noupdate -expand -group X /main/DUT/execute/w_rd_o
add wave -noupdate -expand -group X /main/DUT/execute/w_rd_value_o
add wave -noupdate -expand -group X /main/DUT/execute/w_rd_write_o
add wave -noupdate -expand -group X /main/DUT/execute/w_dm_addr_o
add wave -noupdate -expand -group X /main/DUT/execute/w_rd_source_o
add wave -noupdate -expand -group X /main/DUT/execute/w_rd_shifter_o
add wave -noupdate -expand -group X /main/DUT/execute/w_rd_multiply_o
add wave -noupdate -expand -group X /main/DUT/execute/dm_addr_o
add wave -noupdate -expand -group X /main/DUT/execute/dm_data_s_o
add wave -noupdate -expand -group X /main/DUT/execute/dm_data_select_o
add wave -noupdate -expand -group X /main/DUT/execute/dm_store_o
add wave -noupdate -expand -group X /main/DUT/execute/dm_load_o
add wave -noupdate -expand -group X /main/DUT/execute/dm_ready_i
add wave -noupdate -expand -group X /main/DUT/execute/csr_time_i
add wave -noupdate -expand -group X /main/DUT/execute/csr_cycles_i
add wave -noupdate -expand -group X /main/DUT/execute/timer_tick_i
add wave -noupdate -expand -group X /main/DUT/execute/rs1
add wave -noupdate -expand -group X /main/DUT/execute/rs2
add wave -noupdate -expand -group X /main/DUT/execute/alu_op1
add wave -noupdate -expand -group X /main/DUT/execute/alu_op2
add wave -noupdate -expand -group X /main/DUT/execute/alu_result
add wave -noupdate -expand -group X /main/DUT/execute/rd_value
add wave -noupdate -expand -group X /main/DUT/execute/branch_take
add wave -noupdate -expand -group X /main/DUT/execute/branch_condition_met
add wave -noupdate -expand -group X /main/DUT/execute/branch_target
add wave -noupdate -expand -group X /main/DUT/execute/dm_addr
add wave -noupdate -expand -group X /main/DUT/execute/dm_data_s
add wave -noupdate -expand -group X /main/DUT/execute/dm_select_s
add wave -noupdate -expand -group X /main/DUT/execute/cmp_op1
add wave -noupdate -expand -group X /main/DUT/execute/cmp_op2
add wave -noupdate -expand -group X /main/DUT/execute/cmp_rs
add wave -noupdate -expand -group X /main/DUT/execute/cmp_equal
add wave -noupdate -expand -group X /main/DUT/execute/cmp_lt
add wave -noupdate -expand -group X /main/DUT/execute/f_branch_take
add wave -noupdate -expand -group X /main/DUT/execute/rd_shifter
add wave -noupdate -expand -group X /main/DUT/execute/rd_csr
add wave -noupdate -expand -group X /main/DUT/execute/rd_mul
add wave -noupdate -expand -group X /main/DUT/execute/rd_div
add wave -noupdate -expand -group X /main/DUT/execute/exception
add wave -noupdate -expand -group X /main/DUT/execute/csr_mie
add wave -noupdate -expand -group X /main/DUT/execute/csr_mip
add wave -noupdate -expand -group X /main/DUT/execute/csr_mepc
add wave -noupdate -expand -group X /main/DUT/execute/csr_mstatus
add wave -noupdate -expand -group X /main/DUT/execute/csr_mcause
add wave -noupdate -expand -group X /main/DUT/execute/csr_write_value
add wave -noupdate -expand -group X /main/DUT/execute/exception_address
add wave -noupdate -expand -group X /main/DUT/execute/exception_vector
add wave -noupdate -expand -group X /main/DUT/execute/alu_addsub_op1
add wave -noupdate -expand -group X /main/DUT/execute/alu_addsub_op2
add wave -noupdate -expand -group X /main/DUT/execute/alu_addsub_result
add wave -noupdate -expand -group X /main/DUT/execute/divider_stall_req
add wave -noupdate -expand -group X /main/DUT/execute/d_fun
add wave -noupdate -expand -group X /main/DUT/execute/unaligned_addr
TreeUpdate [SetDefaultTree]
WaveRestoreCursors {{Cursor 1} {58892 ps} 0}
configure wave -namecolwidth 250
configure wave -valuecolwidth 100
configure wave -justifyvalue left
configure wave -signalnamewidth 1
configure wave -snapdistance 10
configure wave -datasetprefix 0
configure wave -rowmargin 4
configure wave -childrowmargin 2
configure wave -gridoffset 0
configure wave -gridperiod 1
configure wave -griddelta 40
configure wave -timeline 0
configure wave -timelineunits ps
update
WaveRestoreZoom {0 ps} {144640 ps}
