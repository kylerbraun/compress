&version 2
&trace &command off
&print_nnl "Running test &q1... "
file_output test_commands.ec
io_call put_chars user_output "&&version 2&NL&&trace &&command off&NL"
&label loop
   &set line &||[io_call get_line user_input -allow_newline]
   &if &[equal &r(line) "-TEST_END&NL"] &then &do
      &goto loop_end
   &end
   io_call put_chars user_output &r(line)
   &goto loop
&label end_loop
revert_output
&on error command_error compress_bad_code compress_fatal compress_test_fail
&+ &begin
   &print FAIL
   delete test_commands
   &goto inc_run
&end
ec test_commands
delete test_commands
&print PASS
value_set tests_passed -add 1
&label inc_run
value_set tests_run -add 1
