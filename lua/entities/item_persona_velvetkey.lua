/*--------------------------------------------------
	*** Copyright (c) 2012-2021 by Cpt. Hazama, All rights reserved. ***
	No parts of this code or any of its contents may be reproduced, copied, modified or adapted,
	without the prior written consent of the author, unless otherwise indicated for stand-alone materials.
--------------------------------------------------*/
AddCSLuaFile()
if (!file.Exists("autorun/vj_base_autorun.lua","LUA")) then return end

ENT.Base 			= "base_gmodentity"
ENT.Type 			= "anim"
ENT.PrintName 		= "Velvet Key"
ENT.Author 			= "Cpt. Hazama"
ENT.Contact 		= "http://steamcommunity.com/groups/vrejgaming"
ENT.Purpose 		= ""
ENT.Instructions 	= ""
ENT.Category		= "Persona - Items"

ENT.Spawnable = true
ENT.AdminOnly = true
---------------------------------------------------------------------------------------------------------------------------------------------
if (CLIENT) then
	function ENT:Draw()
		self:DrawModel()
	end
end
------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------
if !SERVER then return end

function ENT:Initialize()
	self:SetModel("models/cpthazama/persona5/items/velvetkey.mdl")
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
function ENT:Use(ply,caller)
	local velvetPersona = ply:GetPersonaName() .. "_velvet"
	local hasVelvetAlready = PXP.InCompendium(ply,velvetPersona)
	if ply:IsPlayer() && IsValid(ply:GetPersona()) && !ply:GetPersona():GetNW2Bool("Overdrive") && PXP.IsLegendary(ply) && !PXP.IsVelvet(ply) && PXP.GetLevel(ply) <= 99 then
		if PXP.GetLevel(ply) >= 99 && PERSONA[velvetPersona] && !hasVelvetAlready then
			if IsValid(ply:GetPersona()) then
				ply:GetPersona():SetTask("TASK_RETURN")
				ply:GetPersona():OnRequestDisappear(ply)
			end
			ply:SetPersona(ply:GetPersonaName() .. "_velvet")
			PXP.SetPersonaData(ply,8,2)
			ply:PrintMessage(HUD_PRINTTALK,"Igor blesses your Persona with Ultimate power! You can now summon the Velvet Form of your Persona!")
			SafeRemoveEntity(self)
			return
		end
		ply:PrintMessage(HUD_PRINTTALK,"Your Persona absorbs the key and you are overwhelmed with power! Your body can not stand the pressure of Overdrive Mode...")
		ply:GetPersona():Overdrive(true)
		SafeRemoveEntity(self)
		return
	end
	if hasVelvetAlready then
		ply:PrintMessage(HUD_PRINTTALK,"You already have the Velvet Form of your Persona!")
		return
	end
	if ply:IsPlayer() && PXP.IsLegendary(ply) && !PXP.IsVelvet(ply) && PXP.GetLevel(ply) >= 99 && PERSONA[velvetPersona] then
		if IsValid(ply:GetPersona()) then
			ply:GetPersona():SetTask("TASK_RETURN")
			ply:GetPersona():OnRequestDisappear(ply)
		end
		ply:SetPersona(ply:GetPersonaName() .. "_velvet")
		PXP.SetPersonaData(ply,8,2)
		ply:PrintMessage(HUD_PRINTTALK,"Igor blesses your Persona with Ultimate power! You can now summon the Velvet Form of your Persona!")
		SafeRemoveEntity(self)
	else
		ply:PrintMessage(HUD_PRINTTALK,"Your Persona needs to be a LVL 99 Legendary Persona!")
	end
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