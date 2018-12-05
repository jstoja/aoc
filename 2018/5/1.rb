class String
  def is_upper?
    self == self.upcase
  end

  def is_lower?
    self == self.downcase
  end
end

def should_destroy?(a, b)
  a.upcase == b.upcase && ((a.is_upper? && b.is_lower?) || (a.is_lower? && b.is_upper?))
end

File.foreach('input.txt') do |line|
  str = line.chomp
  i_want_to_break_free = false

  while !i_want_to_break_free do
    i_want_to_break_free = true
    str.chars.each_cons(2) do |a, b|
      if should_destroy?(a, b)
        pos = str.index(a+b)
        str[pos..pos+1] = ''
        i_want_to_break_free = false
        break
      end
    end
  end
  puts str, str.length
end
