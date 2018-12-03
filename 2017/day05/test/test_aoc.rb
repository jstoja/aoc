require 'minitest/autorun'

require_relative '../lib/aoc'

class TestMazeJump < Minitest::Test
	def test_maze_jump1
		assert_equal 5, maze_jump("""0
3
0
1
-3""")
	end

	def test_maze_jump2
		assert_equal 10, maze_jump2("""0
3
0
1
-3""")
	end
end
