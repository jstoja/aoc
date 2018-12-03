data = []

File.foreach('input.txt') do |line|
  g = line.each_char.group_by { |c| line.count c }
  data << g.keys.select { |n| (n.eql? 2) || (n.eql? 3) }
end
puts data.flatten.group_by { |x| x }.values.map(&:count).reduce(1, :*)
