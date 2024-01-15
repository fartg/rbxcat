local Config = require(game.ServerStorage.rbxcat.Config);

local BaseVariables = require(game.ServerStorage.rbxcat.Modules.Info.BaseVariables);
local VarFuncs = require(game.ServerStorage.rbxcat.Modules.Functions.Variables);

local EditPlayer = require(game.ServerStorage.rbxcat.Modules.Functions.EditPlayer);

local Datastore = require(game.ServerStorage.rbxcat.Modules.Functions.Datastore);

local Rewards = require(game.ServerStorage.rbxcat.Modules.Info.Rewards);

local v = {}


v.Create = function(Player)
	local Folder, InvFolder, ConfFolder, StatsFolder, GiftsFolder = VarFuncs.CreateFolders(Player);
	
	-- Create and edit folders for player :)
	for i, v in pairs(BaseVariables.Player) do
		EditPlayer.Player(Player, i, v);
	end

	for i, v in pairs(BaseVariables.Settings) do
		EditPlayer.Settings(Player, i, v);
	end
	
	for i, v in pairs(BaseVariables.Inventory) do
		EditPlayer.Inventory(Player, i, v);
	end
	
	for i, v in pairs(BaseVariables.Stats) do
		EditPlayer.Stats(Player, i, v);
	end
	
	for i, v in pairs(BaseVariables.Gifts) do
		EditPlayer.Gifts(Player, i, v);
	end

	if Config["datastore"] then
		-- Grab new_player and all of our data from our datastore module
		local new_player, _settings, _inventory, _stats = Datastore.LoadAll(Player);
		
		-- If it's not a new player, let's set the data now. If they are new, the data is already set :)
		if not new_player then
			for i, v in pairs(_settings) do
				EditPlayer.Settings(Player, i, v);
			end

			for i, v in pairs(_inventory) do
				EditPlayer.Inventory(Player, i, v);
			end

			for i, v in pairs(_stats) do
				EditPlayer.Stats(Player, i, v);
			end
		end
	end
	
	--Set the join time
	EditPlayer.Player(Player, "join_time", os.time())
	
	--Create the rewards for a player
	Rewards.Create(Player)
	
	return true
end

v.Delete = function(Player)
	-- if we have datastore functionality enabled, let's save player data before they leave
	if Config["datastore"] then
		Datastore.SaveAll(Player);
	end

	game.ReplicatedStorage.Players:FindFirstChild(Player.UserId):Destroy();
	game.ServerStorage.Players:FindFirstChild(Player.UserId):Destroy();
end

return v
