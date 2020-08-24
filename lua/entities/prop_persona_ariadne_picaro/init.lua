AddCSLuaFile("shared.lua")
include("shared.lua")

ENT.Stats = {
	LVL = 42, -- Innate level
	STR = 36, -- Effectiveness of phys. attacks
	MAG = 23, -- Effectiveness of magic. attacks
	END = 29, -- Effectiveness of defense
	AGI = 24, -- Effectiveness of hit and evasion rates
	LUC = 21, -- Chance of getting a critical
	WK = {DMG_P_PSI},
	RES = {DMG_P_GUN,DMG_P_BLESS,DMG_P_MIRACLE,DMG_BULLET,DMG_BUCKSHOT},
	NUL = {DMG_P_NUCLEAR},
}
---------------------------------------------------------------------------------------------------------------------------------------------
ENT.LeveledSkills = {
	{Level = 48, Name = "Charge", Cost = 15, UsesHP = false, Icon = "passive"}
}
ENT.LegendaryMaterials = {}
ENT.LegendaryMaterials[1] = "models/cpthazama/persona5/ariadne_picaro/ariadne_picaro_legendary"
---------------------------------------------------------------------------------------------------------------------------------------------
function ENT:HandleEvents(skill,animBlock,seq,t)
	local ply = self.User
	if animBlock == "melee" then
		self:UserSound("cpthazama/persona5/joker/00" .. math.random(23,24) .. ".wav")
		timer.Simple(1.28,function()
			if IsValid(self) then
				self:SetBodygroup(3,1)
				self:SetBodygroup(4,1)
				self:EmitSound("cpthazama/persona5/skills/0222.wav",80)
			end
		end)
		timer.Simple(1.9,function()
			if IsValid(self) then
				self:SetBodygroup(3,0)
				self:SetBodygroup(4,0)
			end
		end)
	end
	if animBlock == "range_start" then
		timer.Simple(1.7,function()
			if IsValid(self) then
				self:SetBodygroup(2,1)
				self:EmitSound("cpthazama/persona5/skills/0375.wav",80)
			end
		end)
		timer.Simple(2.3,function()
			if IsValid(self) then
				self:SetBodygroup(2,0)
			end
		end)
	end
end
---------------------------------------------------------------------------------------------------------------------------------------------
function ENT:GetSpawnPosition(ply)
	return ply:GetPos() +ply:GetForward() *-60
end
---------------------------------------------------------------------------------------------------------------------------------------------
function ENT:GetIdlePosition(ply)
	return ply:GetPos() +ply:GetForward() *-60
end
---------------------------------------------------------------------------------------------------------------------------------------------
function ENT:GetAttackPosition()
	return self.AttackPosition or self:GetPos() +self:OBBCenter()
end
---------------------------------------------------------------------------------------------------------------------------------------------
function ENT:CustomOnHitEntity(entities,dmginfo)
	if self.CurrentMeleeSkill == "Beast Weaver" then
		for _,v in pairs(entities) do
			if IsValid(v) then
				v:EmitSound("cpthazama/persona5/skills/0211.wav",80)
				self.TarundaT = CurTime() +60
			end
		end
	end
end
---------------------------------------------------------------------------------------------------------------------------------------------
function ENT:PersonaControls(ply,persona)
	if CurTime() > self.HeatUpT then
		self.User:SetHealth(math.Clamp(self.User:Health() +(self.User:GetMaxHealth() *0.05),1,self.User:GetMaxHealth()))
		self.User:SetSP(math.Clamp(self.User:GetSP() +10,0,999))
		self.User:EmitSound("cpthazama/persona5/skills/0417.wav",65)
		self.HeatUpT = CurTime() +30
	end
end
---------------------------------------------------------------------------------------------------------------------------------------------
function ENT:OnSummoned(owner)	
	self:AddCard("Beast Weaver",20,true,"phys")
	self:AddCard("Miracle Punch",8,true,"phys")
	self:AddCard("Mediarahan",30,false,"heal")

	self:SetCard("Mediarahan")
	self:SetCard("Beast Weaver",true)

	local v = {forward=-200,right=80,up=50}
	self.User:SetNWVector("Persona_CustomPos",Vector(v.right,v.forward,v.up))
end
---------------------------------------------------------------------------------------------------------------------------------------------
function ENT:CustomOnInitialize()
	self.HeatUpT = CurTime() +30
end
---------------------------------------------------------------------------------------------------------------------------------------------
function ENT:RequestAura(ply,aura)
	self:UserSound("cpthazama/persona5/joker/0022.wav",75,100)
	ParticleEffectAttach(aura == "jojo_aura_red" && "vj_per_idle_chains_evil" or "vj_per_idle_chains",PATTACH_POINT_FOLLOW,self,self:LookupAttachment("origin"))
	ParticleEffectAttach(aura,PATTACH_POINT_FOLLOW,self,self:LookupAttachment("origin"))
	ParticleEffectAttach(aura,PATTACH_POINT_FOLLOW,ply,ply:LookupAttachment("origin"))
	local fx = EffectData()
	fx:SetOrigin(self:GetIdlePosition(ply))
	fx:SetScale(80)
	util.Effect("JoJo_Summon",fx)
end
---------------------------------------------------------------------------------------------------------------------------------------------
function ENT:OnRequestDisappear(ply)
	self:UserSound("cpthazama/persona5/joker/0" .. math.random(106,120) .. ".wav")
end