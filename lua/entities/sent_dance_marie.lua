AddCSLuaFile()

ENT.Base 			= "sent_dance_base"
ENT.Type 			= "anim"
ENT.PrintName 		= "Marie"
ENT.Author 			= "Cpt. Hazama"
ENT.Contact 		= "Atlus or some shit"
ENT.Purpose 		= ""
ENT.Instructions 	= "To fucking dance like there's no tomorrow"
ENT.Category		= "Persona - Dance"

ENT.Spawnable = true
ENT.AdminOnly = true

ENT.Model = "models/cpthazama/persona4_dance/marie.mdl"
ENT.HeightOffset = 0.1
ENT.CollisionBounds = Vector(16,16,75)
ENT.SongStartDelay = 1	
ENT.SongStartAnimationDelay = 0
ENT.ViewBone = "Spine2"

ENT.Animations = {}
ENT.Animations["dance_breakoutof"] = {}
ENT.Animations["dance_breakoutof"][1] = {anim = "dance_breakoutof",next = "dance_breakoutof_b",endEarlyTime = 0}
ENT.Animations["dance_breakoutof"][2] = {anim = "dance_breakoutof_b",next = false,endEarlyTime = 0}

ENT.SoundTracks = {
	[1] = {dance = "dance_breakoutof", song = "cpthazama/persona4_dance/music/c012.mp3"}
}

BG_TOP = 1
BG_BOTTOM = 2
BG_BROW = 3
BG_HAT = 4
BG_BAG = 5

F_BOF = 4999
F_BOF_B = 1610

BG_TOP_DEFAULT = 11
BG_TOP_CLOSED = 12
BG_TOP_WIDE = 13
BG_TOP_SQUINT = 14
BG_TOP_WINK = 15

BG_BOTTOM_DEFAULT = 21
BG_BOTTOM_SMILE = 22
BG_BOTTOM_NEUTRAL = 23
BG_BOTTOM_OPEN = 24
BG_BOTTOM_OPENWIDE = 25
BG_BOTTOM_SHOCKED = 26
BG_BOTTOM_SMIRK = 27
BG_BOTTOM_CRINGE = 28

