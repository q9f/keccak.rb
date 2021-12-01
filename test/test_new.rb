# frozen_string_literal: true

require 'test/unit'

class KeccakNewTests < Test::Unit::TestCase
  def test_singleton_method_hexdigest_256_empty
    result = Digest::Keccak.hexdigest '', 256
    assert_instance_of String, result
    assert_equal 'c5d2460186f7233c927e7db2dcc703c0' \
                 'e500b653ca82273b7bfad8045d85a470',
                 result
  end

  def test_singleton_method_hexdigest_256_sample
    result = Digest::Keccak.hexdigest 'sample', 256
    assert_instance_of String, result
    assert_equal 'b80204f7e9243e4fca5489740ccd31dc' \
                 'd0a54619a7f4165cee73c191ef7271a1',
                 result
  end
end
