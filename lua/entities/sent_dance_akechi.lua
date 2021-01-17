AddCSLuaFile()

ENT.Base 			= "sent_dance_base"
ENT.Type 			= "anim"
ENT.PrintName 		= "Goro Akechi"
ENT.Author 			= "Cpt. Hazama"
ENT.Contact 		= "Atlus or some shit"
ENT.Purpose 		= ""
ENT.Instructions 	= "To fucking dance like there's no tomorrow"
ENT.Category		= "Persona - Dance"

ENT.Spawnable = true
ENT.AdminOnly = true

ENT.Model = "models/cpthazama/persona5_dance/akechi.mdl"
ENT.HeightOffset = 1
ENT.CollisionBounds = Vector(16,16,75)
ENT.SongStartDelay = 0.1
ENT.ViewBone = "Spine2"

ENT.Animations = {}
ENT.Animations["dance_willpower"] = {}
ENT.Animations["dance_willpower"][1] = {anim = "dance_willpower",next = false,endEarlyTime = 0}

ENT.SoundTracks = {
	[1] = {dance = "dance_willpower", song = "cpthazama/persona5_dance/music/h024.mp3", name = "Will Power"}
}

ENT.Outfits = {}
ENT.Outfits[1] = {Name = "Detective Uniform", Model = "", Offset = 1, ReqSong = nil, ReqScore = 0}

