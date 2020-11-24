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

ENT.Model = "models/cpthazama/persona3_dance/yukari.mdl"
ENT.HeightOffset = 1
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
	[1] = {dance = "dance_whenthemoonsreachingoutstars", song = "cpthazama/persona3_dance/music/c012_3.mp3", name = "When The Moon's Reaching Out Stars -Remix-"}
}

ENT.SongLength = {}
ENT.SongLength["dance_whenthemoonsreachingoutstars"] = 173
ENT.SongLength["dance_wanttobeclose"] = 175
---------------------------------------------------------------------------------------------------------------------------------------------
if SERVER then
	function ENT:OnInit()

	end

	function ENT:SetFace(top,bottom,brow)
		self:SetBodygroup(1,top)
		self:SetBodygroup(2,bottom)
		self:SetBodygroup(3,brow)
	end

	function ENT:HandleAnimationEvent(seq,event,frame)
		if event == "default" then
			self:SetFace(0,0,0)
		end
		if event == "smile" then
			self:SetFace(0,1,2)
		end
		if event == "neutral" then
			self:SetFace(0,2,0)
		end
		if event == "open" then
			self:SetFace(0,3,2)
		end
		if event == "open_wide" then
			self:SetFace(0,4,2)
		end
		if event == "wink" then
			self:SetFace(3,5,1)
		end
		if event == "squint" then
			self:SetFace(2,1,1)
		end
		if event == "sexy" then
			self:SetFace(2,5,2)
		end
	end

	function ENT:OnPlayDance(seq,t)
		if seq == "dance_signsoflove" then
			-- self:ChangeFace(nil,nil,2)
		end
	end
end
/*--------------------------------------------------
	*** Copyright (c) 2012-2021 by Cpt. Hazama, All rights reserved. ***
	No parts of this code or any of its contents may be reproduced, copied, modified or adapted,
	without the prior written consent of the author, unless otherwise indicated for persona-alone materials.
--------------------------------------------------*/