&version 2
&trace &command off
&set result """"""
io attach test_discard discard_
io open test_discard stream_output
syn_output test_discard
&label loop
   &set line &||[io get_line user_input -allow_newline]
   &if &[equal &(line) "-TEST_END&NL"] &then &do
      &goto loop_end
   &end
   &set result &||[format_line_nnl "^a^a" &(result) &(line)]
   &goto loop
&label loop_end
revert_output
io close test_discard
io detach test_discard
&return &(result)
