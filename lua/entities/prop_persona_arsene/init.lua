AddCSLuaFile("shared.lua")
include("shared.lua")

ENT.Stats = {
	LVL = 1, -- Innate level
	STR = 2, -- Effectiveness of phys. attacks
	MAG = 2, -- Effectiveness of magic. attacks
	END = 2, -- Effectiveness of defense
	AGI = 3, -- Effectiveness of hit and evasion rates
	LUC = 1, -- Chance of getting a critical
	WK = {DMG_P_ICE,DMG_P_FROST,DMG_P_MIRACLE,DMG_P_CURSE},
	RES = {DMG_P_CURSE},
	NUL = {},
}
---------------------------------------------------------------------------------------------------------------------------------------------
ENT.LeveledSkills = {
	{Level = 34, Name = "Charge", Cost = 15, UsesHP = false, Icon = "passive"},
	{Level = 30, Name = "Maeigaon", Cost = 22, UsesHP = false, Icon = "curse"}, -- heavy, all
	{Level = 26, Name = "Brave Blade", Cost = 24, UsesHP = true, Icon = "phys"}, -- colossal, one
	{Level = 22, Name = "Eigaon", Cost = 12, UsesHP = false, Icon = "curse"}, -- heavy, one
	{Level = 18, Name = "Maeiga", Cost = 16, UsesHP = false, Icon = "curse"}, -- medium, all
	{Level = 13, Name = "Eiga", Cost = 8, UsesHP = false, Icon = "curse"}, -- medium, one
	{Level = 8, Name = "Maeiha", Cost = 10, UsesHP = false, Icon = "curse"}, -- light, all
	{Level = 5, Name = "Dream Needle", Cost = 8, UsesHP = true, Icon = "gun"} -- light, one, med. sleep
}
ENT.LegendaryMaterials = {}
ENT.LegendaryMaterials[1] = "models/cpthazama/persona5/arsene/arsene_legendary"
---------------------------------------------------------------------------------------------------------------------------------------------
function ENT:GetSpawnPosition(ply)
	return ply:GetPos() +ply:GetForward() *-45 +ply:GetUp() *25
end
---------------------------------------------------------------------------------------------------------------------------------------------
function ENT:GetIdlePosition(ply)
	return ply:GetPos() +ply:GetForward() *-45 +ply:GetUp() *25
end
---------------------------------------------------------------------------------------------------------------------------------------------
function ENT:OnSummoned(owner)	
	self:UserSound("cpthazama/persona5/joker/0313.wav",75,100)

	self:AddCard("Cleave",6,true,"phys")
	self:AddCard("Eiha",4,false,"curse")

	self:SetCard("Eiha")
	self:SetCard("Cleave",true)

	local v = {forward=-200,right=80,up=50}
	self.User:SetNW2Vector("Persona_CustomPos",Vector(v.right,v.forward,v.up))
end
---------------------------------------------------------------------------------------------------------------------------------------------
function ENT:OnRequestDisappear(ply)
	self:UserSound("cpthazama/persona5/joker/0" .. math.random(106,120) .. ".wav")
end