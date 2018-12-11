require 'test/unit'

class Board
  def initialize(grid_serial)
    @grid_serial = grid_serial
    @grid_size = 300
    @save = {}
    freeze
  end

  def fuel_cell(x, y)
    @save[y] = {} if @save[y].nil?
    return @save[y][x] unless @save[y][x].nil?
    rack_id = (x + 10) 
    fuel = ((rack_id * y) + @grid_serial) * rack_id
    hundred_digit = fuel / 100 % 10
    o = hundred_digit - 5
    @save[y][x] = o
    return o
  end

  def largest_power_square
    max_pos = [0, 0, 0]
    max_fuel = 0
    save = {}
    (1..@grid_size).each do |s|
      (1..@grid_size-s).each do |y|
        save[y] = {} if save[y].nil?
        (1..@grid_size-s).each do |x|
          if save[y][x].nil? && s.eql?(1)
            save[y][x] = fuel_cell(x, y)
          else
            p = (s.times.map {|i| [x + i, y + (s-1)]}) + ((s-1).times.map {|i| [x + (s-1), y + i]})
            save[y][x] += p.map {|xx, yy| fuel_cell(xx, yy)}.sum
          end
          if save[y][x] > max_fuel
            max_fuel = save[y][x]
            max_pos = [x, y, s]
          end
        end
      end
      #puts "#{s * 100.0 / @grid_size} with max being #{max_fuel} on #{max_pos}"
    end
    return "#{max_pos[0]},#{max_pos[1]},#{max_pos[2]}"
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
  def _test_largest_power2
    assert_equal("90,269,16", Board.new(18).largest_power_square)
    assert_equal("232,251,12", Board.new(42).largest_power_square)
  end
end

pp Board.new(5535).largest_power_square
