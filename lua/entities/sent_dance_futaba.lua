AddCSLuaFile()

ENT.Base 			= "sent_dance_base"
ENT.Type 			= "anim"
ENT.PrintName 		= "Futaba Sakura"
ENT.Author 			= "Cpt. Hazama"
ENT.Contact 		= "Atlus or some shit"
ENT.Purpose 		= ""
ENT.Instructions 	= "To fucking dance like there's no tomorrow"
ENT.Category		= "Persona - Dance"

ENT.Spawnable = true
ENT.AdminOnly = true

ENT.Model = "models/cpthazama/persona5_dance/futaba.mdl"
ENT.HeightOffset = 1
ENT.CollisionBounds = Vector(16,16,75)
ENT.DelayBetweenAnimations = 0.065
ENT.SongStartDelay = 0
ENT.SongStartAnimationDelay = 0.2

ENT.Animations = {}
ENT.Animations["dance_lastsurprise"] = {}
ENT.Animations["dance_lastsurprise"][1] = {anim = "dance_lastsurprise",next = "dance_lastsurprise2"}
ENT.Animations["dance_lastsurprise"][2] = {anim = "dance_lastsurprise2",next = "dance_lastsurprise4"}
ENT.Animations["dance_lastsurprise"][3] = {anim = "dance_lastsurprise4",next = "dance_lastsurprise2"}
ENT.Animations["dance_lastsurprise"][4] = {anim = "dance_lastsurprise2",next = "dance_lastsurprise5"}
ENT.Animations["dance_lastsurprise"][5] = {anim = "dance_lastsurprise5",next = "dance_lastsurprise3"}
ENT.Animations["dance_lastsurprise"][6] = {anim = "dance_lastsurprise3",next = "dance_lastsurprise6"}
ENT.Animations["dance_lastsurprise"][7] = {anim = "dance_lastsurprise6",next = false}

ENT.SoundTracks = {
	[1] = {dance = "dance_lastsurprise", song = "cpthazama/persona5_dance/music/h015.mp3"}
}
---------------------------------------------------------------------------------------------------------------------------------------------
if SERVER then
	function ENT:OnInit()
		self:SetBodygroup(1,math.random(1,4) == 1 && 1 or 0)
		
		self:AddAnimationEvent("dance_lastsurprise",0,"default",917)
		self:AddAnimationEvent("dance_lastsurprise",1,"default",917)
		self:AddAnimationEvent("dance_lastsurprise",2,"default",917)
		self:AddAnimationEvent("dance_lastsurprise",287,"smile",917)
		self:AddAnimationEvent("dance_lastsurprise",638,"open",917)
		self:AddAnimationEvent("dance_lastsurprise",677,"smile",917)
		self:AddAnimationEvent("dance_lastsurprise",700,"open",917)
		self:AddAnimationEvent("dance_lastsurprise",730,"smile",917)
		self:AddAnimationEvent("dance_lastsurprise",785,"open",917)
		self:AddAnimationEvent("dance_lastsurprise",798,"smile",917)

		self:AddAnimationEvent("dance_lastsurprise2",190,"wink",1268)
		self:AddAnimationEvent("dance_lastsurprise2",208,"open",1268)
		self:AddAnimationEvent("dance_lastsurprise2",260,"smile",1268)
		self:AddAnimationEvent("dance_lastsurprise2",824,"open",1268)
		self:AddAnimationEvent("dance_lastsurprise2",845,"smile",1268)
		self:AddAnimationEvent("dance_lastsurprise2",962,"wink",1268)
		self:AddAnimationEvent("dance_lastsurprise2",980,"smile",1268)
		self:AddAnimationEvent("dance_lastsurprise2",1159,"open",1268)
		self:AddAnimationEvent("dance_lastsurprise2",1180,"smile",1268)

		self:AddAnimationEvent("dance_lastsurprise3",1,"open",406)
		self:AddAnimationEvent("dance_lastsurprise3",28,"smile",406)
		self:AddAnimationEvent("dance_lastsurprise3",60,"open",406)
		self:AddAnimationEvent("dance_lastsurprise3",85,"smile",406)
		self:AddAnimationEvent("dance_lastsurprise3",100,"wink",406)
		self:AddAnimationEvent("dance_lastsurprise3",118,"smile",406)
		self:AddAnimationEvent("dance_lastsurprise3",300,"open",406)
		self:AddAnimationEvent("dance_lastsurprise3",320,"smile",406)

		self:AddAnimationEvent("dance_lastsurprise4",64,"open",235)
		self:AddAnimationEvent("dance_lastsurprise4",122,"smile",235)

		self:AddAnimationEvent("dance_lastsurprise5",40,"open",1152)
		self:AddAnimationEvent("dance_lastsurprise5",122,"smile",1152)
		self:AddAnimationEvent("dance_lastsurprise5",225,"open",1152)
		self:AddAnimationEvent("dance_lastsurprise5",294,"smile",1152)
		self:AddAnimationEvent("dance_lastsurprise5",420,"wink",1152)
		self:AddAnimationEvent("dance_lastsurprise5",437,"open",1152)
		self:AddAnimationEvent("dance_lastsurprise5",468,"smile",1152)
		self:AddAnimationEvent("dance_lastsurprise5",692,"open",1152)
		self:AddAnimationEvent("dance_lastsurprise5",742,"smile",1152)
		self:AddAnimationEvent("dance_lastsurprise5",1088,"open",1152)
		self:AddAnimationEvent("dance_lastsurprise5",1125,"smile",1152)

		self:AddAnimationEvent("dance_lastsurprise6",16,"open",1012)
		self:AddAnimationEvent("dance_lastsurprise6",197,"smile",1012)
		self:AddAnimationEvent("dance_lastsurprise6",220,"open",1012)
		self:AddAnimationEvent("dance_lastsurprise6",227,"smile",1012)
		self:AddAnimationEvent("dance_lastsurprise6",265,"open",1012)
		self:AddAnimationEvent("dance_lastsurprise6",296,"smile",1012)
		self:AddAnimationEvent("dance_lastsurprise6",418,"wink",1012)
		self:AddAnimationEvent("dance_lastsurprise6",430,"smile",1012)
		self:AddAnimationEvent("dance_lastsurprise6",547,"open",1012)
		self:AddAnimationEvent("dance_lastsurprise6",560,"smile",1012)
		self:AddAnimationEvent("dance_lastsurprise6",878,"wink",1012)
		self:AddAnimationEvent("dance_lastsurprise6",878,"default",1010)
	end

	function ENT:HandleAnimationEvent(seq,event,frame)
		if event == "default" then
			self:SetBodygroup(2,0)
		end
		if event == "smile" then
			self:SetBodygroup(2,1)
		end
		if event == "open" then
			self:SetBodygroup(2,2)
		end
		if event == "wink" then
			self:SetBodygroup(2,3)
		end
	end

	function ENT:OnPlayDance(seq,t)
		if seq == "dance_lastsurprise" then
			self:ChangeFace()
		end
	end
end
/*--------------------------------------------------
	*** Copyright (c) 2012-2020 by DrVrej, All rights reserved. ***
	No parts of this code or any of its contents may be reproduced, copied, modified or adapted,
	without the prior written consent of the author, unless otherwise indicated for persona-alone materials.
--------------------------------------------------*/