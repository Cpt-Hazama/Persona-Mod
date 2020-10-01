AddCSLuaFile("shared.lua")
include("shared.lua")
---------------------------------------------------------------------------------------------------------------------------------------------
ENT.Animations = {}
ENT.Animations["idle"] = "idle"
ENT.Animations["idle_low"] = "idle"
ENT.Animations["melee"] = "attack"
ENT.Animations["range_start"] = "range_pre"
ENT.Animations["range_start_idle"] = "range_pre_idle"
ENT.Animations["range"] = "range"
ENT.Animations["range_idle"] = "range_loop"
ENT.Animations["range_end"] = "range_end"
---------------------------------------------------------------------------------------------------------------------------------------------
ENT.Stats = {
	LVL = 2, -- Innate level
	STR = 2, -- Effectiveness of phys. attacks
	MAG = 5, -- Effectiveness of magic. attacks
	END = 3, -- Effectiveness of defense
	AGI = 1, -- Effectiveness of hit and evasion rates
	LUC = 2, -- Chance of getting a critical
	WK = {DMG_P_GUN,DMG_BULLET,DMG_P_ICE,DMG_P_FROST,DMG_FROST,DMG_P_WIND},
	RES = {},
	ABS = {DMG_P_FIRE,DMG_BURN},
	NUL = {},
}
---------------------------------------------------------------------------------------------------------------------------------------------
ENT.LegendaryMaterials = {}
ENT.LegendaryMaterials[1] = "models/cpthazama/persona5/jack/jack_legendary"
---------------------------------------------------------------------------------------------------------------------------------------------
function ENT:GetSpawnPosition(ply)
	return (ply:IsNPC() && ply:GetPos()) or ply:GetPos() +ply:GetForward() *-60
end
---------------------------------------------------------------------------------------------------------------------------------------------
function ENT:GetIdlePosition(ply)
	return (ply:IsNPC() && ply:GetPos()) or ply:GetPos() +ply:GetForward() *-60
end
---------------------------------------------------------------------------------------------------------------------------------------------
function ENT:GetAttackPosition()
	return self.AttackPosition or self:GetPos() +self:OBBCenter()
end
---------------------------------------------------------------------------------------------------------------------------------------------
function ENT:OnSummoned(owner)
	self:AddCard("Agi",4,false,"fire")
	self:AddCard("Bash",7,true,"phys")

	self:SetCard("Agi")
	self:SetCard("Agi",true)

	local v = {forward=-120,right=60,up=35}
	self.User:SetNWVector("Persona_CustomPos",Vector(v.right,v.forward,v.up))
end