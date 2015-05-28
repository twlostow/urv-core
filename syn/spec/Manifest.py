target = "xilinx"
action = "synthesis"

fetchto = "../../ip_cores"

syn_device = "xc6slx45t"
syn_grade = "-3"
syn_package = "fgg484"
syn_top = "spec_top"
syn_project = "rv_core_test.xise"
syn_tool = "ise"
top_module = "spec_top"

modules = { "local" : [ "../../top/spec" ] }
