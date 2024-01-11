-- Services
local MarketplaceService = game:GetService("MarketplaceService")

-- Modules
local EditPlayer = require(game.ServerStorage.rbxcat.Modules.Functions.EditPlayer);
local Purchases = require(game.ServerStorage.rbxcat.Modules.Info.Purchases);

-- Gamepass info
local passes = Purchases.Info.pass;

-- Products info
local products = Purchases.Info.product;

-- Check for gamepasses on player connect
game.Players.PlayerAdded:Connect(function(player)
	player.CharacterAdded:Wait()
	for i, v in pairs(passes) do
		local hasPass = false

		local success, err = pcall(function()
			hasPass = MarketplaceService:UserOwnsGamePassAsync(player.UserId, v.ID)
		end)

		if not success then return end

		if hasPass then
			v.run(player)
		end
	end
end)

-- Handle completed purchases
MarketplaceService.PromptGamePassPurchaseFinished:Connect(function(player, purchasedPassID, purchaseSuccess)
	if not purchaseSuccess then return end
	for i, v in pairs(passes) do
		if purchasedPassID == v.ID then
			v.run(player)
		end
	end
end)

MarketplaceService.PromptProductPurchaseFinished:Connect(function(player, purchaseProductID, purchaseSuccess)
	if not purchaseSuccess then return end
	for i, v in pairs(products) do
		if purchaseProductID == v.ID then
			local e_player = game.Players:GetPlayerByUserId(player)
			v.run(e_player)
		end
	end
end)