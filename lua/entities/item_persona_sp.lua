/*--------------------------------------------------
	*** Copyright (c) 2012-2021 by Cpt. Hazama, All rights reserved. ***
	No parts of this code or any of its contents may be reproduced, copied, modified or adapted,
	without the prior written consent of the author, unless otherwise indicated for stand-alone materials.
--------------------------------------------------*/
AddCSLuaFile()
if (!file.Exists("autorun/vj_base_autorun.lua","LUA")) then return end

ENT.Base 			= "base_gmodentity"
ENT.Type 			= "anim"
ENT.PrintName 		= "Chewing Soul"
ENT.Author 			= "Cpt. Hazama"
ENT.Contact 		= "http://steamcommunity.com/groups/vrejgaming"
ENT.Purpose 		= ""
ENT.Instructions 	= ""
ENT.Category		= "Persona - Items"

ENT.Spawnable = true
ENT.AdminOnly = false

ENT.RestoresHP = false
ENT.RestoreAmount = 100
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
	self:SetModel("models/props_lab/jar01a.mdl")
	self:PhysicsInit(SOLID_VPHYSICS)
	self:SetMoveType(MOVETYPE_VPHYSICS)
	self:SetSolid(SOLID_VPHYSICS)
	self:SetUseType(SIMPLE_USE)

	timer.Simple(0,function()
		if IsValid(self:GetCreator()) then self:SetPos(self:GetCreator():GetPos() +Vector(0,0,10)) end
		local ply = self:GetCreator()
		if IsValid(ply) then
			self:Use(ply)
			SafeRemoveEntity(self)
		end
	end)
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
	*** Copyright (c) 2012-2021 by Cpt. Hazama, All rights reserved. ***
	No parts of this code or any of its contents may be reproduced, copied, modified or adapted,
	without the prior written consent of the author, unless otherwise indicated for stand-alone materials.
--------------------------------------------------*/