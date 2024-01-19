local TextChatService = game:GetService("TextChatService")
local AdminEvents = game.ReplicatedStorage.Events.Admin;

TextChatService.OnIncomingMessage = function(message: TextChatMessage)
	if not message.TextSource then return end;

	local _player = game.ReplicatedStorage.Players:FindFirstChild(message.TextSource.UserId);

	if AdminEvents.IsAdmin:InvokeServer(message.TextSource) then
		local props = Instance.new("TextChatMessageProperties");
		props.PrefixText = "<font color='#FF0000'>[A]</font> " .. message.PrefixText
		return props
	end
	
	if _player:GetAttribute("vip") then 
		local props = Instance.new("TextChatMessageProperties");
		props.PrefixText = "<font color='#F5CD30'>[VIP]</font> " .. message.PrefixText
		return props
	end;
end
