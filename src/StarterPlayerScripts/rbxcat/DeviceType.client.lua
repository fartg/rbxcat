repeat task.wait() until game.Loaded

local Events = game:GetService("ReplicatedStorage").Events.Client
local GuiService = game:GetService("GuiService")
local UserInputService = game:GetService("UserInputService")

-- someone made this, but i cant remember who! thx you
function getplatform()
	if (GuiService:IsTenFootInterface()) then
		return "Console"
	elseif (UserInputService.TouchEnabled and not UserInputService.MouseEnabled) then
		local DeviceSize = workspace.CurrentCamera.ViewportSize; 
		if ( DeviceSize.Y > 600 ) then
			return "Mobile (tablet)"
		else
			return "Mobile (phone)"
		end
	else
		return "Desktop"
	end
end

Events.Device:FireServer(getplatform())