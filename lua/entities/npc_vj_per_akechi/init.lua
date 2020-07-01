AddCSLuaFile("shared.lua")
include('shared.lua')
/*-----------------------------------------------
	*** Copyright (c) 2012-2019 by Cpt. Hazama, All rights reserved. ***
	No parts of this code or any of its contents may be reproduced, copied, modified or adapted,
	without the prior written consent of the author, unless otherwise indicated for stand-alone materials.
-----------------------------------------------*/
ENT.Model = {"models/cpthazama/persona5/akechi.mdl"} -- The game will pick a random model from the table when the SNPC is spawned | Add as many as you want 
ENT.Stats = {
	HP = 5000,
	SP = 999,
	STR = 80,
	MAG = 30,
	END = 43,
	AGI = 50,
	LUC = 45,
	WK = DMG_BLESS,
	STR = DMG_CURSE,
	NUL = DMG_CURSE,
}
ENT.Evasion = 30
ENT.HullType = HULL_HUMAN
---------------------------------------------------------------------------------------------------------------------------------------------
ENT.VJ_NPC_Class = {"CLASS_BLACKMASK"}

ENT.BloodColor = "Red"

ENT.HasMeleeAttack = true
ENT.AnimTbl_MeleeAttack = {ACT_MELEE_ATTACK1}
ENT.TimeUntilMeleeAttackDamage = false
ENT.MeleeAttackDistance = 80
ENT.MeleeAttackDamageDistance = 110
ENT.MeleeAttackDamage = 25

ENT.HasDeathAnimation = true
ENT.AnimTbl_Death = {ACT_DIESIMPLE}
ENT.DeathCorpseEntityClass = "prop_vj_animatable"

ENT.SoundTbl_FootStep = {}
ENT.SoundTbl_CombatIdle = {
	"cpthazama/persona5/akechi/00000_streaming [1].wav",
	"cpthazama/persona5/akechi/00018_streaming [1].wav",
	"cpthazama/persona5/akechi/00021_streaming [1].wav",
	"cpthazama/persona5/akechi/blackmask/00000_streaming [1].wav",
	"cpthazama/persona5/akechi/blackmask/00005_streaming [1].wav",
	"cpthazama/persona5/akechi/blackmask/00007_streaming [1].wav",
	"cpthazama/persona5/akechi/blackmask/00013_streaming [1].wav",
	"cpthazama/persona5/akechi/blackmask/00015_streaming [1].wav",
}
ENT.SoundTbl_Pain = {
	"cpthazama/persona5/akechi/blackmask/00009_streaming [1].wav",
	"cpthazama/persona5/akechi/blackmask/00011_streaming [1].wav",
	"cpthazama/persona5/akechi/blackmask/00012_streaming [1].wav",
	"cpthazama/persona5/akechi/blackmask/00023_streaming [1].wav",
	"cpthazama/persona5/akechi/blackmask/00024_streaming [1].wav",
	"cpthazama/persona5/akechi/blackmask/00030_streaming [1].wav",
	"cpthazama/persona5/akechi/blackmask/00031_streaming [1].wav",
}
ENT.SoundTbl_Death = {
	"cpthazama/persona5/akechi/blackmask/00018_streaming [1].wav",
	"cpthazama/persona5/akechi/blackmask/00019_streaming [1].wav",
	"cpthazama/persona5/akechi/blackmask/00020_streaming [1].wav",
	"cpthazama/persona5/akechi/blackmask/00026_streaming [1].wav",
}
ENT.SoundTbl_OnKilledEnemy = {
	"cpthazama/persona5/akechi/blackmask/00000_streaming [1].wav",
	"cpthazama/persona5/akechi/blackmask/00013_streaming [1].wav",
	"cpthazama/persona5/akechi/blackmask/00014_streaming [1].wav",
	"cpthazama/persona5/akechi/blackmask/00016_streaming [1].wav",
	"cpthazama/persona5/akechi/00007_streaming [1].wav",
	"cpthazama/persona5/akechi/00008_streaming [1].wav",
	"cpthazama/persona5/akechi/00009_streaming [1].wav",
}
ENT.SoundTbl_Dodge = {
	"cpthazama/persona5/akechi/blackmask/00011_streaming [1].wav",
	"cpthazama/persona5/akechi/blackmask/00015_streaming [1].wav",
	"cpthazama/persona5/akechi/blackmask/00017_streaming [1].wav",
	"cpthazama/persona5/akechi/blackmask/00021_streaming [1].wav",
	"cpthazama/persona5/akechi/blackmask/00022_streaming [1].wav",
}
ENT.SoundTbl_Persona = {
	"cpthazama/persona5/akechi/blackmask/00010_streaming [1].wav",
	"cpthazama/persona5/akechi/blackmask/00028_streaming [1].wav",
	"cpthazama/persona5/akechi/blackmask/00029_streaming [1].wav",
}
ENT.SoundTbl_PersonaAttack = {
	"cpthazama/persona5/akechi/blackmask/00003_streaming [1].wav",
	"cpthazama/persona5/akechi/blackmask/00004_streaming [1].wav",
	"cpthazama/persona5/akechi/blackmask/00005_streaming [1].wav",
	"cpthazama/persona5/akechi/blackmask/00006_streaming [1].wav",
	"cpthazama/persona5/akechi/blackmask/00007_streaming [1].wav",
	"cpthazama/persona5/akechi/blackmask/00008_streaming [1].wav",
}
ENT.SoundTbl_GetUp = {
	"cpthazama/persona5/akechi/blackmask/00009_streaming [1].wav",
	"cpthazama/persona5/akechi/blackmask/00025_streaming [1].wav",
	"cpthazama/persona5/akechi/blackmask/00027_streaming [1].wav",
}

ENT.GeneralSoundPitch1 = 100

