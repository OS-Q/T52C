set AGM_SUPRA true
set sh_continue_on_error false
set sh_echo_on_source  true
set sh_quiet_on_source true

if { ! [info exists MODE] } { set MODE "QUARTUS" }
if { ! [info exist TOP_MODULE] } {
  set TOP_MODULE {}
}
if { ! [info exist IP_FILES] } {
  set IP_FILES {}
}
if { ! [info exist VERILOG_FILES] } {
  set VERILOG_FILES {}
}
if { ! [info exist VQM_FILES] } {
  set VQM_FILES {}
}
if { ! [info exist VHDL_FILES] } {
  set VHDL_FILES {}
}
if { ! [info exist AF_QUARTUS_TEMPL] } {
  set AF_QUARTUS_TEMPL ""
}
if { ! [info exist AF_QUARTUS] } {
  set AF_QUARTUS ""
}
if { ! [info exist AF_MAP_TEMPL] } {
  set AF_MAP_TEMPL ""
}
if { ! [info exist AF_MAP] } {
  set AF_MAP ""
}
if { ! [info exist AF_RUN_TEMPL] } {
  set AF_RUN_TEMPL ""
}
if { ! [info exist AF_RUN] } {
  set AF_RUN ""
}
if { ! [info exist AF_BATCH_TEMPL] } {
  set AF_BATCH_TEMPL ""
}
if { ! [info exist AF_BATCH] } {
  set AF_BATCH ""
}
if { ! [info exist AF_IP_TEMPL] } {
  set AF_IP_TEMPL ""
}
if { ! [info exist AF_IP] } {
  set AF_IP ""
}
if { ! [info exists VE_FILE] } {
  set VE_FILE ""
}
if { ! [info exist ORIGINAL_DIR] } {
  set ORIGINAL_DIR ""
}
if { ! [info exist ORIGINAL_OUTPUT] } {
  set ORIGINAL_OUTPUT ""
}
if { ! [info exist ORIGINAL_QSF] } {
  set ORIGINAL_QSF ""
}
if { ! [info exist ORIGINAL_PIN] } {
  set ORIGINAL_PIN ""
}
if { ! [info exist GCLK_CNT] } {
  set GCLK_CNT 0
}
if { ! [info exist USE_DESIGN_TEMPL] } {
  set USE_DESIGN_TEMPL false
}

file mkdir [file join . alta_logs]
alta::begin_log_cmd [file join . alta_logs setup.log] [file join . alta_logs setup.err]
alta::tcl_whisper "Cmd : [alta::prog_path] [alta::prog_version]([alta::prog_subversion])\n"
alta::tcl_whisper "Args : $tcl_cmd_args\n"

if { [info exists TIMING_DERATE] } {
  set ar_timing_derate ${TIMING_DERATE}
}

load_architect -no_route -type ${DEVICE} 1 1 1000 1000
foreach ip_file $IP_FILES {
  read_ip $ip_file
}

if { [info exist DEVICE_FAMILY] } {
  set db_target_device_family $DEVICE_FAMILY
}
set ret [alta::setupRun ${DESIGN} ${TOP_MODULE} \
                        "${IP_FILES}" \
                        "${VERILOG_FILES}" \
                        "${VQM_FILES}" \
                        "${VHDL_FILES}" \
                        "${AF_QUARTUS_TEMPL}" "${AF_QUARTUS}" \
                        "${AF_IP_TEMPL}" "${AF_IP}" \
                        "${AF_MAP_TEMPL}" "${AF_MAP}" \
                        "${AF_RUN_TEMPL}" "${AF_RUN}" \
                        "${AF_BATCH_TEMPL}" "${AF_BATCH}" \
                        "${VE_FILE}" \
                        "${WORK_DIR}" "${ORIGINAL_DIR}" "${ORIGINAL_OUTPUT}" \
                        "${ORIGINAL_QSF}" "${ORIGINAL_PIN}" \
                        "${GCLK_CNT}" "${USE_DESIGN_TEMPL}"]
if { !$ret } { exit -1 }

alta::tcl_print "\nSetup done...\n"
alta::tcl_print "Next, compile with quartus using one of following 2 approaches:\n"
alta::tcl_print " 1) Command line base, run \'quartus_sh -t af_quartus.tcl\'\n"
alta::tcl_print " 2) GUI base, start quartus GUI, open project ${DESIGN},\n"
alta::tcl_print "    select Tools->Tcl Scripts..., load af_quartus.tcl and run\n"
alta::tcl_print "Then, run \'af_run\' to generate ${DESIGN} bit-stream files\n"

exit
