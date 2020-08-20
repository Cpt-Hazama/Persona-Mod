AddCSLuaFile("shared.lua")
include("shared.lua")

ENT.Stats = {
	LVL = 75, -- Innate level
	STR = 45, -- Effectiveness of phys. attacks
	MAG = 60, -- Effectiveness of magic. attacks
	END = 45, -- Effectiveness of defense
	AGI = 45, -- Effectiveness of hit and evasion rates
	LUC = 50, -- Chance of getting a critical
	WK = {},
	RES = {DMG_P_BLESS,DMG_P_MIRACLE},
	NUL = {DMG_P_CURSE},
}
ENT.LegendaryMaterials = {}
ENT.LegendaryMaterials[1] = "models/cpthazama/persona3/hypnos/hypnos_legendary"
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
	self:AddCard("Riot Gun",COST_P_RIOT_GUN,true,"gun")
	self:AddCard("Agidyne",COST_P_AGIDYNE,false,"fire")
	self:AddCard("Bufudyne",COST_P_BAFUDYNE,false,"frost")
	self:AddCard("Ziodyne",COST_P_ZIODYNE,false,"elec")
	self:AddCard("Garudyne",COST_P_GARUDYNE,false,"wind")
	self:AddCard("Mahamaon",COST_P_MAHAMAON,false,"bless")
	self:AddCard("Mamudoon",COST_P_MAMUDOON,false,"curse")
	self:AddCard("Megidola",COST_P_MEGIDOLA,false,"almighty")
	self:AddCard("Megidolaon",COST_P_MEGIDOLAON,false,"almighty")

	self:SetCard("Megidola")
	self:SetCard("Riot Gun",true)

	local v = {forward=-200,right=80,up=50}
	self.User:SetNWVector("Persona_CustomPos",Vector(v.right,v.forward,v.up))
end