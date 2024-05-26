&version 2
&trace &command off
&set error false
&set failure false
&set desc &||[io attach_desc error_output]

&on command_error &begin
   &if &(failure) &then &do
      &exit &continue
   &end
   &set error true
   file_output &!.errors -source_switch error_output
&end

&on error compress_bad_code compress_fatal compress_test_fail &begin
   &set failure true
   &if &(error) &then &do
      &if &[not [equal &(desc) [io attach_desc error_output]]]
         &then revert_output -source_switch error_output
      delete ([segments -inhibit_error &!.errors])
   &end
   &exit &continue
&end

&1
revert_output -source_switch error_output
ec expect true &(error)
ec expect &r2 ||[contents &!.errors -nl]
delete &!.errors
