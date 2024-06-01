&version 2
&trace &command off
&set prefix &[value_get test_prefix]
&if &[not [equal &r1 &r2]] &then &do
   &if &[not [value_get &(prefix).failed]] &then &do
      &print FAIL
      value_set -perprocess &(prefix).failed true
   &end
   &print expected:&NL&r1&NLgot:&NL&r2
   &signal test_fail
&end
