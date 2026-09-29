# frozen_string_literal: true

# Coverage is opt-in, driven by `make coverage`. It has to start before any
# first-party file is required, or those files load unmeasured.
#
# The test is against "0" and "" as well as nil: `COVERAGE=0 make test` reading
# as "coverage on" is the kind of surprise that gets a gate switched off.
if !["", "0"].include?(ENV["COVERAGE"].to_s)
  require "simplecov"
  SimpleCov.start do
    enable_coverage :branch
    # track_files is not optional here. Nothing in the suite requires
    # lib/digest/keccak/version.rb -- `require "digest/keccak"` loads the
    # compiled extension and nothing else -- so without this the report holds
    # zero files and SimpleCov calls that 100%.
    track_files "lib/**/*.rb"
    add_filter "/test/"
    # Reporting a number is not a gate. Without this, `make coverage` prints
    # 57% and exits 0, which is the failure this whole target exists to catch.
    minimum_coverage line: 100
  end
end

$LOAD_PATH.unshift(File.expand_path("lib"))
$LOAD_PATH.unshift(File.expand_path("ext"))
require "digest/keccak"
require "digest/keccak/version"

# The 1085 Known Answer Test vectors are generated into test/test_vectors.rb by
# the Makefile. Refuse to run without them rather than silently checking the 16
# hand-written cases: a green suite that skipped the corpus is the exact failure
# this file is guarded against.
vectors = File.expand_path("test/test_vectors.rb")
unless File.exist? vectors
  abort "test/test_vectors.rb is missing. Generate it with `make test`, or " \
        "`ruby test/generate_tests.rb > test/test_vectors.rb`. Running the " \
        "suite without it checks 16 cases instead of 1101."
end

require File.expand_path("test/test_usage")
require File.expand_path("test/test_new")
require vectors

# Existence is not enough. The corpus is generated rather than committed, and a
# generator that dies after the shell has created the redirect target leaves a
# stale file that make will not regenerate -- so the suite could load an empty
# test_vectors.rb, report 16 tests and exit 0. The count is the criterion.
KAT_VECTORS = 1085
found = defined?(KeccakTests) ? KeccakTests.instance_methods(false).grep(/\Atest_/).size : 0
unless found == KAT_VECTORS
  abort "test/test_vectors.rb holds #{found} vectors, expected #{KAT_VECTORS}. " \
        "It is generated, so delete it and rebuild: " \
        "rm -f test/test_vectors.rb && make test."
end
