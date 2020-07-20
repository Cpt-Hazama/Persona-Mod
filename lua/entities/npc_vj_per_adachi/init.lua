AddCSLuaFile("shared.lua")
include('shared.lua')
/*-----------------------------------------------
	*** Copyright (c) 2012-2019 by Cpt. Hazama, All rights reserved. ***
	No parts of this code or any of its contents may be reproduced, copied, modified or adapted,
	without the prior written consent of the author, unless otherwise indicated for stand-alone materials.
-----------------------------------------------*/
ENT.Model = {"models/cpthazama/persona5/adachi.mdl"} -- The game will pick a random model from the table when the SNPC is spawned | Add as many as you want 
ENT.Stats = {
	HP = 4200,
	SP = 2200,
	STR = 65,
	MAG = 55,
	END = 66,
	AGI = 45,
	LUC = 45,
	WK = DMG_P_NUCLEAR,
	STR = DMG_P_PHYS,
	NUL = DMG_P_BLESS,
}
ENT.Evasion = 15
ENT.HullType = HULL_HUMAN
---------------------------------------------------------------------------------------------------------------------------------------------
ENT.VJ_NPC_Class = {"CLASS_ADACHI"}

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
	"cpthazama/persona5/adachi/vo/npc/vbtl_pad_0#1 (pad000).wav",
	"cpthazama/persona5/adachi/vo/npc/vbtl_pad_0#140 (pad202_2).wav",
	"cpthazama/persona5/adachi/vo/npc/vbtl_pad_0#141 (pad203_0).wav",
	"cpthazama/persona5/adachi/vo/npc/vbtl_pad_0#145 (pad204_1).wav",
	"cpthazama/persona5/adachi/vo/npc/vbtl_pad_0#148 (pad205_1).wav",
	"cpthazama/persona5/adachi/vo/npc/vbtl_pad_0#178 (pad300_0).wav",
	"cpthazama/persona5/adachi/vo/npc/vbtl_pad_0#180 (pad300_2).wav",
	"cpthazama/persona5/adachi/vo/npc/vbtl_pad_0#208 (pad600def).wav",
	"cpthazama/persona5/adachi/vo/npc/vbtl_pad_0#209 (pad601def).wav",
}
ENT.SoundTbl_Pain = {
	"cpthazama/persona5/adachi/vo/npc/vbtl_pad_0#101 (pad155).wav",
	"cpthazama/persona5/adachi/vo/npc/vbtl_pad_0#11 (pad010).wav",
	"cpthazama/persona5/adachi/vo/npc/vbtl_pad_0#12 (pad015).wav",
	"cpthazama/persona5/adachi/vo/npc/vbtl_pad_0#13 (pad016).wav",
	"cpthazama/persona5/adachi/vo/npc/vbtl_pad_0#130 (pad170_0).wav",
	"cpthazama/persona5/adachi/vo/npc/vbtl_pad_0#131 (pad170_1).wav",
	"cpthazama/persona5/adachi/vo/npc/vbtl_pad_0#14 (pad017).wav",
	"cpthazama/persona5/adachi/vo/npc/vbtl_pad_0#15 (pad018).wav",
	"cpthazama/persona5/adachi/vo/npc/vbtl_pad_0#16 (pad019).wav",
	"cpthazama/persona5/adachi/vo/npc/vbtl_pad_0#17 (pad020).wav",
}
ENT.SoundTbl_Death = {
	"cpthazama/persona5/adachi/vo/npc/vbtl_pad_0#18 (pad021).wav",
	"cpthazama/persona5/adachi/vo/npc/vbtl_pad_0#19 (pad022).wav",
	"cpthazama/persona5/adachi/vo/npc/vbtl_pad_0#200 (pad400_0).wav",
	"cpthazama/persona5/adachi/vo/npc/vbtl_pad_0#201 (pad400_1).wav",
	"cpthazama/persona5/adachi/vo/npc/vbtl_pad_0#202 (pad401_0).wav",
	"cpthazama/persona5/adachi/vo/npc/vbtl_pad_0#203 (pad401_1).wav",
}
ENT.SoundTbl_OnKilledEnemy = {
	"cpthazama/persona5/adachi/vo/npc/vbtl_pad_0#102 (pad156_0).wav",
	"cpthazama/persona5/adachi/vo/npc/vbtl_pad_0#109 (pad159_1).wav",
	"cpthazama/persona5/adachi/vo/npc/vbtl_pad_0#110 (pad160_0).wav",
	"cpthazama/persona5/adachi/vo/npc/vbtl_pad_0#122 (pad166_0).wav",
	"cpthazama/persona5/adachi/vo/npc/vbtl_pad_0#133 (pad200_1).wav",
	"cpthazama/persona5/adachi/vo/npc/vbtl_pad_0#134 (pad200_2).wav",
	"cpthazama/persona5/adachi/vo/npc/vbtl_pad_0#135 (pad201_0).wav",
	"cpthazama/persona5/adachi/vo/npc/vbtl_pad_0#137 (pad201_2).wav",
	"cpthazama/persona5/adachi/vo/npc/vbtl_pad_0#143 (pad203_2).wav",
	"cpthazama/persona5/adachi/vo/npc/vbtl_pad_0#155 (pad207_2).wav",
	"cpthazama/persona5/adachi/vo/npc/vbtl_pad_0#179 (pad300_1).wav",
	"cpthazama/persona5/adachi/vo/npc/vbtl_pad_0#183 (pad301_2).wav",
	"cpthazama/persona5/adachi/vo/npc/vbtl_pad_0#204 (pad402_0).wav",
	"cpthazama/persona5/adachi/vo/npc/vbtl_pad_0#205 (pad402_1).wav",
	"cpthazama/persona5/adachi/vo/npc/vbtl_pad_0#206 (pad403_0).wav",
}
ENT.SoundTbl_Dodge = {
	"cpthazama/persona5/adachi/vo/npc/vbtl_pad_0#113 (pad161_1).wav",
	"cpthazama/persona5/adachi/vo/npc/vbtl_pad_0#114 (pad162_0).wav",
	"cpthazama/persona5/adachi/vo/npc/vbtl_pad_0#116 (pad163_0).wav",
	"cpthazama/persona5/adachi/vo/npc/vbtl_pad_0#117 (pad163_1).wav",
	"cpthazama/persona5/adachi/vo/npc/vbtl_pad_0#119 (pad164_1).wav",
	"cpthazama/persona5/adachi/vo/npc/vbtl_pad_0#121 (pad165_1).wav",
	"cpthazama/persona5/adachi/vo/npc/vbtl_pad_0#132 (pad200_0).wav",
	"cpthazama/persona5/adachi/vo/npc/vbtl_pad_0#136 (pad201_1).wav",
	"cpthazama/persona5/adachi/vo/npc/vbtl_pad_0#181 (pad301_0).wav",
	"cpthazama/persona5/adachi/vo/npc/vbtl_pad_0#182 (pad301_1).wav",
	"cpthazama/persona5/adachi/vo/npc/vbtl_pad_0#185 (pad302_1).wav",
	"cpthazama/persona5/adachi/vo/npc/vbtl_pad_0#186 (pad302_2).wav",
	"cpthazama/persona5/adachi/vo/npc/vbtl_pad_0#187 (pad303_0).wav",
}
ENT.SoundTbl_Persona = {
	"cpthazama/persona5/adachi/vo/summon_01.wav",
	"cpthazama/persona5/adachi/vo/summon_02.wav",
	"cpthazama/persona5/adachi/vo/summon_03.wav",
	"cpthazama/persona5/adachi/vo/summon_04.wav",
	"cpthazama/persona5/adachi/vo/summon_05.wav",
	"cpthazama/persona5/adachi/vo/summon_06.wav",
	"cpthazama/persona5/adachi/vo/summon_07.wav",
	"cpthazama/persona5/adachi/vo/summon_08.wav",
}
ENT.SoundTbl_PersonaAttack = {
	"cpthazama/persona5/adachi/vo/npc/vbtl_pad_0#104 (pad157_0).wav",
	"cpthazama/persona5/adachi/vo/npc/vbtl_pad_0#105 (pad157_1).wav",
	"cpthazama/persona5/adachi/vo/npc/vbtl_pad_0#106 (pad158_0).wav",
	"cpthazama/persona5/adachi/vo/npc/vbtl_pad_0#107 (pad158_1).wav",
	"cpthazama/persona5/adachi/vo/npc/vbtl_pad_0#108 (pad159_0).wav",
	"cpthazama/persona5/adachi/vo/npc/vbtl_pad_0#120 (pad165_0).wav",
	"cpthazama/persona5/adachi/vo/npc/vbtl_pad_0#124 (pad167_0).wav",
	"cpthazama/persona5/adachi/vo/npc/vbtl_pad_0#125 (pad167_1).wav",
	"cpthazama/persona5/adachi/vo/npc/vbtl_pad_0#126 (pad168_0).wav",
	"cpthazama/persona5/adachi/vo/npc/vbtl_pad_0#127 (pad168_1).wav",
	"cpthazama/persona5/adachi/vo/npc/vbtl_pad_0#128 (pad169_0).wav",
	"cpthazama/persona5/adachi/vo/npc/vbtl_pad_0#129 (pad169_1).wav",
	"cpthazama/persona5/adachi/vo/npc/vbtl_pad_0#139 (pad202_1).wav",
	"cpthazama/persona5/adachi/vo/npc/vbtl_pad_0#149 (pad205_2).wav",
	"cpthazama/persona5/adachi/vo/npc/vbtl_pad_0#156 (pad250_0).wav",
	"cpthazama/persona5/adachi/vo/npc/vbtl_pad_0#157 (pad250_1).wav",
	"cpthazama/persona5/adachi/vo/npc/vbtl_pad_0#158 (pad251_0).wav",
	"cpthazama/persona5/adachi/vo/npc/vbtl_pad_0#160 (pad252_0).wav",
	"cpthazama/persona5/adachi/vo/npc/vbtl_pad_0#162 (pad253_0).wav",
	"cpthazama/persona5/adachi/vo/npc/vbtl_pad_0#161 (pad252_1).wav",
	"cpthazama/persona5/adachi/vo/npc/vbtl_pad_0#168 (pad290_0).wav",
	"cpthazama/persona5/adachi/vo/npc/vbtl_pad_0#169 (pad290_1).wav",
	"cpthazama/persona5/adachi/vo/npc/vbtl_pad_0#171 (pad291_1).wav",
	"cpthazama/persona5/adachi/vo/npc/vbtl_pad_0#188 (pad303_1).wav",
}
ENT.SoundTbl_GetUp = {
}

