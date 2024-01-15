local DataStoreService = game:GetService("DataStoreService");

local SettingsData = DataStoreService:GetDataStore("Settings");
local InventoryData = DataStoreService:GetDataStore("Inventory");
local StatsData = DataStoreService:GetDataStore("Stats");

local datastore = {}

datastore.LoadAll = function(player)
	local settings;
    local _settings;
	local inventory;
	local _inventory;
	local _stats;
	local __stats;
	
    -- if the data doesn't exist, we treat the player as new
    -- note: this will cause issue if you don't have all of your player folders set prior, change at your own risk
	local new_player = false;

	local settings_success, err = pcall(function()
		settings = SettingsData:GetAsync(player.UserId)
	end)

	if settings_success and settings then
		_settings = settings;
	else
		new_player = true;
	end

	local inventory_success, err = pcall(function()
		_inventory = InventoryData:GetAsync(player.UserId)
	end)

	if inventory_success and _inventory then
		inventory = _inventory;
	else
		new_player = true;
	end

	local stats_success, err = pcall(function()
		_stats = StatsData:GetAsync(player.UserId)
	end)

	if stats_success and _stats then
		__stats = _stats;
	else
		new_player = true;
	end

	
	return new_player, _settings, _inventory, __stats
end

datastore.SaveSettings = function(player)
	local _player = game.ServerStorage.Players:FindFirstChild(player.UserId);
	local client_settings = _player.Settings;

	local _settings = {};

	for i, v in pairs(client_settings:GetAttributes()) do
		_settings[i] = v
	end

	local settings_success, err = pcall(function()
		SettingsData:SetAsync(player.UserId, _settings)
	end)

	if not settings_success then
		warn(err) -- data not saved
	end
end

datastore.SaveInventory = function (player)
	local _player = game.ServerStorage.Players:FindFirstChild(player.UserId);
	local inventory = _player.Inventory;

	local _inventory = {
	};

	for i, v in pairs(inventory:GetAttributes()) do
		_inventory[i] = v
	end

	local inv_success, err = pcall(function()
		InventoryData:SetAsync(player.UserId, _inventory)
	end)

	if not inv_success then
		warn(err) -- data not saved
	end
end

datastore.SaveStats = function(player)
	local _player = game.ServerStorage.Players:FindFirstChild(player.UserId);
	local __stats = _player.Stats;

	local _stats = {};

	for i, v in pairs(__stats:GetAttributes()) do
		_stats[i] = v
	end

	local stats_success, err = pcall(function()
		StatsData:SetAsync(player.UserId, _stats)
	end)

	if not stats_success then
		warn(err) -- data not saved
	end
end

datastore.SaveAll = function(player)
    data.SaveSettings(player);
	data.SaveInventory(player);
	data.SaveStats(player);
end

return datastore
