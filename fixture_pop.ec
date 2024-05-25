&version 2
&trace &command off
value_set test_setup
&+        [substr ||[value_get test_setup] 1 [value_get test_prev_setup_length]]
value_set test_teardown
&+        [substr ||[value_get test_teardown] 1
&+		  [value_get test_prev_teardown_length]]
value_set -pop test_prev_setup_length
value_set -pop test_prev_teardown_length
