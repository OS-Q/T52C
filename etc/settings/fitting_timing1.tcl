 set pl_criticality_wratio  "2.50 2.50 2.50 1.00"
#set pl_max_iter_eco        "10 20 300 40 3  100 100 1"
##et pl_eco_slack_crit      "99999. 1.00  0.10 7 0.03 30 0.01 150"

##et pl_priority_compare  "2 2 2 3"
#set pl_priority_result   "2 1 1 0"
#set pl_priority_pass     "2 1 1 0"
#set pl_swap_cost_margin       "200.0  0.0  200.0  0.0  200.0  0.0   0.00  0.0"
 set pl_swap_wirelength_margin "200.0  0.0  200.0  0.0  200.0  0.0   020.0 -0.3  2000. 1.50"
 set pl_swap_congestion_margin "100.0  0.0  100.0  0.0  100.0  0.0   010.0 -0.3  1000. 1.25"
#set pl_criticality_beta "1.0 3.0 1.0  1.0 3.0 1.0  1.0 3.0 1.0  99999 3.0 3.0"

 set rt_retiming_idx         5
 set rt_converge_accelerator "2 1 0 3"
#set rt_pres_cost_ratio      "1.00 1.50  2.00 2.50"
 set rt_dly_ratio            "0.55 0.35 0.30  0.50 0.50 0.30"
 set rt_reroute_max_iter     "6  5 6  7 9  12"
 set rt_reroute_start_iter   "0  1 2  2 4  0 "
 set rt_quick_converge_ratio 0.25
