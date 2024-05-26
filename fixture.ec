&version 2
&trace &command off
value_set test_&1 [fl "^a^a" ||[value_get test_&1 -default ""] [ec get_block]]
&+	  -perprocess
