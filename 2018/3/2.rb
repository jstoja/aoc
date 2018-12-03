map = {}
all_ids = []

re = '#(\d+)\ @\ (\d+),(\d+)\:\ (\d+)x(\d+)'
File.foreach('input.txt') do |line|
  matches = line.chomp.match(re).to_a.map(&:to_i)[1..-1]
  x1 = matches[1]
  y1 = matches[2]
  x2 = matches[1] + matches[3]
  y2 = matches[2] + matches[4]
  all_ids << matches[0]
  (x2 - x1).times do |x|
    map[x1 + x] = {} if map[x1 + x].nil?
    line = map[x1 + x]
    (y2 - y1).times do |y|
      line[y1 + y] = [] if line[y1 + y].nil?
      line[y1 + y] << matches[0]
    end
  end
end

map.each_value do |line|
  line.each_value do |c|
    all_ids.each do |a|
      if (c.length >= 2 && c.include?(a))
        all_ids.delete(a)
        break
      end
    end
  end
end

pp all_ids.first
