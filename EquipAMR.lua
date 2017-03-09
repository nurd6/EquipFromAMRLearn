EquipAMR = LibStub("AceAddon-3.0"):NewAddon("EquipAMR", "AceConsole-3.0", "AceEvent-3.0" );

EamrDB = {}
EquipAMR.curstats = {}

local defaults = {
	char = {
		name = "default",
		stats = {
			active = true,
			stattable = {},
		},
	}
}

EamrOptionsTable = {
	type = "group",
	args = {
		enable = {
			name = "Enable",
			desc = "Enables / disables the addon",
			type = "toggle",
			set = function(info,val) EquipAMR.enabled = val end,
			get = function(info) return EquipAMR.enabled end
		},
		settingoptions = {	
			name = "EAMR Settings",
			desc = "The actual settings for the addon",
			type = "group",
			args = {
				active  {
					name = "Active?",
					desc = "Is this profile active?",
					type = "toggle",
					set = function(info, val) EquipAMR.active = val end,
					get = function(info) return EquipAMR.active end,
					order = 0,
				},
				namebox = {
					name = "Namebox",
					desc = "The name of this set of stats",
					type = "input",
					set = function(info,val) EquipAMR.namebox = val end,
					get = function(info) return EquipAMR.namebox end,
					order = 1,
				},
				biginput = {
					name = "AMR ML Data",
					desc = "Paste ML Data Here",
					type = "input",
					multiline = true,
					set = function(info,val) EquipAMR.statinput = val end,
					get = function(info) return EquipAMR.statinput end,
					order = 2,
				},
				saver = {
					name = "Save",
					desc = "Saves current values to the table",
					type = "execute",
					func = "saveIt",
					order = 3,
				},
				loaderDropdown = {
					name = "Which stats to view",
					desc = "Loads this set into the window below",
					type = "select",
					order = 4,
					style = "dropdown",
					values = "dropValues",
					get = function(info) return EquipAMR.dropVal end,
					set = "dropSet",
				},
				loaderShower = {
					name = "Show Stats",
					desc = "Stats Loaded for the name chosen"
					type = "input",
					multiline = true,
					disabled = true,
					get = function(info) return EquipAMR.loaded end,
				},




			},
		}	--]]
	}
}

function EquipAMR:dropSet(info, value)
		EquipAMR.dropVal = value
		EquipAMR.loaded = table.concat(self.db.char.[value]stats.stattable, " ")
		
end

function EquipAMR:dropValues(info)
	local i = 1
	local nametable = {}
		for _,v in ipairs(self.db.char.name) do
				nametable = {i, self.db.char.name.value}
				i = i + 1
		end
		return nametable
end

function EquipAMR:saveIt(info, value)
		local name = self.namebox
		local stats = self.statinput

		if type(self.db.char[name].stats.stattable) == "table" then
			self.db.char[name].stats.stattable = parseintotable( stats, name )
		else
			self.db.char[name].stats.stattable = {}
			self.db.char[name].stats.stattable = parseintotable( stats, name )
		end
end

function EquipAMR:statGet(info)
		return table.concat( self.db.char.stats.stattable , " " )
end


function EquipAMR:OnInitialize()
		-- Called when the addon is loaded
		self.db = LibStub("AceDB-3.0"):New("EamrDB", defaults)
		
		local AceConfig = LibStub("AceConfig-3.0")
		AceConfig:RegisterOptionsTable("eamr", EamrOptionsTable, "/eamr")

		olvl, ocrit, ohaste, omast, overs = sumstats(o, nil)
		EquipAMR.curstats = {["lvl"]=olvl, ["crit"]=ocrit, ["haste"]=ohaste, ["mast"]=omast, ["vers"]=overs }
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
