onerror {resume}
quietly WaveActivateNextPane {} 0
add wave -noupdate -expand -group F /main/DUT/fetch/clk_i
add wave -noupdate -expand -group F /main/DUT/fetch/rst_i
add wave -noupdate -expand -group F /main/DUT/fetch/im_addr_o
add wave -noupdate -expand -group F /main/DUT/fetch/im_data_i
add wave -noupdate -expand -group F /main/DUT/fetch/im_valid_i
add wave -noupdate -expand -group F /main/DUT/fetch/f_stall_i
add wave -noupdate -expand -group F /main/DUT/fetch/f_kill_i
add wave -noupdate -expand -group F /main/DUT/fetch/f_ir_o
add wave -noupdate -expand -group F /main/DUT/fetch/f_pc_o
add wave -noupdate -expand -group F /main/DUT/fetch/f_pc_plus_4_o
add wave -noupdate -expand -group F /main/DUT/fetch/f_valid_o
add wave -noupdate -expand -group F /main/DUT/fetch/x_pc_bra_i
add wave -noupdate -expand -group F /main/DUT/fetch/x_bra_i
add wave -noupdate -expand -group F /main/DUT/fetch/pc
add wave -noupdate -expand -group F /main/DUT/fetch/pc_plus_4
add wave -noupdate -expand -group F /main/DUT/fetch/ir
add wave -noupdate -expand -group F /main/DUT/fetch/rst_d
add wave -noupdate -expand -group F /main/DUT/fetch/pc_next
add wave -noupdate -expand -group D /main/DUT/decode/clk_i
add wave -noupdate -expand -group D /main/DUT/decode/rst_i
add wave -noupdate -expand -group D /main/DUT/decode/d_stall_i
add wave -noupdate -expand -group D /main/DUT/decode/d_kill_i
add wave -noupdate -expand -group D /main/DUT/decode/d_stall_req_o
add wave -noupdate -expand -group D /main/DUT/decode/x_load_hazard_o
add wave -noupdate -expand -group D /main/DUT/decode/f_ir_i
add wave -noupdate -expand -group D /main/DUT/decode/f_pc_i
add wave -noupdate -expand -group D /main/DUT/decode/f_valid_i
add wave -noupdate -expand -group D /main/DUT/decode/x_valid_o
add wave -noupdate -expand -group D /main/DUT/decode/x_pc_o
add wave -noupdate -expand -group D /main/DUT/decode/rf_rs1_o
add wave -noupdate -expand -group D /main/DUT/decode/rf_rs2_o
add wave -noupdate -expand -group D /main/DUT/decode/x_rs1_o
add wave -noupdate -expand -group D /main/DUT/decode/x_rs2_o
add wave -noupdate -expand -group D /main/DUT/decode/x_rd_o
add wave -noupdate -expand -group D /main/DUT/decode/x_shamt_o
add wave -noupdate -expand -group D /main/DUT/decode/x_fun_o
add wave -noupdate -expand -group D /main/DUT/decode/x_opcode_o
add wave -noupdate -expand -group D /main/DUT/decode/x_shifter_sign_o
add wave -noupdate -expand -group D /main/DUT/decode/x_imm_o
add wave -noupdate -expand -group D /main/DUT/decode/x_is_signed_compare_o
add wave -noupdate -expand -group D /main/DUT/decode/x_is_signed_alu_op_o
add wave -noupdate -expand -group D /main/DUT/decode/x_is_add_o
add wave -noupdate -expand -group D /main/DUT/decode/x_is_shift_o
add wave -noupdate -expand -group D /main/DUT/decode/x_rd_source_o
add wave -noupdate -expand -group D /main/DUT/decode/x_rd_write_o
add wave -noupdate -expand -group D /main/DUT/decode/x_is_undef_o
add wave -noupdate -expand -group D /main/DUT/decode/x_csr_sel_o
add wave -noupdate -expand -group D /main/DUT/decode/x_csr_imm_o
add wave -noupdate -expand -group D /main/DUT/decode/x_is_csr_o
add wave -noupdate -expand -group D /main/DUT/decode/x_is_eret_o
add wave -noupdate -expand -group D /main/DUT/decode/f_rs1
add wave -noupdate -expand -group D /main/DUT/decode/f_rs2
add wave -noupdate -expand -group D /main/DUT/decode/x_rs1
add wave -noupdate -expand -group D /main/DUT/decode/x_rs2
add wave -noupdate -expand -group D /main/DUT/decode/x_rd
add wave -noupdate -expand -group D /main/DUT/decode/x_opcode
add wave -noupdate -expand -group D /main/DUT/decode/x_ir
add wave -noupdate -expand -group D /main/DUT/decode/d_opcode
add wave -noupdate -expand -group D /main/DUT/decode/load_hazard
add wave -noupdate -expand -group D /main/DUT/decode/inserting_nop
add wave -noupdate -expand -group D /main/DUT/decode/d_fun
add wave -noupdate -expand -group D /main/DUT/decode/d_imm_i
add wave -noupdate -expand -group D /main/DUT/decode/d_imm_s
add wave -noupdate -expand -group D /main/DUT/decode/d_imm_b
add wave -noupdate -expand -group D /main/DUT/decode/d_imm_u
add wave -noupdate -expand -group D /main/DUT/decode/d_imm_j
add wave -noupdate -expand -group D /main/DUT/decode/d_is_shift
add wave -noupdate -group RF /main/DUT/regfile/clk_i
add wave -noupdate -group RF /main/DUT/regfile/rst_i
add wave -noupdate -group RF /main/DUT/regfile/x_stall_i
add wave -noupdate -group RF /main/DUT/regfile/w_stall_i
add wave -noupdate -group RF /main/DUT/regfile/rf_rs1_i
add wave -noupdate -group RF /main/DUT/regfile/rf_rs2_i
add wave -noupdate -group RF /main/DUT/regfile/d_rs1_i
add wave -noupdate -group RF /main/DUT/regfile/d_rs2_i
add wave -noupdate -group RF /main/DUT/regfile/x_rs1_value_o
add wave -noupdate -group RF /main/DUT/regfile/x_rs2_value_o
add wave -noupdate -group RF /main/DUT/regfile/w_rd_i
add wave -noupdate -group RF /main/DUT/regfile/w_rd_value_i
add wave -noupdate -group RF /main/DUT/regfile/w_rd_store_i
add wave -noupdate -group RF /main/DUT/regfile/w_bypass_rd_write_i
add wave -noupdate -group RF /main/DUT/regfile/w_bypass_rd_value_i
add wave -noupdate -group RF /main/DUT/regfile/rs1_regfile
add wave -noupdate -group RF /main/DUT/regfile/rs2_regfile
add wave -noupdate -group RF /main/DUT/regfile/write
add wave -noupdate -group RF /main/DUT/regfile/rs1_bypass
add wave -noupdate -group RF /main/DUT/regfile/rs2_bypass
add wave -noupdate -group RF -expand /main/DUT/regfile/bank0/ram
add wave -noupdate -group RF /main/cycles
add wave -noupdate -expand -group X /main/DUT/execute/clk_i
add wave -noupdate -expand -group X /main/DUT/execute/rst_i
add wave -noupdate -expand -group X -radix decimal /main/cycles
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
add wave -noupdate -expand -group X /main/DUT/execute/d_rd_source_i
add wave -noupdate -expand -group X /main/DUT/execute/d_rd_write_i
add wave -noupdate -expand -group X /main/DUT/execute/f_branch_target_o
add wave -noupdate -expand -group X /main/DUT/execute/f_branch_take_o
add wave -noupdate -expand -group X /main/DUT/execute/w_load_hazard_o
add wave -noupdate -expand -group X /main/DUT/execute/irq_i
add wave -noupdate -expand -group X /main/DUT/execute/w_fun_o
add wave -noupdate -expand -group X /main/DUT/execute/w_load_o
add wave -noupdate -expand -group X /main/DUT/execute/w_store_o
add wave -noupdate -expand -group X /main/DUT/execute/w_rd_o
add wave -noupdate -expand -group X /main/DUT/execute/w_rd_value_o
add wave -noupdate -expand -group X /main/DUT/execute/w_rd_write_o
add wave -noupdate -expand -group X /main/DUT/execute/w_dm_addr_o
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
add wave -noupdate -expand -group X /main/DUT/execute/exception_vector
add wave -noupdate -expand -group X /main/DUT/execute/csr_mie
add wave -noupdate -expand -group X /main/DUT/execute/csr_mip
add wave -noupdate -expand -group X /main/DUT/execute/csr_mepc
add wave -noupdate -expand -group X /main/DUT/execute/csr_mstatus
add wave -noupdate -expand -group X /main/DUT/execute/csr_mcause
add wave -noupdate -expand -group X /main/DUT/execute/csr_write_value
add wave -noupdate -expand -group X /main/DUT/execute/alu_addsub_op1
add wave -noupdate -expand -group X /main/DUT/execute/alu_addsub_op2
add wave -noupdate -expand -group X /main/DUT/execute/alu_addsub_result
add wave -noupdate -group ExceptionUnit /main/DUT/execute/exception_unit/clk_i
add wave -noupdate -group ExceptionUnit /main/DUT/execute/exception_unit/rst_i
add wave -noupdate -group ExceptionUnit /main/DUT/execute/exception_unit/x_stall_i
add wave -noupdate -group ExceptionUnit /main/DUT/execute/exception_unit/x_kill_i
add wave -noupdate -group ExceptionUnit /main/DUT/execute/exception_unit/d_is_csr_i
add wave -noupdate -group ExceptionUnit /main/DUT/execute/exception_unit/d_fun_i
add wave -noupdate -group ExceptionUnit /main/DUT/execute/exception_unit/d_csr_imm_i
add wave -noupdate -group ExceptionUnit /main/DUT/execute/exception_unit/d_csr_sel_i
add wave -noupdate -group ExceptionUnit /main/DUT/execute/exception_unit/exp_irq_i
add wave -noupdate -group ExceptionUnit /main/DUT/execute/exception_unit/exp_tick_i
add wave -noupdate -group ExceptionUnit /main/DUT/execute/exception_unit/exp_breakpoint_i
add wave -noupdate -group ExceptionUnit /main/DUT/execute/exception_unit/exp_unaligned_load_i
add wave -noupdate -group ExceptionUnit /main/DUT/execute/exception_unit/exp_unaligned_store_i
add wave -noupdate -group ExceptionUnit /main/DUT/execute/exception_unit/exp_invalid_insn_i
add wave -noupdate -group ExceptionUnit /main/DUT/execute/exception_unit/x_csr_write_value_i
add wave -noupdate -group ExceptionUnit /main/DUT/execute/exception_unit/x_exception_o
add wave -noupdate -group ExceptionUnit /main/DUT/execute/exception_unit/x_exception_pc_i
add wave -noupdate -group ExceptionUnit /main/DUT/execute/exception_unit/x_exception_pc_o
add wave -noupdate -group ExceptionUnit /main/DUT/execute/exception_unit/csr_mstatus_o
add wave -noupdate -group ExceptionUnit /main/DUT/execute/exception_unit/csr_mip_o
add wave -noupdate -group ExceptionUnit /main/DUT/execute/exception_unit/csr_mie_o
add wave -noupdate -group ExceptionUnit /main/DUT/execute/exception_unit/csr_mepc_o
add wave -noupdate -group ExceptionUnit /main/DUT/execute/exception_unit/csr_mcause_o
add wave -noupdate -group ExceptionUnit /main/DUT/execute/exception_unit/csr_mepc
add wave -noupdate -group ExceptionUnit /main/DUT/execute/exception_unit/csr_mie
add wave -noupdate -group ExceptionUnit /main/DUT/execute/exception_unit/csr_ie
add wave -noupdate -group ExceptionUnit /main/DUT/execute/exception_unit/exception
add wave -noupdate -group ExceptionUnit /main/DUT/execute/exception_unit/cause
add wave -noupdate -group ExceptionUnit /main/DUT/execute/exception_unit/except_vec_masked
add wave -noupdate -group ExceptionUnit /main/DUT/execute/exception_unit/csr_mip
add wave -noupdate -group CSR /main/DUT/execute/csr_regs/clk_i
add wave -noupdate -group CSR /main/DUT/execute/csr_regs/rst_i
add wave -noupdate -group CSR /main/DUT/execute/csr_regs/x_stall_i
add wave -noupdate -group CSR /main/DUT/execute/csr_regs/x_kill_i
add wave -noupdate -group CSR /main/DUT/execute/csr_regs/d_is_csr_i
add wave -noupdate -group CSR /main/DUT/execute/csr_regs/d_fun_i
add wave -noupdate -group CSR /main/DUT/execute/csr_regs/d_csr_imm_i
add wave -noupdate -group CSR /main/DUT/execute/csr_regs/d_csr_sel_i
add wave -noupdate -group CSR /main/DUT/execute/csr_regs/d_rs1_i
add wave -noupdate -group CSR /main/DUT/execute/csr_regs/x_rd_o
add wave -noupdate -group CSR /main/DUT/execute/csr_regs/csr_time_i
add wave -noupdate -group CSR /main/DUT/execute/csr_regs/csr_cycles_i
add wave -noupdate -group CSR /main/DUT/execute/csr_regs/x_csr_write_value_o
add wave -noupdate -group CSR /main/DUT/execute/csr_regs/csr_mstatus_i
add wave -noupdate -group CSR /main/DUT/execute/csr_regs/csr_mip_i
add wave -noupdate -group CSR /main/DUT/execute/csr_regs/csr_mie_i
add wave -noupdate -group CSR /main/DUT/execute/csr_regs/csr_mepc_i
add wave -noupdate -group CSR /main/DUT/execute/csr_regs/csr_mcause_i
add wave -noupdate -group CSR /main/DUT/execute/csr_regs/csr_mscratch
add wave -noupdate -group CSR /main/DUT/execute/csr_regs/csr_in1
add wave -noupdate -group CSR /main/DUT/execute/csr_regs/csr_in2
add wave -noupdate -group CSR /main/DUT/execute/csr_regs/csr_out
add wave -noupdate -expand -group WB /main/DUT/writeback/clk_i
add wave -noupdate -expand -group WB /main/DUT/writeback/rst_i
add wave -noupdate -expand -group WB /main/DUT/writeback/w_stall_i
add wave -noupdate -expand -group WB /main/DUT/writeback/w_stall_req_o
add wave -noupdate -expand -group WB /main/DUT/writeback/x_fun_i
add wave -noupdate -expand -group WB /main/DUT/writeback/x_load_i
add wave -noupdate -expand -group WB /main/DUT/writeback/x_store_i
add wave -noupdate -expand -group WB /main/DUT/writeback/x_load_hazard_i
add wave -noupdate -expand -group WB /main/DUT/writeback/x_dm_addr_i
add wave -noupdate -expand -group WB /main/DUT/writeback/x_rd_i
add wave -noupdate -expand -group WB /main/DUT/writeback/x_rd_value_i
add wave -noupdate -expand -group WB /main/DUT/writeback/x_rd_write_i
add wave -noupdate -expand -group WB /main/DUT/writeback/x_shifter_rd_value_i
add wave -noupdate -expand -group WB /main/DUT/writeback/x_rd_source_i
add wave -noupdate -expand -group WB /main/DUT/writeback/dm_data_l_i
add wave -noupdate -expand -group WB /main/DUT/writeback/dm_load_done_i
add wave -noupdate -expand -group WB /main/DUT/writeback/dm_store_done_i
add wave -noupdate -expand -group WB /main/DUT/writeback/rf_rd_value_o
add wave -noupdate -expand -group WB /main/DUT/writeback/rf_rd_o
add wave -noupdate -expand -group WB /main/DUT/writeback/rf_rd_write_o
add wave -noupdate -expand -group WB /main/DUT/writeback/TRIG2
add wave -noupdate -expand -group WB /main/DUT/writeback/load_value
TreeUpdate [SetDefaultTree]
WaveRestoreCursors {{Cursor 1} {2279679 ps} 0}
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
WaveRestoreZoom {2205824 ps} {2350464 ps}
