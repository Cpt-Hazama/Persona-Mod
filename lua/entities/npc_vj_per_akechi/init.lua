AddCSLuaFile("shared.lua")
include('shared.lua')
/*-----------------------------------------------
	*** Copyright (c) 2012-2019 by Cpt. Hazama, All rights reserved. ***
	No parts of this code or any of its contents may be reproduced, copied, modified or adapted,
	without the prior written consent of the author, unless otherwise indicated for stand-alone materials.
-----------------------------------------------*/
ENT.Model = {"models/cpthazama/persona5/akechi_royal.mdl"} -- The game will pick a random model from the table when the SNPC is spawned | Add as many as you want 
ENT.Stats = {
	HP = 5000,
	SP = 999,
	STR = 80,
	MAG = 30,
	END = 43,
	AGI = 50,
	LUC = 45,
}
ENT.VJ_NPC_Class = {"CLASS_BLACKMASK","CLASS_SHIDO"}

ENT.HasDeathAnimation = true
ENT.CanRespawn = true

ENT.SoundTbl_CombatIdle = {
	"cpthazama/persona5/akechi/00000_streaming [1].wav",
	"cpthazama/persona5/akechi/00018_streaming [1].wav",
	"cpthazama/persona5/akechi/00021_streaming [1].wav",
	"cpthazama/persona5/akechi/blackmask/00000_streaming [1].wav",
	"cpthazama/persona5/akechi/blackmask/00005_streaming [1].wav",
	"cpthazama/persona5/akechi/blackmask/00007_streaming [1].wav",
	"cpthazama/persona5/akechi/blackmask/00013_streaming [1].wav",
	"cpthazama/persona5/akechi/blackmask/00015_streaming [1].wav",
}
ENT.SoundTbl_Pain = {
	"cpthazama/persona5/akechi/blackmask/00009_streaming [1].wav",
	"cpthazama/persona5/akechi/blackmask/00011_streaming [1].wav",
	"cpthazama/persona5/akechi/blackmask/00012_streaming [1].wav",
	"cpthazama/persona5/akechi/blackmask/00023_streaming [1].wav",
	"cpthazama/persona5/akechi/blackmask/00024_streaming [1].wav",
	"cpthazama/persona5/akechi/blackmask/00030_streaming [1].wav",
	"cpthazama/persona5/akechi/blackmask/00031_streaming [1].wav",
	"cpthazama/persona5/akechi/blackmask/pain01.wav",
	"cpthazama/persona5/akechi/blackmask/pain02.wav",
	"cpthazama/persona5/akechi/blackmask/pain03.wav",
	"cpthazama/persona5/akechi/blackmask/pain04.wav",
	"cpthazama/persona5/akechi/blackmask/pain05.wav",
	"cpthazama/persona5/akechi/blackmask/pain06.wav",
	"cpthazama/persona5/akechi/blackmask/pain07.wav",
}
ENT.SoundTbl_Death = {
	"cpthazama/persona5/akechi/blackmask/00018_streaming [1].wav",
	"cpthazama/persona5/akechi/blackmask/00019_streaming [1].wav",
	"cpthazama/persona5/akechi/blackmask/00020_streaming [1].wav",
	"cpthazama/persona5/akechi/blackmask/00026_streaming [1].wav",
	"cpthazama/persona5/akechi/blackmask/pain09.wav",
}
ENT.SoundTbl_CallForMedic = {"cpthazama/persona5/akechi/blackmask/callforhelp01.wav"}
ENT.SoundTbl_OnKilledEnemy = {
	"cpthazama/persona5/akechi/blackmask/00000_streaming [1].wav",
	"cpthazama/persona5/akechi/blackmask/00013_streaming [1].wav",
	"cpthazama/persona5/akechi/blackmask/00014_streaming [1].wav",
	"cpthazama/persona5/akechi/blackmask/00016_streaming [1].wav",
	"cpthazama/persona5/akechi/00007_streaming [1].wav",
	"cpthazama/persona5/akechi/00008_streaming [1].wav",
	"cpthazama/persona5/akechi/00009_streaming [1].wav",
	"cpthazama/persona5/akechi/blackmask/kill01.wav",
	"cpthazama/persona5/akechi/blackmask/kill02.wav",
	"cpthazama/persona5/akechi/blackmask/kill03.wav",
}
ENT.SoundTbl_Dodge = {
	"cpthazama/persona5/akechi/blackmask/00011_streaming [1].wav",
	"cpthazama/persona5/akechi/blackmask/00015_streaming [1].wav",
	"cpthazama/persona5/akechi/blackmask/00017_streaming [1].wav",
	"cpthazama/persona5/akechi/blackmask/00021_streaming [1].wav",
	"cpthazama/persona5/akechi/blackmask/00022_streaming [1].wav",
	"cpthazama/persona5/akechi/blackmask/dodge01.wav",
	"cpthazama/persona5/akechi/blackmask/dodge02.wav",
	"cpthazama/persona5/akechi/blackmask/dodge03.wav",
}
ENT.SoundTbl_Persona = {
	"cpthazama/persona5/akechi/blackmask/00010_streaming [1].wav",
	"cpthazama/persona5/akechi/blackmask/00028_streaming [1].wav",
	"cpthazama/persona5/akechi/blackmask/00029_streaming [1].wav",
}
ENT.SoundTbl_PersonaAttack = {
	"cpthazama/persona5/akechi/blackmask/00003_streaming [1].wav",
	"cpthazama/persona5/akechi/blackmask/00004_streaming [1].wav",
	"cpthazama/persona5/akechi/blackmask/00005_streaming [1].wav",
	"cpthazama/persona5/akechi/blackmask/00006_streaming [1].wav",
	"cpthazama/persona5/akechi/blackmask/00007_streaming [1].wav",
	"cpthazama/persona5/akechi/blackmask/00008_streaming [1].wav",
	"cpthazama/persona5/akechi/blackmask/melee01.wav",
	"cpthazama/persona5/akechi/blackmask/melee02.wav",
	"cpthazama/persona5/akechi/blackmask/melee03.wav",
}
ENT.SoundTbl_GetUp = {
	"cpthazama/persona5/akechi/blackmask/00009_streaming [1].wav",
	"cpthazama/persona5/akechi/blackmask/00025_streaming [1].wav",
	"cpthazama/persona5/akechi/blackmask/00027_streaming [1].wav",
}

