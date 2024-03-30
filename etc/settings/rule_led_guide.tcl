alta::tcl_highlight_err "\n<<< LED guide rule check >>>\n"

if { [info exist SDRAM_CHECK_METHOD] } {
  set chk_sdram_check_method $SDRAM_CHECK_METHOD
}
if { [info exist CLOCK_SKEW_LIMIT] } {
  set chk_clock_skew_limit $CLOCK_SKEW_LIMIT
}
if { [info exist HALF_CYCLE_LIMIT] } {
  set chk_half_cycle_limit $HALF_CYCLE_LIMIT
} 

#alta::check_variable_exist CRITICAL_INPUT CRITICAL_OUTPUT \
#                           SPI_SPI PHY_OUT PHY_OCTRL PHY_OCLK PHY_IN PHY_ICTRL PHY_ICLK \
#                           SDRAM_DATA SDRAM_ADDR SDRAM_CTRL SDRAM_CLK SDRAM_CLOCK
alta::start_check_cmd

if { ![alta::is_null CRITICAL_INPUT] || ![alta::is_null CRITICAL_OUTPUT] } {
  alta::tcl_highlight_err "\n*** Check critical IO...\n"
  check_critical_io -input "$CRITICAL_INPUT" -output "$CRITICAL_OUTPUT"
}

if { ![alta::is_null SPI_SPI] } {
  alta::tcl_highlight_err "\n*** Check SPI...\n"
  check_spi_flash_pin -spi $SPI_SPI
}

if { ![alta::is_null PHY_OUT] || ![alta::is_null PHY_IN] } {
  tcl_highlight_err "\n*** Check PHY...\n"
  check_phy_rx -in  $PHY_IN  -ctrl $PHY_ICTRL -clk $PHY_ICLK
  check_phy_tx -out $PHY_OUT -ctrl $PHY_OCTRL -clk $PHY_OCLK
}

if { ![alta::is_null SDRAM_DATA] } {
  alta::tcl_highlight_err "\n*** Check SDRAM...\n"
  check_sdram_input  -data $SDRAM_DATA
  check_sdram_output -data "$SDRAM_DATA $SDRAM_ADDR" -ctrl $SDRAM_CTRL -clk $SDRAM_CLK \
                     -clock $SDRAM_CLOCK
}

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
