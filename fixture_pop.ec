&version 2
&trace &command off
&set prefix &[value_get test_prefix]
&set substr
&+ &"execute_string ""if [nequal [length ||[substr &r1 &2 &3]] 0] -then """""""""""""""""""""""" -else ||[substr &r1 &r2 &r3]"""
value_set &(prefix).setup [&(substr) ||[value_get &(prefix).setup] 1
&+				     [value_get &(prefix).p_setup_len]]
value_set &(prefix).teardown [&(substr) ||[value_get &(prefix).teardown] 1
&+					[value_get &(prefix).p_teardown_len]]
value_set -pop &(prefix).p_(setup teardown)_len
