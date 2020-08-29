AddCSLuaFile("shared.lua")
include('shared.lua')
/*-----------------------------------------------
	*** Copyright (c) 2012-2019 by Cpt. Hazama, All rights reserved. ***
	No parts of this code or any of its contents may be reproduced, copied, modified or adapted,
	without the prior written consent of the author, unless otherwise indicated for stand-alone materials.
-----------------------------------------------*/
ENT.Model = {} -- The game will pick a random model from the table when the SNPC is spawned | Add as many as you want 
ENT.Stats = {
	HP = 1,
	SP = 1,
	LVL = 1,
	STR = 1,
	MAG = 1,
	END = 1,
	AGI = 1,
	LUC = 1,
}
ENT.HullType = HULL_HUMAN
---------------------------------------------------------------------------------------------------------------------------------------------
ENT.VJ_NPC_Class = {}

ENT.BloodColor = "Red"

ENT.HasMeleeAttack = false

ENT.FarAttackDistance = 3500
ENT.CloseAttackDistance = 500

ENT.ConstantlyFaceEnemy = true
ENT.ConstantlyFaceEnemy_IfVisible = true
ENT.ConstantlyFaceEnemy_IfAttacking = false
ENT.ConstantlyFaceEnemy_Postures = "Standing"
ENT.NoChaseAfterCertainRange = true
ENT.NoChaseAfterCertainRange_CloseDistance = 0
ENT.NoChaseAfterCertainRange_Type = "Regular"

ENT.HasDeathAnimation = false
ENT.AnimTbl_Death = {ACT_DIESIMPLE}
ENT.DeathCorpseEntityClass = "prop_vj_animatable"
ENT.CanRespawn = false

ENT.SoundTbl_FootStep = {}
ENT.SoundTbl_CombatIdle = {}
ENT.SoundTbl_Pain = {}
ENT.SoundTbl_Death = {}
ENT.SoundTbl_OnKilledEnemy = {}
ENT.SoundTbl_Dodge = {}
ENT.SoundTbl_Persona = {}
ENT.SoundTbl_PersonaAttack = {}
ENT.SoundTbl_GetUp = {}

ENT.GeneralSoundPitch1 = 100

ENT.Animations = {}
ENT.Animations["idle"] = ACT_IDLE
ENT.Animations["idle_combat"] = ACT_IDLE_ANGRY
ENT.Animations["idle_low"] = ACT_IDLE_STIMULATED
ENT.Animations["walk"] = ACT_WALK
ENT.Animations["run"] = ACT_RUN
ENT.Animations["run_combat"] = ACT_RUN_STIMULATED
ENT.Animations["melee"] = "persona_attack"
ENT.Animations["range_start"] = "persona_attack_start"
ENT.Animations["range_start_idle"] = "persona_attack_start_idle"
ENT.Animations["range"] = "persona_attack"
ENT.Animations["range_idle"] = "persona_attack_idle"
ENT.Animations["range_end"] = "persona_attack_end"

ENT.Persona = "izanagi"
---------------------------------------------------------------------------------------------------------------------------------------------
function ENT:PersonaInit() end
---------------------------------------------------------------------------------------------------------------------------------------------
function ENT:CustomOnTakeDamage_BeforeDamage(dmginfo,hitgroup)
	local dmg = dmginfo:GetDamage()
	local dmgtype = dmginfo:GetDamageType()
	
	if dmginfo:GetDamage() > 0 then
		local canDodge = math.random(1,100) <= self.Stats.AGI
		if canDodge && self:BusyWithActivity() == false && math.random(1,2) == 1 then
			if self:LookupSequence("dodge") then
				self:VJ_ACT_PLAYACTIVITY("dodge",true,false,true)
				self:ResetLoopAnimation()
			end
			dmginfo:SetDamage(0)
		end
	end
