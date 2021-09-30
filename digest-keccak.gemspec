require File.expand_path('lib/digest/sha3/version')

Gem::Specification.new do |s|
  s.name = "digest-keccak"
  s.version = Digest::SHA3::Version::STRING
  s.summary = "The SHA-3 (Keccak) hash used by Ethereum."
  s.email = "ruby@q9f.cc"
  s.homepage = "https://github.com/q9f/digest-keccak-ruby"
  s.description = "The SHA-3 (Keccak) hash use by Ethereum. This does not implement the final FIPS202 standard, today known as SHA3 but rather an early version, commonly referred to as Keccak."
  s.authors = ["Afri Schoedon", "Chris Metcalfe", "Hongli Lai (Phusion)", "Keccak authors"]
  s.extensions << "ext/digest/extconf.rb"
  s.required_ruby_version = ">= 2.2"
  s.license = "Apache-2.0"

  s.files = Dir[
    "README.md",
    "LICENSE",
    "Makefile",
    "digest-keccak.gemspec",
    "ext/**/*.{c,h,rb}",
    "lib/**/*"
  ]
end
