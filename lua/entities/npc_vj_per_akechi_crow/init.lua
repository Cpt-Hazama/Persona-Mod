AddCSLuaFile("shared.lua")
include('shared.lua')
/*-----------------------------------------------
	*** Copyright (c) 2012-2019 by Cpt. Hazama, All rights reserved. ***
	No parts of this code or any of its contents may be reproduced, copied, modified or adapted,
	without the prior written consent of the author, unless otherwise indicated for stand-alone materials.
-----------------------------------------------*/
ENT.Model = {"models/cpthazama/persona5/akechi_normal.mdl"} -- The game will pick a random model from the table when the SNPC is spawned | Add as many as you want 
ENT.Stats = {
	HP = 2200,
	SP = 999,
	STR = 60,
	MAG = 60,
	END = 36,
	AGI = 50,
	LUC = 36,
}
ENT.VJ_NPC_Class = {"CLASS_PLAYER_ALLY","CLASS_PHANTOMTHIEVES"}
ENT.FriendsWithAllPlayerAllies = true

ENT.HasDeathAnimation = true
ENT.CanRespawn = true

ENT.SoundTbl_CombatIdle = {
	"cpthazama/persona5/akechi/00000_streaming [1].wav",
	"cpthazama/persona5/akechi/00017_streaming [1].wav",
	"cpthazama/persona5/akechi/00018_streaming [1].wav",
}
ENT.SoundTbl_Pain = {
	"cpthazama/persona5/akechi/00005_streaming [1].wav",
	"cpthazama/persona5/akechi/00006_streaming [1].wav",
	"cpthazama/persona5/akechi/00010_streaming [1].wav",
	"cpthazama/persona5/akechi/00011_streaming [1].wav",
	"cpthazama/persona5/akechi/00012_streaming [1].wav",
	"cpthazama/persona5/akechi/00016_streaming [1].wav",
	"cpthazama/persona5/akechi/00020_streaming [1].wav",
}
ENT.SoundTbl_Death = {
	"cpthazama/persona5/akechi/00013_streaming [1].wav",
	"cpthazama/persona5/akechi/00019_streaming [1].wav",
}
ENT.SoundTbl_OnKilledEnemy = {
	"cpthazama/persona5/akechi/00007_streaming [1].wav",
	"cpthazama/persona5/akechi/00008_streaming [1].wav",
	"cpthazama/persona5/akechi/00009_streaming [1].wav",
}
ENT.SoundTbl_Dodge = {
}
ENT.SoundTbl_Persona = {
	"cpthazama/persona5/akechi/00001_streaming [1].wav",
	"cpthazama/persona5/akechi/00003_streaming [1].wav",
	"cpthazama/persona5/akechi/00004_streaming [1].wav",
}
ENT.SoundTbl_PersonaAttack = {
}
ENT.SoundTbl_GetUp = {
}

util.AddNetworkString("vj_persona_hud_akechi_crow")

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

ENT.Persona = "robinhood"
---------------------------------------------------------------------------------------------------------------------------------------------
function ENT:Controller_Initialize(ply)
    net.Start("vj_persona_hud_akechi_crow")
		net.WriteBool(false)
		net.WriteEntity(self)
    net.Send(ply)

	function self.VJ_TheControllerEntity:CustomOnStopControlling()
		net.Start("vj_persona_hud_akechi_crow")
			net.WriteBool(true)
			net.WriteEntity(self)
		net.Send(ply)
	end
end
---------------------------------------------------------------------------------------------------------------------------------------------
function ENT:PersonaInit()
	-- self:SetBodygroup(1,1)
end
---------------------------------------------------------------------------------------------------------------------------------------------
function ENT:OnSwitchMetaVerse(didSwitch)
	if didSwitch then
		self:SetModel("models/cpthazama/persona5/akechi_crow.mdl")
		self:SetBodygroup(1,1)
	else
		self:SetModel("models/cpthazama/persona5/akechi_normal.mdl")
		self:SetBodygroup(1,0)
	end
	self:SetPos(self:GetPos() +Vector(0,0,8))
end
---------------------------------------------------------------------------------------------------------------------------------------------
function ENT:OnThink()

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
	
	if self.MetaVerseMode then
		if hasPersona then
			self:SetBodygroup(1,0)
		else
			self:SetBodygroup(1,1)
		end
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