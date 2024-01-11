local MessagingService = game:GetService("MessagingService");
local httpService = game:GetService("HttpService")

local Config = require(game.ServerStorage.rbxcat.Config);
local EditServer = require(game.ServerStorage.rbxcat.Modules.Functions.EditServer);
local Module = require(game.ServerStorage.rbxcat.Modules.Functions.OpenCloudMessaging);

game.Players.PlayerAdded:Connect(function(player)
    repeat task.wait() until EditServer.Return("server_id") ~= "None";

    local server_id = EditServer.Return("server_id");

    -- called in a fetch req https://apis.roblox.com/messaging-service/v1/universes/${universe_id}/topics/${server_id}
    -- body of {
    --  "message": "{\"event\":\"message\",\"arguments\":{\"message\":\"test\",\"type\":\"info\"}}"
    -- }
    local message_connection = MessagingService:SubscribeAsync(server_id, function(message)
        local success, response = pcall(function()
            return httpService:JSONDecode(message.Data);
        end)
        if not success then print('json error'); end;

        for i, v in pairs(Module.commands) do
            if i == response.event then
                v.func(response.arguments);
                return
            end
        end
    end)

    player.AncestryChanged:Connect(function()
        message_connection:Disconnect();
    end)
end)