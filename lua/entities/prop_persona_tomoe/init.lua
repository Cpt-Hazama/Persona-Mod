AddCSLuaFile("shared.lua")
include("shared.lua")

ENT.Stats = {
	LVL = 6, -- Innate level
	STR = 5, -- Effectiveness of phys. attacks
	MAG = 5, -- Effectiveness of magic. attacks
	END = 6, -- Effectiveness of defense
	AGI = 3, -- Effectiveness of hit and evasion rates
	LUC = 4, -- Chance of getting a critical
	WK = {DMG_P_FIRE},
	RES = {DMG_P_ICE}
}
---------------------------------------------------------------------------------------------------------------------------------------------
ENT.Animations = {}
ENT.Animations["idle"] = "idle"
ENT.Animations["idle_low"] = "idle"
ENT.Animations["melee"] = "attack"
ENT.Animations["range"] = "range_single"
---------------------------------------------------------------------------------------------------------------------------------------------
ENT.LeveledSkills = {
	{Level = 74, Name = "Agneyastra", Cost = 24, UsesHP = true, Icon = "phys"},
	{Level = 70, Name = "God's Hand", Cost = 22, UsesHP = true, Icon = "phys"},
	{Level = 67, Name = "Rainy Death", Cost = 20, UsesHP = true, Icon = "phys"},
	{Level = 52, Name = "Charge", Cost = 15, UsesHP = false, Icon = "passive"},
	{Level = 46, Name = "Heat Wave", Cost = 16, UsesHP = true, Icon = "phys"},
	{Level = 38, Name = "Black Spot", Cost = 16, UsesHP = true, Icon = "phys"},
	{Level = 33, Name = "Bufula", Cost = 8, UsesHP = false, Icon = "frost"},
	{Level = 29, Name = "Gale Slash", Cost = 12, UsesHP = true, Icon = "phys"},
	{Level = 22, Name = "Assault Dive", Cost = 9, UsesHP = true, Icon = "phys"},
	{Level = 20, Name = "Rampage", Cost = 12, UsesHP = true, Icon = "phys"},
	{Level = 14, Name = "Mabufu", Cost = 10, UsesHP = false, Icon = "frost"},
	{Level = 11, Name = "Skull Cracker", Cost = 9, UsesHP = true, Icon = "phys"},
	{Level = 7, Name = "Bufu", Cost = 4, UsesHP = false, Icon = "frost"}
}
---------------------------------------------------------------------------------------------------------------------------------------------
ENT.LegendaryMaterials = {}
ENT.LegendaryMaterials[1] = "models/cpthazama/persona4/tomoe/tomoe1_legendary"
ENT.LegendaryMaterials[2] = "models/cpthazama/persona4/tomoe/tomoe2_legendary"
ENT.LegendaryMaterials[3] = "models/cpthazama/persona4/tomoe/tomoe3_legendary"
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
	self:AddCard("Cleave",5,true,"phys")
	self:AddCard("Tarukaja",12,false,"passive")

	self:SetCard("Tarukaja")
	self:SetCard("Cleave",true)

	local v = {forward=-200,right=80,up=50}
	self.User:SetNW2Vector("Persona_CustomPos",Vector(v.right,v.forward,v.up))
end