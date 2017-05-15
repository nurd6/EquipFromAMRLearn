-- Author      : Nurd6
-- Create Date : 3/8/2017 11:53:39 AM

function EquipAMR:parseintotable ( biginput )

	local tempsplit = {}
	local sparsetable = {}
	local counter
	local tempilvl, low, high
	
	for token in string.gmatch(line, "[^%s]+") do
		if token == "Item" or token == "Level" then
			counter = 0
		else
			if counter = 0 then
				tempilvl = tonumber(token)
				counter = 1
				if tempilvl < low then
					low = tempilvl
				end
				if tempilvl > high then 
					high = tempilvl
				end

			else 
				tempsplit[counter] = tonumber(token)			
				counter = counter + 1
			end
		end
	
	end

	table.insert(sparsetable, [tempilvl] = tempsplit)
		
	return filltherestoftable(sparsetable,low,high)


end

function referencedisplaycode ( stable ) --This displays all the rows, use as reference
	for _,row in ipairs(stable) do
		print("{"..table.concat(row,',').."}")
	end 
end


	
	

function EquipAMR:statatpoint( ilvl1, stat1, ilvl2, stat2, cur )
	return ( stat1 + stat2 ) * (  cur / ( ilvl1 + ilvl2 ) )
end

function EqupiAMR:setstatatpoint( bigglobalstat, low, high, curilvl )
	local lcrit,lhaste,lmast,lvers
	local lstats = {}
	local tstats = {}

	lcrit = statatpoint( low, bigglobalstat[low][1], high, bigglobalstat[high][1], curilvl )
	lhaste = statatpoint( low, bigglobalstat[low][2], high, bigglobalstat[high][2], curilvl )
	lmast = statatpoint( low, bigglobalstat[low][3], high, bigglobalstat[high][3], curilvl )
	lvers = statatpoint( low, bigglobalstat[low][4], high, bigglobalstat[high][4], curilvl )

	table.insert(lstats, 1 = lcrit)
	table.insert(lstats, 2 = lhaste)
	table.insert(lstats, 3 = lmast)
	table.insert(lstats, 4 = lvers)

	table.insert(tstats, curilvl = lstats)

	return tstats


	
end

function EquipAMR:tableContains(set, key)
	return set[key] ~= nil
end
			
function EquipAMR:filltherestoftable( sparsetable,lowest, highest )
local curlow, curhigh, lowbound,upperbound
local tempilvl
local tempstat = {}

lowbound = lowest
upperbound = highest

	for i = lowbound, upperbound, 1 do
		if i % 10 == 0 then curlow = i curhigh = i + 10
		else tempstat = setstatatpoint( sparsetable, curlow, curhigh, i)
		end
	end

return tempstat
end

function EquipAMR:sumStats(oldnew, nlink  )
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

function EquipAMR:OnTooltipSetItem(self)
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

function EquipAMR:Comparitor( nlink)
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

function EquipAMR:ud1( strClose )  -- These functions exist in case I need to be able to programatically change the colors
	if strClose = "closer" then return 0.2 else return 1 end
end
function EquipAMR:ud2( strClose )
	if strClose = "closer" then return 1 else return 0.2 end
end
function EquipAMR:ud3( strClose )
	if strClose = "closer" then return 0.2 else return 0.2 end
end
