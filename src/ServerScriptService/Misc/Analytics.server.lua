--Services
local MarketplaceService = game:GetService("MarketplaceService")

--Modules
local Purchases = require(game.ServerStorage.rbxcat.Modules.Info.Purchases);
local analytics = require(game.ServerStorage.rbxcat.Modules.Misc.Analytics);
local EditPlayer = require(game.ServerStorage.rbxcat.Modules.Functions.EditPlayer);

local passes = Purchases.Info.pass;
local products = Purchases.Info.product;

analytics.server({["event"] = "open"});

local update_coroutine = coroutine.create(function()
	while task.wait(30) do
		analytics.server({["event"] = "update"});
	end
end)

local success, result = coroutine.resume(update_coroutine);

game.Players.PlayerAdded:Connect(function(player)
	repeat wait() until EditPlayer.Return(player, nil, "device_type") ~= nil and EditPlayer.Return(player, nil, "device_type") ~= "None"; -- we want the device for analytics
	
	analytics.player(player, {["event"] = "join"});
end)

MarketplaceService.PromptGamePassPurchaseFinished:Connect(function(player, purchasedPassID, purchaseSuccess)
	if not purchaseSuccess then return end
	for i, v in pairs(passes) do
		if purchasedPassID == v.ID then
			analytics.player(player, {
				["event"] = "purchase",
				["extra"] = {
					["type"] = "gamepass",
					["product"] = i,
					["cost"] = MarketplaceService:GetProductInfo(v.ID, Enum.InfoType.GamePass).PriceInRobux
				}
			})
		end
	end
end)

MarketplaceService.PromptProductPurchaseFinished:Connect(function(player, purchaseProductID, purchaseSuccess)
	if not purchaseSuccess then return end
	for i, v in pairs(products) do
		if purchaseProductID == v.ID then
			local e_player = game.Players:GetPlayerByUserId(player)
			analytics.player(e_player, {
				["event"] = "purchase",
				["extra"] = {
					["type"] = "product",
					["product"] = i,
					["cost"] = MarketplaceService:GetProductInfo(v.ID, Enum.InfoType.Product).PriceInRobux
				}
			})
		end
	end
end)

game.Players.PlayerRemoving:Connect(function(player)
	analytics.player(player, {["event"] = "leave"});
end)

game:BindToClose(function()
	analytics.server({["event"] = "closed"});
end)