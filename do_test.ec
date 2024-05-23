&version 2
&trace &command off
&attach
value_set tests_passed 0 -perprocess
value_set tests_run 0 -perprocess

ec test
   ec expect [contents example_counts -nl] [call_print_counts_ ;|]
-END_TEST
