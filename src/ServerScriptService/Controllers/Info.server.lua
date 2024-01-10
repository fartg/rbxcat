-- If you're looking for PlayerReady, it's handled in game.ServerScriptService.Main & game.StarterPlayer.StarterPlayerScripts.Framework.Ready

local EditPlayer = require(game.ServerStorage.rbxcat.Modules.Functions.EditPlayer);
local EditServer = require(game.ServerStorage.rbxcat.Modules.Functions.EditServer);

local info_events = game.ReplicatedStorage.Events.Info;

info_events.ReturnPlayerQuery.OnServerInvoke = function(player, _type, index)
	return EditPlayer.Return(player, _type, index);
end

info_events.ReturnServerQuery.OnServerInvoke = function(player, _type, index)
	return EditServer.Return(index, _type);
end