end
---------------------------------------------------------------------------------------------------------------------------------------------
function ENT:CustomOnInitialize()
	self:SetHealth((GetConVarNumber("vj_npc_allhealth") > 0) and GetConVarNumber("vj_npc_allhealth") or self:VJ_GetDifficultyValue(self.Stats.HP))
	self.SP = self.Stats.SP
	
	self.HasDeathRagdoll = self.HasDeathAnimation
	
	self.MetaVerseMode = false
	self.NextMetaChangeT = 0

	self.NextUseT = 0

	self.MouthDistance = 0
	self.NextMouthMoveT = 0
	self.NextNumChangeT = 0
	
	self:CapabilitiesAdd(bit.bor(CAP_ANIMATEDFACE))
	self:CapabilitiesAdd(bit.bor(CAP_TURN_HEAD))
	self:CapabilitiesAdd(bit.bor(CAP_OPEN_DOORS))
	self:CapabilitiesAdd(bit.bor(CAP_AUTO_DOORS))
	self:CapabilitiesAdd(bit.bor(CAP_USE))
	
	self:SetSP(self.Stats.SP)
	self:SetMaxSP(self.Stats.SP)
	
	self:PersonaInit()
end
---------------------------------------------------------------------------------------------------------------------------------------------
function ENT:OnPlayCreateSound(SoundData,SoundFile)
	if !VJ_HasValue(self.SoundTbl_FootStep,SoundFile) then
		self.NextMouthMoveT = CurTime() +SoundDuration(SoundFile)
	end
end
---------------------------------------------------------------------------------------------------------------------------------------------
function ENT:CustomOnAcceptInput(key,activator,caller,data)
	if key == "step" then
		VJ_EmitSound(self,self.SoundTbl_FootStep,self.FootStepSoundLevel,self:VJ_DecideSoundPitch(self.FootStepPitch1,self.FootStepPitch2))
	elseif string.find(key,"melee") then
		local atk = string.Replace(key,"melee ","")
		self:MeleeAttackCode()
	end
end
---------------------------------------------------------------------------------------------------------------------------------------------
function ENT:StartLoopAnimation(anim)
	-- self.DisableChasingEnemy = true
	self:SetState(VJ_STATE_ONLY_ANIMATION)
	self.AnimTbl_IdleStand = {anim}
	self.NextIdleStandTime = 0
	self:StopMoving()
end
---------------------------------------------------------------------------------------------------------------------------------------------
function ENT:ResetLoopAnimation()
	self:SetState()
	self.AnimTbl_IdleStand = {self.CurrentIdle}
	self.NextIdleStandTime = 0
	-- self.DisableChasingEnemy = false
end
---------------------------------------------------------------------------------------------------------------------------------------------
function ENT:OnAnimEvent(persona,skill,animBlock,seq,t) end
---------------------------------------------------------------------------------------------------------------------------------------------
function ENT:OnPersonaAnimation(persona,skill,animBlock,seq,t)
	local myAnim = self.Animations[animBlock]
	self:OnAnimEvent(persona,skill,animBlock,seq,t)
	if animBlock == "melee" then
		local tStart = self:DecideAnimationLength(self.Animations["range_start"],false)
		local tMelee = self:DecideAnimationLength(self.Animations["melee"],false)
		self:SetState(VJ_STATE_ONLY_ANIMATION)
		self:VJ_ACT_PLAYACTIVITY(self.Animations["range_start"],true,false,true)
		timer.Simple(tStart,function()
			if IsValid(self) then
				self:StartLoopAnimation("range_idle")
				self:VJ_ACT_PLAYACTIVITY(myAnim,true,false,true)
				timer.Simple(tMelee,function()
					if IsValid(self) then
						self:SetState()
						self:VJ_ACT_PLAYACTIVITY(self.Animations["range_end"],true,false,true)
					end
				end)
			end
		end)
	end
	if animBlock == "range_start" then
		-- self.DisableChasingEnemy = true
		-- self:StopMoving()
		self:StartLoopAnimation("range_idle")
		self:VJ_ACT_PLAYACTIVITY(myAnim,true,false,true)
	end
	if animBlock == "range_start_idle" then
		self:VJ_ACT_PLAYACTIVITY(myAnim,true,false,true)
	end
	if animBlock == "range" then
		self:VJ_ACT_PLAYACTIVITY(myAnim,true,false,true)
	end
	if animBlock == "range_idle" then
		self:VJ_ACT_PLAYACTIVITY(myAnim,true,false,true)
	end
	if animBlock == "range_end" then
		self:ResetLoopAnimation()
		self:VJ_ACT_PLAYACTIVITY(myAnim,true,false,true)
	end
