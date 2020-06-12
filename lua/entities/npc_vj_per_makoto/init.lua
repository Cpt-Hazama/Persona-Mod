AddCSLuaFile("shared.lua")
include('shared.lua')
/*-----------------------------------------------
	*** Copyright (c) 2012-2019 by Cpt. Hazama, All rights reserved. ***
	No parts of this code or any of its contents may be reproduced, copied, modified or adapted,
	without the prior written consent of the author, unless otherwise indicated for stand-alone materials.
-----------------------------------------------*/
ENT.Model = {"models/cpthazama/persona5/makoto_normal.mdl"} -- The game will pick a random model from the table when the SNPC is spawned | Add as many as you want 
ENT.Stats = {
	HP = 556,
	SP = 330,
	STR = 84,
	MAG = 85,
	END = 81,
	AGI = 85,
	LUC = 69,
	WK = DMG_PSY,
	STR = DMG_CURSE,
	NUL = DMG_NUCLEAR,
}
ENT.HullType = HULL_HUMAN
---------------------------------------------------------------------------------------------------------------------------------------------
ENT.VJ_NPC_Class = {"CLASS_PLAYER_ALLY","CLASS_PHANTOMTHIEVES"}
ENT.PlayerFriendly = true

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
ENT.SoundTbl_Idle = {}
ENT.SoundTbl_Alert = {}
ENT.SoundTbl_BeforeMeleeAttack = {}
ENT.SoundTbl_Pain = {
	"cpthazama/persona5/makoto/0091.wav",
	"cpthazama/persona5/makoto/0092.wav",
	"cpthazama/persona5/makoto/0093.wav",
	"cpthazama/persona5/makoto/0094.wav",
	"cpthazama/persona5/makoto/0095.wav",
	"cpthazama/persona5/makoto/0096.wav",
	"cpthazama/persona5/makoto/0097.wav",
	"cpthazama/persona5/makoto/0098.wav",
	"cpthazama/persona5/makoto/0099.wav",
	"cpthazama/persona5/makoto/0100.wav",
	"cpthazama/persona5/makoto/0101.wav",
	"cpthazama/persona5/makoto/0102.wav",
	"cpthazama/persona5/makoto/0107.wav",
	"cpthazama/persona5/makoto/0108.wav",
	"cpthazama/persona5/makoto/0109.wav",
	"cpthazama/persona5/makoto/0110.wav",
	"cpthazama/persona5/makoto/0113.wav",
	"cpthazama/persona5/makoto/0114.wav",
	"cpthazama/persona5/makoto/0115.wav",
	"cpthazama/persona5/makoto/0116.wav",
}
ENT.SoundTbl_Death = {
	"cpthazama/persona5/makoto/0103.wav",
	"cpthazama/persona5/makoto/0104.wav",
	"cpthazama/persona5/makoto/0105.wav",
	"cpthazama/persona5/makoto/0106.wav",
	"cpthazama/persona5/makoto/0117.wav",
	"cpthazama/persona5/makoto/0118.wav",
}
ENT.SoundTbl_GetUp = {
	"cpthazama/persona5/makoto/0155.wav",
	"cpthazama/persona5/makoto/0159.wav",
}

ENT.GeneralSoundPitch1 = 100
---------------------------------------------------------------------------------------------------------------------------------------------
function ENT:CustomOnInitialize()
	self:SetHealth((GetConVarNumber("vj_npc_allhealth") > 0) and GetConVarNumber("vj_npc_allhealth") or self:VJ_GetDifficultyValue(self.Stats.HP))
	self.SP = self.Stats.SP
	
	self.MetaVerseMode = false
	
	self.NextMetaChangeT = CurTime() +2
	self.MouthDistance = 0
	self.NextMouthMoveT = 0
	self.NextNumChangeT = 0
	
	local max,min = self:GetCollisionBounds()
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
function ENT:CustomOnThink()
	self.AnimTbl_IdleStand = {self.MetaVerseMode && ACT_IDLE_ANGRY or ACT_IDLE}
	self.AnimTbl_Run = {self.MetaVerseMode && ACT_RUN_STIMULATED or ACT_RUN}
	if IsValid(self:GetEnemy()) then
		if self.MetaVerseMode == false then
			if CurTime() > self.NextMetaChangeT then
				self.MetaVerseMode = true
				self.NextMetaChangeT = CurTime() +5
				self:SetModel("models/cpthazama/persona5/makoto.mdl")
				self:SetBodygroup(1,1)
			end
		else
			self.NextMetaChangeT = CurTime() +5
		end
	else
		if self.MetaVerseMode then
			if CurTime() > self.NextMetaChangeT then
				self.MetaVerseMode = false
				self.NextMetaChangeT = CurTime() +2
				self:SetModel("models/cpthazama/persona5/makoto_normal.mdl")
				self:SetBodygroup(1,0)
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