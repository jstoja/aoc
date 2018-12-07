points = {}
i = 0

File.foreach('input.txt') do |line|
  p = line.split(',').map(&:lstrip).map(&:to_i)
  points[i] = { x: p[0], y: p[1] }
  i += 1
end


def dist(a, b)
  (b[:x] - a[:x]).abs + (b[:y] - a[:y]).abs
end

def get_within(points, within)
  min_x = points[0][:x]
  max_x = 0
  min_y = points[0][:y]
  max_y = 0
  map = {}
  size = 0

  points.each_pair do |id, point|
    map[point[:y]] = {} if map[point[:y]].nil?
    map[point[:y]][point[:x]] = 0 if map[point[:y]][point[:x]].nil?
  
    min_x = point[:x] if point[:x] < min_x
    min_y = point[:y] if point[:y] < min_y
    max_x = point[:x] if point[:x] > max_x
    max_y = point[:y] if point[:y] > max_y
  end
  puts "min: #{min_x},#{min_y} max: #{max_x},#{max_y}"


  (min_y..max_y).each do |y|
    map[y] = {} if map[y].nil?
    (min_x..max_x).each do |x|
      map[y][x] = 0 if map[y][x].nil?
      points.each_value do |point|
        dist = dist({x: x, y: y}, point)
        map[y][x] += dist
        if map[y][x] > within
          break
        end
      end
      if map[y][x] < within
        size += 1
      end
    end
  end
  size
end

puts get_within(points, 10000)
