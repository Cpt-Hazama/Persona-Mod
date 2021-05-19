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
	WK = {}, -- Weak to
	RES = {}, -- Resistent to
	NUL = {}, -- Nullifies
	REF = {}, -- Reflects
	ABS = {}, -- Absorbs and converts into health
}
---------------------------------------------------------------------------------------------------------------------------------------------
ENT.LeveledSkills = {} -- Skills must be place in a specific order! Top of table must be the highest level req. and the last one in the table must be the lowest level req.
-- ENT.LegendaryMaterials = {}
ENT.IsVelvetPersona = false
---------------------------------------------------------------------------------------------------------------------------------------------
ENT.MovesWithUser = true -- Should it lean when the player moves?
ENT.AuraChance = 2 -- Obsolete
ENT.IdleSpeed = 1 -- The playback rate of the idle animation
ENT.StartMeleeDamageCode = false -- If set to a number, overrides the built-in start timer for melee skills
ENT.FirstMeleeDamageTime = false -- If set to a number, overrides the built-in initial damage timer for melee skills
ENT.DamageTypes = bit.bor(DMG_SLASH,DMG_CRUSH,DMG_ALWAYSGIB) -- Obsolete
---------------------------------------------------------------------------------------------------------------------------------------------
function ENT:HandleEvents(skill,animBlock,seq,t) -- Default events, override in your Persona
	if animBlock == "melee" then
		self:UserSound("cpthazama/persona5/joker/00" .. math.random(67,68) .. ".wav",80)
		return
	end
	if animBlock == "range" then
		self:UserSound("cpthazama/persona5/joker/00" .. math.random(68,70) .. ".wav",80)
		return
	end
end
---------------------------------------------------------------------------------------------------------------------------------------------
function ENT:HandleAnimationEvent(seq,event,frame) end
---------------------------------------------------------------------------------------------------------------------------------------------
function ENT:Initialize()
	self:SetSolid(SOLID_OBB)
	self:SetCollisionGroup(COLLISION_GROUP_IN_VEHICLE)
	self:SetRenderMode(RENDERMODE_TRANSADD)
	self:DrawShadow(false)
	
	-- if self.IsPersonaRMD then
		-- self:SetColor(Color(255,255,255,250))
	-- else
		-- self:SetColor(Color(255,255,255,250)) // Yes ma'am
	-- end
	
	self.CurrentTask = "TASK_NONE"
	self.CurrentTaskID = -1
	
	self.CurrentForwardAng = self:GetAngles().x
	self.CurrentSideAng = self:GetAngles().z
	
	self.CurrentMeleeSkill = nil
	self.CurrentMeleeSkillCost = 0

	self.CurrentIdle = "idle"
	
	self.NextDamageUserT = 0
	
	self:SetCritical(false)
	self.HasChaosParticle = false
	self.HasOverdrive = false

	self.Loops = {}
	self.Flexes = {}
	self.AnimationEvents = {}
	
	self.NextCardSwitchT = CurTime()
	self.NextLockOnT = CurTime()
	
	self.BaseLevel = self.Stats.LVL
	self.BaseSTR = self.Stats.STR
	self.BaseMAG = self.Stats.MAG
	self.BaseEND = self.Stats.END
	self.BaseAGI = self.Stats.AGI
	self.BaseLUC = self.Stats.LUC
	
	self.P_LerpVec = self:GetPos()
	self.P_LerpAng = self:GetAngles()

	timer.Simple(0,function()
		if self.User:IsPlayer() then
			net.Start("Persona_Elements")
				net.WriteEntity(self.User)
				net.WriteTable(self.Stats.WK)
				net.WriteTable(self.Stats.RES)
				net.WriteTable(self.Stats.NUL)
				net.WriteTable(self.Stats.REF)
				net.WriteTable(self.Stats.ABS)
			net.Send(self.User)
			if self.IsVelvetPersona then
				if !PXP.InCompendium(self.User,string.Replace(self:GetClass(),"prop_persona_","")) then
					SafeRemoveEntity(self)
					return
				end
				PXP.SetPersonaData(self.User,8,2)
			end
			PXP.SetPersonaData(self.User,5,self.User:GetNW2String("PersonaName"))

			self:CheckSkillLevel(true)
			PXP.ManagePersonaStats(self.User)
		else
			self:UnlockAllSkills()
		end
		self:CustomOnInitialize()
	end)
	
	-- self:AddAnimationEvent("attack",35,"dmgtimer_1",65)
	
	-- PrintTable(self:GetMaterials())
	-- timer.Simple(0,function()
		-- if PXP.IsLegendary(self.User) then
			-- self:MakeLegendary()
		-- end
	-- end)
end
---------------------------------------------------------------------------------------------------------------------------------------------
function ENT:MakeLegendary()
	self.Stats.LVL = 0
	self.Stats.STR = 1
	self.Stats.MAG = 1
	self.Stats.END = 1
	self.Stats.AGI = 1
	self.Stats.LUC = 1

	self.BaseLevel = 0
	self.BaseSTR = 1
	self.BaseMAG = 1
	self.BaseEND = 1
	self.BaseAGI = 1
	self.BaseLUC = 1
	
	PXP.ManagePersonaStats(self.User)

	for index,mat in pairs(self.LegendaryMaterials) do
		self:SetSubMaterial(index -1,mat)
	end
	
	self.IsLegendary = true
	self:RequestAura(self.User,PERSONA[self.User:GetPersonaName()].Aura)
	-- self:Overdrive(true)
end
---------------------------------------------------------------------------------------------------------------------------------------------
function ENT:Overdrive(b)
	self.HasOverdrive = b
	self:SetNW2Bool("Overdrive",b)
	self:StopParticles()
	if self.OverdriveAura then self.OverdriveAura:Stop() end
	if b then
		if !self.OverdriveAura then
			self.OverdriveAura = CreateSound(self,"cpthazama/persona_shared/overdrive.wav")
			self.OverdriveAura:SetSoundLevel(65)
		end
		self.OverdriveAura:Play()
		self:RequestAura(self.User,PERSONA[self.User:GetPersonaName()].Aura)
		ParticleEffectAttach("persona_aura_overdrive",PATTACH_POINT_FOLLOW,self,self:LookupAttachment("origin"))
		return
	end
	self:RequestAura(self.User,PERSONA[self.User:GetPersonaName()].Aura)
