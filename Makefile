PL1 = pl1
PL1FLAGS = -prefix "size,strg,strz,subrg"

OBJECTS = count_bytes_ print_code_ make_code_ write_header_ encode_ compress_ read_header_ decode_ decompress_ write_into_ print_header_ compress

NAMES = $(OBJECTS) uncompress print_compressed_header

TEST_OBJECTS = print_counts_ call_print_counts_ call_count_bytes_ make_example_code_ call_print_code_ call_make_code_ call_write_header_ call_compress_ call_read_header_ call_decompress_

all: $(NAMES)

check: build_tests
	ec do_tests

build_tests: $(TEST_OBJECTS)

external.incl.pl1: external.depd
	delete -brief external.incl.pl1
	depd ([contents external.depd]) ;| external.incl.pl1

count_bytes_.incl.pl1: count_bytes_
	depd count_bytes_ ;| count_bytes_.incl.pl1 -truncate

print_code_.incl.pl1: print_code_
	depd print_code_ ;| print_code_.incl.pl1 -truncate

make_code_.incl.pl1: make_code_
	depd make_code_ ;| make_code_.incl.pl1 -truncate

write_header_.incl.pl1: write_header_
	depd write_header_ ;| write_header_.incl.pl1 -truncate

encode_.incl.pl1: encode_
	depd encode_ ;| encode_.incl.pl1 -truncate

compress_: compress_.pl1 encode_.incl.pl1 make_code_.incl.pl1 \
	   write_header_.incl.pl1
	$(PL1) $(PL1FLAGS) compress_

compress_.incl.pl1: compress_
	depd compress_ ;| compress_.incl.pl1 -truncate

decompress_.incl.pl1: decompress_
	depd decompress_ ;| decompress_.incl.pl1 -truncate

write_into_.incl.pl1: write_into_
	depd write_into_ ;| write_into_.incl.pl1 -truncate

print_header_.incl.pl1: print_header_
	depd print_header_ ;| print_header_.incl.pl1 -truncate

compress: compress.pl1 external.incl.pl1 compress_.incl.pl1 \
	  decompress_.incl.pl1 print_header_.incl.pl1 write_into_.incl.pl1
	$(PL1) $(PL1FLAGS) compress

uncompress: compress
	add_name compress uncompress

print_compressed_header: compress
	add_name compress print_compressed_header

print_counts_.incl.pl1: print_counts_
	depd print_counts_ ;| print_counts_.incl.pl1 -truncate

call_print_counts_: call_print_counts_.pl1 print_counts_.incl.pl1
	$(PL1) $(PL1FLAGS) call_print_counts_

call_count_bytes_: call_count_bytes_.pl1 count_bytes_.incl.pl1 \
		   print_counts_.incl.pl1
	$(PL1) $(PL1FLAGS) call_count_bytes_

make_example_code_.incl.pl1: make_example_code_
	depd make_example_code_ ;| make_example_code_.incl.pl1 -truncate

call_print_code_: call_print_code_.pl1 make_example_code_.incl.pl1 \
		  print_code_.incl.pl1
	$(PL1) $(PL1FLAGS) call_print_code_

call_make_code_: call_make_code_.pl1 external.incl.pl1 make_code_.incl.pl1 \
		 print_code_.incl.pl1
	$(PL1) $(PL1FLAGS) call_make_code_

call_read_header_: call_read_header_.pl1 print_header_.incl.pl1
	$(PL1) $(PL1FLAGS) call_read_header_

call_decompress_: call_decompress_.pl1 external.incl.pl1 decompress_.incl.pl1 \
		  write_into_.incl.pl1
	$(PL1) $(PL1FLAGS) call_decompress_

call_write_header_: call_write_header_.pl1 make_example_code_.incl.pl1 \
		    write_header_.incl.pl1 write_into_.incl.pl1
	$(PL1) $(PL1FLAGS) call_write_header_

call_compress_: call_compress_.pl1 compress_.incl.pl1 write_into_.incl.pl1
	$(PL1) $(PL1FLAGS) call_compress_

.pl1:
	$(PL1) $(PL1FLAGS) $*

.SUFFIXES: .pl1

clean:
	delete -brief $(OBJECTS) $(TEST_OBJECTS)
