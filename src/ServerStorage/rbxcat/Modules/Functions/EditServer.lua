local edit = {}

local function Edit(index, value, dir)
	local Folder = game.ServerStorage:WaitForChild("Server");

	Folder:SetAttribute(index, value);
end

edit.Self = function(index, value)
	Edit(index, value);
end

edit.Return = function(index, dir)
	local Folder = game.ServerStorage:WaitForChild("Server");

	return Folder:GetAttribute(index)
end

return edit
