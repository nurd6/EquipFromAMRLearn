EquipAMR = LibStub("AceAddon-3.0"):NewAddon("EquipAMR", "AceConsole-3.0", "AceEvent-3.0" );

EamrDB = { }

local defaults = {
	char = {
		name = "default",
		stats = {
			active = true,
			stattable = { },
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
			set = function(info,val) MyAddon.enabled = val end,
			get = function(info) return MyAddon.enabled end
		},
		settingoptions = {	
			name = "EAMR Settings",
			desc = "The actual settings for the addon",
			type = "group",
			args = {
				namebox = {
					name = "Namebox",
					desc = "The name of this set of stats",
					type = "input",
					set = "nameset",
					get = "nameget",
				},
				biginput = {
					name = "AMR ML Data",
					desc = "Paste ML Data Here",
					type = "input",
					multiline = true,
					set = "statSet",
					get = "statGet",
				},
			},
		}	--]]
	}
}

function EquipAMR:nameset(info, value)
		EamrDB.char.stats.name = value
		
end

function EquipAMR:nameget(info)
		for l, v in pairs(EamrDB.char.stats.name) do
			self.name = l

		end
		return self.name
end

function EquipAMR:statSet(info, value)
		EamrDB.char.stats.stattable = parseintotable( value, self.name )
end

function EquipAMR:statGet(info)
		return table.concat( EamrDB.char.stats.stattable , " " )
end


function EquipAMR:OnInitialize()
		-- Called when the addon is loaded
		self.db = LibStub("AceDB-3.0"):New("EamrDB", defaults)

		-- Print a message to the chat frame
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
