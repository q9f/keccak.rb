# .PHONY, not .phony: make's special target is case-sensitive, so the old
# spelling declared nothing. It went unnoticed while no file matched a target
# name -- then `make coverage` started reporting "up to date" because the
# coverage/ directory it writes matches the target that writes it.
.PHONY: all clean test coverage

# A generator that dies after the shell created the redirect target leaves a
# truncated test_vectors.rb that make will not regenerate, because its mtime is
# newer than its prerequisites. Delete the target on failure instead.
.DELETE_ON_ERROR:

# The two lines keccak_init cannot reach: `case FAIL:` and `default:`. The
# vendored Init() returns only SUCCESS or BAD_HASHLEN, and HashReturn has no
# fourth value, so both arms are dead. Reaching them would mean editing a
# vendored file, which the specification forbids. Excluding a fifth line is a
# specification amendment, not an edit to this list.
COVERAGE_EXCLUDE = 81,82,85,86

all: ext/digest/Makefile
	make -C ext/digest

ext/digest/Makefile: ext/digest/extconf.rb
	cd ext/digest && ruby extconf.rb

clean:
	if [ -f ext/digest/Makefile ]; then make -C ext/digest clean; fi
	rm -f ext/digest/Makefile
	rm -f test/test_vectors.rb
	rm -f ext/digest/*.gcno ext/digest/*.gcda ext/digest/*.gcov

test: all test/test_vectors.rb
	ruby test/test_all.rb

test/test_vectors.rb: test/generate_tests.rb test/data/*
	ruby test/generate_tests.rb > test/test_vectors.rb

# Always from clean: gcov accumulates counts into .gcda, and an object file
# left over from a non-coverage build produces no data at all.
coverage:
	$(MAKE) clean
	COVERAGE=1 $(MAKE) all
	ruby test/generate_tests.rb > test/test_vectors.rb
	COVERAGE=1 ruby test/test_all.rb
	@cd ext/digest && gcov keccak.c > /dev/null 2>&1
	@ruby -rjson -e 'r = JSON.parse(File.read("coverage/.last_run.json"))["result"]; \
	  n = JSON.parse(File.read("coverage/.resultset.json")).values.first["coverage"].size; \
	  puts format("Ruby: %.1f%% line, %.1f%% branch (%d file%s)", \
	              r["line"], r["branch"], n, n == 1 ? "" : "s"); \
	  abort "coverage report is empty: SimpleCov measured no files" if n.zero?'
	@awk -v excl="$(COVERAGE_EXCLUDE)" -F: ' \
	  BEGIN { split(excl, e, ","); for (i in e) skip[e[i] + 0] = 1 } \
	  { count = $$1; gsub(/[ *]/, "", count); line = $$2 + 0; \
	    if (count == "-" || line == 0) next; \
	    if (line in skip) { excluded++; next } \
	    total++; \
	    if (count == "#####") { uncovered++; printf "  uncovered line %d\n", line } } \
	  END { printf "C   : ext/digest/keccak.c  %d of %d reachable lines (%.2f%%), %d excluded\n", \
	        total - uncovered, total, total ? 100.0 * (total - uncovered) / total : 0, excluded; \
	        if (total == 0) { print "  no executable lines measured: gcov produced no data"; exit 1 } \
	        if (uncovered) exit 1 }' ext/digest/keccak.c.gcov
