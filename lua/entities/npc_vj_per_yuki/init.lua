AddCSLuaFile("shared.lua")
include('shared.lua')
/*-----------------------------------------------
	*** Copyright (c) 2012-2019 by Cpt. Hazama, All rights reserved. ***
	No parts of this code or any of its contents may be reproduced, copied, modified or adapted,
	without the prior written consent of the author, unless otherwise indicated for stand-alone materials.
-----------------------------------------------*/
ENT.Model = {"models/cpthazama/persona3/yuki.mdl"} -- The game will pick a random model from the table when the SNPC is spawned | Add as many as you want 
ENT.Stats = {
	HP = 15000,
	SP = 999,
	STR = 75,
	MAG = 79,
	END = 82,
	AGI = 75,
	LUC = 75,
}
ENT.VJ_NPC_Class = {"CLASS_YUKI","CLASS_SEES","CLASS_PLAYER_ALLY"}
ENT.FriendsWithAllPlayerAllies = true

util.AddNetworkString("vj_persona_hud_yuki")

ENT.SoundTbl_Death = {
	"cpthazama/persona3/yuki/death.wav",
}

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

ENT.Persona = "orpheus"
ENT.Personas = {
	[1] = "orpheus",
	[2] = "thanatos",
	[3] = "messiah",
}
---------------------------------------------------------------------------------------------------------------------------------------------
function ENT:Controller_Initialize(ply)
    net.Start("vj_persona_hud_yuki")
		net.WriteBool(false)
		net.WriteEntity(self)
    net.Send(ply)

	function self.VJ_TheControllerEntity:CustomOnStopControlling()
		net.Start("vj_persona_hud_yuki")
			net.WriteBool(true)
			net.WriteEntity(self)
		net.Send(ply)
	end
end
---------------------------------------------------------------------------------------------------------------------------------------------
function ENT:PersonaInit()
	self.CurrentIndex = 1
end
---------------------------------------------------------------------------------------------------------------------------------------------
function ENT:CustomOnAcceptInput(key,activator,caller,data)
	if key == "evoker_start" then
		self:SetBodygroup(2,1)
		self:SetBodygroup(3,1)
	end
	if key == "evoker_end" then
		self:SetBodygroup(2,0)
		self:SetBodygroup(3,0)
	end
	if key == "shoot" then
		VJ_CreateSound(self,"cpthazama/persona3/evoker.wav",85)
		local pos,ang = self:GetBonePosition(self:LookupBone("rot_head"))
		local effectdata = EffectData()
		effectdata:SetEntity(self)
		effectdata:SetOrigin(pos)
		effectdata:SetStart(self:GetPos() +self:GetRight() *-300)
		util.Effect("Persona_Evoker",effectdata)
	end
end
---------------------------------------------------------------------------------------------------------------------------------------------
function ENT:OnAnimEvent(persona,skill,animBlock,seq,t)
	if animBlock == "range" then
		self:SetBodygroup(2,1)
		self:SetBodygroup(3,1)
	end
end
---------------------------------------------------------------------------------------------------------------------------------------------
function ENT:OnThink()
	if self:GetBodygroup(3) == 1 && VJ_HasValue({ACT_IDLE,ACT_IDLE_STIMULATED,ACT_WALK,ACT_RUN},self:GetActivity()) then
		self:SetBodygroup(2,0)
		self:SetBodygroup(3,0)
	end
	if !IsValid(self.VJ_TheController) then
		local max = self:GetMaxHealth()
		if self:Health() > max *0.75 then
			self.Persona = self.Personas[1]
		elseif self:Health() <= max *0.75 && self:Health() > max *0.25 then
			self.Persona = self.Personas[2]
		elseif self:Health() <= max *0.25 then
			self.Persona = self.Personas[3]
		end
		if IsValid(self:GetPersona()) && self:GetPersonaName() != self.Persona then
			self:SwitchPersona(self.Persona)
		end
	end
end
---------------------------------------------------------------------------------------------------------------------------------------------
function ENT:ControllerThink(controller,persona,enemy,dist)
	if controller:KeyDown(IN_DUCK) && controller:KeyDown(IN_USE) then
		self.CurrentIndex = self.CurrentIndex +1 < 4 && self.CurrentIndex +1 or 1
		self.Persona = self.Personas[self.CurrentIndex]
		self:SwitchPersona(self.Persona)
	end
end
---------------------------------------------------------------------------------------------------------------------------------------------
function ENT:SummonAnimation()
	self:StartLoopAnimation("range_idle")
	self:VJ_ACT_PLAYACTIVITY(self.Animations["range_start"],true,false,true)
	local snd = nil
	if self.Persona == "orpheus" then
		snd = "cpthazama/persona3/yuki/summon_orpheus.wav"
	elseif self.Persona == "alice" then
		snd = "cpthazama/persona3/yuki/summon_alice.wav"
	elseif self.Persona == "attis" then
		snd = "cpthazama/persona3/yuki/summon_attis.wav"
	elseif self.Persona == "messiah" then
		snd = "cpthazama/persona3/yuki/summon_messiah.wav"
	elseif self.Persona == "thanatos" then
		snd = "cpthazama/persona3/yuki/summon_thanatos.wav"
	end
	if snd then VJ_CreateSound(self,snd,85) end
	timer.Simple(self:DecideAnimationLength(self.Animations["range_start"],false),function()
		if IsValid(self) then
			self:VJ_ACT_PLAYACTIVITY(self.Animations["range"],true,false,true)
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
		-- self:SummonAnimation()
	end
end
/*-----------------------------------------------
	*** Copyright (c) 2012-2019 by Cpt. Hazama, All rights reserved. ***
	No parts of this code or any of its contents may be reproduced, copied, modified or adapted,
	without the prior written consent of the author, unless otherwise indicated for stand-alone materials.
-----------------------------------------------*/