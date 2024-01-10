local edit = {}

local function Edit(player, _type,  index, value)
	local Folder = game.ServerStorage.Players:WaitForChild(player.UserId);
	local r_Folder = game.ReplicatedStorage.Players:WaitForChild(player.UserId);
	
	if _type == nil then
		Folder:SetAttribute(index, value)
		r_Folder:SetAttribute(index, value)
		return
	end
	
	Folder:WaitForChild(_type):SetAttribute(index, value);
	r_Folder:WaitForChild(_type):SetAttribute(index, value);
end

edit.Player = function (player, index, value)
	Edit(player, nil, index, value);
end

edit.Inventory = function (player, index, value)
	Edit(player, "Inventory", index, value);
end

edit.Settings = function (player, index, value)
	Edit(player, "Settings", index, value);
end

edit.Stats = function (player, index, value)
	Edit(player, "Stats", index, value);
end

edit.Gifts = function (player, index, value)
	Edit(player, "Gifts", index, value);
end

edit.Return = function(player, _type, index)
	local Folder = game.ServerStorage.Players:WaitForChild(player.UserId);

	if _type == nil then
		return Folder:GetAttribute(index);
	end
	
	return Folder:WaitForChild(_type):GetAttribute(index);
end

return edit
