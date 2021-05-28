AddCSLuaFile("shared.lua")
include('shared.lua')
/*-----------------------------------------------
	*** Copyright (c) 2012-2019 by Cpt. Hazama, All rights reserved. ***
	No parts of this code or any of its contents may be reproduced, copied, modified or adapted,
	without the prior written consent of the author, unless otherwise indicated for stand-alone materials.
-----------------------------------------------*/
ENT.Model = {"models/player/kleiner.mdl"} -- The game will pick a random model from the table when the SNPC is spawned | Add as many as you want 
ENT.Stats = {
	HP = 100,
	SP = 50,
}
ENT.VJ_NPC_Class = {"CLASS_PERSONA_ENEMY","CLASS_SHADOW"}


ENT.HasDeathAnimation = true
ENT.DeathCorpseEntityClass = "UseDefaultBehavior"
ENT.AnimTbl_Death = {"death_01","death_02","death_03","death_04"}
ENT.CanRespawn = false
ENT.HasAltForm = false

ENT.SoundTbl_CombatIdle = {}
ENT.SoundTbl_Pain = {}
ENT.SoundTbl_Death = {}
ENT.SoundTbl_OnKilledEnemy = {}
ENT.SoundTbl_Dodge = {}
ENT.SoundTbl_Persona = {}
ENT.SoundTbl_PersonaAttack = {}
ENT.SoundTbl_GetUp = {}

ENT.Animations = {}
ENT.Animations["idle"] = ACT_HL2MP_IDLE
ENT.Animations["idle_combat"] = ACT_HL2MP_IDLE_KNIFE
ENT.Animations["idle_low"] = ACT_HL2MP_IDLE_CROUCH_KNIFE
ENT.Animations["walk"] = ACT_HL2MP_WALK
ENT.Animations["walk_combat"] = ACT_HL2MP_WALK_KNIFE
ENT.Animations["run"] = ACT_HL2MP_RUN
ENT.Animations["run_combat"] = ACT_HL2MP_RUN_KNIFE
ENT.Animations["melee"] = "vjseq_taunt_laugh_base"
ENT.Animations["range_start"] = "vjseq_gesture_disagree_original"
ENT.Animations["range_start_idle"] = -1
ENT.Animations["range"] = "vjseq_gesture_wave_original"
ENT.Animations["range_idle"] = "idle_all_angry"
ENT.Animations["range_end"] = "vjseq_taunt_cheer_base"
---------------------------------------------------------------------------------------------------------------------------------------------
function ENT:BeforeInit()
	if !IsValid(self.Player) then
		self.Player = VJ_PICK(player.GetAll()) or Entity(1)
		print("No Player set! Picking randomly...")
	end
	
	local b,b2 = self:GetCollisionBounds()[1],self:OBBMaxs().z
	self:SetModel(self.Player:GetModel())
	self.StarterPersona = VJ_PICK(PERSONA_STARTERS)
	self.AvailablePersonae = PXP.GetPersonaData(self.Player,4) or {self.StarterPersona}
	self.Persona = VJ_PICK(self.AvailablePersonae)
	
	self.Animations["idle_combat"] = VJ_SequenceToActivity(self,"pose_standing_01")
	self.Animations["range_start_idle"] = VJ_SequenceToActivity(self,"pose_standing_01")

	self.Stats = {
		HP = self.Player:GetMaxHealth(),
		SP = self.Player:GetMaxSP(),
	}
	
	local l,e = PXP.GetPersonaData(self.Player,9), PXP.GetPersonaData(self.Player,10)
	timer.Simple(0.02,function()
		self:SetNW2Int("PXP_Level",l)
		self:SetNW2Int("PXP_EXP",e)
	end)
	
	ParticleEffectAttach("vj_per_shadow_idle",PATTACH_POINT_FOLLOW,self,self:LookupAttachment("origin"))
	
	self.NextSwitchT = CurTime() +15

	self:SetCollisionBounds(Vector(b,b,b2),Vector(-b,-b,0))
end
---------------------------------------------------------------------------------------------------------------------------------------------
function ENT:GetSightDirection()
	return self:GetAttachment(self:LookupAttachment("eyes")).Ang:Forward()
end
---------------------------------------------------------------------------------------------------------------------------------------------
function ENT:OnDisablePersona(persona)
	self.VJC_Data.ThirdP_Offset = Vector(-15, 40, -35)
	ParticleEffectAttach("vj_per_shadow_idle",PATTACH_POINT_FOLLOW,self,self:LookupAttachment("origin"))
end
---------------------------------------------------------------------------------------------------------------------------------------------
function ENT:SwitchPersona(persona)
	local selected = persona
	if selected == nil then
		local tbl = {}
		for persona,v in pairs(self.AvailablePersonae) do
			table.insert(tbl,persona)
		end
		selected = tbl[math.random(1,#tbl)]
	end

	if IsValid(self:GetPersona()) then
		self:SummonPersona(self.Persona)
	end
	self.NextSwitchT = CurTime() +math.Rand(15,30)
end
---------------------------------------------------------------------------------------------------------------------------------------------
function ENT:OnThink()
	self:DecideXY()
	if IsValid(self:GetEnemy()) && CurTime() > self.NextSwitchT && math.random(1,30) == 1 then
		self:SwitchPersona()
	end
	if self:IsMoving() then
		if !self:BusyWithActivity() && self:GetPos():Distance(self:GetCurWaypointPos()) > 75 then
			self:FaceCertainPosition(self:GetCurWaypointPos())
		end
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
				
				self:VJ_ACT_PLAYACTIVITY("vjseq_smgdraw",true,false,true)
			end
		end)
	end
end
---------------------------------------------------------------------------------------------------------------------------------------------
function ENT:Between(a,b)
	local waypoint = self:GetCurWaypointPos()
	local ang = (waypoint -self:GetPos()):Angle()
	local dif = math.AngleDifference(self:GetAngles().y,ang.y)
	return dif < a && dif > b
end
---------------------------------------------------------------------------------------------------------------------------------------------
function ENT:DecideXY()
	local x = 0
	local y = 0
	if self:Between(30,-30) then
		x = 1
		y = 0
	elseif self:Between(70,30) then
		x = 1
		y = 1
	elseif self:Between(120,70) then
		x = 0
		y = 1
	elseif self:Between(150,120) then
		x = -1
		y = 1
	elseif !self:Between(150,-150) then
		x = -1
		y = 0
	elseif self:Between(-110,-150) then
		x = -1
		y = -1
	elseif self:Between(-70,-110) then
		x = 0
		y = -1
	elseif self:Between(-30,-70) then
		x = 1
		y = -1
	end

	self:SetPoseParameter("move_x",x)
	self:SetPoseParameter("move_y",y)
end
---------------------------------------------------------------------------------------------------------------------------------------------
function ENT:CustomOnKilled(dmginfo,hitgroup)
	if IsValid(self.Player) then
		local ply = self.Player
		local c = PXP.GetPersonaData(ply,4)
		if (!c) or (c && table.Count(c) <= 0) then
			ply:ChatPrint("You feel a power awaken inside of you...")
			PXP.AddToCompendium(ply,self.StarterPersona)
		end
	end
end
/*-----------------------------------------------
	*** Copyright (c) 2012-2019 by Cpt. Hazama, All rights reserved. ***
	No parts of this code or any of its contents may be reproduced, copied, modified or adapted,
	without the prior written consent of the author, unless otherwise indicated for stand-alone materials.
-----------------------------------------------*/