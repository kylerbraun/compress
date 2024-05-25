&version 2
&trace &command off
&if &[not [value_defined test_prev_setup_length]]
   &then value_set -perprocess test_prev_setup_length 0
&if &[not [value_defined test_prev_teardown_length]]
   &then value_set -perprocess test_prev_teardown_length 0
value_set -push test_prev_setup_length
&+	  [length ||[value_get test_setup -default ""]]
value_set -push test_prev_teardown_length
&+	  [length ||[value_get test_teardown -default ""]]
