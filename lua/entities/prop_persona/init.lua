AddCSLuaFile("shared.lua")
include("shared.lua")
include("skills.lua")
---------------------------------------------------------------------------------------------------------------------------------------------
PERSONA_TASKS = {}
PERSONA_TASKS["TASK_NONE"] = -1
PERSONA_TASKS["TASK_RESET"] = 0
PERSONA_TASKS["TASK_IDLE"] = 1
PERSONA_TASKS["TASK_BLOCK"] = 2
PERSONA_TASKS["TASK_ATTACK"] = 3
PERSONA_TASKS["TASK_PLAY_ANIMATION"] = 4
PERSONA_TASKS["TASK_MOVE_TO_POSITION"] = 5
PERSONA_TASKS["TASK_DEATH"] = 6
PERSONA_TASKS["TASK_RETURN"] = 7
---------------------------------------------------------------------------------------------------------------------------------------------
ENT.Animations = {}
ENT.Animations["idle"] = "idle"
ENT.Animations["idle_low"] = "low_hp"
ENT.Animations["melee"] = "attack"
ENT.Animations["range_start"] = "range_pre"
ENT.Animations["range_start_idle"] = "range_pre_idle"
ENT.Animations["range"] = "range"
ENT.Animations["range_idle"] = "range_loop"
ENT.Animations["range_end"] = "range_end"
---------------------------------------------------------------------------------------------------------------------------------------------
ENT.Stats = {
	LVL = 1, -- Innate level
	STR = 1, -- Effectiveness of phys. attacks
	MAG = 1, -- Effectiveness of magic. attacks
	END = 1, -- Effectiveness of defense
	AGI = 1, -- Effectiveness of hit and evasion rates
	LUC = 1, -- Chance of getting a critical
	WK = {},
	RES = {},
	NUL = {},
}
---------------------------------------------------------------------------------------------------------------------------------------------
ENT.LeveledSkills = {} -- Skills must be place in a specific order! Top of table must be the highest level req. and the last one in the table must be the lowest level req.
---------------------------------------------------------------------------------------------------------------------------------------------
ENT.AuraChance = 2
ENT.IdleSpeed = 1
ENT.DamageTypes = bit.bor(DMG_SLASH,DMG_CRUSH,DMG_ALWAYSGIB)
---------------------------------------------------------------------------------------------------------------------------------------------
function ENT:Initialize()
	self:SetSolid(SOLID_OBB)
	self:SetCollisionGroup(COLLISION_GROUP_IN_VEHICLE)
	self:SetRenderMode(RENDERMODE_TRANSADD)
	self:DrawShadow(false)
	
	self.CurrentTask = "TASK_NONE"
	self.CurrentTaskID = -1
	
	self.CurrentForwardAng = self:GetAngles().x
	self.CurrentSideAng = self:GetAngles().z
	
	self.CurrentMeleeSkill = nil
	self.CurrentMeleeSkillCost = 0

	self.CurrentIdle = "idle"
	
	self.NextDamageUserT = 0
	
	self:SetCritical(false)
	self.HeatRiserT = CurTime()
	self.FocusedT = CurTime()
	self.ChargedT = CurTime()
	self.HasChaosParticle = false
	self.ChaosT = CurTime()

	self.Loops = {}
	self.Flexes = {}
	
	self.NextCardSwitchT = CurTime()
	self.NextLockOnT = CurTime()
	
	self.BaseLevel = self.Stats.LVL
	self.BaseSTR = self.Stats.STR
	self.BaseMAG = self.Stats.MAG
	self.BaseEND = self.Stats.END
	self.BaseAGI = self.Stats.AGI
	self.BaseLUC = self.Stats.LUC
	
	timer.Simple(0,function()
		if self.User:IsPlayer() then
			PXP.SetPersonaData(self.User,5,self.User:GetNWString("PersonaName"))

			self:CheckSkillLevel(true)
			PXP.ManagePersonaStats(self.User)
		end
	end)
end
---------------------------------------------------------------------------------------------------------------------------------------------
function ENT:AddItemSkill(data)
	local proceed = true
	for _,v in pairs(self.CardTable) do
		if v.Name == data.Name then
			proceed = false
			break
		end
	end
	if !proceed then
		return
	end
	self:AddCard(data.Name,data.Cost,data.UsesHP,data.Icon)
	PXP.SetPersonaData(self.User,3,self.CardTable)
	self.User:ChatPrint("Obtained a new skill, " .. data.Name .. "!")
end
---------------------------------------------------------------------------------------------------------------------------------------------
function ENT:CheckSkillLevel(noChat)
	local lvl = PXP.GetPersonaData(self.User,2)
	if #self.LeveledSkills > 0 then
		-- for _,skill in pairs(self.LeveledSkills) do
		for i = 1,#self.LeveledSkills do
			local proceed = true
			local skill = self.LeveledSkills[i]
			if skill.Level && skill.Level <= lvl then
				for _,v in pairs(self.CardTable) do
					if v.Name == skill.Name then
						proceed = false
						break
					end
				end
				if !proceed then
					return
				end
				self:AddCard(skill.Name,skill.Cost,skill.UsesHP,skill.Icon)
				if noChat != true then
					self.User:ChatPrint("Obtained a new skill, " .. skill.Name .. "!")
					self.User:EmitSound("cpthazama/persona4/ui_newskill.wav")
				end
			end
		end
	end