util.AddNetworkString("vj_persona_hud_akechi")

ENT.Animations = {}
ENT.Animations["idle"] = ACT_IDLE
ENT.Animations["idle_combat"] = ACT_IDLE_ANGRY
ENT.Animations["idle_low"] = ACT_IDLE_STIMULATED
ENT.Animations["walk"] = ACT_WALK
ENT.Animations["walk_combat"] = ACT_WALK
ENT.Animations["run"] = ACT_RUN
ENT.Animations["run_combat"] = ACT_RUN_STIMULATED
ENT.Animations["melee"] = "persona_attack"
ENT.Animations["range_start"] = "persona_attack_start"
ENT.Animations["range_start_idle"] = "persona_attack_start_idle"
ENT.Animations["range"] = "persona_attack"
ENT.Animations["range_idle"] = "persona_attack_idle"
ENT.Animations["range_end"] = "persona_attack_end"

ENT.Persona = "loki"
---------------------------------------------------------------------------------------------------------------------------------------------
function ENT:CustomOnTakeDamage_AfterDamage(dmginfo,hitgroup)
	local t = dmginfo:GetDamageType()
	local tbl = {
		"cpthazama/persona5/akechi/blackmask/00009_streaming [1].wav",
		"cpthazama/persona5/akechi/blackmask/00011_streaming [1].wav",
		"cpthazama/persona5/akechi/blackmask/00012_streaming [1].wav",
		"cpthazama/persona5/akechi/blackmask/00023_streaming [1].wav",
		"cpthazama/persona5/akechi/blackmask/00024_streaming [1].wav",
		"cpthazama/persona5/akechi/blackmask/00030_streaming [1].wav",
		"cpthazama/persona5/akechi/blackmask/00031_streaming [1].wav",
		"cpthazama/persona5/akechi/blackmask/pain01.wav",
		"cpthazama/persona5/akechi/blackmask/pain02.wav",
		"cpthazama/persona5/akechi/blackmask/pain03.wav",
		"cpthazama/persona5/akechi/blackmask/pain04.wav",
		"cpthazama/persona5/akechi/blackmask/pain05.wav",
		"cpthazama/persona5/akechi/blackmask/pain06.wav",
		"cpthazama/persona5/akechi/blackmask/pain07.wav",
	}
	
	if math.random(1,2) == 1 then
		if t == DMG_P_PSI then
			tbl = {
				"cpthazama/persona5/akechi/blackmask/pain_dizzy.wav",
			}
		elseif t == DMG_P_ELEC || t == DMG_SHOCK then
			tbl = {
				"cpthazama/persona5/akechi/blackmask/pain_elec.wav",
			}
		elseif t == DMG_P_SEAL then
			tbl = {
				"cpthazama/persona5/akechi/blackmask/pain_seal.wav",
			}
		elseif t == DMG_P_ICE || t == DMG_P_FROST || t == DMG_FROST || t == DMG_FREEZE then
			tbl = {
				"cpthazama/persona5/akechi/blackmask/pain_ice.wav",
			}
		elseif t == DMG_P_FIRE || t == DMG_P_BURN || t == DMG_BURN then
			tbl = {
				"cpthazama/persona5/akechi/blackmask/pain_fire.wav",
			}
		elseif t == DMG_P_FEAR then
			tbl = {
				"cpthazama/persona5/akechi/blackmask/pain_fear.wav",
			}
		elseif t == DMG_P_SLEEP || t == DMG_P_PARALYZE then
			tbl = {
				"cpthazama/persona5/akechi/blackmask/pain_sleep.wav",
			}
		end
	end
	self.SoundTbl_Pain = tbl
