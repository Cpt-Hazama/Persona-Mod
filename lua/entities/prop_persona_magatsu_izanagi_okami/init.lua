AddCSLuaFile("shared.lua")
include("shared.lua")
---------------------------------------------------------------------------------------------------------------------------------------------
ENT.Animations = {}
ENT.Animations["idle"] = "idle"
ENT.Animations["idle_low"] = "low_hp"
ENT.Animations["melee"] = "atk_cross_slash"
ENT.Animations["range_start"] = "myriad_pre"
ENT.Animations["range_start_idle"] = "myriad_pre_idle"
ENT.Animations["range"] = "myriad"
ENT.Animations["range_idle"] = "myriad_loop"
ENT.Animations["range_end"] = "myriad_end"
---------------------------------------------------------------------------------------------------------------------------------------------
ENT.Stats = {
	LVL = 95, -- Innate level
	STR = 82, -- Effectiveness of phys. attacks
	MAG = 90, -- Effectiveness of magic. attacks
	END = 82, -- Effectiveness of defense
	AGI = 82, -- Effectiveness of hit and evasion rates
	LUC = 85, -- Chance of getting a critical
	WK = {DMG_P_BLESS,DMG_P_MIRACLE},
	RES = {
		DMG_P_PHYS,
		DMG_P_GUN,
		DMG_P_FIRE,
		DMG_P_ICE,
		DMG_P_WIND,
		DMG_P_ELEC,
		DMG_P_CURSE,
		DMG_P_PSI,
		DMG_SHOCK,
		DMG_BURN,
		DMG_VEHICLE,
		DMG_BULLET,
	},
	NUL = {DMG_P_NUCLEAR},
}
---------------------------------------------------------------------------------------------------------------------------------------------
ENT.LeveledSkills = {
	{Level = 98, Name = "Concentrate", Cost = 15, UsesHP = false, Icon = "passive"},
	{Level = 96, Name = "Heat Riser", Cost = 30, UsesHP = false, Icon = "passive"},
}
ENT.LegendaryMaterials = {}
ENT.LegendaryMaterials[1] = "models/cpthazama/persona5/izanagiokami/okami_magatsu_legendary"
ENT.LegendaryMaterials[2] = "models/cpthazama/persona5/izanagiokami/okami_magatsu_fx_legendary"
---------------------------------------------------------------------------------------------------------------------------------------------
function ENT:GetSpawnPosition(ply)
	return ply:GetPos() +ply:GetForward() *-50 +ply:GetRight() *-15 +ply:GetUp() *(ply:Crouching() && 0 or 45)
end
---------------------------------------------------------------------------------------------------------------------------------------------
function ENT:GetIdlePosition(ply)
	return ply:GetPos() +ply:GetForward() *-50 +ply:GetRight() *-15 +ply:GetUp() *(ply:Crouching() && 0 or 45)
end
---------------------------------------------------------------------------------------------------------------------------------------------
function ENT:OnSummoned(ply)
	self:AddCard("Magatsu Blade",25,true,"phys")
	self:AddCard("Myriad Mandala",45,false,"almighty")

	self:SetCard("Myriad Mandala")
	self:SetCard("Magatsu Blade",true)

	local v = {forward=-200,right=80,up=110}
	ply:SetNWVector("Persona_CustomPos",Vector(v.right,v.forward,v.up))
end
---------------------------------------------------------------------------------------------------------------------------------------------
function ENT:OnKilledEnemy(ent)
	self.User:SetSP(self.User:GetMaxSP())
	self.User:SetHealth(self.User:GetMaxHealth())
end