ENT.Sounds = {}
ENT.Sounds["start"] = {
	"cpthazama/persona5_dance/akechi/24-005.wav",
	"cpthazama/persona5_dance/akechi/24-006.wav",
	"cpthazama/persona5_dance/akechi/24-007.wav",
	"cpthazama/persona5_dance/akechi/24-008.wav",
	"cpthazama/persona5_dance/akechi/24-009.wav",
	"cpthazama/persona5_dance/akechi/24-010.wav",
	"cpthazama/persona5_dance/akechi/24-011.wav",
	"cpthazama/persona5_dance/akechi/24-020.wav",
	"cpthazama/persona5_dance/akechi/24-025.wav",
	"cpthazama/persona5_dance/akechi/24-026.wav",
	"cpthazama/persona5_dance/akechi/24-027.wav",
	"cpthazama/persona5_dance/akechi/24-028.wav",
	"cpthazama/persona5_dance/akechi/24-029.wav",
	"cpthazama/persona5_dance/akechi/24-030.wav",
	"cpthazama/persona5_dance/akechi/24-031.wav",
	"cpthazama/persona5_dance/akechi/24-032.wav",
	"cpthazama/persona5_dance/akechi/24-033.wav",
	"cpthazama/persona5_dance/akechi/24-034.wav",
}
ENT.Sounds["idle"] = {
	"cpthazama/persona5_dance/akechi/24-065.wav",
	"cpthazama/persona5_dance/akechi/24-066.wav",
	"cpthazama/persona5_dance/akechi/24-067.wav",
	"cpthazama/persona5_dance/akechi/24-068.wav",
	"cpthazama/persona5_dance/akechi/24-069.wav",
	"cpthazama/persona5_dance/akechi/24-070.wav",
}
ENT.Sounds["idle_insane"] = {
	"cpthazama/persona5_dance/akechi/24-071.wav",
	"cpthazama/persona5_dance/akechi/24-072.wav",
	"cpthazama/persona5_dance/akechi/24-073.wav",
	"cpthazama/persona5_dance/akechi/24-074.wav",
	"cpthazama/persona5_dance/akechi/24-075.wav",
	"cpthazama/persona5_dance/akechi/24-076.wav",
	"cpthazama/persona5_dance/akechi/24-077.wav",
	"cpthazama/persona5_dance/akechi/24-078.wav",
	"cpthazama/persona5_dance/akechi/24-079.wav",
	"cpthazama/persona5_dance/akechi/24-080.wav",
}
ENT.Sounds["winning"] = {
	"cpthazama/persona5_dance/akechi/24-127.wav",
	"cpthazama/persona5_dance/akechi/24-128.wav",
	"cpthazama/persona5_dance/akechi/24-129.wav",
	"cpthazama/persona5_dance/akechi/24-130.wav",
	"cpthazama/persona5_dance/akechi/24-131.wav",
	"cpthazama/persona5_dance/akechi/24-132.wav",
	"cpthazama/persona5_dance/akechi/24-133.wav",
	"cpthazama/persona5_dance/akechi/24-134.wav",
}
ENT.Sounds["failing"] = {
	"cpthazama/persona5_dance/akechi/24-081.wav",
	"cpthazama/persona5_dance/akechi/24-082.wav",
	"cpthazama/persona5_dance/akechi/24-083.wav",
	"cpthazama/persona5_dance/akechi/24-084.wav",
	"cpthazama/persona5_dance/akechi/24-085.wav",
	"cpthazama/persona5_dance/akechi/24-086.wav",
	"cpthazama/persona5_dance/akechi/24-087.wav",
	"cpthazama/persona5_dance/akechi/24-088.wav",
	"cpthazama/persona5_dance/akechi/24-089.wav",
	"cpthazama/persona5_dance/akechi/24-091.wav",
	"cpthazama/persona5_dance/akechi/24-092.wav",
	"cpthazama/persona5_dance/akechi/24-093.wav",
	"cpthazama/persona5_dance/akechi/24-094.wav",
	"cpthazama/persona5_dance/akechi/24-095.wav",
	"cpthazama/persona5_dance/akechi/24-096.wav",
	"cpthazama/persona5_dance/akechi/24-097.wav",
	"cpthazama/persona5_dance/akechi/24-098.wav",
	"cpthazama/persona5_dance/akechi/24-099.wav",
	"cpthazama/persona5_dance/akechi/24-101.wav",
	"cpthazama/persona5_dance/akechi/24-102.wav",
	"cpthazama/persona5_dance/akechi/24-103.wav",
	"cpthazama/persona5_dance/akechi/24-104.wav",
	"cpthazama/persona5_dance/akechi/24-105.wav",
	"cpthazama/persona5_dance/akechi/24-106.wav",
	"cpthazama/persona5_dance/akechi/24-107.wav",
	"cpthazama/persona5_dance/akechi/24-108.wav",
	"cpthazama/persona5_dance/akechi/24-109.wav",
	"cpthazama/persona5_dance/akechi/24-110.wav",
	"cpthazama/persona5_dance/akechi/24-111.wav",
	"cpthazama/persona5_dance/akechi/24-112.wav",
	"cpthazama/persona5_dance/akechi/24-113.wav",
}

BG_TOP = 1
BG_BOTTOM = 2
BG_BROW = 3
BG_EYES = 4

F_WP = 4930

BG_TOP_DEFAULT = 0
BG_TOP_CLOSED = 1
BG_TOP_OPEN = 2
BG_TOP_ANGRY = 3

BG_BOTTOM_DEFAULT = 0
BG_BOTTOM_SMILE = 1
BG_BOTTOM_NEUTRAL = 2
BG_BOTTOM_OPEN = 3
BG_BOTTOM_SHOCKED = 4
BG_BOTTOM_ANGRY = 5
BG_BOTTOM_INSANE = 6
BG_BOTTOM_SMILE_INSANE = 7

BG_BROW_DEFAULT = 0
BG_BROW_ANGRY = 1
BG_BROW_HAPPY = 2

