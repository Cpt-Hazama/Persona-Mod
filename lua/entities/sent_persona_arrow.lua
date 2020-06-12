AddCSLuaFile()

ENT.Base 			= "base_gmodentity"
ENT.Type 			= "anim"
ENT.PrintName 		= "[PLACEHOLDER]"
ENT.Author 			= "Cpt. Hazama"
ENT.Contact 		= ""
ENT.Purpose 		= ""
ENT.Instructions 	= ""
ENT.Category		= "Persona"

ENT.Spawnable = true
ENT.AdminOnly = false
---------------------------------------------------------------------------------------------------------------------------------------------
if (CLIENT) then
	function ENT:Draw()
		self:DrawModel()
	end
end
------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------
if !(SERVER) then return end
---------------------------------------------------------------------------------------------------------------------------------------------
function ENT:Initialize()
	self:SetModel("models/cpthazama/jojo/arrow.mdl")
	self:PhysicsInit(SOLID_VPHYSICS)
	self:SetMoveType(MOVETYPE_VPHYSICS)
	self:SetSolid(SOLID_VPHYSICS)
	self:SetUseType(SIMPLE_USE)

	self:SetCollisionBounds(Vector(10,10,5),Vector(-10,-10,0))
	self:SetPos(self:GetPos() +Vector(0,0,10))
end
---------------------------------------------------------------------------------------------------------------------------------------------
function ENT:PhysicsCollide(data,phys)
	local velocityspeed = phys:GetVelocity():Length()
	if velocityspeed > 18 then
		self:EmitSound("physics/metal/metal_grenade_impact_hard" .. math.random(1,3) .. ".wav",math.Clamp(velocityspeed *1,15,70))
		self:EmitSound("physics/wood/wood_furniture_impact_soft" .. math.random(1,3) .. ".wav",math.Clamp(velocityspeed *1,20,75))
	end
end
---------------------------------------------------------------------------------------------------------------------------------------------
function ENT:Think()
	return true
end
---------------------------------------------------------------------------------------------------------------------------------------------
function ENT:FindPersona()
	local tbl = {}
	for persona,v in pairs(PERSONA) do
		table.insert(tbl,persona)
	end
	local persona = tbl[math.random(1,#tbl)]
	return persona
end
---------------------------------------------------------------------------------------------------------------------------------------------
function ENT:Use(ply,caller)
	local std = self:FindPersona()
	ply:ChatPrint("Aquired " .. std)
	ply:SetPersona(std)
end
---------------------------------------------------------------------------------------------------------------------------------------------
function ENT:OnTakeDamage(dmginfo)
	return false
end
/*--------------------------------------------------
	*** Copyright (c) 2012-2020 by DrVrej, All rights reserved. ***
	No parts of this code or any of its contents may be reproduced, copied, modified or adapted,
	without the prior written consent of the author, unless otherwise indicated for persona-alone materials.
--------------------------------------------------*/