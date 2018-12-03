require 'pp'

MIN_MAX_TAB = Proc.new { |tab|
	tab.minmax.reduce(:-).abs
}

DIVISABLE_TAB = Proc.new { |tab|
	div = 0
	tab.each_with_index do |i, posi|
		tab.each_with_index do |j, posj|
			if i%j == 0 and posi != posj then
				div = i/j
			end
		end
	end
	div
}

def checksum_map(method, spreadsheet)
	spreadsheet.split("\n").inject 0 do |acc, line|
		acc + method.call(line.split("\s").map {|i| i.to_i})
	end
end

def checksum(spreadsheet)
	checksum_map(MIN_MAX_TAB, spreadsheet)
end

def checksum2(spreadsheet)
	checksum_map(DIVISABLE_TAB, spreadsheet)
end


