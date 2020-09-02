AddCSLuaFile("shared.lua")
include("shared.lua")

ENT.Stats = {
	LVL = 99, -- Innate level
	STR = 70, -- Effectiveness of phys. attacks
	MAG = 61, -- Effectiveness of magic. attacks
	END = 60, -- Effectiveness of defense
	AGI = 62, -- Effectiveness of hit and evasion rates
	LUC = 51, -- Chance of getting a critical
	WK = {DMG_P_BLESS,DMG_P_MIRACLE},
	RES = {DMG_P_PSI,DMG_P_PSY},
	NUL = {DMG_P_CURSE},
	ABS = {}
}
---------------------------------------------------------------------------------------------------------------------------------------------
ENT.LegendaryMaterials = {}
ENT.LegendaryMaterials[1] = "models/cpthazama/persona5/hereward/hereward_legendary"
ENT.LegendaryMaterials[2] = "models/cpthazama/persona5/hereward/scarf_legendary"
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
function ENT:OnSummoned(owner)
	self:AddCard("Laevateinn",25,true,"phys")
	self:AddCard("Megidolaon",38,false,"almighty")
	self:AddCard("Rebellion Blade",99,false,"almighty")
	self:AddCard("Eigaon",12,false,"curse")
	self:AddCard("Debilitate",30,false,"passive")

	self:SetCard("Megidolaon")
	self:SetCard("Laevateinn",true)

	local v = {forward=-200,right=80,up=50}
	self.User:SetNWVector("Persona_CustomPos",Vector(v.right,v.forward,v.up))
end
---------------------------------------------------------------------------------------------------------------------------------------------
function ENT:OnRequestDisappear(ply)
	
end