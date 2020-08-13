if (!file.Exists("autorun/vj_base_autorun.lua","LUA")) then return end
/*--------------------------------------------------
	*** Copyright (c) 2012-2020 by DrVrej, All rights reserved. ***
	No parts of this code or any of its contents may be reproduced, copied, modified or adapted,
	without the prior written consent of the author, unless otherwise indicated for stand-alone materials.
--------------------------------------------------*/
function EFFECT:Init(data)
	self.Pos = data:GetOrigin()
	self.Size = data:GetScale() or 15
	self.Roll = data:GetAttachment() or math.Rand(0,360)
	local Emitter = ParticleEmitter(self.Pos)
	if Emitter == nil then return end

	local EffectCode = Emitter:Add("effects/persona/bullet_slash2", self.Pos)
	-- EffectCode:SetVelocity(data:GetNormal() + 1.1 * data:GetEntity():GetOwner():GetVelocity())
	-- EffectCode:SetAirResistance(160)
	EffectCode:SetDieTime(0.2)
	EffectCode:SetStartAlpha(255)
	EffectCode:SetEndAlpha(0)
	EffectCode:SetStartSize(self.Size)
	EffectCode:SetEndSize(self.Size *2)
	EffectCode:SetRoll(self.Roll)
	EffectCode:SetRollDelta(math.Rand(-1, 1))
	EffectCode:SetColor(255,255,255)

	Emitter:Finish()
end
---------------------------------------------------------------------------------------------------------------------------------------------
function EFFECT:Think()
	return false
end
---------------------------------------------------------------------------------------------------------------------------------------------
function EFFECT:Render()
end
/*--------------------------------------------------
	*** Copyright (c) 2012-2020 by DrVrej, All rights reserved. ***
	No parts of this code or any of its contents may be reproduced, copied, modified or adapted,
	without the prior written consent of the author, unless otherwise indicated for stand-alone materials.
--------------------------------------------------*/