end
---------------------------------------------------------------------------------------------------------------------------------------------
function ENT:DoCritical(t)
	self:SetCritical(true)
	self.User:EmitSound("cpthazama/persona5/misc/00015_streaming.wav",0.2)
	timer.Simple(t,function()
		if IsValid(self) then
			self:SetCritical(false)
		end
	end)
end
---------------------------------------------------------------------------------------------------------------------------------------------
function ENT:GetSpawnPosition(ply)
	return ply:GetPos()
end
---------------------------------------------------------------------------------------------------------------------------------------------
function ENT:GetIdlePosition(ply)
	return ply:GetPos() +ply:GetForward() *25
end
---------------------------------------------------------------------------------------------------------------------------------------------
function ENT:PersonaControls(ply,persona) end
---------------------------------------------------------------------------------------------------------------------------------------------
function ENT:ControlPersonaMovement(ply)
	local dir = Vector()
	local w = ply:KeyDown(IN_FORWARD)
	local a = ply:KeyDown(IN_MOVELEFT)
	local s = ply:KeyDown(IN_BACK)
	local d = ply:KeyDown(IN_MOVERIGHT)
	local ang = self.User:GetAngles()
	-- if !w && !a && !d && !s then
		-- self:SetAngles(self.User:GetAngles())
	-- end
	if w then
		if self.CurrentForwardAng != 15 then
			self.CurrentForwardAng = self.CurrentForwardAng +1
		end
		dir = dir +self:GetForward()
	elseif s then
		if self.CurrentForwardAng != -15 then
			self.CurrentForwardAng = self.CurrentForwardAng -1
		end
		dir = dir -self:GetForward()
	else
		if self.CurrentForwardAng != 0 then
			self.CurrentForwardAng = (self.CurrentForwardAng > 0 && self.CurrentForwardAng -1) or self.CurrentForwardAng +1
		end
	end
	if a then
		if self.CurrentSideAng != -8 then
			self.CurrentSideAng = self.CurrentSideAng -1
		end
		dir = dir -self:GetRight()
	elseif d then
		if self.CurrentSideAng != 8 then
			self.CurrentSideAng = self.CurrentSideAng +1
		end
		dir = dir +self:GetRight()
	else
		if self.CurrentSideAng != 0 then
			self.CurrentSideAng = (self.CurrentSideAng > 0 && self.CurrentSideAng -1) or self.CurrentSideAng +1
		end
	end
	self:FacePlayerAim(self.User)
	if dir:Length() > 0 then
		local tPos = self:GetPos() +dir *20
		local tracedata = {}
		tracedata.start = self:GetPos() +self:OBBCenter()
		tracedata.endpos = tPos
		tracedata.filter = {ply,self}
		local tr = util.TraceLine(tracedata)
		if !tr.Hit then
			self:MoveToPos(tPos,1.75)
		end
	end
end
---------------------------------------------------------------------------------------------------------------------------------------------
function ENT:DefaultPersonaControls(ply,persona)
	if ply:IsPlayer() then
		ply:SetNWEntity("Persona_Target",ply.Persona_EyeTarget)
		if ply:KeyReleased(IN_WALK) && CurTime() > self.NextLockOnT then
			if IsValid(ply.Persona_EyeTarget) then
				ply.Persona_EyeTarget = NULL
				ply:EmitSound("cpthazama/persona5/misc/00019.wav",70,100)
			else
				local ent = ply:GetEyeTrace().Entity
				if IsValid(ent) then
					if (ent:IsNPC() or ent:IsPlayer() or (ent.IsPersona && ent != persona)) then
						ply.Persona_EyeTarget = ent
						ply:EmitSound("cpthazama/persona5/misc/00007.wav",70,100)
					end
				else
					local ents = self:FindEnemies(ply:GetPos(),2000)
					local ent = VJ_PICK(ents)
					if IsValid(ent) then
						ply.Persona_EyeTarget = ent
						ply:EmitSound("cpthazama/persona5/misc/00007.wav",70,100)
					end
				end
			end
			self.NextLockOnT = CurTime() +0.2
		end
		if IsValid(ply.Persona_EyeTarget) then
			ply:SetEyeAngles(LerpAngle(0.5,ply:EyeAngles(),((ply.Persona_EyeTarget:GetPos() +ply.Persona_EyeTarget:OBBCenter()) -ply:GetShootPos()):Angle()))
		end
	end
	if self:GetTask() == "TASK_IDLE" then
		self.CurrentIdle = self.User:IsPlayer() && self.User:Crouching() && "idle_low" or "idle"
		if self:GetSequenceName(self:GetSequence()) != self.Animations[self.CurrentIdle] then
			self:DoIdle()
		end
		self:SetPos(self:GetIdlePosition(ply))
		self:FacePlayerAim(self.User)

		if ply:IsPlayer() then
			local w = ply:KeyDown(IN_FORWARD)
			local a = ply:KeyDown(IN_MOVELEFT)
			local d = ply:KeyDown(IN_MOVERIGHT)
			local s = ply:KeyDown(IN_BACK)
			local ang = self.User:GetAngles()
			if !w && !a && !d && !s then
				self:SetAngles(self.User:GetAngles())
			end
			if w then
				if self.CurrentForwardAng != 15 then
					self.CurrentForwardAng = self.CurrentForwardAng +1
				end
			elseif s then
				if self.CurrentForwardAng != -15 then
					self.CurrentForwardAng = self.CurrentForwardAng -1
				end
			else
				if self.CurrentForwardAng != 0 then
					self.CurrentForwardAng = (self.CurrentForwardAng > 0 && self.CurrentForwardAng -1) or self.CurrentForwardAng +1
				end
			end
			if a then
				if self.CurrentSideAng != -8 then
					self.CurrentSideAng = self.CurrentSideAng -1
				end
			elseif d then
				if self.CurrentSideAng != 8 then
					self.CurrentSideAng = self.CurrentSideAng +1
				end
			else
				if self.CurrentSideAng != 0 then
					self.CurrentSideAng = (self.CurrentSideAng > 0 && self.CurrentSideAng -1) or self.CurrentSideAng +1
				end
			end
			self:SetAngles(Angle(self.CurrentForwardAng,ang.y,self.CurrentSideAng))
		else
			self:SetAngles(self.User:GetAngles())
		end
	elseif self:GetTask() == "TASK_ATTACK" then
		if !IsValid(self.Target) then self:FindTarget(ply) end
		self:FaceTarget()
	else
		-- self:SetColor(Color(255,255,255,255))
	end
