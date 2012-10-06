require File.expand_path('lib/digest/sha3/version')

Gem::Specification.new do |s|
  s.name = "digest-sha3"
  s.version = Digest::SHA3::Version::STRING
  s.summary = "The SHA-3 (Keccak) hash"
  s.email = "hongli@phusion.nl"
  s.homepage = "https://github.com/phusion/digest-sha3-ruby"
  s.description = "The SHA-3 (Keccak) hash."
  s.authors = ["Hongli Lai", "Keccak authors"]
  s.extensions << "ext/digest/extconf.rb"

  s.files = Dir[
    "README.md",
    "LICENSE",
    "Makefile",
    "digest-sha3.gemspec",
    "ext/**/*.{c,h,rb}",
    "lib/**/*"
  ]
end