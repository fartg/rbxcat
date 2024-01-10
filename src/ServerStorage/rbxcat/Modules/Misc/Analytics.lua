local analytics = {}
local httpService = game:GetService("HttpService")

local _settings = require(script.Parent.AnalyticsSettings);
local secrets = require(script.Parent.Secrets);
local EditServer = require(game.ServerStorage.rbxcat.Modules.Functions.EditServer);

function generatePlayerData(player, data)
	local _player = game.ServerStorage.Players:WaitForChild(player.UserId);
	local server = game.ServerStorage.Server;

	local return_data = {
		["embed"] = _settings.show_player_embeds,
		["player"] = player.UserId,
		["game"] = _settings.game_name,
		["server_id"] = server:GetAttribute("server_id"),
		["device_type"] = _player:GetAttribute("device_type"),
		["playtime"] = _player:GetAttribute("time_played"),
		["event"] = data.event;
	}

	if data.extra ~= nil then
		return_data.extra = {}; 
		for i, v in pairs(data.extra) do
			return_data.extra[i] = v
		end
	end;

	return return_data
end

function generateServerData(data)
	local server = game.ServerStorage.Server;

	local return_data = {
		["embed"] = _settings.show_server_embeds,
		["server_id"] = server:GetAttribute("server_id"),
		["game"] = _settings.game_name,
		["event"] = data.event,
		["players"] = #game.Players:GetPlayers(),
	};

	if data.event == "update" then return_data.embed = false end

	if data.extra ~= nil then
		return_data.extra = {}; 
		for i, v in pairs(data.extra) do
			return_data.extra[i] = v
		end
	end;

	return return_data;
end

function requestServerId()
	return {
		["game"] = _settings.game_name,
		["event"] = "request",
	}
end

function sendAnalytics(_type, data)
	local success, response = pcall(function()
		local request = httpService:PostAsync(secrets["webserver"] .. _type, httpService:JSONEncode(data), Enum.HttpContentType.ApplicationJson, false, {["authorization"] = secrets["api_key"]});
		return request
	end)
	if success then
		return httpService:JSONDecode(response);
	end
end

analytics.player = function (player, data)
	return sendAnalytics("user", generatePlayerData(player, data));
end;

analytics.server = function (data)
	if data.event == "open" then
		local response = sendAnalytics("server", requestServerId());
		EditServer.Self("server_id", response["server_id"]);
	end

	return sendAnalytics("server", generateServerData(data));
end;

return analytics;