end
---------------------------------------------------------------------------------------------------------------------------------------------
function ENT:PersonaCards(lmb,rmb,r)
	local ply = self.User
	local persona = self
	local melee = self.CurrentMeleeSkill
	if lmb then
		if melee == "Heaven's Blade" then
			self:HeavensBlade(ply,persona)
		elseif melee == "Cross Slash" then
			self:CrossSlash(ply,persona)
		elseif melee == "Ghastly Wail" then
			self:GhostlyWail(ply)
		elseif melee == "Laevateinn" then
			self:Laevateinn(ply,ply.Persona_EyeTarget)
		elseif melee == "One-shot Kill" then
			self:OneShotKill(ply,persona)
		elseif melee == "Riot Gun" then
			self:RiotGun(ply,persona)
		elseif melee == "Vorpal Blade" then
			self:VorpalBlade(ply,persona)
		end
	end
	if rmb then // Time for spaghet code
		if self:GetCard() == "Myriad Truths" then 
			self:MyriadTruths(ply,persona)
		elseif self:GetCard() == "Maziodyne" then
			self:Maziodyne(ply,persona,rmb)
		elseif self:GetCard() == "Zionga" then
			self:Zionga(ply,persona,rmb)
		elseif self:GetCard() == "Mazionga" then
			self:Mazionga(ply,persona,rmb)
		elseif self:GetCard() == "Evil Smile" then
			self:EvilSmile(ply,persona,rmb)
		elseif self:GetCard() == "Teleport" then
			self:Teleport(ply,persona)
		elseif self:GetCard() == "Charge" then
			self:Charge(ply,persona)
		elseif self:GetCard() == "Concentrate" then
			self:Concentrate(ply,persona)
		elseif self:GetCard() == "Heat Riser" then
			self:HeatRiser(ply,persona)
		elseif self:GetCard() == "Salvation" then
			self:Salvation(ply,persona)
		elseif self:GetCard() == "Debilitate" then
			self:Debilitate(ply,persona)
		elseif self:GetCard() == "Eigaon" then
			self:Eigaon(ply,persona)
		elseif self:GetCard() == "Maeigaon" then
			self:Maeigaon(ply,persona)
		elseif self:GetCard() == "Garu" then
			self:Garu(ply,persona)
		elseif self:GetCard() == "Garudyne" then
			self:Garudyne(ply,persona)
		elseif self:GetCard() == "Magarudyne" then
			self:Magarudyne(ply,persona)
		elseif self:GetCard() == "Megidolaon" then
			self:Megidolaon(ply,ply.Persona_EyeTarget)
		elseif self:GetCard() == "Call of Chaos" then
			self:CallOfChaos(ply,persona)
		elseif self:GetCard() == "Laevateinn" then
			self.CurrentMeleeSkill = "Laevateinn"
		elseif self:GetCard() == "Heaven's Blade" then
			self.CurrentMeleeSkill = "Heaven's Blade"
		elseif self:GetCard() == "Cross Slash" then
			self.CurrentMeleeSkill = "Cross Slash"
		elseif self:GetCard() == "Ghastly Wail" then
			self.CurrentMeleeSkill = "Ghastly Wail"
		elseif self:GetCard() == "One-shot Kill" then
			self.CurrentMeleeSkill = "One-shot Kill"
		elseif self:GetCard() == "Riot Gun" then
			self.CurrentMeleeSkill = "Riot Gun"
		elseif self:GetCard() == "Vorpal Blade" then
			self.CurrentMeleeSkill = "Vorpal Blade"
		end
	end
	if r && CurTime() > self.NextCardSwitchT then
		self:CycleCards()
	end
