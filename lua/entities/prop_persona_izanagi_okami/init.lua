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
ENT.Animations["range_start"] = "myriad_pre"
ENT.Animations["range_start_idle"] = "myriad_pre_idle"
ENT.Animations["range"] = "myriad"
ENT.Animations["range_idle"] = "myriad_loop"
ENT.Animations["range_end"] = "myriad_end"
---------------------------------------------------------------------------------------------------------------------------------------------
ENT.Stats = {
	LVL = 91, -- Innate level
	STR = 80, -- Effectiveness of phys. attacks
	MAG = 80, -- Effectiveness of magic. attacks
	END = 80, -- Effectiveness of defense
	AGI = 80, -- Effectiveness of hit and evasion rates
	LUC = 80, -- Chance of getting a critical
	WK = {},
	RES = {
		DMG_P_PHYS,
		DMG_P_GUN,
		DMG_P_FIRE,
		DMG_P_ICE,
		DMG_P_WIND,
		DMG_P_ELEC,
		DMG_P_PSI,
		DMG_P_NUCLEAR,
		DMG_SHOCK,
		DMG_BURN,
		DMG_VEHICLE,
		DMG_BULLET,
	},
	NUL = {},
}
---------------------------------------------------------------------------------------------------------------------------------------------
ENT.LeveledSkills = {
	{Level = 95, Name = "Heat Riser", Cost = 30, UsesHP = false, Icon = "passive"},
	{Level = 93, Name = "Salvation", Cost = 48, UsesHP = false, Icon = "heal"},
	{Level = 92, Name = "Concentrate", Cost = 15, UsesHP = false, Icon = "passive"}
}
ENT.LegendaryMaterials = {}
ENT.LegendaryMaterials[1] = "models/cpthazama/persona5/izanagiokami/okami_legendary"
---------------------------------------------------------------------------------------------------------------------------------------------
function ENT:HandleEvents(skill,animBlock,seq,t)
	if skill == "Heaven's Blade" && self.User:IsPlayer() then
		if math.random(1,8) == 1 then self:DoCritical(1) end
		self:UserSound("cpthazama/persona5/joker/0027.wav",85)
	end
end
---------------------------------------------------------------------------------------------------------------------------------------------
function ENT:PersonaControls(ply,persona)
	local lmb = ply:KeyDown(IN_ATTACK)
	local rmb = ply:KeyDown(IN_ATTACK2)
	local r = ply:KeyDown(IN_RELOAD)
end
---------------------------------------------------------------------------------------------------------------------------------------------
function ENT:HandleDamage(dmg,dmgtype,dmginfo)
	-- if math.random(1,100) < (self.HeatRiserT > CurTime() && 65) or 45 then // OP af
		-- self.User:ChatPrint("Evaded Attack!")
		-- return true
	-- end
	dmginfo:ScaleDamage(0.025) // Okami has the highest resistance to all damage types in Persona
	return false
end
---------------------------------------------------------------------------------------------------------------------------------------------
function ENT:GetSpawnPosition(ply)
	return ply:GetPos() +ply:GetForward() *-50 +ply:GetRight() *-15 +ply:GetUp() *(ply:IsPlayer() && ply:Crouching() && 0 or 45)
end
---------------------------------------------------------------------------------------------------------------------------------------------
function ENT:GetIdlePosition(ply)
	return ply:GetPos() +ply:GetForward() *-50 +ply:GetRight() *-15 +ply:GetUp() *(ply:IsPlayer() && ply:Crouching() && 0 or 45)
end
---------------------------------------------------------------------------------------------------------------------------------------------
function ENT:OnSummoned(ply)
	self:UserSound("cpthazama/persona5/joker/0009.wav")
	self.PersonaDistance = 999999999

	self.Damage = 2500

	self:AddCard("Heaven's Blade",35,true,"phys")
	self:AddCard("Myriad Truths",40,false,"almighty")
	-- self:AddCard("Concentrate",15,false,"passive")
	-- self:AddCard("Heat Riser",30,false,"passive")
	-- self:AddCard("Salvation",48,false,"heal")

	self:SetCard("Myriad Truths")
	self:SetCard("Heaven's Blade",true)

	local v = {forward=-200,right=80,up=110}
	ply:SetNW2Vector("Persona_CustomPos",Vector(v.right,v.forward,v.up))
end
---------------------------------------------------------------------------------------------------------------------------------------------
function ENT:OnKilledEnemy(ent)
	self.User:SetSP(self.User:GetMaxSP())
	self.User:SetHealth(self.User:GetMaxHealth())
end
---------------------------------------------------------------------------------------------------------------------------------------------
function ENT:OnRequestDisappear(ply)
	self:UserSound("cpthazama/persona5/joker/0" .. math.random(106,120) .. ".wav")
end