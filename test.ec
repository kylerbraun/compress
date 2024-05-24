&version 2
&trace &command off
io put_chars user_output "Running test &q1... " -remove_newline
io attach test_commands vfile_ test_commands.ec -truncate
io open test_commands stream_output
io put_chars test_commands "&&version 2&NL&&trace &&command off"
io attach test_discard discard_
io open test_discard stream_output
syn_output test_discard
&label loop
   &set line &||[io get_line user_input -allow_newline]
   &if &[equal &q(line) "-TEST_END&NL"] &then &do
      &goto loop_end
   &end
   io put_chars test_commands &q(line) -allow_newline
   &goto loop
&label loop_end
revert_output
io close test_discard
io detach test_discard
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
ec test_commands
&revert command_error
&if &(failed)
   &then &goto inc_run
&print PASS
value_set tests_passed -add 1
&label inc_run
delete test_commands.ec
value_set tests_run -add 1
