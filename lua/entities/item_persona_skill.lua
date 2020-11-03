/*--------------------------------------------------
	*** Copyright (c) 2012-2021 by Cpt. Hazama, All rights reserved. ***
	No parts of this code or any of its contents may be reproduced, copied, modified or adapted,
	without the prior written consent of the author, unless otherwise indicated for stand-alone materials.
--------------------------------------------------*/
AddCSLuaFile()
if (!file.Exists("autorun/vj_base_autorun.lua","LUA")) then return end

ENT.PrintName 		= ""
ENT.SkillData = {Name = "BLANK", Cost = 0, UsesHP = false, Icon = "unknown"}
ENT.Spawnable = false
ENT.AdminOnly = false

ENT.Base 			= "base_gmodentity"
ENT.Type 			= "anim"
ENT.Author 			= "Cpt. Hazama"
ENT.Contact 		= "http://steamcommunity.com/groups/vrejgaming"
ENT.Purpose 		= ""
ENT.Instructions 	= ""
ENT.Category		= "Persona - Skills"
---------------------------------------------------------------------------------------------------------------------------------------------
if (CLIENT) then
	function ENT:Draw()
		self:DrawModel()
	end
end
------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------
if !SERVER then return end

function ENT:SetSpawner(ply)
	self.Spawner = ply
end

function ENT:GetSpawner()
	return self.Spawner
end

function ENT:Initialize()
	self:SetModel("models/props_lab/jar01a.mdl")
	self:PhysicsInit(SOLID_VPHYSICS)
	self:SetMoveType(MOVETYPE_VPHYSICS)
	self:SetSolid(SOLID_VPHYSICS)
	self:SetUseType(SIMPLE_USE)

	timer.Simple(0,function()
		local ply = self:GetSpawner() or self:GetCreator()
		if IsValid(ply) then
			self:SetPos(ply:GetPos() +Vector(0,0,10))
			if !IsValid(ply:GetPersona()) then
				ply:PrintMessage(HUD_PRINTTALK,"Summon your Persona first!")
				SafeRemoveEntity(self)
				return
			end
			ply:GetPersona():AddItemSkill(self.SkillData)
			SafeRemoveEntity(self)
		end
	end)
end
/*--------------------------------------------------
	*** Copyright (c) 2012-2021 by Cpt. Hazama, All rights reserved. ***
	No parts of this code or any of its contents may be reproduced, copied, modified or adapted,
	without the prior written consent of the author, unless otherwise indicated for stand-alone materials.
--------------------------------------------------*/