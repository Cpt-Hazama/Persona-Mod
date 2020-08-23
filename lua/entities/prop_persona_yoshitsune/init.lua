AddCSLuaFile("shared.lua")
include("shared.lua")

ENT.Stats = {
	LVL = 87, -- Innate level
	STR = 63, -- Effectiveness of phys. attacks
	MAG = 52, -- Effectiveness of magic. attacks
	END = 50, -- Effectiveness of defense
	AGI = 54, -- Effectiveness of hit and evasion rates
	LUC = 49, -- Chance of getting a critical
	WK = {},
	RES = {DMG_P_FIRE,DMG_BURN,DMG_P_BURN},
	NUL = {DMG_P_PHYS,DMG_SLASH},
	REF = {DMG_P_BLESS,DMG_P_MIRACLE,DMG_P_ELEC,DMG_SHOCK},
	ABS = {}
}
---------------------------------------------------------------------------------------------------------------------------------------------
ENT.LegendaryMaterials = {}
ENT.LegendaryMaterials[1] = "models/cpthazama/persona5/yoshitsune/yoshitsune_legendary"
---------------------------------------------------------------------------------------------------------------------------------------------
function ENT:HandleEvents(skill,animBlock,seq,t)
	if animBlock == "melee" then
		self:UserSound("cpthazama/persona5/joker/0008.wav")
	end
end
---------------------------------------------------------------------------------------------------------------------------------------------
function ENT:GetSpawnPosition(ply)
	return ply:GetPos() +ply:GetForward() *-20 +ply:GetRight() *-35
end
---------------------------------------------------------------------------------------------------------------------------------------------
function ENT:GetIdlePosition(ply)
	return ply:GetPos() +ply:GetForward() *-20 +ply:GetRight() *-35
end
---------------------------------------------------------------------------------------------------------------------------------------------
function ENT:OnSummoned(owner)
	self:AddCard("Hassou Tobi",COST_P_HASSOUTOBI,true,"phys")
	self:AddCard("Charge",COST_P_CHARGE,false,"passive")
	self:AddCard("Heat Riser",COST_P_HEAT_RISER,false,"passive")
	self:AddCard("Agidyne",COST_P_AGIDYNE,false,"fire")

	self:SetCard("Agidyne")
	self:SetCard("Hassou Tobi",true)

	local v = {forward=-150,right=50,up=25}
	self.User:SetNWVector("Persona_CustomPos",Vector(v.right,v.forward,v.up))
	
	self:UserSound("cpthazama/persona5/joker/0254.wav")
end
---------------------------------------------------------------------------------------------------------------------------------------------
function ENT:OnRequestDisappear(ply)
	self:UserSound("cpthazama/persona5/joker/0" .. math.random(106,120) .. ".wav")
end