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
	LVL = 20, -- Innate level
	STR = 14, -- Effectiveness of phys. attacks
	MAG = 13, -- Effectiveness of magic. attacks
	END = 13, -- Effectiveness of defense
	AGI = 14, -- Effectiveness of hit and evasion rates
	LUC = 13, -- Chance of getting a critical
	WK = {DMG_P_WIND},
	RES = {DMG_P_ELEC,DMG_SHOCK},
	NUL = {DMG_P_CURSE},
}
---------------------------------------------------------------------------------------------------------------------------------------------
ENT.LeveledSkills = {
	{Level = 24, Name = "Mazionga", Cost = 16, UsesHP = false, Icon = "elec"}
}
ENT.LegendaryMaterials = {}
ENT.LegendaryMaterials[1] = "models/cpthazama/persona5/izanagi/izanagi_legendary"
---------------------------------------------------------------------------------------------------------------------------------------------
function ENT:HandleEvents(skill,animBlock,seq,t)
	if skill == "Cross Slash" && self.User:IsPlayer() then
		if math.random(1,10) == 1 then self:DoCritical(1) end
		self:UserSound("cpthazama/persona5/joker/0011.wav",85)
	end
end
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
	self:UserSound("cpthazama/persona5/joker/0009.wav")
	
	self:AddCard("Cross Slash",8,true,"phys")
	self:AddCard("Charge",15,false,"passive")
	self:AddCard("Zionga",8,false,"elec")

	self:SetCard("Zionga")
	self:SetCard("Cross Slash",true)

	local v = {forward=-200,right=80,up=50}
	ply:SetNWVector("Persona_CustomPos",Vector(v.right,v.forward,v.up))
end
---------------------------------------------------------------------------------------------------------------------------------------------
function ENT:OnRequestDisappear(ply)
	self:UserSound("cpthazama/persona5/joker/0" .. math.random(106,120) .. ".wav")
end