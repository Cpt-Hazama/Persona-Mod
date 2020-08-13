AddCSLuaFile("shared.lua")
include("shared.lua")
---------------------------------------------------------------------------------------------------------------------------------------------
ENT.Bot_StopDistance = 100
ENT.Bot_Buttons = {
	[1] = {but={IN_ATTACK},dist=100,chance=1},
}
---------------------------------------------------------------------------------------------------------------------------------------------
ENT.Animations = {}
ENT.Animations["idle"] = "idle"
ENT.Animations["idle_low"] = "low_hp"
ENT.Animations["melee"] = "atk_cross_slash"
ENT.Animations["range_start"] = "atk_mazionga_pre"
ENT.Animations["range_start_idle"] = "atk_mazionga_pre_idle"
ENT.Animations["range"] = "atk_mazionga"
ENT.Animations["range_idle"] = "atk_mazionga_loop"
ENT.Animations["range_end"] = "atk_mazionga_end"
---------------------------------------------------------------------------------------------------------------------------------------------
ENT.Stats = {
	LVL = 99, -- Innate level
	STR = 90, -- Effectiveness of phys. attacks
	MAG = 95, -- Effectiveness of magic. attacks
	END = 90, -- Effectiveness of defense
	AGI = 90, -- Effectiveness of hit and evasion rates
	LUC = 85, -- Chance of getting a critical
	WK = {DMG_P_GUN,DMG_BULLET},
	RES = {
		DMG_P_PHYS,
		DMG_P_FIRE,
		DMG_P_ICE,
		DMG_P_WIND,
		DMG_P_ELEC,
		DMG_P_PSI,
		DMG_P_NUCLEAR,
		DMG_SHOCK,
		DMG_BURN,
		DMG_VEHICLE,
	},
	NUL = {DMG_P_CURSE,DMG_P_BLESS,DMG_P_MIRACLE},
}
ENT.IsVelvetPersona = true
---------------------------------------------------------------------------------------------------------------------------------------------
function ENT:GetSpawnPosition(ply)
	return ply:GetPos() +ply:GetForward() *-50 +ply:GetRight() *-15
end
---------------------------------------------------------------------------------------------------------------------------------------------
function ENT:GetIdlePosition(ply)
	return ply:GetPos() +ply:GetForward() *-50 +ply:GetRight() *-15
end
---------------------------------------------------------------------------------------------------------------------------------------------
function ENT:OnSummoned(ply)
	self:AddCard("Almighty Slash",25,true,"almighty")
	self:AddCard("Charge",15,false,"passive")
	self:AddCard("Concentrate",15,false,"passive")
	self:AddCard("Debilitate",COST_P_DEBILITATE,false,"passive")
	self:AddCard("Heat Riser",30,false,"passive")
	self:AddCard("Maziodyne",COST_P_MAZIODYNE,false,"elec")
	self:AddCard("Megidola",COST_P_MEGIDOLA,false,"almighty")
	self:AddCard("Megidolaon",COST_P_MEGIDOLAON,false,"almighty")
	self:AddCard("Salvation",COST_P_SALVATION,false,"heal")

	self:SetCard("Megidolaon")
	self:SetCard("Almighty Slash",true)

	local v = {forward=-200,right=80,up=50}
	ply:SetNWVector("Persona_CustomPos",Vector(v.right,v.forward,v.up))
end