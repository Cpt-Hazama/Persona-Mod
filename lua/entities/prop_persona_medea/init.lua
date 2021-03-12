AddCSLuaFile("shared.lua")
include("shared.lua")

ENT.Stats = {
	LVL = 56, -- Innate level
	STR = 35, -- Effectiveness of phys. attacks
	MAG = 35, -- Effectiveness of magic. attacks
	END = 35, -- Effectiveness of defense
	AGI = 35, -- Effectiveness of hit and evasion rates
	LUC = 35, -- Chance of getting a critical
	WK = {},
	RES = {},
	NUL = {DMG_P_BLESS,DMG_P_MIRACLE,DMG_P_CURSE},
	ABS = {DMG_P_FIRE,DMG_BURN,DMG_P_BURN}
}
---------------------------------------------------------------------------------------------------------------------------------------------
ENT.LeveledSkills = {
	{Level = 64, Name = "Concentrate", Cost = COST_P_CONCENTRATE, UsesHP = false, Icon = "passive"},
	{Level = 60, Name = "Maragidyne", Cost = COST_P_MARAGIDYNE, UsesHP = false, Icon = "fire"},
}
---------------------------------------------------------------------------------------------------------------------------------------------
ENT.LegendaryMaterials = {}
ENT.LegendaryMaterials[1] = "models/cpthazama/persona3/medea/medea01_legendary"
ENT.LegendaryMaterials[2] = "models/cpthazama/persona3/medea/medea02_legendary"
ENT.LegendaryMaterials[3] = "models/cpthazama/persona3/medea/medea00_legendary"
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
	self:AddCard("Ghastly Wail",COST_P_GHASTLY_WAIL,true,"almighty")
	self:AddCard("Agidyne",COST_P_AGIDYNE,false,"fire")
	-- self:AddCard("Maragidyne",COST_P_MARAGIDYNE,false,"fire")
	self:AddCard("Mamudoon",COST_P_MAMUDOON,false,"curse")
	self:AddCard("Debilitate",COST_P_DEBILITATE,false,"passive")
	-- self:AddCard("Concentrate",COST_P_CONCENTRATE,false,"passive")
	self:AddCard("Diarama",COST_P_DIARAMA,false,"heal")

	self:SetCard("Agidyne")
	self:SetCard("Ghastly Wail",true)

	local v = {forward=-200,right=80,up=50}
	self.User:SetNW2Vector("Persona_CustomPos",Vector(v.right,v.forward,v.up))
	
	self:UserSound("cpthazama/persona5/joker/0" .. math.random(159,162) .. ".wav")
end