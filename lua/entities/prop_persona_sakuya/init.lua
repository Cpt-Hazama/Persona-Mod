AddCSLuaFile("shared.lua")
include("shared.lua")

ENT.Stats = {
	LVL = 15, -- Innate level
	STR = 8, -- Effectiveness of phys. attacks
	MAG = 15, -- Effectiveness of magic. attacks
	END = 11, -- Effectiveness of defense
	AGI = 8, -- Effectiveness of hit and evasion rates
	LUC = 10, -- Chance of getting a critical
	WK = {DMG_P_ICE},
	RES = {DMG_P_FIRE}
}
---------------------------------------------------------------------------------------------------------------------------------------------
ENT.LeveledSkills = {
	{Level = 74, Name = "Salvation", Cost = 40, UsesHP = false, Icon = "heal"},
	{Level = 68, Name = "Maragidyne", Cost = 22, UsesHP = false, Icon = "fire"},
	{Level = 65, Name = "Mediarahan", Cost = 30, UsesHP = false, Icon = "heal"},
	{Level = 59, Name = "Samarecarm", Cost = 18, UsesHP = false, Icon = "heal"},
	{Level = 55, Name = "Diarahan", Cost = 18, UsesHP = false, Icon = "heal"},
	{Level = 51, Name = "Agidyne", Cost = 12, UsesHP = false, Icon = "fire"},
	{Level = 43, Name = "Mediarama", Cost = 12, UsesHP = false, Icon = "heal"},
	{Level = 39, Name = "Maragion", Cost = 16, UsesHP = false, Icon = "fire"},
	{Level = 33, Name = "Diarama", Cost = 6, UsesHP = false, Icon = "heal"},
	{Level = 30, Name = "Fire Break", Cost = 15, UsesHP = false, Icon = "passive"},
	{Level = 26, Name = "Recarm", Cost = 8, UsesHP = false, Icon = "heal"},
	{Level = 21, Name = "Agilao", Cost = 8, UsesHP = false, Icon = "fire"},
	{Level = 16, Name = "Media", Cost = 7, UsesHP = false, Icon = "heal"},
}
---------------------------------------------------------------------------------------------------------------------------------------------
ENT.LegendaryMaterials = {}
ENT.LegendaryMaterials[1] = "models/cpthazama/persona4/sakuya/sakuya1_legendary"
ENT.LegendaryMaterials[2] = "models/cpthazama/persona4/sakuya/sakuya3_legendary"
ENT.LegendaryMaterials[3] = "models/cpthazama/persona4/sakuya/sakuya2_legendary"
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
	self:AddCard("Dia",3,false,"heal")
	self:AddCard("Agi",4,false,"fire")
	self:AddCard("Me Patra",6,false,"passive")
	self:AddCard("Maragi",10,false,"fire")

	self:SetCard("Agi")
	self:SetCard("Cleave",true)

	local v = {forward=-250,right=120,up=100}
	self.User:SetNWVector("Persona_CustomPos",Vector(v.right,v.forward,v.up))
end