end
---------------------------------------------------------------------------------------------------------------------------------------------
function ENT:ControllerThink(controller,persona,enemy,dist) end
---------------------------------------------------------------------------------------------------------------------------------------------
function ENT:PersonaThink(persona,enemy,dist,controlled)
	if !IsValid(enemy) then return end
	if !self:Visible(enemy) then return end
	if controlled then
		local controller = self.VJ_TheController
		self:ControllerThink(controller,persona,enemy,dist)
		if controller:KeyDown(IN_RELOAD) then
			persona:CycleCards()
			return
		end
		if controller:KeyDown(IN_ATTACK) then
			persona:DoMeleeAttack(self,persona,persona.CurrentMeleeSkill,true)
			return
		end
		if controller:KeyDown(IN_ATTACK2) then
			persona:DoSpecialAttack(self,persona,nil,true)
			return
		end
		if controller:KeyDown(IN_DUCK) && !controller:KeyDown(IN_USE) then
			self:UseItem("item_persona_hp")
			return
		end
		return
	end
	if math.random(1,10) == 1 then
		persona:CycleCards()
	end
	if self:Health() <= self:GetMaxHealth() /2 && math.random(1,20) == 1 then
		self:UseItem("item_persona_hp")
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
function ENT:OnSummonPersona(persona) end
---------------------------------------------------------------------------------------------------------------------------------------------
function ENT:UseItem(class,t)
	if CurTime() > self.NextUseT then
		local ent = ents.Create(class)
		ent:SetPos(self:GetPos() +self:OBBCenter())
		ent:Spawn()
		ent:SetCollisionGroup(COLLISION_GROUP_IN_VEHICLE)
		ent:Use(self,self)
		self.NextUseT = CurTime() +(t or math.Rand(2,4))
	end
end
---------------------------------------------------------------------------------------------------------------------------------------------
function ENT:PersonaCode()
	if self.MetaVerseMode && self:Health() > 0 then
		if !IsValid(self:GetPersona()) then
			if self.VJ_IsBeingControlled then
				local jump = self.VJ_TheController:KeyDown(IN_JUMP)
				if jump then
					self:SummonPersona(self.Persona)
				end
			end
			if IsValid(self:GetEnemy()) && !self.VJ_IsBeingControlled then
				self:SummonPersona(self.Persona)
			end
		elseif IsValid(self:GetPersona()) then
			if self.VJ_IsBeingControlled then
				local jump = self.VJ_TheController:KeyDown(IN_JUMP)
				if jump then
					self:SummonPersona(self.Persona)
				end
			end
			if !IsValid(self:GetEnemy()) && !self.VJ_IsBeingControlled then
				self:SummonPersona(self.Persona)
			end
			self:PersonaThink(self:GetPersona(),self:GetEnemy(),self:VJ_GetNearestPointToEntityDistance(self:GetEnemy()),self.VJ_IsBeingControlled)
		end
	end
end
---------------------------------------------------------------------------------------------------------------------------------------------
function ENT:HandleAnimations()
	self.CurrentIdle = IsValid(self:GetPersona()) && self.Animations["idle_combat"] or self.Animations["idle"]
	self.CurrentWalk = IsValid(self:GetPersona()) && self.Animations["walk_combat"] or self.Animations["walk"]
	self.CurrentRun = IsValid(self:GetPersona()) && self.Animations["run_combat"] or self.Animations["run"]

	if self:Health() <= self:GetMaxHealth() *0.4 then
		self.CurrentIdle = self.Animations["idle_low"]
	end

	if self:GetState() == 0 then
		self.AnimTbl_IdleStand = {self.CurrentIdle}
		self.AnimTbl_Walk = {self.CurrentWalk}
		self.AnimTbl_Run = {self.CurrentRun}
	end
