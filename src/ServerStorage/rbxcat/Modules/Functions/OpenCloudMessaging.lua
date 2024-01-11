local httpService = game:GetService("HttpService")

local Analytics = require(game.ServerStorage.rbxcat.Modules.Misc.Analytics);
local EditServer = require(game.ServerStorage.rbxcat.Modules.Functions.EditServer);
local Secrets = require(game.ServerStorage.rbxcat.Modules.Misc.Secrets);
local Config = require(game.ServerStorage.rbxcat.Config);

local ClientEvents = game.ReplicatedStorage.Events.Client;


local module = {};

module.commands = {
    ["forceupdate"] = {
        func = function()
            Analytics.server({["event"] = "update"});
            return true;
        end,
    },
    ["message"] = {
        func = function(arguments)
            ClientEvents.SystemMessage:FireAllClients(arguments.message, arguments.type);
            return true;
        end;
    },
    ["findplayer"] = {
        func = function(arguments) 
            for _, player in pairs(game.Players:GetPlayers()) do
                if player.Name == tostring(arguments.player) then
                    return true
                end
            end
            return false;
        end
    }
}

module.SendToServer = function(data)
    -- Let's add identifying information about the server so we can log it.
    data["server_id"] = EditServer.Return("server_id");
    data["server_version"] = EditServer.Return("version");
    data["game"] = Config["game_name"];

    local success, response = pcall(function()
        return httpService:PostAsync(Secrets["webserver"] .. "servefrom", httpService:JSONEncode(data), Enum.HttpContentType.ApplicationJson, false, {["authorization"] = Secrets["api_key"]});
    end)
    if success then
        return httpService:JSONDecode(response);
    end
    if not success then
        print(response);
    end
end

return module;
