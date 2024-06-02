&version 2
&trace &command off
&default *
value_set test_prefix &! -perprocess -push
io move_attach user_input &!.saved_input
io attach user_input syn_ &ec_switch
&set attached true
&on cleanup &begin
   value_delete -brief -match &!.* -perprocess
   value_set -pop test_prefix
   io destroy_iocb &!.saved_input
&end
&on any_other &begin
   &if &(attached) &then &do
      io detach user_input
      io move_attach &!.saved_input user_input
      &set attached false
   &end
   &exit &continue
&end
&on test_continue &begin
   io move_attach user_input &!.saved_input
   io attach user_input syn_ &ec_switch
   &set attached true
&end
value_set &!.passed 0 -perprocess
value_set &!.run 0 -perprocess
value_set &!.match &r1 -perprocess

ec test print_counts_
   ec expect ||[contents example_counts -nl] ||[call_print_counts_ ;||]""
-TEST_END

ec test count_bytes_
   ec expect ||[contents c12345_counts -nl] ||[call_count_bytes_ ;||]""
-TEST_END

ec test print_code_
   ec expect ||[contents example_code -nl] ||[call call_print_code_ 0 ;||]""
-TEST_END

ec test make_code_
   ec expect ||[contents c12345_code -nl] ||[call call_make_code_ 0 ;||]""
-TEST_END

ec test write_header_
   truncate test_header
   call_write_header_
   ec expect ||[contents example_header -nl] ||[contents test_header -nl]
-TEST_END

ec test read_header_
   ec expect
&- For some reason, the `call` command prints an extra leading newline, which
&- we must account for in this test.  Note that the file example_code already
&- contains a leading newline.
&+   [flnnl "^/padding size: 8^/header length (bits): 83^a"
&+   ||[contents example_code -nl]]
&+   ||[call call_read_header_ 0 ;||]""
-TEST_END

ec test compress_
   truncate test_fz
   call_compress_
   ec expect ||[contents c12345_fz -nl] ||[contents test_fz -nl]
-TEST_END

ec test decompress_
   truncate test_unfz
   call_decompress_
   ec expect ||[contents c12345 -nl] ||[contents test_unfz -nl]
-TEST_END

ec fixture_push

ec fixture teardown
   set_user_storage -system
   delete ([files &!.area &!.area_status])
-TEST_END

ec test decompress_noleaks
   truncate test_unfz
   create_area &!.area -zero_on_free ;| discard_
   area_status &!.area ;| &!.area_status
   set_user_storage &!.area
   call_decompress_
   set_user_storage -system
   ec expect ||[contents &!.area_status -nl] ||[area_status &!.area ;||]""
-TEST_END

ec fixture_pop

