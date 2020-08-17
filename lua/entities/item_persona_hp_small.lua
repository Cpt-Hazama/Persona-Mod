/*--------------------------------------------------
	*** Copyright (c) 2012-2020 by DrVrej, All rights reserved. ***
	No parts of this code or any of its contents may be reproduced, copied, modified or adapted,
	without the prior written consent of the author, unless otherwise indicated for stand-alone materials.
--------------------------------------------------*/
AddCSLuaFile()
if (!file.Exists("autorun/vj_base_autorun.lua","LUA")) then return end

ENT.Base 			= "base_gmodentity"
ENT.Type 			= "anim"
ENT.PrintName 		= "Medicine"
ENT.Author 			= "Cpt. Hazama"
ENT.Contact 		= "http://steamcommunity.com/groups/vrejgaming"
ENT.Purpose 		= ""
ENT.Instructions 	= ""
ENT.Category		= "Persona - Items"

ENT.Spawnable = true
ENT.AdminOnly = false

ENT.RestoresHP = true
ENT.RestoreAmount = 50
ENT.Text = "Restored " .. ENT.RestoreAmount .. " " .. (ENT.RestoresHP && "HP" or "SP")
---------------------------------------------------------------------------------------------------------------------------------------------
if (CLIENT) then
	function ENT:Draw()
		self:DrawModel()
	end
end
------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------
if !SERVER then return end

function ENT:Initialize()
	self:SetModel("models/props_lab/jar01b.mdl")
	self:PhysicsInit(SOLID_VPHYSICS)
	self:SetMoveType(MOVETYPE_VPHYSICS)
	self:SetSolid(SOLID_VPHYSICS)
	self:SetUseType(SIMPLE_USE)
	
	local phys = self:GetPhysicsObject()
	if phys and IsValid(phys) then
		phys:Wake()
	end
end
---------------------------------------------------------------------------------------------------------------------------------------------
function ENT:Use(activator, caller)
	self:EmitSound(Sound("items/smallmedkit1.wav"),70,100)
	if activator:IsPlayer() then activator:PrintMessage(HUD_PRINTTALK,self.Text) end
	if self.RestoresHP then
		activator:SetHealth(math.Clamp(activator:Health() +self.RestoreAmount,activator:Health(),activator:GetMaxHealth()))
		if activator:IsPlayer() then activator:PrintMessage(HUD_PRINTTALK,"HP is now " .. activator:Health() .. "/" .. activator:GetMaxHealth()) end
	else
		activator:SetSP(math.Clamp(activator:GetSP() +self.RestoreAmount,activator:GetSP(),activator:GetMaxSP()))
		if activator:IsPlayer() then activator:PrintMessage(HUD_PRINTTALK,"SP is now " .. activator:GetSP() .. "/" .. activator:GetMaxSP()) end
	end
	self:Remove()
end
---------------------------------------------------------------------------------------------------------------------------------------------
function ENT:OnTakeDamage(dmginfo)
	self:GetPhysicsObject():AddVelocity(dmginfo:GetDamageForce() *0.1)
end
/*--------------------------------------------------
	*** Copyright (c) 2012-2020 by DrVrej, All rights reserved. ***
	No parts of this code or any of its contents may be reproduced, copied, modified or adapted,
	without the prior written consent of the author, unless otherwise indicated for stand-alone materials.
--------------------------------------------------*/