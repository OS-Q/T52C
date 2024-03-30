# Aggressive hold fix, including cross clock and IO scope

 set ta_cross_clock_slack "2 2"

#set pl_max_iter_hold_fix "30 1 3"
 set pl_hold_slack_margin  0.2
 set pl_setup_slack_margin "0.5 -1000."
 set pl_net_hold_fix_target "alta_bram alta_bram9k alta_mult"

 set rt_hold_slack_margin  "0.2 0.2    0.2 0.2    0.7 0.7   0.0 0.0"
 set rt_setup_slack_margin "0.5 -1000. 0.5 -1000. 0.0 -1000."
#set rt_net_hold_crit_minmax "0.5 0.5"
 set rt_net_hold_budget_method 2
#set rt_net_hold_fix_target ""

#set pl_net_hold_fix_clock false
 set pl_net_hold_fix_auto  true
 set pl_net_hold_fix_io    true
#set rt_net_hold_fix_start false
#set rt_net_hold_fix_clock false
 set rt_net_hold_fix_auto  true
 set rt_net_hold_fix_io    true
