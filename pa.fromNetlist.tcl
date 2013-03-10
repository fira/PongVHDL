
# PlanAhead Launch Script for Post-Synthesis pin planning, created by Project Navigator

create_project -name SuperPONG -dir "E:/Theo/Documents/PR202/SuperPONG/planAhead_run_1" -part xc3s100ecp132-4
set_property design_mode GateLvl [get_property srcset [current_run -impl]]
set_property edif_top_file "E:/Theo/Documents/PR202/SuperPONG/ctrlVGA_test.ngc" [ get_property srcset [ current_run ] ]
add_files -norecurse { {E:/Theo/Documents/PR202/SuperPONG} }
set_param project.pinAheadLayout  yes
set_param project.paUcfFile  "ctrlVGA_test.ucf"
add_files "ctrlVGA_test.ucf" -fileset [get_property constrset [current_run]]
open_netlist_design
