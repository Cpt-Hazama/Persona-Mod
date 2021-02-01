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

ENT.VJC_Data = {
    CameraMode = 1, -- Sets the default camera mode | 1 = Third Person, 2 = First Person
    ThirdP_Offset = Vector(-15, 40, -35), -- The offset for the controller when the camera is in third person
    FirstP_Bone = "Bip01 Head", -- If left empty, the base will attempt to calculate a position for first person
    FirstP_Offset = Vector(5, 0, 2), -- The offset for the controller when the camera is in first person
}

ENT.SoundTbl_FootStep = {}
ENT.SoundTbl_CombatIdle = {}
ENT.SoundTbl_Pain = {}
ENT.SoundTbl_Death = {}
ENT.SoundTbl_OnKilledEnemy = {}
ENT.SoundTbl_Dodge = {}
ENT.SoundTbl_Persona = {}
ENT.SoundTbl_PersonaAttack = {}
ENT.SoundTbl_Critical = {}
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
ENT.Animations["critical_start"] = "critical_start"
ENT.Animations["critical"] = "critical"
ENT.Animations["critical_end"] = "critical_end"

ENT.Sounds = {}
-- ENT.Sounds[CUE_BATTLE_DISADVANTAGE] = {}

ENT.Persona = "izanagi"
ENT.CriticalDownTime = 10
ENT.DisablePersona = false
---------------------------------------------------------------------------------------------------------------------------------------------
function ENT:PersonaInit() end
---------------------------------------------------------------------------------------------------------------------------------------------
function ENT:CustomOnEntityRelationshipCheck(argent,entisfri,entdist)
	self.Persona_Party = self.Persona_Party or {}
	if IsValid(argent) && entisfri && argent.VJ_CanBeAddedToParty && !VJ_HasValue(self.Persona_Party,argent) then
		self:AddToParty(argent)
	end
end
---------------------------------------------------------------------------------------------------------------------------------------------
function ENT:CustomOnTakeDamage_BeforeDamage(dmginfo,hitgroup)
	local dmg = dmginfo:GetDamage()
	local dmgtype = dmginfo:GetDamageType()

	if dmginfo:GetDamage() > 0 then
		local canDodge = math.random(1,100) <= self.Stats.AGI
		if canDodge && self:BusyWithActivity() == false && self:GetState() != VJ_STATE_ONLY_ANIMATION && math.random(1,2) == 1 then
			if self:LookupSequence("dodge") then
				self:VJ_ACT_PLAYACTIVITY("dodge",true,false,true)
				self:ResetLoopAnimation()
			end
			dmginfo:SetDamage(0)
		end
	end
end
---------------------------------------------------------------------------------------------------------------------------------------------
function ENT:SetCriticalState()
	SafeRemoveEntity(self:GetPersona())
	self.InCriticalState = true
	self:VJ_ACT_PLAYACTIVITY(self.Animations["critical_start"],true,false,true)
	VJ_CreateSound(self,self.SoundTbl_Critical,80,self:VJ_DecideSoundPitch(self.GeneralSoundPitch1,self.GeneralSoundPitch2))
	timer.Simple(self:DecideAnimationLength(self.Animations["critical_start"],false),function()
		if IsValid(self) then
			self:StartLoopAnimation(self:GetSequenceActivity(self:LookupSequence(self.Animations["critical"])))
			timer.Simple(self.CriticalDownTime,function()
				if IsValid(self) then
					self:VJ_ACT_PLAYACTIVITY(self.Animations["critical_end"],true,false,true)
					VJ_CreateSound(self,self.SoundTbl_GetUp,80,self:VJ_DecideSoundPitch(self.GeneralSoundPitch1,self.GeneralSoundPitch2))
					timer.Simple(self:DecideAnimationLength(self.Animations["critical_end"],false),function()
						if IsValid(self) then
							self:ResetLoopAnimation()
							self.InCriticalState = false
						end
					end)
				end
			end)
		end
	end)
end
---------------------------------------------------------------------------------------------------------------------------------------------
function ENT:CustomOnTakeDamage_OnBleed(dmginfo,hitgroup)
	local dmg = dmginfo:GetDamage()
	local dmgtype = dmginfo:GetDamageType()
	local attacker = dmginfo:GetAttacker()
	local inflictor = dmginfo:GetInflictor()

	if dmginfo:GetDamage() > 0 && VJ_AnimationExists(self,self.Animations["critical"]) && IsValid(attacker) && (attacker:IsPlayer() or attacker:IsNPC()) && IsValid(attacker:GetPersona()) then
		local persona = attacker:GetPersona()
		if persona:GetCritical() && !self.InCriticalState then
			self:SetCriticalState(true)
		end
	end
end
---------------------------------------------------------------------------------------------------------------------------------------------
function ENT:CustomOnInitialize()
	self:SetHealth((GetConVarNumber("vj_npc_allhealth") > 0) and GetConVarNumber("vj_npc_allhealth") or self:VJ_GetDifficultyValue(self.Stats.HP))
	local mul = self.SelectedDifficulty +3
	if mul <= 0 then
		mul = 0.5
	end
	self.SP = self.Stats.SP *mul
	
	self.HasDeathRagdoll = self.HasDeathAnimation
	
	self.InCriticalState = false
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
	
	self.Bounds = self:GetCollisionBounds()
	self.Bounds.z = self:OBBMaxs().z
	
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
function ENT:PlaySoundCue(cue,vol,pit)
	VJ_CreateSound(self,self.Sounds[cue],vol or 75,pit or 100)
