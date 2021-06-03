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

function ENT:SetPersona(ply)
	self.Persona = ply
end

function ENT:GetPersona()
	return self.Persona
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
			local skills = PXP.GetPersonaData(ply,3,self:GetPersona())
			if skills == nil then
				ply:PrintMessage(HUD_PRINTTALK,"Summon your Persona first!")
				SafeRemoveEntity(self)
				return
			end
			local data = self.SkillData
			local proceed = true
			for _,v in pairs(skills) do
				if v.Name == data.Name then
					proceed = false
					break
				end
			end
			if !proceed then
				ply:ChatPrint("Your Persona already knows " .. data.Name .. "!")
				SafeRemoveEntity(self)
				return
			end
			table.insert(skills,data)
			PXP.SetPersonaData(ply,3,skills,self:GetPersona())
			ply:ChatPrint("Obtained a new skill, " .. data.Name .. "!")
			SafeRemoveEntity(self)
		end
	end)
end
/*--------------------------------------------------
	*** Copyright (c) 2012-2021 by Cpt. Hazama, All rights reserved. ***
	No parts of this code or any of its contents may be reproduced, copied, modified or adapted,
	without the prior written consent of the author, unless otherwise indicated for stand-alone materials.
--------------------------------------------------*/