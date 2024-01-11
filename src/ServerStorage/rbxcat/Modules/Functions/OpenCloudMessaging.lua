
local Analytics = require(game.ServerStorage.rbxcat.Modules.Misc.Analytics);
local EditServer = require(game.ServerStorage.rbxcat.Modules.Functions.EditServer);
local Secrets = require(game.ServerStorage.rbxcat.Modules.Misc.Secrets);
local ClientEvents = game.ReplicatedStorage.Events.Client;

local module = {};

module.commands = {
    ["forceupdate"] = {
        func = function()
            module.ForceUpdate();
        end,
    },
    ["message"] = {
        func = function(arguments)
            ClientEvents.SystemMessage:FireAllClients(arguments.message, arguments.type);
        end;
    },
    ["findplayer"] = {
        func = function(arguments) 
            for player in game.Players:GetPlayers() do
                if player.Name == arguments.player then
                    module.SendToServer({["type"] = "player_found", ["value"] = EditServer.Return("server_id")});
                    return
                end
            end
        end
    }
}

module.SendToServer = function(data)
    local success, response = pcall(function()
        return httpService:PostAsync(Secrets["webserver"] .. "serveto", httpService:JSONEncode(data), Enum.HttpContentType.ApplicationJson, false, {["authorization"] = Secrets["api_key"]});
    end)
    if success then
        return httpService:JSONDecode(response);
    end
end

module.ForceUpdate = function()
	Analytics.server({["event"] = "update"});
end

return module;
