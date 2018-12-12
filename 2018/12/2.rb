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

prev_sum = state.select{|k,v| v.eql? '#'}.keys.reduce(:+)

done = 0
last_diffs = [0] * 10
NUM_GEN = 50000000000
NUM_GEN.times do |generation|
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
  done += 1

  # To find the convergence we store the last sum differences.
  # If they are all the same, then we do not continue
  # and use the last calculated sum and use the last diff to count the remaining operations
  sum = state.select{|k,v| v.eql? '#'}.keys.reduce(:+)
  last_diffs.shift
  last_diffs << (sum - prev_sum)
  prev_sum = sum
  if last_diffs.uniq.size.eql? 1
    puts "#{generation+1}:\t#{state.values.join}\t#{sum}\t#{last_diffs}"
    puts prev_sum + (last_diffs[0] * (NUM_GEN - done))
    exit
  end

  if generation % 10000 == 0
    puts "#{generation+1}:\t#{state.values.join}\t#{sum}\t#{last_diffs}"
  end
end
