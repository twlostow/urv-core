sim_tool = "modelsim"
top_module="main"
syn_device="xc6slx150t"

action = "simulation"
target = "xilinx"
include_dirs=["."]

files = [ "main.sv",
          "rv_cpu.v",
          "rv_exec.v",
          "rv_fetch.v",
          "rv_predecode.v",
          "rv_regfile.v",
          "rv_writeback.v",
          "rv_shifter.v"];
