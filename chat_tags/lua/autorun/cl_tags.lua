if SERVER then
	AddCSLuaFile()
else
	local chat = chat
	local tags =
	{
		["superadmin"] = {"Tech ", Color(211,211,211,0) },
		["admin"] = {"Admin ", Color( 138, 196, 138 ) },
		["headadmin"] = {"Head Admin ", Color(74, 219, 209, 0) }
	}

	hook.Add("OnPlayerChat", "Chat Tags", function(ply, Text, bTeam, bDead)
		local tag = tags[ply:GetUserGroup()]
		if tag ~= nil then
			print("yep")
			--in TTT you can be not dead if you're a spectator, working around weirdness
			if ply:Team() == TEAM_SPEC and not bDead then
				bDead = true
			end

			local t = {}
			if bDead then
				table.insert(t, Color(255, 0, 0, 255))
				table.insert(t, "*DEAD*")
				if bTeam then
					table.insert(t, Color(0, 204, 0, 255))
					table.insert(t, "{TEAM} ")
				end
			end
			--table.add is neater but is just a wrapper for table.insert
			table.insert(t, tag[2])
			table.insert(t, tag[1])
			table.insert(t, Color(50, 50, 50, 255))
			table.insert(t, "| ")
			table.insert(t, tag[2])
			table.insert(t, ply:Nick())
			table.insert(t, color_white)
			table.insert(t, ": ")
			table.insert(t, Text)
			chat.AddText(unpack(t))
			return true
		end
	end)
end