BG_BROW_DEFAULT = 31
BG_BROW_HAPPY = 32
BG_BROW_WINK = 33
---------------------------------------------------------------------------------------------------------------------------------------------
if SERVER then
	function ENT:OnInit()
		-- self:ManipulateBoneJiggle(44,1) -- Bust | Removes the animated phys smh
		self:ManipulateBoneJiggle(46,1) -- Tie
		self:ManipulateBoneJiggle(47,1)
		self:ManipulateBoneJiggle(48,1)
		self:ManipulateBoneJiggle(4,1) -- Skirt
		self:ManipulateBoneJiggle(5,1)
		self:ManipulateBoneJiggle(6,1)
		self:ManipulateBoneJiggle(7,1)
		self:ManipulateBoneJiggle(8,1)
		self:ManipulateBoneJiggle(9,1)
		self:ManipulateBoneJiggle(10,1)
		self:ManipulateBoneJiggle(11,1)
		self:ManipulateBoneJiggle(12,1)
		self:ManipulateBoneJiggle(13,1)
		self:ManipulateBoneJiggle(14,1)
		self:ManipulateBoneJiggle(15,1)
		self:ManipulateBoneJiggle(16,1)
		self:ManipulateBoneJiggle(17,1)
		self:ManipulateBoneJiggle(18,1)
		self:ManipulateBoneJiggle(19,1)
		self:ManipulateBoneJiggle(106,1) -- Hair
		self:ManipulateBoneJiggle(107,1)
		self:ManipulateBoneJiggle(108,1)
		self:ManipulateBoneJiggle(109,1)
		self:ManipulateBoneJiggle(110,1)
		self:ManipulateBoneJiggle(111,1)
		self:ManipulateBoneJiggle(112,1)
		self:ManipulateBoneJiggle(113,1)

		self:SetBodygroup(BG_HAT,math.random(1,50) == 1 && 1 or 0)
		self:SetBodygroup(BG_BAG,math.random(1,50) == 1 && 1 or 0)

		self:AddAnimationEvent("dance_breakoutof",1,"default",F_BOF)
		self:AddAnimationEvent("dance_breakoutof",139,"open",F_BOF)
		self:AddAnimationEvent("dance_breakoutof",174,"smile",F_BOF)
		-- self:AddAnimationEvent("dance_breakoutof",295,"openwide",F_BOF)
		self:AddAnimationEvent("dance_breakoutof",295,"open",F_BOF)
		self:AddAnimationEvent("dance_breakoutof",310,"smile",F_BOF)
		self:AddAnimationEvent("dance_breakoutof",327,"squint_open",F_BOF)
		self:AddAnimationEvent("dance_breakoutof",361,"smirk",F_BOF)
		self:AddAnimationEvent("dance_breakoutof",388,"open",F_BOF)
		self:AddAnimationEvent("dance_breakoutof",398,"smile",F_BOF)
		self:AddAnimationEvent("dance_breakoutof",527,"open",F_BOF)
		self:AddAnimationEvent("dance_breakoutof",565,"smile",F_BOF)
		self:AddAnimationEvent("dance_breakoutof",700,"open",F_BOF)
		self:AddAnimationEvent("dance_breakoutof",710,"smile",F_BOF)
		self:AddAnimationEvent("dance_breakoutof",950,"openwide",F_BOF)
		self:AddAnimationEvent("dance_breakoutof",960,"smile",F_BOF)
		self:AddAnimationEvent("dance_breakoutof",1050,"smile_close",F_BOF)
		self:AddAnimationEvent("dance_breakoutof",1065,"smile",F_BOF)
		self:AddAnimationEvent("dance_breakoutof",1145,"openwide",F_BOF)
		self:AddAnimationEvent("dance_breakoutof",1225,"smile",F_BOF)
		self:AddAnimationEvent("dance_breakoutof",1314,"wink",F_BOF)
		self:AddAnimationEvent("dance_breakoutof",1333,"smile",F_BOF)
		self:AddAnimationEvent("dance_breakoutof",1385,"smile_close",F_BOF)
		self:AddAnimationEvent("dance_breakoutof",1395,"smile",F_BOF)
		self:AddAnimationEvent("dance_breakoutof",1608,"open",F_BOF)
		self:AddAnimationEvent("dance_breakoutof",1620,"smile",F_BOF)
		self:AddAnimationEvent("dance_breakoutof",1680,"open",F_BOF)
		self:AddAnimationEvent("dance_breakoutof",1718,"smile_close",F_BOF)
		self:AddAnimationEvent("dance_breakoutof",1800,"smile",F_BOF)
		self:AddAnimationEvent("dance_breakoutof",1892,"wink",F_BOF)
		self:AddAnimationEvent("dance_breakoutof",1919,"smile",F_BOF)
		self:AddAnimationEvent("dance_breakoutof",2199,"smile_close",F_BOF)
		self:AddAnimationEvent("dance_breakoutof",2226,"open_shocked",F_BOF)
		self:AddAnimationEvent("dance_breakoutof",2240,"open",F_BOF)
		self:AddAnimationEvent("dance_breakoutof",2256,"open_wide",F_BOF)
		self:AddAnimationEvent("dance_breakoutof",2287,"smile_close",F_BOF)
		self:AddAnimationEvent("dance_breakoutof",2292,"open",F_BOF)
		self:AddAnimationEvent("dance_breakoutof",2335,"smile",F_BOF)
		self:AddAnimationEvent("dance_breakoutof",3005,"wink",F_BOF)
		self:AddAnimationEvent("dance_breakoutof",3010,"smile",F_BOF)
		self:AddAnimationEvent("dance_breakoutof",3030,"open",F_BOF)
		self:AddAnimationEvent("dance_breakoutof",3040,"smile",F_BOF)
		self:AddAnimationEvent("dance_breakoutof",3133,"smile_close",F_BOF)
		self:AddAnimationEvent("dance_breakoutof",3173,"open",F_BOF)
		self:AddAnimationEvent("dance_breakoutof",3173,"open",F_BOF)
		self:AddAnimationEvent("dance_breakoutof",3200,"smile",F_BOF)
		self:AddAnimationEvent("dance_breakoutof",3455,"smile_close",F_BOF)
		self:AddAnimationEvent("dance_breakoutof",3467,"openwide",F_BOF)
		self:AddAnimationEvent("dance_breakoutof",3478,"smile",F_BOF)
		self:AddAnimationEvent("dance_breakoutof",3584,"open",F_BOF)
		self:AddAnimationEvent("dance_breakoutof",3595,"smile",F_BOF)
		self:AddAnimationEvent("dance_breakoutof",3667,"open",F_BOF)
		self:AddAnimationEvent("dance_breakoutof",3692,"smile_close",F_BOF)
		self:AddAnimationEvent("dance_breakoutof",3778,"smile",F_BOF)
		self:AddAnimationEvent("dance_breakoutof",3904,"open_shocked",F_BOF)
		self:AddAnimationEvent("dance_breakoutof",3918,"smile",F_BOF)
		self:AddAnimationEvent("dance_breakoutof",3986,"openwide",F_BOF)
		self:AddAnimationEvent("dance_breakoutof",4015,"open",F_BOF)
		self:AddAnimationEvent("dance_breakoutof",4028,"smile",F_BOF)
		self:AddAnimationEvent("dance_breakoutof",4173,"wink",F_BOF)
		self:AddAnimationEvent("dance_breakoutof",4185,"smirk",F_BOF)
		self:AddAnimationEvent("dance_breakoutof",4200,"open_shocked",F_BOF)
		self:AddAnimationEvent("dance_breakoutof",4212,"open",F_BOF)
		self:AddAnimationEvent("dance_breakoutof",4222,"open_wide",F_BOF)
		self:AddAnimationEvent("dance_breakoutof",4229,"smile_close",F_BOF)
		self:AddAnimationEvent("dance_breakoutof",4235,"smile",F_BOF)
		self:AddAnimationEvent("dance_breakoutof",4437,"open",F_BOF)
		self:AddAnimationEvent("dance_breakoutof",4510,"smile",F_BOF)
		self:AddAnimationEvent("dance_breakoutof",4659,"openwide",F_BOF)
		self:AddAnimationEvent("dance_breakoutof",4679,"smile",F_BOF)
		self:AddAnimationEvent("dance_breakoutof",4806,"smirk",F_BOF)
		self:AddAnimationEvent("dance_breakoutof",4836,"cringe",F_BOF)
		self:AddAnimationEvent("dance_breakoutof",4836,"cringe",F_BOF)
		self:AddAnimationEvent("dance_breakoutof",4841,"smile",F_BOF)
		self:AddAnimationEvent("dance_breakoutof",4903,"wink",F_BOF)
		self:AddAnimationEvent("dance_breakoutof",4924,"smile_close",F_BOF)
		self:AddAnimationEvent("dance_breakoutof",4936,"smile",F_BOF)
		self:AddAnimationEvent("dance_breakoutof",4990,"wink",F_BOF)

		self:AddAnimationEvent("dance_breakoutof_b",0,"wink",F_BOF_B)
		self:AddAnimationEvent("dance_breakoutof_b",1,"wink",F_BOF_B)
		self:AddAnimationEvent("dance_breakoutof_b",15,"smile",F_BOF_B)
		self:AddAnimationEvent("dance_breakoutof_b",107,"open",F_BOF_B)
		self:AddAnimationEvent("dance_breakoutof_b",116,"smile",F_BOF_B)
		self:AddAnimationEvent("dance_breakoutof_b",220,"openwide",F_BOF_B)
		self:AddAnimationEvent("dance_breakoutof_b",245,"smile",F_BOF_B)
		self:AddAnimationEvent("dance_breakoutof_b",263,"wink",F_BOF_B)
		self:AddAnimationEvent("dance_breakoutof_b",283,"open",F_BOF_B)
		self:AddAnimationEvent("dance_breakoutof_b",292,"smile",F_BOF_B)
		self:AddAnimationEvent("dance_breakoutof_b",313,"smirk",F_BOF_B)
		self:AddAnimationEvent("dance_breakoutof_b",338,"openwide",F_BOF_B)
		self:AddAnimationEvent("dance_breakoutof_b",353,"smile",F_BOF_B)
		self:AddAnimationEvent("dance_breakoutof_b",358,"smile_close",F_BOF_B)
		self:AddAnimationEvent("dance_breakoutof_b",375,"smile",F_BOF_B)
		self:AddAnimationEvent("dance_breakoutof_b",635,"open",F_BOF_B)
		self:AddAnimationEvent("dance_breakoutof_b",655,"smirk",F_BOF_B)
		self:AddAnimationEvent("dance_breakoutof_b",670,"smile",F_BOF_B)
		self:AddAnimationEvent("dance_breakoutof_b",693,"openwide",F_BOF_B)
		self:AddAnimationEvent("dance_breakoutof_b",755,"smile",F_BOF_B)
		self:AddAnimationEvent("dance_breakoutof_b",915,"wink",F_BOF_B)
		self:AddAnimationEvent("dance_breakoutof_b",924,"smile",F_BOF_B)
		self:AddAnimationEvent("dance_breakoutof_b",1174,"openwide",F_BOF_B)
		self:AddAnimationEvent("dance_breakoutof_b",1195,"open_shocked",F_BOF_B)
		self:AddAnimationEvent("dance_breakoutof_b",1199,"smile",F_BOF_B)
		self:AddAnimationEvent("dance_breakoutof_b",1317,"openwide",F_BOF_B)
		self:AddAnimationEvent("dance_breakoutof_b",1367,"smile",F_BOF_B)
		self:AddAnimationEvent("dance_breakoutof_b",F_BOF_B -1,"default",F_BOF_B)
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
		if event == "smile" then
			local top,bottom,brow = 0,6,1
			self:SetFace(top,bottom,brow)
		end
		if event == "neutral" then
			local top,bottom,brow = 0,2,1
			self:SetFace(top,bottom,brow)
		end
		if event == "open" then
			local top,bottom,brow = 0,3,1
			self:SetFace(top,bottom,brow)
		end
		if event == "openwide" then
			local top,bottom,brow = 2,4,1
			self:SetFace(top,bottom,brow)
		end
		if event == "open_shocked" then
			local top,bottom,brow = 2,5,0
			self:SetFace(top,bottom,brow)
		end
		if event == "wink" then
			local top,bottom,brow = 4,6,2
			self:SetFace(top,bottom,brow)
		end
		if event == "smile_close" then
			local top,bottom,brow = 1,1,1
			self:SetFace(top,bottom,brow)
		end
		if event == "squint" then
			local top,bottom,brow = 3,5,2
			self:SetFace(top,bottom,brow)
		end
		if event == "squint_open" then
			local top,bottom,brow = 3,3,1
			self:SetFace(top,bottom,brow)
		end
		if event == "smirk" then
			local top,bottom,brow = 0,1,0
			self:SetFace(top,bottom,brow)
		end
		if event == "cringe" then
			local top,bottom,brow = 2,7,0
			self:SetFace(top,bottom,brow)
		end
	end

	function ENT:OnPlayDance(seq,t)
		-- if seq == "dance_breakoutof" then
			-- self:ChangeFace(nil,nil,2)
		-- end
	end
end
/*--------------------------------------------------
	*** Copyright (c) 2012-2020 by DrVrej, All rights reserved. ***
	No parts of this code or any of its contents may be reproduced, copied, modified or adapted,
	without the prior written consent of the author, unless otherwise indicated for persona-alone materials.
--------------------------------------------------*/