end
---------------------------------------------------------------------------------------------------------------------------------------------
function ENT:Controller_Initialize(ply)
    net.Start("vj_persona_hud_akechi")
		net.WriteBool(false)
		net.WriteEntity(self)
    net.Send(ply)

	function self.VJ_TheControllerEntity:CustomOnStopControlling()
		net.Start("vj_persona_hud_akechi")
			net.WriteBool(true)
			net.WriteEntity(self)
		net.Send(ply)
	end
end
---------------------------------------------------------------------------------------------------------------------------------------------
function ENT:PersonaInit()
	self:SetBodygroup(1,1)
	self.IsGood = false
	-- self:ChangeFaction(true)
end
---------------------------------------------------------------------------------------------------------------------------------------------
function ENT:ChangeFaction(bEvil)
	if bEvil then
		if self:GetCostumeName() == "Black Suit" then
			for k, v in ipairs(self:GetMaterials()) do
				if v == "models/cpthazama/persona5/akechi/body" then
					self.DeathCorpseSubMaterials = {k -1}
					self:SetSubMaterial(k -1,"models/cpthazama/persona5/akechi/body_good")
				end
				if v == "models/cpthazama/persona5/akechi/mask" then
					self.DeathCorpseSubMaterials = {k -1}
					self:SetSubMaterial(k -1,"models/cpthazama/persona5/akechi/mask_good")
				end
			end
		end
		self.VJ_NPC_Class = {"CLASS_PLAYER_ALLY","CLASS_PHANTOMTHIEVES"}
		self.Animations["idle_combat"] = ACT_IDLE
		self.IsGood = true
	else
		if self:GetCostumeName() == "Black Suit" then
			for k, v in ipairs(self:GetMaterials()) do
				if v == "models/cpthazama/persona5/akechi/body" then
					self.DeathCorpseSubMaterials = {k -1}
					self:SetSubMaterial(k -1,nil)
				end
				if v == "models/cpthazama/persona5/akechi/mask" then
					self.DeathCorpseSubMaterials = {k -1}
					self:SetSubMaterial(k -1,nil)
				end
			end
		end
		self.VJ_NPC_Class = {"CLASS_BLACKMASK","CLASS_SHIDO"}
		self.Animations["idle_combat"] = ACT_IDLE_ANGRY
		self.IsGood = false
	end
end
---------------------------------------------------------------------------------------------------------------------------------------------
function ENT:OnSummonPersona(persona)
	if self.IsGood then
		persona:SetMaterial("models/cpthazama/persona5/loki/loki_good")
	end
	self.VJC_Data.ThirdP_Offset = Vector(-80, 80, 0)
end
---------------------------------------------------------------------------------------------------------------------------------------------
function ENT:OnDisablePersona(persona)
	self.VJC_Data.ThirdP_Offset = Vector(-15, 40, -35)
end
---------------------------------------------------------------------------------------------------------------------------------------------
function ENT:OnThink()
	if self.PlayerFriendly == true && self.IsGood == false then
		self:ChangeFaction(true)
	elseif self.PlayerFriendly == false && self.IsGood == true then
		self:ChangeFaction(false)
	end
	if self.MetaVerseMode && self:Health() > 0 then
		self:SetPoseParameter("anger",0.6)
	else
		self:SetPoseParameter("anger",0)
	end
end
---------------------------------------------------------------------------------------------------------------------------------------------
function ENT:UseItem(class,t)
	if CurTime() > self.NextUseT && !self:BusyWithActivity() then
		self:VJ_ACT_PLAYACTIVITY("item_start",true,false,true)
		timer.Simple(self:DecideAnimationLength("item_start",false),function()
			if IsValid(self) then
				local ent = ents.Create(class)
				ent:SetPos(self:GetPos() +self:OBBCenter())
				ent:Spawn()
				ent:SetCollisionGroup(COLLISION_GROUP_IN_VEHICLE)
				ent:Use(self,self)
				self.NextUseT = CurTime() +(t or math.Rand(2,4))
				
				self:VJ_ACT_PLAYACTIVITY("item_end",true,false,true)
			end
		end)
	end
end
---------------------------------------------------------------------------------------------------------------------------------------------
function ENT:HandleAnimations()
	self.CurrentIdle = IsValid(self:GetPersona()) && self.Animations["idle_combat"] or self.Animations["idle"]
	self.CurrentWalk = IsValid(self:GetPersona()) && self.Animations["walk_combat"] or self.Animations["walk"]
	self.CurrentRun = IsValid(self:GetPersona()) && self.Animations["run_combat"] or self.Animations["run"]

	if self:Health() <= self:GetMaxHealth() *0.4 then
		self.CurrentIdle = self.Animations["idle_low"]
	end

	if self:GetState() == 0 then
		self.AnimTbl_IdleStand = {self.CurrentIdle}
		self.AnimTbl_Walk = {self.CurrentWalk}
		self.AnimTbl_Run = {self.CurrentRun}
	end
end
/*-----------------------------------------------
	*** Copyright (c) 2012-2019 by Cpt. Hazama, All rights reserved. ***
	No parts of this code or any of its contents may be reproduced, copied, modified or adapted,
	without the prior written consent of the author, unless otherwise indicated for stand-alone materials.
-----------------------------------------------*/