util.AddNetworkString("vj_persona_hud_akechi")
---------------------------------------------------------------------------------------------------------------------------------------------
function ENT:Controller_Initialize(ply)
    net.Start("vj_persona_hud_akechi")
		net.WriteBool(false)
		net.WriteEntity(self)
    net.Send(ply)

	function self.VJ_TheControllerEntity:CustomOnStopControlling()
		net.Start("vj_persona_hud_akechi")
			net.WriteBool(true)
			net.WriteEntity(self)
		net.Send(ply)
	end
end
---------------------------------------------------------------------------------------------------------------------------------------------
function ENT:CustomOnTakeDamage_BeforeDamage(dmginfo,hitgroup)
	local dmg = dmginfo:GetDamage()
	local dmgtype = dmginfo:GetDamageType()
	
	if dmgtype == self.Stats.WK then
		dmginfo:ScaleDamage(2)
	end
	if dmgtype == self.Stats.STR then
		dmginfo:ScaleDamage(0.35)
	end
	if dmgtype == self.Stats.NUL then
		dmginfo:SetDamage(0)
	end
	
	if dmginfo:GetDamage() > 0 then
		if math.random(1,100) <= self.Evasion then
			self:VJ_ACT_PLAYACTIVITY("dodge",true,false,true)
			dmginfo:SetDamage(0)
		end
	end
end
---------------------------------------------------------------------------------------------------------------------------------------------
function ENT:CustomOnInitialize()
	self:SetHealth((GetConVarNumber("vj_npc_allhealth") > 0) and GetConVarNumber("vj_npc_allhealth") or self:VJ_GetDifficultyValue(self.Stats.HP))
	self.SP = self.Stats.SP
	
	self.MetaVerseMode = false
	
	self.NextMetaChangeT = CurTime() +1
	self.MouthDistance = 0
	self.NextMouthMoveT = 0
	self.NextNumChangeT = 0
	
	self:CapabilitiesAdd(bit.bor(CAP_ANIMATEDFACE))
	self:CapabilitiesAdd(bit.bor(CAP_TURN_HEAD))
	self:CapabilitiesAdd(bit.bor(CAP_OPEN_DOORS))
	self:CapabilitiesAdd(bit.bor(CAP_AUTO_DOORS))
	self:CapabilitiesAdd(bit.bor(CAP_USE))

	self:SetBodygroup(1,1)
	
	-- local max,min = self:GetCollisionBounds()
	
	self:SetSP(self.Stats.SP)
	self:SetMaxSP(self.Stats.SP)
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
function ENT:PersonaThink(persona,enemy,dist)
	-- if IsValid(enemy) && self:Visible(enemy) then
		-- if dist < 2000 && dist > 500 then
			-- if persona:GetTask() == "TASK_IDLE" then
				-- persona:Freila(self,enemy)
			-- end
		-- elseif dist <= 500 then
			-- if persona:GetTask() == "TASK_IDLE" then
				-- persona:VajraBlast(self,enemy)
			-- end
		-- end
	-- end
end
---------------------------------------------------------------------------------------------------------------------------------------------
function ENT:CustomOnThink()
	local idle = self.MetaVerseMode && ACT_IDLE_ANGRY or ACT_IDLE
	local run = self.MetaVerseMode && ACT_RUN_STIMULATED or ACT_RUN
	
	if self:Health() <= self:GetMaxHealth() *0.3 then
		idle = ACT_IDLE_STIMULATED
	end
	if IsValid(self:GetPersona()) then
		if self.PreparedToAttack then
			idle = VJ_SequenceToActivity(self,"persona_attack_start_idle")
		end
	end

	self.AnimTbl_IdleStand = {idle}
	self.AnimTbl_Run = {run}

	self.DisableChasingEnemy = IsValid(self:GetPersona())
	if self.DisableChasingEnemy then
		if self:IsMoving() then
			self:StopMoving()
			self:ClearSchedule()
		end
	end
	
	if self.MetaVerseMode then
		self:SetPoseParameter("angry",0.6)
		if !IsValid(self:GetPersona()) then
			if IsValid(self:GetEnemy()) then
				self:SummonPersona("loki")
				ParticleEffectAttach("jojo_aura_red",PATTACH_POINT_FOLLOW,self,self:LookupAttachment("origin"))
			end
		elseif IsValid(self:GetPersona()) then
			-- self:SetBodygroup(1,0)
			if !IsValid(self:GetEnemy()) then
				self:SummonPersona("loki")
				-- self:SetBodygroup(1,1)
			end
			self:PersonaThink(self:GetPersona(),self:GetEnemy(),self:VJ_GetNearestPointToEntityDistance(self:GetEnemy()))
		end
	else
		self:SetPoseParameter("angry",0)
	end

	if IsValid(self:GetEnemy()) then
		if self.MetaVerseMode == false then
			if CurTime() > self.NextMetaChangeT then
				self.MetaVerseMode = true
				self.NextMetaChangeT = CurTime() +5
				-- self:SetModel("models/cpthazama/persona5/akechi.mdl")
				-- self:SetBodygroup(1,1)
			end
		else
			self.NextMetaChangeT = CurTime() +5
		end
	else
		if self.MetaVerseMode then
			if CurTime() > self.NextMetaChangeT then
				self.MetaVerseMode = false
				self.NextMetaChangeT = CurTime() +2
				-- self:SetModel("models/cpthazama/persona5/akechi_normal.mdl")
				-- self:SetBodygroup(1,0)
			end
		else
			self.NextMetaChangeT = CurTime() +2
		end
	end
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
end
---------------------------------------------------------------------------------------------------------------------------------------------
function ENT:CustomOnDeath_AfterCorpseSpawned(dmginfo,hitgroup,GetCorpse)
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