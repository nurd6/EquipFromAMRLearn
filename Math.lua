
function statatpoint( ilvl1, stat1, ilvl2, stat2, inc )
	return ( stat1 + stat2 ) * ( ( ilvl1 + inc ) / ( ilvl1 + ilvl2 ) )
end
function matrixstats( mstat, ilvl, crit, haste, mast, vers )	-- May not need a multidimensional array
	sz = table.getn(mstat)+1									-- Need to make sure I check that the array isn't empty
	mstat[sz] = { ilvl, crit, haste, mast, vers }
	return mstat
end

function filltable ()
end




