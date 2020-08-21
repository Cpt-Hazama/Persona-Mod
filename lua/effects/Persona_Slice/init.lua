if (!file.Exists("autorun/vj_base_autorun.lua","LUA")) then return end
/*--------------------------------------------------
	*** Copyright (c) 2012-2020 by DrVrej, All rights reserved. ***
	No parts of this code or any of its contents may be reproduced, copied, modified or adapted,
	without the prior written consent of the author, unless otherwise indicated for stand-alone materials.
--------------------------------------------------*/
-- Based off of the GMod lasertracer
EFFECT.MainMat = Material("effects/persona/slice")

function EFFECT:Init(data)
	self.StartPos = data:GetStart()
	self.EndPos = data:GetOrigin()
	self.Width = data:GetRadius() or math.random(4,8)
	self.Colors = data:GetAngles() or Angle(100,250,255)
	self.Time = data:GetHitBox() or 0.6
	
	self.HitPos = self.EndPos -self.StartPos
	self.DieTime = CurTime() +self.Time
	self:SetRenderBoundsWS(self.StartPos,self.EndPos)
end
---------------------------------------------------------------------------------------------------------------------------------------------
function EFFECT:Think()
	if (CurTime() > self.DieTime) then
		return false
	end
	return true
end
---------------------------------------------------------------------------------------------------------------------------------------------
function EFFECT:Render()
	render.SetMaterial(self.MainMat)
	render.DrawBeam(self.StartPos,self.EndPos,self.Width,math.Rand(0,1),math.Rand(0,1) +((self.StartPos -self.EndPos):Length() /128),Color(self.Colors.x,self.Colors.y,self.Colors.z,(10 /((self.DieTime -self.Time -0.1) -CurTime()))))
end
/*--------------------------------------------------
	*** Copyright (c) 2012-2020 by DrVrej, All rights reserved. ***
	No parts of this code or any of its contents may be reproduced, copied, modified or adapted,
	without the prior written consent of the author, unless otherwise indicated for stand-alone materials.
--------------------------------------------------*/