ec test nullary
   ec check_error compress [fl "compress: Expected argument missing.
				&+ Usage: compress path {-control_args}^/"]
-TEST_END

ec test nullary_uncompress
   ec check_error uncompress [fl "uncompress: Expected argument missing.
				  &+ Usage: uncompress path {-control_args}^/"]
-TEST_END

ec test not_found
   ec check_error "compress nonexistent"
&+		  [fl "compress: Entry not found. Could not initiate
		       &+ input segment ^a>nonexistent.^/" [wd]]
-TEST_END

ec test not_found_uncompress
   ec check_error "uncompress nonexistent"
&+		  [fl "uncompress: Entry not found. Could not initiate
		       &+ input segment ^a>nonexistent.fz.^/" [wd]]
-TEST_END

ec test bad_option
   ec check_error "compress -nonexistent"
&+		  [fl "compress: Specified control argument is not accepted.
		       &+ -nonexistent^/"]
-TEST_END

ec test extra_arg
   ec check_error "compress file file2"
&+		  [fl "compress: Usage: compress path {-control_args}^/"]
-TEST_END

ec test too_long
   ec check_error "compress this_entryname_is_more_than_32_character_long"
&+		  [fl "compress: Entry name too long. Could not expand input
		       &+ pathname.^/"]
-TEST_END

ec test too_long_with_suffix
   ec check_error "compress this_names_smthg_with_30_chars"
&+		  [fl "compress: Entry name too long. Could not expand input
		       &+ pathname.^/"]
-TEST_END

ec fixture_push

ec fixture teardown
   delete ([files &! &!.fz])
   unlink ([links &! &!.fz])
-TEST_END

ec fixture_push

ec fixture setup
   create &!("" .fz)
-TEST_END

ec test no_input_permission
   set_acl &! n
   ec check_error "compress &!"
&+		  [fl "compress: Incorrect access on entry. Could not initiate
		       &+ input segment ^a>&!.^/" [wd]]
-TEST_END

ec test no_output_permission
   set_acl &!.fz n
   ec check_error "compress &!"
&+		  [fl "compress: Incorrect access on entry. Could not initiate
		       &+ output segment &!.fz.^/" [wd]]
-TEST_END

ec fixture_pop

ec test compress_empty
   create &!
   ec expect [fl "Old length = 0, new length = 1.^/"] ||[compress &! ;||]""
   ec expect ||[contents empty.fz -nl] ||[contents &!.fz -nl]
-TEST_END

ec test compress_empty_fz
   create &!
   ec expect "" ||[compress -brief &!.fz ;||]""
   ec expect ||[contents empty.fz -nl] ||[contents &!.fz -nl]
-TEST_END

ec test uncompress_empty
   copy empty.fz &!.fz
   ec expect [fl "Old length = 1, new length = 0.^/"] ||[uncompress &! ;||]""
   ec expect ||[contents empty -nl] ||[contents &! -nl]
-TEST_END

ec test uncompress_empty_fz
   copy empty.fz &!.fz
   uncompress -brief &!.fz
   ec expect ||[contents empty -nl] ||[contents &! -nl]
-TEST_END

ec fixture_push

ec fixture setup
   create &!
   flnnl text ;| &!.fz
-TEST_END

ec test namedup_no
   ec expect [fl "^/compress: Name duplication. Do you want to delete the old
		  &+ segment &!.fz?   no^/"] ||[answer no compress &! ;||]""
   ec expect text ||[contents &!.fz -nl]
-TEST_END

ec test namedup_yes
   ec expect [fl "^/compress: Name duplication. Do you want to delete the old
		  &+ segment &!.fz?   yes^/
		  &+Old length = 0, new length = 1.^/"]
&+	     ||[answer yes compress &! ;||]""
   ec expect ||[contents empty.fz -nl] ||[contents &!.fz -nl]
-TEST_END

ec test no_write_permission
   set_acl &!.fz r
   ec check_error "ec expect [fl ""^/compress: Name duplication. Do you want to
			         &+ delete the old segment &!.fz?   yes^/""]
		   &+ ||[answer yes compress &! ;||]"""""
&+		  [fl "compress: Incorrect access on entry. Could not truncate
		       &+ &!.fz.^/"]
-TEST_END

ec fixture_pop

ec test compress_replace
   create &!
   compress -brief -replace &!
   ec expect ||[contents empty.fz -nl] ||[contents &!.fz -nl]
   ec expect "" ||[files &!]
-TEST_END

ec test uncompress_replace
   copy empty.fz &!.fz
   uncompress -brief -replace &!
   ec expect ||[contents empty -nl] ||[contents &! -nl]
   ec expect "" ||[files &!.fz]
-TEST_END

ec fixture_push

ec fixture teardown
   delete_dir -fc ([directories &!.d])
-TEST_END

ec test no_modify_permission
   create_dir &!.d
   create &!.d>&!
   set_acl &!.d sa
   ec check_error "compress -replace &!.d>&!"
&+		  [fl "compress: Incorrect access to directory containing entry.
		       &+ Could not delete ^a>&!.d>&!.^/" [wd]]
   ec expect ||[contents empty.fz -nl] ||[contents &!.fz -nl]
-TEST_END

ec fixture_pop

ec test compress_hello
   link hello &!
   compress -brief &!
   ec expect ||[contents hello.fz -nl] ||[contents &!.fz -nl]
-TEST_END

ec test uncompress_hello
   link hello.fz &!.fz
   uncompress -brief &!
   ec expect ||[contents hello -nl] ||[contents &! -nl]
-TEST_END

ec test compress_value_set_info
   link >doc>info>value_set.info &!
   compress -brief &!
   ec expect true [compare value_set.info.fz &!.fz]
-TEST_END

ec test uncompress_value_set_info
   link value_set.info.fz &!.fz
   uncompress -brief &!
   ec expect true [compare >doc>info>value_set.info &!]
-TEST_END

ec test compress_value_info
   link >doc>info>value_.info &!
   compress -brief &!
   ec expect true [compare value_.info.fz &!.fz]
-TEST_END

ec test uncompress_value_info
   link value_.info.fz &!.fz
   uncompress -brief &!
   ec expect true [compare >doc>info>value_.info &!]
-TEST_END

ec test compress_edm
   link >sss>edm &!
   compress -brief &!
   ec expect true [compare edm.fz &!.fz]
-TEST_END

ec test uncompress_edm
   link edm.fz &!.fz
   uncompress -brief &!
   ec expect true [compare >sss>edm &!]
-TEST_END

ec test compress_hcs_info
   link >doc>info>hcs_.info &!
   compress -brief &!
   ec expect true [compare hcs_.info.fz &!.fz]
-TEST_END

ec test uncompress_hcs_info
   link hcs_.info.fz &!.fz
   uncompress -brief &!
   ec expect true [compare >doc>info>hcs_.info &!]
-TEST_END

ec fixture_pop

&set n &[value_get &!.passed]
&set d &[value_get &!.run]
&set percent &[calc &(n)/&(d)*100]
&set r &[round &(percent) [plus [index &(percent). .] 1]]
format_line "^/^d of ^d tests passed (^a%)." &(n) &(d) &(r)
value_delete -match &!.* -perprocess
io detach user_input
io move_attach &!.saved_input user_input
io destroy_iocb &!.saved_input
value_set -pop test_prefix