end
---------------------------------------------------------------------------------------------------------------------------------------------
function ENT:CustomOnInitialize() end
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
	self:SetCriticalFX(true)
	self.User:EmitSound("cpthazama/persona5/misc/00015_streaming.wav",0.2)
	timer.Simple(t,function()
		if IsValid(self) then
			self:SetCritical(false)
		end
	end)
	timer.Simple(t /2,function()
		if IsValid(self) then
			self:SetCriticalFX(false)
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
function ENT:OnRunDamageCode(dmginfo,pos,hitEnts) end
---------------------------------------------------------------------------------------------------------------------------------------------
function ENT:PersonaControls(ply,persona) end
---------------------------------------------------------------------------------------------------------------------------------------------
function ENT:PersonaThink_NPC(ply,persona) end
---------------------------------------------------------------------------------------------------------------------------------------------
function ENT:IdleAnimationCode(ply)
	self.CurrentIdle = self.User:IsPlayer() && self.User:Crouching() && "idle_low" or "idle"
	if self.AllowFading then self:FadeIn() end
	if self:GetSequenceName(self:GetSequence()) != self.Animations[self.CurrentIdle] then
		self:DoIdle()
	end
	self.P_LerpVec = LerpVector(FrameTime() *50,self.P_LerpVec,self.User.IsPersonaShadow && self.User:GetPos() or self:GetIdlePosition(ply))
	self:SetPos(self.P_LerpVec)
	self:FacePlayerAim(self.User)
end
---------------------------------------------------------------------------------------------------------------------------------------------
function ENT:OnThink(ply) end
---------------------------------------------------------------------------------------------------------------------------------------------
function ENT:DefaultPersonaControls(ply,persona)
	self:SetLVL(self.Stats.LVL)
	self:SetSTR(self.Stats.STR)
	self:SetMAG(self.Stats.MAG)
	self:SetEND(self.Stats.END)
	self:SetAGI(self.Stats.AGI)
	self:SetLUC(self.Stats.LUC)
	if ply:IsPlayer() then
		local ent = ply.Persona_EyeTarget
		if IsValid(ent) && ent:Health() <= 0 then
			ply.Persona_EyeTarget = NULL
		end
		ply:SetNW2Entity("Persona_Target",ent)
		ply:SetNW2Int("Persona_TargetHealth",IsValid(ent) && ent:Health() or 100)
		-- if ply:KeyReleased(IN_WALK) && CurTime() > self.NextLockOnT then
			-- if IsValid(ply.Persona_EyeTarget) then
				-- ply.Persona_EyeTarget = NULL
				-- ply:EmitSound("cpthazama/persona5/misc/00019.wav",70,100)
			-- else
				-- local ent = ply:GetEyeTrace().Entity
				-- if IsValid(ent) then
					-- if (ent:IsNPC() or ent:IsPlayer() or (ent.IsPersona && ent != persona)) then
						-- ply.Persona_EyeTarget = ent
						-- ply:EmitSound("cpthazama/persona5/misc/00007.wav",70,100)
					-- end
				-- else
					-- local ents = self:FindEnemies(ply:GetPos(),2000)
					-- local ent = VJ_PICK(ents)
					-- if IsValid(ent) then
						-- ply.Persona_EyeTarget = ent
						-- ply:EmitSound("cpthazama/persona5/misc/00007.wav",70,100)
					-- end
				-- end
			-- end
			-- self.NextLockOnT = CurTime() +0.2
		-- end
		if IsValid(ply.Persona_EyeTarget) then
			-- ply:SetEyeAngles(LerpAngle(5 *FrameTime(),ply:EyeAngles(),((ply.Persona_EyeTarget:GetPos() +ply.Persona_EyeTarget:OBBCenter()) -ply:GetShootPos()):Angle()))
			local ang = ply:GetAngles()
			ply:SetAngles(Angle(ang.x,((ply.Persona_EyeTarget:GetPos() +ply.Persona_EyeTarget:OBBCenter()) -ply:GetPos()):Angle().y,ang.z))
		end
	end
	if self:GetTask() == "TASK_IDLE" then
		self:IdleAnimationCode(ply)

		if ply:IsPlayer() && self.MovesWithUser then
			local w = ply:KeyDown(IN_FORWARD)
			local a = ply:KeyDown(IN_MOVELEFT)
			local d = ply:KeyDown(IN_MOVERIGHT)
			local s = ply:KeyDown(IN_BACK)
			local ang = self.User:GetAngles()
			local speed = 3
			local speedS = 2
			if !w && !a && !d && !s then
				self.P_LerpAng = LerpAngle(FrameTime() *15,self.P_LerpAng,self.User:GetAngles())
				self:SetAngles(self.P_LerpAng)
			end
			if w then
				if self.CurrentForwardAng != 15 then
					self.CurrentForwardAng = self.CurrentForwardAng +speed
				end
			elseif s then
				if self.CurrentForwardAng != -15 then
					self.CurrentForwardAng = self.CurrentForwardAng -speed
				end
			else
				if self.CurrentForwardAng != 0 then
					self.CurrentForwardAng = (self.CurrentForwardAng > 0 && self.CurrentForwardAng -speed) or self.CurrentForwardAng +speed
				end
			end
			if a then
				if self.CurrentSideAng != -8 then
					self.CurrentSideAng = self.CurrentSideAng -speedS
				end
			elseif d then
				if self.CurrentSideAng != 8 then
					self.CurrentSideAng = self.CurrentSideAng +speedS
				end
			else
				if self.CurrentSideAng != 0 then
					self.CurrentSideAng = (self.CurrentSideAng > 0 && self.CurrentSideAng -speedS) or self.CurrentSideAng +speedS
				end
			end
			self.P_LerpAng = LerpAngle(FrameTime() *15,self.P_LerpAng,Angle(self.CurrentForwardAng,ang.y,self.CurrentSideAng))
			self:SetAngles(self.P_LerpAng)
		else
			self.P_LerpAng = LerpAngle(FrameTime() *15,self.P_LerpAng,self.User:GetAngles())
			self:SetAngles(self.P_LerpAng)
		end
	elseif self:GetTask() == "TASK_ATTACK" then
		-- if !IsValid(ply.Persona_EyeTarget) then self:FindTarget(ply) end
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
	local isTurn = self:IsMyTurn()
	if IsPersonaGamemode() then
		if ply:InBattle() && GMP().Battles[ply:CurrentBattle()] && GMP().Battles[ply:CurrentBattle()].CurrentTurn != ply then
			return -- Not my turn, can't do anything
		end
	end
	if r && CurTime() > self.NextCardSwitchT then
		if !isTurn then if ply:IsPlayer() then ply:ChatPrint("Unable to switch cards, not your turn!") end return end
		self:CycleCards()
	end
	if lmb then
		if !isTurn then if ply:IsPlayer() then ply:ChatPrint("Unable to use card, not your turn!") end return end
		self:DoMeleeAttack(ply,persona,melee,rmb)
	end
	if rmb then
		if !isTurn then if ply:IsPlayer() then ply:ChatPrint("Unable to use card, not your turn!") end return end
		self:DoSpecialAttack(ply,persona,melee,rmb)
	end
end
---------------------------------------------------------------------------------------------------------------------------------------------
function ENT:GetUsableSkillsBesidesType(type,cost,allowMelee)
	local tbl = {}
	for _,card in pairs(self:GetSkillsBesides(type,allowMelee)) do
		if card.Cost <= cost then
			table.insert(tbl,card.Name)
		end
	end
	return VJ_PICK(tbl)
end
---------------------------------------------------------------------------------------------------------------------------------------------
function ENT:GetUsableSkillsByType(type,cost,allowMelee)
	local tbl = {}
	for _,card in pairs(self:GetSelectSkills(type,allowMelee)) do
		if card.Cost <= cost then
			table.insert(tbl,card.Name)
		end
	end
	return VJ_PICK(tbl)
end
---------------------------------------------------------------------------------------------------------------------------------------------
function ENT:GetSelectSkills(type,allowMelee)
	local tbl = {}
	for ind,card in pairs(self.CardTable) do
		if card.Icon == type && (allowMelee && !card.UsesHP or true) then
			table.insert(tbl,{Name=card.Name,Cost=card.Cost})
		end
	end
	return tbl
end
---------------------------------------------------------------------------------------------------------------------------------------------
function ENT:GetSkillsBesides(type,allowMelee)
	local tbl = {}
	for ind,card in pairs(self.CardTable) do
		if card.Icon != type && (allowMelee && !card.UsesHP or true) then
			table.insert(tbl,{Name=card.Name,Cost=card.Cost})
		end
	end
	return tbl
end
---------------------------------------------------------------------------------------------------------------------------------------------
function ENT:HasSkillType(type)
	for ind,card in pairs(self.CardTable) do
		if card.Icon == type then
			return true
		end
	end
	return false
end
---------------------------------------------------------------------------------------------------------------------------------------------
function ENT:HasSkill(name)
	for ind,card in pairs(self.CardTable) do
		if card.Name == name then
			return true
		end
	end
	return false
end
---------------------------------------------------------------------------------------------------------------------------------------------
function ENT:DoMeleeAttack(ply,persona,melee,rmb)
	local isTurn = self:IsMyTurn()
	if !isTurn then return end
	self:SetNW2String("LastCard",melee)
	if melee == "Heaven's Blade" then
		self:HeavensBlade(ply,persona)
		return
	elseif melee == "Cross Slash" then
		self:CrossSlash(ply,persona)
		return
	elseif melee == "Raining Seeds" then
		self:RainingSeeds(ply,persona)
		return
	elseif melee == "Ghastly Wail" then
		self:GhostlyWail(ply)
		return
	elseif melee == "Laevateinn" then
		self:Laevateinn(ply,ply.Persona_EyeTarget)
		return
	elseif melee == "One-shot Kill" then
		self:OneShotKill(ply,persona)
		return
	elseif melee == "Riot Gun" then
		self:RiotGun(ply,persona)
		return
	elseif melee == "Vorpal Blade" then
		self:VorpalBlade(ply,persona)
		return
	elseif melee == "Beast Weaver" then
		self:BeastWeaver(ply,persona)
		return
	elseif melee == "Miracle Punch" then
		self:MiraclePunch(ply,persona)
		return
	elseif melee == "Almighty Slash" then
		self:AlmightySlash(ply,persona)
		return
	elseif melee == "Magatsu Blade" then
		self:MagatsuBlade(ply,persona)
		return
	elseif melee == "Vajra Blast" then
		self:VajraBlast(ply,persona)
		return
	elseif melee == "Hassou Tobi" then
		self:HassouTobi(ply,persona)
		return
	elseif melee == "Cleave" then
		self:Cleave(ply,persona)
		return
	elseif melee == "Megaton Raid" then
		self:MegatonRaid(ply,persona)
		return
	elseif melee == "Agneyastra" then
		self:Agneyastra(ply,persona)
		return
	elseif melee == "Heat Wave" then
		self:HeatWave(ply,persona)
		return
	elseif melee == "Black Spot" then
		self:BlackSpot(ply,persona)
		return
	elseif melee == "Gigantomachia" then
		self:Gigantomachia(ply,persona)
		return
	elseif melee == "Bash" then
		self:Bash(ply,persona)
		return
	elseif melee == "Rampage" then
		self:Rampage(ply,persona)
		return
	elseif melee == "Skull Cracker" then
		self:SkullCracker(ply,persona)
		return
	elseif melee == "Gale Slash" then
		self:GaleSlash(ply,persona)
		return
	elseif melee == "God's Hand" then
		self:GodsHand(ply,persona)
		return
	elseif melee == "Terror Claw" then
		self:TerrorClaw(ply,persona)
		return
	else
		if ply:IsPlayer() && melee then
			ply:ChatPrint("Sorry, " .. melee .. " has not been programmed yet. It will be available in the future!")
			ply:EmitSound("cpthazama/persona5/misc/00103.wav")
		end
		self:SetNW2String("LastCard","")
		return
	end
end
---------------------------------------------------------------------------------------------------------------------------------------------
function ENT:DoSpecialAttack(ply,persona,melee,rmb)
	local isTurn = self:IsMyTurn()
	if !isTurn then return end
	local card = self:GetCard()
	self:SetNW2String("LastCard",card)
	if card == "Myriad Truths" then
		self:MyriadTruths(ply,persona)
		return
	elseif card == "Piercing Strike" then
		self:PiercingStrike(ply,persona)
		return
	elseif card == "Tyrant Chaos" then
		self:TyrantChaos(ply,persona)
		return
	elseif card == "Dream Fog" then
		self:DreamFog(ply,persona)
		return
	elseif card == "Tentacle of Protection" then
		self:SummonTentacle(ply,persona,1,card)
		return
	elseif card == "Tentacle of Healing" then
		self:SummonTentacle(ply,persona,2,card)
		return
	elseif card == "Tentacle of Assistance" then
		self:SummonTentacle(ply,persona,3,card)
		return
	elseif card == "Bufu" then
		self:Bufu(ply,persona)
		return
	elseif card == "Bufula" then
		self:Bufula(ply,persona)
		return
	elseif card == "Bufudyne" then
		self:Bufudyne(ply,persona)
		return
	elseif card == "Mabufu" then
		self:Mabufu(ply,persona)
		return
	elseif card == "Mabufula" then
		self:Mabufula(ply,persona)
		return
	elseif card == "Mabufudyne" then
		self:Mabufudyne(ply,persona)
		return
	elseif card == "Diamond Dust" then
		self:DiamondDust(ply,persona)
		return
	elseif card == "Ice Age" then
		self:IceAge(ply,persona)
		return
	elseif card == "Psi" then
		self:Psi(ply,persona)
		return
	elseif card == "Psio" then
		self:Psio(ply,persona)
		return
	elseif card == "Psiodyne" then
		self:Psiodyne(ply,persona)
		return
	elseif card == "Mapsi" then
		self:Mapsi(ply,persona)
		return
	elseif card == "Mapsio" then
		self:Mapsio(ply,persona)
		return
	elseif card == "Mapsiodyne" then
		self:Mapsiodyne(ply,persona)
		return
	elseif card == "Psycho Force" then
		self:PsychoForce(ply,persona)
		return
	elseif card == "Psycho Blast" then
		self:PsychoBlast(ply,persona)
		return
	elseif card == "Marin Karin" then
		self:MarinKarin(ply,persona)
		return
	elseif card == "Life Drain" then
		self:LifeDrain(ply,persona)
		return
	elseif card == "Spirit Drain" then
		self:SpiritDrain(ply,persona)
		return
	elseif card == "Agi" then
		self:Agi(ply,persona)
		return
	elseif card == "Inferno" then
		self:Inferno(ply,persona)
		return
	elseif card == "Agilao" then
		self:Agilao(ply,persona)
		return
	elseif card == "Agidyne" then
		self:Agidyne(ply,persona)
		return
	elseif card == "Maragi" then
		self:Maragi(ply,persona)
		return
	elseif card == "Maragidyne" then
		self:Maragidyne(ply,persona)
		return
	elseif card == "Titanomachia" then
		self:Titanomachia(ply,persona)
		return
	elseif card == "Blazing Hell" then
		self:BlazingHell(ply,persona)
		return
	elseif card == "Maragion" then
		self:Maragion(ply,persona)
		return
	elseif card == "Yomi Drop" then
		self:YomiDrop(ply,persona)
		return
	elseif card == "Myriad Mandala" then
		self:MyriadMandala(ply,persona)
		return
	elseif card == "Velvet Mandala" then
		self:VelvetMandala(ply,persona)
		return
	elseif card == "Maziodyne" then
		self:Maziodyne(ply,persona,rmb)
		return
	elseif card == "Thunder Reign" then
		self:ThunderReign(ply,persona,rmb)
		return
	elseif card == "Wild Thunder" then
		self:WildThunder(ply,persona,rmb)
		return
	elseif card == "Colossal Storm" then
		self:ColossalStorm(ply,persona,rmb)
		return
	elseif card == "Zio" then
		self:Zio(ply,persona,rmb)
		return
	elseif card == "Zionga" then
		self:Zionga(ply,persona,rmb)
		return
	elseif card == "Ziodyne" then
		self:Ziodyne(ply,persona,rmb)
		return
	elseif card == "Mazio" then
		self:Mazio(ply,persona,rmb)
		return
	elseif card == "Mazionga" then
		self:Mazionga(ply,persona,rmb)
		return
	elseif card == "Evil Smile" then
		self:EvilSmile(ply,persona,rmb)
		return
	elseif card == "Teleport" then
		self:Teleport(ply,persona)
		return
	elseif card == "Charge" then
		self:Charge(ply,persona)
		return
	elseif card == "Concentrate" then
		self:Concentrate(ply,persona)
		return
	elseif card == "Tarukaja" then
		self:Tarukaja(ply,persona)
		return
	elseif card == "Rakukaja" then
		self:Rakukaja(ply,persona)
		return
	elseif card == "Sukukaja" then
		self:Sukukaja(ply,persona)
		return
	elseif card == "Tarunda" then
		self:Tarunda(ply,persona)
		return
	elseif card == "Rakunda" then
		self:Rakunda(ply,persona)
		return
	elseif card == "Sukunda" then
		self:Sukunda(ply,persona)
		return
	elseif card == "Heat Riser" then
		self:HeatRiser(ply,persona)
		return
	elseif card == "Tetrakarn" then
		self:Tetrakarn(ply,persona)
		return
	elseif card == "Makarakarn" then
		self:Makarakarn(ply,persona)
		return
	elseif card == "Salvation" then
		self:Salvation(ply,persona)
		return
	elseif card == "Cadenza" then
		self:Cadenza(ply,persona)
		return
	elseif card == "Dia" then
		self:Dia(ply,persona)
		return
	elseif card == "Diarama" then
		self:Diarama(ply,persona)
		return
	elseif card == "Diarahan" then
		self:Diarahan(ply,persona)
		return
	elseif card == "Mediarahan" then
		self:Mediarahan(ply,persona)
		return
	elseif card == "Debilitate" then
		self:Debilitate(ply,persona)
		return
	elseif card == "Eiha" then
		self:Eiha(ply,persona)
		return
	elseif card == "Eiga" then
		self:Eiga(ply,persona)
		return
	elseif card == "Eigaon" then
		self:Eigaon(ply,persona)
		return
	elseif card == "Maeiha" then
		self:Maeiha(ply,persona)
		return
	elseif card == "Maeiga" then
		self:Maeiga(ply,persona)
		return
	elseif card == "Maeigaon" then
		self:Maeigaon(ply,persona)
		return
	elseif card == "Magatsu Mandala" then
		self:MagatsuMandala(ply,persona)
		return
	elseif card == "Garu" then
		self:Garu(ply,persona)
		return
	elseif card == "Garudyne" then
		self:Garudyne(ply,persona)
		return
	elseif card == "Magarudyne" then
		self:Magarudyne(ply,persona)
		return
	elseif card == "Hama" then
		self:Hama(ply,persona)
		return
	elseif card == "Hamaon" then
		self:Hamaon(ply,persona)
		return
	elseif card == "Mahama" then
		self:Mahama(ply,persona)
		return
	elseif card == "Mahamaon" then
		self:Mahamaon(ply,persona)
		return
	elseif card == "Mudo" then
		self:Mudo(ply,persona)
		return
	elseif card == "Mudoon" then
		self:Mudoon(ply,persona)
		return
	elseif card == "Mamudo" then
		self:Mamudo(ply,persona)
		return
	elseif card == "Mamudoon" then
		self:Mamudoon(ply,persona)
		return
	elseif card == "Die For Me!" then
		self:DieForMe(ply,persona)
		return
	elseif card == "Black Viper" then
		self:BlackViper(ply,persona)
		return
	elseif card == "Doors of Hades" then
		self:DoorsOfHades(ply,persona)
		return
	elseif card == "Megidola" then
		self:Megidola(ply,persona)
		return
	elseif card == "Megidolaon" then
		self:Megidolaon(ply,ply.Persona_EyeTarget)
		return
	elseif card == "Sinful Shell" then
		self:SinfulShell(ply,persona)
		return
	elseif card == "Call of Chaos" then
		self:CallOfChaos(ply,persona)
		return
	elseif card == "Abyssal Wings" then
		self:AbyssalWings(ply,persona)
		return
	elseif card == "Freila" then
		self:Freila(ply,persona)
		return
	elseif card == "Freidyne" then
		self:Freidyne(ply,persona)
		return
	elseif card == "Nuclear Crush" then
		self:NuclearCrush(ply,persona)
		return
	elseif card == "Kouha" then
		self:Kouha(ply,persona)
		return
	elseif card == "Kouga" then
		self:Kouga(ply,persona)
		return
	elseif card == "Kougaon" then
		self:Kougaon(ply,persona)
		return
	elseif card == "Makouha" then
		self:Makouha(ply,persona)
		return
	elseif card == "Makouga" then
		self:Makouga(ply,persona)
		return
	elseif card == "Makougaon" then
		self:Makougaon(ply,persona)
		return
	elseif card == "Divine Judgement" then
		self:DivineJudgement(ply,persona)
		return
	elseif card == "Eternal Radiance" then
		self:EternalRadiance(ply,persona)
		return
	elseif card == "Recover HP EX" then
		self:RecoverHPEX(ply,persona)
		return
	elseif card == "Recover SP EX" then
		self:RecoverSPEX(ply,persona)
		return
	elseif card == "Minor Buff" then
		self:MinorBuff(ply,persona)
		return
	elseif card == "Minor Shield" then
		self:MinorShield(ply,persona)
		return
	elseif card == "Minor Awareness" then
		self:MinorAwareness(ply,persona)
		return
	elseif card == "Power Up" then
		self:PowerUp(ply,persona)
		return
	elseif card == "Ultimate Charge" then
		self:UltimateCharge(ply,persona)
		return
	elseif card == "Terror Claw" then
		self.CurrentMeleeSkill = card
		if ply:IsNPC() then
			self:DoMeleeAttack(ply,persona,melee,rmb)
		end
		return
	elseif card == "Laevateinn" then
		self.CurrentMeleeSkill = card
		if ply:IsNPC() then
			self:DoMeleeAttack(ply,persona,melee,rmb)
		end
		return
	elseif card == "Magatsu Blade" then
		self.CurrentMeleeSkill = card
		if ply:IsNPC() then
			self:DoMeleeAttack(ply,persona,melee,rmb)
		end
		return
	elseif card == "Hassou Tobi" then
		self.CurrentMeleeSkill = card
		if ply:IsNPC() then
			self:DoMeleeAttack(ply,persona,melee,rmb)
		end
		return
	elseif card == "Heaven's Blade" then
		self.CurrentMeleeSkill = card
		if ply:IsNPC() then
			self:DoMeleeAttack(ply,persona,melee,rmb)
		end
		return
	elseif card == "Raining Seeds" then
		self.CurrentMeleeSkill = card
		if ply:IsNPC() then
			self:DoMeleeAttack(ply,persona,melee,rmb)
		end
		return
	elseif card == "Cross Slash" then
		self.CurrentMeleeSkill = card
		if ply:IsNPC() then
			self:DoMeleeAttack(ply,persona,melee,rmb)
		end
		return
	elseif card == "Ghastly Wail" then
		self.CurrentMeleeSkill = card
		if ply:IsNPC() then
			self:DoMeleeAttack(ply,persona,melee,rmb)
		end
		return
	elseif card == "One-shot Kill" then
		self.CurrentMeleeSkill = card
		if ply:IsNPC() then
			self:DoMeleeAttack(ply,persona,melee,rmb)
		end
		return
	elseif card == "Riot Gun" then
		self.CurrentMeleeSkill = card
		if ply:IsNPC() then
			self:DoMeleeAttack(ply,persona,melee,rmb)
		end
		return
	elseif card == "Vorpal Blade" then
		self.CurrentMeleeSkill = card
		if ply:IsNPC() then
			self:DoMeleeAttack(ply,persona,melee,rmb)
		end
		return
	elseif card == "Beast Weaver" then
		self.CurrentMeleeSkill = card
		if ply:IsNPC() then
			self:DoMeleeAttack(ply,persona,melee,rmb)
		end
		return
	elseif card == "Miracle Punch" then
		self.CurrentMeleeSkill = card
		if ply:IsNPC() then
			self:DoMeleeAttack(ply,persona,melee,rmb)
		end
		return
	elseif card == "Almighty Slash" then
		self.CurrentMeleeSkill = card
		if ply:IsNPC() then
			self:DoMeleeAttack(ply,persona,melee,rmb)
		end
		return
	elseif card == "Vajra Blast" then
		self.CurrentMeleeSkill = card
		if ply:IsNPC() then
			self:DoMeleeAttack(ply,persona,melee,rmb)
		end
		return
	elseif card == "Cleave" then
		self.CurrentMeleeSkill = card
		if ply:IsNPC() then
			self:DoMeleeAttack(ply,persona,melee,rmb)
		end
		return
	elseif card == "Megaton Raid" then
		self.CurrentMeleeSkill = card
		if ply:IsNPC() then
			self:DoMeleeAttack(ply,persona,melee,rmb)
		end
		return
	elseif card == "Agneyastra" then
		self.CurrentMeleeSkill = card
		if ply:IsNPC() then
			self:DoMeleeAttack(ply,persona,melee,rmb)
		end
		return
	elseif card == "Heat Wave" then
		self.CurrentMeleeSkill = card
		if ply:IsNPC() then
			self:DoMeleeAttack(ply,persona,melee,rmb)
		end
		return
	elseif card == "Black Spot" then
		self.CurrentMeleeSkill = card
		if ply:IsNPC() then
			self:DoMeleeAttack(ply,persona,melee,rmb)
		end
		return
	elseif card == "Gale Slash" then
		self.CurrentMeleeSkill = card
		if ply:IsNPC() then
			self:DoMeleeAttack(ply,persona,melee,rmb)
		end
		return
	elseif card == "Rampage" then
		self.CurrentMeleeSkill = card
		if ply:IsNPC() then
			self:DoMeleeAttack(ply,persona,melee,rmb)
		end
		return
	elseif card == "Skull Cracker" then
		self.CurrentMeleeSkill = card
		if ply:IsNPC() then
			self:DoMeleeAttack(ply,persona,melee,rmb)
		end
		return
	elseif card == "Bash" then
		self.CurrentMeleeSkill = card
		if ply:IsNPC() then
			self:DoMeleeAttack(ply,persona,melee,rmb)
		end
		return
	elseif card == "Gigantomachia" then
		self.CurrentMeleeSkill = card
		if ply:IsNPC() then
			self:DoMeleeAttack(ply,persona,melee,rmb)
		end
		return
	elseif card == "God's Hand" then
		self.CurrentMeleeSkill = card
		if ply:IsNPC() then
			self:DoMeleeAttack(ply,persona,melee,rmb)
		end
		return
	else
		if ply:IsPlayer() && card then
			ply:ChatPrint("Sorry, " .. card .. " has not been programmed yet. It will be available in the future!")
			ply:EmitSound("cpthazama/persona5/misc/00103.wav")
		end
		self:SetNW2String("LastCard","")
		return
	end
end
---------------------------------------------------------------------------------------------------------------------------------------------
function ENT:GetEventCoolDown(seq,frame)
	if self.EventCoolDown[seq] then
		return self.EventCoolDown[seq][frame][1]
	end
end
---------------------------------------------------------------------------------------------------------------------------------------------
function ENT:AddEventCoolDown(seq,frame)
	if self.EventCoolDown[seq] then
		self.EventCoolDown[seq][frame][1] = CurTime() +0.1
	end
end
---------------------------------------------------------------------------------------------------------------------------------------------
function ENT:AddAnimationEvent(seq,frame,eventName,frameCount)
	local seq = self:LookupSequence(seq)
	self.AnimationEvents = self.AnimationEvents or {}
	self.AnimationEvents[seq] = self.AnimationEvents[seq] or {}
	self.AnimationEvents[seq][frame] = self.AnimationEvents[seq][frame] or {}
	table.insert(self.AnimationEvents[seq][frame],eventName)
	
	self.EventCoolDown = self.EventCoolDown or {}
	self.EventCoolDown[seq] = self.EventCoolDown[seq] or {}
	self.EventCoolDown[seq][frame] = self.EventCoolDown[seq][frame] or {}
	table.insert(self.EventCoolDown[seq][frame],CurTime())

	if frameCount then
		self.RegisteredSequences = self.RegisteredSequences or {}
		self.RegisteredSequences[seq] = frameCount
	end
end
---------------------------------------------------------------------------------------------------------------------------------------------
function ENT:Think()
	self:SetNW2Bool("Legendary",self.IsLegendary)
	local seq = self:GetSequence()
	if self.AnimationEvents[seq] && self.RegisteredSequences[seq] then
		if self.LastSequence != seq then
			self.LastSequence = seq
			self.LastFrame = -1
		end
		local NextFrame = math.floor(self:GetCycle() *(self:GetPlaybackRate() *self.RegisteredSequences[seq]))
		self.LastFrame = NextFrame
		if self.AnimationEvents[seq][self.LastFrame] then
			for _,v in pairs(self.AnimationEvents[seq][self.LastFrame]) do
				if CurTime() > self:GetEventCoolDown(seq,self.LastFrame) then
					self:HandleAnimationEvent(seq,v,self.LastFrame)
					self:AddEventCoolDown(seq,self.LastFrame)
				end
			end
		end
	end
	self:NextThink(CurTime() +(0.069696968793869 +FrameTime()))
	if IsValid(self.User) then
		if !self.User:Alive() then
			self:Remove()
		end
		if self:GetTask() == "TASK_RETURN" then
			local dist = self.User:GetPos():Distance(self:GetPos())
			self:FacePlayerAim(self.User)
			local speed = 80
			if dist <= 170 then
				speed = 20
			end
			self:MoveToPos(self.User:GetPos(),speed)
			if dist <= 15 then
				self.User:EmitSound("cpthazama/persona5/persona_disapper.wav",65)
				-- if self.User:IsNPC() && self.User.OnDisablePersona then
					-- self.User:OnDisablePersona(self)
				-- end
				-- self.User:SetNW2Bool("Persona_SkillMenu",false)
				SafeRemoveEntity(self)
			end
			return
		end
		if self.HasChaosParticle then
			if CurTime() > self.User.Persona_ChaosT then
				self.HasChaosParticle = false
				self.User:StopParticles()
				self:CreateAura(self.User)
				if !self.CurrentCardUsesHP then
					self.CurrentCardCost = self.CurrentCardCost /2
				end
				self:SetNW2Int("SpecialAttackCost",self.CurrentCardCost)
			end
		end
		if self.User:IsPlayer() then
			self:PersonaCards(self.User:KeyDown(IN_ATTACK),self.User:KeyDown(IN_ATTACK2),self.User:KeyDown(IN_RELOAD))
			self:PersonaControls(self.User,self)
		elseif self.User:IsNPC() then
			if IsValid(self.User:GetEnemy()) then
				self.User.Persona_EyeTarget = self.User:GetEnemy()
			end
			self:PersonaThink_NPC(self.User,self)
		end
		self:DefaultPersonaControls(self.User,self)
		self:OnThink(self.User)
	else
		self:Remove()
	end
	return true
end
---------------------------------------------------------------------------------------------------------------------------------------------
function ENT:RequestAura(ply,aura)
	self:StopParticles()
	self:EmitSound("cpthazama/persona5/misc/00118.wav",75,100)
	if self.IsLegendary then
		ParticleEffectAttach("persona_aura_yellow",PATTACH_POINT_FOLLOW,self,self:LookupAttachment("origin"))
	end
	-- ParticleEffectAttach(self.IsLegendary && "persona_aura_yellow" or aura,PATTACH_POINT_FOLLOW,self,self:LookupAttachment("origin"))
	ParticleEffectAttach(aura,PATTACH_POINT_FOLLOW,self,self:LookupAttachment("origin"))
	ParticleEffectAttach(aura == "persona_aura_red" && "vj_per_idle_chains_evil" or "vj_per_idle_chains",PATTACH_POINT_FOLLOW,self,self:LookupAttachment("origin"))
	ParticleEffectAttach(aura == "persona_aura_red" && "jojo_aura_red" or "jojo_aura_blue",PATTACH_POINT_FOLLOW,ply,ply:LookupAttachment("origin"))
	local fx = EffectData()
	fx:SetOrigin(self:GetIdlePosition(ply))
	fx:SetScale(80)
	util.Effect("JoJo_Summon",fx)
end
---------------------------------------------------------------------------------------------------------------------------------------------
function ENT:OnSummoned(ply)
	self:UserSound("cpthazama/persona5/joker/0" .. math.random(159,162) .. ".wav") // Override in your Persona!
end
---------------------------------------------------------------------------------------------------------------------------------------------
function ENT:OnRequestDisappear(ply)
	self:UserSound("cpthazama/persona5/joker/0" .. math.random(106,120) .. ".wav") // Override in your Persona!
end
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
	if name == nil then return end
	if req == nil || isHP == nil || icon == nil then
		local data = P_GETSKILL(name)
		if data.Name != "N/A" then
			req = data.Cost
			isHP = data.UsesHP
			icon = data.Icon
		else
			return
		end
	end
	self.CardTable[#self.CardTable +1] = {Name=name,Cost=req,UsesHP=isHP,Icon=(icon or "unknown")}

	self.Cards = self.Cards or {}
	self.Cards[name] = {}
	self.Cards[name].Cost = req
	self.Cards[name].UsesHP = isHP
	self.Cards[name].Icon = icon or "unknown"

	net.Start("Persona_UpdateCards")
		net.WriteEntity(self)
		net.WriteTable(self.CardTable)
	net.Broadcast()
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
function ENT:UnlockAllSkills()
	local lvl = 0
	if #self.LeveledSkills > 0 then
		for index,skill in pairs(self.LeveledSkills) do
			if skill.Name then
				self:AddCard(skill.Name,skill.Cost,skill.UsesHP,skill.Icon)
			end
		end
	end
end
---------------------------------------------------------------------------------------------------------------------------------------------
function ENT:SetMeleeCard(name,cost)
	self.CurrentMeleeSkill = name
	self.CurrentMeleeSkillCost = cost
end
---------------------------------------------------------------------------------------------------------------------------------------------
function ENT:CycleCards()
	local isTurn = self:IsMyTurn()
	if !isTurn then return end
	local index = self.CurrentCardID
	local finalIndex = index +1
	local target = self.CardTable[finalIndex]
	if finalIndex > #self.CardTable then
		target = self.CardTable[1]
		finalIndex = 1
	end
	
	self.User:EmitSound("cpthazama/persona5/misc/00042.wav",45)

	self:SetActiveCard(target.Name,target.Cost,target.UsesHP,target.Icon,finalIndex)
	self.NextCardSwitchT = CurTime() +0.15
end
---------------------------------------------------------------------------------------------------------------------------------------------
function ENT:SetActiveCard(name,cost,useHP,icon,index)
	cost = (!useHP && (IsValid(self.User) && self.User.Persona_ChaosT && self.User.Persona_ChaosT > CurTime())) && cost *2 or cost
	self:SetNW2String("SpecialAttack",name)
	self:SetNW2Int("SpecialAttackCost",cost)
	self:SetNW2Bool("SpecialAttackUsesHP",useHP or false)
	self:SetNW2String("SpecialAttackIcon",icon or "unknown")
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
		-- self:SetNW2String("SpecialAttack",name)
		-- self:SetNW2Int("SpecialAttackCost",self.Cards[name].Cost)
		-- self:SetNW2Bool("SpecialAttackUsesHP",self.Cards[name].UsesHP or false)
		-- self.CurrentCardCost = self.Cards[name].Cost
		-- self.CurrentCardUsesHP = self.Cards[name].UsesHP
	-- end
end
---------------------------------------------------------------------------------------------------------------------------------------------
function ENT:GetCard()
	return self:GetNW2String("SpecialAttack")
end
---------------------------------------------------------------------------------------------------------------------------------------------
function ENT:TakeSP(sp)
	if self.User:HasGodMode() then return end
	-- self.User:SetSP(math.Clamp(self.User:GetSP() -sp,0,self.User:IsPlayer() && 999 or 9999))
	self.User:SetSP(math.Clamp(self.User:GetSP() -sp,0,self.User:GetMaxSP()))
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
	tracedata.endpos = self.User:IsNPC() && (IsValid(self.User:GetEnemy()) && self.User:GetEnemy():GetPos() or self.User:EyePos() +self.User:EyeAngles():Forward() *5000) or self.User:GetEyeTrace().HitPos
	tracedata.filter = {self.User,self}
	local tr = util.TraceLine(tracedata)

	return tr
end
---------------------------------------------------------------------------------------------------------------------------------------------
function ENT:FindTarget(ply)
	-- if ply:IsPlayer() then
		-- local tracedata = {}
		-- tracedata.start = ply:EyePos()
		-- tracedata.endpos = ply:GetEyeTrace().HitPos
		-- tracedata.filter = {ply,self}
		-- local tr = util.TraceLine(tracedata)
		-- local ent = tr.Entity
	-- else
		-- ent = ply:GetEnemy()
	-- end
	
	-- ply.Persona_EyeTarget = IsValid(ent) && (ent:IsNPC() or ent:IsPlayer()) && ent
	-- self.Target = IsValid(ent) && (ent:IsNPC() or ent:IsPlayer()) && ent
end
---------------------------------------------------------------------------------------------------------------------------------------------
function ENT:FaceTarget()
	if IsValid(self.User.Persona_EyeTarget) then
		local ang = self:GetAngles()
		self:SetAngles(Angle(ang.x,(self.User.Persona_EyeTarget:GetPos() -self:GetPos()):Angle().y,ang.z))
	end
end
---------------------------------------------------------------------------------------------------------------------------------------------
function ENT:FacePlayerAim(ply)
	if IsValid(ply.Persona_EyeTarget) then
		local ang = self:GetAngles()
		self:SetAngles(Angle(ang.x,(ply.Persona_EyeTarget:GetPos() -self:GetPos()):Angle().y,ang.z))
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
	if !IsValid(self.User) then return dmg end
	dmg = self.User.Persona_TarukajaT > CurTime() && dmg *1.25 or dmg
	dmg = self.User.Persona_TarundaT > CurTime() && dmg *0.5 or dmg
	dmg = self.User.Persona_DebilitateT > CurTime() && dmg *0.5 or dmg
	dmg = self.User.Persona_HeatRiserT > CurTime() && dmg *1.5 or dmg
	dmg = self.User.Persona_ChaosT > CurTime() && dmg *3 or dmg
	dmg = self:GetCritical() && dmg *1.25 or dmg
	dmg = self.HasOverdrive && dmg *1.25 or dmg
	if type == 1 then -- Physical
		dmg = self.User.Persona_ChargedT > CurTime() && dmg *2 or dmg
		dmg = (dmg *self.Stats.STR) /6
	elseif type == 2 then -- Magic
		dmg = self.User.Persona_FocusedT > CurTime() && dmg *2 or dmg
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
	local user = self.User
	local checkPlayers = true
	if (user:IsNPC() && GetConVarNumber("ai_ignoreplayers") == 1) then
		checkPlayers = false
	end
	if FindEnts != nil then
		for _,v in pairs(FindEnts) do
			if (v != self && v != user) && ((v:IsNPC() or (checkPlayers == true && v:IsPlayer() && v:Alive()))) then
				if self.User:IsNPC() && self.User:Disposition(v) == 3 then
					continue
				end
				if self.User:IsPlayer() && v:IsNPC() && VJ_HasValue(self.User:GetParty_NPC(),v) then
					continue
				end
				if self.User:IsPlayer() && v:IsPlayer() && VJ_HasValue(self.User:GetParty(),v:UniqueID()) then
					continue
				end
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
	doactualdmg:SetAttacker(IsValid(self.User) && self.User or self)
	doactualdmg:SetDamagePosition(ent:NearestPoint(self:GetAttackPosition()))
	ent:TakeDamageInfo(doactualdmg,IsValid(self.User) && self.User or self)
	if ent:IsPlayer() then
		ent:ViewPunch(Angle(math.random(-1,1) *dmg,math.random(-1,1) *dmg,math.random(-1,1) *dmg))
	end

	if type != 2 then
		local effectdata = EffectData()
		effectdata:SetOrigin(ent:NearestPoint(self:GetAttackPosition()))
		effectdata:SetScale(math.Clamp(dmg /3,20,300))
		util.Effect("Persona_Hit_Cut",effectdata)
	end
end
---------------------------------------------------------------------------------------------------------------------------------------------
function ENT:MeleeAttackCode(dmg,dmgdist,rad,snd,inflict,inflictT)
	local AttackDist = dmgdist
	local attackPos = self:GetAttackPosition()
	local FindEnts = ents.FindInSphere(attackPos,AttackDist)
	local hitentity = false
	local hitEnts = {}
	local snd = snd or true
	local doactualdmg = DamageInfo()
	local agility = self.Stats.AGI
	dmg = self:AdditionalInput(dmg,1)
	local checkPlayers = true
	if (self.User:IsNPC() && GetConVarNumber("ai_ignoreplayers") == 1) then
		checkPlayers = false
	end
	inflict = inflict or false
	inflictT = inflictT or 1
	if FindEnts != nil then
		for _,v in pairs(FindEnts) do
			if (v != self && v != self.User) && (((v:IsNPC() or (checkPlayers && v:IsPlayer() && v:Alive()))) or v:IsNextBot() or v:GetClass() == "func_breakable_surf" or v:GetClass() == "prop_physics") then
				if (self:GetForward():Dot((Vector(v:GetPos().x,v:GetPos().y,0) - Vector(self:GetPos().x,self:GetPos().y,0)):GetNormalized()) > math.cos(math.rad(rad))) then
					if self.User:IsNPC() && self.User:Disposition(v) == 3 then
						continue
					end
					if self.User:IsPlayer() && v:IsNPC() && VJ_HasValue(self.User:GetParty_NPC(),v) then
						continue
					end
					if self.User:IsPlayer() && v:IsPlayer() && VJ_HasValue(self.User:GetParty(),v:UniqueID()) then
						continue
					end
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
					
					if inflict then
						if inflict == "Fear" then
							self:Fear(v,inflictT)
						elseif inflict == "Curse" then
							self:Curse(v,inflictT,5)
						end
					end

					local effectdata = EffectData()
					effectdata:SetOrigin(v:NearestPoint(attackPos))
					effectdata:SetScale(math.Clamp(dmg /3,20,300))
					util.Effect("Persona_Hit_Cut",effectdata)

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
	self:OnRunDamageCode(doactualdmg,attackPos,hitEnts)
	return hitEnts
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
	local level = ent:GetNW2Int("PXP_Level")
	local exp = ent:GetNW2Int("PXP_EXP")
	
	PXP.GiveEXP(ply,exp)
	PXP.GivePlayerEXP(ply,exp)
end
---------------------------------------------------------------------------------------------------------------------------------------------
function ENT:BrainWash(ent,min,max)
	if !IsValid(ent) then return end
	local ply = self.User

	local spawnparticle = ents.Create("info_particle_system")
	spawnparticle:SetKeyValue("effect_name","vj_per_skill_brainwash")
	spawnparticle:SetPos(ent:GetPos() +ent:OBBCenter())
	spawnparticle:Spawn()
	spawnparticle:Activate()
	spawnparticle:Fire("Start","",0)
	spawnparticle:Fire("SetParent",ent:GetName())

	ent:EmitSound("cpthazama/persona5/skills/0096.wav",80)

	timer.Simple(1.25,function()
		if IsValid(ent) && IsValid(self) then
			if math.random(1,max) <= min && !ent.Persona_BrainWashed then
				spawnparticle:Fire("Kill","",0.1)
				if ent:IsNPC() && ent:Disposition(ply) != D_LI then
					ent:AddEntityRelationship(ply,D_LI,99)
					ent.Persona_BrainWashed = true
					ent.P_VJ_NPC_Class = ent.VJ_NPC_Class
					local oldVal = ent.PlayerFriendly
					local oldValB = ent.FriendsWithAllPlayerAllies
					ent.PlayerFriendly = true
					ent.FriendsWithAllPlayerAllies = true
					ent.VJ_NPC_Class = ply.VJ_NPC_Class or {"CLASS_PLAYER_ALLY"}
					if ent.VJ_AddCertainEntityAsFriendly then table.insert(ent.VJ_AddCertainEntityAsFriendly,ply) end
					timer.Simple(20,function()
						if IsValid(ent) then
							ent.Persona_BrainWashed = false
							if IsValid(ply) then
								for i,v in pairs(ent.VJ_AddCertainEntityAsFriendly) do
									if v == ply then table.remove(ent.VJ_AddCertainEntityAsFriendly,i) end
								end
								ply:ChatPrint(ent:IsNPC() && (ent.PrintName != nil && ent.PrintName or "target") .. " is no longer brainwashed!")
							end
							ent.PlayerFriendly = oldVal
							ent.FriendsWithAllPlayerAllies = oldValB
							ent.VJ_NPC_Class = ent.P_VJ_NPC_Class
						end
					end)
				elseif ent:IsPlayer() && !ent.Persona_BrainWashed && ent:Alive() then
					ent.Persona_BrainWashed = true
					ent.Persona_BrainWashers = ent.Persona_BrainWashers or {}
					table.insert(ent.Persona_BrainWashers,ply)
					timer.Simple(20,function()
						if IsValid(ent) then
							ent.Persona_BrainWashed = false
							if IsValid(ply) then
								for i,v in pairs(ent.Persona_BrainWashers) do
									if v == ply then table.remove(ent.Persona_BrainWashers,i) end
								end
								ply:ChatPrint(ent:Nick() .. " is no longer brainwashed!")
							end
						end
					end)
				end
				ply:ChatPrint("Successfully brainwashed " .. (ent:IsPlayer() && ent:Nick() or ent:IsNPC() && (ent.PrintName != nil && ent.PrintName or "target")) .. "!")
			else
				ply:ChatPrint("Missed!")
			end
		end
	end)
end
---------------------------------------------------------------------------------------------------------------------------------------------
function ENT:IceEffect(ent,dmg,scale)
	local dmg = dmg or DMG_P_HEAVY
	local snds = {
		[DMG_P_MINISCULE] = "cpthazama/persona5/skills/0020.wav",
		[DMG_P_LIGHT] = "cpthazama/persona5/skills/0020.wav",
		[DMG_P_MEDIUM] = "cpthazama/persona5/skills/0021.wav",
		[DMG_P_HEAVY] = "cpthazama/persona5/skills/0021.wav",
		[DMG_P_SEVERE] = "cpthazama/persona5/skills/0022.wav",
		[DMG_P_COLOSSAL] = "cpthazama/persona5/skills/0022.wav",
	}
	local scale = scale or 1
	local m = ents.Create("prop_vj_animatable")
	m:SetModel("models/cpthazama/persona5/effects/ice.mdl")
	m:SetPos(ent:GetPos() +Vector(0,0,-15))
	m:Spawn()
	m:SetParent(ent)
	m:DrawShadow(false)
	-- m:SetCollisionGroup(COLLISION_GROUP_IN_VEHICLE)
	m:ResetSequence("idle")
	m:SetModelScale((ent:OBBMaxs().z *0.0175) *scale,0.25)
	m:EmitSound(snds[dmg] or "cpthazama/persona5/skills/0021.wav",80)
	timer.Simple(0.85,function()
		if IsValid(ent) && IsValid(self) then
			if math.random(1,4) == 1 then
				-- ent:SetFrozen(20) -- No code for this yet!
				if IsValid(self.User) && self.User:IsPlayer() then
					self.User:ChatPrint("Inflicted Freeze!")
				end
			end
			ent:EmitSound("cpthazama/persona5/skills/0210.wav",75)
			self:DealDamage(ent,dmg,DMG_P_ICE,2)
		end
	end)
	timer.Simple(1,function()
		if IsValid(m) then
			SafeRemoveEntity(m)
		end
	end)
end
---------------------------------------------------------------------------------------------------------------------------------------------
function ENT:AgiEffect(ent,dmg,scale,extraFX)
	-- if self.User:IsPlayer() && ent:IsPlayer() && VJ_HasValue(self.User:GetParty(),ent:UniqueID()) then
		-- continue
	-- end
	local dmg = dmg or DMG_P_HEAVY
	local scale = scale or 1
	local m = ents.Create("prop_vj_animatable")
	m:SetModel("models/cpthazama/persona5/effects/agi.mdl")
	m:SetPos(ent:GetPos())
	m:Spawn()
	m:SetParent(ent)
	m:DrawShadow(false)
	m:SetCollisionGroup(COLLISION_GROUP_IN_VEHICLE)
	m:ResetSequence("idle")
	m:SetModelScale((ent:OBBMaxs().z *0.03) *scale,1)
	m:EmitSound("ambient/fire/ignite.wav",80)
	if extraFX then
		local e = ents.Create("prop_vj_animatable")
		e:SetModel("models/cpthazama/persona5/effects/agi_lava.mdl")
		e:SetPos(ent:GetPos())
		e:Spawn()
		e:SetParent(ent)
		e:DrawShadow(false)
		e:SetCollisionGroup(COLLISION_GROUP_IN_VEHICLE)
		e:ResetSequence("idle")
		m:DeleteOnRemove(e)
		-- e:SetModelScale((ent:OBBMaxs().z *0.03) *scale,1)
	end
	timer.Simple(1,function()
		if IsValid(m) then
			m:EmitSound("cpthazama/persona5/skills/0015.wav",95)
		end
	end)
	timer.Simple(2,function()
		if IsValid(ent) && IsValid(self) then
			if math.random(1,4) == 1 then
				ent:Ignite(20)
				if IsValid(self.User) && self.User:IsPlayer() then
					self.User:ChatPrint("Inflicted Burn!")
				end
			end
			ent:EmitSound("cpthazama/persona5/skills/0011.wav",75)
			self:DealDamage(ent,dmg,DMG_P_FIRE,2)
		end
	end)
	timer.Simple(3,function()
		SafeRemoveEntity(m)
		SafeRemoveEntity(e)
	end)
end
---------------------------------------------------------------------------------------------------------------------------------------------
function ENT:NuclearEffect(ent,dmg,t,sc)
	local dmg = dmg or DMG_P_SEVERE
	local scale = sc or 2.5
	local time = t or 1
	time = math.Clamp(time,0.55,time)
	local m = ents.Create("prop_vj_animatable")
	m:SetModel("models/cpthazama/persona5/effects/megidolaon.mdl")
	m:SetPos(ent:GetPos() +Vector(0,0,15))
	m:Spawn()
	m:SetColor(Color(0,100,255))
	m:DrawShadow(false)
	m:SetCollisionGroup(COLLISION_GROUP_IN_VEHICLE)
	m:ResetSequence("idle")
	m:SetModelScale(scale,time)
	VJ_CreateSound(m,"cpthazama/persona5/skills/0338.wav",90)
	-- m:EmitSound("PERSONA_MEGIDOLAON")
	local Light = ents.Create("light_dynamic")
	Light:SetKeyValue("brightness","7")
	Light:SetKeyValue("distance",tostring(30 *scale))
	Light:SetPos(m:GetPos())
	Light:Fire("Color","0 100 255")
	Light:SetParent(m)
	Light:Spawn()
	Light:Activate()
	Light:Fire("TurnOn","",0)
	Light:Fire("TurnOff","",5)
	m:DeleteOnRemove(Light)
	-- timer.Simple(time -0.5,function()
		-- if IsValid(m) && IsValid(self) then
			-- local ents = self:FindEnemies(m:GetPos(),30 *scale)
			-- if ents != nil then
				-- for _,v in pairs(ents) do
					-- if IsValid(v) then
						-- local dmginfo = DamageInfo()
						-- dmginfo:SetDamage(IsValid(self) && self:AdditionalInput(dmg,2) or dmg)
						-- dmginfo:SetDamageType(DMG_P_NUCLEAR)
						-- dmginfo:SetInflictor(IsValid(self) && self or v)
						-- dmginfo:SetAttacker(IsValid(self) && IsValid(self.User) && self.User or v)
						-- dmginfo:SetDamagePosition(m:NearestPoint(v:GetPos() +v:OBBCenter()))
						-- v:TakeDamageInfo(dmginfo,IsValid(self) && IsValid(self.User) && self.User or v)
						-- v:EmitSound("cpthazama/persona5/skills/0014.wav",70)
					-- end
				-- end
			-- end
		-- end
	-- end)
	timer.Simple(time -0.5,function()
		if IsValid(ent) && IsValid(self) then
			local dmginfo = DamageInfo()
			dmginfo:SetDamage(IsValid(self) && self:AdditionalInput(dmg,2) or dmg)
			dmginfo:SetDamageType(DMG_P_NUCLEAR)
			dmginfo:SetInflictor(IsValid(self) && self or v)
			dmginfo:SetAttacker(IsValid(self) && IsValid(self.User) && self.User or ent)
			dmginfo:SetDamagePosition(m:NearestPoint(ent:GetPos() +ent:OBBCenter()))
			ent:TakeDamageInfo(dmginfo,IsValid(self) && IsValid(self.User) && self.User or ent)
			ent:EmitSound("cpthazama/persona5/skills/0230.wav",90)
		end
	end)
	timer.Simple(time,function()
		if IsValid(m) then
			SafeRemoveEntity(m)
		end
	end)
end
---------------------------------------------------------------------------------------------------------------------------------------------
function ENT:BlackViperEffect(ent,dmg)
	local dmg = dmg or DMG_P_SEVERE
	local scale = 20
	local function FX(ent)
		local spawnparticle = ents.Create("info_particle_system")
		spawnparticle:SetKeyValue("effect_name","vj_per_skill_viper_main")
		spawnparticle:SetPos(ent:GetPos() +ent:OBBCenter() +Vector(math.Rand(-200,200),math.Rand(-200,200),0))
		spawnparticle:Spawn()
		spawnparticle:Activate()
		spawnparticle:Fire("Start","",0)
		spawnparticle:Fire("Kill","",0.1)
	end
	VJ_CreateSound(ent,"cpthazama/persona5/skills/0180.wav",150)
	FX(ent)
	timer.Simple(0.75,function()
		if IsValid(self) && IsValid(ent) then
			if math.random(1,100) <= self.Stats.LUC && math.random(1,2) == 1 then self:DoCritical(2) end
			local m = ents.Create("prop_vj_animatable")
			m:SetModel("models/cpthazama/persona5/effects/black_viper.mdl")
			m:SetPos(ent:GetPos())
			m:Spawn()
			m:DrawShadow(false)
			m:SetCollisionGroup(COLLISION_GROUP_IN_VEHICLE)
			m:ResetSequence("bite")
			m:SetModelScale(scale)

			-- for i = 1,5 do
				-- timer.Simple(0.2 *i,function() if IsValid(ent) then FX(ent) end end)
			-- end
			timer.Simple(0.1,function() if IsValid(ent) then FX(ent) end end)

			timer.Simple(0.8,function()
				if IsValid(ent) && IsValid(self) then
					local dmginfo = DamageInfo()
					dmginfo:SetDamage(IsValid(self) && self:AdditionalInput(dmg,2) or dmg)
					dmginfo:SetDamageType(DMG_P_ALMIGHTY)
					dmginfo:SetInflictor(IsValid(self) && self or v)
					dmginfo:SetAttacker(IsValid(self) && IsValid(self.User) && self.User or ent)
					dmginfo:SetDamagePosition(m:NearestPoint(ent:GetPos() +ent:OBBCenter()))
					ent:TakeDamageInfo(dmginfo,IsValid(self) && IsValid(self.User) && self.User or ent)
				end
			end)
			timer.Simple(VJ_GetSequenceDuration(m,"bite"),function()
				if IsValid(m) then
					SafeRemoveEntity(m)
				end
			end)
		end
	end)
end
---------------------------------------------------------------------------------------------------------------------------------------------
function ENT:PsiEffect(ent,dmg,t,sc,cnt,sound)
	local dmg = dmg or DMG_P_SEVERE
	local tbl = {}
	local scale = sc or 1
	local count = cnt && math.Clamp(cnt,3,cnt) or 5
	local time = t or 3
	local snd = sound or "cpthazama/persona5/skills/0190.wav"
	time = math.Clamp(time,0.55,time)
	for i = 1,math.random(3,count) do
		local m = ents.Create("prop_vj_animatable")
		m:SetModel("models/cpthazama/persona5/effects/megidolaon.mdl")
		local cent = ent:GetPos() +ent:OBBCenter()
		local vec = VectorRand() *math.random(30,60) *i
		-- if vec.z < ent:GetPos().z then
			-- vec.z = cent.z
		-- end
		m:SetPos(cent +vec)
		m:SetAngles(Angle(math.random(0,360),math.random(0,360),math.random(0,360)))
		m:Spawn()
		m:SetParent(ent)
		m:SetModelScale(0.01,0)
		m:SetMaterial("models/cpthazama/persona_shared/psy")
		m:DrawShadow(false)
		m:SetCollisionGroup(COLLISION_GROUP_IN_VEHICLE)
		m:ResetSequence("idle")
		m:SetPlaybackRate(math.random(2,6))
		m:SetModelScale(scale,time /2)
		VJ_CreateSound(m,"cpthazama/persona5/skills/0190.wav",90)
		table.insert(tbl,m)
	end
	local spawnparticle = ents.Create("info_particle_system")
	spawnparticle:SetKeyValue("effect_name","vj_per_skill_psy")
	spawnparticle:SetPos(ent:GetPos())
	spawnparticle:Spawn()
	spawnparticle:Activate()
	spawnparticle:Fire("Start","",0)
	spawnparticle:Fire("SetParent",ent:GetName())
	timer.Simple(time *0.75,function()
		for _,m in pairs(tbl) do
			if IsValid(m) then
				m:SetModelScale(0.01,time *0.25)
				m:EmitSound(snd,90)
				spawnparticle:Fire("Kill","",0.1)
			end
		end
	end)
	timer.Simple(time -0.5,function()
		if IsValid(ent) && IsValid(self) then
			local dmginfo = DamageInfo()
			dmginfo:SetDamage(IsValid(self) && self:AdditionalInput(dmg,2) or dmg)
			dmginfo:SetDamageType(DMG_P_PSI)
			dmginfo:SetInflictor(IsValid(self) && self or v)
			dmginfo:SetAttacker(IsValid(self) && IsValid(self.User) && self.User or ent)
			dmginfo:SetDamagePosition(self:NearestPoint(ent:GetPos() +ent:OBBCenter()))
			ent:TakeDamageInfo(dmginfo,IsValid(self) && IsValid(self.User) && self.User or ent)
			ent:EmitSound("cpthazama/persona5/skills/0190.wav",90)
		end
	end)
	timer.Simple(time,function()
		for _,m in pairs(tbl) do
			if IsValid(m) then
				SafeRemoveEntity(m)
			end
		end
	end)
end
---------------------------------------------------------------------------------------------------------------------------------------------
function ENT:BlessAttack(ent,dmg,t,effect)
	local spawnparticle = ents.Create("info_particle_system")
	spawnparticle:SetKeyValue("effect_name",effect or "vj_per_skill_bless_small")
	spawnparticle:SetPos(ent:GetPos() +ent:OBBCenter())
	spawnparticle:Spawn()
	spawnparticle:Activate()
	spawnparticle:Fire("Start","",0)
	if t then
		spawnparticle:Fire("SetParent",ent:GetName())
	else
		spawnparticle:Fire("Kill","",0.1)
	end

	timer.Simple(t or 0,function()
		if IsValid(self) && IsValid(ent) then
			self:DealDamage(ent,dmg,DMG_P_BLESS,2)
			if t then
				spawnparticle:Fire("Kill","",0.1)
			end
		end
	end)
end
---------------------------------------------------------------------------------------------------------------------------------------------
function ENT:BlessEffect(ent,chance,effect)
	local spawnparticle = ents.Create("info_particle_system")
	spawnparticle:SetKeyValue("effect_name","vj_per_skill_bless_small_b")
	spawnparticle:SetPos(ent:GetPos() +ent:OBBCenter())
	spawnparticle:Spawn()
	spawnparticle:Activate()
	spawnparticle:Fire("Start","",0)
	spawnparticle:Fire("Kill","",0.1)

	local function FX(ent)
		local spawnparticle = ents.Create("info_particle_system")
		spawnparticle:SetKeyValue("effect_name","vj_per_skill_bless_small_b")
		spawnparticle:SetPos(ent:GetPos() +ent:OBBCenter())
		spawnparticle:Spawn()
		spawnparticle:Activate()
		spawnparticle:Fire("Start","",0)
		spawnparticle:Fire("Kill","",0.1)
	end

	for i = 1,18 do
		timer.Simple(0.1 *i,function() if IsValid(ent) then if i == 2 then ent:EmitSound("cpthazama/persona5/skills/0053.wav",80) end FX(ent) end end)
	end

	timer.Simple(2,function()
		if IsValid(ent) && IsValid(self) && math.random(1,chance) == 1 then
			local spawnparticle = ents.Create("info_particle_system")
			spawnparticle:SetKeyValue("effect_name",effect or "vj_per_skill_bless_small")
			spawnparticle:SetPos(ent:GetPos() +ent:OBBCenter())
			spawnparticle:Spawn()
			spawnparticle:Activate()
			spawnparticle:Fire("Start","",0)
			spawnparticle:Fire("Kill","",0.1)
			
			self:InstaKillDamage(ent,chance,DMG_P_BLESS)
		else
			if IsValid(self) then
				self.User:ChatPrint("Missed Target!")
			end
		end
	end)
end
---------------------------------------------------------------------------------------------------------------------------------------------
function ENT:InstaKillDamage(ent,chance,dmgtype)
	if math.random(1,chance) == 1 then
		ent:SetHealth(1)
		ent.GodMode = false
		if ent:IsPlayer() then
			ent:GodDisable()
		end
		self:DealDamage(ent,ent:GetMaxHealth() or ent:Health(),dmgtype or DMG_P_CURSE,2)
	end
end
---------------------------------------------------------------------------------------------------------------------------------------------
function ENT:MudoEffect(ent,chance,effect)
	local spawnparticle = ents.Create("info_particle_system")
	spawnparticle:SetKeyValue("effect_name","vj_per_skill_curse_b_small")
	spawnparticle:SetPos(ent:GetPos() +ent:OBBCenter())
	spawnparticle:Spawn()
	spawnparticle:Activate()
	spawnparticle:Fire("Start","",0)
	spawnparticle:Fire("Kill","",0.1)
	ent:EmitSound("cpthazama/persona5/skills/0063.wav",80)
	
	local function FX(ent)
		local spawnparticle = ents.Create("info_particle_system")
		spawnparticle:SetKeyValue("effect_name","vj_per_skill_curse_b_small")
		spawnparticle:SetPos(ent:GetPos() +ent:OBBCenter())
		spawnparticle:Spawn()
		spawnparticle:Activate()
		spawnparticle:Fire("Start","",0)
		spawnparticle:Fire("Kill","",0.1)
	end

	timer.Simple(0.5,function() if IsValid(ent) then FX(ent) end end)
	timer.Simple(0.9,function() if IsValid(ent) then FX(ent) end end)
	timer.Simple(1.2,function() if IsValid(ent) then FX(ent) end end)

	timer.Simple(1.5,function()
		if IsValid(ent) && IsValid(self) && math.random(1,chance) == 1 then
			local spawnparticle = ents.Create("info_particle_system")
			spawnparticle:SetKeyValue("effect_name",effect or "vj_per_skill_curse_small")
			spawnparticle:SetPos(ent:GetPos() +ent:OBBCenter())
			spawnparticle:Spawn()
			spawnparticle:Activate()
			spawnparticle:Fire("Start","",0)
			spawnparticle:Fire("Kill","",0.1)

			self:InstaKillDamage(ent,chance,DMG_P_CURSE)
		else
			if IsValid(self) then
				self.User:ChatPrint("Missed Target!")
			end
		end
	end)
end
---------------------------------------------------------------------------------------------------------------------------------------------
function ENT:MegidolaonEffect(ent,dmg,time,scale)
	-- if self.User:IsPlayer() && ent:IsPlayer() && VJ_HasValue(self.User:GetParty(),ent:UniqueID()) then
		-- continue
	-- end
	local dmg = dmg or DMG_P_SEVERE
	local scale = scale or 60 -- 100
	local time = time or 5
	local m = ents.Create("prop_vj_animatable")
	m:SetModel("models/cpthazama/persona5/effects/megidolaon.mdl")
	m:SetPos(ent:GetPos() +Vector(0,0,15))
	m:Spawn()
	m:DrawShadow(false)
	m:SetCollisionGroup(COLLISION_GROUP_IN_VEHICLE)
	m:ResetSequence("idle")
	m:SetModelScale(scale,time)
	VJ_CreateSound(m,"cpthazama/persona5/skills/megidolaon.wav",150)
	-- m:EmitSound("PERSONA_MEGIDOLAON")
	local Light = ents.Create("light_dynamic")
	Light:SetKeyValue("brightness","7")
	Light:SetKeyValue("distance",tostring(30 *scale))
	Light:SetPos(m:GetPos())
	Light:Fire("Color","180 255 255")
	Light:SetParent(m)
	Light:Spawn()
	Light:Activate()
	Light:Fire("TurnOn","",0)
	Light:Fire("TurnOff","",5)
	m:DeleteOnRemove(Light)
	timer.Simple(time -0.5,function()
		if IsValid(m) && IsValid(self) then
			local ents = self:FindEnemies(m:GetPos(),30 *scale)
			if ents != nil then
				for _,v in pairs(ents) do
					if IsValid(v) then
						local dmginfo = DamageInfo()
						dmginfo:SetDamage(IsValid(self) && self:AdditionalInput(dmg,2) or dmg)
						dmginfo:SetDamageType(DMG_P_ALMIGHTY)
						dmginfo:SetInflictor(IsValid(self) && self or v)
						dmginfo:SetAttacker(IsValid(self) && IsValid(self.User) && self.User or v)
						dmginfo:SetDamagePosition(m:NearestPoint(v:GetPos() +v:OBBCenter()))
						v:TakeDamageInfo(dmginfo,IsValid(self) && IsValid(self.User) && self.User or v)
						v:EmitSound("cpthazama/persona5/skills/0014.wav",70)
					end
				end
			end
		end
	end)
	timer.Simple(time,function()
		if IsValid(m) then
			SafeRemoveEntity(m)
		end
	end)
end
---------------------------------------------------------------------------------------------------------------------------------------------
function ENT:ZioEffect(ent,dmg,eff) -- att,dist,eff,target
	-- if self.IzanagiType then
		-- self:ZioEffect_P4AU(att,dist,eff,target) -- As much as I love the P4AU styled Zio skills, it's too much of an annoyance to keep adding support for custom variations for specific Personae
		-- return
	-- end
	if self.IzanagiType then
		eff = self.Magatsu && "maziodyne_red" or "maziodyne_blue"
	end
	local dmg = dmg or DMG_P_HEAVY
	local snds = {
		[DMG_P_MINISCULE] = "cpthazama/persona5/skills/0040.wav",
		[DMG_P_LIGHT] = "cpthazama/persona5/skills/0040.wav",
		[DMG_P_MEDIUM] = "cpthazama/persona5/skills/0041.wav",
		[DMG_P_HEAVY] = "cpthazama/persona5/skills/0042.wav",
		[DMG_P_SEVERE] = "cpthazama/persona5/skills/0042.wav",
		[DMG_P_COLOSSAL] = "cpthazama/persona5/skills/0042.wav",
	}
	local timeDMG = dmg >= DMG_P_HEAVY && 1.65 or 0
	local pos = ent:GetPos()
	local dist = math.Clamp(ent:OBBMaxs().z *5,100,2500)
	-- local dist = ent:OBBMaxs().z *5
	local tr = util.TraceLine({
		start = pos,
		endpos = pos +Vector(0,0,dist),
		filter = {ent,self}
	})
	pos = tr.HitPos or pos +Vector(0,0,200)
	local m = ents.Create("prop_vj_animatable")
	m:SetModel("models/cpthazama/persona5/effects/ice.mdl")
	m:SetPos(pos)
	m:Spawn()
	m:SetNoDraw(true)
	m:DrawShadow(false)
	m:SetParent(ent)
	m:SetCollisionGroup(COLLISION_GROUP_IN_VEHICLE)
	m:SetModelScale(0.01)
	ent:EmitSound(snds[dmg] or "cpthazama/persona5/skills/0041.wav",95)
	if timeDMG > 0 then
		local quickMaths = timeDMG /8
		local base = math.Clamp(quickMaths,timeDMG < quickMaths && quickMaths or 0,timeDMG)
		for i = base,8 do
			timer.Simple(i *quickMaths,function()
				if IsValid(m) then
					local rand = VectorRand() *math.random(-10000,10000)
					-- rand.z = rand.z > m:GetPos() && rand.z /2 or rand.z
					local tr = util.TraceLine({
						start = m:GetPos(),
						endpos = m:GetPos() +rand,
						filter = m,
					})
					local spawnparticle = ents.Create("info_particle_system")
					spawnparticle:SetKeyValue("effect_name","maziodyne_default_impact_glow")
					spawnparticle:SetPos(m:GetPos())
					spawnparticle:Spawn()
					spawnparticle:Activate()
					spawnparticle:Fire("Start","",0)
					spawnparticle:Fire("Kill","",0.1)
					util.ParticleTracerEx(eff or "maziodyne_default",m:GetPos(),tr.HitPos,false,m:EntIndex(),0)
					local spawnparticle = ents.Create("info_particle_system")
					spawnparticle:SetKeyValue("effect_name","maziodyne_default_impact")
					spawnparticle:SetPos(tr.HitPos)
					spawnparticle:Spawn()
					spawnparticle:Activate()
					spawnparticle:Fire("Start","",0)
					spawnparticle:Fire("Kill","",0.1)
				end
			end)
		end
	end
	timer.Simple(timeDMG,function()
		if IsValid(ent) && IsValid(self) then
			if math.random(1,4) == 1 then
				-- ent:SetShock(20) -- No code for this yet!
				if IsValid(self.User) && self.User:IsPlayer() then
					self.User:ChatPrint("Inflicted Shock!")
				end
			end
			ent:EmitSound("cpthazama/persona5/skills/0040.wav",95)
			self:DealDamage(ent,dmg,bit.bor(DMG_P_ELEC,DMG_SHOCK),2)
			local spawnparticle = ents.Create("info_particle_system")
			spawnparticle:SetKeyValue("effect_name","maziodyne_default_impact_glow")
			spawnparticle:SetPos(m:GetPos())
			spawnparticle:Spawn()
			spawnparticle:Activate()
			spawnparticle:Fire("Start","",0)
			spawnparticle:Fire("Kill","",0.1)
			util.ParticleTracerEx(eff or "maziodyne_default",pos,ent:GetPos(),false,m:EntIndex(),0)
			local spawnparticle = ents.Create("info_particle_system")
			spawnparticle:SetKeyValue("effect_name","maziodyne_default_impact")
			spawnparticle:SetPos(ent:GetPos())
			spawnparticle:Spawn()
			spawnparticle:Activate()
			spawnparticle:Fire("Start","",0)
			spawnparticle:Fire("Kill","",0.1)
			SafeRemoveEntity(m)
		end
	end)
end
---------------------------------------------------------------------------------------------------------------------------------------------
function ENT:ZioEffect_P4AU(att,dist,eff,target)
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
	self:EmitSound("cpthazama/vo/adachi/elec_charge.wav",75)
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
function ENT:Confuse(ent,t)
	ent.Persona_ConfuseT = ent.Persona_ConfuseT or 0
	if ent.Persona_ConfuseT < CurTime() then
		ent.Persona_ConfuseT = CurTime() +t
		if self.User:IsPlayer() then self.User:ChatPrint("Inflicted Confusion!") end
		ParticleEffectAttach("persona_fx_dmg_death",PATTACH_POINT_FOLLOW,ent,ent:LookupAttachment("origin"))
		local hookName = "Persona_ConfuseThink_" .. ent:EntIndex()
		hook.Add("Think",hookName,function()
			if !IsValid(ent) then
				hook.Remove("Think",hookName)
				return
			end
			if CurTime() > ent.Persona_ConfuseT || ent:Health() <= 0 || (ent:IsPlayer() && !ent:Alive()) then
				ent:StopParticles()
				hook.Remove("Think",hookName)
				return
			end
			local persona = ent:GetPersona()
			if IsValid(persona) then
				SafeRemoveEntity(persona)
			end
		end)
	end
end
---------------------------------------------------------------------------------------------------------------------------------------------
function ENT:Curse(ent,t,dmg)
	ent.Persona_CurseT = ent.Persona_CurseT or 0
	if ent.Persona_CurseT < CurTime() then
		ent.Persona_CurseT = CurTime() +t
		ent.Persona_CurseDMGT = CurTime() +(t < 1 && 0 or 1)
		if self.User:IsPlayer() then self.User:ChatPrint("Inflicted Curse!") end
		ParticleEffectAttach("persona_fx_dmg_fear",PATTACH_POINT_FOLLOW,ent,ent:LookupAttachment("origin"))
		local hookName = "Persona_CurseThink_" .. ent:EntIndex()
		hook.Add("Think",hookName,function()
			if !IsValid(ent) then
				hook.Remove("Think",hookName)
				return
			end
			if CurTime() > ent.Persona_CurseT || ent:Health() <= 0 || (ent:IsPlayer() && !ent:Alive()) then
				ent:StopParticles()
				hook.Remove("Think",hookName)
				return
			end
			if CurTime() > ent.Persona_CurseDMGT then
				local dmginfo = DamageInfo()
				dmginfo:SetDamage(dmg)
				dmginfo:SetDamageType(DMG_P_CURSE)
				dmginfo:SetDamagePosition(ent:GetPos() +ent:OBBCenter())
				dmginfo:SetInflictor(IsValid(self) && self or ent)
				dmginfo:SetAttacker(IsValid(self) && IsValid(self.User) && self.User or ent)
				ent:TakeDamageInfo(dmginfo,IsValid(self) && IsValid(self.User) && self.User or ent)
				ent.Persona_CurseDMGT = CurTime() +1
			end
		end)
	end
end
---------------------------------------------------------------------------------------------------------------------------------------------
function ENT:Fear(ent,t)
	ent.Persona_FearT = ent.Persona_FearT or 0
	if ent.Persona_FearT < CurTime() then
		ent.Persona_FearT = CurTime() +t
		if self.User:IsPlayer() then self.User:ChatPrint("Inflicted Fear!") end
		-- ent:EmitSound("cpthazama/vo/adachi/curse.wav",80)
		ParticleEffectAttach("persona_fx_dmg_fear",PATTACH_POINT_FOLLOW,ent,ent:LookupAttachment("origin"))
		local hookName = "Persona_FearThink_" .. ent:EntIndex()
		local user = self.User
		local prevDisp = (ent:IsNPC() && IsValid(user) && ent:Disposition(user) != D_FR && ent:Disposition(user) or D_NU) or false
		hook.Add("Think",hookName,function()
			if !IsValid(ent) then
				hook.Remove("Think",hookName)
				return
			end
			if IsValid(ent) && ent:Health() <= 0 then
				hook.Remove("Think",hookName)
				return
			end
			if CurTime() > ent.Persona_FearT || ent:Health() <= 0 || (ent:IsPlayer() && !ent:Alive()) then
				ent:StopParticles()
				if IsValid(user) && ent:IsNPC() then ent:AddEntityRelationship(user,prevDisp,99) end
				hook.Remove("Think",hookName)
				return
			end
			if !IsValid(user) then return end
			if ent:IsNPC() then
				ent:AddEntityRelationship(user,D_FR,99)
				if IsValid(ent:GetEnemy()) && ent:GetEnemy() == user then
					ent:SetEnemy(NULL)
				end
			end
		end)
	end
end
---------------------------------------------------------------------------------------------------------------------------------------------
hook.Add("OnNPCKilled","Persona_NPCKilled",function(ent,killer,weapon)
	if IsValid(killer) && killer:IsPlayer() then
		local persona = killer:GetPersona()
		if IsValid(persona) then
			persona:OnKilledEnemy(ent)
			persona:OnKilledEnemy_EXP(ent)
		end
	end
end)
---------------------------------------------------------------------------------------------------------------------------------------------
hook.Add("PlayerDeath","Persona_PlayerKilled",function(ent,killer,weapon)
	if IsValid(killer) && killer:IsPlayer() && killer != ent then
		local persona = killer:GetPersona()
		if IsValid(persona) then
			persona:OnKilledEnemy(ent)
			persona:OnKilledEnemy_EXP(ent)
		end
	end
end)
---------------------------------------------------------------------------------------------------------------------------------------------
function ENT:UpdateStats()
	local add = PXP.IsLegendary(self.User) && 2 or 1
	self.Stats.STR = self.Stats.STR +add
	self.Stats.MAG = self.Stats.MAG +add
	self.Stats.END = self.Stats.END +add
	self.Stats.AGI = self.Stats.AGI +add
	self.Stats.LUC = self.Stats.LUC +add
	PXP.SavePersonaStats(self.User)
end
---------------------------------------------------------------------------------------------------------------------------------------------
function ENT:WhenRemoved() end
---------------------------------------------------------------------------------------------------------------------------------------------
function ENT:OnRemove()
	if IsValid(self.User) then
		self.User:SetNW2Bool("Persona_SkillMenu",false)
		self.User:SetNW2Vector("Persona_CustomPos",Vector(0,0,0))
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
	if self.OverdriveAura then self.OverdriveAura:Stop() end
	self:StopParticles()
	if IsValid(self.User) && self.User:IsNPC() && self.User.OnDisablePersona then
		self.User:OnDisablePersona(self)
		if self.User.UpdateCamera then
			self.User:UpdateCamera(1)
		end
	end
	self:WhenRemoved()
	if self.Loops then
		for _,v in pairs(self.Loops) do
			if v then
				v:Stop()
			end
		end
	end
end