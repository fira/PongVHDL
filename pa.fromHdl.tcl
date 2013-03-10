
# PlanAhead Launch Script for Pre-Synthesis Floorplanning, created by Project Navigator

create_project -name SuperPONG -dir "E:/Theo/Documents/PR202/SuperPONG/planAhead_run_1" -part xc3s100ecp132-4
set_param project.pinAheadLayout yes
set srcset [get_property srcset [current_run -impl]]
set_property top ctrlVGA_test $srcset
set_param project.paUcfFile  "ctrlVGA_test.ucf"
set hdlfile [add_files [list {Counter.vhd}]]
set_property file_type VHDL $hdlfile
set_property library work $hdlfile
set hdlfile [add_files [list {clkdivider.vhd}]]
set_property file_type VHDL $hdlfile
set_property library work $hdlfile
set hdlfile [add_files [list {ctrlVGA.vhd}]]
set_property file_type VHDL $hdlfile
set_property library work $hdlfile
set hdlfile [add_files [list {ctrlVGA_test.vhd}]]
set_property file_type VHDL $hdlfile
set_property library work $hdlfile
add_files "ctrlVGA_test.ucf" -fileset [get_property constrset [current_run]]
add_files -norecurse { {E:/Theo/Documents/PR202/SuperPONG} }
open_rtl_design -part xc3s100ecp132-4
