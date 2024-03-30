set AGM_SUPRA true
set sh_continue_on_error false
set sh_echo_on_source  true
set sh_quiet_on_source true

if { ! [info exist AF_PREPARE_TEMPL] } {
  set AF_PREPARE_TEMPL ""
}
if { ! [info exist AF_SDC_TEMPL] } {
  set AF_SDC_TEMPL ""
}
if { ! [info exist AF_IP_TEMPL] } {
  set AF_IP_TEMPL ""
}
if { ! [info exist QUARTUS_DIR] } {
  set QUARTUS_DIR "."
}
if { ! [info exist DERATE_SDC] } {
  set DERATE_SDC "None"
}
if { ! [info exist VE_FILE] } {
  set VE_FILE ""
}

file mkdir [file join . alta_logs]
alta::begin_log_cmd [file join . alta_logs prepare.log] [file join . alta_logs prepare.err]
alta::tcl_whisper "Cmd : [alta::prog_path] [alta::prog_version]([alta::prog_subversion])\n"
alta::tcl_whisper "Args : $tcl_cmd_args\n"

load_architect -no_route -type ${DEVICE} 1 1 1000 1000

set ret [alta::prepareRun "${AF_PREPARE_TEMPL}" "${AF_SDC_TEMPL}" "${AF_IP_TEMPL}" \
                        "${QUARTUS_DIR}" "${DERATE_SDC}" \
                        "${DEVICE}" "${VE_FILE}" "${WORK_DIR}"]
if { !$ret } { exit -1 }

alta::tcl_print "\nPrepare done...\n"
alta::tcl_print "Next, compile with quartus using one of following 2 approaches:\n"
alta::tcl_print " 1) Command line base, run \'quartus_sh -t af_prepare.tcl <design>\'\n"
alta::tcl_print " 2) GUI base, start quartus GUI, open project <design>,\n"
alta::tcl_print "    select Tools->Tcl Scripts..., load af_prepare.tcl and run\n"
alta::tcl_print "Then, run \'af_setup\' to setup <design> for migration\n"

exit