BG_EYES_DEFAULT = 0
BG_EYES_SMALL = 1
---------------------------------------------------------------------------------------------------------------------------------------------
if CLIENT then
	function ENT:ClientInit()
		local seq = "dance_willpower"
		local lifeTime = 1
		local offset = 0.5 -- Lazy be like
		self:AddNote(seq,"s",lifeTime,8 -lifeTime -offset)
		self:AddNote(seq,"a",lifeTime,9 -lifeTime -offset)
		self:AddNote(seq,"s",lifeTime,9.625 -lifeTime -offset)
		self:AddNote(seq,"d",lifeTime,10.5 -lifeTime -offset)
		self:AddNote(seq,"s",lifeTime,11.5 -lifeTime -offset)
		self:AddNote(seq,"a",lifeTime,12.25 -lifeTime -offset)
		self:AddNote(seq,"d",lifeTime,13 -lifeTime -offset)
		self:AddNote(seq,"a",lifeTime,13.75 -lifeTime -offset)
		self:AddNote(seq,"d",lifeTime,14 -lifeTime -offset)
		self:AddNote(seq,"d",lifeTime,14.25 -lifeTime -offset)
		self:AddNote(seq,"a",lifeTime,14.5 -lifeTime -offset)
		self:AddNote(seq,"s",lifeTime,15 -lifeTime -offset)
		self:AddNote(seq,"s",lifeTime,15.25 -lifeTime -offset)
		self:AddNote(seq,"s",lifeTime,15.5 -lifeTime -offset)
		self:AddNote(seq,"s",lifeTime,16 -lifeTime -offset)
		self:AddNote(seq,"a",lifeTime,16.5 -lifeTime -offset)
		self:AddNote(seq,"d",lifeTime,17 -lifeTime -offset)
		self:AddNote(seq,"a",lifeTime,17.5 -lifeTime -offset)
		self:AddNote(seq,"a",lifeTime,17.75 -lifeTime -offset)
		self:AddNote(seq,"a",lifeTime,18 -lifeTime -offset)
		self:AddNote(seq,"s",lifeTime,18.5 -lifeTime -offset)
		self:AddNote(seq,"d",lifeTime,18.75 -lifeTime -offset)
		self:AddNote(seq,"s",lifeTime,19.25 -lifeTime -offset)
		self:AddNote(seq,"s",lifeTime,19.5 -lifeTime -offset)
		self:AddNote(seq,"a",lifeTime,19.75 -lifeTime -offset)
		self:AddNote(seq,"s",lifeTime,20 -lifeTime -offset)
		self:AddNote(seq,"s",lifeTime,21 -lifeTime -offset)
		self:AddNote(seq,"s",lifeTime,21.25 -lifeTime -offset)
	end
