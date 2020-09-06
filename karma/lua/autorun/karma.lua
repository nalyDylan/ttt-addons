local function KT()
	local count = #player.GetAll() - #player.GetBots() - #team.GetPlayers(TEAM_SPECTATOR)
	if count < 4 then
		RunConsoleCommand("ttt_karma", "0")
    		return
	end
	RunConsoleCommand("ttt_karma", "1")
end
hook.Add("TTTBeginRound", "KarmaToggle", KT)
