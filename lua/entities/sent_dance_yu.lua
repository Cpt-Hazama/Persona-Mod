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
	[1] = {dance = "dance_specialist", song = "cpthazama/persona4_dance/music/c001.mp3", name = "Specialist -Remix-"}
}

ENT.PreviewThemes = {"cpthazama/persona4_dance/music/preview.wav"}

ENT.Outfits = {}
ENT.Outfits[1] = {Name = "Yasogami Winter Uniform", Model = "", Offset = 1, ReqSong = nil, ReqScore = 0}

ENT.TrackNotes = {}
---------------------------------------------------------------------------------------------------------------------------------------------
if CLIENT then
	function ENT:ClientInit()
		-- local seq = "dance_specialist"
		-- local timer = 1.5
		-- self:AddNote(seq,"w",timer,9)
		-- self:AddNote(seq,"w",timer,10)
		-- self:AddNote(seq,"d",timer,11)
		-- self:AddNote(seq,"d",timer,12)
		-- self:AddNote(seq,"s",timer,13)
		-- self:AddNote(seq,"s",timer,13.5)
		
		-- self:AddNote(seq,"s",timer,14)
		-- self:AddNote(seq,"s",timer,14.25)
		
		-- self:AddNote(seq,"a",timer,14.5)
		-- self:AddNote(seq,"a",timer,14.75)
		
		-- self:AddNote(seq,"w",timer,15)
		-- self:AddNote(seq,"w",timer,15.25)

		-- self:AddNote(seq,"w",timer,16)
		-- self:AddNote(seq,"d",timer,16.75)
		-- self:AddNote(seq,"s",timer,17)
		-- self:AddNote(seq,"s",timer,17.25)
		-- self:AddNote(seq,"AAAAA",timer,18)
		-- self:AddNote(seq,"AAAAA",timer,spawnTime)
		-- self:AddNote(seq,"AAAAA",timer,spawnTime)
		-- self:AddNote(seq,"AAAAA",timer,spawnTime)
		-- self:AddNote(seq,"AAAAA",timer,spawnTime)
		-- self:AddNote(seq,"AAAAA",timer,spawnTime)
		-- self:AddNote(seq,"AAAAA",timer,spawnTime)
		-- self:AddNote(seq,"AAAAA",timer,spawnTime)
		-- self:AddNote(seq,"AAAAA",timer,spawnTime)
		-- self:AddNote(seq,"AAAAA",timer,spawnTime)
		-- self:AddNote(seq,"AAAAA",timer,spawnTime)
		-- self:AddNote(seq,"AAAAA",timer,spawnTime)
		-- self:AddNote(seq,"AAAAA",timer,spawnTime)
		-- self:AddNote(seq,"AAAAA",timer,spawnTime)
		-- self:AddNote(seq,"AAAAA",timer,spawnTime)
		-- self:AddNote(seq,"AAAAA",timer,spawnTime)
		-- self:AddNote(seq,"AAAAA",timer,spawnTime)
		-- self:AddNote(seq,"AAAAA",timer,spawnTime)
		-- self:AddNote(seq,"AAAAA",timer,spawnTime)
		-- self:AddNote(seq,"AAAAA",timer,spawnTime)
		-- self:AddNote(seq,"AAAAA",timer,spawnTime)
		-- self:AddNote(seq,"AAAAA",timer,spawnTime)
		-- self:AddNote(seq,"AAAAA",timer,spawnTime)
		-- self:AddNote(seq,"AAAAA",timer,spawnTime)
		-- self:AddNote(seq,"AAAAA",timer,spawnTime)
		-- self:AddNote(seq,"AAAAA",timer,spawnTime)
		-- self:AddNote(seq,"AAAAA",timer,spawnTime)
		-- self:AddNote(seq,"AAAAA",timer,spawnTime)
		-- self:AddNote(seq,"AAAAA",timer,spawnTime)
		-- self:AddNote(seq,"AAAAA",timer,spawnTime)
		-- self:AddNote(seq,"AAAAA",timer,spawnTime)
		-- self:AddNote(seq,"AAAAA",timer,spawnTime)
		-- self:AddNote(seq,"AAAAA",timer,spawnTime)
		-- self:AddNote(seq,"AAAAA",timer,spawnTime)
		-- self:AddNote(seq,"AAAAA",timer,spawnTime)
		-- self:AddNote(seq,"AAAAA",timer,spawnTime)
		-- self:AddNote(seq,"AAAAA",timer,spawnTime)
		-- self:AddNote(seq,"AAAAA",timer,spawnTime)
		-- self:AddNote(seq,"AAAAA",timer,spawnTime)
		-- self:AddNote(seq,"AAAAA",timer,spawnTime)
		-- self:AddNote(seq,"AAAAA",timer,spawnTime)
		-- self:AddNote(seq,"AAAAA",timer,spawnTime)
		-- self:AddNote(seq,"AAAAA",timer,spawnTime)
		-- self:AddNote(seq,"AAAAA",timer,spawnTime)
		-- self:AddNote(seq,"AAAAA",timer,spawnTime)
		-- self:AddNote(seq,"AAAAA",timer,spawnTime)
		-- self:AddNote(seq,"AAAAA",timer,spawnTime)
		-- self:AddNote(seq,"AAAAA",timer,spawnTime)
		-- self:AddNote(seq,"AAAAA",timer,spawnTime)
		-- self:AddNote(seq,"AAAAA",timer,spawnTime)
		-- self:AddNote(seq,"AAAAA",timer,spawnTime)
		-- self:AddNote(seq,"AAAAA",timer,spawnTime)
		-- self:AddNote(seq,"AAAAA",timer,spawnTime)
		-- self:AddNote(seq,"AAAAA",timer,spawnTime)
		-- self:AddNote(seq,"AAAAA",timer,spawnTime)
		-- self:AddNote(seq,"AAAAA",timer,spawnTime)
		-- self:AddNote(seq,"AAAAA",timer,spawnTime)
		-- self:AddNote(seq,"AAAAA",timer,spawnTime)
		-- self:AddNote(seq,"AAAAA",timer,spawnTime)
		-- self:AddNote(seq,"AAAAA",timer,spawnTime)
		-- self:AddNote(seq,"AAAAA",timer,spawnTime)
		-- self:AddNote(seq,"AAAAA",timer,spawnTime)
		-- self:AddNote(seq,"AAAAA",timer,spawnTime)
		-- self:AddNote(seq,"AAAAA",timer,spawnTime)
		-- self:AddNote(seq,"AAAAA",timer,spawnTime)
		-- self:AddNote(seq,"AAAAA",timer,spawnTime)
		-- self:AddNote(seq,"AAAAA",timer,spawnTime)
	end