end
---------------------------------------------------------------------------------------------------------------------------------------------
if SERVER then
	function ENT:OnStartDance(seq,song,songName,dance)
		local mode = GetConVarNumber("vj_persona_dancemode")
		if mode == 2 then
			self:PlaySound(nil,nil,nil,"cpthazama/persona5_dance/akechi/24-0" .. math.random(34,56) .. ".wav")
		else
			self:PlaySound("start")
		end

		self.Insane = false
		self.NextSpeakT = CurTime() +6
	end

	function ENT:OnInit()
		self:ManipulateBoneJiggle(28,1) -- Jacket
		self:ManipulateBoneJiggle(29,1)
		self:ManipulateBoneJiggle(30,1)
		self:ManipulateBoneJiggle(31,1)
		self:ManipulateBoneJiggle(32,1)
		-- self:ManipulateBoneJiggle(93,1) -- Hair
		-- self:ManipulateBoneJiggle(94,1)
		-- self:ManipulateBoneJiggle(95,1)
		-- self:ManipulateBoneJiggle(96,1)
		-- self:ManipulateBoneJiggle(97,1)
		-- self:ManipulateBoneJiggle(98,1)
		-- self:ManipulateBoneJiggle(99,1)
		-- self:ManipulateBoneJiggle(100,1)
		-- self:ManipulateBoneJiggle(101,1)
	
		self:AddAnimationEvent("dance_willpower",0,"default",F_WP)
		self:AddAnimationEvent("dance_willpower",100,"smile",F_WP)
		self:AddAnimationEvent("dance_willpower",246,"open",F_WP)
		self:AddAnimationEvent("dance_willpower",272,"smile",F_WP)
		self:AddAnimationEvent("dance_willpower",289,"neutral",F_WP)
		self:AddAnimationEvent("dance_willpower",423,"smile",F_WP)
		self:AddAnimationEvent("dance_willpower",460,"neutral",F_WP)
		self:AddAnimationEvent("dance_willpower",634,"open",F_WP)
		self:AddAnimationEvent("dance_willpower",654,"neutral",F_WP)
		self:AddAnimationEvent("dance_willpower",758,"smile",F_WP)
		self:AddAnimationEvent("dance_willpower",766,"insane_smile",F_WP)
		self:AddAnimationEvent("dance_willpower",773,"neutral",F_WP)
		self:AddAnimationEvent("dance_willpower",846,"open",F_WP)
		self:AddAnimationEvent("dance_willpower",856,"smile",F_WP)
		self:AddAnimationEvent("dance_willpower",900,"neutral",F_WP)
		self:AddAnimationEvent("dance_willpower",1089,"smile",F_WP)
		self:AddAnimationEvent("dance_willpower",1098,"open",F_WP)
		self:AddAnimationEvent("dance_willpower",1110,"neutral",F_WP)
		self:AddAnimationEvent("dance_willpower",1414,"insane_smile",F_WP)
		self:AddAnimationEvent("dance_willpower",1424,"smile",F_WP)
		self:AddAnimationEvent("dance_willpower",1660,"insane_smile",F_WP)
		self:AddAnimationEvent("dance_willpower",1680,"smile",F_WP)
		self:AddAnimationEvent("dance_willpower",1969,"insane",F_WP)
		self:AddAnimationEvent("dance_willpower",1978,"neutral",F_WP)
		self:AddAnimationEvent("dance_willpower",2014,"insane_smile",F_WP)
		self:AddAnimationEvent("dance_willpower",2023,"neutral",F_WP)
		self:AddAnimationEvent("dance_willpower",2237,"insane_smile",F_WP)
		self:AddAnimationEvent("dance_willpower",2372,"neutral",F_WP)
		self:AddAnimationEvent("dance_willpower",2406,"insane_smile",F_WP)
		self:AddAnimationEvent("dance_willpower",2490,"smile",F_WP)
		self:AddAnimationEvent("dance_willpower",2540,"insane_smile",F_WP)
		self:AddAnimationEvent("dance_willpower",2560,"smile",F_WP)
		self:AddAnimationEvent("dance_willpower",2566,"neutral",F_WP)
		self:AddAnimationEvent("dance_willpower",2594,"insane",F_WP)
		self:AddAnimationEvent("dance_willpower",2618,"neutral",F_WP)
		self:AddAnimationEvent("dance_willpower",2688,"insane",F_WP)
		self:AddAnimationEvent("dance_willpower",2715,"insane_smile",F_WP)
		self:AddAnimationEvent("dance_willpower",2725,"smile",F_WP)
		self:AddAnimationEvent("dance_willpower",2986,"insane_smile",F_WP)
		self:AddAnimationEvent("dance_willpower",3034,"neutral",F_WP)
		self:AddAnimationEvent("dance_willpower",3226,"insane_smile",F_WP)
		self:AddAnimationEvent("dance_willpower",3244,"neutral",F_WP)
		self:AddAnimationEvent("dance_willpower",3287,"insane_smile",F_WP)
		self:AddAnimationEvent("dance_willpower",3325,"neutral",F_WP)
		self:AddAnimationEvent("dance_willpower",3751,"insane",F_WP)
		self:AddAnimationEvent("dance_willpower",3788,"insane_smile",F_WP)
		self:AddAnimationEvent("dance_willpower",3908,"neutral",F_WP)
		self:AddAnimationEvent("dance_willpower",4024,"open",F_WP)
		self:AddAnimationEvent("dance_willpower",4036,"neutral",F_WP)
		self:AddAnimationEvent("dance_willpower",4098,"insane",F_WP)
		self:AddAnimationEvent("dance_willpower",4168,"neutral",F_WP)
		self:AddAnimationEvent("dance_willpower",4216,"insane_smile",F_WP)
		self:AddAnimationEvent("dance_willpower",4236,"neutral",F_WP)
		self:AddAnimationEvent("dance_willpower",4253,"smile",F_WP)
		self:AddAnimationEvent("dance_willpower",4288,"neutral",F_WP)
		self:AddAnimationEvent("dance_willpower",4298,"insane",F_WP)
		self:AddAnimationEvent("dance_willpower",4331,"open_shocked",F_WP)
		self:AddAnimationEvent("dance_willpower",4340,"neutral",F_WP)
		self:AddAnimationEvent("dance_willpower",4344,"insane",F_WP)
		self:AddAnimationEvent("dance_willpower",4435,"insane_smile",F_WP)
		self:AddAnimationEvent("dance_willpower",4445,"neutral",F_WP)
		self:AddAnimationEvent("dance_willpower",4511,"insane",F_WP)
		self:AddAnimationEvent("dance_willpower",4554,"insane_open",F_WP)
		self:AddAnimationEvent("dance_willpower",4600,"insane",F_WP)
		self:AddAnimationEvent("dance_willpower",4646,"neutral",F_WP)
		self:AddAnimationEvent("dance_willpower",4744,"insane",F_WP)
		self:AddAnimationEvent("dance_willpower",4824,"neutral",F_WP)
		self:AddAnimationEvent("dance_willpower",4928,"default",F_WP)

		local function Cinematic(frame,data,seq,maxFrames)
			self:AddCinematicEvent(seq,frame,data,maxFrames)
		end

		-- self:SetCinematicData()
		self:RandomizeCinematics("dance_willpower",F_WP)
		-- Cinematic(1,{f=90,r=-180,u=40,dist=0,speed=100},"dance_willpower",F_WP)
		-- Cinematic(4,{f=25,r=80,u=0,dist=0,speed=0.01},"dance_willpower",F_WP)
		-- Cinematic(100,{f=25,r=10,u=20,dist=0,speed=2},"dance_willpower",F_WP)
		-- Cinematic(175,{f=35,r=0,u=0,dist=0,speed=2},"dance_willpower",F_WP)
		-- Cinematic(230,{f=35,r=15,u=25,dist=0,speed=2},"dance_willpower",F_WP)
		-- Cinematic(325,{f=35,r=0,u=0,dist=0,speed=15},"dance_willpower",F_WP)
		-- Cinematic(410,{f=45,r=-50,u=-15,dist=0,speed=20},"dance_willpower",F_WP)
		-- Cinematic(570,{f=28,r=20,u=15,dist=0,speed=5},"dance_willpower",F_WP)
		-- Cinematic(710,{f=50,r=160,u=-40,dist=0,speed=100},"dance_willpower",F_WP)
		-- Cinematic(713,{f=50,r=-100,u=-40,dist=0,speed=0.0001},"dance_willpower",F_WP)
		-- Cinematic(800,{f=35,r=25,u=25,dist=0,speed=100},"dance_willpower",F_WP)
		-- Cinematic(815,{f=120,r=30,u=-40,dist=0,speed=1},"dance_willpower",F_WP)
		-- Cinematic(880,{f=45,r=0,u=-25,dist=0,speed=1},"dance_willpower",F_WP)
		-- Cinematic(955,{f=50,r=0,u=25,dist=0,speed=4},"dance_willpower",F_WP)
		-- Cinematic(1060,{f=35,r=-15,u=10,dist=0,speed=10},"dance_willpower",F_WP)
		-- Cinematic(1100,{f=15,r=5,u=10,dist=0,speed=10},"dance_willpower",F_WP)
		-- Cinematic(1120,{f=35,r=15,u=0,dist=0,speed=100},"dance_willpower",F_WP)
		-- Cinematic(1122,{f=25,r=-30,u=40,dist=0,speed=100},"dance_willpower",F_WP)
		-- Cinematic(1300,{f=40,r=-5,u=5,dist=0,speed=100},"dance_willpower",F_WP)
		-- Cinematic(1350,{f=150,r=-30,u=20,dist=0,speed=1},"dance_willpower",F_WP)
		-- Cinematic(1400,{f=30,r=60,u=-20,dist=0,speed=1},"dance_willpower",F_WP)
		-- Cinematic(1450,{f=25,r=-30,u=40,dist=0,speed=1},"dance_willpower",F_WP)
		-- Cinematic(1550,{f=80,r=15,u=0,dist=0,speed=1},"dance_willpower",F_WP)
		-- Cinematic(1630,{f=15,r=-8,u=0,dist=0,speed=1,bone="head"},"dance_willpower",F_WP)
		
		Cinematic(4700,{f=15,r=8,u=15,dist=0,speed=1},"dance_willpower",F_WP)
	end

	function ENT:SetFace(top,bottom,brow,eyes)
		eyes = eyes or 0
		self:SetBodygroup(BG_TOP,top)
		self:SetBodygroup(BG_BOTTOM,bottom)
		self:SetBodygroup(BG_BROW,brow)
		self:SetBodygroup(BG_EYES,eyes)
	end

	function ENT:OnThink()
		if math.random(1,100) == 1 && CurTime() > self.NextSpeakT then
			local snd = self:PlaySound(self.Insane && "idle_insane" or "idle")
			self.NextSpeakT = CurTime() +SoundDuration(snd[2]) +math.random(1,10)
		end
	end

	function ENT:HandleAnimationEvent(seq,event,frame)
		if event == "default" then
			local top,bottom,brow,eyes = 0,0,0,0
			self:SetFace(top,bottom,brow,eyes)
		end
		if event == "smile" then
			local top,bottom,brow,eyes = 0,1,2,0
			self:SetFace(top,bottom,brow,eyes)
		end
		if event == "open" then
			local top,bottom,brow,eyes = 2,3,2,0
			self:SetFace(top,bottom,brow,eyes)
		end
		if event == "neutral" then
			local top,bottom,brow,eyes = 0,2,0,0
			self:SetFace(top,bottom,brow,eyes)
		end
		if event == "insane_smile" then
			local top,bottom,brow,eyes = 2,6,1,0
			self:SetFace(top,bottom,brow,eyes)
			if frame == 2406 then
				self.Insane = true
				timer.Simple(1,function()
					if IsValid(self) then
						local snd = self:PlaySound(nil,nil,nil,"cpthazama/persona5_dance/akechi/24-0" .. math.random(73,74) .. ".wav")
						self.NextSpeakT = CurTime() +SoundDuration(snd[2]) +0.5
					end
				end)
			end
		end
		if event == "insane" then
			local top,bottom,brow,eyes = 0,7,1,0
			self:SetFace(top,bottom,brow,eyes)
		end
		if event == "open_shocked" then
			local top,bottom,brow,eyes = 2,4,0,0
			self:SetFace(top,bottom,brow,eyes)
		end
		if event == "angry" then
			local top,bottom,brow,eyes = 3,5,1,0
			self:SetFace(top,bottom,brow,eyes)
		end
	end
end
/*--------------------------------------------------
	*** Copyright (c) 2012-2021 by Cpt. Hazama, All rights reserved. ***
	No parts of this code or any of its contents may be reproduced, copied, modified or adapted,
	without the prior written consent of the author, unless otherwise indicated for persona-alone materials.
--------------------------------------------------*/