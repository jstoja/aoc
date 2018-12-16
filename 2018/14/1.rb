require 'test/unit'

class Scoreboard
  attr_reader :values, :new_receipes
  def initialize(values, elves_count)
    @values = values
    @elves = Array.new(elves_count) { |i| i }
    @new_receipes = values.size
  end

  def new_receipe
    @elves.collect { |e| @values[e] }.reduce(:+)
  end

  def next_try!
    new = new_receipe.to_s.chars.map(&:to_i)
    @new_receipes += new.size
    @values += new
  end

  def pick_new!
    @elves = @elves.collect do |elve|
      (1 + elve + @values[elve]) % @values.size
    end
  end

  def print!
    @values.each_with_index do |val, index|
      if !@elves.include? index
        print " #{val} "
      else
        print "(#{val})"
      end
    end
    print " ==> #{@new_receipes}"
    puts
  end
end

def next_10_receipes(after)
  scoreboard = Scoreboard.new([3, 7], 2)
  debug = false

  until scoreboard.new_receipes >= (10 + after)
    scoreboard.next_try!
    scoreboard.pick_new!
    scoreboard.print! if debug
  end
  remove = scoreboard.new_receipes - (10 + after)
  scoreboard.values.last(10 + remove)[0..-(1 + remove)].join('')
end

class TestScoreboard < Test::Unit::TestCase
  def _test_10_after
    assert_equal('5158916779', next_10_receipes(9))
    assert_equal('0124515891', next_10_receipes(5))
    assert_equal('9251071085', next_10_receipes(18))
    assert_equal('5941429882', next_10_receipes(2018))
  end
end

pp next_10_receipes(704_321)
