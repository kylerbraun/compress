&version 2
&trace &command off
&set result """"""
io move_attach user_output test_save_&!
io attach user_output discard_
io open user_output stream_output
&label loop
   &set line &||[io get_line user_input -allow_newline]
   &if &[equal &(line) "-TEST_END&NL"] &then &do
      &goto loop_end
   &end
   &set result &||[format_line_nnl "^a^a" &(result) &(line)]
   &goto loop
&label loop_end
io (close detach) user_output
io move_attach test_save_&! user_output
io destroy_iocb test_save_&!
&return &(result)
