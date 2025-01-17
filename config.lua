Config = {}

Config.DebugPoly = false				-- Global debug poly for everything
Config.RestartingScript = true			-- If restarting script whilst creating zones put this to true otherwise false
Config.Moneytype = 'money'				-- Money type -- money or bank

Config.AllGangs = {						-- Input all gang names here
	["mechanic"] = true,
	["police"] = true,
	["ambulance"] = true,
}

Config.HomeTurfZones = {
	["mechanic"] = {					-- Gang name
		["gang_name"] = 'mechanic', 	-- Gang Name
		["zoneColour"] = 1,				-- Box Zone Colour	
		["zoneAlpha"] = 80,				-- Box Zone Opacity
		["zoneParts"] = {
			{
				["coords"] = vector3(274.96, -1758.57, 29.29),		-- Box zone coordinates
				["length"] = 84.4,									-- Box zone length
				["width"] = 116.4,									-- Box zone width
				["heading"] = 230,									-- Box zone heading
				["name"] = 'balas_1',								-- Name needs to be unique
				["maxz"] = 40.0,									-- Max height
				["debugPoly"] = true,								-- Green box in game toggle
			},
		},
		["blip"] = {
			["enable"] = false,
			["coords"] = vector3(-1531.5464, -2872.2424, 14.3590),	-- Coords of blip, can be anywhere, usually inside of the zone
			["id"] = 437,											-- Sprite of the blip
			["display"] = 4,										-- Display on minimap
			["scale"] = 0.5,										-- Scale
			["colour"] = 1,											-- Colour
			["shortRange"] = true,									-- Short range on minimap
			["text"] = 'Mechanics Turf',							-- The text of the blip
		},
		["killReward"] = 500,										-- Reward for killing another gang member inside this zone
	},
	
	["police"] = {					-- Gang name
		["gang_name"] = 'police', 	-- Gang Name
		["zoneColour"] = 1,				-- Box Zone Colour	
		["zoneAlpha"] = 80,				-- Box Zone Opacity
		["zoneParts"] = {
			{
				["coords"] = vector3(371.7, -1765.13, 29.31),		-- Box zone coordinates
				["length"] = 20.4,									-- Box zone length
				["width"] = 13.2,									-- Box zone width
				["heading"] = 320,									-- Box zone heading
				["name"] = 'police_1',								-- Name needs to be unique
				["maxz"] = 40.0,									-- Max height
				["debugPoly"] = true,								-- Green box in game toggle
			},
		},
		["blip"] = {
			["enable"] = false,
			["coords"] = vector3(371.7, -1765.13, 29.31),	-- Coords of blip, can be anywhere, usually inside of the zone
			["id"] = 437,											-- Sprite of the blip
			["display"] = 4,										-- Display on minimap
			["scale"] = 0.5,										-- Scale
			["colour"] = 1,											-- Colour
			["shortRange"] = true,									-- Short range on minimap
			["text"] = 'Police Turf',							-- The text of the blip
		},
		["killReward"] = 500,										-- Reward for killing another gang member inside this zone
	},
	
	
	
}
