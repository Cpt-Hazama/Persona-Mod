AddCSLuaFile("shared.lua")
include('shared.lua')
/*-----------------------------------------------
	*** Copyright (c) 2012-2019 by Cpt. Hazama, All rights reserved. ***
	No parts of this code or any of its contents may be reproduced, copied, modified or adapted,
	without the prior written consent of the author, unless otherwise indicated for stand-alone materials.
-----------------------------------------------*/
ENT.Model = {"models/cpthazama/persona4/yu.mdl"} -- The game will pick a random model from the table when the SNPC is spawned | Add as many as you want 
ENT.Stats = {
	HP = 15000,
	SP = 999,
	STR = 54,
	MAG = 61,
	END = 56,
	AGI = 58,
	LUC = 45,
}
ENT.VJ_NPC_Class = {"CLASS_YU","CLASS_INVESTIGATION_TEAM","CLASS_PLAYER_ALLY"}
ENT.FriendsWithAllPlayerAllies = true

util.AddNetworkString("vj_persona_hud_yu")

ENT.Animations = {}
ENT.Animations["idle"] = ACT_IDLE
ENT.Animations["idle_combat"] = ACT_IDLE
ENT.Animations["idle_low"] = ACT_IDLE_STIMULATED
ENT.Animations["walk"] = ACT_WALK
ENT.Animations["walk_combat"] = ACT_RUN
ENT.Animations["run"] = ACT_RUN
ENT.Animations["run_combat"] = ACT_RUN
ENT.Animations["melee"] = "range"
ENT.Animations["range_start"] = "range_pre"
ENT.Animations["range_start_idle"] = "range_pre_idle"
ENT.Animations["range"] = "range"
ENT.Animations["range_idle"] = "range_idle"
ENT.Animations["range_end"] = "range_end"

ENT.Persona = "izanagi"
ENT.Personas = {
	[1] = "izanagi",
	[2] = "izanagi_picaro",
	[3] = "yoshitsune",
	[4] = "izanagi_okami",
}
---------------------------------------------------------------------------------------------------------------------------------------------
function ENT:Controller_Initialize(ply)
    net.Start("vj_persona_hud_yu")
		net.WriteBool(false)
		net.WriteEntity(self)
    net.Send(ply)

	function self.VJ_TheControllerEntity:CustomOnStopControlling()
		net.Start("vj_persona_hud_yu")
			net.WriteBool(true)
			net.WriteEntity(self)
		net.Send(ply)
	end
end
---------------------------------------------------------------------------------------------------------------------------------------------
function ENT:PersonaInit()
	self:SetBodygroup(1,1)
	self.CurrentIndex = 1
	if math.random(1,1000) == 1 then
		local dance = ents.Create("sent_dance_yu")
		dance:SetPos(self:GetPos())
		dance:SetAngles(self:GetAngles())
		dance:Spawn()
		undo.ReplaceEntity(self,dance)
	end
end
---------------------------------------------------------------------------------------------------------------------------------------------
function ENT:OnAnimEvent(persona,skill,animBlock,seq,t)
	if animBlock == "melee" then
		self:CreateTarot()
	end
	if animBlock == "range_start" then
		self:CreateTarot()
	end
end
---------------------------------------------------------------------------------------------------------------------------------------------
function ENT:OnThink()
	if !IsValid(self.VJ_TheController) then
		local max = self:GetMaxHealth()
		if self:Health() > max *0.75 then
			self.Persona = "izanagi"
		elseif self:Health() <= max *0.75 && self:Health() > max *0.5 then
			self.Persona = "izanagi_picaro"
		elseif self:Health() <= max *0.5 && self:Health() > max *0.25 then
			self.Persona = "yoshitsune"
		elseif self:Health() <= max *0.25 then
			self.Persona = "izanagi_okami"
		end
		if IsValid(self:GetPersona()) && self:GetPersonaName() != self.Persona then
			self:SwitchPersona(self.Persona)
		end
	end
