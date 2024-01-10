local EditPlayer = require(game.ServerStorage.rbxcat.Modules.Functions.EditPlayer)

local rewards = {}

rewards.Info = {
	["Basic"] = {
		["gift1"] = {
			exec = function(player)
			end,
		},
		["gift2"] = {
			exec = function(player)
			end,
		},
		["gift3"] = {
			exec = function(player)
			end,
		},
		["gift4"] = { 
			exec = function(player)
			end,
		},
		["gift5"] = { 
			exec = function(player)
			end,
		},
	},
	["Daily"] ={
		--...
	}
}

rewards.Claim = function(Player, gift)
	EditPlayer.Gifts(Player, gift .. "_claimed", true);
end

rewards.Create = function(Player)
	EditPlayer.Gifts(Player, "gift1", os.time()+(60*5))
	EditPlayer.Gifts(Player, "gift2", os.time()+(60*15))
	EditPlayer.Gifts(Player, "gift3", os.time()+(60*30))
	EditPlayer.Gifts(Player, "gift4", os.time()+(60*45))
	EditPlayer.Gifts(Player, "gift5", os.time()+(60*60))	
end

return rewards
