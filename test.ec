&version 2
&trace &command off
&set prefix &[value_get test_prefix]
&if &[not [equal ||[call match_star_name_ &r1 ||[value_get &(prefix).match]
&+					  -out -code -ret]
&+		 ""]] &then &do
   io move_attach user_output &!.save_output
   io attach user_output discard_
   io open user_output stream_output
   &label discard_loop
      &set line &||[io get_line user_input -allow_newline]
      &if &[equal &(line) "-TEST_END&NL"] &then &do
	 io (close detach) user_output
	 io move_attach &!.save_output user_output
	 io destroy_iocb &!.save_output
	 &quit
      &end
   &goto discard_loop
&end
io put_chars user_output "Running test &q1... " -remove_newline
io attach &!.ec vfile_ &!.ec -truncate
io open &!.ec stream_output

io put_chars &!.ec [fl "&&version 2^/&&trace &&command off^/
&+ &&on cleanup &&begin^/
&+^a&&end^/
&+^a^a^a"
&+		       ||[value_get &(prefix).teardown -default ""]
&+		       ||[value_get &(prefix).setup -default ""]
&+		       [ec get_block]
&+		       ||[value_get &(prefix).teardown -default ""]]

io (close detach destroy_iocb) &!.ec
&set failed false
&on test_fail &begin
   &goto inc_run
&end
&on any_other &begin
   &if &[not &(failed)]
      &then &print FAIL
   &set failed true
   &if &[not [equal &condition_name command_error]]
      &then &exit &continue
&end
&on program_interrupt &begin
   &set failed true
   &goto continue
&end
&on cleanup &begin
  delete ([files &!.ec])
&end
ec &!
&revert any_other
&if &(failed)
   &then &goto inc_run
&print PASS
value_set &(prefix).passed -add 1
&label inc_run
delete &!.ec
value_set &(prefix).run -add 1
&quit
&label continue
&signal test_continue
&goto inc_run
