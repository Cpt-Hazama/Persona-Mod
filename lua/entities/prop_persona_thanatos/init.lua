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
ENT.Animations["melee"] = "attack"
ENT.Animations["range_start"] = "range_pre"
ENT.Animations["range_start_idle"] = "range_pre_idle"
ENT.Animations["range"] = "range"
ENT.Animations["range_idle"] = "range_loop"
ENT.Animations["range_end"] = "range_end"
---------------------------------------------------------------------------------------------------------------------------------------------
ENT.Stats = {
	LVL = 65, -- Innate level
	STR = 43, -- Effectiveness of phys. attacks
	MAG = 49, -- Effectiveness of magic. attacks
	END = 41, -- Effectiveness of defense
	AGI = 38, -- Effectiveness of hit and evasion rates
	LUC = 31, -- Chance of getting a critical
	WK = {DMG_P_BLESS},
	RES = {DMG_P_PHYS},
	NUL = {DMG_P_CURSE},
}
---------------------------------------------------------------------------------------------------------------------------------------------
ENT.LeveledSkills = {
	{Level = 70, Name = "Doors of Hades", Cost = 32, UsesHP = false, Icon = "almighty"}
}
ENT.LegendaryMaterials = {}
ENT.LegendaryMaterials[1] = "models/cpthazama/persona5/thanatos/thanatos_legendary"
---------------------------------------------------------------------------------------------------------------------------------------------
function ENT:PersonaControls(ply,persona)
	local lmb = ply:KeyDown(IN_ATTACK)
	local rmb = ply:KeyDown(IN_ATTACK2)
	local r = ply:KeyDown(IN_RELOAD)
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
function ENT:OnSummoned(owner)
	self:UserSound("cpthazama/persona5/joker/0005.wav")
	self.PersonaDistance = 999999999

	-- self:AddCard("Doors of Hades",32,false,"almighty")
	self:AddCard("Maeigaon",22,false,"curse")
	self:AddCard("Mamudoon",34,false,"curse")
	self:AddCard("Concentrate",15,false,"passive")
	self:AddCard("One-shot Kill",17,true,"gun")
	if owner:IsNPC() && owner:GetClass() == "npc_vj_per_elizabeth" then
		self:AddCard("Maziodyne",COST_P_MAZIODYNE,false,"elec")
		self:AddCard("Mabufudyne",1,false,"ice")
		self:AddCard("Magarudyne",1,false,"wind")
		self:AddCard("Maragidyne",1,false,"fire")
		self:AddCard("Debilitate",1,false,"passive")
		self:AddCard("Charge",1,false,"sleep")
		self:AddCard("Mahamaon",1,false,"bless")
		self:AddCard("Diarahan",1,false,"heal")
		self:AddCard("Ghastly Wail",1,true,"almighty")
		self:AddCard("Megidolaon",38,false,"almighty")
	end

	self:SetCard("Maeigaon")
	self:SetCard("One-shot Kill",true)

	local v = {forward=-200,right=80,up=50}
	owner:SetNW2Vector("Persona_CustomPos",Vector(v.right,v.forward,v.up))
end
---------------------------------------------------------------------------------------------------------------------------------------------
function ENT:OnRequestDisappear(ply)
	self:UserSound("cpthazama/persona5/joker/0" .. math.random(106,120) .. ".wav")
end