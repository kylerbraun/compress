&version 2
&trace &command off
&set prefix &[value_get test_prefix]
value_set &(prefix).&1 [fl "^a^a" ||[value_get &(prefix).&1 -default ""]
&+				  [ec get_block]]
&+	  -perprocess
