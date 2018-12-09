require 'test/unit'

class Circle
  def initialize
    @circle = [0]
    @current_mable = 0
  end

  def place(marble)
    @circle.rotate!
    @circle << marble
  end

  def delete7
    @circle.rotate!(-7)
    deleted = @circle.delete_at(-1)
    @circle.rotate!
    deleted
  end
end

class Game
  def initialize(num_players, last_marble)
    @scores = Hash.new(0)
    @circle = Circle.new
    @current_player = 1
    @last_marble = last_marble
    @num_players = num_players
    run!
  end

  def run!
    (1..@last_marble).each do |marble|
      if (marble % 23).zero?
        @scores[@current_player] += marble
        @scores[@current_player] += @circle.delete7
      else
        @circle.place marble
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

puts Game.new(459, 72103).highest_score
