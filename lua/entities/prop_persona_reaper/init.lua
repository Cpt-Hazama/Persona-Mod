AddCSLuaFile("shared.lua")
include("shared.lua")
---------------------------------------------------------------------------------------------------------------------------------------------
ENT.Model = "models/cpthazama/persona5/persona/reaper.mdl"
ENT.Name = "The Reaper"
ENT.Aura = "jojo_aura_red"
---------------------------------------------------------------------------------------------------------------------------------------------
ENT.Animations = {}
ENT.Animations["idle"] = "idle"
ENT.Animations["idle_low"] = "idle"
ENT.Animations["melee"] = "melee"
ENT.Animations["range_start"] = "range_start"
ENT.Animations["range_start_idle"] = "range_start_idle"
ENT.Animations["range"] = "range"
ENT.Animations["range_idle"] = "range_idle"
ENT.Animations["range_end"] = "range_end"
---------------------------------------------------------------------------------------------------------------------------------------------
ENT.Stats = {
	LVL = 85, -- Innate level
	STR = 99, -- Effectiveness of phys. attacks
	MAG = 80, -- Effectiveness of magic. attacks
	END = 80, -- Effectiveness of defense
	AGI = 75, -- Effectiveness of hit and evasion rates
	LUC = 80, -- Chance of getting a critical
	WK = {},
	RES = {},
	NUL = {},
}
---------------------------------------------------------------------------------------------------------------------------------------------
function ENT:GetSpawnPosition(ply)
	return ply:GetPos() +ply:GetForward() *-130
end
---------------------------------------------------------------------------------------------------------------------------------------------
function ENT:GetIdlePosition(ply)
	return ply:GetPos() +ply:GetForward() *-130
end
---------------------------------------------------------------------------------------------------------------------------------------------
function ENT:GetAttackPosition()
	return self.AttackPosition or self:GetPos() +self:OBBCenter()
end
---------------------------------------------------------------------------------------------------------------------------------------------
function ENT:OnSummoned(owner)
	self.Magatsu = true

	self:AddCard("Vorpal Blade",3,true,"phys")
	self:AddCard("One-shot Kill",2,true,"gun")
	self:AddCard("Riot Gun",4,true,"gun")

	self:AddCard("Agidyne",12,false,"fire")
	self:AddCard("Maragidyne",22,false,"fire")
	self:AddCard("Bufudyne",12,false,"frost")
	self:AddCard("Mabufudyne",22,false,"frost")
	self:AddCard("Ziodyne",12,false,"elec")
	self:AddCard("Maziodyne",22,false,"elec")
	self:AddCard("Garudyne",12,false,"wind")
	self:AddCard("Magarudyne",22,false,"wind")
	self:AddCard("Psiodyne",12,false,"psi")
	self:AddCard("Mapsiodyne",22,false,"psi")
	self:AddCard("Freidyne",12,false,"nuclear")
	self:AddCard("Mafreidyne",22,false,"nuclear")
	self:AddCard("Hamaon",15,false,"bless")
	self:AddCard("Mahamaon",34,false,"bless")
	self:AddCard("Mudoon",15,false,"curse")
	self:AddCard("Mamudoon",34,false,"curse")
	self:AddCard("Megidolaon",38,false,"almighty")
	self:AddCard("Life Leech",24,false,"passive")
	self:AddCard("Spirit Leech",4,true,"passive")
	self:AddCard("Concentrate",15,false,"passive")
	self:AddCard("Fire Break",15,false,"passive")
	self:AddCard("Ice Break",15,false,"passive")
	self:AddCard("Elec Break",15,false,"passive")
	self:AddCard("Wind Break",15,false,"passive")

	self:SetCard("Megidolaon")
	self:SetCard("One-shot Kill",true)

	local v = {forward=-400,right=80,up=130}
	self.User:SetNW2Vector("Persona_CustomPos",Vector(v.right,v.forward,v.up))
end