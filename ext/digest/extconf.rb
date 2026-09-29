#!/usr/bin/env ruby
# frozen_string_literal: true

require "mkmf"

def cflags(*args)
  args.each do |str|
    $CFLAGS += (ENV["OS"] == "Windows_NT") ? " #{str} " : " #{str.shellescape} "
  end
end

def have_header!(*args)
  exit 1 unless have_header(*args)
end

def have_func!(header, *args)
  exit 1 unless have_func(*args, header)
end

cflags "-std=c11"
cflags "-Wall"
cflags "-Wextra"
cflags "-fvisibility=hidden"

# Coverage build, opt-in through `make coverage`. It stays off by default so
# `gem install` neither ships .gcno files nor pays for instrumentation.
#
# -O0 and -fno-inline are part of the measurement, not a preference: with
# inlining on, gcc folds keccak_finish_func into its only caller and gcov then
# reports the callee's body unexecuted while marking the call site "2196*".
# That reads as a missing test and is not one.
if ENV["COVERAGE"]
  cflags "--coverage", "-O0", "-fno-inline"
  $LDFLAGS += " --coverage"
end

have_header! "ruby/digest.h"
have_header! "stdio.h"
have_header! "string.h"

have_func! "rb_str_set_len"
have_func "rb_digest_make_metadata", "ruby/digest.h"

create_makefile "digest/keccak" or exit 1
