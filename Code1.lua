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
	local ilvl, low, high

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
	
	
	

function statatpoint( ilvl1, stat1, ilvl2, stat2, cur )
	return ( stat1 + stat2 ) * (  cur / ( ilvl1 + ilvl2 ) )
end
function matrixstats( mstat, ilvl, crit, haste, mast, vers )	-- May not need a multidimensional array
	sz = table.getn(mstat)+1									-- Need to make sure I check that the array isn't empty
	mstat[sz] = { ilvl, crit, haste, mast, vers }
	return mstat
end

function setstatatpoint( bigglobalstat, low, high, curilvl, name )
	
	bigglobalstat[name][curilvl].crit = statatpoint( low, bigglobalstat[name][low].crit, high, bigglobalstat[name][high].crit, curilvl )
	bigglobalstat[name][curilvl].haste = statatpoint( low, bigglobalstat[name][low].haste, high, bigglobalstat[name][high].haste, curilvl )
	bigglobalstat[name][curilvl].mast = statatpoint( low, bigglobalstat[name][low].mast, high, bigglobalstat[name][high].mast, curilvl ) 
	bigglobalstat[name][curilvl].vers = statatpoint( low, bigglobalstat[name][low].vers, high, bigglobalstat[name][high].vers, curilvl )

	return bigglobalstat
end
			
function filltherestoftable( bigglobalstat, name )
	lowbound = bigglobalstat[name].lowi
	upperbound = bigglobalstat[name].highi
	
	for i = lowbound, upperbound, 1 do
		if i % 10 == 0 then curlow = i curhigh = i + 10
		else bigglobalstat = setstatatpoint( bigglobalstat, curlow, curhigh, i, name )
		end
	end
	return bigglobalstat
end

function sumStats(oldnew, nlink  )
	local slots = {"Head", "Neck", "Shoulder", "Back", "Chest", "Shirt", "Tabard", "Wrist", "Waist", "Legs", "Feet", "Hands", "Finger0", "Finger1", "Trinket0", "Trinket1", "MainHand", "SecondaryHand"}
	local invtypes = {"head" = "Head", "neck" = "Neck", "shoulder" = "Shoulder", "body" = "Shirt", "chest" = "Chest", "robe" = "Chest", "feet" = "Feet", "wrist" = "Wrist", "finger" = "Finger0", "trinket" = "Trinket0", "cloak" = "Back", "shield" = "SecondaryHand", "2hweapon" = "MainHand", "weaponmainhand" = "MainHand", "weaponoffhand" = "SecondaryHand", "holdable" = "SecondaryHand", "ranged" = "MainHand", "rangedright" = "MainHand", "thrown" = "MainHand"}
	local totali, numitems, newi, avgi
	local critTot, hasteTot, mastTot, versTot
	local nslot

	if nlink then 
		local _,_,_,neewi,_,_,_,_,noslot = GetItemInfo(nlink) 
		newi = neewi
		local _,nislot = strsplit("_",noslot)
		nslot = invtypes[string.lower(nislot)].."Slot"
	end


	for q,v in pairs(slots) do
		local slotID = GetInventorySlotInfo(v .. "Slot")
		local itemLink
		if oldnew == "o" or not slotID == nslot then
			itemLink = GetInventoryItemLink("player", slotID)
		else 
			itemLink = nlink
		end
		local stats = GetItemStats(itemLink)
		critTot = critTot + stats["ITEM_MOD_CRIT_RATING_SHORT"]
		hasteTot = hasteTot + stats["ITEM_MOD_HASTE_RATING_SHORT"]
		mastTot = mastTot + stats["ITEM_MOD_MASTERY_RATING_SHORT"]
		versTot = versTot + stats["ITEM_MOD_VERSATILITY"]

		if itemLink then
			numitems = numitems + 1
			if newi then 
				totali = totali + newi 
			else 
				local _,_,_,tempi = GetItemInfo(itemLink)
				totali = totali + tempi
			end
		end

	end
	
	avgi = totali / numitems

	return avgi, critTot, hasteTot, mastTot, versTot
		
		
end

local function OnTooltipSetItem(self)
	if not GameTooltip:IsEquippedItem() then --Not going through all the work for the item you're wearing
		local name, link = self:GetItem()
		if name then
			local equippable = IsEquippableItem( link )
			if not equippable then
				-- Nothing to do for not equipment
			else
				cs, hs, ms, vs = Comparitor( link)
				GameToolTip:AddDoubleLine( "Crit: ", cs,,,, ud1(cs), ud2(cs), ud3(cs))
				GameTooltip:AddDoubleLine( "Haste: ", hs,,,, ud1(cs), ud2(cs), ud3(cs))
				GameTooltip:AddDoubleLine( "Mastery: ", ms,,,, ud1(cs), ud2(cs), ud3(cs))
				GameTooltip:AddDoubleLine( "Vers: ",vs,,,, ud1(cs), ud2(cs), ud3(cs))
				GameToolTip:Show()
			end
		end
	end
end

function Comparitor( nlink)
	local _, eitem = GetAverageItemLevel()
	local newslvl, newcrit, newhaste, newmast, newvers = sumStats( n, nlink)
	local amrnow = self.db.char[name].stats.stattable[eitem]
	local amrnew = self.db.char[name].stats.stattable[newslvl]

	local ocrit = EquipAMR.curstats.crit
	local ohaste = EquipAMR.curstats.haste
	local omast = EquipAMR.curstats.mast
	local overs = EquipAMR.curstats.vers

	local opcrit = ocrit / amrnow.crit     -- Old stat percent of AMR
	local ophaste = ohaste / amrnow.haste
	local opmast = omast / amrnow.mast
	local opvers = overs / amrnow.vers

	local npcrit = newcrit / amrnew.crit	-- New stat percent of AMR
	local nphaste = newhaste / amrnew.haste
	local npmast = newmast / amrnew.mast
	local npvers = newvers / amrnew.vers

	local cstatus, hstatus, mstatus, vstatus ="no","no","no","no"

	if npcrit > opcrit then cstatus = "closer" end
	if nphaste > ophaste then hstatus = "closer" end
	if npmast > opmast then mstatus = "closer" end
	if npvers > opvers then vstatus = "closer" end

	return cstatus, hstatus, mstatus, vstatus
end

function ud1( strClose )  -- These functions exist in case I need to be able to programatically change the colors
	if strClose = "closer" then return 0.2 else return 1 end
end
function ud2( strClose )
	if strClose = "closer" then return 1 else return 0.2 end
end
function ud3( strClose )
	if strClose = "closer" then return 0.2 else return 0.2 end
end
