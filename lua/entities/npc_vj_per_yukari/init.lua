AddCSLuaFile("shared.lua")
include('shared.lua')
/*-----------------------------------------------
	*** Copyright (c) 2012-2019 by Cpt. Hazama, All rights reserved. ***
	No parts of this code or any of its contents may be reproduced, copied, modified or adapted,
	without the prior written consent of the author, unless otherwise indicated for stand-alone materials.
-----------------------------------------------*/
ENT.Model = {"models/cpthazama/persona3/yukari.mdl"} -- The game will pick a random model from the table when the SNPC is spawned | Add as many as you want 
ENT.Stats = {
	HP = 2000,
	SP = 1250,
	STR = 91,
	MAG = 70,
	END = 42,
	AGI = 44,
	LUC = 41,
	WK = nil,
	STR = DMG_P_WIND,
	NUL = DMG_P_CURSE,
}
ENT.Evasion = 18
ENT.HullType = HULL_HUMAN
---------------------------------------------------------------------------------------------------------------------------------------------
ENT.VJ_NPC_Class = {"CLASS_YUKARI","CLASS_PLAYER_ALLY","CLASS_SEES"}
ENT.PlayerFriendly = true

ENT.BloodColor = "Red"

ENT.HasMeleeAttack = false
ENT.AnimTbl_MeleeAttack = {ACT_MELEE_ATTACK1}
ENT.TimeUntilMeleeAttackDamage = false
ENT.MeleeAttackDistance = 80
ENT.MeleeAttackDamageDistance = 110
ENT.MeleeAttackDamage = 25

-- ENT.HasDeathAnimation = true
-- ENT.AnimTbl_Death = {ACT_DIESIMPLE}
-- ENT.DeathCorpseEntityClass = "prop_vj_animatable"

ENT.SoundTbl_FootStep = {}
ENT.SoundTbl_CombatIdle = {

}
ENT.SoundTbl_Pain = {

}
ENT.SoundTbl_Death = {

}
ENT.SoundTbl_OnKilledEnemy = {

}
ENT.SoundTbl_Dodge = {

}
ENT.SoundTbl_Persona = {

}
ENT.SoundTbl_PersonaAttack = {

}
ENT.SoundTbl_GetUp = {
}

ENT.GeneralSoundPitch1 = 100
ENT.HasAltForm = false

util.AddNetworkString("vj_persona_hud_yukari")
---------------------------------------------------------------------------------------------------------------------------------------------
function ENT:Controller_Initialize(ply)
    net.Start("vj_persona_hud_yukari")
		net.WriteBool(false)
		net.WriteEntity(self)
    net.Send(ply)

	function self.VJ_TheControllerEntity:CustomOnStopControlling()
		net.Start("vj_persona_hud_yukari")
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
			-- self:VJ_ACT_PLAYACTIVITY("dodge",true,false,true)
			dmginfo:SetDamage(0)
		end
	end
end
---------------------------------------------------------------------------------------------------------------------------------------------
function ENT:CustomOnInitialize()
	self:SetHealth((GetConVarNumber("vj_npc_allhealth") > 0) and GetConVarNumber("vj_npc_allhealth") or self:VJ_GetDifficultyValue(self.Stats.HP))
	self.SP = self.Stats.SP
	
	self.MetaVerseMode = true
	self.PreparedToAttack = false
	
	self.NextMetaChangeT = CurTime() +1
	self.MouthDistance = 0
	self.NextMouthMoveT = 0
	self.NextNumChangeT = 0
	
	self:CapabilitiesAdd(bit.bor(CAP_ANIMATEDFACE))
	self:CapabilitiesAdd(bit.bor(CAP_TURN_HEAD))
	self:CapabilitiesAdd(bit.bor(CAP_OPEN_DOORS))
	self:CapabilitiesAdd(bit.bor(CAP_AUTO_DOORS))
	self:CapabilitiesAdd(bit.bor(CAP_USE))
	
	-- local max,min = self:GetCollisionBounds()
	
	self:SetSP(self.Stats.SP)
	self:SetMaxSP(self.Stats.SP)
	self.WeaponSpread = 1
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
	if self.VJ_IsBeingControlled then
		local ply = self.VJ_TheController
		local lmb = ply:KeyDown(IN_ATTACK)
		local rmb = ply:KeyDown(IN_ATTACK2)
		local r = ply:KeyDown(IN_RELOAD)
		
		if lmb then

		end
		return
	end
	if IsValid(enemy) && self:Visible(enemy) then
		-- if dist <= 2500 then
			-- if !self.PreparedToAttack && persona:GetTask() == "TASK_IDLE" && CurTime() > persona.RechargeT then
				-- self.PreparedToAttack = true
				-- self:VJ_ACT_PLAYACTIVITY("persona_attack_start",true,false,true)
				-- if persona:GetTask() == "TASK_IDLE" then
					-- persona:Maziodyne_NPC(self,enemy)
					-- self.PreparedToAttack = false
				-- end
				-- timer.Simple(self:DecideAnimationLength("persona_attack_start",false),function()
					-- if IsValid(self) then
						-- self.PreparedToAttack = false
					-- end
				-- end)
			-- end
		-- end
	end
