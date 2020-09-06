local function KT()
	local count = #player.GetAll() - #player.GetBots() - #team.GetPlayers(TEAM_SPECTATOR)
	if count < 4 then
		RunConsoleCommand("ttt_karma", "0")
		return
	end

	--if we've made it this far, there's more than 4 people on the server
	--so if karma is disabled, we're about to enable it and so we need to fix things
	local k = GetConVar("ttt_karma"):GetInt()
	if k == 0 then
		--[[ TTT now calculates karma even when it's off, so, when we toggle karma
		on, players can sometimes be banned as their Base karma gets set equal to their live
		karma so here we do the opposite, we set liveKarma = baseKarma, which stops any damage
		done while karma is off AND preserves their karma from before karma was disabled, so
		you can't join an empty server for a free karma reset ]]
		for k,v in ipairs(player.GetAll()) do
				v:SetLiveKarma(v:GetBaseKarma())
			end
		end
	end
	RunConsoleCommand("ttt_karma", "1")
end
hook.Add("TTTBeginRound", "KarmaToggle", KT)
