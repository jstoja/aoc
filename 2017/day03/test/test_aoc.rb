require 'minitest/autorun'

require_relative '../lib/aoc'

class TestSpiralMemory < Minitest::Test
	def test_spiral_memory1
		assert_equal 0, spiral_memory(1)
	end

	def test_spiral_memory2
		assert_equal 3, spiral_memory(12)
	end

	def test_spiral_memory3
		assert_equal 2, spiral_memory(23)
	end

	def test_spiral_memory4
		assert_equal 31, spiral_memory(1024)
	end
end

class TestFindPositionInSpiral < Minitest::Test
	def test_find_position_in_spiral1
		assert_equal [0,0], find_position_in_spiral(1)
	end

	def test_find_position_in_spiral2
		assert_equal [2,1], find_position_in_spiral(12)
	end

	def test_find_position_in_spiral3
		assert_equal [0,-2], find_position_in_spiral(23)
	end

	def test_find_position_in_spiral4
		assert_equal [-2,4], find_position_in_spiral(63)
	end
end
