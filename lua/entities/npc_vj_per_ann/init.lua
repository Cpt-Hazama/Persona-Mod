AddCSLuaFile("shared.lua")
include('shared.lua')
/*-----------------------------------------------
	*** Copyright (c) 2012-2019 by Cpt. Hazama, All rights reserved. ***
	No parts of this code or any of its contents may be reproduced, copied, modified or adapted,
	without the prior written consent of the author, unless otherwise indicated for stand-alone materials.
-----------------------------------------------*/
ENT.Model = {"models/cpthazama/persona5/ann_school_winter.mdl"} -- The game will pick a random model from the table when the SNPC is spawned | Add as many as you want 
ENT.Stats = {
	HP = 786,
	SP = 845,
}
ENT.VJ_NPC_Class = {"CLASS_PLAYER_ALLY","CLASS_PHANTOMTHIEVES"}
ENT.FriendsWithAllPlayerAllies = true

ENT.HasDeathAnimation = true
ENT.CanRespawn = true

ENT.SoundTbl_CombatIdle = {}
ENT.SoundTbl_Pain = {}
ENT.SoundTbl_Death = {}
ENT.SoundTbl_OnKilledEnemy = {}
ENT.SoundTbl_Dodge = {}
ENT.SoundTbl_Persona = {}
ENT.SoundTbl_PersonaAttack = {}
ENT.SoundTbl_GetUp = {}

util.AddNetworkString("vj_persona_hud_ann")

ENT.Animations = {}
ENT.Animations["idle"] = ACT_IDLE
ENT.Animations["idle_combat"] = ACT_IDLE_AGITATED
ENT.Animations["idle_low"] = ACT_IDLE_STIMULATED
ENT.Animations["walk"] = ACT_WALK
ENT.Animations["walk_combat"] = ACT_WALK
ENT.Animations["run"] = ACT_RUN
ENT.Animations["run_combat"] = ACT_RUN_STIMULATED
ENT.Animations["melee"] = "persona"
ENT.Animations["range_start"] = "persona_start"
ENT.Animations["range_start_idle"] = "persona_start_idle"
ENT.Animations["range"] = "persona"
ENT.Animations["range_idle"] = "persona_idle"
ENT.Animations["range_end"] = "persona_end"

ENT.Persona = "carmen"
---------------------------------------------------------------------------------------------------------------------------------------------
function ENT:Controller_Initialize(ply)
    net.Start("vj_persona_hud_ann")
		net.WriteBool(false)
		net.WriteEntity(self)
    net.Send(ply)

	function self.VJ_TheControllerEntity:CustomOnStopControlling()
		net.Start("vj_persona_hud_ann")
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
		self:SetModel("models/cpthazama/persona5/ann.mdl")
		self:SetBodygroup(1,1)
	else
		self:SetModel("models/cpthazama/persona5/ann_school_winter.mdl")
		self:SetBodygroup(1,0)
	end
	local bounds = self.Bounds
	self:SetCollisionBounds(Vector(bounds.x,bounds.y,bounds.z),-Vector(bounds.x,bounds.y,0))
	self:SetPos(self:GetPos() +Vector(0,0,5))
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
function ENT:OnThink()
	if self.MetaVerseMode then
		if hasPersona then
			self:SetBodygroup(1,0)
		else
			self:SetBodygroup(1,1)
		end
	end
end
/*-----------------------------------------------
	*** Copyright (c) 2012-2019 by Cpt. Hazama, All rights reserved. ***
	No parts of this code or any of its contents may be reproduced, copied, modified or adapted,
	without the prior written consent of the author, unless otherwise indicated for stand-alone materials.
-----------------------------------------------*/