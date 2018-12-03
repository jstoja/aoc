require 'minitest/autorun'

require_relative 'lib/aoc'

TEST_CHECKSUM = """5 1 9 5
7 5 3
2 4 6 8
"""

TEST_CHECKSUM2 = """5 9 2 8
9 4 7 3
3 8 6 5
"""

class TestChecksum < Minitest::Test
	def test_checksum1
		assert_equal 18, checksum(TEST_CHECKSUM)
	end
end

class TestChecksum2 < Minitest::Test
	def test_checksum1
		assert_equal 9, checksum2(TEST_CHECKSUM2)
	end
end
