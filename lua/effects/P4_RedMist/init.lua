function EFFECT:Init(data)
	local origin = data:GetOrigin()
	local scale = data:GetScale()
	local time = data:GetAttachment() or 10
	
	self.Emitter = ParticleEmitter(origin)
	for buzz = 0,6 do
		local Mist = self.Emitter:Add("particle/smokesprites_000"..math.random(1,9),origin)
		if (Mist) then
			local out = 5
			Mist:SetVelocity(Vector(math.random(-out,out),math.random(-out,out),math.random(-10,5)))
			Mist:SetDieTime(time)
			Mist:SetStartAlpha(255)
			Mist:SetEndAlpha(0)
			Mist:SetStartSize(scale /2)
			Mist:SetEndSize(scale)
			Mist:SetRoll(1)
			Mist:SetRollDelta(0)
			Mist:SetAirResistance(1)
			Mist:SetGravity(Vector(0,0,math.Rand(0.2,1)))
			Mist:SetColor(255,0,0)
		end
	end
end

function EFFECT:Think()
	return false
end

function EFFECT:Render() end