# The Keccak (SHA-3) digest for Ruby

[![GitHub Workflow Status](https://img.shields.io/github/workflow/status/q9f/keccak.rb/Build/main)](https://github.com/q9f/keccak.rb/actions)
[![GitHub top language](https://img.shields.io/github/languages/top/q9f/keccak.rb?color=black)](https://github.com/q9f/keccak.rb/pulse)
[![GitHub release](https://img.shields.io/github/v/release/q9f/keccak.rb?color=red)](https://github.com/q9f/keccak.rb/releases/latest)
[![Gem](https://img.shields.io/gem/v/keccak?color=red)](https://rubygems.org/gems/keccak)
[![License](https://img.shields.io/github/license/q9f/keccak.rb.svg?color=black)](LICENSE)

This Ruby extension exposes the [Keccak](http://keccak.noekeon.org/) (SHA-3) digest C bindings in the non-final version used by Ethereum. It is based on the reference `C` implementation, version 3.2. The exposed interface is almost identical to that of the `digest` standard library.

## Installation

The gem is called `keccak`.

```bash
bundle add keccak
gem install keccak
```

```ruby
gem 'keccak', '~> 1.2'
```

**Note**: as of version `v1.1.0`, `digest-sha3` (historic name) requires Ruby 2.2. The new `keccak` version `v1.2.0` now also supports Ruby 3.0. The last version that worked on older Ruby (1.x) versions was `v1.0.2`. It can be found at the no longer maintained [`digest-sha3` repository from 2015](https://github.com/phusion/digest-sha3-ruby/releases/tag/release-1.0.2).

## Usage

This gem extends the `digest/*` module by a `digest/sha3` class (historic reference, see history section below).

```ruby
require 'digest/sha3'

# Generate 512-bit digest.
Digest::SHA3.digest("foo")       # => "\025\227\204*..."
Digest::SHA3.hexdigest("foo")    # => "1597842a..."

# Generate 224-bit digest.
Digest::SHA3.digest("foo", 224)       # => "\332\251M\247..."
Digest::SHA3.hexdigest("foo", 224)    # => "daa94da7..."

# Use this interface to feed data in chunks. 512-bit by default.
digest = Digest::SHA3.new
digest.update("f")
digest.update("o")
digest.update("o")
digest.digest       # => "\025\227\204*..."
digest.hexdigest    # => "1597842a..."

# You can pass a hash length to the constructor.
digest = Digest::SHA3.new(224)
```

Keccak supports five hash lengths: 224-bit, 256-bit, 384-bit, 512-bit and variable length. Variable length is not supported by this Ruby extension. Unless the user specifies otherwise, this Ruby extension assumes 512-bit.

## Running the test suite

Run the test suite as follows:

```bash
bundle install
make test
```

A part of the test suite is automatically generated from Keccak's reference test suite.

## Warning: Keccak vs. SHA-3

**Note:** This gem still uses the `Digest::SHA3` namespace for reasons of backwards compatibility and long-term maintainability. See history section below.

:warning: This gem does **not** implement the final FIPS202 standard, today known as SHA-3 but rather an early version, commonly referred to as Keccak. The reason why this is kept around, is that Ethereum uses this earler version of Keccak. See also: [Ethereum: Difference between keccak256 and sha3](https://ethereum.stackexchange.com/questions/30369/difference-between-keccak256-and-sha3)

If you are looking for the final SHA-3 gem, please use the following: https://rubygems.org/gems/sha3

## History

This gem was initially developed and published as `digest-sha3`: https://github.com/phusion/digest-sha3-ruby

This gem was later patched multiple times:

* https://github.com/teamhedge/digest-sha3-ruby (KECCAK, as `digest-sha3-patched`)
* https://github.com/sydneyitguy/digest-sha3-ruby (KECCAK, as `digest-sha3-patched-ruby-3`)
* https://github.com/steakknife/digest-sha3-ruby (actual SHA-3, do not use for Ethereum)
* https://github.com/kotovalexarian/digest-keccak/ (KECCAK, as `digest-keccak`)
