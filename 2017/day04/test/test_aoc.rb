require 'minitest/autorun'

require_relative '../lib/aoc'

class TestPassphrases < Minitest::Test
	def test_passphrase1
		assert_equal true, passphrase_valid("aa bb cc dd ee")
	end

	def test_passphrase2
		assert_equal false, passphrase_valid("aa bb cc dd aa")
	end

	def test_passphrase3
		assert_equal true, passphrase_valid("aa bb cc dd aaa")
	end
end
