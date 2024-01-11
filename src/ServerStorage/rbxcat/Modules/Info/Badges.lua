local BadgeService = game:GetService("BadgeService")

local b = {}

b.Give = function(player_instance, badge)
	if not BadgeService:UserHasBadgeAsync(player_instance.UserId, b.Info[badge].ID) then
		BadgeService:AwardBadge(player_instance.UserId, b.Info[badge].ID);
		return;
	end
end

b.Info = {
	["welcome"] = {
		ID = "4258772279121127",
	}
}

return b
