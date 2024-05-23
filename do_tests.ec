&version 2
&trace &command off
&attach
value_set tests_passed 0 -perprocess
value_set tests_run 0 -perprocess

ec test print_counts_
   ec expect [contents example_counts -nl] [call_print_counts_ ;|]
-TEST_END

&set n [value_get tests_passed]
&set d [value_get tests_run]
format_line "^/^d of ^d tests passed (^d%)." &(n) &(d) [calc &(n)/&(d)]
value_delete tests_passed
value_delete tests_run
