AddCSLuaFile("shared.lua")
include("shared.lua")

ENT.Stats = {
	LVL = 1, -- Innate level
	STR = 2, -- Effectiveness of phys. attacks
	MAG = 5, -- Effectiveness of magic. attacks
	END = 4, -- Effectiveness of defense
	AGI = 6, -- Effectiveness of hit and evasion rates
	LUC = 4, -- Chance of getting a critical
	WK = {DMG_P_CURSE},
	RES = {},
	NUL = {DMG_P_BLESS,DMG_P_MIRACLE},
	REF = {},
	ABS = {}
}
---------------------------------------------------------------------------------------------------------------------------------------------
ENT.LeveledSkills = {
	{Level = 95, Name = "God's Hand", Cost = 25, UsesHP = false, Icon = "phys"},
	{Level = 90, Name = "Salvation", Cost = 48, UsesHP = false, Icon = "heal"},
	{Level = 84, Name = "Divine Judgement", Cost = 48, UsesHP = false, Icon = "bless"},
	{Level = 75, Name = "Makougaon", Cost = 22, UsesHP = false, Icon = "bless"},
	{Level = 60, Name = "Mediarahan", Cost = 30, UsesHP = false, Icon = "heal"},
	-- {Level = 55, Name = "Samarecarm", Cost = 18, UsesHP = false, Icon = "heal"},
	{Level = 48, Name = "Kougaon", Cost = 12, UsesHP = false, Icon = "bless"},
	{Level = 40, Name = "Makouga", Cost = 16, UsesHP = false, Icon = "bless"},
	-- {Level = 35, Name = "Mediarama", Cost = 12, UsesHP = false, Icon = "heal"},
	-- {Level = 30, Name = "Recarm", Cost = 8, UsesHP = false, Icon = "heal"},
	{Level = 23, Name = "Kouga", Cost = 8, UsesHP = false, Icon = "bless"},
	-- {Level = 19, Name = "Tetraja", Cost = 24, UsesHP = false, Icon = "passive"},
	{Level = 12, Name = "Makouha", Cost = 10, UsesHP = false, Icon = "bless"}
}
---------------------------------------------------------------------------------------------------------------------------------------------
ENT.LegendaryMaterials = {}
ENT.LegendaryMaterials[1] = "models/cpthazama/persona5_strikers/pandora/Rune_legendary"
ENT.LegendaryMaterials[2] = "models/cpthazama/persona5_strikers/pandora/Pandora_Body_legendary"
ENT.LegendaryMaterials[3] = "models/cpthazama/persona5_strikers/pandora/Pandora_Skin_legendary"
---------------------------------------------------------------------------------------------------------------------------------------------
function ENT:GetSpawnPosition(ply)
	return ply:GetPos() +ply:GetForward() *-40 +ply:GetUp() *10
end
---------------------------------------------------------------------------------------------------------------------------------------------
function ENT:GetIdlePosition(ply)
	return ply:GetPos() +ply:GetForward() *-40 +ply:GetUp() *10
end
---------------------------------------------------------------------------------------------------------------------------------------------
function ENT:GetAttackPosition()
	return self.AttackPosition or self:GetPos() +self:OBBCenter()
end
---------------------------------------------------------------------------------------------------------------------------------------------
function ENT:OnSummoned(owner)
	self:AddCard("Bash",6,true,"phys")
	self:AddCard("Kouha",4,false,"bless")
	self:AddCard("Dia",3,false,"heal")

	self:SetCard("Kouha")
	self:SetCard("Bash",true)
	
	if owner:Nick() == "Cpt. Hazama" then
		self:SetBodygroup(1,1)
	end

	local v = {forward=-200,right=80,up=50}
	self.User:SetNW2Vector("Persona_CustomPos",Vector(v.right,v.forward,v.up))
end