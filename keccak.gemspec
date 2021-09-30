require File.expand_path('lib/digest/sha3/version')

Gem::Specification.new do |s|
  s.name = "keccak"
  s.version = Digest::SHA3::Version::STRING
  s.summary = "The Keccak (SHA-3) hash used by Ethereum."
  s.email = "ruby@q9f.cc"
  s.homepage = "https://github.com/q9f/keccak.rb"
  s.description = "The Keccak (SHA-3) hash use by Ethereum. This does not implement the final FIPS202 standard, today known as SHA3 but rather an early version, commonly referred to as Keccak."
  s.authors = ["Afri Schoedon", "Chris Metcalfe", "Hongli Lai (Phusion)", "Keccak authors"]
  s.extensions << "ext/digest/extconf.rb"
  s.required_ruby_version = ">= 2.2"
  s.license = "Apache-2.0"

  s.files = Dir[
    "README.md",
    "COPYRIGHT",
    "LICENSE",
    "Makefile",
    "keccak.gemspec",
    "ext/**/*.{c,h,rb}",
    "lib/**/*"
  ]
end
