AddCSLuaFile("shared.lua")
include("shared.lua")

ENT.Stats = {
	LVL = 45, -- Innate level
	STR = 32, -- Effectiveness of phys. attacks
	MAG = 29, -- Effectiveness of magic. attacks
	END = 28, -- Effectiveness of defense
	AGI = 29, -- Effectiveness of hit and evasion rates
	LUC = 24, -- Chance of getting a critical
	WK = {DMG_P_CURSE},
	RES = {DMG_P_BLESS,DMG_P_MIRACLE},
	NUL = {},
	ABS = {}
}
---------------------------------------------------------------------------------------------------------------------------------------------
ENT.LeveledSkills = {
	{Level = 75, Name = "Call of Chaos", Cost = 100, UsesHP = false, Icon = "passive"},
	{Level = 70, Name = "Debilitate", Cost = 30, UsesHP = false, Icon = "passive"},
	{Level = 62, Name = "Megidolaon", Cost = 38, UsesHP = false, Icon = "almighty"},
	{Level = 62, Name = "Mamudoon", Cost = 34, UsesHP = false, Icon = "curse"},
	{Level = 59, Name = "Mahamaon", Cost = 34, UsesHP = false, Icon = "bless"},
	{Level = 48, Name = "Eigaon", Cost = 12, UsesHP = false, Icon = "curse"},
	{Level = 47, Name = "Kougaon", Cost = 12, UsesHP = false, Icon = "bless"}
}
---------------------------------------------------------------------------------------------------------------------------------------------
ENT.LegendaryMaterials = {}
ENT.LegendaryMaterials[1] = "models/cpthazama/persona5/robinhood/robinhood_legendary"
---------------------------------------------------------------------------------------------------------------------------------------------
function ENT:HandleEvents(skill,animBlock,seq,t)
	local ply = self.User
	if skill == "Call of Chaos" then
		if animBlock == "range_start" then
			if ply:IsNPC() && ply:GetClass() == "npc_vj_per_akechi_crow" then
				VJ_CreateSound(ply,"cpthazama/persona5/akechi/blackmask/00027_streaming [1].wav",78)
			else
				self:UserSound("cpthazama/persona5/akechi/blackmask/00027_streaming [1].wav",80)
			end
		end
		if animBlock == "range" then
			if ply:IsNPC() && ply:GetClass() == "npc_vj_per_akechi_crow" then
				VJ_CreateSound(ply,"cpthazama/persona5/akechi/blackmask/00029_streaming [1].wav",78)
			else
				self:UserSound("cpthazama/persona5/akechi/blackmask/00029_streaming [1].wav",80)
			end
		end
		if animBlock == "range_idle" then
			if ply:IsNPC() && ply:GetClass() == "npc_vj_per_akechi_crow" then
				VJ_CreateSound(ply,"cpthazama/persona5/akechi/blackmask/00020_streaming [1].wav.wav",78)
			else
				self:UserSound("cpthazama/persona5/akechi/blackmask/00020_streaming [1].wav",80)
			end
		end
	end
	if animBlock == "melee" then
		if skill == "Laevateinn" then
			self:UserSound("cpthazama/persona5/akechi/blackmask/00010_streaming [1].wav",80)
		else
			self:UserSound(VJ_PICK({
				"cpthazama/persona5/akechi/blackmask/00004_streaming [1].wav",
				"cpthazama/persona5/akechi/blackmask/00006_streaming [1].wav",
				"cpthazama/persona5/akechi/blackmask/00007_streaming [1].wav",
				"cpthazama/persona5/akechi/blackmask/00008_streaming [1].wav",
				"cpthazama/persona5/akechi/blackmask/00009_streaming [1].wav",
			}),80)
		end
	end
	if animBlock == "range_start" then
		if ply:IsNPC() && ply:GetClass() == "npc_vj_per_akechi_crow" then
			VJ_CreateSound(ply,"cpthazama/persona5/akechi/00002_streaming [1].wav",78)	
		end
	end
	if animBlock == "range" then
		if string.StartWith(skill,"Agi") or string.StartWith(skill,"Mara") then
			self:UserSound("cpthazama/persona5/akechi/blackmask/00002_streaming [1].wav",80)
			return
		elseif string.StartWith(skill,"Buf") or string.StartWith(skill,"Mabuf") then
			self:UserSound("cpthazama/persona5/akechi/blackmask/00001_streaming [1].wav",80)
			return
		elseif string.StartWith(skill,"Zio") or string.StartWith(skill,"Mazio") then
			self:UserSound("cpthazama/persona5/akechi/blackmask/00003_streaming [1].wav",80)
			return
		elseif string.StartWith(skill,"Garu") or string.StartWith(skill,"Magaru") then
			self:UserSound("cpthazama/persona5/akechi/blackmask/00004_streaming [1].wav",80)
			return
		elseif string.StartWith(skill,"Evil") or string.StartWith(skill,"Ei") or string.StartWith(skill,"Maei") then
			self:UserSound("cpthazama/persona5/akechi/blackmask/00005_streaming [1].wav",80)
			return
		elseif string.StartWith(skill,"Megi") then
			self:UserSound("cpthazama/persona5/akechi/blackmask/00008_streaming [1].wav",80)
			return
		end
	end
end
---------------------------------------------------------------------------------------------------------------------------------------------
function ENT:GetSpawnPosition(ply)
	return ply:GetPos() +ply:GetForward() *-60
end
---------------------------------------------------------------------------------------------------------------------------------------------
function ENT:GetIdlePosition(ply)
	return ply:GetPos() +ply:GetForward() *-60
end
---------------------------------------------------------------------------------------------------------------------------------------------
function ENT:GetAttackPosition()
	return self.AttackPosition or self:GetPos() +self:OBBCenter()
end
---------------------------------------------------------------------------------------------------------------------------------------------
function ENT:OnSummoned(owner)
	self:AddCard("Megaton Raid",16,true,"phys")
	self:AddCard("Megidola",24,false,"almighty")
	self:AddCard("Kouga",8,false,"bless")
	self:AddCard("Eiga",8,false,"curse")
	self:AddCard("Hamaon",15,false,"bless")
	self:AddCard("Mudoon",15,false,"curse")

	self:SetCard("Megidola")
	self:SetCard("Megaton Raid",true)

	local v = {forward=-230,right=100,up=60}
	self.User:SetNW2Vector("Persona_CustomPos",Vector(v.right,v.forward,v.up))
end
---------------------------------------------------------------------------------------------------------------------------------------------
function ENT:OnRequestDisappear(ply)
	
end