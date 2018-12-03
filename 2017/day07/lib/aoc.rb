require 'pp'


def sort_tower(tower_arr)
	parents = tower_arr.find_all {|i| i[:childs]}
	first = parents.reject do |i|
		test = false
		parents.each do |j|
			test = test || (j[:childs].include? i[:name])
		end
		test
	end

	first
end

def parse_tower(tower)
	tower_arr = []
	tower.split("\n").each do |line|
		items = line.split("\s")
		childs = items[3..-1]
		if childs then childs = childs.join.split(",") end
		tower_arr << {name: items[0], weight: items[1].chop[1..-1].to_i, childs: childs}
	end
	tower_arr
end

LOL = []

def weight_rec(tower_arr, disk)
	weight = 0
	tower_arr.each do |d|
		if d[:name].eql? disk
			weight = d[:weight]
			unless d[:childs].nil? then 
				d[:childs].each do |i|
					weight += (weight_rec tower_arr, i)
				end
			else
				return weight
			end
		end
	end
	LOL << {name: disk, weight: weight}
	return weight
end

def weight_disk(tower, disk)
	tower_arr = parse_tower tower
	parent = tower_arr.find {|d| d[:name].eql? disk}
	weight_rec tower_arr, disk
	pp LOL
end

def first_disk(tower)
	tower_arr = parse_tower tower
	return sort_tower(tower_arr)[0][:name]
end
