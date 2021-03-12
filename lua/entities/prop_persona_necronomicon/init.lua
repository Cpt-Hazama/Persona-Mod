AddCSLuaFile("shared.lua")
include("shared.lua")
---------------------------------------------------------------------------------------------------------------------------------------------
ENT.Animations = {}
ENT.Animations["idle"] = "idle"
ENT.Animations["idle_low"] = "idle"
ENT.Animations["melee"] = "attack"
ENT.Animations["range_start"] = "null"
ENT.Animations["range_start_idle"] = "null"
ENT.Animations["range"] = "range"
ENT.Animations["range_idle"] = "null"
ENT.Animations["range_end"] = "null"
---------------------------------------------------------------------------------------------------------------------------------------------
ENT.Stats = {
	LVL = 31, -- Innate level
	STR = 17, -- Effectiveness of phys. attacks
	MAG = 23, -- Effectiveness of magic. attacks
	END = 20, -- Effectiveness of defense
	AGI = 21, -- Effectiveness of hit and evasion rates
	LUC = 35, -- Chance of getting a critical
	WK = {},
	RES = {},
	NUL = {},
}
---------------------------------------------------------------------------------------------------------------------------------------------
ENT.LegendaryMaterials = {}
ENT.LegendaryMaterials[1] = "models/cpthazama/persona5/necronomicon/necronomicon_legendary"
---------------------------------------------------------------------------------------------------------------------------------------------
function ENT:GetSpawnPosition(ply)
	return ply:GetPos() +ply:GetUp() *300
end
---------------------------------------------------------------------------------------------------------------------------------------------
function ENT:GetIdlePosition(ply)
	return (ply:IsPlayer() && ply:KeyDown(IN_DUCK) && ply:GetPos() +ply:GetUp() *100) or ply:GetPos() +ply:GetUp() *300
end
---------------------------------------------------------------------------------------------------------------------------------------------
function ENT:OnSummoned(owner)
	self:AddCard("Bash",5,true,"phys")
	-- self:AddCard("Inflict Ailment",22,false,"necro")
	self:AddCard("Recover HP EX",30,false,"necro")
	self:AddCard("Recover SP EX",30,false,"necro")
	self:AddCard("Minor Buff",35,false,"necro")
	self:AddCard("Minor Shield",32,false,"necro")
	self:AddCard("Minor Awareness",30,false,"necro")
	self:AddCard("Power Up",60,false,"necro")
	self:AddCard("Ultimate Charge",68,false,"necro")
	-- self:AddCard("Final Guard",85,false,"necro")
	-- self:AddCard("Full Scan",15,false,"necro")

	self:SetCard("Recover HP EX")
	self:SetCard("Bash",true)

	local v = {forward=-200,right=80,up=50}
	self.User:SetNW2Vector("Persona_CustomPos",Vector(v.right,v.forward,v.up))

	self:UserSound("cpthazama/persona5/joker/0" .. math.random(121,125) .. ".wav")
end