end
---------------------------------------------------------------------------------------------------------------------------------------------
function ENT:ControllerThink(controller,persona,enemy,dist)
	if controller:KeyDown(IN_DUCK) && controller:KeyDown(IN_USE) then
		self.CurrentIndex = self.CurrentIndex +1 < 5 && self.CurrentIndex +1 or 1
		self.Persona = self.Personas[self.CurrentIndex]
		self:SwitchPersona(self.Persona)
	end
end
---------------------------------------------------------------------------------------------------------------------------------------------
function ENT:CreateTarot()
	local tarot = ents.Create("prop_vj_animatable")
	tarot:SetModel("models/cpthazama/persona4/objects/tarot.mdl")
	tarot:SetPos(self:GetPos() +Vector(0,0,110) +self:GetRight() *-10 +self:GetForward() *10)
	tarot:Spawn()
	self:DeleteOnRemove(tarot)
	tarot:ResetSequence("idle")
	tarot:SetCollisionGroup(COLLISION_GROUP_IN_VEHICLE)
	ParticleEffectAttach("jojo_aura_blue",PATTACH_POINT_FOLLOW,tarot,tarot:LookupAttachment("origin"))
	for i = 1,20 do
		timer.Simple(0.1 *i,function()
			if IsValid(tarot) then
				tarot:SetPos(tarot:GetPos() +Vector(0,0,-2.25))
			end
		end)
	end
	timer.Simple(self:DecideAnimationLength(self.Animations["range_start"],false) +0.5,function()
		if IsValid(tarot) then
			tarot:EmitSound("cpthazama/persona5/critical.wav",90)
			SafeRemoveEntity(tarot)
		end
	end)
end
---------------------------------------------------------------------------------------------------------------------------------------------
function ENT:SummonAnimation()
	self:StartLoopAnimation("range_idle")
	self:VJ_ACT_PLAYACTIVITY(self.Animations["range_start"],true,false,true)
	VJ_CreateSound(self,"cpthazama/persona4/yu/skill_ziodyne2.wav")
	self:CreateTarot()
	timer.Simple(self:DecideAnimationLength(self.Animations["range_start"],false),function()
		if IsValid(self) then
			self:VJ_ACT_PLAYACTIVITY(self.Animations["range"],true,false,true)
			local snd = "cpthazama/persona4/yu/summon_generic" .. math.random(1,2) .. ".wav"
			if self.Persona == "izanagi" then
				snd = "cpthazama/persona4/yu/summon_izanagi" .. math.random(1,2) .. ".wav"
			elseif self.Persona == "izanagi_okami" then
				snd = "cpthazama/persona4/yu/summon_izanagi_okami" .. math.random(1,2) .. ".wav"
			end
			VJ_CreateSound(self,snd,80)
			timer.Simple(self:DecideAnimationLength(self.Animations["range"],false),function()
				if IsValid(self) then
					self:ResetLoopAnimation()
					self:VJ_ACT_PLAYACTIVITY(self.Animations["range_end"],true,false,true)
				end
			end)
		end
	end)
end
---------------------------------------------------------------------------------------------------------------------------------------------
function ENT:OnSummonPersona(persona)
	self:SummonAnimation()
	self.VJC_Data.ThirdP_Offset = Vector(-80, 80, 0)
end
---------------------------------------------------------------------------------------------------------------------------------------------
function ENT:OnDisablePersona(persona)
	self.VJC_Data.ThirdP_Offset = Vector(-15, 40, -35)
end
---------------------------------------------------------------------------------------------------------------------------------------------
function ENT:SwitchPersona(persona)
	if !self:BusyWithActivity() then
		if IsValid(self:GetPersona()) then
			self:SummonPersona(self.Persona)
		end
		self:SummonAnimation()
	end
end
/*-----------------------------------------------
	*** Copyright (c) 2012-2019 by Cpt. Hazama, All rights reserved. ***
	No parts of this code or any of its contents may be reproduced, copied, modified or adapted,
	without the prior written consent of the author, unless otherwise indicated for stand-alone materials.
-----------------------------------------------*/