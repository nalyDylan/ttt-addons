local function mapEdits()
	local map = game.GetMap()
	local ents = ents
	--replace all knives spawned into a map with confetti knives
	--that explode confetti and play rick roll music for 0 damage
	knifeSwap()

	local edits = {
			--randomly disable 2 of 5 T buttons each round on haven, it's too small for that much boom
			["ttt_minecraft_haven_los"] = function()
				local buttons = ipairs(ents.FindByClass("ttt_traitor_button"))
				local res = math.random(1,5)
				buttons[res]:Remove()
				buttons[res] = nil
				res = math.random(1,4)
				buttons[res]:Remove()
			end,
			--the middle market has sliding bar doors that screech like banshees
			["ttt_amsterville_rc1b"] = function()
				noLoopSound()
			end,
			--people use the swinging saloon style doors to RDM because of the constraint strength
			["de_westwood"] = function()
				for _,e in ipairs(ents.FindByClass("func_physbox")) do
					e.CanPickup = false
				end
			end,
			--the giant stack of oranges are props with weird physics boxes that kill people that touch them
			["de_paris_opt"] = function()
				for _,v in ipairs(ents.FindByClass("prop_physics")) do
					if v:GetModel() == "models/props/de_inferno/crates_fruit1.mdl" then
						v:GetPhysicsObject():EnableMotion(false)
					end
				end
			end,
			--there's a few small chunks of rubble on the map that people have found can be placed
			--at the bottom of a teleporter to kill players with
			["ttt_67thway_v7_defect_fix"] = function()
				for _,e in ipairs(ents.FindByClass("func_physbox")) do
					e.CanPickup = false
				end
			end,
			--loud doors
			["ttt_traitormotel_reloaded_b1"] = function()
				noLoopSound()
			end,
			--loud doors
			["de_district23"] = function()
				noLoopSound()
			end,
			--removed the sliding bridge that lorddragon uses to RDM a ton with
			--this map has been removed though
			["ttt_crummycradle_a4"] = function()
				for k,v in ipairs(ents.FindByClass("func_button")) do
					if v:GetPos():DistToSqr(Vector(184, 675, 1980)) < 5 then
						v:Remove()
					end
				end
			end,
			--there's 4-5 boxes each with 5 flareguns each in them by default, replaced with balloons
			--there's a drivable golfcart too that seems to make the driver invincible
			["ttt_alstoybarn_cube"] = function()
				for k,v in ipairs(ents.GetAll()) do
					if v:IsVehicle() then
						print(v:GetClass())
						v:Remove()
					end
				end
				local pos
				for k,v in ipairs(ents.FindByClass("weapon_ttt_flaregun")) do
					pos = v:GetPos()
					v:Remove()
					makeBalloon(pos)
				end
			end
			}
	if edits[map] then
		edits[map]()
	end
end
hook.Add("TTTPrepareRound", "Map Edits Prep", mapEdits)

function knifeSwap()
	local kpos, wep
	for _,v in ipairs(ents.FindByClass("weapon_ttt_knife")) do
		kpos = v:GetPos()
		v:Remove()
		wep = ents.Create("weapon_ttt_confetti")
		wep:SetPos(kpos)
		wep:Spawn()
	end
end
function noLoopSound()
	for _,v in ipairs(ents.FindByClass("func_door")) do
		v:SetKeyValue("loopmovesound", 0)
	end
end

--[[
Modified code mostly ripped from the Balloon tool in sandbox, but, we don't have sandbox gamemode hooks
and some other libraries that exist there
]]
function makeBalloon(pos)
	local balloon, attachpoint, trace, trData, CurPos, NearestPoint, Offset, LPos1, LPos2
	local util = util
	trData = {
		start = pos,
		endpos = pos - Vector(0, 0, 100)
	}
	trace = util.TraceLine( trData )
	balloon = ents.Create("balloon")
	balloon:SetModel("models/balloons/balloon_star.mdl")
	balloon:Spawn()
	balloon:SetColor( Color( math.random(128) + 128, math.random(128) + 128, math.random(128) + 128, 255 ) )
	balloon:SetForce( 100 )
	balloon:SetPos(pos)

	CurPos = balloon:GetPos()
	NearestPoint = balloon:NearestPoint( CurPos - ( trace.HitNormal * 10 ) )
	Offset = CurPos - NearestPoint

	pos = trace.HitPos + Offset


	attachpoint = pos + Vector( 0, 0, 0 )

	LPos1 = balloon:WorldToLocal( attachpoint )

	if ( IsValid( trace.Entity ) ) then
		local phys = trace.Entity:GetPhysicsObjectNum( trace.PhysicsBone )
		if ( IsValid( phys ) ) then LPos2 = phys:WorldToLocal( trace.HitPos ) end
	else
		LPos2 = trace.HitPos
	end

	constraint.Rope( balloon, trace.Entity, 0, trace.PhysicsBone, LPos1, LPos2, 0, 40, 0, 0.5, "cable/rope", nil )
end