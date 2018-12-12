initial_state = ''
notes_with = []
notes_without = []
File.foreach('input.txt') do |line|
  vals = line.split(' ')
  if initial_state.empty?
    initial_state = vals[2]
  else
    notes_with << vals[0] if vals[2].eql? '#'
    notes_without << vals[0] if vals[2].eql? '.'
  end
end

state = Hash.new('.')
initial_state.chars.each_with_index do |c, i|
  state[i] = c
end

c = state.values.count('#')
puts "0:\t#{state.values.join}\t#{c}"
20.times do |generation|
  new_state = Hash.new('.')
  ((state.keys.min-2)..(state.keys.max+2)).each do |pos|
    a = [state[pos - 2], state[pos - 1], state[pos], state[pos + 1], state[pos + 2]]
    note = a.join('')
    if notes_with.include?(note)
      new_state[pos] = '#'
    elsif a.count('#') > 0
      new_state[pos] = '.'
    end
  end
  state = new_state
  puts "#{generation+1}:\t#{state.values.join}"
end

pp state.select{|k,v| v.eql? '#'}.keys.reduce(:+)
