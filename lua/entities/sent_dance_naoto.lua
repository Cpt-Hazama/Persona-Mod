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
ENT.CollisionBounds = Vector(16,16,75)
ENT.SongStartDelay = 1.35
ENT.SongStartAnimationDelay = 0
ENT.ViewBone = "spine_01"

ENT.Animations = {}
ENT.Animations["dance_signsoflove"] = {}
ENT.Animations["dance_signsoflove"][1] = {anim = "dance_signsoflove",next = "dance_signsoflove_b",endEarlyTime = 0.02}
ENT.Animations["dance_signsoflove"][2] = {anim = "dance_signsoflove_b",next = false,endEarlyTime = 0}

ENT.SoundTracks = {
	[1] = {dance = "dance_signsoflove", song = "cpthazama/persona4_dance/music/c007.mp3"}
}
---------------------------------------------------------------------------------------------------------------------------------------------
if SERVER then
	function ENT:OnInit()
		-- self:ManipulateBoneJiggle(12,1) -- Bust | Removes the animated phys smh
		-- self:ManipulateBoneJiggle(35,1) -- Bust | Removes the animated phys smh
		self:ManipulateBoneJiggle(79,1)

		self:AddAnimationEvent("dance_signsoflove",1,"default",4998)
		self:AddAnimationEvent("dance_signsoflove",45,"happy",4998)
		self:AddAnimationEvent("dance_signsoflove",190,"default",4998)
		self:AddAnimationEvent("dance_signsoflove",200,"closed",4998)
		self:AddAnimationEvent("dance_signsoflove",220,"happy",4998)
		self:AddAnimationEvent("dance_signsoflove",315,"sexy",4998)
		self:AddAnimationEvent("dance_signsoflove",350,"happy",4998)
		self:AddAnimationEvent("dance_signsoflove",574,"open_wide",4998)
		self:AddAnimationEvent("dance_signsoflove",590,"neutral",4998)
		self:AddAnimationEvent("dance_signsoflove",642,"open",4998)
		self:AddAnimationEvent("dance_signsoflove",655,"happy",4998)
		self:AddAnimationEvent("dance_signsoflove",734,"sexy",4998)
		self:AddAnimationEvent("dance_signsoflove",750,"happy",4998)
		self:AddAnimationEvent("dance_signsoflove",786,"sexy",4998)
		self:AddAnimationEvent("dance_signsoflove",824,"open_wide",4998)
		self:AddAnimationEvent("dance_signsoflove",886,"wink",4998)
		self:AddAnimationEvent("dance_signsoflove",900,"neutral",4998)
		self:AddAnimationEvent("dance_signsoflove",925,"happy",4998)
		self:AddAnimationEvent("dance_signsoflove",1050,"sexy",4998)
		self:AddAnimationEvent("dance_signsoflove",1084,"neutral",4998)
		self:AddAnimationEvent("dance_signsoflove",1154,"open",4998)
		self:AddAnimationEvent("dance_signsoflove",1205,"wink",4998)
		self:AddAnimationEvent("dance_signsoflove",1215,"open_wide",4998)
		self:AddAnimationEvent("dance_signsoflove",1222,"squint",4998)
		self:AddAnimationEvent("dance_signsoflove",1234,"happy",4998)
		self:AddAnimationEvent("dance_signsoflove",1264,"neutral",4998)
		self:AddAnimationEvent("dance_signsoflove",1289,"happy",4998)
		self:AddAnimationEvent("dance_signsoflove",1299,"sexy",4998)
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
		self:AddAnimationEvent("dance_signsoflove",1726,"sexy",4998)
		self:AddAnimationEvent("dance_signsoflove",1765,"neutral",4998)
		self:AddAnimationEvent("dance_signsoflove",1840,"sexy",4998)
		self:AddAnimationEvent("dance_signsoflove",1884,"open",4998)
		self:AddAnimationEvent("dance_signsoflove",1890,"open_wide",4998)
		self:AddAnimationEvent("dance_signsoflove",1901,"neutral",4998)
		self:AddAnimationEvent("dance_signsoflove",1946,"wink",4998)
		self:AddAnimationEvent("dance_signsoflove",1958,"smile",4998)
		self:AddAnimationEvent("dance_signsoflove",2019,"sexy",4998)
		self:AddAnimationEvent("dance_signsoflove",2025,"smile",4998)
		self:AddAnimationEvent("dance_signsoflove",2100,"open_wide",4998)
		self:AddAnimationEvent("dance_signsoflove",2140,"neutral",4998)
		self:AddAnimationEvent("dance_signsoflove",2195,"sexy",4998)
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
		self:AddAnimationEvent("dance_signsoflove",2585,"sexy",4998)
		self:AddAnimationEvent("dance_signsoflove",2610,"smile",4998)
		self:AddAnimationEvent("dance_signsoflove",2635,"open_wide",4998)
		self:AddAnimationEvent("dance_signsoflove",2665,"open",4998)
		self:AddAnimationEvent("dance_signsoflove",2711,"sexy",4998)
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
		self:AddAnimationEvent("dance_signsoflove",3394,"sexy",4998)
		self:AddAnimationEvent("dance_signsoflove",3429,"smile",4998)
		self:AddAnimationEvent("dance_signsoflove",3513,"open_wide",4998)
		self:AddAnimationEvent("dance_signsoflove",3531,"neutral",4998)
		self:AddAnimationEvent("dance_signsoflove",3644,"wink",4998)
		self:AddAnimationEvent("dance_signsoflove",3656,"neutral",4998)
		self:AddAnimationEvent("dance_signsoflove",3683,"open_wide",4998)
		self:AddAnimationEvent("dance_signsoflove",3696,"smile",4998)
		self:AddAnimationEvent("dance_signsoflove",3717,"sexy",4998)
		self:AddAnimationEvent("dance_signsoflove",3758,"neutral",4998)
		self:AddAnimationEvent("dance_signsoflove",3820,"wink",4998)
		self:AddAnimationEvent("dance_signsoflove",3825,"smile",4998)
		self:AddAnimationEvent("dance_signsoflove",3906,"neutral",4998)
		self:AddAnimationEvent("dance_signsoflove",3951,"sexy",4998)
		self:AddAnimationEvent("dance_signsoflove",3995,"wink",4998)
		self:AddAnimationEvent("dance_signsoflove",4008,"smile",4998)
		self:AddAnimationEvent("dance_signsoflove",4057,"open",4998)
		self:AddAnimationEvent("dance_signsoflove",4096,"neutral",4998)
		self:AddAnimationEvent("dance_signsoflove",4258,"smile",4998)
		self:AddAnimationEvent("dance_signsoflove",4310,"sexy",4998)
		self:AddAnimationEvent("dance_signsoflove",4355,"wink",4998)
		self:AddAnimationEvent("dance_signsoflove",4372,"neutral",4998)
		self:AddAnimationEvent("dance_signsoflove",4456,"open_wide",4998)
		self:AddAnimationEvent("dance_signsoflove",4481,"neutral",4998)
		self:AddAnimationEvent("dance_signsoflove",4577,"open",4998)
		self:AddAnimationEvent("dance_signsoflove",4590,"open_wide",4998)
		self:AddAnimationEvent("dance_signsoflove",4607,"neutral",4998)
		self:AddAnimationEvent("dance_signsoflove",4752,"smile",4998)
		self:AddAnimationEvent("dance_signsoflove",4810,"sexy",4998)
		self:AddAnimationEvent("dance_signsoflove",4870,"smile",4998)
		self:AddAnimationEvent("dance_signsoflove",4968,"neutral",4998)

		self:AddAnimationEvent("dance_signsoflove_b",1,"neutral",511)
		self:AddAnimationEvent("dance_signsoflove_b",87,"open_wide",511)
		self:AddAnimationEvent("dance_signsoflove_b",120,"smile",511)
		self:AddAnimationEvent("dance_signsoflove_b",170,"neutral",511)
		self:AddAnimationEvent("dance_signsoflove_b",317,"wink",511)
		self:AddAnimationEvent("dance_signsoflove_b",327,"open",511)
		self:AddAnimationEvent("dance_signsoflove_b",347,"neutral",511)
		self:AddAnimationEvent("dance_signsoflove_b",376,"sexy",511)
		self:AddAnimationEvent("dance_signsoflove_b",507,"default",511)
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
	*** Copyright (c) 2012-2020 by DrVrej, All rights reserved. ***
	No parts of this code or any of its contents may be reproduced, copied, modified or adapted,
	without the prior written consent of the author, unless otherwise indicated for persona-alone materials.
--------------------------------------------------*/