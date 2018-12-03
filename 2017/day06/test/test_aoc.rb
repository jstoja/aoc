require 'minitest/autorun'

require_relative '../lib/aoc'

class TestDebugCountCycles < Minitest::Test
	def test_debug_count_cycles1
		assert_equal 5, debug_count_cycles("0 2 7 0")
	end
end
