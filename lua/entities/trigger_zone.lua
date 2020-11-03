AddCSLuaFile()

ENT.Base 			= "base_gmodentity"
ENT.Type 			= "anim"
ENT.PrintName 		= ""
ENT.Author 			= "Cpt. Hazama"
ENT.Contact 		= ""
ENT.Purpose 		= "To trigger gamemode-specific information such as the zone name and soundtrack"
ENT.Instructions 	= ""
ENT.Category		= "Persona"

ENT.Spawnable = false
ENT.AdminOnly = false
ENT.TriggerZone = true

function ENT:SetZoneName(name)
	self.ZoneName = name
end

function ENT:GetZoneName()
	return self.ZoneName
end

function ENT:SetMusic(tbl)
	self.SoundTrack = tbl
end

function ENT:GetMusic()
	return self.SoundTrack
end
---------------------------------------------------------------------------------------------------------------------------------------------
function ENT:SetupDataTables()
	self:NetworkVar("Int",0,"MusicID")
end
---------------------------------------------------------------------------------------------------------------------------------------------
if (CLIENT) then
	function ENT:Draw()
		self:DrawModel()
	end
	
	function ENT:GetSoundTracks(ID)
		local SoundTracks = {}
		SoundTracks[1] = { -- Hub
			"cpthazama/persona_resource/music/Beneath the Mask.mp3",
			"cpthazama/persona_resource/music/Heartbeat, Heartbreak.mp3",
			"cpthazama/persona_resource/music/Joy.mp3",
			"cpthazama/persona_resource/music/Life Goes On.mp3",
			"cpthazama/persona_resource/music/Like A Dream Come True.mp3",
			"cpthazama/persona_resource/music/New Beginning.mp3",
			"cpthazama/persona_resource/music/New Days.mp3",
			"cpthazama/persona_resource/music/Phantom.mp3",
			"cpthazama/persona_resource/music/Signs Of Love.mp3",
			"cpthazama/persona_resource/music/Sky's The Limit.mp3",
			"cpthazama/persona_resource/music/Specialist.mp3",
			"cpthazama/persona_resource/music/Tokyo Daylight.mp3",
			"cpthazama/persona_resource/music/Tokyo Emergency.mp3",
			"cpthazama/persona_resource/music/Your Affection -dancing-.mp3",
			"cpthazama/persona_resource/music/Your Affection.mp3"
		}
		SoundTracks[2] = {"cpthazama/persona_resource/music/Iwatodai Station.mp3"} -- Station
		SoundTracks[3] = {"cpthazama/persona_resource/music/The Whims of Fate.mp3"} -- Casino
		SoundTracks[4] = {"cpthazama/persona_resource/music/What's Going On.mp3"} -- Bar
		return SoundTracks[ID]
	end
	local nt = 0
	function ENT:OnTriggered(ent)
		-- if CurTime() > nt then
			-- PrintTable(self:GetSoundTracks(1))
			-- nt = CurTime() +10
		-- end
		-- print("Touched " .. ent)
		if ent.AmbientTrackID != self:GetMusicID() then
			ent.AmbientTrackID = self:GetMusicID()
			ent.AmbientTracks = self:GetSoundTracks(self:GetMusicID())
			PGM():SetAmbientSong(PGM():SelectFromTable(ply.AmbientTracks),ply)
			if ent.Persona_AmbientSound then
				ent.Persona_AmbientSound:Stop()
			end
			ent.NextAmbientSongT = 0
		end
	end
end
------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------
if !(SERVER) then return end
---------------------------------------------------------------------------------------------------------------------------------------------
function ENT:SetBounds(vec)
	self:SetCollisionBounds(vec,Vector(-vec.x,-vec.y,0))
end
---------------------------------------------------------------------------------------------------------------------------------------------
function ENT:SetSize(scale)
	self:SetModelScale(scale,0)
end
---------------------------------------------------------------------------------------------------------------------------------------------
function ENT:Initialize()
	self:PhysicsInit(SOLID_BBOX)
	self:SetMoveType(MOVETYPE_NONE)
	self:SetSolid(SOLID_BBOX)
	self:SetUseType(SIMPLE_USE)
	self:SetCollisionGroup(COLLISION_GROUP_IN_VEHICLE)
	
	self.TriggerZone = true
	
	self:SetCustomCollisionCheck(true)
end
---------------------------------------------------------------------------------------------------------------------------------------------
function ENT:Think()
	self:NextThink(CurTime())
end
/*--------------------------------------------------
	*** Copyright (c) 2012-2021 by Cpt. Hazama, All rights reserved. ***
	No parts of this code or any of its contents may be reproduced, copied, modified or adapted,
	without the prior written consent of the author, unless otherwise indicated for persona-alone materials.
--------------------------------------------------*/