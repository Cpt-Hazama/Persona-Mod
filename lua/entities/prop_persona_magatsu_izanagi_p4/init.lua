AddCSLuaFile("shared.lua")
include("shared.lua")
---------------------------------------------------------------------------------------------------------------------------------------------
ENT.Bot_StopDistance = 100
ENT.Bot_Buttons = {
	[1] = {but={IN_ATTACK},dist=100,chance=1},
}
ENT.Model = "models/cpthazama/persona5/persona/magatsu_izanagi.mdl"
ENT.Name = "Magatsu-Izanagi (P4)"
ENT.Aura = "jojo_aura_red"
ENT.IdleSpeed = 2
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
	LVL = 82, -- Innate level
	STR = 67, -- Effectiveness of phys. attacks
	MAG = 58, -- Effectiveness of magic. attacks
	END = 70, -- Effectiveness of defense
	AGI = 52, -- Effectiveness of hit and evasion rates
	LUC = 55, -- Chance of getting a critical
	WK = {},
	RES = {},
	NUL = {DMG_P_CURSE,DMG_P_BLESS,DMG_P_MIRACLE},
}
---------------------------------------------------------------------------------------------------------------------------------------------
ENT.LeveledSkills = {
	{Level = 88, Name = "Heat Riser", Cost = 30, UsesHP = false, Icon = "passive"},
	{Level = 85, Name = "Megidolaon", Cost = 38, UsesHP = false, Icon = "almighty"},
	{Level = 83, Name = "Magarudyne", Cost = 22, UsesHP = false, Icon = "wind"},
}
ENT.LegendaryMaterials = {}
ENT.LegendaryMaterials[1] = "models/cpthazama/persona5/magatsuizanagi/magatsuizanagi_legendary"
ENT.LegendaryMaterials[2] = "models/cpthazama/persona5/magatsuizanagi/magatsuizanagi_fx2_legendary"
ENT.LegendaryMaterials[3] = "models/cpthazama/persona5/magatsuizanagi/magatsuizanagi_classic_legendary"
ENT.LegendaryMaterials[4] = "models/cpthazama/persona5/magatsuizanagi/magatsuizanagi_classic_fx_legendary"
---------------------------------------------------------------------------------------------------------------------------------------------
function ENT:HandleEvents(skill,animBlock,seq,t)
	if skill == "Ghostly Wail" then
		if animBlock == "melee" then
			self.User:EmitSound("cpthazama/persona5/adachi/vo/ghostly_wail_0" .. math.random(1,2) .. ".wav",85)
		end
	end
end
---------------------------------------------------------------------------------------------------------------------------------------------
function ENT:CustomOnHitEntity(hitEnts,dmginfo)
	-- if dmginfo:GetDamageType() == DMG_P_FEAR then
		for _,v in pairs(hitEnts) do
			if IsValid(v) && v:Health() > 0 then
				self:Fear(v,15)
			end
		end
	-- end
end
---------------------------------------------------------------------------------------------------------------------------------------------
function ENT:PersonaControls_NPC(ply,persona)

end
---------------------------------------------------------------------------------------------------------------------------------------------
function ENT:PersonaControls(ply,persona)
	if ply:IsNPC() then
		return
	end
	local lmb = ply:KeyDown(IN_ATTACK)
	local rmb = ply:KeyDown(IN_ATTACK2)
	local r = ply:KeyDown(IN_RELOAD)
end
---------------------------------------------------------------------------------------------------------------------------------------------
function ENT:GetAttackPosition()
	return self:GetTask() == "TASK_ATTACK" && self:GetPos() +self:OBBCenter() +self:GetForward() *675 or self:GetPos() +self:OBBCenter()
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
	if ply:IsPlayer() then ply:EmitSound("cpthazama/persona5/adachi/vo/summon_0" .. math.random(1,8) .. ".wav") end
	self:SetModel(self.Model)
	self.PersonaDistance = 999999999 -- 40 meters
	self.RechargeT = CurTime()
	self.IsArmed = false
	self.Magatsu = true
	
	self:SetSkin(1)

	self:AddCard("Maziodyne",22,false,"elec")
	-- self:AddCard("Heat Riser",30,false,"passive")
	self:AddCard("Maeigaon",22,false,"curse")
	self:AddCard("Ghastly Wail",19,true,"almighty")
	self:AddCard("Evil Smile",12,false,"sleep")
	self:AddCard("Charge",15,false,"passive")
	self:AddCard("Megidola",24,false,"almighty")

	self:SetCard("Maziodyne")
	self:SetCard("Ghastly Wail",true)

	local v = {forward=-200,right=80,up=50}
	ply:SetNWVector("Persona_CustomPos",Vector(v.right,v.forward,v.up))
end
---------------------------------------------------------------------------------------------------------------------------------------------
function ENT:OnRequestDisappear(ply)
	-- ply:EmitSound("cpthazama/persona5/joker/0" .. math.random(106,120) .. ".wav")
	local tbl = {
		"cpthazama/vox/adachi/kill/vbtl_pad_0#98 (pad152).wav",
		"cpthazama/vox/adachi/kill/vbtl_pad_0#96 (pad150).wav",
		"cpthazama/vox/adachi/kill/vbtl_pad_0#179 (pad300_1).wav",
		"cpthazama/vox/adachi/kill/vbtl_pad_0#180 (pad300_2).wav",
	}
	ply:EmitSound(VJ_PICK(tbl))
end