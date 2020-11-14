AddCSLuaFile()

ENT.Base 			= "prop_vj_animatable"
ENT.Type 			= "anim"
ENT.PrintName 		= ""
ENT.Author 			= "Cpt. Hazama"
ENT.Contact 		= "Atlus or some shit"
ENT.Purpose 		= ""
ENT.Instructions 	= "To fucking dance like there's no tomorrow"
ENT.Category		= "Persona - Dance"

ENT.Spawnable = false
ENT.AdminOnly = false

ENT.Model = "models/error.mdl"
ENT.HeightOffset = 1
ENT.CollisionBounds = Vector(16,16,75)
ENT.SongStartDelay = 0
ENT.SongStartAnimationDelay = 0
ENT.HasLamp = true
ENT.LampRGB = false
ENT.ViewMode = 2 -- 0 = None, 1 = Follow, 2 = Dance, Dance!
ENT.ViewBone = "Spine2"

ENT.Difficulty = 2 -- 1 = Easy, 2 = Normal, 3 = Hard, 4+ = You're stupid

ENT.Animations = {}
-- ENT.Animations["dance_lastsurprise"] = {}
-- ENT.Animations["dance_lastsurprise"][1] = {anim = "dance_lastsurprise",next = "dance_lastsurprise2",endEarlyTime = 0.09}
-- ENT.Animations["dance_lastsurprise"][2] = {anim = "dance_lastsurprise2",next = "dance_lastsurprise4",endEarlyTime = 0.05}
-- ENT.Animations["dance_lastsurprise"][3] = {anim = "dance_lastsurprise4",next = "dance_lastsurprise2",endEarlyTime = 0.08}
-- ENT.Animations["dance_lastsurprise"][4] = {anim = "dance_lastsurprise2",next = "dance_lastsurprise5",endEarlyTime = 0.05}
-- ENT.Animations["dance_lastsurprise"][5] = {anim = "dance_lastsurprise5",next = "dance_lastsurprise3",endEarlyTime = 0.075}
-- ENT.Animations["dance_lastsurprise"][6] = {anim = "dance_lastsurprise3",next = "dance_lastsurprise6",endEarlyTime = 0.2}
-- ENT.Animations["dance_lastsurprise"][7] = {anim = "dance_lastsurprise6",next = false,endEarlyTime = 0}

ENT.SoundTracks = {
	-- [1] = {dance = "dance_lastsurprise", song = "cpthazama/persona5_dance/music/h015.mp3"}
}

ENT.SongLength = {}
-- ENT.SongLength["dance_lastsurprise"] = 300

ENT.TrackNotes = {} -- Touch THIS one!

ENT.Notes = {} -- Don't touch this!
---------------------------------------------------------------------------------------------------------------------------------------------
function ENT:HSL(h,s,l)
	h = h %256
	if s == 0 then 
		return Color(l,l,l)
	end
	h, s, l = h /256 *6, s /255, l /255
	local c = (1 -math.abs(2 *l -1)) *s
	local x = (1 - math.abs(h %2 -1)) *c
	local m, r, g, b = (l -0.5 *c),0,0,0
	if h < 1 then 
		r,g,b = c,x,0
	elseif h < 2 then
		r,g,b = x,c,0
	elseif h < 3 then
		r,g,b = 0,c,x
	elseif h < 4 then
		r,g,b = 0,x,c
	elseif h < 5 then
		r,g,b = x,0,c
	else
		r,g,b = c,0,x
	end
	return Color(math.ceil((r +m) *256),math.ceil((g +m) *256),math.ceil((b +m) *256))
end
---------------------------------------------------------------------------------------------------------------------------------------------
if SERVER then
	function ENT:HandleKeys(ply) end

	function ENT:OnInit() end

	function ENT:HandleAnimationEvent(seq,event,frame) end

	function ENT:OnThink() end

	function ENT:OnPlayDance(seq,t) end

	function ENT:OnStartDance(seq,song,songName,dance) end

	util.AddNetworkString("Persona_Dance_Song")
	util.AddNetworkString("Persona_Dance_ModeStart")
end
---------------------------------------------------------------------------------------------------------------------------------------------
function ENT:SetupDataTables()
	self:NetworkVar("String",0,"Song")
	self:NetworkVar("String",1,"SongName")
