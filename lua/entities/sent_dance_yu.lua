AddCSLuaFile()

ENT.Base 			= "sent_dance_base"
ENT.Type 			= "anim"
ENT.PrintName 		= "Yu Narukami"
ENT.Author 			= "Cpt. Hazama"
ENT.Contact 		= "Atlus or some shit"
ENT.Purpose 		= ""
ENT.Instructions 	= "To fucking dance like there's no tomorrow"
ENT.Category		= "Persona - Dance"

ENT.Spawnable = true
ENT.AdminOnly = true

ENT.Model = "models/cpthazama/persona4_dance/yu.mdl"
ENT.HeightOffset = 1
ENT.CollisionBounds = Vector(16,16,75)
ENT.SongStartDelay = 0.45
ENT.ViewBone = "spine_01"

ENT.Animations = {}
ENT.Animations["dance_specialist"] = {}
ENT.Animations["dance_specialist"][1] = {anim = "dance_specialist",next = false,endEarlyTime = 0}

ENT.SoundTracks = {
	[1] = {dance = "dance_specialist", song = "cpthazama/persona4_dance/music/c001.mp3"}
}
---------------------------------------------------------------------------------------------------------------------------------------------
if SERVER then
	function ENT:OnInit()
		self:AddAnimationEvent("dance_specialist",0,"default",4167)
		self:AddAnimationEvent("dance_specialist",1,"default",4167)
		self:AddAnimationEvent("dance_specialist",2,"default",4167)
		self:AddAnimationEvent("dance_specialist",69,"smile",4167)
		self:AddAnimationEvent("dance_specialist",164,"default",4167)
		self:AddAnimationEvent("dance_specialist",380,"smile",4167)
		self:AddAnimationEvent("dance_specialist",447,"default",4167)
		self:AddAnimationEvent("dance_specialist",601,"smile",4167)
		self:AddAnimationEvent("dance_specialist",650,"default",4167)
		self:AddAnimationEvent("dance_specialist",742,"smile",4167)
		self:AddAnimationEvent("dance_specialist",754,"default",4167)
		self:AddAnimationEvent("dance_specialist",908,"smile",4167)
		self:AddAnimationEvent("dance_specialist",945,"default",4167)
		self:AddAnimationEvent("dance_specialist",1171,"smile",4167)
		self:AddAnimationEvent("dance_specialist",1305,"default",4167)
		self:AddAnimationEvent("dance_specialist",1395,"smile",4167)
		self:AddAnimationEvent("dance_specialist",1628,"default",4167)
		self:AddAnimationEvent("dance_specialist",1741,"smile",4167)
		self:AddAnimationEvent("dance_specialist",1760,"default",4167)
		self:AddAnimationEvent("dance_specialist",1964,"smile",4167)
		self:AddAnimationEvent("dance_specialist",2060,"default",4167)
		self:AddAnimationEvent("dance_specialist",2145,"smile",4167)
		self:AddAnimationEvent("dance_specialist",2175,"default",4167)
		self:AddAnimationEvent("dance_specialist",2475,"smile",4167)
		self:AddAnimationEvent("dance_specialist",2507,"default",4167)
		self:AddAnimationEvent("dance_specialist",2550,"smile",4167)
		self:AddAnimationEvent("dance_specialist",2575,"default",4167)
		self:AddAnimationEvent("dance_specialist",3033,"smile",4167)
		self:AddAnimationEvent("dance_specialist",3097,"default",4167)
		self:AddAnimationEvent("dance_specialist",3369,"smile",4167)
		self:AddAnimationEvent("dance_specialist",3426,"default",4167)
		self:AddAnimationEvent("dance_specialist",3770,"smile",4167)
		self:AddAnimationEvent("dance_specialist",3871,"default",4167)
		self:AddAnimationEvent("dance_specialist",4031,"smile",4167)
		self:AddAnimationEvent("dance_specialist",4106,"default",4167)
	end

	function ENT:HandleAnimationEvent(seq,event,frame)
		if event == "default" then
			self:SetBodygroup(1,0)
		end
		if event == "smile" then
			self:SetBodygroup(1,1)
		end
	end

	function ENT:OnPlayDance(seq,t)
		if seq == "dance_specialist" then
			self:ChangeFace()
		end
	end
end
/*--------------------------------------------------
	*** Copyright (c) 2012-2020 by DrVrej, All rights reserved. ***
	No parts of this code or any of its contents may be reproduced, copied, modified or adapted,
	without the prior written consent of the author, unless otherwise indicated for persona-alone materials.
--------------------------------------------------*/