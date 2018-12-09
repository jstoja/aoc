require 'test/unit'

class Circle
  attr_accessor :value, :clockwise, :counter_clockwise

  def initialize(value, clockwise = self, counter_clockwise = self)
    @value = value
    @clockwise = clockwise
    @counter_clockwise = counter_clockwise
  end

  def insert_new_marble(value)
    counter = @clockwise
    clockwise = counter.clockwise
    new_marble = Circle.new(value, clockwise, counter)
    counter.clockwise = new_marble
    clockwise.counter_clockwise = new_marble
    new_marble
  end

  def steps_away(steps)
    if steps.zero?
      self
    elsif steps > 0
      @clockwise.steps_away(steps - 1)
    else
      @counter_clockwise.steps_away(steps + 1)
    end
  end
end

class Game
  def initialize(num_players, last_marble)
    @scores = Hash.new(0)
    @circle = Circle.new(0)
    @current_player = 1
    @last_marble = last_marble
    @num_players = num_players
    run!
  end

  def run!
    (1..@last_marble).each do |marble|
      if (marble % 23).zero?
        @scores[@current_player] += marble
        @circle = @circle.steps_away(-7)
        @scores[@current_player] += @circle.value
        @circle.counter_clockwise.clockwise = @circle.clockwise
        @circle.clockwise.counter_clockwise = @circle.counter_clockwise
        @circle = @circle.clockwise
      else
        @circle = @circle.insert_new_marble(marble)
      end
      next_player!
    end
  end

  def next_player!
    @current_player += 1
    @current_player = 1 if @current_player > @num_players
  end

  def highest_score
    @scores.values.max
  end
end

class TestGame < Test::Unit::TestCase
  def test_1
    assert_equal(32, Game.new(9, 25).highest_score)
    assert_equal(8317, Game.new(10, 1618).highest_score)
    assert_equal(146_373, Game.new(13, 7999).highest_score)
    assert_equal(2764, Game.new(17, 1104).highest_score)
    assert_equal(54_718, Game.new(21, 6111).highest_score)
    assert_equal(37_305, Game.new(30, 5807).highest_score)
  end
end

puts Game.new(459, 72103*100).highest_score
