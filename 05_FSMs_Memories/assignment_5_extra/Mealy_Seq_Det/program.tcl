# Program the Nexys 4 DDR with seq_det_div3.bit over USB (JTAG)
#   vivado -mode batch -source program.tcl

open_hw_manager
connect_hw_server
open_hw_target

set dev [lindex [get_hw_devices xc7a100t*] 0]
current_hw_device $dev
refresh_hw_device -update_hw_probes false $dev
set_property PROGRAM.FILE ./seq_det_div3.bit $dev
program_hw_devices $dev

puts "FPGA programmed"
close_hw_target
disconnect_hw_server
close_hw_manager
