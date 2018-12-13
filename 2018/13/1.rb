map = Hash.new([])
y_index = 0
CART_POSITIONS = ['^', '>', 'v', '<'].freeze
TURN_ORDER = %i[left straight right].freeze
carts = []

File.foreach('input.txt') do |line|
  map[y_index] = line
  x_carts = []
  line.chars.each_with_index do |c, index|
    x_carts << index if CART_POSITIONS.include? c
  end
  unless x_carts.empty?
    x_carts.each do |x|
      prev = (['<', '>'].include?(line[x]) ? '-' : '|')
      carts << {
        x: x,
        y: y_index,
        position: line[x],
        next_direction: 0,
        prev_part: prev
      }
    end
  end
  y_index += 1
end

TURNS = {
  '/' => {
    '<' => 'v',
    '>' => '^',
    'v' => '<',
    '^' => '>'
  },
  '\\' => {
    'v' => '>',
    '^' => '<',
    '<' => '^',
    '>' => 'v'
  }
}.freeze

def turn_special!(curr_cart)
  test = (CART_POSITIONS.find_index(curr_cart[:position]) - 1) % CART_POSITIONS.length
  test2 = (CART_POSITIONS.find_index(curr_cart[:position]) + 1) % CART_POSITIONS.length
  case TURN_ORDER[curr_cart[:next_direction]]
  when :left
    curr_cart[:position] = CART_POSITIONS[test]
  when :right
    curr_cart[:position] = CART_POSITIONS[test2]
  end
  new_dir = (curr_cart[:next_direction] + 1) % TURN_ORDER.length
  curr_cart[:next_direction] = new_dir
end

def turns!(part, curr_cart)
  curr_cart[:prev_part] = part
  if part == '+'
    turn_special!(curr_cart)
  elsif !TURNS[part].nil?
    curr_cart[:position] = TURNS[part][curr_cart[:position]]
  end
end

def move_right!(map, curr_cart, x, y)
  map[y][x] = curr_cart[:prev_part]
  curr_cart[:x] += 1

  old_part = map[y][x + 1]
  turns!(old_part, curr_cart)
  map[y][x + 1] = curr_cart[:position]
end

def move_left!(map, curr_cart, x, y)
  old_part = map[y][x - 1]
  map[y][x] = curr_cart[:prev_part]
  curr_cart[:x] -= 1
  turns!(old_part, curr_cart)
  map[y][x - 1] = curr_cart[:position]

end

def move_up!(map, curr_cart, x, y)
  old_part = map[y - 1][x]
  map[y][x] = curr_cart[:prev_part]
  curr_cart[:y] -= 1
  turns!(old_part, curr_cart)
  map[y - 1][x] = curr_cart[:position]
end

def move_down!(map, curr_cart, x, y)
  old_part = map[y + 1][x]
  map[y][x] = curr_cart[:prev_part]
  curr_cart[:y] += 1
  turns!(old_part, curr_cart)
  map[y + 1][x] = curr_cart[:position]
end

debug = false
loop do
  map.each_value { |line| puts line } if debug
  carts.collect { |c| [c[:y], c[:x]] }.sort.each do |y, x|
    curr_cart = carts.select { |c| (c[:x].eql? x) && (c[:y].eql? y) }
    if curr_cart.length > 1
      map[y][x] = 'X'
      map.each_value { |line| puts line } if debug
      puts "#{x},#{y}"
      exit
    end
    curr_cart = curr_cart.first
    if curr_cart[:position] == '>'
      move_right!(map, curr_cart, x, y)
    elsif curr_cart[:position] == '<'
      move_left!(map, curr_cart, x, y)
    elsif curr_cart[:position] == 'v'
      move_down!(map, curr_cart, x, y)
    elsif curr_cart[:position] == '^'
      move_up!(map, curr_cart, x, y)
    else
      puts "don't know..."
    end
  end
end
