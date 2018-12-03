require 'pp'

def debug_count_cycles(blocks)
	nums = blocks.split("\s").map(&:to_i)
	iter = 0
	position_done = [nums.join(' ').to_s]
	loop do
		max_idx = [nums.max, nums.index(nums.max)]
		val = max_idx[0]
		idx = max_idx[1]+1
		nums[max_idx[1]] = 0
		val.times do |i|
			if idx >= (nums.size) then idx = 0 end
			nums[idx] += 1
			idx += 1
		end
		iter += 1
		if position_done.include? nums.join(' ').to_s
			return [iter, iter - position_done.index(nums.join(' ').to_s)]
		end
		position_done << nums.join(' ').to_s
	end
end
