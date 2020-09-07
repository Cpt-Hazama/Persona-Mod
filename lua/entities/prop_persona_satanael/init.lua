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
ENT.Animations["idle_low"] = "idle"
ENT.Animations["melee"] = "attack"
ENT.Animations["range_start"] = "range_start"
ENT.Animations["range_start_idle"] = "range_pre_idle"
ENT.Animations["range"] = "range"
ENT.Animations["range_idle"] = "range_loop"
ENT.Animations["range_end"] = "range_end"
---------------------------------------------------------------------------------------------------------------------------------------------
ENT.Stats = {
	LVL = 95, -- Innate level
	STR = 63, -- Effectiveness of phys. attacks
	MAG = 60, -- Effectiveness of magic. attacks
	END = 57, -- Effectiveness of defense
	AGI = 56, -- Effectiveness of hit and evasion rates
	LUC = 56, -- Chance of getting a critical
	WK = {},
	RES = {
		DMG_P_ICE,
		DMG_P_EARTH,
		DMG_P_WIND,
		DMG_P_GRAVITY,
		DMG_P_NUCLEAR,
		DMG_P_EXPEL,
		DMG_P_DEATH,
		DMG_P_FORCE,
		DMG_P_TECH,
		DMG_P_ALMIGHTY,
		DMG_P_PSI,
		DMG_P_ELEC,
		DMG_P_CURSE,
		DMG_P_FEAR,
		DMG_P_PHYS,
		DMG_P_GUN
	},
	NUL = {DMG_P_BLESS,DMG_P_MIRACLE},
}
---------------------------------------------------------------------------------------------------------------------------------------------
ENT.LeveledSkills = {
	{Level = 99, Name = "Sinful Shell", Cost = 999, UsesHP = false, Icon = "almighty"},
	{Level = 97, Name = "Black Viper", Cost = 48, UsesHP = false, Icon = "almighty"}
}
ENT.LegendaryMaterials = {}
ENT.LegendaryMaterials[1] = "models/cpthazama/persona5/satanael/satanael_legendary"
---------------------------------------------------------------------------------------------------------------------------------------------
function ENT:PersonaControls(ply,persona)
	local lmb = ply:KeyDown(IN_ATTACK)
	local rmb = ply:KeyDown(IN_ATTACK2)
	local r = ply:KeyDown(IN_RELOAD)
end
---------------------------------------------------------------------------------------------------------------------------------------------
function ENT:GetSpawnPosition(ply)
	return ply:GetPos() +ply:GetForward() *-400 +ply:GetRight() *-15
end
---------------------------------------------------------------------------------------------------------------------------------------------
function ENT:GetIdlePosition(ply)
	return ply:GetPos() +ply:GetForward() *-400 +ply:GetRight() *-15
end
---------------------------------------------------------------------------------------------------------------------------------------------
function ENT:OnSummoned(ply)
	self:UserSound("cpthazama/persona5/joker/0314.wav")

	self:AddCard("Maeigaon",22,false,"curse")
	self:AddCard("Megidolaon",38,false,"almighty")
	-- self:AddCard("Black Viper",48,false,"almighty")
	self:AddCard("Heat Riser",30,false,"passive")
	self:AddCard("Riot Gun",24,true,"gun")
	-- self:AddCard("Sinful Shell",999,false,"almighty")

	self:SetCard("Megidolaon")
	self:SetCard("Riot Gun",true)

	local v = {forward=-600,right=300,up=300}
	ply:SetNWVector("Persona_CustomPos",Vector(v.right,v.forward,v.up))
end
---------------------------------------------------------------------------------------------------------------------------------------------
function ENT:OnRequestDisappear(ply)
	self:UserSound("cpthazama/persona5/joker/0" .. math.random(106,120) .. ".wav")
end