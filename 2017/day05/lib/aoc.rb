require 'pp'

def jump(steps)
	it = 0
	i = 0
	max_i = steps.size
	loop do
		if steps[i].nil? then return it end
		tmp = steps[i]
		steps[i] += 1
		i += tmp
		it += 1
	end
end

def jump2(steps)
	it = 0
	i = 0
	max_i = steps.size
	loop do
		if steps[i].nil? then return it end
		tmp = steps[i]
		if steps[i] >= 3 then
			steps[i] -= 1
		else
			steps[i] += 1
		end
		i += tmp
		it += 1
	end
end

def maze_jump(maze)
	jump(maze.split("\n").map {|i| i.to_i})
end

def maze_jump2(maze)
	jump2(maze.split("\n").map {|i| i.to_i})
end
