if (!file.Exists("autorun/vj_base_autorun.lua","LUA")) then return end
/*--------------------------------------------------
	*** Copyright (c) 2012-2021 by Cpt. Hazama, All rights reserved. ***
	No parts of this code or any of its contents may be reproduced, copied, modified or adapted,
	without the prior written consent of the author, unless otherwise indicated for stand-alone materials.
--------------------------------------------------*/
function EFFECT:Init(data)
	self.Pos = data:GetOrigin()
	-- self.Dir = data:GetStart()
	self.Ent = data:GetEntity()
	local Emitter = ParticleEmitter(self.Pos)
	if Emitter == nil then return end

	local pos,ang = self.Ent:GetBonePosition(self.Ent:LookupBone("rot_head"))
	ang = ang +Angle(90,100,0)
	for i = 1,60 do
		local EffectCode = Emitter:Add("effects/persona/evoker_fx",self.Pos)
		EffectCode:SetVelocity(ang:Right() *500 +VectorRand() *200)
		-- EffectCode:SetVelocity(pos +ang:Forward() *500 +VectorRand() *100)
		-- EffectCode:SetVelocity(self.Dir +self.Dir:Angle():Forward() *50)
		EffectCode:SetAirResistance(200)
		EffectCode:SetDieTime(0.75)
		EffectCode:SetStartAlpha(255)
		EffectCode:SetEndAlpha(0)
		EffectCode:SetStartSize(math.random(1,5))
		EffectCode:SetEndSize(math.random(0,3))
		EffectCode:SetRoll(math.Rand(0,360))
		EffectCode:SetRollDelta(math.Rand(-1,1))
		EffectCode:SetColor(255,255,255)
	end

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
	*** Copyright (c) 2012-2021 by Cpt. Hazama, All rights reserved. ***
	No parts of this code or any of its contents may be reproduced, copied, modified or adapted,
	without the prior written consent of the author, unless otherwise indicated for stand-alone materials.
--------------------------------------------------*/
