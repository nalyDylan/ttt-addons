if SERVER then
	AddCSLuaFile()
else
	local Tags =
	{
		{"superadmin", "Tech ", Color(211,211,211,0) },
		{"admin", "Admin ", Color( 138, 196, 138 ) },
		{"headadmin", "Head Admin ", Color(74, 219, 209, 0) }
	}

	hook.Add("OnPlayerChat", "Tags", function(ply, Text, Team, PlayerIsDead)
		for _,v in ipairs(Tags) do
			if ply:IsUserGroup(v[1]) then
				local t = ply:Alive() and {} or {Color(255, 0, 0, 255), "*DEAD*"}
				if Team and not ply:Alive() then
					table.Add(t,{Color(0, 204, 0, 255), "{TEAM} "})
				end
				table.Add(t, {v[3], v[2], Color(50, 50, 50, 255), "| ", v[3], ply:Nick(), color_white, ": ", Text})
				chat.AddText(unpack(t))
				return true
			end
		end
	end)
end