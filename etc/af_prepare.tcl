set AGM_SUPRA true

if { [is_project_open] } {
  export_assignments
}
qexec "[file join $::quartus(binpath) quartus_sh] -t af_ip.tcl $::quartus(project)"

load_package flow
if { ! [is_project_open] } {
  if { [llength $quartus(args)] == 0 } {
    return false
  } else {
    project_open [lindex $quartus(args) 0]
  }
}

### Setup ModelSim ###
set_global_assignment -name EDA_SIMULATION_TOOL "ModelSim (Verilog)"

### Setup Timing Derate ###
set_global_assignment -name SDC_FILE [file join . af_prepare.sdc]

### Run Compile ###
set PIN_MAP "__device_pinmap__"
set VE_FILE "__ve_file__"
if { [file exists $VE_FILE] && [file exist $PIN_MAP] } {
  puts "Processing $VE_FILE with $PIN_MAP"
  set pin_map [open $PIN_MAP r]
  while { [gets $pin_map line] >= 0 } {
    set words [regexp -all -inline {\S+} $line]
    if { [llength $words] >= 2 } {
      set pin_map_arr([lindex $words 0]) [lindex $words 1]
    }
  }
  set ve_file [open $VE_FILE r]
  while { [gets $ve_file line] >= 0 } {
    set words [regexp -all -inline {\S+} $line]
    if { [llength $words] >= 2 } {
      set pin [lindex $words 0]
      set loc [lindex $words 1]
      if { [string index $pin 0] == "#" } {
        continue
      }
      if { [info exists pin_map_arr($loc)] } {
        set_location_assignment $pin_map_arr($loc) -to $pin
      }
    }
  }
}

set_global_assignment -name MAX_GLOBAL_CLOCKS_ALLOWED __max_global_clock__

### Area Reserve Regions ###
__area_reserve_regions__

export_assignments -reorganize
execute_flow -compile
