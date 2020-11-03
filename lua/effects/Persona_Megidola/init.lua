if (!file.Exists("autorun/vj_base_autorun.lua","LUA")) then return end
/*--------------------------------------------------
	*** Copyright (c) 2012-2021 by Cpt. Hazama, All rights reserved. ***
	No parts of this code or any of its contents may be reproduced, copied, modified or adapted,
	without the prior written consent of the author, unless otherwise indicated for stand-alone materials.
--------------------------------------------------*/
-- Based off of the GMod lasertracer
EFFECT.MainMat = Material("effects/blueblacklargebeam")

function EFFECT:Init(data)
	self.StartPos = data:GetStart()
	self.EndPos = data:GetOrigin()
	self.Target = data:GetEntity()

	self.HitPos = self.EndPos -self.StartPos
	self.DieTime = CurTime() +3
	self:SetRenderBoundsWS(self.StartPos,self.EndPos)

	local Emitter = ParticleEmitter(self.StartPos)
	local EffectCode = Emitter:Add("effects/bluemuzzle",self.StartPos)
	EffectCode:SetDieTime(3)
	EffectCode:SetStartAlpha(255)
	EffectCode:SetEndAlpha(230)
	EffectCode:SetStartSize(60)
	EffectCode:SetEndSize(45)
	EffectCode:SetRoll(math.Rand(0,360))
	EffectCode:SetRollDelta(math.Rand(-1,1))
	EffectCode:SetColor(255,255,255)
	
	timer.Simple(0.8,function()
		if IsValid(self) then
			self:EmitSound("cpthazama/persona5/skills/0073.wav",85)
		end
	end)
	
	timer.Simple(2,function()
		if IsValid(self) then
			self:EmitSound("cpthazama/persona5/skills/0071.wav",85)
		end
	end)
end
---------------------------------------------------------------------------------------------------------------------------------------------
function EFFECT:Think()
	if IsValid(self.Target) then
		self.EndPos = self.Target:GetPos() +self.Target:OBBCenter()
	end
	if (CurTime() > self.DieTime) then
		return false
	end
	return true
end
---------------------------------------------------------------------------------------------------------------------------------------------
function EFFECT:Render()
	render.SetMaterial(self.MainMat)
	render.DrawBeam(self.StartPos,self.EndPos,math.Rand(18,24),math.Rand(0,1),math.Rand(0,1) +((self.StartPos -self.EndPos):Length() /128),Color(255,255,255,(50 /((self.DieTime -0.5) -CurTime()))))
end
/*--------------------------------------------------
	*** Copyright (c) 2012-2021 by Cpt. Hazama, All rights reserved. ***
	No parts of this code or any of its contents may be reproduced, copied, modified or adapted,
	without the prior written consent of the author, unless otherwise indicated for stand-alone materials.
--------------------------------------------------*/