end
---------------------------------------------------------------------------------------------------------------------------------------------
if SERVER then
	function ENT:OnInit()
		local function Cinematic(frame,data,seq,maxFrames)
			self:AddCinematicEvent(seq,frame,data,maxFrames)
		end

		-- self:ManipulateBoneJiggle(1,1)
		self:ManipulateBoneJiggle(2,1)
		self:ManipulateBoneJiggle(3,1)
		-- self:ManipulateBoneJiggle(4,1)
		self:ManipulateBoneJiggle(5,1)
		self:ManipulateBoneJiggle(6,1)
		self:ManipulateBoneJiggle(39,1)
		self:ManipulateBoneJiggle(61,1)

		-- self:SetCinematicData()
		Cinematic(1,{f=90,r=0,u=0,dist=0,speed=15},"dance_specialist",4167)
		Cinematic(5,{f=70,r=0,u=0,dist=0,speed=1},"dance_specialist",4167)
		Cinematic(15,{f=50,r=0,u=0,dist=0,speed=1},"dance_specialist",4167)
		Cinematic(30,{f=30,r=0,u=0,dist=0,speed=1},"dance_specialist",4167)
		Cinematic(45,{f=10,r=0,u=0,dist=0,speed=1,bone="neck"},"dance_specialist",4167)
		Cinematic(70,{f=10,r=0,u=0,dist=0,speed=false,bone="head"},"dance_specialist",4167)
		Cinematic(108,{f=25,r=-25,u=0,dist=0,speed=false,bone="head"},"dance_specialist",4167)
		Cinematic(180,{f=80,r=25,u=0,dist=0,speed=false},"dance_specialist",4167)
		Cinematic(290,{f=15,r=25,u=0,dist=0,speed=false,bone="head"},"dance_specialist",4167)
		Cinematic(390,{f=25,r=-8,u=20,dist=0,speed=false,bone="head"},"dance_specialist",4167)
		Cinematic(420,{f=25,r=15,u=-10,dist=0,speed=false,bone="head"},"dance_specialist",4167)
		Cinematic(435,{f=35,r=0,u=-5,dist=0,speed=false,bone="R_Knee"},"dance_specialist",4167)
		Cinematic(500,{f=55,r=-5,u=0,dist=0,speed=false},"dance_specialist",4167)
		Cinematic(610,{f=20,r=-10,u=0,dist=0,speed=false,bone="R_hand"},"dance_specialist",4167)
		Cinematic(630,{f=20,r=10,u=0,dist=0,speed=false,bone="L_hand"},"dance_specialist",4167)
		Cinematic(660,{f=50,r=0,u=0,dist=0,speed=false,bone="head"},"dance_specialist",4167)
		Cinematic(745,{f=20,r=10,u=0,dist=0,speed=false,bone="head"},"dance_specialist",4167)
		Cinematic(785,{f=20,r=-10,u=0,dist=0,speed=false,bone="head"},"dance_specialist",4167)
	
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
	*** Copyright (c) 2012-2021 by Cpt. Hazama, All rights reserved. ***
	No parts of this code or any of its contents may be reproduced, copied, modified or adapted,
	without the prior written consent of the author, unless otherwise indicated for persona-alone materials.
--------------------------------------------------*/