&version 2
&trace &command off
io_call put_chars user_output "Running test &q1... " -remove_newline
file_output test_commands.ec
io_call put_chars user_output "&&version 2&NL&&trace &&command off"
&label loop
   &set line &||[io_call get_line user_input -allow_newline]
   &if &[equal &q(line) "-TEST_END&NL"] &then &do
      &goto loop_end
   &end
   io_call put_chars user_output &q(line) -allow_newline
   &goto loop
&label loop_end
revert_output
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
