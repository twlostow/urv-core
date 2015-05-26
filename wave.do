onerror {resume}
quietly WaveActivateNextPane {} 0
add wave -noupdate /main/DUT/clk_i
add wave -noupdate /main/DUT/rst_i
add wave -noupdate -expand -group cpu /main/DUT/clk_i
add wave -noupdate -expand -group cpu /main/DUT/rst_i
add wave -noupdate -expand -group cpu /main/DUT/im_addr_o
add wave -noupdate -expand -group cpu /main/DUT/im_data_i
add wave -noupdate -expand -group cpu /main/DUT/im_valid_i
add wave -noupdate -expand -group cpu /main/DUT/dm_addr_o
add wave -noupdate -expand -group cpu /main/DUT/dm_data_s_o
add wave -noupdate -expand -group cpu /main/DUT/dm_data_l_i
add wave -noupdate -expand -group cpu /main/DUT/dm_data_select_o
add wave -noupdate -expand -group cpu /main/DUT/dm_ready_i
add wave -noupdate -expand -group cpu /main/DUT/dm_store_o
add wave -noupdate -expand -group cpu /main/DUT/dm_load_o
add wave -noupdate -expand -group cpu /main/DUT/dm_load_done_i
add wave -noupdate -expand -group cpu /main/DUT/dm_store_done_i
add wave -noupdate -expand -group cpu /main/DUT/f_stall
add wave -noupdate -expand -group cpu /main/DUT/w_stall
add wave -noupdate -expand -group cpu /main/DUT/x_stall
add wave -noupdate -expand -group cpu /main/DUT/x_kill
add wave -noupdate -expand -group cpu /main/DUT/f_kill
add wave -noupdate -expand -group cpu /main/DUT/f2d_pc
add wave -noupdate -expand -group cpu /main/DUT/f2d_pc_plus_4
add wave -noupdate -expand -group cpu /main/DUT/f2d_ir
add wave -noupdate -expand -group cpu /main/DUT/f2d_ir_valid
add wave -noupdate -expand -group cpu /main/DUT/x2f_pc_bra
add wave -noupdate -expand -group cpu /main/DUT/x2f_bra
add wave -noupdate -expand -group cpu /main/DUT/f2d_valid
add wave -noupdate -expand -group cpu /main/DUT/f_stall_req
add wave -noupdate -expand -group cpu /main/DUT/d2x_pc
add wave -noupdate -expand -group cpu /main/DUT/rf_rs1
add wave -noupdate -expand -group cpu /main/DUT/d2x_rs1
add wave -noupdate -expand -group cpu /main/DUT/rf_rs2
add wave -noupdate -expand -group cpu /main/DUT/d2x_rs2
add wave -noupdate -expand -group cpu /main/DUT/d2x_rd
add wave -noupdate -expand -group cpu /main/DUT/d2x_shamt
add wave -noupdate -expand -group cpu /main/DUT/d2x_fun
add wave -noupdate -expand -group cpu /main/DUT/d2x_opcode
add wave -noupdate -expand -group cpu /main/DUT/d2x_shifter_sign
add wave -noupdate -expand -group cpu /main/DUT/d2x_imm_i
add wave -noupdate -expand -group cpu /main/DUT/d2x_imm_s
add wave -noupdate -expand -group cpu /main/DUT/d2x_imm_u
add wave -noupdate -expand -group cpu /main/DUT/d2x_imm_b
add wave -noupdate -expand -group cpu /main/DUT/d2x_imm_j
add wave -noupdate -expand -group cpu /main/DUT/f_load_hazard
add wave -noupdate -expand -group cpu /main/DUT/x2w_rd
add wave -noupdate -expand -group cpu /main/DUT/x2w_rd_value
add wave -noupdate -expand -group cpu /main/DUT/x2w_dm_addr
add wave -noupdate -expand -group cpu /main/DUT/x2w_rd_write
add wave -noupdate -expand -group cpu /main/DUT/x2w_fun
add wave -noupdate -expand -group cpu /main/DUT/x2w_store
add wave -noupdate -expand -group cpu /main/DUT/x2w_load
add wave -noupdate -expand -group cpu /main/DUT/x_rs2_value
add wave -noupdate -expand -group cpu /main/DUT/x_rs1_value
add wave -noupdate -expand -group cpu /main/DUT/rf_rd
add wave -noupdate -expand -group cpu /main/DUT/rf_rd_value
add wave -noupdate -expand -group cpu /main/DUT/rf_rd_write
add wave -noupdate -expand -group cpu /main/DUT/rf_bypass_rd_value
add wave -noupdate -expand -group cpu /main/DUT/rf_bypass_rd_write
add wave -noupdate -expand -group cpu /main/DUT/x_load_comb
add wave -noupdate -expand -group cpu /main/DUT/x_stall_req
add wave -noupdate -expand -group cpu /main/DUT/w_stall_req
add wave -noupdate -expand -group cpu /main/DUT/x2f_bra_d0
add wave -noupdate -expand -group cpu /main/DUT/interlock_load
add wave -noupdate -expand -group cpu /main/DUT/interlock_load_d0
add wave -noupdate -expand -group cpu /main/DUT/stall_tmp
add wave -noupdate -expand -group fetch /main/DUT/fetch/clk_i
add wave -noupdate -expand -group fetch /main/DUT/fetch/rst_i
add wave -noupdate -expand -group fetch /main/DUT/fetch/im_addr_o
add wave -noupdate -expand -group fetch /main/DUT/fetch/im_data_i
add wave -noupdate -expand -group fetch /main/DUT/fetch/im_valid_i
add wave -noupdate -expand -group fetch /main/DUT/fetch/f_stall_i
add wave -noupdate -expand -group fetch /main/DUT/fetch/f_kill_i
add wave -noupdate -expand -group fetch /main/DUT/fetch/rf_rs1_o
add wave -noupdate -expand -group fetch /main/DUT/fetch/rf_rs2_o
add wave -noupdate -expand -group fetch /main/DUT/fetch/f_load_hazard_o
add wave -noupdate -expand -group fetch /main/DUT/fetch/f_ir_o
add wave -noupdate -expand -group fetch /main/DUT/fetch/f_pc_o
add wave -noupdate -expand -group fetch /main/DUT/fetch/f_pc_plus_4_o
add wave -noupdate -expand -group fetch /main/DUT/fetch/f_valid_o
add wave -noupdate -expand -group fetch /main/DUT/fetch/x_pc_bra_i
add wave -noupdate -expand -group fetch /main/DUT/fetch/x_bra_i
add wave -noupdate -expand -group fetch /main/DUT/fetch/pc
add wave -noupdate -expand -group fetch /main/DUT/fetch/ir
add wave -noupdate -expand -group fetch /main/DUT/fetch/rst_d
add wave -noupdate -expand -group fetch /main/DUT/fetch/rs1_mem
add wave -noupdate -expand -group fetch /main/DUT/fetch/rs2_mem
add wave -noupdate -expand -group fetch /main/DUT/fetch/rd
add wave -noupdate -expand -group fetch /main/DUT/fetch/pc_next
add wave -noupdate -group decode /main/DUT/decode/clk_i
add wave -noupdate -group decode /main/DUT/decode/rst_i
add wave -noupdate -group decode /main/DUT/decode/f_ir_i
add wave -noupdate -group decode /main/DUT/decode/f_pc_i
add wave -noupdate -group decode /main/DUT/decode/x_pc_o
add wave -noupdate -group decode /main/DUT/decode/rf_rs1_o
add wave -noupdate -group decode /main/DUT/decode/rf_rs2_o
add wave -noupdate -group decode /main/DUT/decode/x_rd_o
add wave -noupdate -group decode /main/DUT/decode/x_shamt_o
add wave -noupdate -group decode /main/DUT/decode/x_fun_o
add wave -noupdate -group decode /main/DUT/decode/x_opcode_o
add wave -noupdate -group decode /main/DUT/decode/x_shifter_sign_o
add wave -noupdate -group decode /main/DUT/decode/x_imm_i_o
add wave -noupdate -group decode /main/DUT/decode/x_imm_s_o
add wave -noupdate -group decode /main/DUT/decode/x_imm_b_o
add wave -noupdate -group decode /main/DUT/decode/x_imm_u_o
add wave -noupdate -group decode /main/DUT/decode/x_imm_j_o
add wave -noupdate -expand -group regfile /main/DUT/regfile/clk_i
add wave -noupdate -expand -group regfile /main/DUT/regfile/rst_i
add wave -noupdate -expand -group regfile /main/DUT/regfile/x_stall_i
add wave -noupdate -expand -group regfile /main/DUT/regfile/w_stall_i
add wave -noupdate -expand -group regfile /main/DUT/regfile/rf_rs1_i
add wave -noupdate -expand -group regfile /main/DUT/regfile/rf_rs2_i
add wave -noupdate -expand -group regfile /main/DUT/regfile/d_rs1_i
add wave -noupdate -expand -group regfile /main/DUT/regfile/d_rs2_i
add wave -noupdate -expand -group regfile /main/DUT/regfile/x_rs1_value_o
add wave -noupdate -expand -group regfile /main/DUT/regfile/x_rs2_value_o
add wave -noupdate -expand -group regfile /main/DUT/regfile/w_rd_i
add wave -noupdate -expand -group regfile /main/DUT/regfile/w_rd_value_i
add wave -noupdate -expand -group regfile /main/DUT/regfile/w_rd_store_i
add wave -noupdate -expand -group regfile /main/DUT/regfile/w_bypass_rd_write_i
add wave -noupdate -expand -group regfile /main/DUT/regfile/w_bypass_rd_value_i
add wave -noupdate -expand -group regfile /main/DUT/regfile/rs1_regfile
add wave -noupdate -expand -group regfile /main/DUT/regfile/rs2_regfile
add wave -noupdate -expand -group regfile /main/DUT/regfile/write
add wave -noupdate -expand -group regfile /main/DUT/regfile/rs1_bypass
add wave -noupdate -expand -group regfile /main/DUT/regfile/rs2_bypass
add wave -noupdate /main/DUT/regfile/bank0/ram
add wave -noupdate -expand -group shifter /main/DUT/execute/shifter/clk_i
add wave -noupdate -expand -group shifter /main/DUT/execute/shifter/rst_i
add wave -noupdate -expand -group shifter /main/DUT/execute/shifter/d_i
add wave -noupdate -expand -group shifter /main/DUT/execute/shifter/q_o
add wave -noupdate -expand -group shifter /main/DUT/execute/shifter/shift_i
add wave -noupdate -expand -group shifter /main/DUT/execute/shifter/func_i
add wave -noupdate -expand -group shifter /main/DUT/execute/shifter/arith_i
add wave -noupdate -expand -group shifter /main/DUT/execute/shifter/extend_sign
add wave -noupdate -expand -group shifter /main/DUT/execute/shifter/shift_pre
add wave -noupdate -expand -group shifter /main/DUT/execute/shifter/shift_16
add wave -noupdate -expand -group shifter /main/DUT/execute/shifter/shift_8
add wave -noupdate -expand -group shifter /main/DUT/execute/shifter/s1_out
add wave -noupdate -expand -group shifter /main/DUT/execute/shifter/s2_extend_sign
add wave -noupdate -expand -group shifter /main/DUT/execute/shifter/s2_shift
add wave -noupdate -expand -group shifter /main/DUT/execute/shifter/s2_func
add wave -noupdate -expand -group shifter /main/DUT/execute/shifter/shift_4
add wave -noupdate -expand -group shifter /main/DUT/execute/shifter/shift_2
add wave -noupdate -expand -group shifter /main/DUT/execute/shifter/shift_1
add wave -noupdate -expand -group shifter /main/DUT/execute/shifter/shift_post
add wave -noupdate -expand -group execute /main/DUT/execute/clk_i
add wave -noupdate -expand -group execute /main/DUT/execute/rst_i
add wave -noupdate -expand -group execute /main/DUT/execute/x_stall_i
add wave -noupdate -expand -group execute /main/DUT/execute/x_kill_i
add wave -noupdate -expand -group execute /main/DUT/execute/x_stall_req_o
add wave -noupdate -expand -group execute /main/DUT/execute/d_pc_i
add wave -noupdate -expand -group execute /main/DUT/execute/d_rd_i
add wave -noupdate -expand -group execute /main/DUT/execute/d_fun_i
add wave -noupdate -expand -group execute /main/DUT/execute/rf_rs1_value_i
add wave -noupdate -expand -group execute /main/DUT/execute/rf_rs2_value_i
add wave -noupdate -expand -group execute /main/DUT/execute/d_valid_i
add wave -noupdate -expand -group execute /main/DUT/execute/d_opcode_i
add wave -noupdate -expand -group execute /main/DUT/execute/d_shifter_sign_i
add wave -noupdate -expand -group execute /main/DUT/execute/d_imm_i_i
add wave -noupdate -expand -group execute /main/DUT/execute/d_imm_s_i
add wave -noupdate -expand -group execute /main/DUT/execute/d_imm_b_i
add wave -noupdate -expand -group execute /main/DUT/execute/d_imm_u_i
add wave -noupdate -expand -group execute /main/DUT/execute/d_imm_j_i
add wave -noupdate -expand -group execute /main/DUT/execute/f_branch_target_o
add wave -noupdate -expand -group execute /main/DUT/execute/f_branch_take_o
add wave -noupdate -expand -group execute /main/DUT/execute/w_fun_o
add wave -noupdate -expand -group execute /main/DUT/execute/w_load_o
add wave -noupdate -expand -group execute /main/DUT/execute/w_store_o
add wave -noupdate -expand -group execute /main/DUT/execute/w_rd_o
add wave -noupdate -expand -group execute /main/DUT/execute/w_rd_value_o
add wave -noupdate -expand -group execute /main/DUT/execute/w_rd_write_o
add wave -noupdate -expand -group execute /main/DUT/execute/w_dm_addr_o
add wave -noupdate -expand -group execute /main/DUT/execute/dm_addr_o
add wave -noupdate -expand -group execute /main/DUT/execute/dm_data_s_o
add wave -noupdate -expand -group execute /main/DUT/execute/dm_data_select_o
add wave -noupdate -expand -group execute /main/DUT/execute/dm_store_o
add wave -noupdate -expand -group execute /main/DUT/execute/dm_load_o
add wave -noupdate -expand -group execute /main/DUT/execute/dm_ready_i
add wave -noupdate -expand -group execute /main/DUT/execute/rs1
add wave -noupdate -expand -group execute /main/DUT/execute/rs2
add wave -noupdate -expand -group execute /main/DUT/execute/alu_op1
add wave -noupdate -expand -group execute /main/DUT/execute/alu_op2
add wave -noupdate -expand -group execute /main/DUT/execute/alu_result
add wave -noupdate -expand -group execute /main/DUT/execute/rd_value
add wave -noupdate -expand -group execute /main/DUT/execute/branch_take
add wave -noupdate -expand -group execute /main/DUT/execute/branch_condition_met
add wave -noupdate -expand -group execute /main/DUT/execute/branch_target
add wave -noupdate -expand -group execute /main/DUT/execute/dm_addr
add wave -noupdate -expand -group execute /main/DUT/execute/dm_data_s
add wave -noupdate -expand -group execute /main/DUT/execute/dm_select_s
add wave -noupdate -expand -group execute /main/DUT/execute/rd_write
add wave -noupdate -expand -group execute /main/DUT/execute/cmp_sign_ext
add wave -noupdate -expand -group execute /main/DUT/execute/cmp_op1
add wave -noupdate -expand -group execute /main/DUT/execute/cmp_op2
add wave -noupdate -expand -group execute /main/DUT/execute/cmp_equal
add wave -noupdate -expand -group execute /main/DUT/execute/cmp_lt
add wave -noupdate -expand -group execute /main/DUT/execute/shifter_result
add wave -noupdate -expand -group execute /main/DUT/execute/shifter_req_d0
add wave -noupdate -expand -group execute /main/DUT/execute/shifter_req
add wave -noupdate -expand -group execute /main/DUT/execute/shifter_stall_req
add wave -noupdate -expand -group execute /main/DUT/execute/is_load
add wave -noupdate -expand -group execute /main/DUT/execute/is_store
add wave -noupdate -expand -group writeback /main/DUT/writeback/clk_i
add wave -noupdate -expand -group writeback /main/DUT/writeback/rst_i
add wave -noupdate -expand -group writeback /main/DUT/writeback/w_stall_i
add wave -noupdate -expand -group writeback /main/DUT/writeback/w_stall_req_o
add wave -noupdate -expand -group writeback /main/DUT/writeback/x_fun_i
add wave -noupdate -expand -group writeback /main/DUT/writeback/x_load_i
add wave -noupdate -expand -group writeback /main/DUT/writeback/x_store_i
add wave -noupdate -expand -group writeback /main/DUT/writeback/x_dm_addr_i
add wave -noupdate -expand -group writeback /main/DUT/writeback/x_rd_i
add wave -noupdate -expand -group writeback /main/DUT/writeback/x_rd_value_i
add wave -noupdate -expand -group writeback /main/DUT/writeback/x_rd_write_i
add wave -noupdate -expand -group writeback /main/DUT/writeback/dm_data_l_i
add wave -noupdate -expand -group writeback /main/DUT/writeback/dm_load_done_i
add wave -noupdate -expand -group writeback /main/DUT/writeback/dm_store_done_i
add wave -noupdate -expand -group writeback /main/DUT/writeback/rf_rd_value_o
add wave -noupdate -expand -group writeback /main/DUT/writeback/rf_rd_o
add wave -noupdate -expand -group writeback /main/DUT/writeback/rf_rd_write_o
add wave -noupdate -expand -group writeback /main/DUT/writeback/load_value
TreeUpdate [SetDefaultTree]
WaveRestoreCursors {{Cursor 1} {140034 ps} 0}
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
WaveRestoreZoom {0 ps} {289276 ps}
