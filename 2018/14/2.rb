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

  def find_sequence(sequence)
    s = sequence.size
    l = sequence.chars.last.to_i
    loop do
      next_try!
      pick_new!
      if @values.last == l
        v = @values.last(s).join('')
        #puts "tested #{v} #{l}"
        return @new_receipes - s if v == sequence
      end
      #puts "#{@new_receipes * 100 / 1741551173.0}%" if @new_receipes % 1000 == 0
      puts "#{@new_receipes}" if @new_receipes % 10000 == 0
    end
  end

end

def next_seq(seq)
  scoreboard = Scoreboard.new([3, 7], 2)
  scoreboard.find_sequence seq
end

class TestScoreboard < Test::Unit::TestCase
  def _test_seq
    assert_equal(9, next_seq('51589'))
    assert_equal(5, next_seq('01245'))
    assert_equal(18, next_seq('92510'))
    assert_equal(2018, next_seq('59414'))
  end
end

pp next_seq('704321')
