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

def get_sums(points, offset)
  min_x = points[0][:x]
  max_x = 0
  min_y = points[0][:y]
  max_y = 0
  map = {}
  sums = {}

  points.each_pair do |id, point|
    map[point[:y]] = {} if map[point[:y]].nil?
    map[point[:y]][point[:x]] = {} if map[point[:y]][point[:x]].nil?
    map[point[:y]][point[:x]][id] = 0
  
    min_x = point[:x] if point[:x] < min_x
    min_y = point[:y] if point[:y] < min_y
    max_x = point[:x] if point[:x] > max_x
    max_y = point[:y] if point[:y] > max_y
    unless ([min_x, max_x].include? point[:x]) || ([min_y, max_y].include? point[:y])
      sums[id] = 0
    end
  end
  min_x -= offset
  min_y -= offset
  max_x += offset
  max_y += offset
  puts "min: #{min_x},#{min_y} max: #{max_x},#{max_y}"

  (min_y..max_y).each do |y|
    map[y] = {} if map[y].nil?
    (min_x..max_x).each do |x|
      map[y][x] = {} if map[y][x].nil?
      points.each_pair do |id, point|
        dist = dist({x: x, y: y}, point)
        min = map[y][x].values.min
        if min.nil? or dist <= min
          map[y][x][id] = dist
        end
      end
    end
  end

  (min_y..max_y).each do |y|
    line = []
    (min_x..max_x).each do |x|
      min = map[y][x].values.min
      tmp = map[y][x].dup.delete_if { |k, v| v != min }
      if tmp.keys.size > 1
        line << '.'
      else
        line << tmp.keys.first
        sums[tmp.keys.first] += 1 if sums.keys.include? tmp.keys.first
      end
    end
  end
  return sums
end

sums1 = get_sums(points, 0)
sums2 = get_sums(points, 20)

common = {}
sums1.each do |k1, v1|
  sums2.each do |k2, v2|
    if v1.eql? v2
      common[k1] = v1
    end
  end
end

pp [common.max_by{|k, v| v}].to_h
