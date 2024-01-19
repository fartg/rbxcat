local MessagingService = game:GetService("MessagingService");
local httpService = game:GetService("HttpService")

local Config = require(game.ServerStorage.rbxcat.Config);
local EditServer = require(game.ServerStorage.rbxcat.Modules.Functions.EditServer);
local Module = require(game.ServerStorage.rbxcat.Modules.Functions.OpenCloudMessaging);

repeat task.wait() until EditServer.Return("server_id") ~= "None";

local server_id = EditServer.Return("server_id"); 
   
    --[[
        called in a fetch req https://apis.roblox.com/messaging-service/v1/universes/${universe_id}/topics/${server_id}
        body of {
            "message": "{\"event\":\"message\",\"arguments\":{\"message\":\"test\",\"type\":\"info\"}}"
        }

        The way you could get this in JS would be like:

        function serveto(json) {
            let send_to = `https://apis.roblox.com/messaging-service/v1/universes/${json["universe_id"]}/topics/${json["server_id"]}`;
            let new_json = {"message": {}}
            new_json.message = JSON.stringify(json["body"]);
            return fetch(send_to, {method: "POST", body: JSON.stringify(new_json), headers: {"Content-Type": "application/json","x-api-key": "snip"}});
        }

        I'll eventually publish rbxcat-server so you'll have all this code yourself :D
    ]]--

 MessagingService:SubscribeAsync(server_id, function(message)    

    local success, response = pcall(function()
        return httpService:JSONDecode(message.Data);
    end)
    print('message received: ', message.Data);

    if not success then print('json error'); end;

    for i, v in pairs(Module.commands) do
        if i == response.event then
            local ran = v.func(response.arguments);

            if ran[1] == true then
                response["response"] = ran[2];
                response["status"] = "done";

                Module.SendToServer(response);
                end
            return
         end
    end
end)