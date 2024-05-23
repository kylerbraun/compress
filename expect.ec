&version 2
&trace &command off
&if &[not [equal &r1 &r2]]
   &then &signal test_fail
