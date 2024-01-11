-- Services
local Players = game:GetService("Players")

-- Modules
local EditPlayer = require(game.ServerStorage.rbxcat.Modules.Functions.EditPlayer);

local p = {}

p.Info = {
	["pass"] = { 
		["vip"] = {
			ID = 637419997,
			run = function(player)
				EditPlayer.Player(player, "vip", true);
			end,
		},
	},
	["product"] = {
		["tiny_gems"] = {
			ID = 1675608473,
			run = function(player)
				--MoneyHandler.Give(player, 500);
			end,
		},
	}
}

p.Return = function(_type, query)
	if p.Info[_type][query] == nil then return false end;
	return p.Info[_type][query];
end

return p
