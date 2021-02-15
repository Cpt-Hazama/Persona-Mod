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
	sound.Play("cpthazama/persona5/skills/0706.wav",self.StartPos,150,100,1)

	self.DieTime = CurTime() +3
end
---------------------------------------------------------------------------------------------------------------------------------------------
function EFFECT:Think()
	if (CurTime() > self.DieTime) then
		return false
	end
	local Emitter = ParticleEmitter(self.StartPos)
	local EffectCode = Emitter:Add("effects/bluemuzzle",self.StartPos)
	EffectCode:SetDieTime(0.25)
	EffectCode:SetStartAlpha(255)
	EffectCode:SetEndAlpha(255)
	EffectCode:SetStartSize(math.random(40,80))
	EffectCode:SetEndSize(math.random(40,80))
	EffectCode:SetRoll(math.Rand(0,360))
	EffectCode:SetRollDelta(math.Rand(-1,1))
	EffectCode:SetColor(255,255,255)
	Emitter:Finish()
	return true
end
---------------------------------------------------------------------------------------------------------------------------------------------
function EFFECT:Render() end
/*--------------------------------------------------
	*** Copyright (c) 2012-2021 by Cpt. Hazama, All rights reserved. ***
	No parts of this code or any of its contents may be reproduced, copied, modified or adapted,
	without the prior written consent of the author, unless otherwise indicated for stand-alone materials.
--------------------------------------------------*/