&version 2
&trace &command off
&if &[not [equal &r1 &r2]] &then &do
   &print FAIL
   &print expected:&NL&r1&NLgot: &r2
   &signal compress_test_fail
&end
