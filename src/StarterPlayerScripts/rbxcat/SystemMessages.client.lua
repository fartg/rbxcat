local Events = game.ReplicatedStorage.Events.Client
local TextChatService = game:GetService("TextChatService");
local TextChannels = TextChatService:WaitForChild("TextChannels");
local RBXSystem = TextChannels:WaitForChild("RBXSystem");

function format(_m, _type)
	if _type == "system" then
		return string.format("<font color=\"rgb(0, 255, 0)\">[SYSTEM]</font>: %s", _m)
	end
	if _type == "info" then
		return string.format("<font color=\"rgb(255, 165, 0)\">[INFO]</font>: %s", _m)
	end
end

Events.SystemMessage.OnClientEvent:Connect(function(message, _type)
	RBXSystem:DisplaySystemMessage(format(message, _type))
end)