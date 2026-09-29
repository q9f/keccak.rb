# frozen_string_literal: true

# Coverage is opt-in, driven by `make coverage`. It has to start before any
# first-party file is required, or those files load unmeasured.
if ENV["COVERAGE"]
  require "simplecov"
  SimpleCov.start do
    enable_coverage :branch
    # track_files is not optional here. Nothing in the suite requires
    # lib/digest/keccak/version.rb -- `require "digest/keccak"` loads the
    # compiled extension and nothing else -- so without this the report holds
    # zero files and SimpleCov calls that 100%.
    track_files "lib/**/*.rb"
    add_filter "/test/"
  end
end

$LOAD_PATH.unshift(File.expand_path("lib"))
$LOAD_PATH.unshift(File.expand_path("ext"))
require "digest/keccak"
require "digest/keccak/version"

# The 1085 Known Answer Test vectors are generated into test/test_vectors.rb by
# the Makefile. Refuse to run without them rather than silently checking the 10
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
