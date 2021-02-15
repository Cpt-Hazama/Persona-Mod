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
ENT.ModelScale = 0.42
ENT.CollisionBounds = Vector(16,16,75)
ENT.SongStartDelay = 0
ENT.SongStartAnimationDelay = 0.2

ENT.Animations = {}
ENT.Animations["dance_lastsurprise"] = {}
ENT.Animations["dance_lastsurprise"][1] = {anim = "dance_lastsurprise",next = "dance_lastsurprise2",endEarlyTime = 0}
ENT.Animations["dance_lastsurprise"][2] = {anim = "dance_lastsurprise2",next = "dance_lastsurprise4",endEarlyTime = 0}
ENT.Animations["dance_lastsurprise"][3] = {anim = "dance_lastsurprise4",next = "dance_lastsurprise2",endEarlyTime = 0}
ENT.Animations["dance_lastsurprise"][4] = {anim = "dance_lastsurprise2",next = "dance_lastsurprise5",endEarlyTime = 0}
ENT.Animations["dance_lastsurprise"][5] = {anim = "dance_lastsurprise5",next = "dance_lastsurprise3",endEarlyTime = 0}
ENT.Animations["dance_lastsurprise"][6] = {anim = "dance_lastsurprise3",next = "dance_lastsurprise6",endEarlyTime = 0}
ENT.Animations["dance_lastsurprise"][7] = {anim = "dance_lastsurprise6",next = false,endEarlyTime = 0}

ENT.SoundTracks = {
	[1] = {dance = "dance_lastsurprise", song = "cpthazama/persona5_dance/music/h015.mp3", name = "Last Surprise -Remix-"}
}

ENT.PreviewThemes = {"cpthazama/persona5_dance/music/preview.wav"}

ENT.Outfits = {}
ENT.Outfits[1] = {Name = "Stage Uniform", Model = "", Offset = 1, ReqSong = nil, ReqScore = 0}
ENT.Outfits[2] = {Name = "Summer Uniform", Model = "_uniform_summer", Offset = 1, ReqSong = "Last Surprise -Remix-", ReqScore = 12000}

ENT.SongLength = {}
ENT.SongLength["dance_lastsurprise"] = 204
---------------------------------------------------------------------------------------------------------------------------------------------
if SERVER then
	function ENT:OnInit()

		-- self:SetCinematicData()
		self:RandomizeCinematics("dance_lastsurprise",917)
		self:RandomizeCinematics("dance_lastsurprise2",1268)
		self:RandomizeCinematics("dance_lastsurprise3",406)
		self:RandomizeCinematics("dance_lastsurprise4",235)
		self:RandomizeCinematics("dance_lastsurprise5",1152)
		self:RandomizeCinematics("dance_lastsurprise6",1012)

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

		local exp = {"smile","eyeDroop","browUp"}
		self:RandomizeExpressions(exp,"preview",227)
	end

	function ENT:HandleAnimationEvent(seq,event,frame)
		if event == "default" then
			self:ResetFlexes()
		end
		if event == "smile" then
			self:RemoveOldFlexes({"smile","browUp"})
			self:SendFlexData("browUp",0.3,6)
			self:SendFlexData("smile",1,6)
		end
		if event == "open" then
			self:RemoveOldFlexes({"open_happy","neutral","eyeOpen"})
			self:SendFlexData("eyeOpen",0.45,6)
			self:SendFlexData("neutral",1,6)
			self:SendFlexData("open_happy",1,6)
		end
		if event == "wink" then
			self:RemoveOldFlexes({"smile_big","smirk","lWink","eyeDroop","rBrowDown"})
			self:SendFlexData("eyeDroop",0.3,6)
			self:SendFlexData("rBrowDown",1,6)
			self:SendFlexData("lWink",1,6)
			self:SendFlexData("smile_big",1,6)
			self:SendFlexData("smirk",1,6)
		end
	end
end
/*--------------------------------------------------
	*** Copyright (c) 2012-2021 by Cpt. Hazama, All rights reserved. ***
	No parts of this code or any of its contents may be reproduced, copied, modified or adapted,
	without the prior written consent of the author, unless otherwise indicated for persona-alone materials.
--------------------------------------------------*/