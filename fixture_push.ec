&version 2
&trace &command off
&set prefix &[value_get test_prefix]
&if &[not [value_defined &(prefix).p_setup_len]]
   &then value_set -perprocess &(prefix).p_setup_len 0
&if &[not [value_defined &(prefix).p_teardown_len]]
   &then value_set -perprocess &(prefix).p_teardown_len 0
value_set -push &(prefix).p_setup_len
&+        [length ||[value_get &(prefix).setup -default ""]]
value_set -push &(prefix).p_teardown_len
&+        [length ||[value_get &(prefix).teardown -default ""]]
