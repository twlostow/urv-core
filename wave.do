onerror {resume}
quietly WaveActivateNextPane {} 0
add wave -noupdate -group F /main/DUT/fetch/clk_i
add wave -noupdate -group F /main/DUT/fetch/rst_i
add wave -noupdate -group F /main/DUT/fetch/im_addr_o
add wave -noupdate -group F /main/DUT/fetch/im_data_i
add wave -noupdate -group F /main/DUT/fetch/im_valid_i
add wave -noupdate -group F /main/DUT/fetch/f_stall_i
add wave -noupdate -group F /main/DUT/fetch/f_kill_i
add wave -noupdate -group F /main/DUT/fetch/f_ir_o
add wave -noupdate -group F /main/DUT/fetch/f_pc_o
add wave -noupdate -group F /main/DUT/fetch/f_pc_plus_4_o
add wave -noupdate -group F /main/DUT/fetch/f_valid_o
add wave -noupdate -group F /main/DUT/fetch/x_pc_bra_i
add wave -noupdate -group F /main/DUT/fetch/x_bra_i
add wave -noupdate -group F /main/DUT/fetch/pc
add wave -noupdate -group F /main/DUT/fetch/ir
add wave -noupdate -group F /main/DUT/fetch/rst_d
add wave -noupdate -group F /main/DUT/fetch/pc_next
add wave -noupdate -group D /main/DUT/decode/clk_i
add wave -noupdate -group D /main/DUT/decode/rst_i
add wave -noupdate -group D /main/DUT/decode/d_stall_i
add wave -noupdate -group D /main/DUT/decode/d_kill_i
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
add wave -noupdate -group D /main/DUT/decode/f_rs1
add wave -noupdate -group D /main/DUT/decode/f_rs2
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
add wave -noupdate -expand -group X /main/DUT/execute/d_opcode_i
add wave -noupdate -expand -group X /main/DUT/execute/d_shifter_sign_i
add wave -noupdate -expand -group X /main/DUT/execute/f_branch_target_o
add wave -noupdate -expand -group X /main/DUT/execute/f_branch_take_o
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
add wave -noupdate -expand -group X /main/DUT/execute/rd_write
add wave -noupdate -expand -group X /main/DUT/execute/cmp_op1
add wave -noupdate -expand -group X /main/DUT/execute/cmp_op2
add wave -noupdate -expand -group X /main/DUT/execute/cmp_rs
add wave -noupdate -expand -group X /main/DUT/execute/cmp_equal
add wave -noupdate -expand -group X /main/DUT/execute/cmp_lt
add wave -noupdate -expand -group X /main/DUT/execute/shifter_result
add wave -noupdate -expand -group X /main/DUT/execute/alu_addsub_op1
add wave -noupdate -expand -group X /main/DUT/execute/alu_addsub_op2
add wave -noupdate -expand -group X /main/DUT/execute/alu_addsub_result
add wave -noupdate -expand -group X /main/DUT/execute/shifter_req_d0
add wave -noupdate -expand -group X /main/DUT/execute/shifter_req
add wave -noupdate -expand -group X /main/DUT/execute/shifter_stall_req
add wave -noupdate -expand -group X /main/DUT/execute/is_load
add wave -noupdate -expand -group X /main/DUT/execute/is_store
add wave -noupdate -group W /main/DUT/writeback/clk_i
add wave -noupdate -group W /main/DUT/writeback/rst_i
add wave -noupdate -group W /main/DUT/writeback/w_stall_i
add wave -noupdate -group W /main/DUT/writeback/w_stall_req_o
add wave -noupdate -group W /main/DUT/writeback/interlock_d
add wave -noupdate -group W /main/DUT/writeback/interlock
add wave -noupdate -group W /main/DUT/writeback/x_fun_i
add wave -noupdate -group W /main/DUT/writeback/x_load_i
add wave -noupdate -group W /main/DUT/writeback/x_load_hazard_i
add wave -noupdate -group W /main/DUT/writeback/x_store_i
add wave -noupdate -group W /main/DUT/writeback/x_dm_addr_i
add wave -noupdate -group W /main/DUT/writeback/x_rd_i
add wave -noupdate -group W /main/DUT/writeback/x_rd_value_i
add wave -noupdate -group W /main/DUT/writeback/x_rd_write_i
add wave -noupdate -group W /main/DUT/writeback/dm_data_l_i
add wave -noupdate -group W /main/DUT/writeback/dm_load_done_i
add wave -noupdate -group W /main/DUT/writeback/dm_store_done_i
add wave -noupdate -group W /main/DUT/writeback/rf_rd_value_o
add wave -noupdate -group W /main/DUT/writeback/rf_rd_o
add wave -noupdate -group W /main/DUT/writeback/rf_rd_write_o
add wave -noupdate -group W /main/DUT/writeback/load_value
add wave -noupdate -group Top /main/DUT/clk_i
add wave -noupdate -group Top /main/DUT/rst_i
add wave -noupdate -group Top /main/DUT/im_addr_o
add wave -noupdate -group Top /main/DUT/im_data_i
add wave -noupdate -group Top /main/DUT/im_valid_i
add wave -noupdate -group Top /main/DUT/dm_addr_o
add wave -noupdate -group Top /main/DUT/dm_data_s_o
add wave -noupdate -group Top /main/DUT/dm_data_l_i
add wave -noupdate -group Top /main/DUT/dm_data_select_o
add wave -noupdate -group Top /main/DUT/dm_ready_i
add wave -noupdate -group Top /main/DUT/dm_store_o
add wave -noupdate -group Top /main/DUT/dm_load_o
add wave -noupdate -group Top /main/DUT/dm_load_done_i
add wave -noupdate -group Top /main/DUT/dm_store_done_i
add wave -noupdate -group Top /main/DUT/f_stall
add wave -noupdate -group Top /main/DUT/w_stall
add wave -noupdate -group Top /main/DUT/x_stall
add wave -noupdate -group Top /main/DUT/x_kill
add wave -noupdate -group Top /main/DUT/f_kill
add wave -noupdate -group Top /main/DUT/f2d_pc
add wave -noupdate -group Top /main/DUT/f2d_pc_plus_4
add wave -noupdate -group Top /main/DUT/f2d_ir
add wave -noupdate -group Top /main/DUT/f2d_ir_valid
add wave -noupdate -group Top /main/DUT/x2f_pc_bra
add wave -noupdate -group Top /main/DUT/x2f_bra
add wave -noupdate -group Top /main/DUT/f2d_valid
add wave -noupdate -group Top /main/DUT/f_stall_req
add wave -noupdate -group Top /main/DUT/d2x_valid
add wave -noupdate -group Top /main/DUT/d2x_pc
add wave -noupdate -group Top /main/DUT/rf_rs1
add wave -noupdate -group Top /main/DUT/d2x_rs1
add wave -noupdate -group Top /main/DUT/rf_rs2
add wave -noupdate -group Top /main/DUT/d2x_rs2
add wave -noupdate -group Top /main/DUT/d2x_rd
add wave -noupdate -group Top /main/DUT/d2x_shamt
add wave -noupdate -group Top /main/DUT/d2x_fun
add wave -noupdate -group Top /main/DUT/d2x_opcode
add wave -noupdate -group Top /main/DUT/d2x_shifter_sign
add wave -noupdate -group Top /main/DUT/d_stall
add wave -noupdate -group Top /main/DUT/d_kill
add wave -noupdate -group Top /main/DUT/x2w_rd
add wave -noupdate -group Top /main/DUT/x2w_rd_value
add wave -noupdate -group Top /main/DUT/x2w_dm_addr
add wave -noupdate -group Top /main/DUT/x2w_rd_write
add wave -noupdate -group Top /main/DUT/x2w_fun
add wave -noupdate -group Top /main/DUT/x2w_store
add wave -noupdate -group Top /main/DUT/x2w_load
add wave -noupdate -group Top /main/DUT/x_rs2_value
add wave -noupdate -group Top /main/DUT/x_rs1_value
add wave -noupdate -group Top /main/DUT/rf_rd
add wave -noupdate -group Top /main/DUT/rf_rd_value
add wave -noupdate -group Top /main/DUT/rf_rd_write
add wave -noupdate -group Top /main/DUT/rf_bypass_rd_value
add wave -noupdate -group Top /main/DUT/rf_bypass_rd_write
add wave -noupdate -group Top /main/DUT/x_load_comb
add wave -noupdate -group Top /main/DUT/x_stall_req
add wave -noupdate -group Top /main/DUT/w_stall_req
add wave -noupdate -group Top /main/DUT/x2f_bra_d0
add wave -noupdate -group Top /main/DUT/x2f_bra_d1
TreeUpdate [SetDefaultTree]
WaveRestoreCursors {{Cursor 1} {31985000 ps} 0}
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
WaveRestoreZoom {13501336 ps} {50528664 ps}
