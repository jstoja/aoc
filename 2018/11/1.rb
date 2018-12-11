require 'test/unit'

class Board
  def initialize(grid_serial)
    @grid_serial = grid_serial
    @grid_size = 300
    freeze
  end

  def fuel_cell(x, y)
    rack_id = (x + 10) 
    fuel = ((rack_id * y) + @grid_serial) * rack_id
    hundred_digit = fuel / 100 % 10
    return hundred_digit - 5
  end

  def largest_power_square
    max_pos = [0, 0]
    max_fuel = 0
    (1..@grid_size-3).each do |y|
      (1..@grid_size-3).each do |x|
        p = (3.times.map {|i| x + i}).product((3.times.map {|i| y + i}))
        curr_fuel = p.map {|xx, yy| fuel_cell(xx, yy)}.sum
        if curr_fuel > max_fuel
          max_fuel = curr_fuel
          max_pos = [x, y]
        end
      end
    end
    return "#{max_pos[0]},#{max_pos[1]}"
  end
end

class TestBoard < Test::Unit::TestCase
  def _test_fuel_cell
    assert_equal(-5, Board.new(57).fuel_cell(122, 79))
    assert_equal(0, Board.new(39).fuel_cell(217, 196))
    assert_equal(4, Board.new(71).fuel_cell(101, 153))
  end

  def _test_largest_power
    assert_equal("33,45", Board.new(18).largest_power_square)
    assert_equal("21,61", Board.new(42).largest_power_square)
  end
end

pp Board.new(5535).largest_power_square
