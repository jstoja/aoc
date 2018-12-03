acc = 0
File.foreach('input.txt') do |line|
  acc+= line.to_i
end
puts acc
