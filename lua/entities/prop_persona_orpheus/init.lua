AddCSLuaFile("shared.lua")
include("shared.lua")

ENT.Stats = {
	LVL = 29, -- Innate level
	STR = 19, -- Effectiveness of phys. attacks
	MAG = 19, -- Effectiveness of magic. attacks
	END = 19, -- Effectiveness of defense
	AGI = 19, -- Effectiveness of hit and evasion rates
	LUC = 19, -- Chance of getting a critical
	WK = {DMG_P_ELEC,DMG_SHOCK,DMG_P_CURSE},
	RES = {DMG_P_BLESS,DMG_P_MIRACLE},
	NUL = {},
	ABS = {}
}
---------------------------------------------------------------------------------------------------------------------------------------------
ENT.LegendaryMaterials = {}
ENT.LegendaryMaterials[1] = "models/cpthazama/persona3/orpheus/orpheus_legendary"
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
	self:UserSound("cpthazama/persona5/joker/0001.wav",75,100)

	self:AddCard("Bash",7,true,"phys")
	self:AddCard("Agidyne",COST_P_AGIDYNE,false,"fire")
	self:AddCard("Maragion",16,false,"fire")
	self:AddCard("Debilitate",COST_P_DEBILITATE,false,"passive")
	self:AddCard("Cadenza",24,false,"heal")

	self:SetCard("Agidyne")
	self:SetCard("Bash",true)

	local v = {forward=-200,right=80,up=50}
	self.User:SetNWVector("Persona_CustomPos",Vector(v.right,v.forward,v.up))
end
---------------------------------------------------------------------------------------------------------------------------------------------
function ENT:OnRequestDisappear(ply)
	self:UserSound("cpthazama/persona5/joker/0" .. math.random(106,120) .. ".wav")
end