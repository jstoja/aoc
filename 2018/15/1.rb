require 'test/unit'
require 'securerandom'

class Map
  attr_reader :max_x, :max_y
  attr_writer :map
  def initialize(file)
    @map = []
    File.foreach(file) do |line|
      @map << line.chomp
    end
    @max_x = @map.first.size
    @max_y = @map.size
  end
  def print_map
    i = 0
    print ' '
    @max_x.times { |i| print i }
    puts
    @map.each do |l|
      puts "#{i}#{l}"
      i += 1
    end
  end

  def get_players
    players = []
    @map.each_with_index do |l, y|
      l.chars.each_with_index do |c, x|
        if ['E', 'G'].include? c
          players << Player.new(c, x, y)
        end
      end
    end
    players
  end

  def adjacent_squares(player)
    adjacents([player.x, player.y]).select { |pos| empty? pos }
  end

  def adjacents(p)
    left = [p[0] - 1, p[1]]
    right = [p[0] + 1, p[1]]
    top = [p[0], p[1] - 1]
    bottom = [p[0], p[1] + 1]
    #[left, right, top, bottom]
    [top, left, right, bottom]
  end

  def empty?(p)
    x = p[0]
    y = p[1]
    x > 0 && x < @max_x && y > 0 && y < @max_y && @map[y][x] == '.'
  end

  def eql?(p1, p2)
    p1[0] == p2[0] && p1[1] == p2[1]
  end

  def reachable(source, dest)
    r = filter_reachable(source, dest)
    return nil if r.nil?
    test_map = @map.dup
    @map.each_with_index do |l, i|
      test_map[i] = l.dup
    end

    r.each do |p|
      test_map[p[1]][p[0]] = p[2].to_s
    end
    path = [source.dup]
    test = source << 0
    r_pos = r.collect { |p| [p[0], p[1]] }
    loop do
      adj = adjacents(test).select { |p| r_pos.include? p }
      a = adj.sort_by { |p| test_map[p[1]][p[0]] }.first
      path << a
      test = a
      return path if eql?(a, dest)
    end
  end
  def filter_reachable(source, dest)
    queue = [[dest[0], dest[1], 0]]
    queue_item = 0
    1.step do |i|
      return nil if queue[queue_item].nil?
      new = adjacents(queue[queue_item])
      new = new.collect { |pp| pp << i }
      new = new.reject do |p|
        t = false
        queue.each do |q|
          t = true if eql?(p, q) && q[2] <= p[2]
        end
        t
      end
      new.each { |p| return queue << p if eql?(p, source) } #IF WE FIND THE SOURCE
      #puts "before source: #{source} dest: #{dest} => new_path: #{new} from: #{queue[queue_item]}"
      new = new.select { |pos| empty? pos }
      #puts "after source: #{source} dest: #{dest} => new_path: #{new} from: #{queue[queue_item]}"
      queue += new
      queue_item += 1
      #return nil if i >= (@max_x * @max_y)
    end
  end

  def move_player(player, dest)
    @map[player.y][player.x] = '.'
    @map[dest[1]][dest[0]] = player.type
  end
end

class Game
  attr_reader :players
  attr_writer :debug
  def initialize(map_file)
    @map = Map.new(map_file)
    @players = @map.get_players
    @debug = true
    @map.print_map if @debug
  end

  def play!
    0.step do |round|
      ordered_players.each do |player|
        in_range = players_next_move(player)
        unless in_range.nil?
          move_player(player, in_range)
        end
      end
      @map.print_map if @debug
      exit
    end
  end

  def move_player(player, dest)
    pp player, dest
    @map.move_player(player, dest)
    player.move(dest)
  end

  def players_next_move(from_player)
    points = []
    @players.each do |player|
      next if player.id == from_player.id || player.type == from_player.type
      points += @map.adjacent_squares(player)
    end
    points.collect do |p|
      l = @map.reachable([from_player.x, from_player.y], p)
      #puts "from: #{from_player.x} #{from_player.y} to: #{p} => path: #{l}"
      if l.nil?
        nil
      else
        {point: p, path: l}
      end
    end.compact.sort_by { |p| p[:path].size }.first[:path][1]
  end

  def ordered_players
    pl = []
    @map.max_y.times do |y|
      @map.max_x.times do |x|
        @players.each do |p|
          pl << p if p.x == x && p.y == y
        end
      end
    end
    pl
  end
end

class Player
  attr_reader :alive, :x, :y, :id, :type
  def initialize(type, x, y)
    @id = SecureRandom.uuid
    @type = type
    @x = x
    @y = y
    @attack_power = 3
    @hit_points = 200
    @alive = true
  end

  def move(dest)
    x = dest[0]
    y = dest[1]
  end
end

#Game.new('test1.txt').play!

class TestScoreboard < Test::Unit::TestCase
  def test1
    g = Game.new('test0.txt')
    assert_equal([2, 1], g.players_next_move(g.players[0]))
    assert_equal([3, 1], g.players_next_move(g.players[1]))
  end
  def test1
    g = Game.new('test1.txt')
    g.debug = true
    assert_equal([1, 1], g.players_next_move(g.players[0]))
  end
end
