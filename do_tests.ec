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

ec test write_header_
   truncate test_header
   call_write_header_
   ec expect ||[contents example_header -nl] ||[contents test_header -nl]
-TEST_END

ec test read_header_
   ec expect
&- For some reason, the `call` command prints an extra leading newline, which
&- we must account for in this test.  Note that the file example_code already
&- contains a leading newline.
&+   [flnnl "^/padding size: 8^/used: 83^a" ||[contents example_code -nl]]
&+   ||[call call_read_header_ 0 ;||]
-TEST_END

ec test compress_
   truncate test_fz
   call_compress_
   ec expect ||[contents c12345_fz -nl] ||[contents test_fz -nl]
-TEST_END

ec test decompress_
   truncate test_unfz
   call_decompress_
   ec expect ||[contents c12345 -nl] ||[contents test_unfz -nl]
-TEST_END

&set n &[value_get tests_passed]
&set d &[value_get tests_run]
&set percent &[calc &(n)/&(d)*100]
&set r &[round &(percent) [plus [index &(percent). .] 1]]
format_line "^/^d of ^d tests passed (^a%)." &(n) &(d) &(r)
value_delete tests_passed
value_delete tests_run
