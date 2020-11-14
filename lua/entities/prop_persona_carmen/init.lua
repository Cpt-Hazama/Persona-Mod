AddCSLuaFile("shared.lua")
include("shared.lua")

ENT.Stats = {
	LVL = 5, -- Innate level
	STR = 3, -- Effectiveness of phys. attacks
	MAG = 6, -- Effectiveness of magic. attacks
	END = 4, -- Effectiveness of defense
	AGI = 4, -- Effectiveness of hit and evasion rates
	LUC = 5, -- Chance of getting a critical
	WK = {DMG_P_ICE,DMG_P_FROST},
	RES = {DMG_P_FIRE},
	NUL = {},
}
---------------------------------------------------------------------------------------------------------------------------------------------
ENT.LeveledSkills = {
	{Level = 74, Name = "Blazing Hell", Cost = 54, UsesHP = false, Icon = "fire"},
	{Level = 62, Name = "Concentrate", Cost = 15, UsesHP = false, Icon = "passive"},
	{Level = 57, Name = "Diarahan", Cost = 18, UsesHP = false, Icon = "heal"},
	{Level = 54, Name = "Maragidyne", Cost = 22, UsesHP = false, Icon = "fire"},
	{Level = 46, Name = "Agidyne", Cost = 12, UsesHP = false, Icon = "fire"},
	{Level = 41, Name = "Matarunda", Cost = 24, UsesHP = false, Icon = "passive"},
	{Level = 35, Name = "Maragion", Cost = 16, UsesHP = false, Icon = "fire"},
	{Level = 30, Name = "Lullaby", Cost = 8, UsesHP = false, Icon = "sleep"},
	{Level = 28, Name = "Diarama", Cost = 6, UsesHP = false, Icon = "heal"},
	{Level = 25, Name = "Fire Break", Cost = 15, UsesHP = false, Icon = "passive"},
	{Level = 22, Name = "Agilao", Cost = 8, UsesHP = false, Icon = "fire"},
	{Level = 16, Name = "Dekaja", Cost = 10, UsesHP = false, Icon = "passive"},
	{Level = 13, Name = "Maragi", Cost = 10, UsesHP = false, Icon = "fire"},
	{Level = 11, Name = "Tarunda", Cost = 8, UsesHP = false, Icon = "passive"},
	{Level = 7, Name = "Dormina", Cost = 3, UsesHP = false, Icon = "sleep"},
}
ENT.LegendaryMaterials = {}
ENT.LegendaryMaterials[1] = "models/cpthazama/persona5/carmen/carmen_legendary"
---------------------------------------------------------------------------------------------------------------------------------------------
function ENT:GetSpawnPosition(ply)
	return ply:GetPos() +ply:GetForward() *-85
end
---------------------------------------------------------------------------------------------------------------------------------------------
function ENT:GetIdlePosition(ply)
	return ply:GetPos() +ply:GetForward() *-85
end
---------------------------------------------------------------------------------------------------------------------------------------------
function ENT:OnSummoned(owner)	
	self:AddCard("Agi",4,false,"fire")
	self:AddCard("Dia",3,false,"heal")

	self:SetCard("Agi")

	local v = {forward=-200,right=80,up=50}
	self.User:SetNW2Vector("Persona_CustomPos",Vector(v.right,v.forward,v.up))
end