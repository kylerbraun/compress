&version 2
&trace &command off
&attach
value_set tests_passed 0 -perprocess
value_set tests_run 0 -perprocess

ec test print_counts_
   ec expect ||[contents example_counts -nl] ||[call_print_counts_ ;||]
-TEST_END

ec test count_bytes_
   ec expect ||[contents c12345_counts -nl] ||[call_count_bytes_ ;||]
-TEST_END

ec test print_code_
   ec expect ||[contents example_code -nl] ||[call call_print_code_ 0 ;||]
-TEST_END

ec test make_code_
   ec expect ||[contents c12345_code -nl] ||[call call_make_code_ 0 ;||]
-TEST_END

&set n [value_get tests_passed]
&set d [value_get tests_run]
&set percent [calc &(n)/&(d)*100]
format_line "^/^d of ^d tests passed (^d%)." &(n) &(d)
&+	    [round &(percent) [plus [index &(percent) .] 2]]
value_delete tests_passed
value_delete tests_run
