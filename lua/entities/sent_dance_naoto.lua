AddCSLuaFile()

ENT.Base 			= "sent_dance_base"
ENT.Type 			= "anim"
ENT.PrintName 		= "Naoto Shirogane"
ENT.Author 			= "Cpt. Hazama"
ENT.Contact 		= "Atlus or some shit"
ENT.Purpose 		= ""
ENT.Instructions 	= "To fucking dance like there's no tomorrow"
ENT.Category		= "Persona - Dance"

ENT.Spawnable = true
ENT.AdminOnly = true

ENT.Model = "models/cpthazama/persona4_dance/naoto.mdl"
ENT.HeightOffset = 1
ENT.ModelScale = 0.42
ENT.CollisionBounds = Vector(16,16,75)
ENT.SongStartDelay = 1.35
ENT.SongStartAnimationDelay = 0
ENT.ViewBone = "spine_01"

ENT.Animations = {}
ENT.Animations["dance_signsoflove"] = {}
ENT.Animations["dance_signsoflove"][1] = {anim = "dance_signsoflove",next = "dance_signsoflove_b",endEarlyTime = 0.02}
ENT.Animations["dance_signsoflove"][2] = {anim = "dance_signsoflove_b",next = false,endEarlyTime = 0}

ENT.SoundTracks = {
	[1] = {dance = "dance_signsoflove", song = "cpthazama/persona4_dance/music/c007.mp3", name = "Signs Of Love -Remix-"}
}

ENT.PreviewThemes = {"cpthazama/persona4_dance/music/preview.wav"}

ENT.Outfits = {}
ENT.Outfits[1] = {Name = "Stage Outfit", Model = "", Offset = 1, ReqSong = nil, ReqScore = 0}

