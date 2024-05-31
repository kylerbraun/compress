&version 2
&trace &command off
&set prefix &[value_get test_prefix]
&set substr
&+ &"execute_string ""if [nequal [length ||[substr &r1 &2 &3]] 0] -then """""""""""""""""""""""" -else ||[substr &r1 &r2 &r3]"""
value_set -perprocess &(prefix).setup
&+	  [&(substr) ||[value_get &(prefix).setup -default ""] 1
&+		     [value_get &(prefix).p_setup_len]]
value_set -perprocess &(prefix).teardown
&+		      [&(substr) ||[value_get &(prefix).teardown -default ""] 1
&+				 [value_get &(prefix).p_teardown_len]]
value_set -pop &(prefix).p_(setup teardown)_len
