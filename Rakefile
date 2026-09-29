require 'rake/testtask'
require 'bundler/gem_tasks'

# The 1085 KAT vectors are generated, not committed. The Makefile declares the
# corpus a prerequisite of its own test target; Rake needs its own, or
# `rake test` aborts in test/test_all.rb on a tree where it has not been built.
VECTORS = "test/test_vectors.rb"

file VECTORS => ["test/generate_tests.rb", *FileList["test/data/*"]] do
  # Generate through a temporary and move it into place. A generator that dies
  # mid-write would otherwise leave a truncated corpus whose mtime is newer
  # than its prerequisites, which neither Rake nor make would regenerate. The
  # Makefile gets this from .DELETE_ON_ERROR:; Rake has no equivalent.
  tmp = "#{VECTORS}.new"
  begin
    sh "ruby test/generate_tests.rb > #{tmp}"
    mv tmp, VECTORS
  rescue StandardError
    rm_f tmp
    raise
  end
end

Rake::TestTask.new do |t|
  t.libs << "lib"
  t.libs << "test"
  t.test_files = FileList['test/test*.rb']
  t.verbose = true
end

task :test => VECTORS

task :default => [:build, :install, :test]
