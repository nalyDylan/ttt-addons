local function KT()
	local count = 0
	for _,p in pairs(player.GetAll()) do
		if p:IsTerror() then
			count = count+1
		end
	end
	if count < 4 then
		RunConsoleCommand("ttt_karma", "0")
    		return
	end
  RunConsoleCommand("ttt_karma", "1")
end
hook.Add("TTTBeginRound", "KarmaToggle", KT)
