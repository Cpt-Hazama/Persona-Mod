function EFFECT:Init(data)
	local origin = data:GetOrigin()
	local scale = data:GetScale()
	
	self.Emitter = ParticleEmitter(origin)
	local dir = origin:Angle()
	for buzz = 0,30 do
		local Mist = self.Emitter:Add("particle/particle_noisesphere",origin)
		if (Mist) then
			dir = dir +Angle(0,15,0)
			Mist:SetVelocity(dir:Forward() *60)
			Mist:SetDieTime(1)
			Mist:SetStartAlpha(240)
			Mist:SetEndAlpha(0)
			Mist:SetStartSize(scale/2)
			Mist:SetEndSize(scale)
			Mist:SetRoll(1)
			Mist:SetRollDelta(0)
			Mist:SetAirResistance(1)
			Mist:SetGravity(Vector(0,0,5))
			Mist:SetColor(Color(255,223,127))
		end
	end
end
---------------------------------------------------------------------------------------------------------------------------------------------
function EFFECT:Think()
	return false
end
---------------------------------------------------------------------------------------------------------------------------------------------
function EFFECT:Render() end