ENT.SongLength = {}
ENT.SongLength["dance_signsoflove"] = 175
---------------------------------------------------------------------------------------------------------------------------------------------
if SERVER then
	function ENT:OnInit()
		-- self:SetCinematicData()
		self:RandomizeCinematics("dance_signsoflove",4998)
		self:RandomizeCinematics("dance_signsoflove_b",511)

		self:AddAnimationEvent("dance_signsoflove",1,"default",4998)
		self:AddAnimationEvent("dance_signsoflove",45,"happy",4998)
		self:AddAnimationEvent("dance_signsoflove",190,"default",4998)
		self:AddAnimationEvent("dance_signsoflove",200,"closed",4998)
		self:AddAnimationEvent("dance_signsoflove",220,"happy",4998)
		self:AddAnimationEvent("dance_signsoflove",315,"thatLOOK",4998)
		self:AddAnimationEvent("dance_signsoflove",350,"happy",4998)
		self:AddAnimationEvent("dance_signsoflove",574,"open_wide",4998)
		self:AddAnimationEvent("dance_signsoflove",590,"neutral",4998)
		self:AddAnimationEvent("dance_signsoflove",642,"open",4998)
		self:AddAnimationEvent("dance_signsoflove",655,"happy",4998)
		self:AddAnimationEvent("dance_signsoflove",734,"thatLOOK",4998)
		self:AddAnimationEvent("dance_signsoflove",750,"happy",4998)
		self:AddAnimationEvent("dance_signsoflove",786,"thatLOOK",4998)
		self:AddAnimationEvent("dance_signsoflove",824,"open_wide",4998)
		self:AddAnimationEvent("dance_signsoflove",886,"wink",4998)
		self:AddAnimationEvent("dance_signsoflove",900,"neutral",4998)
		self:AddAnimationEvent("dance_signsoflove",925,"happy",4998)
		self:AddAnimationEvent("dance_signsoflove",1050,"thatLOOK",4998)
		self:AddAnimationEvent("dance_signsoflove",1084,"neutral",4998)
		self:AddAnimationEvent("dance_signsoflove",1154,"open",4998)
		self:AddAnimationEvent("dance_signsoflove",1205,"wink",4998)
		self:AddAnimationEvent("dance_signsoflove",1215,"open_wide",4998)
		self:AddAnimationEvent("dance_signsoflove",1222,"squint",4998)
		self:AddAnimationEvent("dance_signsoflove",1234,"happy",4998)
		self:AddAnimationEvent("dance_signsoflove",1264,"neutral",4998)
		self:AddAnimationEvent("dance_signsoflove",1289,"happy",4998)
		self:AddAnimationEvent("dance_signsoflove",1299,"thatLOOK",4998)
		self:AddAnimationEvent("dance_signsoflove",1305,"neutral",4998)
		self:AddAnimationEvent("dance_signsoflove",1320,"open_wide",4998)
		self:AddAnimationEvent("dance_signsoflove",1356,"squint",4998)
		self:AddAnimationEvent("dance_signsoflove",1368,"happy",4998)
		self:AddAnimationEvent("dance_signsoflove",1452,"neutral",4998)
		self:AddAnimationEvent("dance_signsoflove",1515,"happy",4998)
		self:AddAnimationEvent("dance_signsoflove",1611,"open_wide",4998)
		self:AddAnimationEvent("dance_signsoflove",1637,"happy",4998)
		self:AddAnimationEvent("dance_signsoflove",1660,"neutral",4998)
		self:AddAnimationEvent("dance_signsoflove",1719,"squint",4998)
		self:AddAnimationEvent("dance_signsoflove",1726,"thatLOOK",4998)
		self:AddAnimationEvent("dance_signsoflove",1765,"neutral",4998)
		self:AddAnimationEvent("dance_signsoflove",1840,"thatLOOK",4998)
		self:AddAnimationEvent("dance_signsoflove",1884,"open",4998)
		self:AddAnimationEvent("dance_signsoflove",1890,"open_wide",4998)
		self:AddAnimationEvent("dance_signsoflove",1901,"neutral",4998)
		self:AddAnimationEvent("dance_signsoflove",1946,"wink",4998)
		self:AddAnimationEvent("dance_signsoflove",1958,"smile",4998)
		self:AddAnimationEvent("dance_signsoflove",2019,"thatLOOK",4998)
		self:AddAnimationEvent("dance_signsoflove",2025,"smile",4998)
		self:AddAnimationEvent("dance_signsoflove",2100,"open_wide",4998)
		self:AddAnimationEvent("dance_signsoflove",2140,"neutral",4998)
		self:AddAnimationEvent("dance_signsoflove",2195,"thatLOOK",4998)
		self:AddAnimationEvent("dance_signsoflove",2240,"smile",4998)
		self:AddAnimationEvent("dance_signsoflove",2280,"neutral",4998)
		self:AddAnimationEvent("dance_signsoflove",2338,"open_wide",4998)
		self:AddAnimationEvent("dance_signsoflove",2366,"smile",4998)
		self:AddAnimationEvent("dance_signsoflove",2444,"squint",4998)
		self:AddAnimationEvent("dance_signsoflove",2452,"open",4998)
		self:AddAnimationEvent("dance_signsoflove",2464,"neutral",4998)
		self:AddAnimationEvent("dance_signsoflove",2517,"open",4998)
		self:AddAnimationEvent("dance_signsoflove",2558,"wink",4998)
		self:AddAnimationEvent("dance_signsoflove",2570,"neutral",4998)
		self:AddAnimationEvent("dance_signsoflove",2585,"thatLOOK",4998)
		self:AddAnimationEvent("dance_signsoflove",2610,"smile",4998)
		self:AddAnimationEvent("dance_signsoflove",2635,"open_wide",4998)
		self:AddAnimationEvent("dance_signsoflove",2665,"open",4998)
		self:AddAnimationEvent("dance_signsoflove",2711,"thatLOOK",4998)
		self:AddAnimationEvent("dance_signsoflove",2837,"neutral",4998)
		self:AddAnimationEvent("dance_signsoflove",2888,"open_wide",4998)
		self:AddAnimationEvent("dance_signsoflove",2942,"smile",4998)
		self:AddAnimationEvent("dance_signsoflove",2970,"wink",4998)
		self:AddAnimationEvent("dance_signsoflove",2984,"neutral",4998)
		self:AddAnimationEvent("dance_signsoflove",2992,"open_wide",4998)
		self:AddAnimationEvent("dance_signsoflove",3021,"smile",4998)
		self:AddAnimationEvent("dance_signsoflove",3109,"neutral",4998)
		self:AddAnimationEvent("dance_signsoflove",3144,"open",4998)
		self:AddAnimationEvent("dance_signsoflove",3171,"open_wide",4998)
		self:AddAnimationEvent("dance_signsoflove",3192,"neutral",4998)
		self:AddAnimationEvent("dance_signsoflove",3218,"smile",4998)
		self:AddAnimationEvent("dance_signsoflove",3367,"neutral",4998)
		self:AddAnimationEvent("dance_signsoflove",3394,"thatLOOK",4998)
		self:AddAnimationEvent("dance_signsoflove",3429,"smile",4998)
		self:AddAnimationEvent("dance_signsoflove",3513,"open_wide",4998)
		self:AddAnimationEvent("dance_signsoflove",3531,"neutral",4998)
		self:AddAnimationEvent("dance_signsoflove",3644,"wink",4998)
		self:AddAnimationEvent("dance_signsoflove",3656,"neutral",4998)
		self:AddAnimationEvent("dance_signsoflove",3683,"open_wide",4998)
		self:AddAnimationEvent("dance_signsoflove",3696,"smile",4998)
		self:AddAnimationEvent("dance_signsoflove",3717,"thatLOOK",4998)
		self:AddAnimationEvent("dance_signsoflove",3758,"neutral",4998)
		self:AddAnimationEvent("dance_signsoflove",3820,"wink",4998)
		self:AddAnimationEvent("dance_signsoflove",3825,"smile",4998)
		self:AddAnimationEvent("dance_signsoflove",3906,"neutral",4998)
		self:AddAnimationEvent("dance_signsoflove",3951,"thatLOOK",4998)
		self:AddAnimationEvent("dance_signsoflove",3995,"wink",4998)
		self:AddAnimationEvent("dance_signsoflove",4008,"smile",4998)
		self:AddAnimationEvent("dance_signsoflove",4057,"open",4998)
		self:AddAnimationEvent("dance_signsoflove",4096,"neutral",4998)
		self:AddAnimationEvent("dance_signsoflove",4258,"smile",4998)
		self:AddAnimationEvent("dance_signsoflove",4310,"thatLOOK",4998)
		self:AddAnimationEvent("dance_signsoflove",4355,"wink",4998)
		self:AddAnimationEvent("dance_signsoflove",4372,"neutral",4998)
		self:AddAnimationEvent("dance_signsoflove",4456,"open_wide",4998)
		self:AddAnimationEvent("dance_signsoflove",4481,"neutral",4998)
		self:AddAnimationEvent("dance_signsoflove",4577,"open",4998)
		self:AddAnimationEvent("dance_signsoflove",4590,"open_wide",4998)
		self:AddAnimationEvent("dance_signsoflove",4607,"neutral",4998)
		self:AddAnimationEvent("dance_signsoflove",4752,"smile",4998)
		self:AddAnimationEvent("dance_signsoflove",4810,"thatLOOK",4998)
		self:AddAnimationEvent("dance_signsoflove",4870,"smile",4998)
		self:AddAnimationEvent("dance_signsoflove",4968,"neutral",4998)

		self:AddAnimationEvent("dance_signsoflove_b",1,"neutral",511)
		self:AddAnimationEvent("dance_signsoflove_b",87,"open_wide",511)
		self:AddAnimationEvent("dance_signsoflove_b",120,"smile",511)
		self:AddAnimationEvent("dance_signsoflove_b",170,"neutral",511)
		self:AddAnimationEvent("dance_signsoflove_b",317,"wink",511)
		self:AddAnimationEvent("dance_signsoflove_b",327,"open",511)
		self:AddAnimationEvent("dance_signsoflove_b",347,"neutral",511)
		self:AddAnimationEvent("dance_signsoflove_b",376,"thatLOOK",511)
		self:AddAnimationEvent("dance_signsoflove_b",507,"default",511)

		local exp = {"smile","smirk","eyeDroop","browUm"}
		self:RandomizeExpressions(exp,"preview",318)
	end

	function ENT:HandleAnimationEvent(seq,event,frame)
		if event == "default" then
			self:ResetFlexes()
		end
		if event == "smile" then
			self:RemoveOldFlexes({"smile","smile_teeth"})
			self:SendFlexData("smile",1,6)
			self:SendFlexData("smile_teeth",1,6)
		end
		if event == "neutral" then
			self:RemoveOldFlexes({"smile"})
			self:SendFlexData("smile",1,6)
		end
		if event == "open" then
			self:RemoveOldFlexes({"open_small","neutral","eyeOpen"})
			self:SendFlexData("eyeOpen",0.45,6)
			self:SendFlexData("neutral",1,6)
			self:SendFlexData("open_small",1,6)
		end
		if event == "open_wide" then
			self:RemoveOldFlexes({"smile_large","neutral","eyeOpen"})
			self:SendFlexData("eyeOpen",0.45,6)
			self:SendFlexData("neutral",1,6)
			self:SendFlexData("smile_large",1,6)
		end
		if event == "wink" then
			self:RemoveOldFlexes({"smile","smirk","lWink","eyeDroop","rBrowDown"})
			self:SendFlexData("eyeDroop",0.3,6)
			self:SendFlexData("rBrowDown",1,6)
			self:SendFlexData("lWink",1,6)
			self:SendFlexData("smile",1,6)
			self:SendFlexData("smirk",1,6)
		end
		if event == "squint" then
			self:RemoveOldFlexes({"smile","smirk","browAnger","eyeSerious","eyeOmi"})
			self:SendFlexData("eyeSerious",0.24,6)
			self:SendFlexData("eyeOmi",0.24,6)
			self:SendFlexData("browAnger",0.55,6)
			self:SendFlexData("smile",0.38,6)
			self:SendFlexData("smirk",0.28,6)
		end
		if event == "thatLOOK" then
			self:RemoveOldFlexes({"eyeSerious","smirk","eyeScold","eyeDroop","browUm"})
			self:SendFlexData("eyeDroop",0.55,6)
			self:SendFlexData("eyeSerious",0.1,6)
			self:SendFlexData("eyeScold",0.18,6)
			self:SendFlexData("browUm",1,6)
			self:SendFlexData("smirk",1,6)
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