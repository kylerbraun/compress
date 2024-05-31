PL1 = pl1
PL1FLAGS = -prefix "size,strg,strz,subrg"

OBJECTS = count_bytes_ print_header_ print_code_ make_code_ write_header_ \
	  encode_ compress_ read_header_ decode_ decompress_ write_into_ \
	  compress

NAMES = $(OBJECTS) uncompress print_compressed_header

TEST_OBJECTS = call_print_counts_ call_count_bytes_ make_example_code_ call_print_code_ call_make_code_ call_write_header_ call_compress_ call_read_header_ call_decompress_

all: $(NAMES)

check: $(TEST_OBJECTS)
	ec do_tests

uncompress: compress
	add_name compress uncompress

print_compressed_header: compress
	add_name compress print_compressed_header

.pl1:
	$(PL1) $(PL1FLAGS) $*

.SUFFIXES: .pl1

clean:
	delete -brief $(OBJECTS) $(TEST_OBJECTS)