end
---------------------------------------------------------------------------------------------------------------------------------------------
if (CLIENT) then
	function ENT:Draw()
		self:DrawModel()
	end

	function ENT:Initialize()
		self.DanceIndex = 0
		self.NextSpeakT = 0
		self:ClientInit()
	end

	function ENT:AddNote(seq,dir,timer,spawnTime)
		self.TrackNotes[seq] = self.TrackNotes[seq] or {}
		table.insert(self.TrackNotes[seq],{Dir = dir,Life = timer,Activate = spawnTime})
	end
	
	function ENT:ClientInit() end

	function ENT:ReadNotes(name)
		local f = file.Open("mns/" .. name .. ".bin","rb","GAME")
			if !f then return MsgN("Unable to read file!") end
			if f:QuickRead(3) == "MNS" then
				local header = f:ReadULong()
				f:Seek(0)
				print(f:Read(3))
			end
		f:Close()
	end

	function ENT:ApplyNotes(anim,len)
		if !self.TrackNotes[anim] then -- Random Notes
			local adjust = math.random(1,self.Difficulty)
			local clampMin = self.Difficulty == 1 && 1.25 or 0.75
			local clampMax = self.Difficulty == 1 && 3 or 5
			local subClamp = self.Difficulty == 1 && 0.95 or 0.5
			for i = 1,len *adjust do
				if i > 3 then
					if math.random(1,2) == 1 then
						for x = 1,math.random(1,self.Difficulty) do
							local dir = VJ_PICK({"w","a","s","d"})
							local ogTime = math.Rand(clampMin +0.5,clampMax) /adjust
							local time = math.Clamp(math.Rand(ogTime -subClamp,ogTime +subClamp),clampMin,clampMax)
							self:AddNote(anim,dir,time,i)
							if math.random(1,5) == 1 then
								dir = dir == "w" && "s" or dir == "s" && "w" or dir == "a" && "d" or dir == "d" && "a"
								self:AddNote(anim,dir,time,i)
							end
						end
					end
				end
			end
			-- return
		end
		local index = self.DanceIndex
		for _,v in pairs(self.TrackNotes[anim]) do
			timer.Simple(v.Activate,function()
				if IsValid(self) && self.DanceIndex == index then
					self:SpawnNote(v.Dir,v.Life)
				end
			end)
		end
	end

	function ENT:SpawnNote(dir,time)
		local ind = #self.Notes +1
		self.Notes[ind] = {}
		self.Notes[ind].Direction = dir
		self.Notes[ind].Timer = CurTime() +time
	end

	hook.Add("PlayerBindPress", "Persona_DanceViewScroll", function(ply,bind,pressed)
		local dancer = ply:GetNW2Entity("Persona_Dancer")
		if !IsValid(dancer) then return end
		local mode = ply:GetNW2Int("Persona_DanceMode")
		if mode == 0 then return end

		local usingController = GetConVarNumber("crosshair") == 1 -- Yeah idk
		local bUp = usingController && "lastinv" or "+forward"
		local bLeft = usingController && "+reload" or "+moveleft"
		local bRight = usingController && "+use" or "+moveright"
		local bDown = usingController && "+jump" or "+back"
		local bScratch = usingController && "+attack" or "+use"
		local w = bind == bUp && pressed
		local a = bind == bLeft && pressed
		local s = bind == bDown && pressed
		local d = bind == bRight && pressed
		local e = bind == bScratch && pressed

		if mode == 2 then
			ply.Persona_HitTime = ply.Persona_HitTime or 0
			-- ply:SetNW2Int("Persona_Dance_Score",ply:GetNW2Int("Persona_Dance_Score") or 0)
			ply.Persona_Dance_HitData = ply.Persona_Dance_HitData or {Perfect=0,Great=0,Good=0,Miss=0}
			ply.Persona_Dance_Score = ply.Persona_Dance_Score or 0
			ply.Persona_Dance_LastNoteT = ply.Persona_Dance_LastNoteT or 0
			ply.Persona_Dance_HitTimes = ply.Persona_Dance_HitTimes or 0
			ply.Persona_Dance_LastCheerT = ply.Persona_Dance_LastCheerT or 0
			ply.Persona_NoteDir = ply.Persona_NoteDir or "e"
			local function CheckHit(dir)
				local hNoMore = 0.03
				local hPerfect = 0.075
				local hGreat = 0.013
				local hGood = 0.2
				local possibleHits = {}
				-- Entity(1):ChatPrint(dir)
				for ind,note in pairs(dancer.Notes) do
					local rTime = note.Timer -CurTime()
					if note && note.Direction == dir then 
						if rTime <= 0.3 then
							table.insert(possibleHits,note)
						end
					end
				end
				if #possibleHits > 0 then
					for _,v in pairs(possibleHits) do
						local tDif = v.Timer -CurTime()
						local didHit = false
						local boost = CurTime() <= ply.Persona_Dance_LastCheerT
						local mul = boost && 1.5 or 1
						-- local old = ply:GetNW2Int("Persona_Dance_Score")
						local old = ply.Persona_Dance_Score
						if tDif <= hPerfect && tDif > hNoMore then -- Perfect
							ply:EmitSound("cpthazama/persona5_dance/clap_mega.wav")
							ply:ChatPrint("PERFECT!")
							didHit = true
							ply.Persona_Dance_HitData.Perfect = ply.Persona_Dance_HitData.Perfect +1
							-- ply:SetNW2Int("Persona_Dance_Score",ply:GetNW2Int("Persona_Dance_Score") +math.Round(100 *(1 -tDif)))
							ply.Persona_Dance_Score = math.Round(ply.Persona_Dance_Score +math.Round(100 *(1 -tDif)) *mul)
						elseif tDif > hPerfect && tDif <= hGreat then -- Great
							ply:EmitSound("cpthazama/persona5_dance/clap_cyl.wav")
							ply:ChatPrint("GREAT!")
							didHit = true
							ply.Persona_Dance_HitData.Great = ply.Persona_Dance_HitData.Great +1
							ply.Persona_Dance_Score = math.Round(ply.Persona_Dance_Score +math.Round(50 *(1 -tDif)) *mul)
							-- ply:SetNW2Int("Persona_Dance_Score",ply:GetNW2Int("Persona_Dance_Score") +math.Round(50 *(1 -tDif)))
						elseif tDif > hGreat && tDif <= hGood then -- Good
							ply:EmitSound("cpthazama/persona5_dance/clap.wav")
							ply:ChatPrint("GOOD!")
							didHit = true
							ply.Persona_Dance_HitData.Good = ply.Persona_Dance_HitData.Good +1
							ply.Persona_Dance_Score = math.Round(ply.Persona_Dance_Score +math.Round(25 *(1 -tDif)) *mul)
							-- ply:SetNW2Int("Persona_Dance_Score",ply:GetNW2Int("Persona_Dance_Score") +math.Round(25 *(1 -tDif)))
						else
							ply:EmitSound("cpthazama/persona5/misc/00103.wav")
							ply:ChatPrint("MISS!")
							ply.Persona_Dance_HitTimes = 0
							ply.Persona_Dance_LastNoteT = 0
							ply.Persona_Dance_HitData.Miss = ply.Persona_Dance_HitData.Miss +1
							if CurTime() > dancer.NextSpeakT && math.random(1,15) == 1 then
								local snd = dancer:PlaySound("failing")
								dancer.NextSpeakT = CurTime() +SoundDuration(snd[2]) +0.5
							end
						end
						if ply.Persona_Dance_LastNoteT < CurTime() then
							ply.Persona_Dance_HitTimes = 0
						end
						if didHit then
							if CurTime() > dancer.NextSpeakT && math.random(1,15) == 1 then
								local snd = dancer:PlaySound("winning")
								dancer.NextSpeakT = CurTime() +SoundDuration(snd[2]) +0.5
							end
							if ply.Persona_Dance_LastCheerT > CurTime() then
								ply.Persona_Dance_LastCheerT = math.Clamp(ply.Persona_Dance_LastCheerT +0.25,CurTime(),CurTime() +10)
							else
								ply.Persona_Dance_LastNoteT = CurTime() +5
								ply.Persona_Dance_HitTimes = ply.Persona_Dance_HitTimes +1
							end
							if ply.Persona_Dance_HitTimes >= 25 && ply.Persona_Dance_LastNoteT > CurTime() && CurTime() > ply.Persona_Dance_LastCheerT then
								ply.Persona_Dance_LastNoteT = 0
								ply.Persona_Dance_LastCheerT = CurTime() +10
								ply.Persona_Dance_HitTimes = 0
								ply:ChatPrint("SCORE BOOST FOR 10 SECONDS!")
								ply:EmitSound("cpthazama/persona4/ui_shufflebegin.wav")
								ply:EmitSound("cpthazama/persona5_dance/crowd.wav")
							end
						end
						-- ply:ChatPrint("Gained " .. tostring(ply:GetNW2Int("Persona_Dance_Score") -old) .. " points!")
						ply:ChatPrint("Gained " .. tostring(ply.Persona_Dance_Score -old) .. " points!")
					-- else
						-- ply:EmitSound("cpthazama/persona5/misc/00103.wav")
						-- ply:ChatPrint("MISS!")
					end
				end
				-- ply.Persona_HitTime = 0
			end
			if w then
				-- if ply.Persona_NoteDir != "w" then return end
				CheckHit("w")
			end
			if a then
				-- if ply.Persona_NoteDir != "a" then return end
				CheckHit("a")
			end
			if s then
				-- if ply.Persona_NoteDir != "s" then return end
				CheckHit("s")
			end
			if d then
				-- if ply.Persona_NoteDir != "d" then return end
				CheckHit("d")
			end
			if e then
				-- ply:ChatPrint("E")
				ply:EmitSound("cpthazama/persona5_dance/mix.wav")
			end
		end
		
		if (bind == "invprev" or bind == "invnext") then
			ply.Persona_DanceZoom = ply.Persona_DanceZoom or 90
			if bind == "invprev" then
				ply.Persona_DanceZoom = math.Clamp(ply.Persona_DanceZoom -5,dancer:BoundingRadius(),500)
			else
				ply.Persona_DanceZoom = math.Clamp(ply.Persona_DanceZoom +5,dancer:BoundingRadius(),500)
			end
		end
	end)

	local mat = Material("hud/persona/dance/star_b.png")
	hook.Add("HUDPaint","Persona_DanceViewMode_HUD",function(ply)
		local ply = LocalPlayer()
		local dancer = ply:GetNW2Entity("Persona_Dancer")
		if !IsValid(dancer) then return end
		local mode = ply:GetNW2Int("Persona_DanceMode")
		if mode != 2 then return end

		dancer.Persona_NextNoteT = dancer.Persona_NextNoteT or 0
		ply.Persona_NoteDir = ply.Persona_NoteDir or "w"
		ply.Persona_HitTimeTotal = ply.Persona_HitTimeTotal or 0
		ply.Persona_Dance_Score = ply.Persona_Dance_Score or 0
		ply.Persona_Dance_HitData = ply.Persona_Dance_HitData or {Perfect=0,Great=0,Good=0,Miss=0}
		-- ply:SetNW2Int("Persona_Dance_Score",ply:GetNW2Int("Persona_Dance_Score") or 0)
		-- ply:SetNW2Int("Persona_Dance_HighScore",ply:GetNW2Int("Persona_Dance_HighScore") or 0)
		-- if ply:GetNW2Int("Persona_Dance_Score") > ply:GetNW2Int("Persona_Dance_HighScore") then
			-- ply:SetNW2Int("Persona_Dance_HighScore",ply:GetNW2Int("Persona_Dance_Score"))
		-- end
		
		local function DrawNote(note)
			local nDir = note.Direction
			local nTime = note.Timer -CurTime()
			local alpha = 220
			local col = Color(255,255,255,alpha)
			local dA = 2
			local scrWData = ScrW() /dA
			local scrHData = ScrH() /dA
			if nDir == "w" then
				col = Color(255,240,0,alpha)
				scrWData = ScrW() /dA
				scrHData = ScrH() /dA -nTime *ScrH() +50
			elseif nDir == "a" then
				col = Color(0,120,255,alpha)
				scrWData = ScrW() /dA -nTime *ScrH() +50
				scrHData = ScrH() /dA
			elseif nDir == "s" then
				col = Color(0,255,157,alpha)
				scrWData = ScrW() /dA
				scrHData = ScrH() /dA +nTime *ScrH() -50
			elseif nDir == "d" then
				col = Color(255,90,90,alpha)
				scrWData = ScrW() /dA +nTime *ScrW() -50
				scrHData = ScrH() /dA
			end
			local scale = 50
			surface.SetMaterial(mat)
			surface.SetDrawColor(col.r,col.g,col.b,col.a)
			surface.DrawTexturedRect(scrWData -25,scrHData -25,scale,scale)
			-- Entity(1):ChatPrint("DRAWING")
		end

		local boost = ply.Persona_Dance_LastCheerT > CurTime()
		local mBoxCol = Color(0,255,255,150)
		local sBoxHeight = boost && 350 or 290 -- 60 dif | 130 | 160 dif

		local hT = ply.Persona_Dance_HitData
		local hP = hT.Perfect
		local hGr = hT.Great
		local hG = hT.Good
		local hM = hT.Miss

		local iDif = dancer.Difficulty
		local dif = iDif == 1 && "Easy" or iDif == 2 && "Normal" or iDif == 3 && "Hard" or iDif == 4 && "Crazy" or "Insane"
		draw.RoundedBox(8,ScrW() -360,ScrH() -770,350,sBoxHeight,Color(0,0,0,230)) // 200
		draw.SimpleText(dancer:GetSongName(),"Persona",ScrW() -350,ScrH() -700 -60,Color(255,0,0))
		draw.SimpleText("Difficulty - " .. dif,"Persona",ScrW() -350,ScrH() -660 -60,Color(255,0,0))
		draw.SimpleText("Score - " .. ply.Persona_Dance_Score,"Persona",ScrW() -350,ScrH() -620 -60,Color(255,0,0))
		draw.SimpleText("Perfects - " .. hP,"Persona",ScrW() -350,ScrH() -580 -60,Color(255,0,0))
		draw.SimpleText("Greats - " .. hGr,"Persona",ScrW() -350,ScrH() -540 -60,Color(255,0,0))
		draw.SimpleText("Goods - " .. hG,"Persona",ScrW() -350,ScrH() -500 -60,Color(255,0,0))
		draw.SimpleText("Misses - " .. hM,"Persona",ScrW() -350,ScrH() -460 -60,Color(255,0,0))
		-- draw.SimpleText("Score - " .. ply:GetNW2Int("Persona_Dance_Score"),"Persona",ScrW() -350,ScrH() -660 -60,Color(255,0,0))
		-- draw.SimpleText("High Score - " .. ply:GetNW2Int("Persona_Dance_HighScore"),"Persona",ScrW() -350,ScrH() -620 -60,Color(255,0,0))


		if boost then
			mBoxCol = dancer:HSL((RealTime() *250 -(0 *15)),128,128)
			local r = ply.Persona_Dance_LastCheerT -CurTime()
			-- local r = 10
			draw.RoundedBox(8,ScrW() -335, ScrH() -480,30 *r,45,mBoxCol)
		end
		draw.RoundedBox(8,ScrW() /2 -30, ScrH() /2 -30,60,60,mBoxCol)

		for ind,note in pairs(dancer.Notes) do
			if note then
				if note.Timer < CurTime() then
					-- Entity(1):ChatPrint("REMOVED")
					table.remove(dancer.Notes,ind)
				else
					DrawNote(note)
				end
			end
		end
	end)

	local P_LerpVec = Vector(0,0,0)
	local P_LerpAng = Angle(0,0,0)
	hook.Add("CalcView","Persona_DanceViewMode",function(ply,pos,angles,fov)
		local dancer = ply:GetNW2Entity("Persona_Dancer")
		local danceMode = ply:GetNW2Int("Persona_DanceMode")
		local danceBone = ply:GetNW2String("Persona_DanceBone")
		local enabled = IsValid(dancer) && danceMode != 0 && danceBone
		if enabled then
			if IsValid(ply:GetViewEntity()) && ply:GetViewEntity():GetClass() == "gmod_cameraprop" then
				return
			end
			local sPos,sAng = dancer:GetBonePosition(dancer:LookupBone(danceBone))
			local offsetVec = Vector(0,0,0)
			local dist = ply.Persona_DanceZoom or 90
			local offset = angles:Forward() *offsetVec.y +angles:Right() *offsetVec.x +angles:Up() *offsetVec.z
			local tr = util.TraceHull({
				start = sPos,
				endpos = sPos +angles:Forward() *-math.max(dist,dancer:BoundingRadius()) +offset,
				mask = MASK_SHOT,
				filter = player.GetAll(),
				mins = Vector(-8,-8,-8),
				maxs = Vector(8,8,8)
			})
			pos = tr.HitPos +tr.HitNormal *5
			P_LerpVec = LerpVector(FrameTime() *15,P_LerpVec,pos)
			P_LerpAng = LerpAngle(FrameTime() *15,P_LerpAng,(sPos -pos):Angle())
			-- P_LerpAng = LerpAngle(FrameTime() *15,P_LerpAng,ply:EyeAngles())

			local view = {}
			view.origin = P_LerpVec
			view.angles = P_LerpAng
			view.fov = fov
			return view
		end
	end)

	net.Receive("Persona_Dance_Song",function(len)
		local dir = net.ReadString()
		local ply = net.ReadEntity()
		local me = net.ReadEntity()
		local seq = net.ReadString()
		local length = net.ReadInt(12)

		if !IsValid(me) then MsgN("Thanks GMod, very cool") end
		me.Difficulty = GetConVarNumber("vj_persona_dancedifficulty")
		me.DanceIndex = (me.DanceIndex or 0) +1
		if !me.ApplyNotes then ply:ChatPrint("A weird problem occured...respawn the Dancer and it will be fixed"); me:Remove() return end
		me:ApplyNotes(seq,(seq && me.SongLength && me.SongLength[seq]) or length -4)
		me.Persona_NextNoteT = CurTime() +3

		ply.Persona_Dance_LastNoteT = 0
		ply.Persona_Dance_LastCheerT = 0
		ply.Persona_Dance_HitTimes = 0
		ply.Persona_Dance_HitData = {Perfect=0,Great=0,Good=0,Miss=0}
		if ply.VJ_Persona_Dance_Theme && ply.VJ_Persona_Dance_ThemeDir == dir then ply.VJ_Persona_Dance_Theme:Stop() end
		timer.Simple(me.SongStartDelay,function()
			if IsValid(ply) && IsValid(me) then
				ply.VJ_Persona_Dance_ThemeDir = dir
				ply.VJ_Persona_Dance_Theme = CreateSound(ply,dir)
				ply.VJ_Persona_Dance_Theme:SetSoundLevel(0)
				ply.VJ_Persona_Dance_Theme:Play()
				ply.VJ_Persona_Dance_Theme:ChangeVolume(GetConVarNumber("vj_persona_dancevol") *0.01) // 60
				ply.VJ_Persona_Dance_Theme:ChangePitch(100 *GetConVarNumber("host_timescale"))
			end
		end)
	end)

	net.Receive("Persona_Dance_ModeStart",function(len)
		local ply = net.ReadEntity()
		local me = net.ReadEntity()

		-- ply:SetNW2Int("Persona_Dance_Score",0)
		ply.Persona_Dance_Score = 0
		ply.Persona_Dance_LastNoteT = 0
		ply.Persona_Dance_HitData = {Perfect=0,Great=0,Good=0,Miss=0}
		ply.Persona_Dance_StartSound = CreateSound(ply,"cpthazama/persona5_dance/crowd.wav")
		ply.Persona_Dance_StartSound:SetSoundLevel(0)
		ply.Persona_Dance_StartSound:Play()
		ply.Persona_Dance_StartSound:ChangeVolume(GetConVarNumber("vj_persona_dancevol") *0.01)
		ply:ChatPrint("'Dance, Dance!' mode is very WIP right now!")
	end)

	function ENT:Think()
		local ply = LocalPlayer()
		if ply.VJ_Persona_Dance_Theme && ply.VJ_Persona_Dance_Theme:IsPlaying() then
			ply.VJ_Persona_Dance_Theme:ChangeVolume(GetConVarNumber("vj_persona_dancevol") *0.01)
			ply.VJ_Persona_Dance_Theme:ChangePitch(100 *GetConVarNumber("host_timescale"))
		end
	end

	function ENT:OnRemove()
		local ply = LocalPlayer()
		local song = self:GetSongName()

		-- local oldData = PXP.GetDanceData(ply,song)
		-- local s = ply:GetNW2Int("Persona_Dance_Score")
		-- local hs = ply:GetNW2Int("Persona_Dance_HighScore")
		-- if hs && hs > oldData then
			-- PXP.SaveDanceData(ply,song,s)
		-- end
		-- ply:SetNW2Int("Persona_Dance_Score",0)
		-- ply:SetNW2Int("Persona_Dance_HighScore",0)

		if ply.VJ_Persona_Dance_Theme && ply.VJ_Persona_Dance_ThemeDir == self:GetSong() then
			local cont = true
			for _,v in pairs(ents.FindByClass("sent_dance_*")) do
				if v:GetSong() != nil && v != self && v:GetSong() == self:GetSong() then
					cont = false
				end
			end
			if cont then
				ply.VJ_Persona_Dance_Theme:FadeOut(2)
			end
		end
	end
