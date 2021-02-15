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
ENT.LegendaryMaterials = {}
ENT.LegendaryMaterials[1] = "models/cpthazama/persona5/tsukiyomi/tsukiyomi_legendary"
ENT.LegendaryMaterials[4] = "models/cpthazama/persona5/tsukiyomi/helmet_legendary"
---------------------------------------------------------------------------------------------------------------------------------------------
function ENT:HandleEvents(skill,animBlock,seq,t)
	local ply = self.User
	if animBlock == "melee" then
		local tbl = {
			"cpthazama/vo/sho/nb400a.wav",
			"cpthazama/vo/sho/nb400b.wav",
			"cpthazama/vo/sho/no124a.wav",
			"cpthazama/vo/sho/no125a.wav",
			"cpthazama/vo/sho/no126a.wav",
			"cpthazama/vo/sho/no126ak.wav",
			"cpthazama/vo/sho/no127a.wav",
			"cpthazama/vo/sho/no127b.wav",
			"cpthazama/vo/sho/no128a.wav",
		}
		self:UserSound(VJ_PICK(tbl))
	end
	if animBlock == "special" then
		local tbl = {
			"cpthazama/vo/sho/nb313b.wav"
		}
		self:UserSound(VJ_PICK(tbl))
	end
	if skill == "Abyssal Wings" then
		if animBlock == "range_start" then
			self.Set = math.random(1,2)
			self:UserSound(self.Set == 1 && "cpthazama/vo/sho/nb313b.wav" or "cpthazama/vo/sho/nb322a.wav")
		end
		if animBlock == "range" then
			self:UserSound(self.Set == 1 && "cpthazama/vo/sho/nb322b.wav" or "cpthazama/vo/sho/nb323a.wav")
		end
	else
		if animBlock == "range_start" then
			local tbl = {
				"cpthazama/vo/sho/no304a.wav",
				"cpthazama/vo/sho/nb400a.wav",
				"cpthazama/vo/sho/nb400b.wav",
			}
			self:UserSound(VJ_PICK(tbl))
		end
		if animBlock == "range" then
			local tbl = {
				"cpthazama/vo/sho/no303b.wav",
				"cpthazama/vo/sho/nb323b.wav",
			}
			self:UserSound(VJ_PICK(tbl))
		end
	end
end
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
local mN = "models/cpthazama/persona5/tsukiyomi/tsukiyomi"
local mI = "models/cpthazama/persona5/tsukiyomi/tsukiyomi_instakill"
local mN_L = "models/cpthazama/persona5/tsukiyomi/tsukiyomi_legendary"
local mI_L = "models/cpthazama/persona5/tsukiyomi/tsukiyomi_instakill_legendary"
function ENT:OnThink(ply)
	local isL = PXP.IsLegendary(ply)
	self.CurrentState = (self:GetTask() == "TASK_IDLE" && 1) or 0
	if self.CurrentState != self.LastState then
		local mat = (self.CurrentState == 1 && (isL && mN_L or mN)) or (isL && mI_L or mI)
		self:SetSubMaterial(0,mat)
		self.LastState = self.CurrentState
	end
end
---------------------------------------------------------------------------------------------------------------------------------------------
function ENT:OnSummoned(ply)
	local tbl = {
		"cpthazama/vo/sho/nb213a.wav",
		"cpthazama/vo/sho/nb213b.wav",
		"cpthazama/vo/sho/no210a.wav",
		"cpthazama/vo/sho/no210b.wav",
		"cpthazama/vo/sho/no211a.wav",
		"cpthazama/vo/sho/no211b.wav",
	}
	self:UserSound(VJ_PICK(tbl))
	
	self:AddCard("Abyssal Wings",30,false,"curse")
	self:AddCard("Life Drain",3,false,"almighty")
	self:AddCard("Vorpal Blade")
	self:AddCard("Teleport",15,false,"passive")
	self:AddCard("Dream Fog")

	self:SetCard("Teleport")
	self:SetCard("Vorpal Blade",true)

	local v = {forward=-125,right=60,up=35}
	ply:SetNW2Vector("Persona_CustomPos",Vector(v.right,v.forward,v.up))

	self.CurrentState = 0
	self.LastState = 0
end
---------------------------------------------------------------------------------------------------------------------------------------------
function ENT:OnRequestDisappear(ply)
	self:UserSound("cpthazama/vo/sho/no127b.wav")
end