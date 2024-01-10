local Players = game:GetService("Players");

local Variables = require(game.ServerStorage.rbxcat.Modules.Variables);
local PlayerFunctions = require(game.ServerStorage.rbxcat.Modules.Functions.PlayerFunctions);

local ready_event = game.ReplicatedStorage.Events.Info.PlayerReady;

Players.PlayerAdded:Connect(function(player)
	repeat wait() until Variables.Create(player);
	
	PlayerFunctions.Playtime(player);
	
	ready_event:FireClient(player);
	
	player.CharacterAdded:Connect(function(character)
		-- player respawned;
		
	end)
end)

Players.PlayerRemoving:Connect(function(player)
	-- save data;
	
	Variables.Delete(player);
end)
