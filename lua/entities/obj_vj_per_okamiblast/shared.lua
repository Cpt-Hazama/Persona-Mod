ENT.Type 			= "anim"
ENT.Base 			= "obj_vj_projectile_base"
ENT.PrintName		= ""
ENT.Author 			= "Cpt. Hazama"
ENT.Contact 		= "http://steamcommunity.com/groups/vrejgaming"
ENT.Information		= "Projectiles for my addons"
ENT.Category		= "Projectiles"

if CLIENT then
	function ENT:Think()
		self.Emitter = ParticleEmitter(self:GetPos())
		self.SmokeEffect1 = self.Emitter:Add("sprites/light_glow02_add",self:GetPos())
		self.SmokeEffect1:SetVelocity(self:GetForward() *math.Rand(0,50))
		self.SmokeEffect1:SetDieTime(0.1)
		self.SmokeEffect1:SetStartAlpha(100)
		self.SmokeEffect1:SetEndAlpha(0)
		self.SmokeEffect1:SetStartSize(20)
		self.SmokeEffect1:SetEndSize(5)
		self.SmokeEffect1:SetRoll(math.Rand(-0.2,0.2))
		self.SmokeEffect1:SetColor(255,229,0)
		self.Emitter:Finish()
	end
end