changes = []
File.foreach('input2.txt') do |line|
  changes << line.to_i
end

freq = 0
freq_history = []
changes.cycle do |freq_change|
  freq += freq_change
  if freq_history.include? freq
    puts freq
    exit
  end
  freq_history << freq
end
