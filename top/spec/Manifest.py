files = ["spec_top.vhd", 
	 "spec_top.ucf",
	 "reset_gen.vhd" ]

fetchto = "../../ip_cores"

files = ["../../rtl/xrv_core.vhd", "spec_top.vhd", "reset_gen.vhd", "spec_top.ucf" ];

modules = {
    "local" : ["../../rtl/", "../../ip_cores/general-cores" ]
    }
