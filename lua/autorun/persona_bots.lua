hook.Add("StartCommand","Persona_ControlBotAI",function(ply,cmd)
	-- if !ply:IsBot() then return end
	-- if !ply:Alive() then return end
	-- if ply:IsFlagSet(FL_FROZEN) then return end

	-- cmd:ClearMovement()
	-- cmd:ClearButtons()

	-- if SERVER then
		-- if !IsValid(ply:GetPersona()) then
			-- local tbl = {}
			-- for stando,v in pairs(PERSONA) do
				-- table.insert(tbl,stando)
			-- end
			-- local persona = tbl[math.random(1,#tbl)]
			-- ply:SetPersona(persona)

			-- local class = "prop_persona_" .. ply:GetPersonaName()
			-- local ent = ents.Create(class)
			-- ent:SetModel(PERSONA[ply:GetPersonaName()].Model)
			-- ent:SetPos(ent:GetSpawnPosition(ply) or ply:GetPos())
			-- ent:SetAngles(ply:GetAngles())
			-- ent:Spawn()
			-- ply:SetPersonaEntity(ent)
			-- ent:RequestAura(ply,PERSONA[ply:GetPersonaName()].Aura)
			-- ent.User = ply
			-- ent.Persona = ply:GetPersonaName()
			-- ent:DoIdle()
			-- ent:OnSummoned(ply)
			-- ent:CheckCards()
			-- ply:SetNWEntity("PersonaEntity",ent)
			-- ent:SetFeedName(PERSONA[ply:GetPersonaName()].Name,class)

			-- local exp = PXP.GetPersonaData(ply,1)
			-- local lvl = PXP.GetPersonaData(ply,2)
			-- ent.EXP = exp != nil && exp or 0
			-- ent.Level = lvl != nil && lvl or ent.Stats.LVL
			-- if ent.Level < ent.Stats.LVL then
				-- ent.Level = ent.Stats.LVL
			-- end
			-- PXP.AddToCompendium(ply,ply:GetPersonaName())
			-- PXP.SavePersonaData(ply,ent.EXP,ent.Level,ent.CardTable)
			-- return
		-- end
	-- end
end)