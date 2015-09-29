sim_tool = "modelsim"
top_module="main"
syn_device="xc6slx150t"

action = "simulation"
target = "xilinx"
include_dirs=["../../rtl"]

vcom_opt="-mixedsvvh l"

files = [ "main.sv" ];

modules = {"local" : [ "../../rtl" ] }