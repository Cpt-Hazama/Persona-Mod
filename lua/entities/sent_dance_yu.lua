AddCSLuaFile()

ENT.Base 			= "prop_vj_animatable"
ENT.Type 			= "anim"
ENT.PrintName 		= "Yu Narukami"
ENT.Author 			= "Cpt. Hazama"
ENT.Contact 		= "Atlus or some shit"
ENT.Purpose 		= "Get Trolled, LOL"
ENT.Instructions 	= "To fucking dance like there's no tomorrow"
ENT.Category		= "Persona - Dance"

ENT.Spawnable = true
ENT.AdminOnly = true

ENT.SoundTracks = {}
ENT.SoundTracks["dance_specialist"] = "cpthazama/persona4_dance/music/c001.mp3"
---------------------------------------------------------------------------------------------------------------------------------------------
if SERVER then
	util.AddNetworkString("Persona_Dance_Song")
end
---------------------------------------------------------------------------------------------------------------------------------------------
function ENT:SetupDataTables()
	self:NetworkVar("String",0,"Song")
end
---------------------------------------------------------------------------------------------------------------------------------------------
if (CLIENT) then
	function ENT:Draw()
		self:DrawModel()
	end

	net.Receive("Persona_Dance_Song",function(len)
		local dir = net.ReadString()
		local ply = net.ReadEntity()

		if ply.VJ_Persona_Dance_Theme && ply.VJ_Persona_Dance_ThemeDir == dir then ply.VJ_Persona_Dance_Theme:Stop() end
		timer.Simple(0.45,function()
			if IsValid(ply) then
				ply.VJ_Persona_Dance_ThemeDir = dir
				ply.VJ_Persona_Dance_Theme = CreateSound(ply,dir)
				ply.VJ_Persona_Dance_Theme:SetSoundLevel(0)
				ply.VJ_Persona_Dance_Theme:ChangeVolume(60)
				ply.VJ_Persona_Dance_Theme:Play()
			end
		end)
	end)

	function ENT:PlayMusic()
		-- local ply = LocalPlayer()
		-- if ply.VJ_Persona_Dance_Theme then ply.VJ_Persona_Dance_Theme:Stop() end
		-- ply.VJ_Persona_Dance_Theme = CreateSound(ply,song)
		-- ply.VJ_Persona_Dance_Theme:SetSoundLevel(0)
		-- ply.VJ_Persona_Dance_Theme:ChangeVolume(60)
		-- ply.VJ_Persona_Dance_Theme:Play()
	end

	function ENT:OnRemove()
		local ply = LocalPlayer()
		-- if ply.VJ_Persona_Dance_Theme then ply.VJ_Persona_Dance_Theme:Stop() end
		if ply.VJ_Persona_Dance_Theme && ply.VJ_Persona_Dance_ThemeDir == self:GetSong() then
			local cont = true
			for _,v in pairs(ents.FindByClass("sent_dance_*")) do
				if v:GetSong() != nil && v != self && v:GetSong() == self:GetSong() then
					cont = false
				end
			end
			if cont then
				ply.VJ_Persona_Dance_Theme:FadeOut(2)
			end
		end
	end
end
---------------------------------------------------------------------------------------------------------------------------------------------
function ENT:PlayAnimation(seq,rate,cycle)
	self:ResetSequence(seq)
	self:SetPlaybackRate(rate)
	self:SetCycle(cycle or 0)
	for _,v in pairs(player.GetAll()) do
		net.Start("Persona_Dance_Song")
			net.WriteString(self.SoundTracks[seq])
			net.WriteEntity(v)
		net.Broadcast()
	end
	self:SetSong(self.SoundTracks[seq])
	-- if CLIENT then
		-- self:PlayMusic(self.SoundTracks[seq])
	-- end
	local t = self:GetSequenceDuration(self,seq)
	return t
end
---------------------------------------------------------------------------------------------------------------------------------------------
function ENT:GetSequenceDuration(argent,actname)
	if isnumber(actname) then
		return argent:SequenceDuration(argent:SelectWeightedSequence(actname))
	elseif isstring(actname) then
		return argent:SequenceDuration(argent:LookupSequence(actname))
	end
	return 0
end
------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------
if !(SERVER) then return end
---------------------------------------------------------------------------------------------------------------------------------------------
function ENT:Initialize()
	self:SetModel("models/cpthazama/persona4_dance/yu.mdl")
	self:SetSolid(SOLID_OBB)
	self:SetCollisionGroup(COLLISION_GROUP_IN_VEHICLE)
	self:SetCollisionBounds(Vector(16,16,75),Vector(-16,-16,0))
	
	self.NextDanceT = CurTime()

	timer.Simple(0,function()
		if IsValid(self) then
			if IsValid(self:GetCreator()) && self:GetCreator():IsPlayer() then
				-- self:GetCreator():ChatPrint("GET TROLLED, LOL!")
			end
		end
	end)
end
---------------------------------------------------------------------------------------------------------------------------------------------
function ENT:Think()
	if CurTime() > self.NextDanceT then
		local t = self:PlayAnimation("dance_specialist",1,1)
		self.NextDanceT = CurTime() +t
	end
	self:NextThink(CurTime())
	return true
end
/*--------------------------------------------------
	*** Copyright (c) 2012-2020 by DrVrej, All rights reserved. ***
	No parts of this code or any of its contents may be reproduced, copied, modified or adapted,
	without the prior written consent of the author, unless otherwise indicated for persona-alone materials.
--------------------------------------------------*/