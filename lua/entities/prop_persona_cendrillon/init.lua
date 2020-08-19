AddCSLuaFile("shared.lua")
include("shared.lua")

ENT.Stats = {
	LVL = 75, -- Innate level
	STR = 55, -- Effectiveness of phys. attacks
	MAG = 46, -- Effectiveness of magic. attacks
	END = 36, -- Effectiveness of defense
	AGI = 51, -- Effectiveness of hit and evasion rates
	LUC = 44, -- Chance of getting a critical
	WK = {DMG_P_CURSE},
	RES = {},
	NUL = {DMG_P_BLESS,DMG_P_MIRACLE},
}
---------------------------------------------------------------------------------------------------------------------------------------------
ENT.LeveledSkills = {
	{Level = 82, Name = "Heat Riser", Cost = 30, UsesHP = false, Icon = "passive"},
	{Level = 80, Name = "Brave Step", Cost = 16, UsesHP = false, Icon = "passive"},
	{Level = 77, Name = "Makougaon", Cost = 22, UsesHP = false, Icon = "bless"}
}
ENT.LegendaryMaterials = {}
ENT.LegendaryMaterials[1] = "models/cpthazama/persona5/cendrillon/misc_legendary"
ENT.LegendaryMaterials[2] = "models/cpthazama/persona5/cendrillon/cendrillon_legendary"
ENT.LegendaryMaterials[3] = "models/cpthazama/persona5/cendrillon/cendrillon_armor_legendary"
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
	self:AddCard("Vorpal Blade",23,true,"phys")
	self:AddCard("Sword Dance",21,true,"phys")
	self:AddCard("Kougaon",12,false,"bless")
	-- self:AddCard("Makougaon",22,false,"bless")
	self:AddCard("Diarahan",18,false,"heal")
	-- self:AddCard("Brave Step",16,false,"passive")
	-- self:AddCard("Heat Riser",30,false,"passive")

	self:SetCard("Kougaon")
	self:SetCard("Vorpal Blade",true)

	local v = {forward=-200,right=80,up=50}
	self.User:SetNWVector("Persona_CustomPos",Vector(v.right,v.forward,v.up))
end