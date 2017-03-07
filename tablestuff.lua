function parseintotable ( biginput,name )
	local stattable = {}
	index = 1
	for line in io.lines('file.txt') do --replace text file with wow input box
		stattable[index] = {}
		for match in string.gmatch(line,"%d+") do 
			stattable[index][ #stattable[index] + 1 ] = tonumber(match)
		end 
		index = index + 1
	end 
	
	makeusabletable(stattable,name)
end

function referencedisplaycode ( stable ) --This displays all the rows, use as reference
	for _,row in ipairs(stable) do
		print("{"..table.concat(row,',').."}")
	end 
end

function makeusabletable (stable, name)
	for outer, row in ipairs(stable) do
		for inner, row2 in ipars(row) do
			if inner == 1 then bigglobalstat[name][outer].ilvl = row2
			elseif inner == 2 then bigglobalstat[name][outer].crit = row2
			elseif inner == 3 then bigglobalstat[name][outer].haste = row2
			elseif inner == 4 then bigglobalstat[name][outer].mast = row2
			elseif inner == 5 then bigglobalstat[name][outer].vers = row2
			end
		end
	end
end
			
		