data = []

def diff_1_letter(a, b)
  diff_position = []
  a.length.times do |i|
    if !a[i].eql? b[i]
      diff_position << i
    elsif diff_position.length > 1
      return 0
    end
  end
  if diff_position.length == 1
    diff_position.first
  else
    0
  end
end

File.foreach('input.txt') do |line|
  n = line.chomp
  data << n
  data.each do |s|
    d = diff_1_letter(n, s)
    unless d.zero?
      str = n.chars
      str.delete_at(d)
      puts str.join
      exit
    end
  end
end
