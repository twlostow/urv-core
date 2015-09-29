onerror {resume}
quietly WaveActivateNextPane {} 0
add wave -noupdate /main/DUT/clk_i
add wave -noupdate /main/DUT/rst_i
add wave -noupdate -expand -group RF-old /main/DUT/regfile/clk_i
add wave -noupdate -expand -group RF-old /main/DUT/regfile/rst_i
add wave -noupdate -expand -group RF-old /main/DUT/regfile/d_stall_i
add wave -noupdate -expand -group RF-old /main/DUT/regfile/rf_rs1_i
add wave -noupdate -expand -group RF-old /main/DUT/regfile/rf_rs2_i
add wave -noupdate -expand -group RF-old /main/DUT/regfile/d_rs1_i
add wave -noupdate -expand -group RF-old /main/DUT/regfile/d_rs2_i
add wave -noupdate -expand -group RF-old /main/DUT/regfile/x_rs1_value_o
add wave -noupdate -expand -group RF-old /main/DUT/regfile/x_rs2_value_o
add wave -noupdate -expand -group RF-old /main/DUT/regfile/w_rd_i
add wave -noupdate -expand -group RF-old /main/DUT/regfile/w_rd_value_i
add wave -noupdate -expand -group RF-old /main/DUT/regfile/w_rd_store_i
add wave -noupdate -expand -group RF-old /main/DUT/regfile/w_bypass_rd_write_i
add wave -noupdate -expand -group RF-old /main/DUT/regfile/w_bypass_rd_value_i
add wave -noupdate -expand -group RF-old /main/DUT/regfile/rs1_regfile
add wave -noupdate -expand -group RF-old /main/DUT/regfile/rs2_regfile
add wave -noupdate -expand -group RF-old /main/DUT/regfile/write
add wave -noupdate -expand -group RF-old /main/DUT/regfile/rs1_bypass
add wave -noupdate -expand -group RF-old /main/DUT/regfile/rs2_bypass
add wave -noupdate -expand -group RF-old /main/DUT/regfile/bank0/bypass
add wave -noupdate -expand -group RF-new /main/DUT/regfile2/clk_i
add wave -noupdate -expand -group RF-new /main/DUT/regfile2/rst_i
add wave -noupdate -expand -group RF-new /main/DUT/regfile2/d_stall_i
add wave -noupdate -expand -group RF-new /main/DUT/regfile2/rf_rs1_i
add wave -noupdate -expand -group RF-new /main/DUT/regfile2/rf_rs2_i
add wave -noupdate -expand -group RF-new /main/DUT/regfile2/d_rs1_i
add wave -noupdate -expand -group RF-new /main/DUT/regfile2/d_rs2_i
add wave -noupdate -expand -group RF-new /main/DUT/regfile2/x_rs1_value_o
add wave -noupdate -expand -group RF-new /main/DUT/regfile2/x_rs2_value_o
add wave -noupdate -expand -group RF-new /main/DUT/regfile2/w_rd_i
add wave -noupdate -expand -group RF-new /main/DUT/regfile2/w_rd_value_i
add wave -noupdate -expand -group RF-new /main/DUT/regfile2/w_rd_store_i
add wave -noupdate -expand -group RF-new /main/DUT/regfile2/w_bypass_rd_write_i
add wave -noupdate -expand -group RF-new /main/DUT/regfile2/w_bypass_rd_value_i
add wave -noupdate -expand -group RF-new /main/DUT/regfile2/rs1_regfile
add wave -noupdate -expand -group RF-new /main/DUT/regfile2/rs2_regfile
add wave -noupdate -expand -group RF-new /main/DUT/regfile2/write
add wave -noupdate -expand -group RF-new /main/DUT/regfile2/rs1_bypass_x
add wave -noupdate -expand -group RF-new /main/DUT/regfile2/rs2_bypass_x
add wave -noupdate -expand -group RF-new /main/DUT/regfile2/rs1_bypass_w
add wave -noupdate -expand -group RF-new /main/DUT/regfile2/rs2_bypass_w
add wave -noupdate -expand -group RF-new /main/DUT/regfile2/bypass_w
TreeUpdate [SetDefaultTree]
WaveRestoreCursors {{Cursor 1} {1252556 ps} 0}
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
WaveRestoreZoom {21150368 ps} {21728928 ps}