end
---------------------------------------------------------------------------------------------------------------------------------------------
function ENT:CustomOnThink()
	self:HandleAnimations()

	self.ConstantlyFaceEnemyDistance = self.FarAttackDistance -500
	self.NoChaseAfterCertainRange_FarDistance = self.CloseAttackDistance -50

	if IsValid(self:GetEnemy()) then
		if self.MetaVerseMode == false then
			if CurTime() > self.NextMetaChangeT then
				self.MetaVerseMode = true
				self.NextMetaChangeT = CurTime() +3
				self:OnSwitchMetaVerse(true)
			end
		else
			self.NextMetaChangeT = CurTime() +3
		end
	else
		if self.MetaVerseMode then
			if CurTime() > self.NextMetaChangeT then
				self.MetaVerseMode = false
				self.NextMetaChangeT = CurTime() +2
				self:OnSwitchMetaVerse(false)
			end
		else
			self.NextMetaChangeT = CurTime() +1
		end
	end
	
	self:PersonaCode()

	if CurTime() < self.NextMouthMoveT then
		if CurTime() > self.NextNumChangeT then
			self.MouthDistance = math.Rand(0,1)
			self.NextNumChangeT = CurTime() +0.2
		end
		local pp = self:GetPoseParameter("talk")
		local targ = self.MouthDistance
		local input = self:GetPoseParameter("talk")
		if pp != targ then
			if self.MouthDistance > input then
				input = pp +0.2
			else
				input = pp -0.2
			end
		end
		local fin = Lerp(1,pp,input)
		self:SetPoseParameter("talk",fin)
	else
		self:SetPoseParameter("talk",0)
	end
	
	self:OnThink()
end
---------------------------------------------------------------------------------------------------------------------------------------------
function ENT:CustomOnDeath_AfterCorpseSpawned(dmginfo,hitgroup,GetCorpse)
	if self.HasDeathAnimation == false then return end
	if self.CanRespawn == false then return end
	GetCorpse:ResetSequence("death")
	GetCorpse:SetCycle(1)
	GetCorpse.SP = self.SP
	GetCorpse.Class = self:GetClass()
	undo.ReplaceEntity(self,GetCorpse)
	timer.Simple(20,function()
		if IsValid(GetCorpse) then
			local e = ents.Create(GetCorpse.Class)
			e:SetPos(GetCorpse:GetPos())
			e:SetAngles(GetCorpse:GetAngles())
			e:Spawn()
			if self.DeathCorpseSubMaterials != nil then
				for _, x in ipairs(self.DeathCorpseSubMaterials) do
					if self:GetSubMaterial(x) != "" then
						self.Corpse:SetSubMaterial(x, self:GetSubMaterial(x))
					end
				end
			end
			e:SetNoDraw(true)
			e:SetModel(GetCorpse:GetModel())
			e:SetHealth(e:Health() /2)
			e.SP = GetCorpse.SP
			undo.ReplaceEntity(GetCorpse,e)
			e:VJ_ACT_PLAYACTIVITY("getup",true,false,false)
			e:SetState(VJ_STATE_FREEZE,e:DecideAnimationLength("getup"))
			e:StopAllCommonSpeechSounds()
			VJ_CreateSound(e,e.SoundTbl_GetUp,80,e:VJ_DecideSoundPitch(e.GeneralSoundPitch1,e.GeneralSoundPitch2))
			timer.Simple(0.2,function() SafeRemoveEntity(GetCorpse) if IsValid(e) then e:SetNoDraw(false) end end)
		end
	end)
end
/*-----------------------------------------------
	*** Copyright (c) 2012-2019 by Cpt. Hazama, All rights reserved. ***
	No parts of this code or any of its contents may be reproduced, copied, modified or adapted,
	without the prior written consent of the author, unless otherwise indicated for stand-alone materials.
-----------------------------------------------*/