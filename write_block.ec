&version 2
&trace &command off
io attach test_commands vfile_ &r1 -truncate
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
