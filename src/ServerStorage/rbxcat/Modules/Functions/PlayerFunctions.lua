local pf = {}
local EditPlayer = require(game.ServerStorage.rbxcat.Modules.Functions.EditPlayer)

pf.Playtime = function (Player)
	local coro = coroutine.create(function()
		while game.ServerStorage.Players:FindFirstChild(Player.UserId) do
			EditPlayer.Player(Player, "time_played", EditPlayer.Return(Player, nil, "time_played") + 1) 
			EditPlayer.Stats(Player, "playtime", EditPlayer.Return(Player, "Stats", "playtime") + 1) 
			wait(1)
		end
	end)
	local success, result = coroutine.resume(coro)
end

return pf