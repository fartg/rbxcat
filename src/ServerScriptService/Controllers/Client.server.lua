local events = game.ReplicatedStorage.Events.Client;

local edit_player = require(game.ServerStorage.rbxcat.Modules.Functions.EditPlayer);

events.Device.OnServerEvent:Connect(function(player, value)
	if value ~= "Mobile (tablet)" and value ~= "Mobile (phone)" and value ~= "Console" and value ~= "Desktop" then
		-- cheater
		print("cheater");
	end
	
	edit_player.Player(player, "device_type", value);
end)

events.SettingsUpdate.OnServerEvent:Connect(function(player, index, value) 
	edit_player.Settings(player, index, value)
end)
