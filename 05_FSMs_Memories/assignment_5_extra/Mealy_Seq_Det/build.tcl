# Vivado flow for seq_det_div3 (with top.v) on the Nexys 4 DDR
# Creates a saved Vivado project, runs synthesis + implementation,
# generates the bitstream and copies it next to this script.
#
# Run from the folder that holds top.v, seq_det_div3.v, seq_det_div3_tb.v and seq_det_div3.xdc:
#   vivado -mode batch -source build.tcl
#
# Open the saved project in the GUI afterwards:
#   vivado vivado_proj/seq_det_div3.xpr

set proj_name seq_det_div3
set proj_dir  ./vivado_proj
set part      xc7a100tcsg324-1
set top       top

# 1. Create and save the project
create_project $proj_name $proj_dir -part $part -force

add_files -norecurse {top.v seq_det_div3.v}
add_files -fileset constrs_1 -norecurse seq.xdc
add_files -fileset sim_1     -norecurse seq_det_div3_tb.v

set_property top $top             [current_fileset]
set_property top seq_det_div3_tb  [get_filesets sim_1]
update_compile_order -fileset sources_1

# 2. Synthesis
launch_runs synth_1 -jobs 4
wait_on_run synth_1
if {[get_property PROGRESS [get_runs synth_1]] != "100%"} {
    error "Synthesis failed - see $proj_dir/$proj_name.runs/synth_1/runme.log"
}

# 3. Implementation + bitstream
launch_runs impl_1 -to_step write_bitstream -jobs 4
wait_on_run impl_1
if {[get_property PROGRESS [get_runs impl_1]] != "100%"} {
    error "Implementation failed - see $proj_dir/$proj_name.runs/impl_1/runme.log"
}

# 4. Reports
open_run impl_1
report_utilization    -file ./utilization.rpt
report_timing_summary -file ./timing.rpt

# 5. Copy the bitstream here
file copy -force $proj_dir/$proj_name.runs/impl_1/$top.bit ./seq_det_div3.bit
puts "Done: bitstream written to ./seq_det_div3.bit"
