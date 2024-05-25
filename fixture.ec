&version 2
&trace &command off
value_set test_&1 [format_line_nnl "^a^a"
&+		   [substr ||[value_get test_&1] 1
&+			   [value_get test_prev_&1_length -default 0]]
&+		   [ec get_block]]
