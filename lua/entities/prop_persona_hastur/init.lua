AddCSLuaFile("shared.lua")
include("shared.lua")

ENT.Stats = {
	LVL = 84, -- Innate level
	STR = 78, -- Effectiveness of phys. attacks
	MAG = 99, -- Effectiveness of magic. attacks
	END = 58, -- Effectiveness of defense
	AGI = 57, -- Effectiveness of hit and evasion rates
	LUC = 54, -- Chance of getting a critical
	WK = {},
	RES = {DMG_P_FIRE,DMG_BURN,DMG_P_BURN},
	NUL = {DMG_P_PSI,DMG_P_PSY},
	ABS = {DMG_P_WIND}
}
---------------------------------------------------------------------------------------------------------------------------------------------
ENT.LegendaryMaterials = {}
ENT.LegendaryMaterials[1] = "models/cpthazama/persona5/hastur/hastur_legendary"
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
	self:AddCard("Abyssal Eye",50,false,"almighty")
	self:AddCard("Vacuum Wave",48,false,"wind")
	self:AddCard("Concentrate",COST_P_CONCENTRATE,false,"passive")
	self:AddCard("Nocturnal Flash",8,false,"sleep")

	self:SetCard("Abyssal Eye")

	local v = {forward=-200,right=80,up=50}
	self.User:SetNW2Vector("Persona_CustomPos",Vector(v.right,v.forward,v.up))
end