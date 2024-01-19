local analytics = {}
local httpService = game:GetService("HttpService")

local _settings = require(script.Parent.AnalyticsSettings);
local secrets = require(script.Parent.Secrets);
local BaseVariables = require(game.ServerStorage.rbxcat.Modules.Info.BaseVariables);
local EditServer = require(game.ServerStorage.rbxcat.Modules.Functions.EditServer);
local Promise = require(game.ServerStorage.rbxcat.Modules.Misc.Promise);

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

function generateLivePlayerData(player)
	local _player = game.ServerStorage.Players:WaitForChild(player.UserId);
	local server = game.ServerStorage.Server;

	local return_data = {["player"] = {}}

	-- player attributes
	return_data["player"]["player"] = {};

	for i, v in pairs(_player:GetAttributes()) do
		return_data["player"]["player"][i] = v;
	end

	for i, v in pairs(BaseVariables.Overview) do
		return_data["player"][v] = {};

		for k, j in pairs(_player:FindFirstChild(v):GetAttributes()) do
			return_data["player"][v][k] = j;
		end
	end

	-- server attributes
	return_data["player"]["game"] = {};

	for i, v in pairs(server:GetAttributes()) do
		return_data["player"]["game"][i] = v;
	end

	-- set up player's roblox information
	return_data["player"]["userid"] = player.UserId;
	return_data["player"]["displayname"] = player.DisplayName;
	return_data["player"]["name"] = player.Name;

	-- set up server
	return_data["player"]["game"]["name"] = _settings.game_name;

	return return_data;
end

function generateServerData(data)
	local server = game.ServerStorage.Server;

	local return_data = {
		["embed"] = _settings.show_server_embeds,
		["server_id"] = server:GetAttribute("server_id"),
		["rbx_ocm_alias"] = secrets["rbx_ocm_alias"],
		["game"] = _settings.game_name,
		["event"] = data.event,
		["players"] = analytics.generatePlayers()
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
			return httpService:PostAsync(secrets["webserver"] .. _type, httpService:JSONEncode(data), Enum.HttpContentType.ApplicationJson, false, {["authorization"] = secrets["api_key"]});
	end)
	if success then
		return httpService:JSONDecode(response);
	end
end

analytics.generatePlayers = function()
	local return_table = {};
	
	for _, player in pairs(game.Players:GetPlayers()) do
		table.insert(return_table, player.Name);
	end

	return return_table;
end

analytics.player = function (player, data)
	return sendAnalytics("user", generatePlayerData(player, data));
end;

analytics.livePlayer = function(player)
	return sendAnalytics("live_player", generateLivePlayerData(player));
end;

analytics.server = function (data)
	if data.event == "open" then

		local success, response = Promise.new(function(resolve, reject, onCancel)
			local r = sendAnalytics("server", requestServerId());
			resolve(r);
		end):await();
		
		if not success then print(response) return end;
		
		EditServer.Self("server_id", response["server_id"])
	end

	return sendAnalytics("server", generateServerData(data));
end;

analytics.playerData = function(player)
	return generateLivePlayerData(player);
end;

return analytics;