ENT.GeneralSoundPitch1 = 100

util.AddNetworkString("vj_persona_hud_adachi")
---------------------------------------------------------------------------------------------------------------------------------------------
function ENT:Controller_Initialize(ply)
    net.Start("vj_persona_hud_adachi")
		net.WriteBool(false)
		net.WriteEntity(self)
    net.Send(ply)

	function self.VJ_TheControllerEntity:CustomOnStopControlling()
		net.Start("vj_persona_hud_adachi")
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

	self:SetBodygroup(1,1)
	
	-- local max,min = self:GetCollisionBounds()
	
	self:Give("weapon_vj_persona_revolver_adachi")
	
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
			if !self.PreparedToAttack && persona:GetTask() == "TASK_IDLE" then
				self.PreparedToAttack = true
				self:VJ_ACT_PLAYACTIVITY("persona_attack_start",true,false,true)
				timer.Simple(self:DecideAnimationLength("persona_attack_start",false),function()
					if IsValid(self) && IsValid(persona) && IsValid(enemy) then
						if persona:GetTask() == "TASK_IDLE" then
							persona:Maziodyne_NPC(self,enemy)
							self.PreparedToAttack = false
						end
					end
				end)
			end
		end
		return
	end
	if IsValid(enemy) && self:Visible(enemy) then
		if dist <= 2500 then
			if !self.PreparedToAttack && persona:GetTask() == "TASK_IDLE" then
				self.PreparedToAttack = true
				self:VJ_ACT_PLAYACTIVITY("persona_attack_start",true,false,true)
				timer.Simple(self:DecideAnimationLength("persona_attack_start",false),function()
					if IsValid(self) && IsValid(persona) && IsValid(enemy) then
						if persona:GetTask() == "TASK_IDLE" then
							persona:Maziodyne_NPC(self,enemy)
							self.PreparedToAttack = false
						end
					end
				end)
			end
		end
	end
