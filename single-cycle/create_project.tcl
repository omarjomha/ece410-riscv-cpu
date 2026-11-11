# ---------------------------------------------------------------------------
# create_project.tcl  --  (re)build the Vivado project for the single-cycle CPU
#
# From a Vivado Tcl Console (or `vivado -mode batch -source create_project.tcl`):
#     source <repo>/single-cycle/create_project.tcl
#
# Creates ./vivado/single_cycle.xpr (git-ignored) with:
#   src/*  -> Design Sources      (top: single_cycle_riscv)
#   tb/*   -> Simulation Sources  (sim_1)
# Files are referenced in place, so edits in Vivado land directly in src/ and tb/.
# ---------------------------------------------------------------------------

set here     [file dirname [file normalize [info script]]]
set proj_dir [file join $here vivado]
set part     xc7z010clg400-1

create_project single_cycle $proj_dir -part $part -force
set_property target_language    VHDL [current_project]
set_property simulator_language VHDL [current_project]

set srcs [lsort [glob -nocomplain -directory [file join $here src] *.vhd *.vhdl]]
set tbs  [lsort [glob -nocomplain -directory [file join $here tb]  *.vhd *.vhdl]]

if {[llength $srcs]} { add_files -norecurse -fileset sources_1 $srcs }
if {[llength $tbs]}  { add_files -norecurse -fileset sim_1     $tbs }

set_property top single_cycle_riscv [get_filesets sources_1]
set_property top single_cycle_riscv_tb [get_filesets sim_1]
set_property top_lib xil_defaultlib [get_filesets sim_1]

update_compile_order -fileset sources_1
update_compile_order -fileset sim_1

puts "Project created: [file join $proj_dir single_cycle.xpr]"
puts "  Design sources : [llength $srcs]"
puts "  Testbenches    : [llength $tbs]"
