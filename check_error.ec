&version 2
&trace &command off
&set error false
&set redirected false

&on command_error &begin
   &set error true
   file_output &!.errors -source_switch error_output
   &set redirected true
&end

&on cleanup &begin
   &if &(error) &then &do
      &if &(redirected)
         &then revert_output -source_switch error_output
      delete ([segments -inhibit_error &!.errors])
   &end
&end

&on any_other &begin
   &if &(redirected) &then &do
      revert_output -source_switch error_output
      &set redirected false
   &end
   &exit &continue
&end

&1
&revert command_error
revert_output -source_switch error_output
&set redirected false
ec expect true &(error)
ec expect &r2 ||[contents &!.errors -nl]
delete &!.errors
