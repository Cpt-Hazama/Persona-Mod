AddCSLuaFile("shared.lua")
include("shared.lua")
---------------------------------------------------------------------------------------------------------------------------------------------
ENT.Bot_StopDistance = 100
ENT.Bot_Buttons = {
	[1] = {but={IN_ATTACK},dist=100,chance=1},
}

ENT.IzanagiType = true
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
	LVL = 99, -- Innate level
	STR = 85, -- Effectiveness of phys. attacks
	MAG = 98, -- Effectiveness of magic. attacks
	END = 95, -- Effectiveness of defense
	AGI = 85, -- Effectiveness of hit and evasion rates
	LUC = 80, -- Chance of getting a critical
	WK = {DMG_P_PSI},
	RES = {
		DMG_P_PHYS,
		DMG_P_FIRE,
		DMG_P_ICE,
		DMG_P_WIND,
		DMG_P_ELEC,
		DMG_P_NUCLEAR,
		DMG_P_GUN,
		DMG_BULLET,
		DMG_SHOCK,
		DMG_BURN,
		DMG_VEHICLE,
	},
	NUL = {DMG_P_CURSE,DMG_P_NUCLEAR},
}
ENT.IsVelvetPersona = true
---------------------------------------------------------------------------------------------------------------------------------------------
function ENT:HandleEvents(skill,animBlock,seq,t)
	if skill == "Ghostly Wail" then
		if animBlock == "melee" then
			self:UserSound("cpthazama/vo/adachi/vo/ghostly_wail_0" .. math.random(1,2) .. ".wav",85)
		end
	end
end
---------------------------------------------------------------------------------------------------------------------------------------------
function ENT:CustomOnHitEntity(hitEnts,dmginfo)
	-- if dmginfo:GetDamageType() == DMG_P_FEAR then
		-- for _,v in pairs(hitEnts) do
			-- if IsValid(v) && v:Health() > 0 then
				-- self:Fear(v,15)
			-- end
		-- end
	-- end
end
---------------------------------------------------------------------------------------------------------------------------------------------
function ENT:GetAttackPosition()
	return self:GetPos() +self:OBBCenter()
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
	self:UserSound("cpthazama/vo/adachi/vo/summon_0" .. math.random(1,8) .. ".wav")

	self:AddCard("Velvet Mandala",48,false,"almighty")
	self:AddCard("Ghastly Wail",19,true,"almighty")
	self:AddCard("Charge",15,false,"passive")
	self:AddCard("Heat Riser",30,false,"passive")
	self:AddCard("Maziodyne",COST_P_MAZIODYNE,false,"elec")
	self:AddCard("Magarudyne",22,false,"wind")
	self:AddCard("Megidolaon",COST_P_MEGIDOLAON,false,"almighty")
	self:AddCard("Salvation",COST_P_SALVATION,false,"heal")

	self:SetCard("Velvet Mandala")
	self:SetCard("Ghastly Wail",true)

	local v = {forward=-200,right=80,up=50}
	ply:SetNW2Vector("Persona_CustomPos",Vector(v.right,v.forward,v.up))
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
	self:UserSound(VJ_PICK(tbl))
end