end
---------------------------------------------------------------------------------------------------------------------------------------------
function ENT:SetAnimationRate(rate)
	self:SetPlaybackRate(rate)
	self.DefaultPlaybackRate = rate
end
---------------------------------------------------------------------------------------------------------------------------------------------
function ENT:PlayAnimation(seq,rate,cycle,index,name,noReset)
	local sT = index == 1 && self.SongStartAnimationDelay or 0
	local t = self:GetSequenceDuration(self,seq)
	timer.Simple(sT,function()
		if IsValid(self) then
			self:ResetSequence(seq)
			self:SetAnimationRate(rate)
			self:SetCycle(cycle or 0)
			local dance = nil
			local song = nil
			local songName = nil
			for _,v in pairs(self.SoundTracks) do
				if v.dance == seq then
					dance = v.dance
					song = v.song
					songName = v.name
					break
				end
			end
			if !noReset then
				for _,v in pairs(player.GetAll()) do
					net.Start("Persona_Dance_Song")
						net.WriteString(song)
						net.WriteEntity(v)
						net.WriteEntity(self)
						net.WriteString(dance)
						net.WriteInt(self:GetSequenceDuration(self,dance),12)
					net.Broadcast()
				end
				self:SetSong(song)
				self.SongName = songName
				self:SetSongName(songName)
				self:OnStartDance(seq,song,songName,dance)
			end
			self:OnPlayDance(seq,t)
			local dur = self:GetSequenceDuration(self,seq)
			local equ = dur -(dur *GetConVarNumber("host_timescale"))
			if dur *GetConVarNumber("host_timescale") > dur then
				equ = (dur *GetConVarNumber("host_timescale")) -dur
			end
			t = math.Clamp(dur -equ,0,999999999)
			if self.Index == 0 then
				self.Index = 1
			end
			-- Entity(1):ChatPrint("------------------------------------")
			-- Entity(1):ChatPrint("Current Index - " .. self.Index)
			-- Entity(1):ChatPrint("Now Playing - " .. seq)
			if self.Animations[name][index].next then
				local offset = self.Animations[name][index].endEarlyTime
				timer.Simple(t -offset,function()
					if IsValid(self) then
						local anim = self.Animations[name][index].next
						self.Index = self.Index +1
						-- Entity(1):ChatPrint("Was Playing - " .. seq .. " | Now Playing - " .. anim .. " | Next Play - " .. (self.Animations[name][index +1] != nil && self.Animations[name][index +1].next) or " N/A")
						-- Entity(1):ChatPrint("------------------------------------")
						-- Entity(1):ChatPrint("Current Index - " .. self.Index)
						-- Entity(1):ChatPrint("Now Playing - " .. anim)
						-- Entity(1):ChatPrint("Next To Playing - " .. (self.Animations[name][index +1] != nil && self.Animations[name][index +1].next) or " N/A")
						-- Entity(1):ChatPrint("Delay For Next - " .. tostring(self.Animations[name][index +1].endEarlyTime))
						local t = self:PlayAnimation(anim,1,0,self.Index,name,true)
						self.NextDanceT = CurTime() +t +0.1
					end
				end)
			else
				self.Index = 0
			end
			return t
		end
	end)
	return t
