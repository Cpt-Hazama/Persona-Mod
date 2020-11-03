AddCSLuaFile()

ENT.Base 			= "sent_dance_base"
ENT.Type 			= "anim"
ENT.PrintName 		= "Tohru Adachi"
ENT.Author 			= "Cpt. Hazama"
ENT.Contact 		= "Atlus or some shit"
ENT.Purpose 		= ""
ENT.Instructions 	= "To fucking dance like there's no tomorrow"
ENT.Category		= "Persona - Dance"

ENT.Spawnable = true
ENT.AdminOnly = true

ENT.Model = "models/cpthazama/persona4_dance/adachi.mdl"
ENT.HeightOffset = 0.1
ENT.CollisionBounds = Vector(16,16,75)
ENT.SongStartDelay = 1
ENT.SongStartAnimationDelay = 0
ENT.ViewBone = "Spine2"

ENT.Animations = {}
ENT.Animations["dance_thefog"] = {}
ENT.Animations["dance_thefog"][1] = {anim = "dance_thefog",next = "dance_thefog_b",endEarlyTime = 0.04}
ENT.Animations["dance_thefog"][2] = {anim = "dance_thefog_b",next = false,endEarlyTime = 0}

ENT.SoundTracks = {
	[1] = {dance = "dance_thefog", song = "cpthazama/persona4_dance/music/c013.mp3", name = "The Fog"}
}

ENT.SongLength = {}
ENT.SongLength["dance_thefog"] = 249

BG_TOP = 1
BG_BOTTOM = 2
BG_BROW = 3

