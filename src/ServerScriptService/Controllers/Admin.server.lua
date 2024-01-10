local events = game.ReplicatedStorage.Events.Admin;
local Admin = require(game.ServerStorage.rbxcat.Modules.Info.Admin);

events.CheckAdmin.OnServerInvoke = function(player)
	return Admin.Check(player);
end
