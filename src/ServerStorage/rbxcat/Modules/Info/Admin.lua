local admin = {}

admin.Check = function(player)
	if table.find(admin.List, tostring(player.UserId)) ~= nil then return true end
	return false
end

admin.List = {
	"129180189",
	"27676",
	"5010243714",
	"-1"
}

return admin
