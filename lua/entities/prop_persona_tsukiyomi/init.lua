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
ENT.Animations["range_start"] = "range_start"
ENT.Animations["range_start_idle"] = "range_pre_idle"
ENT.Animations["range"] = "range"
ENT.Animations["range_idle"] = "range_loop"
ENT.Animations["range_end"] = "range_end"
---------------------------------------------------------------------------------------------------------------------------------------------
ENT.Stats = {
	LVL = 50, -- Innate level
	STR = 38, -- Effectiveness of phys. attacks
	MAG = 32, -- Effectiveness of magic. attacks
	END = 33, -- Effectiveness of defense
	AGI = 37, -- Effectiveness of hit and evasion rates
	LUC = 17, -- Chance of getting a critical
	WK = {DMG_P_NUCLEAR},
	RES = {DMG_P_BLESS,DMG_P_MIRACLE,DMG_P_PHYS},
	NUL = {DMG_P_CURSE},
}
---------------------------------------------------------------------------------------------------------------------------------------------
function ENT:CustomOnHitEntity(hitEnts,dmginfo)
	if dmginfo:GetDamageType() == DMG_P_CURSE then
		for _,v in pairs(hitEnts) do
			if IsValid(v) && v:Health() > 0 then
				self:Curse(v,10,5)
			end
		end
	end
end
---------------------------------------------------------------------------------------------------------------------------------------------
function ENT:PersonaControls(ply,persona)
	local lmb = ply:KeyDown(IN_ATTACK)
	local rmb = ply:KeyDown(IN_ATTACK2)
	local alt = ply:KeyDown(IN_WALK)
	local r = ply:KeyDown(IN_RELOAD)
end
---------------------------------------------------------------------------------------------------------------------------------------------
function ENT:GetAttackPosition()
	return self:GetTask() == "TASK_ATTACK" && self:GetPos() +self:OBBCenter() +self:GetForward() *350 or self:GetPos() +self:OBBCenter()
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
	ply:EmitSound("cpthazama/persona5/joker/0029.wav")
	self.PersonaDistance = 999999999 -- 40 meters
	
	self:AddCard("Abyssal Wings",30,false,"curse")
	self:AddCard("Life Drain",3,false,"almighty")
	self:AddCard("Vorpal Blade",23,true,"phys")
	self:AddCard("Teleport",15,false,"passive")

	self:SetCard("Teleport")
	self:SetCard("Vorpal Blade",true)

	local v = {forward=-125,right=60,up=35}
	ply:SetNWVector("Persona_CustomPos",Vector(v.right,v.forward,v.up))
end
---------------------------------------------------------------------------------------------------------------------------------------------
function ENT:OnRequestDisappear(ply)
	ply:EmitSound("cpthazama/persona5/joker/0" .. math.random(106,120) .. ".wav")
end