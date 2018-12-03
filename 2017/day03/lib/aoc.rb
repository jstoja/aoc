require 'pp'

def prev_square_end(number)
	while true do
		sqrt = Math.sqrt(number)
		if ((number % sqrt) == 0) and (sqrt.to_i.odd?)
			return number
		end
		number -= 1
	end
end

def find_position_in_spiral(number)
	if number == 1 then return[0,0] end
	min_square = prev_square_end(number)
	n = Math.sqrt(min_square).to_i
	i = (2..n).find_all { |j| j.odd? }.count
	number_pos = [i+1, -i]
	number_test = min_square+1

	# up with y+1
	n.times do
		if number.eql? number_test then return number_pos end
		number_pos[1] += 1
		number_test += 1
	end
	# left with x-1
	(n+1).times do
		if number.eql? number_test then return number_pos end
		number_pos[0] -= 1
		number_test += 1
	end
	# down with y-1
	(n+1).times do
		if number.eql? number_test then return number_pos end
		number_pos[1] -= 1
		number_test += 1
	end
	# right with x+1
	n.times do
		if number.eql? number_test then return number_pos end
		number_pos[0] += 1
		number_test += 1
	end
end

def spiral_memory(number)
	number_pos = find_position_in_spiral number
	number_pos[0].abs + number_pos[1].abs
end
