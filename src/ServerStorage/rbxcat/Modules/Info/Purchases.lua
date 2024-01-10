-- Services
local Players = game:GetService("Players")

-- Modules
local EditPlayer = require(game.ServerStorage.rbxcat.Modules.Functions.EditPlayer);

local p = {}

p.Info = {
	["pass"] = { 
		
	},
	["product"] = {
		
	}
}

p.Return = function(_type, query)
	if p.Info[_type][query] == nil then return false end;
	return p.Info[_type][query];
end

return p
