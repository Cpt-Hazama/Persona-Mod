AddCSLuaFile("shared.lua")
include('shared.lua')
/*-----------------------------------------------
	*** Copyright (c) 2012-2019 by Cpt. Hazama, All rights reserved. ***
	No parts of this code or any of its contents may be reproduced, copied, modified or adapted,
	without the prior written consent of the author, unless otherwise indicated for stand-alone materials.
-----------------------------------------------*/
ENT.Stats = {
	HP = 35000,
	SP = 45000,
}
ENT.VJ_NPC_Class = {"CLASS_ADACHI"}

ENT.Phase = 1
ENT.ChangingPhases = false
---------------------------------------------------------------------------------------------------------------------------------------------
function ENT:PersonaInit()
	self:SetBodygroup(1,1)
	self:SetSkin(1)

	self:Give("weapon_vj_persona_revolver_adachi")
	self.WeaponSpread = 1
	
	-- VJ_CreateSound(self,"cpthazama/vo/adachi/p4/btlmem [1216].wav",75)

	ParticleEffectAttach("vj_per_shadow_idle",PATTACH_POINT_FOLLOW,self,self:LookupAttachment("origin"))
end
---------------------------------------------------------------------------------------------------------------------------------------------
function ENT:OnDisablePersona(persona)
	ParticleEffectAttach("vj_per_shadow_idle",PATTACH_POINT_FOLLOW,self,self:LookupAttachment("origin"))
end
---------------------------------------------------------------------------------------------------------------------------------------------
function ENT:OnSwitchMetaVerse(didSwitch)
	self:SetSkin(1)
end
---------------------------------------------------------------------------------------------------------------------------------------------
function ENT:Dialogue(t,snd,cFunc)
	timer.Simple(t,function()
		if IsValid(self) then
			VJ_CreateSound(self,snd,75)
			if cFunc then
				cFunc(self)
			end
		end
	end)
end
---------------------------------------------------------------------------------------------------------------------------------------------
function ENT:OnThink()
	self:SetPoseParameter("smile",self:IsMoving() && 0.9 or 0)
	self:SetPoseParameter("anger",1)
	if self:Health() <= self:GetMaxHealth() *0.5 && self.Phase == 1 && self.ChangingPhases == false then
		self.ChangingPhases = true
		if IsValid(self:GetPersona()) then self:GetPersona():Remove() end
		self.DisablePersona = true
		self.GodMode = true
		self.AnimTbl_IdleStand = {ACT_IDLE_STIMULATED}
		self:VJ_ACT_PLAYACTIVITY(ACT_IDLE_STIMULATED,true,false)
		self:VJ_ACT_PLAYACTIVITY("persona_attack_start_idle",true,false)
		self:Dialogue(0.75,"cpthazama/vo/adachi/p4/btlmem [1212].wav")
		self:Dialogue(SoundDuration("cpthazama/vo/adachi/p4/btlmem [1212].wav") +1.2,"cpthazama/vo/adachi/p4/btlmem [1321].wav")
		self:Dialogue(SoundDuration("cpthazama/vo/adachi/p4/btlmem [1212].wav") +SoundDuration("cpthazama/vo/adachi/p4/btlmem [1321].wav") +3,"cpthazama/vo/adachi/p4/btlmem [1222].wav")
		self:Dialogue(SoundDuration("cpthazama/vo/adachi/p4/btlmem [1212].wav") +SoundDuration("cpthazama/vo/adachi/p4/btlmem [1321].wav") +SoundDuration("cpthazama/vo/adachi/p4/btlmem [1222].wav") +3,"cpthazama/vo/adachi/p4/btlmem [1323].wav")
		self:Dialogue(SoundDuration("cpthazama/vo/adachi/p4/btlmem [1212].wav") +SoundDuration("cpthazama/vo/adachi/p4/btlmem [1321].wav") +SoundDuration("cpthazama/vo/adachi/p4/btlmem [1222].wav") +SoundDuration("cpthazama/vo/adachi/p4/btlmem [1323].wav") +5,"cpthazama/vo/adachi/p4/btlmem [1225].wav")
		timer.Simple(25,function()
			if IsValid(self) then
				self:StopMoving()
				self.GodMode = false
				self.DisablePersona = false
				self.Phase = 2
			end
		end)
	end
end
/*-----------------------------------------------
	*** Copyright (c) 2012-2019 by Cpt. Hazama, All rights reserved. ***
	No parts of this code or any of its contents may be reproduced, copied, modified or adapted,
	without the prior written consent of the author, unless otherwise indicated for stand-alone materials.
-----------------------------------------------*/