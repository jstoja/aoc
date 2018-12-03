acc = 0
File.foreach('input1.txt') do |line|
  acc+= line.to_i
end
puts acc
