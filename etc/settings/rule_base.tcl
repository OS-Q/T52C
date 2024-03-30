alta::tcl_highlight_err "\n<<< Default rule check >>>\n"

alta::start_check_cmd

if { true } {
alta::tcl_highlight_err "\n*** Check PLL...\n"
#check_pll_phase_lock
check_pll_phase_xref
}

alta::tcl_highlight_err "\n*** Check clock skew...\n"
check_clock_skew

alta::tcl_highlight_err "\n*** Check clock cycle...\n"
check_half_cycle

alta::tcl_highlight_err "\n*** Check global route...\n"
check_global_route

if { false } {
alta::tcl_highlight_err "\n*** Check constraints...\n"
check_uncontraint_path
}

alta::end_check_cmd