end
---------------------------------------------------------------------------------------------------------------------------------------------
function ENT:CustomOnThink()
	self:SetPoseParameter("smile",self:IsMoving() && 0.65 or self:Health() <= self:GetMaxHealth() *0.3 && 0 or 0.2)
	local idle = self.MetaVerseMode && ACT_IDLE_ANGRY or ACT_IDLE
	
	if self:Health() <= self:GetMaxHealth() *0.3 then
		idle = ACT_IDLE_STIMULATED
	end
	if IsValid(self:GetPersona()) then
		if self.PreparedToAttack then
			idle = VJ_SequenceToActivity(self,"persona_attack_start_idle")
		end
	end
	
	self:SetSkin(self.MetaVerseMode && IsValid(self:GetEnemy()) && 1 or 0)

	self.AnimTbl_IdleStand = {idle}

	self.DisableChasingEnemy = IsValid(self:GetPersona())
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
					self:SummonPersona("magatsu_izanagi")
					ParticleEffectAttach("jojo_aura_red",PATTACH_POINT_FOLLOW,self,self:LookupAttachment("origin"))
				end
			end
			if IsValid(self:GetEnemy()) && !self.VJ_IsBeingControlled then
				self:SummonPersona("magatsu_izanagi")
				ParticleEffectAttach("jojo_aura_red",PATTACH_POINT_FOLLOW,self,self:LookupAttachment("origin"))
			end
		elseif IsValid(self:GetPersona()) then
			-- self:SetBodygroup(1,0)
			if self.VJ_IsBeingControlled then
				local jump = self.VJ_TheController:KeyDown(IN_JUMP)
				if jump then
					self:SummonPersona("magatsu_izanagi")
				end
			end
			if !IsValid(self:GetEnemy()) && !self.VJ_IsBeingControlled then
				self:SummonPersona("magatsu_izanagi")
				-- self:SetBodygroup(1,1)
			end
			self:PersonaThink(self:GetPersona(),self:GetEnemy(),self:VJ_GetNearestPointToEntityDistance(self:GetEnemy()))
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