&version 2
&trace &command off
&if &[not [equal ||[call match_star_name_ &r1 ||[value_get tests_match]
&+					  -out -code -ret]
&+		 ""]] &then &do
   ec get_block ;| discard_
   &quit
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

io close test_commands
io detach test_commands
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