end
---------------------------------------------------------------------------------------------------------------------------------------------
function ENT:GetSequenceDuration(argent,actname)
	if isnumber(actname) then
		return argent:SequenceDuration(argent:SelectWeightedSequence(actname))
	elseif isstring(actname) then
		return argent:SequenceDuration(argent:LookupSequence(actname))
	end
	return 0
end
---------------------------------------------------------------------------------------------------------------------------------------------
function ENT:PlaySound(name,vol,pit,notTable)
	return VJ_PlaySound(self,(self.Sounds && self.Sounds[name] && VJ_PICK(self.Sounds[name])) or notTable,vol or 75,pit or 100)
end
------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------
if !(SERVER) then return end
---------------------------------------------------------------------------------------------------------------------------------------------
function ENT:ChangeFace(t,id,sID)
	local t = t or 0
	local id = id or 0
	local sID = sID or 1
	timer.Simple(t,function()
		if IsValid(self) then
			self:SetBodygroup(sID,id)
		end
	end)
end
---------------------------------------------------------------------------------------------------------------------------------------------
function ENT:PlaySound(name,vol,pit,notTable)
	return VJ_PlaySound(self,(self.Sounds && self.Sounds[name] && VJ_PICK(self.Sounds[name])) or notTable,vol or 75,pit or 100)
