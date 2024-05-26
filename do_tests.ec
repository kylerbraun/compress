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

ec test nullary
   ec check_error compress [fl "compress: Expected argument missing.
				&+ Usage: compress path {-control_args}^/"]
-TEST_END

ec test nullary_uncompress
   ec check_error uncompress [fl "uncompress: Expected argument missing.
				  &+ Usage: uncompress path {-control_args}^/"]
-TEST_END

ec test not_found
   ec check_error "compress nonexistent"
&+		  [fl "compress: Entry not found. Could not initiate
		       &+ input segment ^a>nonexistent.^/" [wd]]
-TEST_END

ec test not_found_uncompress
   ec check_error "uncompress nonexistent"
&+		  [fl "uncompress: Entry not found. Could not initiate
		       &+ input segment ^a>nonexistent.fz.^/" [wd]]
-TEST_END

ec test bad_option
   ec check_error "compress -nonexistent"
&+		  [fl "compress: Specified control argument is not accepted.
		       &+ -nonexistent^/"]
-TEST_END

ec test extra_arg
   ec check_error "compress file file2"
&+		  [fl "compress: Usage: compress path {-control_args}^/"]
-TEST_END

ec test too_long
   ec check_error "compress this_entryname_is_more_than_32_character_long"
&+		  [fl "compress: Entry name too long. Could not expand input
		       &+ pathname.^/"]
-TEST_END

&set n &[value_get tests_passed]
&set d &[value_get tests_run]
&set percent &[calc &(n)/&(d)*100]
&set r &[round &(percent) [plus [index &(percent). .] 1]]
format_line "^/^d of ^d tests passed (^a%)." &(n) &(d) &(r)
value_delete tests_passed
value_delete tests_run