end
---------------------------------------------------------------------------------------------------------------------------------------------
function ENT:CustomOnThink()
	self:SetPoseParameter("smile",self:IsMoving() && 0.65 or self:Health() <= self:GetMaxHealth() *0.3 && 0 or 0.2)
	-- local idle = self.MetaVerseMode && ACT_IDLE_ANGRY or ACT_IDLE
	local idle = IsValid(self:GetEnemy()) && ACT_IDLE_ANGRY or ACT_IDLE
	
	if self:Health() <= self:GetMaxHealth() *0.3 then
		-- idle = ACT_IDLE_STIMULATED
	end

	self.AnimTbl_IdleStand = {idle}

	self.DisableChasingEnemy = IsValid(self:GetPersona())
	self.ConstantlyFaceEnemy = IsValid(self:GetPersona())
	if self.DisableChasingEnemy then
		if self:IsMoving() then
			self:StopMoving()
			self:ClearSchedule()
		end
	end
	
	if self.MetaVerseMode && self:Health() > 0 then
		self:SetPoseParameter("anger",0.6)
		if !IsValid(self:GetPersona()) then
			if self.VJ_IsBeingControlled then
				local jump = self.VJ_TheController:KeyDown(IN_JUMP)
				if jump then
					-- self:SummonPersona("isis")
					ParticleEffectAttach("jojo_aura_green",PATTACH_POINT_FOLLOW,self,self:LookupAttachment("origin"))
				end
			end
			if IsValid(self:GetEnemy()) && !self.VJ_IsBeingControlled then
				-- self:SummonPersona("isis")
				ParticleEffectAttach("jojo_aura_green",PATTACH_POINT_FOLLOW,self,self:LookupAttachment("origin"))
			end
		elseif IsValid(self:GetPersona()) then
			if self.VJ_IsBeingControlled then
				local jump = self.VJ_TheController:KeyDown(IN_JUMP)
				if jump then
					-- self:SummonPersona("isis")
				end
			end
			if !IsValid(self:GetEnemy()) && !self.VJ_IsBeingControlled then
				-- self:SummonPersona("isis")
			end
			-- self:PersonaThink(self:GetPersona(),self:GetEnemy(),self:VJ_GetNearestPointToEntityDistance(self:GetEnemy()))
		end
	else
		self:SetPoseParameter("anger",0)
	end

	-- if IsValid(self:GetEnemy()) then
		-- if self.MetaVerseMode == false then
			-- if CurTime() > self.NextMetaChangeT then
				-- self.MetaVerseMode = true
				-- self.NextMetaChangeT = CurTime() +5
			-- end
		-- else
			-- self.NextMetaChangeT = CurTime() +5
		-- end
	-- else
		-- if self.MetaVerseMode then
			-- if CurTime() > self.NextMetaChangeT then
				-- self.MetaVerseMode = false
				-- self.NextMetaChangeT = CurTime() +2
			-- end
		-- else
			-- self.NextMetaChangeT = CurTime() +2
		-- end
	-- end
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
	-- GetCorpse:ResetSequence("death")
	-- GetCorpse:SetCycle(1)
	-- GetCorpse.SP = self.SP
	-- GetCorpse.Class = self:GetClass()
	-- undo.ReplaceEntity(self,GetCorpse)
	-- timer.Simple(20,function()
		-- if IsValid(GetCorpse) then
			-- local e = ents.Create(GetCorpse.Class)
			-- e:SetPos(GetCorpse:GetPos())
			-- e:SetAngles(GetCorpse:GetAngles())
			-- e:Spawn()
			-- e:SetNoDraw(true)
			-- e:SetModel(GetCorpse:GetModel())
			-- e:SetHealth(e:Health() /2)
			-- e.SP = GetCorpse.SP
			-- undo.ReplaceEntity(GetCorpse,e)
			-- e:VJ_ACT_PLAYACTIVITY("getup",true,false,false)
			-- e:SetState(VJ_STATE_FREEZE,e:DecideAnimationLength("getup"))
			-- e:StopAllCommonSpeechSounds()
			-- VJ_CreateSound(e,e.SoundTbl_GetUp,80,e:VJ_DecideSoundPitch(e.GeneralSoundPitch1,e.GeneralSoundPitch2))
			-- timer.Simple(0.2,function() SafeRemoveEntity(GetCorpse) if IsValid(e) then e:SetNoDraw(false) end end)
		-- end
	-- end)
end
/*-----------------------------------------------
	*** Copyright (c) 2012-2019 by Cpt. Hazama, All rights reserved. ***
	No parts of this code or any of its contents may be reproduced, copied, modified or adapted,
	without the prior written consent of the author, unless otherwise indicated for stand-alone materials.
-----------------------------------------------*/