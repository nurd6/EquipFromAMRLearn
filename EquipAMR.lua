EquipAMR = LibStub("AceAddon-3.0"):NewAddon("EquipAMR", "AceConsole-3.0", "AceEvent-3.0" );

EamrDB = {}
local CRIT = 1
local HASTE = 2
local MAST = 3
local VERS = 4



EquipAMR.defaults = {
	profile = {
		enable = true,
		biginput = {1,{0, 0, 0, 0}}

	}
}

EquipAMR.options = {
	name = "EquipAMR"
	handler = "EquipAMR"
	type = "group",
	get = "get",
	set = "set",
	args = {
		enable = {
			name = "Enable",
			desc = "Enables / disables the addon",
			type = "toggle",
			order = 0,
		},
		biginput = {
			name = "AMR ML Data",
			desc = "Paste ML Data Here",
			type = "input",
			multiline = true,
			order = 2,
		},
	},
}	--]]


function EquipAMR:get(key)
	return self.db.profile[key[#key]]
end

function EquipAMR:get(key,value)
	if key[#key] = "biginput" then
		self.db.profile.biginput = saveit(value)
	else
		self.db.profile[key[#key] = value
	end
	
end


function EquipAMR:saveIt(value)

return praseintotable(value)

		
end

function EquipAMR:statGet(info)
		return table.concat( self.db.char.stats.stattable , " " )
end


function EquipAMR:OnInitialize()
		-- Called when the addon is loaded
		curstats = {}
		self.db = LibStub("AceDB-3.0"):New("EamrDB", self.defaults)
		local profileOptions = LibStub("AceDBOptions-3.0"):GetOptionsTable(self.db)

		LibStub("AceConfig-3.0"):RegisterOptionsTable("EquipAMR", self.options)
		LibStub("AceConfig-3.0"):RegisterOptionsTable("EquipAMR Profile", profileoptions)

		olvl, ocrit, ohaste, omast, overs = sumstats(o, nil)
		tempstats = {ocrit, ohaste, omast, overs}
		table insert(curstats, [oilvl] = tempstats)
		self:Print("OnInitialize Event Fired: Hello")
end

function EquipAMR:OnEnable()
		-- Called when the addon is enabled

		-- Print a message to the chat frame
		self:Print("OnEnable Event Fired: Hello, again ;)")
end

function EquipAMR:OnDisable()
		-- Called when the addon is disabled
end