end
---------------------------------------------------------------------------------------------------------------------------------------------
function ENT:Initialize()
	self:SetModel(self.Model)
	self:SetSolid(SOLID_OBB)
	self:SetCollisionGroup(COLLISION_GROUP_IN_VEHICLE)
	local col = self.CollisionBounds
	self:SetCollisionBounds(Vector(col.x,col.y,col.z),Vector(-col.x,-col.y,0))

	self.DefaultPlaybackRate = 1
	self.Index = 0
	self.DanceIndex = 0
	self.NextDanceT = CurTime()
	self.NextSpeakT = 0

	self.AnimationEvents = {}

	timer.Simple(0,function()
		if IsValid(self) then
			if IsValid(self:GetCreator()) && self:GetCreator():IsPlayer() then
				self:SetPos(self:GetPos() +Vector(0,0,self.HeightOffset))
				self.ViewMode = GetConVarNumber("vj_persona_dancemode")
				if self.ViewMode != 0 then
					self:GetCreator():SetNW2Entity("Persona_Dancer",self)
					self:GetCreator():SetNW2Int("Persona_DanceMode",self.ViewMode)
					self:GetCreator():SetNW2String("Persona_DanceBone",self.ViewBone)
					self.Creator = self:GetCreator()
					self.Creator:Spectate(OBS_MODE_CHASE)
					self.Creator:SpectateEntity(self)
					self.Creator:SetNoTarget(true)
					self.Creator:DrawShadow(false)
					self.Creator:SetNoDraw(true)
					self.Creator:SetMoveType(MOVETYPE_OBSERVER)
					self.Creator:DrawViewModel(false)
					self.Creator:DrawWorldModel(false)
					local weps = {}
					for _, v in pairs(self.Creator:GetWeapons()) do
						weps[#weps+1] = v:GetClass()
					end
					self.Data_Creator = {
						[1] = self.Creator:Health(),
						[2] =self.Creator:Armor(),
						[3] = weps,
						[4] = (IsValid(self.Creator:GetActiveWeapon()) and self.Creator:GetActiveWeapon():GetClass()) or "",
					}
					self.Creator:StripWeapons()
				end
				self:OnInit()
			end
		end
	end)
end
---------------------------------------------------------------------------------------------------------------------------------------------
function ENT:GetEventCoolDown(seq,frame)
	if self.EventCoolDown[seq] then
		return self.EventCoolDown[seq][frame][1]
	end
end
---------------------------------------------------------------------------------------------------------------------------------------------
function ENT:AddEventCoolDown(seq,frame)
	if self.EventCoolDown[seq] then
		self.EventCoolDown[seq][frame][1] = CurTime() +0.1
	end
end
---------------------------------------------------------------------------------------------------------------------------------------------
function ENT:AddAnimationEvent(seq,frame,eventName,frameCount)
	local seq = self:LookupSequence(seq)
	self.AnimationEvents = self.AnimationEvents or {}
	self.AnimationEvents[seq] = self.AnimationEvents[seq] or {}
	self.AnimationEvents[seq][frame] = self.AnimationEvents[seq][frame] or {}
	table.insert(self.AnimationEvents[seq][frame],eventName)
	
	self.EventCoolDown = self.EventCoolDown or {}
	self.EventCoolDown[seq] = self.EventCoolDown[seq] or {}
	self.EventCoolDown[seq][frame] = self.EventCoolDown[seq][frame] or {}
	table.insert(self.EventCoolDown[seq][frame],CurTime())

	if frameCount then
		self.RegisteredSequences = self.RegisteredSequences or {}
		self.RegisteredSequences[seq] = frameCount
	end
end
---------------------------------------------------------------------------------------------------------------------------------------------
function ENT:StartLamp()
	if !self.HasLamp then return end
	SafeRemoveEntity(self.Lamp)

	local tr = util.TraceHull({
		start = self:GetPos() +self:OBBCenter(),
		endpos = self:GetPos() +self:GetForward() *200 +Vector(0,0,self:OBBMaxs().z *3.5),
		mask = MASK_SHOT,
		filter = player.GetAll(),
		mins = Vector(-8,-8,-8),
		maxs = Vector(8,8,8)
	})
	local trPos = tr.HitPos +tr.HitNormal *5

	self.Lamp = ents.Create("gmod_lamp")
	self.Lamp:SetModel("models/maxofs2d/lamp_projector.mdl")
	self.Lamp:SetPos(trPos)
	self.Lamp:SetAngles((self:GetPos() -self.Lamp:GetPos()):Angle())
	self.Lamp:Spawn()
	self.Lamp:SetMoveType(MOVETYPE_NONE)
	self.Lamp:SetSolid(SOLID_BBOX)
	self:DeleteOnRemove(self.Lamp)
	self.Lamp:SetOn(true)
	self.Lamp:SetLightFOV(40)
	self.Lamp:SetDistance(self.Lamp:GetPos():Distance(self:GetPos()) *2)
	self.Lamp:SetBrightness(self.Lamp:GetPos():Distance(self:GetPos()) *0.01)
	-- self.Lamp:SetFashlightTexture("sprites/lamphalo")
	-- self.Lamp:SetFashlightTexture("engine/lightsprite")
	self.Lamp:SetColor(Color(255,255,255))
	if IsValid(self.Lamp.flashlight) then
		self.Lamp.flashlight:Input("SpotlightTexture",NULL,NULL,"effects/flashlight/soft")
		-- self.Lamp.flashlight:SetColor(Color(255,255,255))
	end
	self.Lamp:SetCollisionGroup(COLLISION_GROUP_IN_VEHICLE)
	local phys = self:GetPhysicsObject()
	if IsValid(phys) then phys:Sleep() end
end
---------------------------------------------------------------------------------------------------------------------------------------------
function ENT:Think()
	self:HandleKeys(IsValid(self.Creator) && self.Creator)
	if CurTime() > self.NextDanceT then
		local song = VJ_PICK(self.SoundTracks)
		-- PrintTable(self.Animations[song.dance])
		local anim = self.Animations[song.dance][1].anim
		local songName = song.name
		local delay = self.SongStartAnimationDelay
		self:StartLamp()
		local t = self:PlayAnimation(anim,1,0,1,anim) +delay +0.1
		if IsValid(self.Creator) && self.ViewMode == 2 then
			local ply = self.Creator
			ply:SetNW2Int("Persona_Dance_Score",0)
			-- local oldData = PXP.GetDanceData(ply,songName)
			-- local s = ply:GetNW2Int("Persona_Dance_Score")
			-- local hs = ply:GetNW2Int("Persona_Dance_HighScore")
			-- if hs && hs > oldData then
				-- PXP.SaveDanceData(ply,song,hs)
			-- end
			-- ply:SetNW2Int("Persona_Dance_Score",0)
			-- ply:SetNW2Int("Persona_Dance_HighScore",0)

			net.Start("Persona_Dance_ModeStart")
				net.WriteEntity(self.Creator)
				net.WriteEntity(self)
			net.Broadcast()
		end
		self.NextDanceT = CurTime() +t
	end
	if IsValid(self.Lamp) then
		self.Lamp:SetAngles((self:GetBonePosition(1) -self.Lamp:GetPos()):Angle())
		local flashlight = self.Lamp.flashlight
		if IsValid(flashlight) then
			if self.LampRGB then
				local col = self:HSL((RealTime() *70 -(0 *8)),128,128)
				flashlight:Input("SpotlightTexture",NULL,NULL,"effects/flashlight/soft")
				flashlight:Input("LightColor",NULL,NULL,Format("%i %i %i 255",col.r,col.g,col.b))
				self.Lamp:SetColor(col)
			else
				flashlight:Input("SpotlightTexture",NULL,NULL,"effects/flashlight/soft")
				flashlight:Input("LightColor",NULL,NULL,Format("%i %i %i 255",255,255,255))
				self.Lamp:SetColor(Color(255,255,255))
			end
		end
	end
	if self:GetPlaybackRate() *GetConVarNumber("host_timescale") != self:GetPlaybackRate() then
		self:SetPlaybackRate(self.DefaultPlaybackRate *GetConVarNumber("host_timescale"))
	end
	local seq = self:GetSequence()
	if self.AnimationEvents[seq] && self.RegisteredSequences[seq] then
		if self.LastSequence != seq then
			self.LastSequence = seq
			self.LastFrame = -1
		end
		local NextFrame = math.floor(self:GetCycle() *(self:GetPlaybackRate() *self.RegisteredSequences[seq]))
		self.LastFrame = NextFrame
		if self.AnimationEvents[seq][self.LastFrame] then
			for _,v in pairs(self.AnimationEvents[seq][self.LastFrame]) do
				if CurTime() > self:GetEventCoolDown(seq,self.LastFrame) then
					self:HandleAnimationEvent(seq,v,self.LastFrame)
					self:AddEventCoolDown(seq,self.LastFrame)
				end
			end
		end
	end
	self:OnThink()
	self:NextThink(CurTime())
	return true
end
---------------------------------------------------------------------------------------------------------------------------------------------
function ENT:OnRemove()
	SafeRemoveEntity(self.Lamp)
	if IsValid(self.Creator) then
		self.Creator:SetNW2Entity("Persona_Dancer",NULL)
		self.Creator:SetNW2Int("Persona_DanceMode",0)
		self.Creator:SetNW2String("Persona_DanceBone",nil)
		self.Creator:UnSpectate()
		self.Creator:KillSilent()
		self.Creator:Spawn()
		self.Creator:SetHealth(self.Data_Creator[1])
		self.Creator:SetArmor(self.Data_Creator[2])
		for _, v in pairs(self.Data_Creator[3]) do
			self.Creator:Give(v)
		end
		self.Creator:SelectWeapon(self.Data_Creator[4])
		self.Creator:SetPos(self:GetPos() +self:OBBMaxs() +Vector(0,0,20))
		self.Creator:SetNoDraw(false)
		self.Creator:DrawShadow(true)
		self.Creator:SetNoTarget(false)
		self.Creator:DrawViewModel(true)
		self.Creator:DrawWorldModel(true)
	end
	self.Creator = NULL
end
/*--------------------------------------------------
	*** Copyright (c) 2012-2021 by Cpt. Hazama, All rights reserved. ***
	No parts of this code or any of its contents may be reproduced, copied, modified or adapted,
	without the prior written consent of the author, unless otherwise indicated for persona-alone materials.
--------------------------------------------------*/