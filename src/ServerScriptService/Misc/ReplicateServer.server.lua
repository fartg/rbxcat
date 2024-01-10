local server = game.ServerStorage.Server
local r_server = server:Clone();

r_server.Parent = game.ReplicatedStorage

server.AttributeChanged:Connect(function(attribute)
	r_server:SetAttribute(attribute, server:GetAttribute(attribute))
end)
