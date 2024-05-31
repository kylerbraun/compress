PL1 = pl1
PL1FLAGS = -prefix "size,strg,strz,subrg"

OBJECTS = count_bytes_ print_header_ print_code_ make_code_ write_header_ \
	  encode_ compress_ read_header_ decode_ decompress_ write_into_ \
	  compress

NAMES = $(OBJECTS) uncompress print_compressed_header

TEST_OBJECTS = call_print_counts_ call_count_bytes_ make_example_code_ \
	       call_print_code_ call_make_code_ call_write_header_ \
	       call_compress_ call_read_header_ call_decompress_

all: $(NAMES)

check: build_tests
	ec do_tests

build_tests: $(TEST_OBJECTS)

external.incl.pl1: external.depd
	display_entry_point_dcl ([contents external.depd]) ;| external.incl.pl1

print_counts_.incl.pl1: print_counts_
	display_entry_point_dcl print_counts_ ;| print_counts_.incl.pl1

decompress_.incl.pl1: decompress_
	display_entry_point_dcl decompress_ ;| decompress_.incl.pl1

write_into_.incl.pl1: write_into_
	display_entry_point_dcl write_into_ ;| write_into_.incl.pl1

uncompress: compress
	add_name compress uncompress

print_compressed_header: compress
	add_name compress print_compressed_header

call_print_counts_: call_print_counts_.pl1 print_counts_.incl.pl1
	$(PL1) $(PL1FLAGS) call_print_counts_

call_decompress_: call_decompress_.pl1 external.incl.pl1 decompress_.incl.pl1 \
		  write_into_.incl.pl1
	$(PL1) $(PL1FLAGS) call_decompress_

.pl1:
	$(PL1) $(PL1FLAGS) $*

.SUFFIXES: .pl1

clean:
	delete -brief $(OBJECTS) $(TEST_OBJECTS)