F_TF = 4999
F_TF_B = 2400
---------------------------------------------------------------------------------------------------------------------------------------------
if SERVER then
	function ENT:OnInit()
		self:ManipulateBoneJiggle(24,1) -- Suit
		self:ManipulateBoneJiggle(25,1)
		self:ManipulateBoneJiggle(26,1)
		self:ManipulateBoneJiggle(27,1)
		self:ManipulateBoneJiggle(28,1)
		self:ManipulateBoneJiggle(29,1)
		self:ManipulateBoneJiggle(30,1)
		self:ManipulateBoneJiggle(31,1)
		self:ManipulateBoneJiggle(32,1)
		self:ManipulateBoneJiggle(33,1)
		self:ManipulateBoneJiggle(34,1)
		self:ManipulateBoneJiggle(35,1)
		self:ManipulateBoneJiggle(97,1) -- Hair
		self:ManipulateBoneJiggle(98,1)
		self:ManipulateBoneJiggle(99,1)
		self:ManipulateBoneJiggle(100,1)
		self:ManipulateBoneJiggle(101,1)
		self:ManipulateBoneJiggle(102,1)
		-- self:ManipulateBoneJiggle(38,1) -- Tie
		-- self:ManipulateBoneJiggle(39,1)
		-- self:ManipulateBoneJiggle(40,1)
		-- self:ManipulateBoneJiggle(41,1)

		self:AddAnimationEvent("dance_thefog",1,"default",F_TF)
		self:AddAnimationEvent("dance_thefog",20,"neutral",F_TF)
		self:AddAnimationEvent("dance_thefog",225,"smirk",F_TF)
		self:AddAnimationEvent("dance_thefog",535,"smirk_smile",F_TF)
		self:AddAnimationEvent("dance_thefog",567,"smile",F_TF)
		self:AddAnimationEvent("dance_thefog",580,"smirk",F_TF)
		self:AddAnimationEvent("dance_thefog",648,"laugh",F_TF)
		self:AddAnimationEvent("dance_thefog",713,"open",F_TF)
		self:AddAnimationEvent("dance_thefog",727,"smirk_smile",F_TF)
		self:AddAnimationEvent("dance_thefog",785,"neutral",F_TF)
		self:AddAnimationEvent("dance_thefog",900,"smirk",F_TF)
		self:AddAnimationEvent("dance_thefog",953,"wink",F_TF)
		self:AddAnimationEvent("dance_thefog",963,"smirk",F_TF)
		self:AddAnimationEvent("dance_thefog",1005,"open",F_TF)
		self:AddAnimationEvent("dance_thefog",1016,"confused",F_TF)
		self:AddAnimationEvent("dance_thefog",1040,"default",F_TF)
		self:AddAnimationEvent("dance_thefog",1113,"smile",F_TF)
		self:AddAnimationEvent("dance_thefog",1150,"smirk",F_TF)
		self:AddAnimationEvent("dance_thefog",1158,"smile",F_TF)
		self:AddAnimationEvent("dance_thefog",1165,"smirk",F_TF)
		self:AddAnimationEvent("dance_thefog",1296,"laugh",F_TF)
		self:AddAnimationEvent("dance_thefog",1323,"smirk",F_TF)
		self:AddAnimationEvent("dance_thefog",1352,"open",F_TF)
		self:AddAnimationEvent("dance_thefog",1359,"confused",F_TF)
		self:AddAnimationEvent("dance_thefog",1385,"default",F_TF)
		self:AddAnimationEvent("dance_thefog",1429,"neutral",F_TF)
		self:AddAnimationEvent("dance_thefog",1514,"angry",F_TF)
		self:AddAnimationEvent("dance_thefog",1581,"neutral",F_TF)
		self:AddAnimationEvent("dance_thefog",1608,"smile",F_TF)
		self:AddAnimationEvent("dance_thefog",1690,"annoyed",F_TF)
		self:AddAnimationEvent("dance_thefog",1754,"angry",F_TF)
		self:AddAnimationEvent("dance_thefog",1772,"open",F_TF)
		self:AddAnimationEvent("dance_thefog",1783,"laugh_insane",F_TF)
		self:AddAnimationEvent("dance_thefog",1816,"angry",F_TF)
		self:AddAnimationEvent("dance_thefog",1856,"laugh",F_TF)
		self:AddAnimationEvent("dance_thefog",1918,"wink",F_TF)
		self:AddAnimationEvent("dance_thefog",1928,"laugh",F_TF)
		self:AddAnimationEvent("dance_thefog",1952,"laugh_insane",F_TF)
		self:AddAnimationEvent("dance_thefog",1988,"laugh",F_TF)
		self:AddAnimationEvent("dance_thefog",1995,"smirk",F_TF)
		self:AddAnimationEvent("dance_thefog",2035,"open",F_TF)
		self:AddAnimationEvent("dance_thefog",2076,"smirk",F_TF)
		self:AddAnimationEvent("dance_thefog",2196,"laugh",F_TF)
		self:AddAnimationEvent("dance_thefog",2285,"smirk",F_TF)
		self:AddAnimationEvent("dance_thefog",2295,"smile",F_TF)
		self:AddAnimationEvent("dance_thefog",2236,"smirk",F_TF)
		self:AddAnimationEvent("dance_thefog",2443,"confused",F_TF)
		self:AddAnimationEvent("dance_thefog",2493,"angry",F_TF)
		self:AddAnimationEvent("dance_thefog",2639,"annoyed",F_TF)
		self:AddAnimationEvent("dance_thefog",2722,"angry_insane",F_TF)
		self:AddAnimationEvent("dance_thefog",2765,"neutral",F_TF)
		self:AddAnimationEvent("dance_thefog",2816,"confused",F_TF)
		self:AddAnimationEvent("dance_thefog",2888,"angry",F_TF)
		self:AddAnimationEvent("dance_thefog",2977,"neutral",F_TF)
		self:AddAnimationEvent("dance_thefog",3056,"smirk_smile",F_TF)
		self:AddAnimationEvent("dance_thefog",2896,"shocked",F_TF)

		self:AddAnimationEvent("dance_thefog_b",0,"shocked",F_TF_B)
		self:AddAnimationEvent("dance_thefog_b",55,"scolded",F_TF_B)
		self:AddAnimationEvent("dance_thefog_b",142,"annoyed",F_TF_B)
		self:AddAnimationEvent("dance_thefog_b",206,"confused",F_TF_B)
		self:AddAnimationEvent("dance_thefog_b",218,"angry",F_TF_B)
		self:AddAnimationEvent("dance_thefog_b",226,"laugh_insane",F_TF_B)
		self:AddAnimationEvent("dance_thefog_b",235,"laugh",F_TF_B)
		self:AddAnimationEvent("dance_thefog_b",254,"laugh_insane",F_TF_B)
		self:AddAnimationEvent("dance_thefog_b",331,"smile",F_TF_B)
		self:AddAnimationEvent("dance_thefog_b",423,"laugh_insane",F_TF_B)
		self:AddAnimationEvent("dance_thefog_b",459,"confused",F_TF_B)
		self:AddAnimationEvent("dance_thefog_b",503,"shocked",F_TF_B)
		self:AddAnimationEvent("dance_thefog_b",545,"smirk",F_TF_B)
		self:AddAnimationEvent("dance_thefog_b",672,"smile",F_TF_B)
		self:AddAnimationEvent("dance_thefog_b",766,"smirk_smile",F_TF_B)
		self:AddAnimationEvent("dance_thefog_b",805,"smirk",F_TF_B)
		self:AddAnimationEvent("dance_thefog_b",930,"annoyed",F_TF_B)
		self:AddAnimationEvent("dance_thefog_b",1125,"smirk_smile",F_TF_B)
		self:AddAnimationEvent("dance_thefog_b",1230,"angry",F_TF_B)
		self:AddAnimationEvent("dance_thefog_b",1325,"annoyed",F_TF_B)
		self:AddAnimationEvent("dance_thefog_b",1365,"confused",F_TF_B)
		self:AddAnimationEvent("dance_thefog_b",1530,"angry",F_TF_B)
		self:AddAnimationEvent("dance_thefog_b",1640,"neutral",F_TF_B)
		self:AddAnimationEvent("dance_thefog_b",1721,"smile",F_TF_B)
		self:AddAnimationEvent("dance_thefog_b",1812,"confused",F_TF_B)
		self:AddAnimationEvent("dance_thefog_b",1894,"angry",F_TF_B)
		self:AddAnimationEvent("dance_thefog_b",1973,"confused",F_TF_B)
		self:AddAnimationEvent("dance_thefog_b",2115,"smirk_smile",F_TF_B)
		self:AddAnimationEvent("dance_thefog_b",2273,"smirk",F_TF_B)
		self:AddAnimationEvent("dance_thefog_b",2288,"wink",F_TF_B)
		self:AddAnimationEvent("dance_thefog_b",F_TF_B -1,"default",F_TF_B)
	end

	function ENT:SetFace(top,bottom,brow)
		self:SetBodygroup(BG_TOP,top)
		self:SetBodygroup(BG_BOTTOM,bottom)
		self:SetBodygroup(BG_BROW,brow)
	end

	function ENT:HandleAnimationEvent(seq,event,frame)
		if event == "default" then
			local top,bottom,brow = 0,0,0
			self:SetFace(top,bottom,brow)
		end
		if event == "angry" then
			local top,bottom,brow = 3,1,1
			self:SetFace(top,bottom,brow)
		end
		if event == "annoyed" then
			local top,bottom,brow = 0,2,1
			self:SetFace(top,bottom,brow)
		end
		if event == "bummed" then
			local top,bottom,brow = 0,3,5
			self:SetFace(top,bottom,brow)
		end
		if event == "confused" then
			local top,bottom,brow = 2,6,2
			self:SetFace(top,bottom,brow)
		end
		if event == "laugh" then
			local top,bottom,brow = 0,4,7
			self:SetFace(top,bottom,brow)
		end
		if event == "laugh_insane" then
			local top,bottom,brow = 2,5,2
			self:SetFace(top,bottom,brow)
		end
		if event == "neutral" then
			local top,bottom,brow = 0,6,0
			self:SetFace(top,bottom,brow)
		end
		if event == "open" then
			local top,bottom,brow = 2,7,3
			self:SetFace(top,bottom,brow)
		end
		if event == "sad" then
			local top,bottom,brow = 2,8,6
			self:SetFace(top,bottom,brow)
		end
		if event == "scoled" then
			local top,bottom,brow = 1,2,6
			self:SetFace(top,bottom,brow)
		end
		if event == "shocked" then
			local top,bottom,brow = 2,9,3
			self:SetFace(top,bottom,brow)
		end
		if event == "smile" then
			local top,bottom,brow = 3,10,7
			self:SetFace(top,bottom,brow)
		end
		if event == "smirk" then
			local top,bottom,brow = 3,11,7
			self:SetFace(top,bottom,brow)
		end
		if event == "smirk_smile" then
			local top,bottom,brow = 3,12,3
			self:SetFace(top,bottom,brow)
		end
		if event == "wink" then
			local top,bottom,brow = 4,10,7
			self:SetFace(top,bottom,brow)
		end
		if event == "angry_insane" then
			local top,bottom,brow = 2,1,2
			self:SetFace(top,bottom,brow)
		end
	end
end
/*--------------------------------------------------
	*** Copyright (c) 2012-2021 by Cpt. Hazama, All rights reserved. ***
	No parts of this code or any of its contents may be reproduced, copied, modified or adapted,
	without the prior written consent of the author, unless otherwise indicated for persona-alone materials.
--------------------------------------------------*/