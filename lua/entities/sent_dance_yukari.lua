AddCSLuaFile()

ENT.Base 			= "sent_dance_base"
ENT.Type 			= "anim"
ENT.PrintName 		= "Yukari Takeba"
ENT.Author 			= "Cpt. Hazama"
ENT.Contact 		= "Atlus or some shit"
ENT.Purpose 		= ""
ENT.Instructions 	= "To fucking dance like there's no tomorrow"
ENT.Category		= "Persona - Dance"

ENT.Spawnable = true
ENT.AdminOnly = true

-- ENT.Model = "models/cpthazama/persona3_dance/yukari_racequeen.mdl"
ENT.Model = "models/cpthazama/persona3_dance/yukari.mdl"
ENT.HeightOffset = 1
ENT.ModelScale = 0.42
ENT.CollisionBounds = Vector(16,16,75)
ENT.SongStartDelay = 1
ENT.SongStartAnimationDelay = 0
ENT.ViewBone = "Spine2"
ENT.WaitForNextSongToStartTime = 10

ENT.Animations = {}
ENT.Animations["dance_whenthemoonsreachingoutstars"] = {}
ENT.Animations["dance_whenthemoonsreachingoutstars"][1] = {anim = "dance_whenthemoonsreachingoutstars",next = "dance_whenthemoonsreachingoutstars_2",endEarlyTime = 0.02}
ENT.Animations["dance_whenthemoonsreachingoutstars"][2] = {anim = "dance_whenthemoonsreachingoutstars_2",next = "dance_whenthemoonsreachingoutstars_3",endEarlyTime = 0.02}
ENT.Animations["dance_whenthemoonsreachingoutstars"][3] = {anim = "dance_whenthemoonsreachingoutstars_3",next = "dance_whenthemoonsreachingoutstars_2",endEarlyTime = 0.02}
ENT.Animations["dance_whenthemoonsreachingoutstars"][4] = {anim = "dance_whenthemoonsreachingoutstars_2",next = "dance_whenthemoonsreachingoutstars_4",endEarlyTime = 0.02}
ENT.Animations["dance_whenthemoonsreachingoutstars"][5] = {anim = "dance_whenthemoonsreachingoutstars_4",next = false,endEarlyTime = 0}

ENT.SoundTracks = {
	[1] = {dance = "dance_whenthemoonsreachingoutstars", song = "cpthazama/persona3_dance/music/c012_3.mp3", name = "When The Moon's Reaching Out Stars -Remix-"},
}

ENT.Outfits = {}
ENT.Outfits[1] = {Name = "Stage Outfit", Model = "", Offset = 1, ReqSong = nil, ReqScore = 0}
ENT.Outfits[2] = {Name = "Gekkoukan Winter Uniform", Model = "_winteruniform", Offset = 1, ReqSong = "Want To Be Close -Remix", ReqScore = 10000}
ENT.Outfits[3] = {Name = "Race Queen", Model = "_racequeen", Offset = 0.1, ReqSong = "When The Moon's Reaching Out Stars -Remix-", ReqScore = 60000}

ENT.SongLength = {}
ENT.SongLength["dance_whenthemoonsreachingoutstars"] = 173
ENT.SongLength["dance_wanttobeclose"] = 175
---------------------------------------------------------------------------------------------------------------------------------------------
if CLIENT then
	function ENT:ClientInit()
		self:ChangeFlex("smile_teeth",1,2)
	end
end
---------------------------------------------------------------------------------------------------------------------------------------------
if SERVER then
	function ENT:OnInit()
		self:SetCinematicData()
		self:RandomizeCinematics("dance_whenthemoonsreachingoutstars",1160)
		self:RandomizeCinematics("dance_whenthemoonsreachingoutstars_2",619)
		self:RandomizeCinematics("dance_whenthemoonsreachingoutstars_3",1775)
		self:RandomizeCinematics("dance_whenthemoonsreachingoutstars_4",1138)
	end
end
/*--------------------------------------------------
	*** Copyright (c) 2012-2021 by Cpt. Hazama, All rights reserved. ***
	No parts of this code or any of its contents may be reproduced, copied, modified or adapted,
	without the prior written consent of the author, unless otherwise indicated for persona-alone materials.
--------------------------------------------------*/