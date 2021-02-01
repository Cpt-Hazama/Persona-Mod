AddCSLuaFile("shared.lua")
include('shared.lua')
/*-----------------------------------------------
	*** Copyright (c) 2012-2019 by Cpt. Hazama, All rights reserved. ***
	No parts of this code or any of its contents may be reproduced, copied, modified or adapted,
	without the prior written consent of the author, unless otherwise indicated for stand-alone materials.
-----------------------------------------------*/
ENT.Stats = {
	HP = 25000,
	SP = 45000,
}
ENT.VJ_NPC_Class = {"CLASS_SHADOW"}
ENT.HasAltForm = false

util.AddNetworkString("vj_persona_hud_adachi_shadow")
---------------------------------------------------------------------------------------------------------------------------------------------
function ENT:Controller_Initialize(ply)
    net.Start("vj_persona_hud_adachi_shadow")
		net.WriteBool(false)
		net.WriteEntity(self)
    net.Send(ply)

	function self.VJ_TheControllerEntity:CustomOnStopControlling()
		net.Start("vj_persona_hud_adachi_shadow")
			net.WriteBool(true)
			net.WriteEntity(self)
		net.Send(ply)
	end
end
---------------------------------------------------------------------------------------------------------------------------------------------
function ENT:PersonaInit()
	self:SetBodygroup(1,1)
	self:SetSkin(1)

	self:Give("weapon_vj_persona_revolver_adachi")
	self.WeaponSpread = 1

	for _,v in pairs(player.GetAll()) do
		if !IsValid(v:GetNW2Entity("VJ_Persona_ShadowBoss")) then
			v:SetNW2Entity("VJ_Persona_ShadowBoss",self)
		end
	end

	ParticleEffectAttach("vj_per_shadow_idle",PATTACH_POINT_FOLLOW,self,self:LookupAttachment("origin"))
end
---------------------------------------------------------------------------------------------------------------------------------------------
function ENT:OnDisablePersona(persona)
	ParticleEffectAttach("vj_per_shadow_idle",PATTACH_POINT_FOLLOW,self,self:LookupAttachment("origin"))
end
---------------------------------------------------------------------------------------------------------------------------------------------
function ENT:OnThink()
	self:SetPoseParameter("smile",self:IsMoving() && 0.9 or self:Health() <= self:GetMaxHealth() *0.4 && 0 or 0.75)
	if self:Health() <= self:GetMaxHealth() *0.4 then
		self:SetPoseParameter("anger",1)
	else
		self:SetPoseParameter("anger",0)
	end
	self:SetSkin(1)
end
---------------------------------------------------------------------------------------------------------------------------------------------
function ENT:CustomOnRemove()
	for _,v in pairs(player.GetAll()) do
		if IsValid(v:GetNW2Entity("VJ_Persona_ShadowBoss")) && v:GetNW2Entity("VJ_Persona_ShadowBoss") == self then
			v:SetNW2Entity("VJ_Persona_ShadowBoss",NULL)
		end
	end
end
/*-----------------------------------------------
	*** Copyright (c) 2012-2019 by Cpt. Hazama, All rights reserved. ***
	No parts of this code or any of its contents may be reproduced, copied, modified or adapted,
	without the prior written consent of the author, unless otherwise indicated for stand-alone materials.
-----------------------------------------------*/