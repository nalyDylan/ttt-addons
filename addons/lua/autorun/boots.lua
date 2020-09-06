resource.AddFile( 'materials/VGUI/ttt/icon_ironboots.vmt' )
EQUIP_BOOTS = 8
hook.Add("Initialize", "Boots", function()
  table.insert(EquipmentItems[ROLE_DETECTIVE],       
  {  
      id       = EQUIP_BOOTS,
           type     = "item_passive",
           material = "vgui/ttt/icon_ironboots",
           name     = "Steel-Toed Boots",
           desc     = "Eliminates fall damage.\n(Excluding pitfalls and traps)"
        })
  table.insert(EquipmentItems[ROLE_TRAITOR],       
  {  
      id       = EQUIP_BOOTS,
           type     = "item_passive",
           material = "vgui/ttt/icon_ironboots",
           name     = "Steel-Toed Boots",
           desc     = "Eliminates fall damage.\n(Excluding pitfalls and traps)"
        })

  function GAMEMODE:GetFallDamage(ply, speed)
     return !(ply:HasEquipmentItem(EQUIP_BOOTS))
  end

  local fallsounds = {
     Sound("player/damage1.wav"),
     Sound("player/damage2.wav"),
     Sound("player/damage3.wav")
  };

  local bootsounds = {
     Sound("npc/metropolice/gear1.wav"),
     Sound("npc/metropolice/gear2.wav"),
     Sound("npc/metropolice/gear3.wav"),
     Sound("npc/metropolice/gear4.wav"),
     Sound("npc/metropolice/gear5.wav"),
     Sound("npc/metropolice/gear6.wav")
  }
  if SERVER then
     function GAMEMODE:OnPlayerHitGround(ply, in_water, on_floater, speed)
        if in_water or speed < 450 or not IsValid(ply) then return end

        -- Everything over a threshold hurts you, rising exponentially with speed
        local damage = math.pow(0.05 * (speed - 420), 1.75)

        -- I don't know exactly when on_floater is true, but it's probably when
        -- landing on something that is in water.
        if on_floater then damage = damage / 2 end

        -- if we fell on a dude, that hurts (him)
        local ground = ply:GetGroundEntity()
        if IsValid(ground) and ground:IsPlayer() then
           if math.floor(damage) > 0 then
              local att = ply

              -- if the faller was pushed, that person should get attrib
              local push = ply.was_pushed
              if push then
                 -- TODO: move push time checking stuff into fn?
                 if math.max(push.t or 0, push.hurt or 0) > CurTime() - 4 then
                    att = push.att
                 end
              end

              local dmg = DamageInfo()

              if att == ply then
                 -- hijack physgun damage as a marker of this type of kill
                 dmg:SetDamageType(DMG_CRUSH + DMG_PHYSGUN)
              else
                 -- if attributing to pusher, show more generic crush msg for now
                 dmg:SetDamageType(DMG_CRUSH)
              end

              dmg:SetAttacker(att)
              dmg:SetInflictor(att)
              dmg:SetDamageForce(Vector(0,0,-1))
              dmg:SetDamage(damage * ((ply:HasEquipmentItem(EQUIP_BOOTS) and 2) or 1))

              ground:TakeDamageInfo(dmg)
           end

           -- our own falling damage is cushioned
           damage = damage / 3
        end

        if math.floor(damage) > 0 then
        if  ply:HasEquipmentItem(EQUIP_BOOTS) and !ply.PitFall then
           if damage > 5 then
              --play some sounds
              ply:EmitSound(table.Random(bootsounds), 45 + math.Clamp(damage, 0, 50), 100)
           end
           return
        end
           local dmg = DamageInfo()
           dmg:SetDamageType(DMG_FALL)
           dmg:SetAttacker(game.GetWorld())
           dmg:SetInflictor(game.GetWorld())
           dmg:SetDamageForce(Vector(0,0,1))
           dmg:SetDamage((ply.PitFall and math.max(ply:Health(), 1000)) or damage)

           ply:TakeDamageInfo(dmg)

           -- play CS:S fall sound if we got somewhat significant damage
           if damage > 5 then
              sound.Play(table.Random(fallsounds), ply:GetShootPos(), 55 + math.Clamp(damage, 0, 50), 100)
           end
        end
     end
  end
end)