end
---------------------------------------------------------------------------------------------------------------------------------------------
function ENT:Think()
	if IsValid(self.User) then
		if !self.User:Alive() then
			self:Remove()
		end
		if self:GetTask() == "TASK_RETURN" then
			local dist = self.User:GetPos():Distance(self:GetPos())
			self:FacePlayerAim(self.User)
			local speed = 30
			if dist <= 170 then
				speed = 15
			end
			self:MoveToPos(self.User:GetPos(),speed)
			if dist <= 10 then
				self.User:EmitSound("cpthazama/persona5/persona_disapper.wav",65)
				SafeRemoveEntity(self)
			end
			return
		end
		if self.HasChaosParticle then
			if CurTime() > self.ChaosT then
				self.HasChaosParticle = false
				self.User:StopParticles()
				self:CreateAura(self.User)
				if !self.CurrentCardUsesHP then
					self.CurrentCardCost = self.CurrentCardCost /2
				end
				self:SetNWInt("SpecialAttackCost",self.CurrentCardCost)
			end
		end
		if self.User:IsPlayer() then
			self:PersonaCards(self.User:KeyDown(IN_ATTACK),self.User:KeyDown(IN_ATTACK2),self.User:KeyDown(IN_RELOAD))
		end
		self:PersonaControls(self.User,self.Stand)
		if self.ControlType == 2 then
			self:ControlPersonaMovement(self.User)
		else
			self:DefaultPersonaControls(self.User,self.Stand)
		end
	else
		self:Remove()
	end
	self:NextThink(CurTime())
	return true
end
---------------------------------------------------------------------------------------------------------------------------------------------
function ENT:RequestAura(ply,aura)
	self:EmitSound("cpthazama/persona5/misc/00118.wav",75,100)
	if math.random(1,self.AuraChance) == 1 then ParticleEffectAttach(aura,PATTACH_POINT_FOLLOW,self,self:LookupAttachment("origin")) end
	ParticleEffectAttach(aura,PATTACH_POINT_FOLLOW,ply,ply:LookupAttachment("origin"))
	local fx = EffectData()
	fx:SetOrigin(self:GetIdlePosition(ply))
	fx:SetScale(80)
	util.Effect("JoJo_Summon",fx)
end
---------------------------------------------------------------------------------------------------------------------------------------------
function ENT:OnSummoned(ply) end
---------------------------------------------------------------------------------------------------------------------------------------------
function ENT:OnRequestDisappear(ply) end
---------------------------------------------------------------------------------------------------------------------------------------------
function ENT:DoIdle()
	self:SetTask("TASK_IDLE")
	self.IdleAnimation = self.Animations[self.CurrentIdle]
	self:PlayAnimation(self.IdleAnimation,self.IdleSpeed,1)
end
---------------------------------------------------------------------------------------------------------------------------------------------
function ENT:GetMeleeCost()
	return (self.CurrentMeleeSkillCost *0.01)
