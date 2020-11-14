ENT.Type 			= "anim"
ENT.Base 			= "obj_vj_projectile_base"
ENT.PrintName		= ""
ENT.Author 			= "Cpt. Hazama"
ENT.Contact 		= "http://steamcommunity.com/groups/vrejgaming"
ENT.Information		= "Projectiles for my addons"
ENT.Category		= "Projectiles"

if CLIENT then
	local col = Color(255,229,0)
	function ENT:Think()
		local Magatsu = self:GetNW2Bool("Magatsu")
		if Magatsu then
			col = Color(255,0,0)
		end
		self.Emitter = ParticleEmitter(self:GetPos())
		self.SmokeEffect1 = self.Emitter:Add("sprites/light_glow02_add",self:GetPos())
		self.SmokeEffect1:SetVelocity(self:GetForward() *math.Rand(0,50))
		self.SmokeEffect1:SetDieTime(0.1)
		self.SmokeEffect1:SetStartAlpha(100)
		self.SmokeEffect1:SetEndAlpha(0)
		self.SmokeEffect1:SetStartSize(20)
		self.SmokeEffect1:SetEndSize(5)
		self.SmokeEffect1:SetRoll(math.Rand(-0.2,0.2))
		self.SmokeEffect1:SetColor(col)
		self.Emitter:Finish()
	end
end