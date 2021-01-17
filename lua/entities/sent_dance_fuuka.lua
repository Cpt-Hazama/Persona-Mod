AddCSLuaFile()

ENT.Base 			= "sent_dance_base"
ENT.Type 			= "anim"
ENT.PrintName 		= "Fuuka Yamagishi"
ENT.Author 			= "Cpt. Hazama"
ENT.Contact 		= "Atlus or some shit"
ENT.Purpose 		= ""
ENT.Instructions 	= "To fucking dance like there's no tomorrow"
ENT.Category		= "Persona - Dance"

ENT.Spawnable = true
ENT.AdminOnly = true

ENT.Model = "models/cpthazama/persona3_dance/fuuka_flex.mdl"
ENT.HeightOffset = 1
ENT.CollisionBounds = Vector(16,16,75)
ENT.ModelScale = 0.42
ENT.SongStartDelay = 1
ENT.SongStartAnimationDelay = 0
ENT.ViewBone = "Spine2"
ENT.WaitForNextSongToStartTime = 10

ENT.Animations = {}
ENT.Animations["dance_time"] = {}
ENT.Animations["dance_time"][1] = {anim = "dance_time",next = "dance_time_2",endEarlyTime = 0.01}
ENT.Animations["dance_time"][2] = {anim = "dance_time_2",next = "dance_time_3",endEarlyTime = 0.01}
ENT.Animations["dance_time"][3] = {anim = "dance_time_3",next = "dance_time_2",endEarlyTime = 0.01}
ENT.Animations["dance_time"][4] = {anim = "dance_time_2",next = "dance_time_4",endEarlyTime = 0.01}
ENT.Animations["dance_time"][5] = {anim = "dance_time_4",next = false,endEarlyTime = 0}

ENT.SoundTracks = {
	[1] = {dance = "dance_time", song = "cpthazama/persona3_dance/music/c006_11.mp3", name = "Time -Remix-"},
}

ENT.Outfits = {}
ENT.Outfits[1] = {Name = "SEES Uniform", Model = "", Offset = 1, ReqSong = nil, ReqScore = 0}

ENT.SongLength = {}
ENT.SongLength["dance_time"] = 188
---------------------------------------------------------------------------------------------------------------------------------------------
if CLIENT then
	function ENT:ClientInit()
		self:ChangeFlex("smile_teeth",1,2)
	end
end
---------------------------------------------------------------------------------------------------------------------------------------------
if SERVER then
	function ENT:OnInit()
		-- self:SetCinematicData()
		self:RandomizeCinematics("dance_time",419)
		self:RandomizeCinematics("dance_time_2",1136)
		self:RandomizeCinematics("dance_time_3",874)
		self:RandomizeCinematics("dance_time_4",2084)
		
		self:AddFlexEvent("dance_time",50,{Name="smile_teeth",Value=3,Speed=4},419)
		self:AddFlexEvent("dance_time",125,{Name="smile_teeth",Value=0.65,Speed=20},419)
		
		-- self:RandomizeExpressions({"smile_teeth"},"dance_time",419)
		-- self:RandomizeExpressions({"smile_teeth"},"dance_time_2",1136)
		-- self:RandomizeExpressions({"smile_teeth"},"dance_time_3",874)
		-- self:RandomizeExpressions({"smile_teeth"},"dance_time_4",2084)
	end

	function ENT:HandleAnimationEvent(seq,event,frame)
		if event == "default" then
			
		end
	end
end
/*--------------------------------------------------
	*** Copyright (c) 2012-2021 by Cpt. Hazama, All rights reserved. ***
	No parts of this code or any of its contents may be reproduced, copied, modified or adapted,
	without the prior written consent of the author, unless otherwise indicated for persona-alone materials.
--------------------------------------------------*/