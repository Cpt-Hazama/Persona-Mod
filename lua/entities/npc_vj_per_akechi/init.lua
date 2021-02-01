AddCSLuaFile("shared.lua")
include('shared.lua')
/*-----------------------------------------------
	*** Copyright (c) 2012-2019 by Cpt. Hazama, All rights reserved. ***
	No parts of this code or any of its contents may be reproduced, copied, modified or adapted,
	without the prior written consent of the author, unless otherwise indicated for stand-alone materials.
-----------------------------------------------*/
ENT.Model = {"models/cpthazama/persona5/akechi_royal.mdl"} -- The game will pick a random model from the table when the SNPC is spawned | Add as many as you want 
ENT.Stats = {
	HP = 10000, // 5000
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
	"cpthazama/vo/akechi/blackmask/bp09_01 [134].wav",
	"cpthazama/vo/akechi/blackmask/bp09_01 [136].wav",
	"cpthazama/vo/akechi/blackmask/bp09_01 [14].wav",
	"cpthazama/vo/akechi/blackmask/bp09_01 [151].wav",
	"cpthazama/vo/akechi/blackmask/bp09_01 [152].wav",
	"cpthazama/vo/akechi/blackmask/bp09_01 [153].wav",
	"cpthazama/vo/akechi/blackmask/bp09_01 [156].wav",
	"cpthazama/vo/akechi/blackmask/bp09_01 [157].wav",
	"cpthazama/vo/akechi/blackmask/bp09_01 [158].wav",
}
ENT.SoundTbl_Alert = {
	"cpthazama/vo/akechi/blackmask/bp09_01 [134].wav",
	"cpthazama/vo/akechi/blackmask/bp09_01 [136].wav",
	"cpthazama/vo/akechi/blackmask/bp09_01 [153].wav",
	"cpthazama/vo/akechi/blackmask/bp09_01 [154].wav",
	"cpthazama/vo/akechi/blackmask/bp09_01 [155].wav",
	"cpthazama/vo/akechi/blackmask/bp09_01 [156].wav",
	"cpthazama/vo/akechi/blackmask/bp09_01 [157].wav",
	"cpthazama/vo/akechi/blackmask/bp09_01 [180].wav",
	"cpthazama/vo/akechi/blackmask/bp09_01 [181].wav",
	"cpthazama/vo/akechi/blackmask/bp09_01 [192].wav",
	"cpthazama/vo/akechi/blackmask/bp09_01 [195].wav",
	"cpthazama/vo/akechi/blackmask/bp09_01 [196].wav",
	"cpthazama/vo/akechi/blackmask/bp09_01 [208].wav",
	"cpthazama/vo/akechi/blackmask/bp09_01 [209].wav",
	"cpthazama/vo/akechi/blackmask/bp09_01 [211].wav",
	"cpthazama/vo/akechi/blackmask/bp09_01 [212].wav",
	"cpthazama/vo/akechi/blackmask/bp09_01 [221].wav",
	"cpthazama/vo/akechi/blackmask/bp09_01 [223].wav",
	"cpthazama/vo/akechi/blackmask/bp09_01 [2].wav",
	"cpthazama/vo/akechi/blackmask/bp09_01 [43].wav",
	"cpthazama/vo/akechi/blackmask/bp09_01 [6].wav",
	"cpthazama/vo/akechi/blackmask/bp09_01 [74].wav",
	"cpthazama/vo/akechi/blackmask/bp09_01 [8].wav",
	"cpthazama/vo/akechi/blackmask/bp09_01 [9].wav",
}
ENT.SoundTbl_Death = {
	"cpthazama/vo/akechi/blackmask/bp09_01 [59].wav",
	"cpthazama/vo/akechi/blackmask/bp09_01 [63].wav",
	"cpthazama/vo/akechi/blackmask/bp09_01 [90].wav",
	"cpthazama/vo/akechi/blackmask/bp09_01 [91].wav",
	"cpthazama/vo/akechi/blackmask/bp09_01 [92].wav",
	"cpthazama/vo/akechi/blackmask/bp09_01 [93].wav",
	"cpthazama/vo/akechi/blackmask/bp09_01 [94].wav",
	"cpthazama/vo/akechi/blackmask/bp09_01 [95].wav",
	"cpthazama/vo/akechi/blackmask/bp09_01 [96].wav",
	"cpthazama/vo/akechi/blackmask/bp09_01 [98].wav",
}
ENT.SoundTbl_CallForMedic = {"cpthazama/vo/akechi/blackmask/bp09_01 [99].wav"}
ENT.SoundTbl_OnKilledEnemy = {
	"cpthazama/vo/akechi/blackmask/bp09_01 [164].wav",
	"cpthazama/vo/akechi/blackmask/bp09_01 [165].wav",
	"cpthazama/vo/akechi/blackmask/bp09_01 [166].wav",
	"cpthazama/vo/akechi/blackmask/bp09_01 [167].wav",
	"cpthazama/vo/akechi/blackmask/bp09_01 [168].wav",
	"cpthazama/vo/akechi/blackmask/bp09_01 [187].wav",
	"cpthazama/vo/akechi/blackmask/bp09_01 [193].wav",
	"cpthazama/vo/akechi/blackmask/bp09_01 [194].wav",
	"cpthazama/vo/akechi/blackmask/bp09_01 [197].wav",
	"cpthazama/vo/akechi/blackmask/bp09_01 [198].wav",
	"cpthazama/vo/akechi/blackmask/bp09_01 [199].wav",
	"cpthazama/vo/akechi/blackmask/bp09_01 [200].wav",
	"cpthazama/vo/akechi/blackmask/bp09_01 [201].wav",
	"cpthazama/vo/akechi/blackmask/bp09_01 [202].wav",
	"cpthazama/vo/akechi/blackmask/bp09_01 [213].wav",
	"cpthazama/vo/akechi/blackmask/bp09_01 [214].wav",
	"cpthazama/vo/akechi/blackmask/bp09_01 [30].wav",
	"cpthazama/vo/akechi/blackmask/bp09_01 [78].wav",
	"cpthazama/vo/akechi/blackmask/bp09_01 [79].wav",
}
ENT.SoundTbl_Dodge = {
	"cpthazama/vo/akechi/blackmask/bp09_01 [114].wav",
	"cpthazama/vo/akechi/blackmask/bp09_01 [115].wav",
	"cpthazama/vo/akechi/blackmask/bp09_01 [116].wav",
	"cpthazama/vo/akechi/blackmask/bp09_01 [117].wav",
	"cpthazama/vo/akechi/blackmask/bp09_01 [118].wav",
	"cpthazama/vo/akechi/blackmask/bp09_01 [140].wav",
	"cpthazama/vo/akechi/blackmask/bp09_01 [97].wav",
}
ENT.SoundTbl_Persona = {
	"cpthazama/vo/akechi/blackmask/bp09_01 [127].wav",
	"cpthazama/vo/akechi/blackmask/bp09_01 [13].wav",
	"cpthazama/vo/akechi/blackmask/bp09_01 [151].wav",
	"cpthazama/vo/akechi/blackmask/bp09_01 [152].wav",
	"cpthazama/vo/akechi/blackmask/bp09_01 [224].wav",
	"cpthazama/vo/akechi/blackmask/bp09_01 [64].wav",
	"cpthazama/vo/akechi/blackmask/bp09_01 [65].wav",
	"cpthazama/vo/akechi/blackmask/bp09_01 [66].wav",
	"cpthazama/vo/akechi/blackmask/bp09_01 [67].wav",
	"cpthazama/vo/akechi/blackmask/bp09_01 [68].wav",
	"cpthazama/vo/akechi/blackmask/bp09_01 [75].wav",
}
ENT.SoundTbl_PersonaAttack = {
	"cpthazama/vo/akechi/blackmask/bp09_01 [175].wav",
	"cpthazama/vo/akechi/blackmask/bp09_01 [177].wav",
	"cpthazama/vo/akechi/blackmask/bp09_01 [223].wav",
	"cpthazama/vo/akechi/blackmask/bp09_01 [22].wav",
	"cpthazama/vo/akechi/blackmask/bp09_01 [23].wav",
	"cpthazama/vo/akechi/blackmask/bp09_01 [25].wav",
	"cpthazama/vo/akechi/blackmask/bp09_01 [27].wav",
	"cpthazama/vo/akechi/blackmask/bp09_01 [28].wav",
	"cpthazama/vo/akechi/blackmask/bp09_01 [31].wav",
	"cpthazama/vo/akechi/blackmask/bp09_01 [32].wav",
	"cpthazama/vo/akechi/blackmask/bp09_01 [33].wav",
	"cpthazama/vo/akechi/blackmask/bp09_01 [34].wav",
	"cpthazama/vo/akechi/blackmask/bp09_01 [35].wav",
	"cpthazama/vo/akechi/blackmask/bp09_01 [36].wav",
	"cpthazama/vo/akechi/blackmask/bp09_01 [37].wav",
	"cpthazama/vo/akechi/blackmask/bp09_01 [38].wav",
	"cpthazama/vo/akechi/blackmask/bp09_01 [39].wav",
	"cpthazama/vo/akechi/blackmask/bp09_01 [40].wav",
	"cpthazama/vo/akechi/blackmask/bp09_01 [76].wav",
	"cpthazama/vo/akechi/blackmask/bp09_01 [77].wav",
}
ENT.SoundTbl_GetUp = {
	"cpthazama/vo/akechi/blackmask/bp09_01 [143].wav",
	"cpthazama/vo/akechi/blackmask/bp09_01 [170].wav",
	"cpthazama/vo/akechi/blackmask/bp09_01 [171].wav",
}
ENT.SoundTbl_MedicReceiveHeal = {
	"cpthazama/vo/akechi/blackmask/bp09_01 [161].wav",
	"cpthazama/vo/akechi/blackmask/bp09_01 [162].wav",
	"cpthazama/vo/akechi/blackmask/bp09_01 [163].wav",
}
ENT.SoundTbl_OnReceiveOrder = {
	"cpthazama/vo/akechi/blackmask/bp09_01 [144].wav",
	"cpthazama/vo/akechi/blackmask/bp09_01 [145].wav",
	"cpthazama/vo/akechi/blackmask/bp09_01 [146].wav",
	"cpthazama/vo/akechi/blackmask/bp09_01 [147].wav",
	"cpthazama/vo/akechi/blackmask/bp09_01 [148].wav",
	"cpthazama/vo/akechi/blackmask/bp09_01 [149].wav",
	"cpthazama/vo/akechi/blackmask/bp09_01 [14].wav",
	"cpthazama/vo/akechi/blackmask/bp09_01 [150].wav",
	"cpthazama/vo/akechi/blackmask/bp09_01 [158].wav",
	"cpthazama/vo/akechi/blackmask/bp09_01 [210].wav",
	"cpthazama/vo/akechi/blackmask/bp09_01 [217].wav",
	"cpthazama/vo/akechi/blackmask/bp09_01 [218].wav",
	"cpthazama/vo/akechi/blackmask/bp09_01 [219].wav",
	"cpthazama/vo/akechi/blackmask/bp09_01 [220].wav",
	"cpthazama/vo/akechi/blackmask/bp09_01 [221].wav",
	"cpthazama/vo/akechi/blackmask/bp09_01 [5].wav",
	"cpthazama/vo/akechi/blackmask/bp09_01 [62].wav",
}
ENT.SoundTbl_IdleDialogueAnswer = {
	"cpthazama/vo/akechi/blackmask/bp09_01 [119].wav",
	"cpthazama/vo/akechi/blackmask/bp09_01 [11].wav",
	"cpthazama/vo/akechi/blackmask/bp09_01 [120].wav",
	"cpthazama/vo/akechi/blackmask/bp09_01 [128].wav",
	"cpthazama/vo/akechi/blackmask/bp09_01 [135].wav",
	"cpthazama/vo/akechi/blackmask/bp09_01 [138].wav",
	"cpthazama/vo/akechi/blackmask/bp09_01 [139].wav",
	"cpthazama/vo/akechi/blackmask/bp09_01 [141].wav",
	"cpthazama/vo/akechi/blackmask/bp09_01 [145].wav",
	"cpthazama/vo/akechi/blackmask/bp09_01 [156].wav",
	"cpthazama/vo/akechi/blackmask/bp09_01 [169].wav",
	"cpthazama/vo/akechi/blackmask/bp09_01 [172].wav",
	"cpthazama/vo/akechi/blackmask/bp09_01 [173].wav",
	"cpthazama/vo/akechi/blackmask/bp09_01 [174].wav",
	"cpthazama/vo/akechi/blackmask/bp09_01 [182].wav",
	"cpthazama/vo/akechi/blackmask/bp09_01 [183].wav",
	"cpthazama/vo/akechi/blackmask/bp09_01 [184].wav",
	"cpthazama/vo/akechi/blackmask/bp09_01 [185].wav",
	"cpthazama/vo/akechi/blackmask/bp09_01 [186].wav",
	"cpthazama/vo/akechi/blackmask/bp09_01 [188].wav",
	"cpthazama/vo/akechi/blackmask/bp09_01 [189].wav",
	"cpthazama/vo/akechi/blackmask/bp09_01 [190].wav",
	"cpthazama/vo/akechi/blackmask/bp09_01 [191].wav",
}
ENT.SoundTbl_SwitchFaction_Good = {
	"cpthazama/vo/akechi/blackmask/bp09_01 [122].wav",
	"cpthazama/vo/akechi/blackmask/bp09_01 [125].wav",
	"cpthazama/vo/akechi/blackmask/bp09_01 [132].wav",
	"cpthazama/vo/akechi/blackmask/bp09_01 [133].wav",
	"cpthazama/vo/akechi/blackmask/bp09_01 [130].wav",
	"cpthazama/vo/akechi/blackmask/bp09_01 [12].wav",
}
ENT.SoundTbl_SwitchFaction_Evil = {
	"cpthazama/vo/akechi/blackmask/bp09_01 [11].wav",
	"cpthazama/vo/akechi/blackmask/bp09_01 [123].wav",
	"cpthazama/vo/akechi/blackmask/bp09_01 [124].wav",
	"cpthazama/vo/akechi/blackmask/bp09_01 [127].wav",
	"cpthazama/vo/akechi/blackmask/bp09_01 [128].wav",
	"cpthazama/vo/akechi/blackmask/bp09_01 [131].wav",
	"cpthazama/vo/akechi/blackmask/bp09_01 [134].wav",
	"cpthazama/vo/akechi/blackmask/bp09_01 [135].wav",
	"cpthazama/vo/akechi/blackmask/bp09_01 [136].wav",
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
ENT.HasAltForm = false
---------------------------------------------------------------------------------------------------------------------------------------------
function ENT:CustomOnTakeDamage_AfterDamage(dmginfo,hitgroup)
	local t = dmginfo:GetDamageType()
	local tbl = {
		"cpthazama/vo/akechi/blackmask/bp09_01 [109].wav",
		"cpthazama/vo/akechi/blackmask/bp09_01 [10].wav",
		"cpthazama/vo/akechi/blackmask/bp09_01 [110].wav",
		"cpthazama/vo/akechi/blackmask/bp09_01 [111].wav",
		"cpthazama/vo/akechi/blackmask/bp09_01 [112].wav",
		"cpthazama/vo/akechi/blackmask/bp09_01 [113].wav",
		"cpthazama/vo/akechi/blackmask/bp09_01 [178].wav",
		"cpthazama/vo/akechi/blackmask/bp09_01 [179].wav",
		"cpthazama/vo/akechi/blackmask/bp09_01 [80].wav",
		"cpthazama/vo/akechi/blackmask/bp09_01 [81].wav",
		"cpthazama/vo/akechi/blackmask/bp09_01 [82].wav",
		"cpthazama/vo/akechi/blackmask/bp09_01 [83].wav",
		"cpthazama/vo/akechi/blackmask/bp09_01 [84].wav",
		"cpthazama/vo/akechi/blackmask/bp09_01 [85].wav",
		"cpthazama/vo/akechi/blackmask/bp09_01 [86].wav",
		"cpthazama/vo/akechi/blackmask/bp09_01 [87].wav",
		"cpthazama/vo/akechi/blackmask/bp09_01 [88].wav",
		"cpthazama/vo/akechi/blackmask/bp09_01 [89].wav",
	}
	
	if math.random(1,2) == 1 then
		if t == DMG_P_PSI then
			tbl = {
				"cpthazama/vo/akechi/blackmask/bp09_01 [104].wav",
			}
		elseif t == DMG_P_ELEC || t == DMG_SHOCK then
			tbl = {
				"cpthazama/vo/akechi/blackmask/bp09_01 [15].wav",
			}
		elseif t == DMG_P_SEAL then
			tbl = {
				"cpthazama/vo/akechi/blackmask/bp09_01 [106].wav",
			}
		elseif t == DMG_P_ICE || t == DMG_P_FROST || t == DMG_FROST || t == DMG_FREEZE then
			tbl = {
				"cpthazama/vo/akechi/blackmask/bp09_01 [101].wav",
			}
		elseif t == DMG_P_FIRE || t == DMG_P_BURN || t == DMG_BURN then
			tbl = {
				"cpthazama/vo/akechi/blackmask/bp09_01 [100].wav",
			}
		elseif t == DMG_P_FEAR then
			tbl = {
				"cpthazama/vo/akechi/blackmask/bp09_01 [105].wav",
				"cpthazama/vo/akechi/blackmask/bp09_01 [17].wav",
			}
		elseif t == DMG_P_SLEEP then
			tbl = {
				"cpthazama/vo/akechi/blackmask/bp09_01 [103].wav",
				"cpthazama/vo/akechi/blackmask/bp09_01 [107].wav",
			}
		elseif t == DMG_P_BRAINWASH then
			tbl = {
				"cpthazama/vo/akechi/blackmask/bp09_01 [108].wav",
			}
		elseif t == DMG_POISON || t == DMG_P_PARALYZE then
			tbl = {
				"cpthazama/vo/akechi/blackmask/bp09_01 [102].wav",
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
		VJ_CreateSound(self,self.SoundTbl_SwitchFaction_Evil,75)
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
		VJ_CreateSound(self,self.SoundTbl_SwitchFaction_Good,75)
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
	if IsValid(self:GetEnemy()) && self:Health() > 0 then
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
/*-----------------------------------------------
	*** Copyright (c) 2012-2019 by Cpt. Hazama, All rights reserved. ***
	No parts of this code or any of its contents may be reproduced, copied, modified or adapted,
	without the prior written consent of the author, unless otherwise indicated for stand-alone materials.
-----------------------------------------------*/