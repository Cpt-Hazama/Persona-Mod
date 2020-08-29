AddCSLuaFile("shared.lua")
include('shared.lua')
/*-----------------------------------------------
	*** Copyright (c) 2012-2019 by Cpt. Hazama, All rights reserved. ***
	No parts of this code or any of its contents may be reproduced, copied, modified or adapted,
	without the prior written consent of the author, unless otherwise indicated for stand-alone materials.
-----------------------------------------------*/
ENT.Model = {"models/cpthazama/persona5/lavenza.mdl"} -- The game will pick a random model from the table when the SNPC is spawned | Add as many as you want 
ENT.Stats = {
	HP = 20000,
	SP = 999,
	LVL = 99,
	STR = 99,
	MAG = 99,
	END = 99,
	AGI = 99,
	LUC = 99,
}
ENT.VJ_NPC_Class = {"CLASS_PLAYER_ALLY","CLASS_VELVET_ROOM"}
ENT.FriendsWithAllPlayerAllies = true

ENT.Animations = {}
ENT.Animations["idle"] = ACT_IDLE
ENT.Animations["idle_combat"] = ACT_IDLE_ANGRY
ENT.Animations["idle_low"] = ACT_IDLE_STIMULATED
ENT.Animations["walk"] = ACT_WALK
ENT.Animations["run"] = ACT_WALK
ENT.Animations["run_combat"] = ACT_WALK
ENT.Animations["melee"] = "persona_attack"
ENT.Animations["range_start"] = "persona_attack_start"
ENT.Animations["range_start_idle"] = "persona_attack_start_idle"
ENT.Animations["range"] = "persona_attack"
ENT.Animations["range_idle"] = "persona_attack_idle"
ENT.Animations["range_end"] = "persona_attack_end"

ENT.Persona = "izanagi_velvet"

util.AddNetworkString("vj_persona_hud_lavenza")
util.AddNetworkString("vj_persona_hud_lavenza_speech")
---------------------------------------------------------------------------------------------------------------------------------------------
function ENT:Controller_Initialize(ply)
    net.Start("vj_persona_hud_lavenza")
		net.WriteBool(false)
		net.WriteEntity(self)
    net.Send(ply)

	function self.VJ_TheControllerEntity:CustomOnStopControlling()
		net.Start("vj_persona_hud_lavenza")
			net.WriteBool(true)
			net.WriteEntity(self)
		net.Send(ply)
	end
end
---------------------------------------------------------------------------------------------------------------------------------------------
function ENT:PersonaInit()
	self:SetCollisionBounds(Vector(8,8,48),Vector(-8,-8,0))
	
	self.NextSwitchT = CurTime() +15
end
---------------------------------------------------------------------------------------------------------------------------------------------
function ENT:SwitchPersona(persona)
	local selected = persona
	if selected == nil then
		local tbl = {}
		for persona,v in pairs(PERSONA) do
			table.insert(tbl,persona)
		end
		selected = tbl[math.random(1,#tbl)]
	end

	if !self:BusyWithActivity() then
		if IsValid(self:GetPersona()) then
			self:SummonPersona(self.Persona)
		end
		self.NextSwitchT = CurTime() +math.Rand(15,30)
		self:VJ_ACT_PLAYACTIVITY("persona_switch",true,false,true)
		timer.Simple(self:DecideAnimationLength("persona_switch",false),function()
			if IsValid(self) then
				self:VJ_ACT_PLAYACTIVITY("persona_attack_end",true,false,true)
				self.Persona = selected
			end
		end)
	end
end
---------------------------------------------------------------------------------------------------------------------------------------------
function ENT:OnThink()
	if IsValid(self:GetEnemy()) && CurTime() > self.NextSwitchT && math.random(1,5) == 1 then
		self:SwitchPersona()
	end
end
---------------------------------------------------------------------------------------------------------------------------------------------
function ENT:UseItem(class,t)
	if CurTime() > self.NextUseT && !self:BusyWithActivity() then
		self:VJ_ACT_PLAYACTIVITY("item_use",true,false,true)
		timer.Simple(self:DecideAnimationLength("item_use",false),function()
			if IsValid(self) then
				local ent = ents.Create(class)
				ent:SetPos(self:GetPos() +self:OBBCenter())
				ent:Spawn()
				ent:SetCollisionGroup(COLLISION_GROUP_IN_VEHICLE)
				ent:Use(self,self)
				self.NextUseT = CurTime() +(t or math.Rand(2,4))
				
				self:VJ_ACT_PLAYACTIVITY("item_use_end",true,false,true)
			end
		end)
	end
end
---------------------------------------------------------------------------------------------------------------------------------------------
function ENT:CustomOnAcceptInput(key,ent,caller,data)
	if ent:IsPlayer() then
		self:OnInteract(ent)
	end
end
/*-----------------------------------------------
	*** Copyright (c) 2012-2019 by Cpt. Hazama, All rights reserved. ***
	No parts of this code or any of its contents may be reproduced, copied, modified or adapted,
	without the prior written consent of the author, unless otherwise indicated for stand-alone materials.
-----------------------------------------------*/