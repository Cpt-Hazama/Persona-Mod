AddCSLuaFile("shared.lua")
include('shared.lua')
/*-----------------------------------------------
	*** Copyright (c) 2012-2019 by Cpt. Hazama, All rights reserved. ***
	No parts of this code or any of its contents may be reproduced, copied, modified or adapted,
	without the prior written consent of the author, unless otherwise indicated for stand-alone materials.
-----------------------------------------------*/
ENT.HasMeleeAttack = true
ENT.MeleeAttackDamage = 0

-- ENT.ConstantlyFaceEnemy = false
ENT.NoChaseAfterCertainRange = false

ENT.BloodColor = "Oil"

ENT.Animations = {}
ENT.Animations["idle"] = ACT_IDLE
ENT.Animations["walk"] = ACT_WALK
ENT.Animations["run"] = ACT_RUN
ENT.Animations["melee"] = ACT_MELEE_ATTACK1

//cpthazama/persona5/misc/00055.wav -- Alarm
//cpthazama/persona5/misc/00056.wav -- Transform
//cpthazama/persona5/misc/00057.wav -- Combat Start
---------------------------------------------------------------------------------------------------------------------------------------------
function ENT:CustomOnInvestigate(argent)
	self:SetState(VJ_STATE_ONLY_ANIMATION)
	local t = VJ_GetSequenceDuration(self,"notice")
	self:VJ_ACT_PLAYACTIVITY("notice",true,false,true)
	self.SightAngle = 180
	timer.Simple(t,function()
		if IsValid(self) then
			self:SetState()
			self.SightAngle = 80
		end
	end)
end
---------------------------------------------------------------------------------------------------------------------------------------------
function ENT:CustomOnMeleeAttack_AfterChecks(TheHitEntity)
	self:Transform()
	if IsPersonaGamemode() then
		if PGM().StartBattle then
			local tbl = {TheHitEntity}
			if TheHitEntity:IsPlayer() then
				local party = TheHitEntity:GetFullParty()
				if #party > 0 then
					for _,v in pairs(party) do
						table.insert(tbl,v)
					end
				end
			end
			PGM():StartBattle(tbl,{self})
		end
	end
	return false
end
---------------------------------------------------------------------------------------------------------------------------------------------
function ENT:CustomOnAlert(argent)
	sound.Play("cpthazama/persona5/misc/00055.wav",argent:GetPos(),85)
end
---------------------------------------------------------------------------------------------------------------------------------------------
function ENT:CustomOnTakeDamage_BeforeDamage(dmginfo,hitgroup)
	local dmg = dmginfo:GetDamage()
	local dmgtype = dmginfo:GetDamageType()
end
---------------------------------------------------------------------------------------------------------------------------------------------
function ENT:CustomOnTakeDamage_OnBleed(dmginfo,hitgroup)
	if !IsValid(self:GetPersona()) then
		self:Transform(true,dmginfo:GetAttacker())
	end
end
---------------------------------------------------------------------------------------------------------------------------------------------
function ENT:BeforeInit() end
---------------------------------------------------------------------------------------------------------------------------------------------
function ENT:CustomOnInitialize()
	self:BeforeInit()
	self:SetHealth((GetConVarNumber("vj_npc_allhealth") > 0) and GetConVarNumber("vj_npc_allhealth") or self:VJ_GetDifficultyValue(self.Stats.HP))
	self.SP = self.Stats.SP
	
	self.MetaVerseMode = false

	self.NextMetaChangeT = 0
	self.NextNumChangeT = 0
	
	self:CapabilitiesAdd(bit.bor(CAP_OPEN_DOORS))
	self:CapabilitiesAdd(bit.bor(CAP_AUTO_DOORS))
	self:CapabilitiesAdd(bit.bor(CAP_USE))
	
	self:SetSP(self.Stats.SP)
	self:SetMaxSP(self.Stats.SP)
	
	if IsPersonaGamemode() then
		self.SightDistance = 720
	end

	self:PersonaInit()
end
---------------------------------------------------------------------------------------------------------------------------------------------
function ENT:OnPersonaAnimation(persona,skill,animBlock,seq,t)
	local myAnim = self.Animations[animBlock]
	self:OnAnimEvent(persona,skill,animBlock,seq,t)
	if animBlock == "melee" then
		self:StopMoving()
	end
	if animBlock == "range_start" then
		self:StopMoving()
	end
	if animBlock == "range_start_idle" then
		self:StopMoving()
	end
	if animBlock == "range" then
		self:StopMoving()
	end
	if animBlock == "range_idle" then
		self:StopMoving()
	end
	if animBlock == "range_end" then
		self:StopMoving()
	end
end
---------------------------------------------------------------------------------------------------------------------------------------------
function ENT:PersonaThink(persona,enemy,dist,controlled)
	if !IsValid(enemy) then return end
	if !self:Visible(enemy) then return end
	if math.random(1,10) == 1 then
		persona:CycleCards()
	end
	if dist <= self.FarAttackDistance && dist >= self.CloseAttackDistance -100 && math.random(1,4) == 1 then
		persona:DoSpecialAttack(self,persona,nil,true)
	elseif dist < self.CloseAttackDistance && math.random(1,6) == 1 then
		persona:DoMeleeAttack(self,persona,persona.CurrentMeleeSkill,true)
	end
