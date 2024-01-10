local BaseVariables = require(game.ServerStorage.rbxcat.Modules.Info.BaseVariables)
local EditPlayer = require(game.ServerStorage.rbxcat.Modules.Functions.EditPlayer)
local VarFuncs = require(game.ServerStorage.rbxcat.Modules.Functions.Variables)
local Rewards = require(game.ServerStorage.rbxcat.Modules.Info.Rewards);

local v = {}


v.Create = function(Player)
	local Folder, InvFolder, ConfFolder, StatsFolder, GiftsFolder = VarFuncs.CreateFolders(Player);
	
	-- Create and edit folders for player :)
	for i, v in pairs(BaseVariables.Player) do
		EditPlayer.Player(Player, i, v);
	end
	
	for i, v in pairs(BaseVariables.Inventory) do
		EditPlayer.Inventory(Player, i, v);
	end
	
	for i, v in pairs(BaseVariables.Settings) do
		EditPlayer.Settings(Player, i, v);
	end
	
	for i, v in pairs(BaseVariables.Stats) do
		EditPlayer.Stats(Player, i, v);
	end
	
	for i, v in pairs(BaseVariables.Gifts) do
		EditPlayer.Gifts(Player, i, v);
	end
	
	--Set the join time
	EditPlayer.Player(Player, "join_time", os.time())
	
	--Create the rewards for a player
	Rewards.Create(Player)
	
	return true
end

v.Delete = function(Player)
	game.ReplicatedStorage.Players:FindFirstChild(Player.UserId):Destroy();
	game.ServerStorage.Players:FindFirstChild(Player.UserId):Destroy();
end

return v