end
---------------------------------------------------------------------------------------------------------------------------------------------
function ENT:AddCard(name,req,isHP,icon)
	self.CardTable = self.CardTable or {}
	self.CardTable[#self.CardTable +1] = {Name=name,Cost=req,UsesHP=isHP,Icon=(icon or "unknown")}

	self.Cards = self.Cards or {}
	self.Cards[name] = {}
	self.Cards[name].Cost = req
	self.Cards[name].UsesHP = isHP
	self.Cards[name].Icon = icon or "unknown"
end
---------------------------------------------------------------------------------------------------------------------------------------------
function ENT:CheckCards()
	if self.User:IsNPC() then return end

	local oldSkills = {}
	for _,v in pairs(self.CardTable) do
		table.insert(oldSkills,v.Name)
	end
	local tbl = PXP.GetPersonaData(self.User,3)
	local newSkills = {}
	if tbl == nil then return end
	for index,skill in pairs(tbl) do
		-- print("Checking " .. skill.Name)
		if !VJ_HasValue(oldSkills,skill.Name) then
			table.insert(newSkills,skill)
			-- print("Added " .. skill.Name .. " to new skills")
		end
	end
	for _,skill in pairs(newSkills) do
		self:AddCard(skill.Name,skill.Cost,skill.UsesHP,skill.Icon)
		-- print("Implemented " .. skill.Name)
	end
end
---------------------------------------------------------------------------------------------------------------------------------------------
function ENT:SetMeleeCard(name,cost)
	self.CurrentMeleeSkill = name
	self.CurrentMeleeSkillCost = cost
end
---------------------------------------------------------------------------------------------------------------------------------------------
function ENT:CycleCards()
	local index = self.CurrentCardID
	local finalIndex = index +1
	local target = self.CardTable[finalIndex]
	if finalIndex > #self.CardTable then
		target = self.CardTable[1]
		finalIndex = 1
	end
	
	self.User:EmitSound("cpthazama/persona5/misc/00042.wav",45)

	self:SetActiveCard(target.Name,target.Cost,target.UsesHP,target.Icon,finalIndex)
	self.NextCardSwitchT = CurTime() +0.2
end
---------------------------------------------------------------------------------------------------------------------------------------------
function ENT:SetActiveCard(name,cost,useHP,icon,index)
	cost = (!useHP && self.ChaosT > CurTime()) && cost *2 or cost
	self:SetNWString("SpecialAttack",name)
	self:SetNWInt("SpecialAttackCost",cost)
	self:SetNWBool("SpecialAttackUsesHP",useHP or false)
	self:SetNWString("SpecialAttackIcon",icon or "unknown")
	self.CurrentCardCost = cost
	self.CurrentCardUsesHP = useHP
	self.CurrentCardID = index
end
---------------------------------------------------------------------------------------------------------------------------------------------
function ENT:SetCard(name,isMelee)
	self.NextCardSwitchT = CurTime() +0.35
	if isMelee then
		for index,v in ipairs(self.CardTable) do
			if v.Name == name then
				self:SetMeleeCard(name,v.Cost)
				break
			end
		end
		return
	end
	for index,v in ipairs(self.CardTable) do
		if v.Name == name then
			self:SetActiveCard(v.Name,v.Cost,v.UsesHP,v.Icon,index)
			break
		end
	end
	-- if self.Cards[name] then
		-- self:SetNWString("SpecialAttack",name)
		-- self:SetNWInt("SpecialAttackCost",self.Cards[name].Cost)
		-- self:SetNWBool("SpecialAttackUsesHP",self.Cards[name].UsesHP or false)
		-- self.CurrentCardCost = self.Cards[name].Cost
		-- self.CurrentCardUsesHP = self.Cards[name].UsesHP
	-- end
end
---------------------------------------------------------------------------------------------------------------------------------------------
function ENT:GetCard()
	return self:GetNWString("SpecialAttack")
end
---------------------------------------------------------------------------------------------------------------------------------------------
function ENT:TakeSP(sp)
	if self.User:HasGodMode() then return end
	self.User:SetSP(math.Clamp(self.User:GetSP() -sp,0,999))
end
---------------------------------------------------------------------------------------------------------------------------------------------
function ENT:TakeHP(hp)
	if self.User:HasGodMode() then return end
	self.User:SetHealth(self.User:Health() -hp)
end
---------------------------------------------------------------------------------------------------------------------------------------------
function ENT:AddLoop(snd,sndlevel)
	local lp = CreateSound(self,snd)
	lp:SetSoundLevel(sndlevel)
	table.insert(self.Loops,lp)
	return lp
end
---------------------------------------------------------------------------------------------------------------------------------------------
function ENT:MoveToPos(pos,speed)
	local dir = (pos -self:GetPos()):GetNormal()
	self:SetPos(self:GetPos() +dir *speed)
end
---------------------------------------------------------------------------------------------------------------------------------------------
function ENT:DoGesture(seq,speed)
	local gest = self:AddGestureSequence(self:LookupSequence(seq))
	self:SetLayerPriority(gest,2)
	self:SetLayerPlaybackRate(gest,speed)
end
---------------------------------------------------------------------------------------------------------------------------------------------
function ENT:UserTrace(maxDist)
	if maxDist then
		local tracedata = {}
		tracedata.start = self.User:EyePos()
		tracedata.endpos = self.User:EyePos() +self.User:EyeAngles():Forward() *maxDist
		tracedata.filter = {self.User,self}
		local tr = util.TraceLine(tracedata)
		
		-- util.ParticleTracerEx("Weapon_Combine_Ion_Cannon_Beam",tr.StartPos,tr.HitPos,false,self.User:EntIndex(),0)

		return tr
	end
	local tracedata = {}
	tracedata.start = self.User:EyePos()
	tracedata.endpos = self.User:GetEyeTrace().HitPos
	tracedata.filter = {self.User,self}
	local tr = util.TraceLine(tracedata)

	return tr
end
---------------------------------------------------------------------------------------------------------------------------------------------
function ENT:FindTarget(ply)
	if ply:IsPlayer() then
		local tracedata = {}
		tracedata.start = ply:EyePos()
		tracedata.endpos = ply:GetEyeTrace().HitPos
		tracedata.filter = {ply,self}
		local tr = util.TraceLine(tracedata)
		local ent = tr.Entity
	else
		ent = ply:GetEnemy()
	end
	
	self.Target = IsValid(ent) && (ent:IsNPC() or ent:IsPlayer()) && ent
end
---------------------------------------------------------------------------------------------------------------------------------------------
function ENT:FaceTarget()
	if IsValid(self.Target) then
		local ang = self:GetAngles()
		self:SetAngles(Angle(ang.x,(self.Target:GetPos() -self:GetPos()):Angle().y,ang.z))
	end
end
---------------------------------------------------------------------------------------------------------------------------------------------
function ENT:FacePlayerAim(ply)
	if IsValid(self.Target) then
		local ang = self:GetAngles()
		self:SetAngles(Angle(ang.x,(self.Target:GetPos() -self:GetPos()):Angle().y,ang.z))
		return
	end

	if ply:IsPlayer() then
		local tracedata = {}
		tracedata.start = ply:EyePos()
		tracedata.endpos = ply:GetEyeTrace().HitPos
		tracedata.filter = {ply,self}
		local tr = util.TraceLine(tracedata)

		local ang = self:GetAngles()
		self:SetAngles(Angle(ang.x,(tr.HitPos -self:GetPos()):Angle().y,ang.z))
		self:SetPoseParameter("aim_pitch",ply:GetPoseParameter("aim_pitch"))
		self:SetPoseParameter("aim_yaw",ply:GetPoseParameter("aim_yaw"))
		self:SetPoseParameter("head_pitch",ply:GetPoseParameter("head_pitch"))
		self:SetPoseParameter("head_yaw",ply:GetPoseParameter("head_yaw"))
	end
end
---------------------------------------------------------------------------------------------------------------------------------------------
function ENT:AdditionalInput(dmg,type)
	dmg = self:GetCritical() && dmg *1.25 or dmg
	dmg = self.HeatRiserT > CurTime() && dmg *1.5 or dmg
	dmg = self.ChaosT > CurTime() && dmg *3 or dmg
	if type == 1 then -- Physical
		dmg = self.ChargedT > CurTime() && dmg *2 or dmg
		dmg = (dmg *self.Stats.STR) /6
	elseif type == 2 then -- Magic
		dmg = self.FocusedT > CurTime() && dmg *2 or dmg
		dmg = (dmg *self.Stats.MAG) /6
	end
	return dmg
end
---------------------------------------------------------------------------------------------------------------------------------------------
function ENT:OnMissedEnemy(ent)
	print("MISSED")
end
---------------------------------------------------------------------------------------------------------------------------------------------
function ENT:GetAttackPosition()
	return self:GetPos() +self:OBBCenter()
end
---------------------------------------------------------------------------------------------------------------------------------------------
function ENT:FindEnemies(pos,dist)
	local FindEnts = ents.FindInSphere(pos,dist)
	local foundEnts = {}
	if FindEnts != nil then
		for _,v in pairs(FindEnts) do
			if (v != self && v != self.User) && ((v:IsNPC() or (v:IsPlayer() && v:Alive()))) then
				table.insert(foundEnts,v)
			end
		end
	end
	return foundEnts
end
---------------------------------------------------------------------------------------------------------------------------------------------
function ENT:DealDamage(ent,dmg,dmgtype,type)
	dmg = self:AdditionalInput(dmg,type or 1)
	local doactualdmg = DamageInfo()
	doactualdmg:SetDamage(dmg)
	doactualdmg:SetDamageType(dmgtype)
	doactualdmg:SetInflictor(self)
	doactualdmg:SetAttacker(self.User)
	doactualdmg:SetDamagePosition(ent:NearestPoint(self:GetAttackPosition()))
	ent:TakeDamageInfo(doactualdmg,self.User)
	if ent:IsPlayer() then
		ent:ViewPunch(Angle(math.random(-1,1) *dmg,math.random(-1,1) *dmg,math.random(-1,1) *dmg))
	end
end
---------------------------------------------------------------------------------------------------------------------------------------------
function ENT:MeleeAttackCode(dmg,dmgdist,rad,snd)
	local AttackDist = dmgdist
	local attackPos = self:GetAttackPosition()
	local FindEnts = ents.FindInSphere(attackPos,AttackDist)
	local hitentity = false
	local hitEnts = {}
	local snd = snd or true
	local doactualdmg = DamageInfo()
	local agility = self.Stats.AGI
	dmg = self:AdditionalInput(dmg,1)
	if FindEnts != nil then
		for _,v in pairs(FindEnts) do
			if (v != self && v != self.User) && (((v:IsNPC() or (v:IsPlayer() && v:Alive()))) or v:GetClass() == "func_breakable_surf" or v:GetClass() == "prop_physics") then
				if (self:GetForward():Dot((Vector(v:GetPos().x,v:GetPos().y,0) - Vector(self:GetPos().x,self:GetPos().y,0)):GetNormalized()) > math.cos(math.rad(rad))) then
					-- if math.random(1,100) > agility then
						-- self:OnMissedEnemy(v)
						-- return
					-- end
					doactualdmg:SetDamage(dmg)
					doactualdmg:SetDamageType(snd != nil && type(snd) == "number" && snd or self.DamageTypes or DMG_P_PHYSICAL)
					doactualdmg:SetDamageForce(self:GetForward() *((doactualdmg:GetDamage() +100) *70))
					doactualdmg:SetInflictor(self)
					doactualdmg:SetAttacker(self.User)
					doactualdmg:SetDamagePosition(v:NearestPoint(attackPos))
					v:TakeDamageInfo(doactualdmg,self.User)
					if v:IsPlayer() then
						v:ViewPunch(Angle(math.random(-1,1) *dmg,math.random(-1,1) *dmg,math.random(-1,1) *dmg))
					end
					hitentity = true
					table.insert(hitEnts,v)
					if snd && type(snd) == "string" then v:EmitSound("cpthazama/persona5/misc/00051.wav",math.random(60,72),math.random(100,120)) end
					
					-- if v:GetClass() == "prop_physics" then
						local phys = v:GetPhysicsObject()
						if IsValid(phys) then
							phys:ApplyForceCenter(v:GetPos() +self:GetForward() *phys:GetMass() *(dmg *20) +self:GetUp() *phys:GetMass() *(dmg))
						end
					-- end
				end
			end
		end
	end
	if hitentity then
		if self.CustomOnHitEntity then self:CustomOnHitEntity(hitEnts,doactualdmg) end
	else
		self:EmitSound("npc/zombie/claw_miss1.wav",math.random(50,65),math.random(100,125))
		if self.CustomOnMissEntity then self:CustomOnMissEntity() end
	end
end
---------------------------------------------------------------------------------------------------------------------------------------------
function ENT:CreateAura(ply)
	ParticleEffectAttach(PERSONA[ply:GetPersonaName()].Aura,PATTACH_POINT_FOLLOW,ply,ply:LookupAttachment("origin"))
end
---------------------------------------------------------------------------------------------------------------------------------------------
function ENT:DoChat(text)
	if self.User:IsPlayer() then self.User:ChatPrint(text) end
end
---------------------------------------------------------------------------------------------------------------------------------------------
function ENT:SoundTimer(t,ent,snd)
	timer.Simple(t,function()
		if IsValid(ent) then
			ent:EmitSound(snd)
		end
	end)
end
---------------------------------------------------------------------------------------------------------------------------------------------
function ENT:OnKilledEnemy(ent) end
---------------------------------------------------------------------------------------------------------------------------------------------
function ENT:OnKilledEnemy_EXP(ent)
	local ply = self.User
	local level = ent:GetNWInt("PXP_Level")
	local exp = ent:GetNWInt("PXP_EXP")
	
	PXP.GiveEXP(ply,exp)
end
---------------------------------------------------------------------------------------------------------------------------------------------
function ENT:MegidolaonEffect(ent,dmg)
	local dmg = dmg or DMG_P_SEVERE
	local m = ents.Create("prop_vj_animatable")
	m:SetModel("models/cpthazama/persona5/effects/megidolaon.mdl")
	m:SetPos(ent:GetPos())
	m:Spawn()
	m:SetCollisionGroup(COLLISION_GROUP_IN_VEHICLE)
	m:ResetSequence("idle")
	m:SetModelScale(100,5)
	VJ_CreateSound(m,"cpthazama/persona5/skills/megidolaon.wav",150)
	-- m:EmitSound("PERSONA_MEGIDOLAON")
	local Light = ents.Create("light_dynamic")
	Light:SetKeyValue("brightness","7")
	Light:SetKeyValue("distance","3800")
	Light:SetPos(m:GetPos())
	Light:Fire("Color","180 255 255")
	Light:SetParent(m)
	Light:Spawn()
	Light:Activate()
	Light:Fire("TurnOn","",0)
	Light:Fire("TurnOff","",5)
	m:DeleteOnRemove(Light)
	timer.Simple(4,function()
		if IsValid(m) then
			for _,v in pairs(ents.FindInSphere(m:GetPos(),3800)) do
				if (v != self && v != self.User) && (((v:IsNPC() or (v:IsPlayer() && v:Alive()))) or v:GetClass() == "func_breakable_surf" or v:GetClass() == "prop_physics") then
					local dmginfo = DamageInfo()
					dmginfo:SetDamage(IsValid(self) && self:AdditionalInput(dmg,2) or dmg)
					dmginfo:SetDamageType(DMG_P_ALMIGHTY)
					dmginfo:SetInflictor(IsValid(self) && self or v)
					dmginfo:SetAttacker(IsValid(self) && IsValid(self.User) && self.User or v)
					dmginfo:SetDamagePosition(v:NearestPoint(m:GetPos()))
					v:TakeDamageInfo(dmginfo,IsValid(self) && IsValid(self.User) && self.User or v)
					v:EmitSound("cpthazama/persona5/skills/0014.wav",70)
				end
			end
		end
	end)
	timer.Simple(5,function()
		if IsValid(m) then
			SafeRemoveEntity(m)
		end
	end)
end
---------------------------------------------------------------------------------------------------------------------------------------------
function ENT:MaziodyneAttack(att,dist,eff,target)
	local pos = self:GetAttachment(att).Pos
	local ent = self.User:IsNPC() && IsValid(self.User:GetEnemy()) && self.User:GetEnemy() or self.User:IsPlayer() && IsValid(self.User.Persona_EyeTarget) && self.User.Persona_EyeTarget or NULL
	if IsValid(target) then
		ent = target
	end
	local endPosi = IsValid(ent) && (ent:GetPos() +ent:OBBCenter()) or pos +self:GetForward() *dist
	local tr = util.TraceLine({
		start = pos,
		endpos = endPosi,
	})
	self:EmitSound("cpthazama/persona5/adachi/elec_charge.wav",75)
	if tr.Hit then
		if !IsValid(ent) then
			ent = tr.Entity
		end
		util.ParticleTracerEx(eff or "maziodyne_blue",pos,tr.HitPos,false,self:EntIndex(),att)
	else
		util.ParticleTracerEx(eff or "maziodyne_blue",pos,endPosi,false,self:EntIndex(),att)
	end
	local trB = util.TraceLine({
		start = pos,
		endpos = ent && ent:GetPos() +ent:OBBCenter() or tr.HitPos,
	})
	if ent && ent:Health() && ent:Health() > 0 && trB.Hit && trB.Entity == ent then
		self:DealDamage(ent,1,DMG_P_ELEC,2)
	end
end
---------------------------------------------------------------------------------------------------------------------------------------------
function ENT:Curse(ent,t,dmg)
	ent.Persona_DMG_Curse = CurTime() +t
	ParticleEffectAttach("persona_fx_dmg_fear",PATTACH_POINT_FOLLOW,ent,ent:LookupAttachment("origin"))
	for i = 1, t do
		timer.Simple(i,function()
			if IsValid(ent) then
				local dmginfo = DamageInfo()
				dmginfo:SetDamage(dmg)
				dmginfo:SetDamageType(DMG_P_CURSE)
				dmginfo:SetInflictor(IsValid(self) && self or ent)
				dmginfo:SetAttacker(IsValid(self) && IsValid(self.User) && self.User or ent)
				ent:TakeDamageInfo(dmginfo,IsValid(self) && IsValid(self.User) && self.User or ent)
			end
		end)
	end
	timer.Simple(t +0.15,function()
		if IsValid(ent) then
			if CurTime() > ent.Persona_DMG_Curse then
				ent:StopParticles()
			end
		end
	end)
end
---------------------------------------------------------------------------------------------------------------------------------------------
function ENT:Fear(ent,t)
	if ent:IsNPC() then
		local prevDisp = ent:Disposition(self.User) != D_FR && ent:Disposition(self.User) or D_NU
		ent.Persona_DMG_Fear = CurTime() +t
		ParticleEffectAttach("persona_fx_dmg_fear",PATTACH_POINT_FOLLOW,ent,ent:LookupAttachment("origin"))
		ent:AddEntityRelationship(self.User,D_FR,99)
		ent:EmitSound("cpthazama/persona5/adachi/curse.wav",80)
		timer.Simple(t +0.15,function()
			if IsValid(ent) then
				if CurTime() > ent.Persona_DMG_Fear then
					ent:StopParticles()
					if IsValid(self) && IsValid(self.User) then
						ent:AddEntityRelationship(self.User,prevDisp,99)
					end
				end
			end
		end)
	else
		ent.Persona_DMG_Fear = CurTime() +t
		ParticleEffectAttach("persona_fx_dmg_fear",PATTACH_POINT_FOLLOW,ent,ent:LookupAttachment("origin"))
		ent:EmitSound("cpthazama/persona5/adachi/curse.wav",80)
		timer.Simple(t +0.15,function()
			if IsValid(ent) then
				if CurTime() > ent.Persona_DMG_Fear then
					ent:StopParticles()
				end
			end
		end)
	end
end
---------------------------------------------------------------------------------------------------------------------------------------------
hook.Add("OnNPCKilled","Persona_NPCKilled",function(ent,killer,weapon)
	if killer:IsPlayer() then
		local persona = killer:GetPersona()
		if IsValid(persona) then
			persona:OnKilledEnemy(ent)
			persona:OnKilledEnemy_EXP(ent)
		end
	end
end)
---------------------------------------------------------------------------------------------------------------------------------------------
hook.Add("PlayerDeath","Persona_PlayerKilled",function(ent,killer,weapon)
	if killer:IsPlayer() && killer != ent then
		local persona = killer:GetPersona()
		if IsValid(persona) then
			persona:OnKilledEnemy(ent)
			persona:OnKilledEnemy_EXP(ent)
		end
	end
end)
---------------------------------------------------------------------------------------------------------------------------------------------
function ENT:UpdateStats()
	self.Stats.STR = self.Stats.STR +1
	self.Stats.MAG = self.Stats.MAG +1
	self.Stats.END = self.Stats.END +1
	self.Stats.AGI = self.Stats.AGI +1
	self.Stats.LUC = self.Stats.LUC +1
	PXP.SavePersonaStats(self.User)
end
---------------------------------------------------------------------------------------------------------------------------------------------
function ENT:WhenRemoved() end
---------------------------------------------------------------------------------------------------------------------------------------------
function ENT:OnRemove()
	if IsValid(self.User) then
		self.User:SetNWVector("Persona_CustomPos",Vector(0,0,0))
		self.User:StopParticles()

		local exp = PXP.GetPersonaData(self.User,1)
		local lvl = PXP.GetPersonaData(self.User,2)
		self.EXP = exp != nil && exp or 0
		self.Level = lvl != nil && lvl or self.Stats.LVL
		-- if self.EXP < (self.Stats.LVL *1500) then
			-- self.EXP = self.Stats.LVL *1500
		-- end
		if self.Level < self.Stats.LVL then
			self.Level = self.Stats.LVL
		end
		PXP.SavePersonaData(self.User,self.EXP,self.Level,self.CardTable)
	end
	self:StopParticles()
	self:WhenRemoved()
	for _,v in pairs(self.Loops) do
		if v then
			v:Stop()
		end
	end
end