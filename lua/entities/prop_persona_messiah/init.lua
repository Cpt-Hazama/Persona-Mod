AddCSLuaFile("shared.lua")
include("shared.lua")

ENT.Stats = {
	LVL = 90, -- Innate level
	STR = 79, -- Effectiveness of phys. attacks
	MAG = 93, -- Effectiveness of magic. attacks
	END = 64, -- Effectiveness of defense
	AGI = 77, -- Effectiveness of hit and evasion rates
	LUC = 81, -- Chance of getting a critical
	WK = {DMG_P_CURSE},
	RES = {DMG_P_FIRE,DMG_BURN,DMG_P_ICE,DMG_P_ELEC,DMG_SHOCK,DMG_P_WIND,DMG_P_PSI,DMG_P_PSY,DMG_P_NUCLEAR},
	NUL = {},
	REF = {DMG_P_BLESS,DMG_P_MIRACLE},
	ABS = {}
}
---------------------------------------------------------------------------------------------------------------------------------------------
ENT.LegendaryMaterials = {}
ENT.LegendaryMaterials[1] = "models/cpthazama/persona3/messiah/messiah_legendary"
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
	self:UserSound("cpthazama/persona5/joker/0033.wav",75,100)

	self:AddCard("God's Hand",25,true,"phys")
	self:AddCard("Megidolaon",COST_P_MEGIDOLAON,false,"almighty")
	self:AddCard("Salvation",COST_P_SALVATION,false,"heal")

	self:SetCard("Megidolaon")
	self:SetCard("God's Hand",true)

	local v = {forward=-200,right=80,up=50}
	self.User:SetNWVector("Persona_CustomPos",Vector(v.right,v.forward,v.up))
end
---------------------------------------------------------------------------------------------------------------------------------------------
function ENT:OnRequestDisappear(ply)
	self:UserSound("cpthazama/persona5/joker/0" .. math.random(106,120) .. ".wav")
end