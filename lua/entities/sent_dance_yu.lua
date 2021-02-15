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
-- ENT.HeightOffset = 1
ENT.HeightOffset = 0.1
ENT.CollisionBounds = Vector(16,16,75)
ENT.SongStartDelay = 0.45
ENT.ModelScale = 0.42
ENT.ViewBone = "spine_01"
ENT.ViewBoneOffset = Vector(0,0,4)

ENT.Animations = {}
ENT.Animations["dance_specialist"] = {}
ENT.Animations["dance_specialist"][1] = {anim = "dance_specialist",next = false,endEarlyTime = 0}

ENT.SoundTracks = {
	[1] = {dance = "dance_specialist", song = "cpthazama/persona4_dance/music/c001.mp3", name = "Specialist -Remix-"}
}

ENT.PreviewThemes = {"cpthazama/persona4_dance/music/preview.wav"}

ENT.Outfits = {}
ENT.Outfits[1] = {Name = "Yasogami Winter Uniform", Model = "", Offset = 0.1, ReqSong = nil, ReqScore = 0}
ENT.Outfits[2] = {Name = "Yasogami Winter Uniform (Shades)", Model = "", Offset = 0.1, ReqSong = "Specialist -Remix-", ReqScore = 4200}

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
	function ENT:OnChangedOutfit(old,new,outfit)
		if outfit == "Yasogami Winter Uniform" then
			self:SetBodygroup(0,0)
		end
		if outfit == "Yasogami Winter Uniform (Shades)" then
			self:SetBodygroup(0,1)
		end
	end

	function ENT:OnInit()
		local function Cinematic(frame,data,seq,maxFrames)
			self:AddCinematicEvent(seq,frame,data,maxFrames)
		end

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

		self:RandomizeCinematics("dance_specialist",4167)
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

		self:AddFlexEvent("preview",12,{Name="smirk",Value=0.71139651147245,Speed=3.9556460394105},318)
		self:AddFlexEvent("preview",31,{Name="smirk",Value=0.80253839369798,Speed=4.6740437963604},318)
		self:AddFlexEvent("preview",76,{Name="smirk",Value=0.77615989128869,Speed=0.97009840065917},318)
		self:AddFlexEvent("preview",91,{Name="smirk",Value=0.44123345895845,Speed=0.54378684332205},318)
		self:AddFlexEvent("preview",113,{Name="smirk",Value=0.37610842572374,Speed=3.6182653050184},318)
		self:AddFlexEvent("preview",125,{Name="smirk",Value=0.40984988881277,Speed=0.99756694893298},318)
		self:AddFlexEvent("preview",156,{Name="smirk",Value=0.46680429349536,Speed=4.5140550418782},318)
		self:AddFlexEvent("preview",182,{Name="smirk",Value=0.14153651244129,Speed=1.8517302988492},318)
		self:AddFlexEvent("preview",266,{Name="smirk",Value=0.70302442439556,Speed=4.1384478105202},318)
		self:AddFlexEvent("preview",312,{Name="smirk",Value=0.95693534177754,Speed=4.7522732591046},318)
		self:AddFlexEvent("preview",12,{Name="eyesScold",Value=0.77721404346135,Speed=3.6165132615923},318)
		self:AddFlexEvent("preview",31,{Name="eyesScold",Value=0.89219972852395,Speed=2.4227516364094},318)
		self:AddFlexEvent("preview",76,{Name="eyesScold",Value=0.57774334449409,Speed=3.2407939808439},318)
		self:AddFlexEvent("preview",91,{Name="eyesScold",Value=0.20526867741596,Speed=0.56990240964073},318)
		self:AddFlexEvent("preview",113,{Name="eyesScold",Value=0.45222503320568,Speed=0.60893394959173},318)
		self:AddFlexEvent("preview",125,{Name="eyesScold",Value=0.95660158127135,Speed=2.9440838021925},318)
		self:AddFlexEvent("preview",156,{Name="eyesScold",Value=0.33244694012272,Speed=3.8642838352994},318)
		self:AddFlexEvent("preview",182,{Name="eyesScold",Value=0.96819181496774,Speed=1.9367482376334},318)
		self:AddFlexEvent("preview",266,{Name="eyesScold",Value=0.2470371283683,Speed=1.6065305126488},318)
		self:AddFlexEvent("preview",312,{Name="eyesScold",Value=0.59831287780035,Speed=1.767870800933},318)
		self:RandomizeExpressions({"eyesScold","smirk"},"dance_specialist",4167)
	end

	function ENT:HandleAnimationEvent(seq,event,frame)
		if event == "default" then
			self:ResetFlexes()
		end
		if event == "smile" then
			self:RemoveOldFlexes({"eyesScold","smirk"})
			self:SendFlexData("eyesScold",0.25,6)
			self:SendFlexData("smirk",1,6)
		end
	end
end
/*--------------------------------------------------
	*** Copyright (c) 2012-2021 by Cpt. Hazama, All rights reserved. ***
	No parts of this code or any of its contents may be reproduced, copied, modified or adapted,
	without the prior written consent of the author, unless otherwise indicated for persona-alone materials.
--------------------------------------------------*/