end
---------------------------------------------------------------------------------------------------------------------------------------------
function ENT:OnAnimEvent(persona,skill,animBlock,seq,t) end
---------------------------------------------------------------------------------------------------------------------------------------------
function ENT:OnPersonaAnimation(persona,skill,animBlock,seq,t)
	local myAnim = self.Animations[animBlock]
	self:OnAnimEvent(persona,skill,animBlock,seq,t)
	if self.InCriticalState then return end
	if animBlock == "melee" then
		local tStart = self:DecideAnimationLength(self.Animations["range_start"],false)
		local tMelee = self:DecideAnimationLength(self.Animations["melee"],false)
		self:SetState(VJ_STATE_ONLY_ANIMATION)
		self:VJ_ACT_PLAYACTIVITY(self.Animations["range_start"],true,false,true)
		timer.Simple(tStart,function()
			if IsValid(self) then
				if self.InCriticalState then return end
				self:StartLoopAnimation("range_idle")
				self:VJ_ACT_PLAYACTIVITY(myAnim,true,false,true)
				timer.Simple(tMelee,function()
					if IsValid(self) then
						if self.InCriticalState then return end
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
	-- if math.random(1,10) == 1 then
		-- persona:CycleCards()
	-- end
	if self:Health() <= self:GetMaxHealth() /2 && math.random(1,20) == 1 then
		self:UseItem("item_persona_hp")
	end
	if dist <= self.FarAttackDistance && math.random(1,math.random(2,4)) == 1 then // Can attempt battle methods...
		self:CalculateMove(persona,enemy,dist)
	end
	-- if dist <= self.FarAttackDistance && dist >= self.CloseAttackDistance -100 && math.random(1,4) == 1 then
		-- persona:DoSpecialAttack(self,persona,nil,true)
	-- elseif dist < self.CloseAttackDistance && math.random(1,6) == 1 then
		-- persona:DoMeleeAttack(self,persona,persona.CurrentMeleeSkill,true)
	-- end
end
---------------------------------------------------------------------------------------------------------------------------------------------
function ENT:OnThink() end
---------------------------------------------------------------------------------------------------------------------------------------------
function ENT:OnSwitchMetaVerse(didSwitch) end
---------------------------------------------------------------------------------------------------------------------------------------------
function ENT:OnSummonPersona(persona)
	self.VJC_Data.ThirdP_Offset = Vector(-80, 80, 0)
end
---------------------------------------------------------------------------------------------------------------------------------------------
function ENT:OnDisablePersona(persona)
	self.VJC_Data.ThirdP_Offset = Vector(-15, 40, -35)
end
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
function ENT:CalculateMove(persona,enemy,dist)
	local choose = math.random(1,100)
	local hasHeatRiser = self.Persona_HeatRiserT > CurTime()
	local hasCharge = self.Persona_ChargedT > CurTime()
	local hasConcentrate = self.Persona_FocusedT > CurTime()
	local hasTarukaja = self.Persona_TarukajaT > CurTime()
	local hasRakukaja = self.Persona_RakukajaT > CurTime()
	local hasSukukaja = self.Persona_SukukajaT > CurTime()
	local meleeSkill = persona.CurrentMeleeSkill
	local magicSkill = persona:GetCard()
	local hp = self:Health()
	local sp = self:GetSP()
	local doMelee = choose < 40

	if P_HasEnhancements(enemy) && (persona:HasSkill("Dekaja") or persona:HasSkill("Debilitate")) then
		if math.random(1,2) == 1 then
			persona:SetCard("Dekaja")
			persona:DoSpecialAttack(self,persona,nil,true)
		else
			persona:SetCard("Debilitate")
			persona:DoSpecialAttack(self,persona,nil,true)
		end
		return
	elseif P_HasPenalties(self) && math.random(1,2) == 1 && persona:HasSkill("Dekunda") then
		persona:SetCard("Dekunda")
		persona:DoSpecialAttack(self,persona,nil,true)
		return
	elseif !hasHeatRiser && math.random(1,3) == 1 && persona:HasSkill("Heat Riser") then
		persona:SetCard("Heat Riser")
		persona:DoSpecialAttack(self,persona,nil,true)
		return
	elseif !hasCharge && math.random(1,3) == 1 && persona:HasSkill("Charge") then
		persona:SetCard("Charge")
		persona:DoSpecialAttack(self,persona,nil,true)
		return
	elseif !hasConcentrate && math.random(1,3) == 1 && persona:HasSkill("Concentrate") then
		persona:SetCard("Concentrate")
		persona:DoSpecialAttack(self,persona,nil,true)
		return
	elseif (!hasTarukaja && persona:HasSkill("Tarukaja")) || (!hasRakukaja && persona:HasSkill("Rakukaja")) || (!hasSukukaja && persona:HasSkill("Sukukaja")) && math.random(1,3) == 1 then
		local tar = !hasTarukaja && persona:HasSkill("Tarukaja")
		local rak = !hasRakukaja && persona:HasSkill("Rakukaja")
		local suk = !hasSukukaja && persona:HasSkill("Sukukaja")
		local pick = {}
		if tar then table.insert(pick,"Tarukaja") end
		if rak then table.insert(pick,"Rakukaja") end
		if suk then table.insert(pick,"Sukukaja") end
		persona:SetCard(VJ_PICK(pick))
		persona:DoSpecialAttack(self,persona,nil,true)
		return
	end
	
	if hasConcentrate && !hasCharge && math.random(1,2) == 1 then
		doMelee = false
	elseif hasCharge && !hasConcentrate && math.random(1,2) == 1 then
		doMelee = true
	elseif enemy.InCriticalState then
		doMelee = true
	end

	if doMelee then // Attempt melee...
		if dist < self.CloseAttackDistance then
			persona:DoMeleeAttack(self,persona,meleeSkill,true)
		else
			if math.random(1,2) == 1 then
				if P_GETSKILL(magicSkill).icon != "heal" && persona:HasSkillType("heal") then
					local skill = persona:GetUsableSkillsByType("heal",sp)
					persona:SetCard(skill)
				end
			else
				local skill = persona:GetUsableSkillsBesidesType("heal",sp,false)
				persona:SetCard(skill)
			end
			persona:DoSpecialAttack(self,persona,nil,true)
		end
	else // Attempt range...
		if dist <= self.FarAttackDistance && dist >= self.CloseAttackDistance then
			if math.random(1,4) == 1 then
				if P_GETSKILL(magicSkill).icon != "heal" && persona:HasSkillType("heal") then
					local skill = persona:GetUsableSkillsByType("heal",sp)
					persona:SetCard(skill)
				end
			else
				local skill = persona:GetUsableSkillsBesidesType("heal",sp,false)
				persona:SetCard(skill)
			end
			persona:DoSpecialAttack(self,persona,nil,true)
		end
	end
end
---------------------------------------------------------------------------------------------------------------------------------------------
function ENT:PersonaCode()
	if self.DisablePersona then return end
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
function ENT:HandleAnimations(controlled)
	local combatAnims = (IsValid(self:GetPersona()) or (controlled && self.MetaVerseMode))
	self.CurrentIdle = combatAnims && self.Animations["idle_combat"] or self.Animations["idle"]
	self.CurrentWalk = combatAnims && self.Animations["walk_combat"] or self.Animations["walk"]
	self.CurrentRun = combatAnims && self.Animations["run_combat"] or self.Animations["run"]

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
function ENT:LevelCode()
	if IsValid(self:GetPersona()) then
		self:SetNW2Int("PXP_Level",self.Level or self:GetPersona().Stats.LVL)
	end
end
---------------------------------------------------------------------------------------------------------------------------------------------
function ENT:CustomOnThink()
	local controlled = self.VJ_IsBeingControlled

	self:HandleAnimations(controlled)
	
	self:LevelCode()
	self:SetNW2Bool("MetaVerseMode",self.MetaVerseMode)
	if self.HasAltForm == false then -- Fuck me right?
		self.MetaVerseMode = true
	end

	self.DisableFindEnemy = self.InCriticalState
	if self.InCriticalState then
		self:SetEnemy(NULL)
	end
	self.ConstantlyFaceEnemyDistance = self.FarAttackDistance -500
	self.NoChaseAfterCertainRange_FarDistance = self.CloseAttackDistance -50

	if !controlled then
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
					if IsValid(self:GetPersona()) then
						SafeRemoveEntity(self:GetPersona())
					end
					self.MetaVerseMode = false
					self.NextMetaChangeT = CurTime() +2
					self:OnSwitchMetaVerse(false)
				end
			else
				self.NextMetaChangeT = CurTime() +1
			end
		end
	else
		local ply = self.VJ_TheController
		if ply:KeyDown(IN_RELOAD) && ply:KeyDown(IN_USE) then
			if self.HasAltForm == false then return end
			if CurTime() > self.NextMetaChangeT then
				local new = !self.MetaVerseMode
				if new == false && IsValid(self:GetPersona()) then
					SafeRemoveEntity(self:GetPersona())
				end
				self.MetaVerseMode = !self.MetaVerseMode
				self.NextMetaChangeT = CurTime() +2
				self:OnSwitchMetaVerse(new)
			end
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
	local respawn = self.CanRespawn
	GetCorpse:ResetSequence("death")
	GetCorpse:SetCycle(1)
	GetCorpse.SP = self.SP
	GetCorpse.Class = self:GetClass()
	undo.ReplaceEntity(self,GetCorpse)
	timer.Simple(20,function()
		if IsValid(GetCorpse) then
			if !respawn then
				GetCorpse:Remove()
				return
			end
			local e = ents.Create(GetCorpse.Class)
			e:SetPos(GetCorpse:GetPos() +Vector(0,0,4))
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