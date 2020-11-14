AddCSLuaFile("shared.lua")
include("shared.lua")

ENT.Stats = {
	LVL = 79, -- Innate level
	STR = 43, -- Effectiveness of phys. attacks
	MAG = 59, -- Effectiveness of magic. attacks
	END = 40, -- Effectiveness of defense
	AGI = 57, -- Effectiveness of hit and evasion rates
	LUC = 45, -- Chance of getting a critical
	WK = {DMG_P_MIRACLE,DMG_P_BLESS},
	RES = {DMG_P_PSY,DMG_P_PSI,DMG_P_NUCLEAR},
	REF = {DMG_P_CURSE},
}
---------------------------------------------------------------------------------------------------------------------------------------------
ENT.LeveledSkills = {
	{Level = 87, Name = "Concentrate", Cost = 15, UsesHP = false, Icon = "passive"},
	{Level = 86, Name = "Megidolaon", Cost = 38, UsesHP = false, Icon = "almighty"},
	{Level = 85, Name = "Die For Me!", Cost = 40, UsesHP = false, Icon = "almighty"},
}
ENT.LegendaryMaterials = {}
ENT.LegendaryMaterials[1] = "models/cpthazama/persona5/alice/alice_legendary"
---------------------------------------------------------------------------------------------------------------------------------------------
function ENT:GetSpawnPosition(ply)
	return ply:GetPos() +ply:GetForward() *45
end
---------------------------------------------------------------------------------------------------------------------------------------------
function ENT:GetIdlePosition(ply)
	return ply:GetPos() +ply:GetForward() *45
end
---------------------------------------------------------------------------------------------------------------------------------------------
function ENT:OnSummoned(owner)	
	self:UserSound("cpthazama/persona5/joker/0216.wav",75,100)

	self:AddCard("Terror Claw",8,true,"phys") -- 50% Inflict Fear
	self:AddCard("Maeigaon",22,false,"curse")
	self:AddCard("Mamudoon",26,false,"curse")

	self:SetCard("Mamudoon")
	self:SetCard("Terror Claw",true)

	local v = {forward=-35,right=30,up=0}
	self.User:SetNW2Vector("Persona_CustomPos",Vector(v.right,v.forward,v.up))
end
---------------------------------------------------------------------------------------------------------------------------------------------
function ENT:OnRequestDisappear(ply)
	self:UserSound("cpthazama/persona5/joker/0" .. math.random(106,120) .. ".wav")
end