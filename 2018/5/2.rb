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

def react_polymer(str)
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
  return str
end

data = {}

File.foreach('input.txt') do |line|
  str = line.chomp

  ('a'..'z').each do |c|
    res = str.delete(c.downcase).delete(c.upcase)
    data[c] = react_polymer(res.dup).length
  end

end

pp data.invert.sort.to_h.first
