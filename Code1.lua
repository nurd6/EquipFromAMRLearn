-- Author      : Nurd6
-- Create Date : 3/8/2017 11:53:39 AM

function parseintotable ( biginput,name )
	local stattable = {}
	index = 1
	for line in biginput do 
		stattable[index] = {}
		for match in string.gmatch(line,"%d+") do 
			stattable[index][ #stattable[index] + 1 ] = tonumber(match)
		end 
		index = index + 1
	end 
	
	return makeusabletable(stattable,name)
end

function referencedisplaycode ( stable ) --This displays all the rows, use as reference
	for _,row in ipairs(stable) do
		print("{"..table.concat(row,',').."}")
	end 
end

function makeusabletable (stable, name)
	local bigglobalstat = { }
	for outer, row in ipairs(stable) do
		for inner, row2 in ipars(row) do
			if inner == 1 then ilvl,low,high = getilowhigh(row2,low,high)
			elseif inner == 2 then bigglobalstat[name][ilvl].crit = row2
			elseif inner == 3 then bigglobalstat[name][ilvl].haste = row2
			elseif inner == 4 then bigglobalstat[name][ilvl].mast = row2
			elseif inner == 5 then bigglobalstat[name][ilvl].vers = row2
			end
		end
	end
	bigglobalstat[name].lowi = low
	bigglobalstat[name].highi = high
	
	return filltherestoftable(bigglobalstat, name)
	
end

local function getilowhigh ( nlvl, lowi, highi )
	if lowi == nil then lowi = nlvl end
	if highi == nil then highi = nlvl end
	if nlvl < lowi then lowi = nlvl end
	if nlvl > highi then highi = nlvl end
	return nlvl, lowi, highi
end
	
	
	

function statatpoint( ilvl1, stat1, ilvl2, stat2, inc )
	return ( stat1 + stat2 ) * ( ( ilvl1 + inc ) / ( ilvl1 + ilvl2 ) )
end
function matrixstats( mstat, ilvl, crit, haste, mast, vers )	-- May not need a multidimensional array
	sz = table.getn(mstat)+1									-- Need to make sure I check that the array isn't empty
	mstat[sz] = { ilvl, crit, haste, mast, vers }
	return mstat
end

function setstatatpoint( bigglobalstat, low, high, dif, name )
	curilvl = low + dif

	bigglobalstat[name][curilvl].crit = statatpoint( low, bigglobalstat[name][low].crit, high, bigglobalstat[name][high].crit, dif )
	bigglobalstat[name][curilvl].haste = statatpoint( low, bigglobalstat[name][low].haste, high, bigglobalstat[name][high].haste, dif )
	bigglobalstat[name][curilvl].mast = statatpoint( low, bigglobalstat[name][low].mast, high, bigglobalstat[name][high].mast, dif ) 
	bigglobalstat[name][curilvl].vers = statatpoint( low, bigglobalstat[name][low].vers, high, bigglobalstat[name][high].vers, dif )

	return bigglobalstat
end
			
function filltherestoftable( bigglobalstat, name )
	lowbound = bigglobalstat[name].lowi
	upperbound = bigglobalstat[name].highi
	
	for i = lowbound, upperbound, 1 do
		if i % 10 == 0 then curlow = i curhigh = i + 10
		else bigglobalstat = setstatatpoint( bigglobalstat, curlow, curhigh, i - curlow, name )
		end
	end
	return bigglobalstat
end