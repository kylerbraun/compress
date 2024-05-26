&version 2
&trace &command off
&if &[not [equal ||[call match_star_name_ &r1 ||[value_get tests_match]
&+					  -out -code -ret]
&+		 ""]] &then &do
   io move_attach user_output test_save_&!
   io attach user_output discard_
   io open user_output stream_output
   &label discard_loop
      &set line &||[io get_line user_input -allow_newline]
      &if &[equal &(line) "-TEST_END&NL"] &then &do
	 io (close detach) user_output
	 io move_attach test_save_&! user_output
	 &quit
      &end
   &goto discard_loop
&end
io put_chars user_output "Running test &q1... " -remove_newline
io attach test_commands vfile_ &!.ec -truncate
io open test_commands stream_output

io put_chars test_commands [format_line "&&version 2^/&&trace &&command off^/
&+ &&on error command_error compress_bad_code compress_fatal
     &+ compress_test_fail &&begin^/
&+^a&&exit &&continue^/
&+&&end^/
&+^a^a^a"
&+					||[value_get test_teardown -default ""]
&+					||[value_get test_setup -default ""]
&+					[ec get_block]
&+					||[value_get test_teardown -default ""]]

io (close detach) test_commands
&set failed false
&on error command_error compress_bad_code compress_fatal compress_test_fail
&+ &begin
   &print FAIL
   &if &[not [equal &condition_name command_error]]
      &then &goto inc_run
      &else &set failed true
&end
ec &!
&revert command_error
&if &(failed)
   &then &goto inc_run
&print PASS
value_set tests_passed -add 1
&label inc_run
delete &!.ec
value_set tests_run -add 1
