require 'minitest/autorun'

require_relative '../lib/aoc'

TOWER = """pbga (66)
xhth (57)
ebii (61)
havc (66)
ktlj (57)
fwft (72) -> ktlj, cntj, xhth
qoyq (66)
padx (45) -> pbga, havc, qoyq
tknk (41) -> ugml, padx, fwft
jptl (61)
ugml (68) -> gyxo, ebii, jptl
gyxo (61)
cntj (57)
"""

class TestRecursiveCircus < Minitest::Test
	def test_first_disk1
		assert_equal "tknk", first_disk(TOWER)
	end

	#def test_sum_disk1
	#	assert_equal 251, weight_disk(TOWER, "ugml")
	#end
	#def test_sum_disk2
	#	assert_equal 243, weight_disk(TOWER, "padx")
	#end
	#def test_sum_disk3
	#	assert_equal 243, weight_disk(TOWER, "fwft")
	#end
	def test_sum_disk4
		assert_equal 243, weight_disk(TOWER, first_disk(TOWER))
	end
end
