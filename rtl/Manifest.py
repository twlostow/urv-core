sim_tool = "modelsim"
top_module="main"
syn_device="xc6slx150t"

action = "simulation"
target = "xilinx"
include_dirs=["."]

files = [ "rv_cpu.v",
          "rv_exec.v",
          "rv_fetch.v",
          "rv_predecode.v",
          "rv_regfile.v",
          "rv_writeback.v",
          "rv_shifter.v",
          "rv_multiply.v",
          "rv_divide.v",
	  "rv_csr.v",
          "rv_timer.v",
          "rv_exceptions.v",
          "urv_iram.v",
	    "xrv_core.vhd" ];
#	  "../sim/rv_icache_model.sv"];
