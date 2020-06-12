hook.Add("StartCommand","Persona_ControlBotAI",function(bot,cmd)
	if !bot:IsBot() then return end
	if !bot:Alive() then return end
	if bot:IsFlagSet(FL_FROZEN) then return end

	cmd:ClearMovement() 
	cmd:ClearButtons()

	local function findEnemy(bot)
		for _,v in pairs(player.GetAll()) do
			if (!v:Alive() or v == bot) then continue end
			bot.Persona_Enemy = v
		end
	end

	if !IsValid(bot.Persona_Enemy) then
		findEnemy(bot)
		return
	end
	if !bot.Persona_Enemy:Alive() then
		bot.Persona_Enemy = NULL
		return
	end
	if SERVER then
		if !IsValid(bot:GetStand()) then
			local tbl = {}
			for stando,v in pairs(JOJO_STANDS) do
				table.insert(tbl,stando)
			end
			local persona = tbl[math.random(1,#tbl)]
			bot:SetStand(persona)
			local ent = ents.Create("prop_stand_" .. persona)
			ent:SetModel(JOJO_STANDS[persona].Model)
			ent:SetPos(bot:GetPos())
			ent:SetAngles(bot:GetAngles())
			ent:Spawn()
			bot:SetStandEntity(ent)
			ent.User = bot
			ent.Stand = bot:GetStandName()
			ent:DoIdle()
			ent:OnSummoned(bot)
			return
		end
	end
	local ent = bot.Persona_Enemy
	local dist = ent:GetPos():Distance(bot:GetPos())
	cmd:SetViewAngles(((ent:GetPos() +ent:OBBCenter()) -bot:GetShootPos()):GetNormalized():Angle())
	if dist > bot:GetStand().Bot_StopDistance then
		cmd:SetForwardMove(bot:GetWalkSpeed())
	end
	for ind,val in pairs(bot:GetStand().Bot_Buttons) do
		local buttons = val.but
		local vDist = val.dist
		local chance = val.chance
		if dist <= vDist && math.random(1,chance) == 1 then
			for _,b in pairs(buttons) do
				cmd:SetButtons(b)
			end
		end
	end
end)