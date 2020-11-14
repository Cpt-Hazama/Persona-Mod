AddCSLuaFile("shared.lua")
include("shared.lua")

ENT.Stats = {
	LVL = 95, -- Innate level
	STR = 60, -- Effectiveness of phys. attacks
	MAG = 99, -- Effectiveness of magic. attacks
	END = 63, -- Effectiveness of defense
	AGI = 66, -- Effectiveness of hit and evasion rates
	LUC = 75, -- Chance of getting a critical
	WK = {DMG_P_PHYS,DMG_SLASH,DMG_CRUSH,DMG_VEHICLE},
	RES = {},
	NUL = {DMG_P_PSI,DMG_P_PSY,DMG_P_ELEC,DMG_SHOCK,DMG_P_WIND,DMG_P_NUCLEAR},
	REF = {DMG_P_FIRE,DMG_BURN,DMG_P_BURN,DMG_BULLET,DMG_P_GUN,DMG_P_ICE,DMG_P_BLESS,DMG_P_MIRACLE,DMG_P_CURSE}
}
---------------------------------------------------------------------------------------------------------------------------------------------
ENT.Animations = {}
ENT.Animations["idle"] = "idle"
ENT.Animations["idle_low"] = "idle"
ENT.Animations["melee"] = "flinch"
ENT.Animations["range_start"] = "range_pre"
ENT.Animations["range_start_idle"] = "range_pre_idle"
ENT.Animations["range"] = "range"
ENT.Animations["range_idle"] = "range_loop"
ENT.Animations["range_end"] = "range_end"
---------------------------------------------------------------------------------------------------------------------------------------------
ENT.LegendaryMaterials = {}
ENT.LegendaryMaterials[1] = "models/cpthazama/persona5/azathoth/tentacles"
ENT.LegendaryMaterials[2] = "models/cpthazama/persona5/azathoth/azatoth_legendary"
ENT.LegendaryMaterials[3] = "models/cpthazama/persona5/azathoth/hand"
ENT.MovesWithUser = false
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
	self:AddCard("Nuclear Crush",30,false,"nuclear")
	self:AddCard("Raining Seeds",5,true,"phys")
	self:AddCard("Evil Smile",12,false,"sleep")
	self:AddCard("Eternal Radiance",30,false,"bless")
	self:AddCard("Piercing Strike",300,false,"almighty")
	self:AddCard("Tyrant Chaos",500,false,"almighty")
	self:AddCard("Megidolaon",COST_P_MEGIDOLAON,false,"almighty")
	self:AddCard("Energy Stream",25,false,"heal")

	self:SetCard("Nuclear Crush")
	self:SetCard("Raining Seeds",true)

	local v = {forward=-350,right=80,up=90}
	self.User:SetNW2Vector("Persona_CustomPos",Vector(v.right,v.forward,v.up))
end