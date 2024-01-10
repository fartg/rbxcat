local vf = {}

vf.CreateFolders = function(Player)
	local Folder = Instance.new("Folder", game.ServerStorage.Players); Folder.Name = Player.UserId;
	local InvFolder = Instance.new("Folder", Folder); InvFolder.Name = "Inventory"; 
	local SettingsFolder = Instance.new("Folder", Folder); SettingsFolder.Name = "Settings";
	local StatsFolder = Instance.new("Folder", Folder); StatsFolder.Name = "Stats";
	local GiftsFolder = Instance.new("Folder", Folder); GiftsFolder.Name = "Gifts";
	
	local r_Folder = Folder:Clone();
	r_Folder.Parent = game.ReplicatedStorage.Players;

	return Folder, InvFolder, SettingsFolder, StatsFolder, GiftsFolder;
end

return vf
