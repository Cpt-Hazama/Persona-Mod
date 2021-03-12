AddCSLuaFile("shared.lua")
include("shared.lua")
---------------------------------------------------------------------------------------------------------------------------------------------
ENT.Bot_StopDistance = 100
ENT.Bot_Buttons = {
	[1] = {but={IN_ATTACK},dist=100,chance=1},
}

ENT.IzanagiType = true
ENT.Model = "models/cpthazama/persona5/persona/magatsu_izanagi_picaro.mdl"
ENT.Name = "Magatsu-Izanagi Picaro"
ENT.Aura = "jojo_aura_blue"
ENT.DamageTypes = bit.bor(DMG_SLASH,DMG_CRUSH,DMG_ALWAYSGIB,DMG_P_FEAR)
---------------------------------------------------------------------------------------------------------------------------------------------
ENT.Animations = {}
ENT.Animations["idle"] = "idle"
ENT.Animations["idle_low"] = "low_hp"
ENT.Animations["melee"] = "ghostly_wail_noXY"
ENT.Animations["range_start"] = "atk_magatsu_mandala_pre"
ENT.Animations["range_start_idle"] = "atk_magatsu_mandala_pre_idle"
ENT.Animations["range"] = "atk_magatsu_mandala_start"
ENT.Animations["range_idle"] = "atk_magatsu_mandala"
ENT.Animations["range_end"] = "atk_magatsu_mandala_end"
ENT.Animations["special"] = "evileye"
---------------------------------------------------------------------------------------------------------------------------------------------
ENT.Stats = {
	LVL = 80, -- Innate level
	STR = 60, -- Effectiveness of phys. attacks
	MAG = 56, -- Effectiveness of magic. attacks
	END = 56, -- Effectiveness of defense
	AGI = 48, -- Effectiveness of hit and evasion rates
	LUC = 44, -- Chance of getting a critical
	WK = {DMG_P_NUCLEAR},
	RES = {},
	NUL = {DMG_P_CURSE,DMG_P_BLESS,DMG_P_MIRACLE},
}
---------------------------------------------------------------------------------------------------------------------------------------------
ENT.LeveledSkills = {
	{Level = 86, Name = "Heat Riser", Cost = 30, UsesHP = false, Icon = "passive"},
	{Level = 83, Name = "Megidolaon", Cost = 38, UsesHP = false, Icon = "almighty"},
	{Level = 81, Name = "Magarudyne", Cost = 22, UsesHP = false, Icon = "wind"},
}
ENT.LegendaryMaterials = {}
ENT.LegendaryMaterials[1] = "models/cpthazama/persona5/magatsuizanagi/magatsuizanagi_picaro_nofx_legendary"
ENT.LegendaryMaterials[2] = "models/cpthazama/persona5/magatsuizanagi/magatsuizanagi_picaro_legendary"
---------------------------------------------------------------------------------------------------------------------------------------------
function ENT:GetAttackPosition()
	return self:GetPos() +self:OBBCenter()
end
---------------------------------------------------------------------------------------------------------------------------------------------
function ENT:GetSpawnPosition(ply)
	if ply:IsPlayer() then
		return ply:GetPos() +ply:GetForward() *(ply:IsPlayer() && ply:Crouching() && -10 or -50) +ply:GetRight() *(ply:IsPlayer() && ply:Crouching() && -10 or 0)
	else
		return ply:GetPos() +ply:GetForward() *-50
	end
end
---------------------------------------------------------------------------------------------------------------------------------------------
function ENT:GetIdlePosition(ply)
	if ply:IsPlayer() then
		return ply:GetPos() +ply:GetForward() *(ply:IsPlayer() && ply:Crouching() && -10 or -50) +ply:GetRight() *(ply:IsPlayer() && ply:Crouching() && -10 or 0)
	else
		return ply:GetPos() +ply:GetForward() *-50
	end
end
---------------------------------------------------------------------------------------------------------------------------------------------
function ENT:OnSummoned(ply)
	self:SetModel(self.Model)
	self:DoIdle()
	self.Magatsu = true

	-- self:AddCard("Magarudyne",22,false,"wind")
	-- self:AddCard("Heat Riser",30,false,"passive")
	self:AddCard("Magatsu Mandala",30,false,"curse")
	self:AddCard("Ghastly Wail",19,true,"almighty")
	self:AddCard("Evil Smile",12,false,"sleep")
	self:AddCard("Charge",15,false,"passive")
	-- self:AddCard("Megidolaon",38,false,"almighty")

	self:SetCard("Evil Smile")
	self:SetCard("Ghastly Wail",true)

	local v = {forward=-200,right=80,up=50}
	ply:SetNW2Vector("Persona_CustomPos",Vector(v.right,v.forward,v.up))

	self:UserSound("cpthazama/persona5/joker/0014.wav")
end