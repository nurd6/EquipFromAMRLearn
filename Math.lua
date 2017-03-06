function lerp(a,b,t) return (1-t)*a + t*b end
function lerp2(a,b,t) return a+(b-a)*t end
function getMidpoint( x1, y1, x2, y2 )
	return ( x1 + x2 ) / 2, ( y1 + y2 ) / 2
end
function statatpoint( ilvl1, stat1, ilvl2, stat2, inc )
	return ( stat1 + stat2 ) * ( ( ilvl1 + inc ) / ( ilvl1 + ilvl2 ) )
end
function matrixstats( mstat, ilvl, crit, haste, mast, vers )	-- May not need a multidimensional array
	sz = table.getn(mstat)+1									-- Need to make sure I check that the array isn't empty
	mstat[sz] = { ilvl, crit, haste, mast, vers }
	return mstat
end





