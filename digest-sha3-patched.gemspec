require File.expand_path('lib/digest/sha3/version')

Gem::Specification.new do |s|
  s.name = "digest-sha3-patched"
  s.version = Digest::SHA3::Version::STRING
  s.summary = "The SHA-3 (Keccak) hash"
  s.email = "chris.s.metcalfe@gmail.com"
  s.homepage = "https://github.com/teamhedg/digest-sha3-ruby"
  s.description = "The SHA-3 (Keccak) hash."
  s.authors = ["Hongli Lai (Phusion)", "Keccak authors", "Chris Metcalfe"]
  s.extensions << "ext/digest/extconf.rb"
  s.required_ruby_version = ">= 2.2"
  s.license = "MIT"

  s.files = Dir[
    "README.md",
    "LICENSE",
    "Makefile",
    "digest-sha3-patched.gemspec",
    "ext/**/*.{c,h,rb}",
    "lib/**/*"
  ]
end
