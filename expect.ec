&version 2
&trace &command off
&if &[not [equal &r1 &r2]]
   &then &signal compress_test_fail
