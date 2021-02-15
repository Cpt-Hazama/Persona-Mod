AddCSLuaFile("shared.lua")
include('shared.lua')
/*-----------------------------------------------
	*** Copyright (c) 2012-2019 by Cpt. Hazama, All rights reserved. ***
	No parts of this code or any of its contents may be reproduced, copied, modified or adapted,
	without the prior written consent of the author, unless otherwise indicated for stand-alone materials.
-----------------------------------------------*/
ENT.Stats = {
	HP = 40000,
	SP = 30000,
}
ENT.VJ_NPC_Class = {"CLASS_SHADOW"}

ENT.HasAltForm = false
---------------------------------------------------------------------------------------------------------------------------------------------
function ENT:PersonaInit()
	self:SetBodygroup(1,1)
	self.CurrentIndex = 1
	self.HasOkami = false
	self.VJ_NPC_Class = {"CLASS_SHADOW"}

	self:SetSubMaterial(0,"models/cpthazama/persona4/yu/face_shadow")
	ParticleEffectAttach("vj_per_shadow_idle",PATTACH_POINT_FOLLOW,self,self:LookupAttachment("origin"))
end
---------------------------------------------------------------------------------------------------------------------------------------------
function ENT:OnDisablePersona(persona)
	self.VJC_Data.ThirdP_Offset = Vector(-15, 40, -35)
	ParticleEffectAttach("vj_per_shadow_idle",PATTACH_POINT_FOLLOW,self,self:LookupAttachment("origin"))
end
/*-----------------------------------------------
	*** Copyright (c) 2012-2019 by Cpt. Hazama, All rights reserved. ***
	No parts of this code or any of its contents may be reproduced, copied, modified or adapted,
	without the prior written consent of the author, unless otherwise indicated for stand-alone materials.
-----------------------------------------------*/