end
---------------------------------------------------------------------------------------------------------------------------------------------
function ENT:OnThink() end
---------------------------------------------------------------------------------------------------------------------------------------------
function ENT:OnSwitchMetaVerse(didSwitch) end
---------------------------------------------------------------------------------------------------------------------------------------------
function ENT:OnSummonPersona(persona)
	self:SetHealth(math.Clamp((self.Stats.HP /3) *((persona.Stats && persona.Stats.LVL) or 1),1,999))
	self:SetMaxHealth(self:Health())

	local spawnparticle = ents.Create("info_particle_system")
	spawnparticle:SetKeyValue("effect_name","vj_per_skill_curse_e")
	spawnparticle:SetPos(self:GetPos() +self:OBBCenter())
	spawnparticle:Spawn()
	spawnparticle:Activate()
	spawnparticle:Fire("Start","",0)
	spawnparticle:Fire("Kill","",1)
end
---------------------------------------------------------------------------------------------------------------------------------------------
function ENT:OnDisablePersona(persona)
	
end
---------------------------------------------------------------------------------------------------------------------------------------------
function ENT:PersonaCode()
	if self.MetaVerseMode && self:Health() > 0 then
		if !IsValid(self:GetPersona()) then
			if IsValid(self:GetEnemy()) then
				self:SummonPersona(self.Persona)
			end
		elseif IsValid(self:GetPersona()) then
			if !IsValid(self:GetEnemy()) then
				self:SummonPersona(self.Persona)
			end
			self:PersonaThink(self:GetPersona(),self:GetEnemy(),self:VJ_GetNearestPointToEntityDistance(self:GetEnemy()))
		end
	end
end
---------------------------------------------------------------------------------------------------------------------------------------------
function ENT:HandleAnimations()
	self.CurrentIdle = self.Animations["idle"]
	self.CurrentWalk = self.Animations["walk"]
	self.CurrentRun = self.Animations["run"]

	if self:GetState() == 0 then
		self.AnimTbl_IdleStand = {self.CurrentIdle}
		self.AnimTbl_Walk = {self.CurrentWalk}
		self.AnimTbl_Run = {self.CurrentRun}
	end
end
---------------------------------------------------------------------------------------------------------------------------------------------
function ENT:Transform(bForce,bEntity)
	if self:GetState() != 0 then return end
	if CurTime() > self.NextMetaChangeT then
		local t = VJ_GetSequenceDuration(self,"transform")
		self:VJ_ACT_PLAYACTIVITY("transform",true,false,true)
		VJ_CreateSound(self,"cpthazama/persona5/misc/00056.wav",85)
		timer.Simple(t,function()
			if IsValid(self) then
				self.MetaVerseMode = true
				self:OnSwitchMetaVerse(true)
				if bForce then
					self:SetEnemy(bEntity)
					self:SummonPersona(self.Persona)
				end
			end
		end)
		self.NextMetaChangeT = CurTime() +t +0.1
	end
end
---------------------------------------------------------------------------------------------------------------------------------------------
function ENT:LevelCode()
	if IsValid(self:GetPersona()) then
		self:SetNW2Int("PXP_Level",self.Level or self:GetPersona().Stats.LVL)
	end
end
---------------------------------------------------------------------------------------------------------------------------------------------
function ENT:CustomOnThink()
	self:HandleAnimations()
	self:LevelCode()

	self.DisableChasingEnemy = IsValid(self:GetPersona())

	if IsValid(self:GetEnemy()) then
		if self.MetaVerseMode == false then
			if CurTime() > self.NextMetaChangeT then
				-- self:Transform()
			end
		else
			-- self.NextMetaChangeT = CurTime() +1
		end
	else
		if self.MetaVerseMode then
			if CurTime() > self.NextMetaChangeT then
				self.MetaVerseMode = false
				self.NextMetaChangeT = CurTime() +1
				self:OnSwitchMetaVerse(false)
			end
		else
			-- self.NextMetaChangeT = CurTime() +1
		end
	end
	
	self.HasMeleeAttack = !IsValid(self:GetPersona())
	if IsValid(self:GetPersona()) then
		self:SetNoDraw(true)
		self:SetPos(self:GetPersona():GetPos())
		-- self:SetPos(self:GetPersona():GetPos() +self:GetPersona():OBBCenter())
		-- self:SetParent(self:GetPersona())
	else
		-- self:SetParent(NULL)
		self:SetNoDraw(false)
	end
	
	self:PersonaCode()
	self:OnThink()
end
---------------------------------------------------------------------------------------------------------------------------------------------
function ENT:CustomOnDeath_AfterCorpseSpawned(dmginfo,hitgroup,GetCorpse)
	GetCorpse:Remove()
end
/*-----------------------------------------------
	*** Copyright (c) 2012-2019 by Cpt. Hazama, All rights reserved. ***
	No parts of this code or any of its contents may be reproduced, copied, modified or adapted,
	without the prior written consent of the author, unless otherwise indicated for stand-alone materials.
-----------------------------------------------*/