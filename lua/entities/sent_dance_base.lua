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
ENT.ModelScale = 1
ENT.HasLamp = true
ENT.LampRGB = false
ENT.ViewMode = 2 -- 0 = None, 1 = Follow, 2 = Dance, Dance!
ENT.ViewBone = "Spine2"
ENT.WaitForNextSongToStartTime = 0.01

ENT.Difficulty = 2 -- 1 = Easy, 2 = Normal, 3 = Hard, 4+ = You're stupid

ENT.PreviewThemes = {} -- Song that plays during song select/customization. The sounds must be looped using Waveosaur or another program. If left empty, it will play the default song (P3D Theme)

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

ENT.Outfits = {}
-- ENT.Outfits[1] = {Name = "Winter Uniform", Model = "", ReqSong = nil, ReqScore = 0} -- Model = self.Model +whatever is in here, ReqSong must be the song name, not the id/seq name

ENT.SongLength = {}
-- ENT.SongLength["dance_lastsurprise"] = 300

ENT.TrackNotes = {} -- Touch THIS one!

ENT.Notes = {} -- Don't touch this!

FEVERCOMBOCOST = 25
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

	function ENT:OnCinematicEvent(seq,event,frame) end

	function ENT:OnThink() end

	function ENT:OnChangedOutfit(old,new,outfit) end

	function ENT:OnPlayPreview(ply) end

	function ENT:OnPlayDance(seq,t) end

	function ENT:OnStartDance(seq,song,songName,dance) end

	util.AddNetworkString("Persona_Dance_Song")
	util.AddNetworkString("Persona_Dance_PreviewSong")
	util.AddNetworkString("Persona_Dance_UpdateOutfit")
	util.AddNetworkString("Persona_Dance_UpdateSong")
	util.AddNetworkString("Persona_Dance_SendScore")
	util.AddNetworkString("Persona_Dance_SongEnd")
	util.AddNetworkString("Persona_Dance_ModeStart")
	util.AddNetworkString("Persona_Dance_ChangeFlex")
end
---------------------------------------------------------------------------------------------------------------------------------------------
function ENT:SetupDataTables()
	self:NetworkVar("String",0,"Song")
	self:NetworkVar("String",1,"SongName")
	self:NetworkVar("String",2,"SelectedSong")
	self:NetworkVar("Float",1,"ViewMode")
	self:NetworkVar("Bool",0,"ShowSongMenu")
	self:NetworkVar("Bool",1,"ShowCostumeMenu")

	if CLIENT then
		self.ViewMode = GetConVarNumber("vj_persona_dancemode")
		self:SetViewMode(GetConVarNumber("vj_persona_dancemode"))
	end
end
---------------------------------------------------------------------------------------------------------------------------------------------
function ENT:GetAnimation()
	return self:GetSequenceName(self:GetSequence())
end
---------------------------------------------------------------------------------------------------------------------------------------------
if (CLIENT) then
	ENT.NextBlink = 0
	ENT.BlinkTime = 0
	ENT.CurBlink = 0
	ENT.Flexes = {}

	function ENT:OnChangeFlex(name,oldVal,val) end

	function ENT:ChangeFlex(name,val,speed) -- Translation value
		local canContinue = true
		for _,v in pairs(self.Flexes) do
			if v.Name == name then
				canContinue = false
				v.Target = val
				v.Speed = speed
				break
			end
		end
		if canContinue then
			table.insert(self.Flexes,{Name=name,Target=val,Speed=speed})
		end
	end

	function ENT:SetFlex(name,val) -- Immediate value
		local nameID = self:GetFlexIDByName(name)
		if nameID then
			local oldVal = self:GetFlexWeight(nameID)
			val = math.Clamp(val,0,1)
			self:SetFlexWeight(nameID,val)
			self:OnChangeFlex(name,oldVal,val)
		end
	end

	function ENT:Draw()
		self:DrawModel()
		self:OnDraw()
		
		for ind,flex in ipairs(self.Flexes) do
			if flex then
				local id = self:GetFlexIDByName(flex.Name)
				local oldVal = self:GetFlexWeight(id)
				local target = flex.Target
				-- if oldVal != flex.Target then
				-- if (target > oldVal && oldVal < target) or (target < oldVal && oldVal > target) then
				if (math.abs(target -oldVal) > 0.05) then
					-- Entity(1):ChatPrint("Changing " .. flex.Name .. " from " .. oldVal .. " to " .. flex.Target)
					self:SetFlex(flex.Name,Lerp(FrameTime() *flex.Speed,oldVal,flex.Target))
				else
					table.remove(self.Flexes,ind)
				end
			end
		end
		
        if CurTime() >= (self.NextBlink or 0) then
            self.BlinkTime = CurTime() +0.175
            self.NextBlink = CurTime() +math.Rand(2.5,7.5)
        end

        local blink = CurTime() < (self.BlinkTime or 0)
        local baseBlink = 0
    
        if blink then
            self.CurBlink = Lerp(FrameTime() *10,self.CurBlink or baseBlink,1)
            self:SetFlex("blink",self.CurBlink)
        elseif self.CurBlink && self.CurBlink > baseBlink +0.01 then
            self.CurBlink = Lerp(FrameTime() *5,self.CurBlink or 0,baseBlink)
            self:SetFlex("blink",self.CurBlink)
        else
            self.CurBlink = nil
        end
	end

	function ENT:Initialize()
		self.DanceIndex = 0
		self.NextSpeakT = 0
		self:ClientInit()
		
		self.ViewMode = GetConVarNumber("vj_persona_dancemode")
		self:SetViewMode(GetConVarNumber("vj_persona_dancemode"))
	end

	function ENT:AddNote(seq,dir,timer,spawnTime)
		self.TrackNotes[seq] = self.TrackNotes[seq] or {}
		table.insert(self.TrackNotes[seq],{Dir = dir,Life = timer,Activate = spawnTime})
	end
	
	function ENT:CustomCalcView(ply,pos,angles,fov,danceBone) end
	
	function ENT:OnDraw() end
	
	function ENT:ClientInit() end
	
	function ENT:ClientThink() end
	
	function ENT:ClientRemove() end

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
							-- local dir = VJ_PICK({"w","a","d","n4","n8","n6"})
							local dir = VJ_PICK({"s","a","d","n4","n8","n6"})
							local ogTime = math.Rand(clampMin +0.5,clampMax) /adjust
							local time = math.Clamp(math.Rand(ogTime -subClamp,ogTime +subClamp),clampMin,clampMax)
							time = 1
							self:AddNote(anim,dir,time,i)
							if math.random(1,8) == 1 then
								-- dir = VJ_PICK({"w","a","d","n4","n8","n6"})
								dir = VJ_PICK({"s","a","d","n4","n8","n6"})
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
				if IsValid(self) && self.DanceIndex == index && self:GetSelectedSong() != "false" then
					self:SpawnNote(v.Dir,v.Life)
				end
			end)
		end
	end

	function ENT:SpawnNote(dir,time)
		local ind = #self.Notes +1
		self.Notes[ind] = {}
		self.Notes[ind].Hit = false
		self.Notes[ind].HitType = -1
		self.Notes[ind].Direction = dir
		self.Notes[ind].Timer = CurTime() +time
	end

	function ENT:OnNoteHit(ply,ind,note,type)
		note.Hit = true
		note.HitType = type
		if type == 0 then
			ply.Persona_Dance_HitData.Miss = ply.Persona_Dance_HitData.Miss +1
		end
		
		local mats = {
			[0] = "hud/persona/dance/fx_miss.png",
			[1] = "hud/persona/dance/fx_perfect.png",
			[2] = "hud/persona/dance/fx_great.png",
			[3] = "hud/persona/dance/fx_good.png",
		}
		
		self.Persona_HitFX = self.Persona_HitFX or {}
		table.insert(self.Persona_HitFX,{Material=mats[type],PosW=note.LastPosW[1],PosH=note.LastPosH[1],Timer=CurTime() +0.35})
	end

	function ENT:CheckNoteHit(dir)
		local hNoMore = 75 -- Cut-off, at this point you missed
		local hPerfect = 170 -- Dead on
		local hGreat = 210 -- Almost on the spot
		local hGood = 300 -- Meh
		local didHit = false
		for ind,note in pairs(self.Notes) do
			-- local tDif = note.Timer -CurTime()
			local nDist = note.RemainingDist
			if note && note.Direction == dir then
				if didHit then return end
				-- if tDif <= 0.3 && !note.Hit then
				if note.CanBeHit && note.Hit == false then
					local boost = CurTime() <= ply.Persona_Dance_LastCheerT
					local mul = boost && 1.5 or 1
					local old = ply.Persona_Dance_Score
					local hType = note.HitType
					local hP = note.HitPoints
					if hType == 1 then -- Perfect
						ply:EmitSound("cpthazama/persona5_dance/clap_mega.wav")
						didHit = true
						ply.Persona_Dance_HitData.Perfect = ply.Persona_Dance_HitData.Perfect +1
						-- ply.Persona_Dance_Score = math.Round(ply.Persona_Dance_Score +math.Round(100 *(1 -tDif)) *mul)
						ply.Persona_Dance_Score = math.Round(ply.Persona_Dance_Score +math.Round(hP) *mul)
					elseif hType == 2 then -- Great
						ply:EmitSound("cpthazama/persona5_dance/clap_cyl.wav")
						didHit = true
						ply.Persona_Dance_HitData.Great = ply.Persona_Dance_HitData.Great +1
						-- ply.Persona_Dance_Score = math.Round(ply.Persona_Dance_Score +math.Round(50 *(1 -tDif)) *mul)
						ply.Persona_Dance_Score = math.Round(ply.Persona_Dance_Score +math.Round(hP) *mul)
					elseif hType == 3 then -- Good
						ply:EmitSound("cpthazama/persona5_dance/clap.wav")
						didHit = true
						ply.Persona_Dance_HitData.Good = ply.Persona_Dance_HitData.Good +1
						-- ply.Persona_Dance_Score = math.Round(ply.Persona_Dance_Score +math.Round(25 *(1 -tDif)) *mul)
						ply.Persona_Dance_Score = math.Round(ply.Persona_Dance_Score +math.Round(hP) *mul)
					else
						hType = 0
						ply:EmitSound("cpthazama/persona5/misc/00103.wav")
						ply.Persona_Dance_HitTimes = 0
						ply.Persona_Dance_LastNoteT = 0
						if CurTime() > self.NextSpeakT && math.random(1,15) == 1 then
							local snd = self:PlaySound("failing")
							self.NextSpeakT = CurTime() +SoundDuration(snd[2]) +0.5
						end
					end
					self:OnNoteHit(ply,ind,note,hType)
					if ply.Persona_Dance_LastNoteT < CurTime() then
						ply.Persona_Dance_HitTimes = 0
					end
					if didHit then
						if CurTime() > self.NextSpeakT && math.random(1,15) == 1 then
							local snd = self:PlaySound("winning")
							self.NextSpeakT = CurTime() +SoundDuration(snd[2]) +0.5
						end
						if ply.Persona_Dance_LastCheerT > CurTime() then
							ply.Persona_Dance_LastCheerT = math.Clamp(ply.Persona_Dance_LastCheerT +0.25,CurTime(),CurTime() +10)
						else
							ply.Persona_Dance_LastNoteT = CurTime() +10
							ply.Persona_Dance_HitTimes = ply.Persona_Dance_HitTimes +1
						end
						if ply.Persona_Dance_HitTimes >= FEVERCOMBOCOST && ply.Persona_Dance_LastNoteT > CurTime() && CurTime() > ply.Persona_Dance_LastCheerT then
							ply.Persona_Dance_LastNoteT = 0
							ply.Persona_Dance_LastCheerT = CurTime() +10
							ply.Persona_Dance_HitTimes = 0
							ply:ChatPrint("SCORE BOOST FOR 10 SECONDS!")
							ply:EmitSound("cpthazama/persona4/ui_shufflebegin.wav")
							ply:EmitSound("cpthazama/persona5_dance/crowd.wav")
						end
					else
						ply.Persona_Dance_HitTimes = 0
					end
					ply:ChatPrint("Gained " .. tostring(ply.Persona_Dance_Score -old) .. " points!")
				end
			end
		end
	end

	hook.Add("PlayerBindPress", "Persona_DanceViewScroll", function(ply,bind,pressed)
		local dancer = ply:GetNW2Entity("Persona_Dancer")
		if !IsValid(dancer) then return end
		local mode = ply:GetNW2Int("Persona_DanceMode")
		if mode == 0 then return end

		local usingController = GetConVarNumber("persona_dance_controller") == 1
		local bUp = usingController && "lastinv" or "+forward"
		local bLeft = usingController && "+reload" or "+moveleft"
		local bRight = usingController && "+use" or "+moveright"
		local bDown = usingController && "+jump" or "+back"
		local bScratch = usingController && "+attack" or "+use"
		local bNum4 = usingController && "+invprev" or "slot7"
		local bNum8 = usingController && "+attack2" or "slot8"
		local bNum6 = usingController && "+invnext" or "slot9"
		local w = bind == bUp && pressed
		local a = bind == bLeft && pressed
		local s = bind == bDown && pressed
		local d = bind == bRight && pressed
		local e = bind == bScratch && pressed
		local n4 = bind == bNum4 && pressed
		local n8 = bind == bNum8 && pressed
		local n6 = bind == bNum6 && pressed

		if mode == 2 then
			ply.Persona_HitTime = ply.Persona_HitTime or 0
			-- ply:SetNW2Int("Persona_Dance_Score",ply:GetNW2Int("Persona_Dance_Score") or 0)
			ply.Persona_Dance_HitData = ply.Persona_Dance_HitData or {Perfect=0,Great=0,Good=0,Miss=0}
			ply.Persona_Dance_Score = ply.Persona_Dance_Score or 0
			ply.Persona_Dance_LastNoteT = ply.Persona_Dance_LastNoteT or 0
			ply.Persona_Dance_HitTimes = ply.Persona_Dance_HitTimes or 0
			ply.Persona_Dance_LastCheerT = ply.Persona_Dance_LastCheerT or 0
			ply.Persona_NoteDir = ply.Persona_NoteDir or "e"

			-- if w then
				-- CheckHit("w")
			-- end
			if a then
				dancer:CheckNoteHit("a")
			end
			if s then
				dancer:CheckNoteHit("s")
			end
			if d then
				dancer:CheckNoteHit("d")
			end
			if n6 then
				dancer:CheckNoteHit("n4")
			end
			if n8 then
				dancer:CheckNoteHit("n8")
			end
			if n4 then
				dancer:CheckNoteHit("n6")
			end
			if e then
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

	local mat = Material("hud/persona/dance/star_b_new.png")
	hook.Add("HUDPaint","Persona_DanceViewMode_HUD",function(ply)
		local ply = LocalPlayer()
		local dancer = ply:GetNW2Entity("Persona_Dancer")
		if !IsValid(dancer) then return end
		local mode = ply:GetNW2Int("Persona_DanceMode")
		if mode != 2 then return end

		dancer.Persona_NextNoteT = dancer.Persona_NextNoteT or 0
		ply.Persona_Dance_LastCheerT = ply.Persona_Dance_LastCheerT or 0
		ply.Persona_NoteDir = ply.Persona_NoteDir or "w"
		ply.Persona_HitTimeTotal = ply.Persona_HitTimeTotal or 0
		ply.Persona_Dance_Score = ply.Persona_Dance_Score or 0
		ply.Persona_Dance_HitData = ply.Persona_Dance_HitData or {Perfect=0,Great=0,Good=0,Miss=0}
		-- ply:SetNW2Int("Persona_Dance_Score",ply:GetNW2Int("Persona_Dance_Score") or 0)
		-- ply:SetNW2Int("Persona_Dance_HighScore",ply:GetNW2Int("Persona_Dance_HighScore") or 0)
		-- if ply:GetNW2Int("Persona_Dance_Score") > ply:GetNW2Int("Persona_Dance_HighScore") then
			-- ply:SetNW2Int("Persona_Dance_HighScore",ply:GetNW2Int("Persona_Dance_Score"))
		-- end
		
		local HUDColor = Color(GetConVarNumber("persona_dance_hud_r"),GetConVarNumber("persona_dance_hud_g"),GetConVarNumber("persona_dance_hud_b"))
		local boost = ply.Persona_Dance_LastCheerT > CurTime()
		local boostColor = dancer:HSL((RealTime() *250 -(0 *15)),128,128)
		HUDColor = boost && boostColor or HUDColor
		local buttonA_W,buttonA_H = ScrW() /16,ScrH() /10.9
		local buttonW_W,buttonW_H = ScrW() /56,ScrH() /2.32
		local buttonD_W,buttonD_H = ScrW() /16,ScrH() /1.3
		local buttonN4_W,buttonN4_H = ScrW() /1.165,ScrH() /10.9
		local buttonN8_W,buttonN8_H = ScrW() /1.107,ScrH() /2.32
		local buttonN6_W,buttonN6_H = ScrW() /1.165,ScrH() /1.3
		local A_hitW,A_hitH = buttonA_W -25,buttonA_H -10
		local S_hitW,S_hitH = buttonW_W -60,buttonW_H +75
		local D_hitW,D_hitH = buttonD_W -60,buttonD_H +75
		local N4_hitW,N4_hitH = buttonN4_W +240,buttonN4_H -35
		local N8_hitW,N8_hitH = buttonN8_W +240,buttonN8_H +75
		local N6_hitW,N6_hitH = buttonN6_W +240,buttonN6_H +180
		
		local function CanDeleteNote(w,h)
			req = 100
			return w <= req && h <= req
		end
		
		local function GetNoteDist(wCurPos,hCurPos,wTarPos,hTarPos)
			local w,h = 99999,99999
			w = math.abs(wCurPos[1] -wTarPos)
			h = math.abs(hCurPos[1] -hTarPos)

			return w,h
		end

		local function DrawTexture(texture,col,posX,posY,scaleX,scaleY,rot)
			local mat = Material(texture)
			surface.SetMaterial(mat)
			surface.SetDrawColor(col.r,col.g,col.b,col.a)
			if rot then
				surface.DrawTexturedRectRotated(posX,posY,scaleX,scaleY,rot)
				return
			end
			surface.DrawTexturedRect(posX,posY,scaleX,scaleY)
		end

		local function DrawNote(note)
			local nDir = note.Direction
			local nTime = note.Timer -CurTime()
			if !note.Speed then note.Speed = nTime end
			if !note.StartPosW then note.StartPosW = ScrW() /2 end
			if !note.StartPosH then note.StartPosH = ScrH() /2 end
			if !note.LastPosW then note.LastPosW = Angle(ScrW() /2,0,0) end
			if !note.LastPosH then note.LastPosH = Angle(ScrH() /2,0,0) end
			if !note.CanDelete then note.CanDelete = false end
			if !note.HitType then note.HitType = 0 end
			if !note.RemainingDist then note.RemainingDist = 99999 end
			local alpha = 240
			local dA = 2
			local scrWData = ScrW() /dA
			local scrHData = ScrH() /dA
			local targetW,targetH = nil,nil
			local speed = note.Speed > 1 && note.Speed -1 or 1 +note.Speed
			if nDir == "s" then
				note.LastPosW = note.LastPosW +Angle(-speed,0,0)
				note.LastPosH = note.LastPosH
				targetW = S_hitW
				targetH = S_hitH
			elseif nDir == "a" then
				note.LastPosW = note.LastPosW +Angle(-speed,0,0)
				note.LastPosH = note.LastPosH +Angle(-speed /2,0,0)
				targetW = A_hitW
				targetH = A_hitH
			elseif nDir == "d" then
				note.LastPosW = note.LastPosW +Angle(-speed,0,0)
				note.LastPosH = note.LastPosH +Angle(speed /2,0,0)
				targetW = D_hitW
				targetH = D_hitH
			elseif nDir == "n8" then
				note.LastPosW = note.LastPosW +Angle(speed,0,0)
				note.LastPosH = note.LastPosH
				targetW = N8_hitW
				targetH = N8_hitH
			elseif nDir == "n4" then
				note.LastPosW = note.LastPosW +Angle(speed,0,0)
				note.LastPosH = note.LastPosH +Angle(speed /2,0,0)
				targetW = N6_hitW
				targetH = N6_hitH
			elseif nDir == "n6" then
				note.LastPosW = note.LastPosW +Angle(speed,0,0)
				note.LastPosH = note.LastPosH +Angle(-speed /2,0,0)
				targetW = N4_hitW
				targetH = N4_hitH
			end
			local w,h = GetNoteDist(note.LastPosW,note.LastPosH,targetW,targetH)
			note.RemainingDist = w
			note.CanDelete = CanDeleteNote(w,h)
			local scale = 120
			surface.SetMaterial(mat)
			surface.SetDrawColor(HUDColor.r,HUDColor.g,HUDColor.b,alpha)
			surface.DrawTexturedRect(note.LastPosW[1] -(scale /2),note.LastPosH[1] -(scale /2),scale,scale)
		end

		local canExpand = ply.Persona_Dance_LastNoteT && ply.Persona_Dance_LastNoteT > CurTime() || boost
		local songName = dancer:GetSongName()
		local score = ply.Persona_Dance_Score
		local scoreText = "Score - " .. score
		local boxX, boxY = ScrW() /4, ScrH() /150
		local boxW, boxH = ScrW() /4.2, ScrH() /16
		local boxSX, boxSY = ScrW() /1.9, ScrH() /150
		local boxSW, boxSH = ScrW() /28 +surface.GetTextSize(scoreText) *1.35, canExpand && ScrH() /16 or ScrH() /28

		local hT = ply.Persona_Dance_HitData
		local hP = hT.Perfect
		local hGr = hT.Great
		local hG = hT.Good
		local hM = hT.Miss
		local danceMat = dancer.HUD_SideMaterial
		local blink = math.Clamp(math.abs(math.sin(CurTime() *1) *255),50,255)
		
		DrawTexture("hud/persona/dance/bg.png",boost && Color(boostColor.r,boostColor.g,boostColor.b,255) or Color(255,255,255,255),0,0,ScrW(),ScrH())
		DrawTexture(danceMat && danceMat .. "_cut.png" or "hud/persona/dance/bg_stars_cut.png",Color(HUDColor.r,HUDColor.g,HUDColor.b,blink),0,0,ScrW() /5,ScrH())
		DrawTexture(danceMat && danceMat .. "_cut_b.png" or "hud/persona/dance/bg_stars_cut_b.png",Color(HUDColor.r,HUDColor.g,HUDColor.b,blink),ScrW() *0.8,0,ScrW() /5,ScrH())
		DrawTexture("hud/persona/dance/sidebar.png",Color(HUDColor.r,HUDColor.g,HUDColor.b,255),0,0,ScrW() /5,ScrH())
		DrawTexture("hud/persona/dance/sidebar_b.png",Color(HUDColor.r,HUDColor.g,HUDColor.b,255),ScrW() *0.8,0,ScrW() /5,ScrH())
		if boost then DrawTexture("hud/persona/dance/bg_swirl.png",Color(boostColor.r,boostColor.g,boostColor.b,100),ScrW() /2,ScrH() /2,ScrH() *1.15,ScrH() *1.15,(CurTime() % 360) *25) end
		
		if ply.Persona_HUD_LoadT && CurTime() < ply.Persona_HUD_LoadT then
			DrawTexture("hud/persona/dance/loading.png",Color(HUDColor.r,HUDColor.g,HUDColor.b,255),ScrW() /1.041,ScrH() /1.075,200,200,(CurTime() % 360) *100)
		end		
		if ply.Persona_HUD_SaveT && CurTime() < ply.Persona_HUD_SaveT then
			DrawTexture("hud/persona/dance/saving.png",Color(HUDColor.r,HUDColor.g,HUDColor.b,255),ScrW() /1.041,ScrH() /1.075,200,200,(CurTime() % 360) *100)
		end
		
		DrawTexture("hud/persona/dance/ico_a.png",Color(HUDColor.r,HUDColor.g,HUDColor.b,255),buttonA_W,buttonA_H,200,200)
		-- DrawTexture("hud/persona/dance/ico_w.png",Color(HUDColor.r,HUDColor.g,HUDColor.b,255),buttonW_W,buttonW_H,200,200)
		DrawTexture("hud/persona/dance/ico_s.png",Color(HUDColor.r,HUDColor.g,HUDColor.b,255),buttonW_W,buttonW_H,200,200)
		DrawTexture("hud/persona/dance/ico_d.png",Color(HUDColor.r,HUDColor.g,HUDColor.b,255),buttonD_W,buttonD_H,200,200)
		
		DrawTexture("hud/persona/dance/ico_n4.png",Color(HUDColor.r,HUDColor.g,HUDColor.b,255),buttonN4_W,buttonN4_H,200,200)
		DrawTexture("hud/persona/dance/ico_n8.png",Color(HUDColor.r,HUDColor.g,HUDColor.b,255),buttonN8_W,buttonN8_H,200,200)
		DrawTexture("hud/persona/dance/ico_n6.png",Color(HUDColor.r,HUDColor.g,HUDColor.b,255),buttonN6_W,buttonN6_H,200,200)
		
		-- DrawTexture("hud/persona/dance/fx_impact.png",Color(255,0,0,255),buttonN4_W +210,buttonN4_H -20,50,50)

		local iDif = dancer.Difficulty
		local dif = iDif == 1 && "Easy" or iDif == 2 && "Normal" or iDif == 3 && "Hard" or iDif == 4 && "Crazy" or "Insane"
		draw.RoundedBox(8,boxSX,boxSY,boxSW,boxSH,Color(0,0,0,245))
	
		draw.RoundedBox(8,boxX,boxY,boxW,boxH,Color(0,0,0,245)) // 200
		draw.SimpleText(songName,"Persona",boxX +10,boxY +10,HUDColor)
		draw.SimpleText("Difficulty - " .. dif,"Persona",boxX +10,boxY +50,HUDColor)
		draw.SimpleText(scoreText,"Persona",boxSX +10,boxSY +10,HUDColor)
		
		if dancer:GetShowSongMenu() then
			// Outfits
			dancer.OutfitIndex = dancer.OutfitIndex or 1
			if ply:KeyReleased(IN_MOVERIGHT) then
				dancer.OutfitIndex = dancer.OutfitIndex +1
				if dancer.OutfitIndex > #dancer.Outfits then
					dancer.OutfitIndex = 1
				end
				surface.PlaySound("cpthazama/persona4/ui_hover.wav")
			end
			if ply:KeyReleased(IN_MOVELEFT) then
				dancer.OutfitIndex = dancer.OutfitIndex -1
				if dancer.OutfitIndex < 1 then
					dancer.OutfitIndex = #dancer.Outfits
				end
				surface.PlaySound("cpthazama/persona4/ui_hover.wav")
			end
			if ply:KeyReleased(IN_USE) then
				net.Start("Persona_Dance_UpdateOutfit")
					net.WriteString(dancer.Outfits[dancer.OutfitIndex].Name)
					net.WriteEntity(dancer)
					net.WriteEntity(ply)
				net.SendToServer()
				surface.PlaySound("cpthazama/persona5/misc/00031.wav")
			end

			boxX, boxY = ScrW() /1.53, ScrH() /4
			boxW, boxH = ScrW() /4.6, 165
			-- boxW, boxH = ScrW() /4.6, #dancer.Outfits *95
			for i = 1,#dancer.Outfits do
				boxH = boxH +(i *10)
			end
			draw.RoundedBox(8,boxX, boxY,boxW,boxH,Color(0,0,0,245))
			draw.SimpleText("SELECT AN OUTFIT","Persona",boxX *1.065,boxY +10,HUDColor)
			draw.SimpleText("(A - Up, D - Down, E - Equip)","Persona",boxX *1.03,boxY +50,HUDColor)
			local stPos = boxY +70
			for i = 1,#dancer.Outfits do
				stPos = stPos +40
				local name = dancer.Outfits[i].Name
				local unlocked = 
				draw.SimpleText(name,"Persona",boxX +10,stPos,i == dancer.OutfitIndex && boostColor or HUDColor)
			end

			// Songs
			dancer.SelectedIndex = dancer.SelectedIndex or 1
			if ply:KeyReleased(IN_BACK) then
				dancer.SelectedIndex = dancer.SelectedIndex +1
				if dancer.SelectedIndex > #dancer.SoundTracks then
					dancer.SelectedIndex = 1
				end
				surface.PlaySound("cpthazama/persona4/ui_hover.wav")
			end
			if ply:KeyReleased(IN_FORWARD) then
				dancer.SelectedIndex = dancer.SelectedIndex -1
				if dancer.SelectedIndex < 1 then
					dancer.SelectedIndex = #dancer.SoundTracks
				end
				surface.PlaySound("cpthazama/persona4/ui_hover.wav")
			end
			if ply:KeyReleased(IN_JUMP) then
				net.Start("Persona_Dance_UpdateSong")
					net.WriteString(dancer.SoundTracks[dancer.SelectedIndex].name)
					net.WriteEntity(dancer)
					net.WriteEntity(ply)
				net.SendToServer()
				surface.PlaySound("cpthazama/persona5/misc/00031.wav")
				if ply.VJ_Persona_DancePreview_Theme:IsPlaying() then ply.VJ_Persona_DancePreview_Theme:Stop() end
			end
			boxX, boxY = ScrW() /7, ScrH() /4
			-- boxW, boxH = ScrW() /2, ScrH() /(9.65 -#dancer.SoundTracks)
			boxW, boxH = ScrW() /2, 145
			for i = 1,#dancer.SoundTracks do
				boxH = boxH +(i *8)
			end
			draw.RoundedBox(8,boxX, boxY,boxW,boxH,Color(0,0,0,245))
			draw.SimpleText("SELECT A SONG","Persona",boxX *2.3,boxY +10,HUDColor)
			draw.SimpleText("(W - Up, S - Down, Space - Start Song)","Persona",boxX *1.875,boxY +50,HUDColor)
			local stPos = boxY +70
			for i = 1,#dancer.SoundTracks do
				stPos = stPos +40
				local name = dancer.SoundTracks[i].name
				local score = dancer:GetNW2Int("HS_" .. name)
				draw.SimpleText(name .. " : High Score - " .. tostring(score),"Persona",boxX +10,stPos,i == dancer.SelectedIndex && boostColor or HUDColor)
			end
		end

		if canExpand then
			local r = boost && ply.Persona_Dance_LastCheerT -CurTime() or (ply.Persona_Dance_LastNoteT -CurTime())
			draw.RoundedBox(8,boxSX +5, boxSY +45,math.Clamp(20 *r,0,boxSW -10),40,HUDColor)
		end

		for ind,note in pairs(dancer.Notes) do
			if note then
				if note.RemainingDist then -- So, due to another really fucking retarded and weird GMod issue, I am not forced to run this block of code every fucking Tick. Holy fuck I am so done with GMod...
					local hNoMore = 75 -- Cut-off, at this point you missed
					local hPerfect = 170 -- Dead on
					local hGreat = 210 -- Almost on the spot
					local hGood = 350 -- Meh
					local nDist = math.abs(note.RemainingDist)
					if nDist <= hPerfect && nDist > hNoMore then
						note.HitType = 1
					elseif nDist > hPerfect && nDist <= hGreat then
						note.HitType = 2
					elseif nDist > hGreat && nDist <= hGood then
						note.HitType = 3
					else
						note.HitType = 0
					end
					note.CanBeHit = nDist <= 370
					note.HitPoints = 350 -nDist
					-- draw.SimpleText(math.Round(nDist),"Persona",note.LastPosW[1] +50,note.LastPosH[1] +10,Color(255,0,0))
				end
				
				if GetConVarNumber("persona_dance_perfect") == 1 && note.RemainingDist then
					local nDist = math.abs(note.RemainingDist)
					if note.CanBeHit && nDist <= 170 && nDist > 75 then
						if note.Hit == false then
							dancer:CheckNoteHit(note.Direction)
						end
					end
				end

				if note.CanDelete /*note.Timer < CurTime()*/ or note.Hit == true then
					-- Entity(1):ChatPrint("REMOVED")
					if note.Hit == false then
						dancer:OnNoteHit(ply,ind,note,0)
					end
					table.remove(dancer.Notes,ind)
				else
					DrawNote(note)
				end
			end
		end

		local function DrawFX(fx)
			local posW = fx.PosW
			local posH = fx.PosH
			fx.PosH = fx.PosH -0.5
			fx.Alpha = fx.Alpha or 255
			fx.Alpha = fx.Alpha -5 or 255
			local mat = Material(fx.Material)
			local scale = 250
			surface.SetMaterial(mat)
			surface.SetDrawColor(255,255,255,fx.Alpha)
			surface.DrawTexturedRect(posW -(scale /2),posH -(scale /2),scale,scale /2)
		end

		if dancer.Persona_HitFX then
			for ind,fx in pairs(dancer.Persona_HitFX) do
				if fx then
					if fx.Timer < CurTime() then
						table.remove(dancer.Persona_HitFX,ind)
					else
						DrawFX(fx)
					end
				end
			end
		end
	end)

	hook.Add("InputMouseApply","Persona_ThirdPersonView_Rotate",function(cmd,x,y,ang)
		local ply = LocalPlayer()
		local dancer = ply:GetNW2Entity("Persona_Dancer")
		local danceMode = ply:GetNW2Int("Persona_DanceMode")
		local cCinematic = tobool(GetConVarNumber("persona_dance_cinematic"))
		local enabled = IsValid(dancer) && danceMode != 0
		if enabled && cCinematic then
			cmd:SetMouseX(0)
			cmd:SetMouseY(0)
			return true
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
			local cCinematic = tobool(GetConVarNumber("persona_dance_cinematic"))
			if IsValid(ply:GetViewEntity()) && ply:GetViewEntity():GetClass() == "gmod_cameraprop" then
				return
			end
			if dancer:GetNW2Bool("CustomView") == true && dancer.CustomCalcView then
				return dancer:CustomCalcView(ply,pos,angles,fov,danceBone)
			end
			if cCinematic then
				local pos = dancer:GetNW2Vector("LastCinematicPos")
				local dist = dancer:GetNW2Int("LastCinematicDist")
				local speed = dancer:GetNW2Int("LastCinematicSpeed")
				local bone = dancer:GetNW2String("LastCinematicBone")

				local sPos,sAng = dancer:GetBonePosition(dancer:LookupBone(bone))
				local tr = util.TraceHull({
					start = sPos,
					endpos = sPos +angles:Forward() *-dist +(dancer:GetForward() *pos.y +dancer:GetRight() *pos.x +dancer:GetUp() *pos.z),
					mask = MASK_SHOT,
					filter = player.GetAll(),
					mins = Vector(-8,-8,-8),
					maxs = Vector(8,8,8)
				})
				pos = tr.HitPos +tr.HitNormal *5
				P_LerpVec = LerpVector(FrameTime() *speed,P_LerpVec,pos)
				P_LerpAng = LerpAngle(FrameTime() *speed,P_LerpAng,(sPos -pos):Angle())

				local view = {}
				view.origin = P_LerpVec
				view.angles = P_LerpAng
				view.fov = fov
				return view
			end
			local sPos,sAng = dancer:GetBonePosition(dancer:LookupBone(danceBone))
			local dist = ply.Persona_DanceZoom or 90
			local tr = util.TraceHull({
				start = sPos,
				endpos = sPos +angles:Forward() *-math.max(dist,dancer:BoundingRadius()),
				mask = MASK_SHOT,
				filter = player.GetAll(),
				mins = Vector(-8,-8,-8),
				maxs = Vector(8,8,8)
			})
			pos = tr.HitPos +tr.HitNormal *5
			P_LerpVec = LerpVector(FrameTime() *15,P_LerpVec,pos)
			P_LerpAng = LerpAngle(FrameTime() *15,P_LerpAng,(sPos -pos):Angle())

			local view = {}
			view.origin = P_LerpVec
			view.angles = P_LerpAng
			view.fov = fov
			return view
		end
	end)

	net.Receive("Persona_Dance_PreviewSong",function(len)
		local me = net.ReadEntity()
		local ply = net.ReadEntity()
		
		if LocalPlayer() != ply then return end
		if ply.VJ_Persona_DancePreview_Theme == nil or ply.VJ_Persona_DancePreview_Theme && !ply.VJ_Persona_DancePreview_Theme:IsPlaying() then
			local snd = me.PreviewThemes && VJ_PICK(me.PreviewThemes) or "cpthazama/persona3_dance/music/preview.wav"
			ply.VJ_Persona_DancePreview_Theme = CreateSound(ply,snd)
			ply.VJ_Persona_DancePreview_Theme:SetSoundLevel(0)
			ply.VJ_Persona_DancePreview_Theme:Play()
			ply.VJ_Persona_DancePreview_Theme:ChangeVolume(GetConVarNumber("vj_persona_dancevol") *0.01) // 60
			ply.VJ_Persona_DancePreview_Theme:ChangePitch(100 *GetConVarNumber("host_timescale"))
		end
	end)

	net.Receive("Persona_Dance_Song",function(len)
		local dir = net.ReadString()
		local ply = net.ReadEntity()
		local me = net.ReadEntity()
		local seq = net.ReadString()
		local length = net.ReadInt(12)

		if !IsValid(me) then MsgN("Thanks GMod, very cool") end
		if LocalPlayer() != ply then return end
		-- if me.ViewMode != 0 then
			-- if ply != me.Persona_Player then return end
		-- end
		me.Persona_Player = ply
		me.Difficulty = GetConVarNumber("vj_persona_dancedifficulty")
		me.IsCheating = GetConVarNumber("persona_dance_perfect") == 1 or false
		me.DanceIndex = (me.DanceIndex or 0) +1
		if !me.ApplyNotes then ply:ChatPrint("A weird problem occured...respawn the Dancer and it will be fixed"); SafeRemoveEntity(me) return end
		me:ApplyNotes(seq,(seq && me.SongLength && me.SongLength[seq]) or length -4)
		me.Persona_NextNoteT = CurTime() +3

		ply.Persona_Dance_LastNoteT = 0
		ply.Persona_Dance_LastCheerT = 0
		ply.Persona_Dance_HitTimes = 0
		ply.Persona_Dance_HitData = {Perfect=0,Great=0,Good=0,Miss=0}
		me.HUD_SideMaterial = math.random(1,2) == 1 && "hud/persona/dance/bg_stars" or "hud/persona/dance/bg_hex"
		ply.Persona_HUD_LoadT = CurTime() +math.Rand(0.1,0.6)
		me:SetShowSongMenu(false)
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

	net.Receive("Persona_Dance_SongEnd",function(len)
		local song = net.ReadString()
		local ply = net.ReadEntity()
		local dancer = net.ReadEntity()
		local score = ply.Persona_Dance_Score
		
		if dancer.IsCheating then
			score = 0
		end
		
		-- dancer:SetNW2Int("HS_" .. song,score or 0)
		
		net.Start("Persona_Dance_SendScore")
			net.WriteInt(score,24)
			net.WriteString(song)
			net.WriteEntity(ply)
			net.WriteEntity(dancer)
		net.SendToServer()

		ply.Persona_HUD_SaveT = CurTime() +math.Rand(0.4,1)
	end)

	net.Receive("Persona_Dance_ChangeFlex",function(len)
		local dancer = net.ReadEntity()
		local flex = net.ReadString()
		local val = net.ReadInt(32)
		local speed = net.ReadInt(32)
		
		dancer:ChangeFlex(flex,val,speed)
	end)

	function ENT:Think()
		local ply = LocalPlayer()
		self:ClientThink(ply)
		if ply.VJ_Persona_Dance_Theme && ply.VJ_Persona_Dance_Theme:IsPlaying() then
			ply.VJ_Persona_Dance_Theme:ChangeVolume(GetConVarNumber("vj_persona_dancevol") *0.01)
			ply.VJ_Persona_Dance_Theme:ChangePitch(100 *GetConVarNumber("host_timescale"))
		end
		if ply.VJ_Persona_DancePreview_Theme && ply.VJ_Persona_DancePreview_Theme:IsPlaying() then
			ply.VJ_Persona_DancePreview_Theme:ChangeVolume(GetConVarNumber("vj_persona_dancevol") *0.01)
			ply.VJ_Persona_DancePreview_Theme:ChangePitch(100 *GetConVarNumber("host_timescale"))
		end
	end

	function ENT:OnRemove()
		local ply = LocalPlayer()
		local song = self:GetSongName()
		self:ClientRemove(ply)

		-- local oldData = PXP.GetDanceData(ply,song)
		-- local s = ply:GetNW2Int("Persona_Dance_Score")
		-- local hs = ply:GetNW2Int("Persona_Dance_HighScore")
		-- if hs && hs > oldData then
			-- PXP.SaveDanceData(ply,song,s)
		-- end
		-- ply:SetNW2Int("Persona_Dance_Score",0)
		-- ply:SetNW2Int("Persona_Dance_HighScore",0)

		-- if ply != self.Persona_Player then return end
		-- print(ply,self.Persona_Player)
		if ply.VJ_Persona_DancePreview_Theme && ply.VJ_Persona_DancePreview_Theme:IsPlaying() then ply.VJ_Persona_DancePreview_Theme:FadeOut(2) end
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
function ENT:OutfitUnlocked(outfit,ply)
	if type(outfit) == "number" && self.Outfits[outfit] then
		if self.Outfits[outfit].ReqSong == nil then return true end
		local highscore = PXP.GetDanceData(ply,self.Outfits[outfit].ReqSong)
		return highscore >= self.Outfits[outfit].ReqScore
	end
	for _,v in pairs(self.Outfits) do
		if v.Name == outfit then
			if v.ReqSong == nil then return true end
			local highscore = PXP.GetDanceData(ply,v.ReqSong)
			return highscore >= v.ReqScore
		end
	end
end
---------------------------------------------------------------------------------------------------------------------------------------------
function ENT:ChangeOutfit(outfit)
	local mdl = string.Replace(self.Model,".mdl","")
	local pos = self:GetPos() +Vector(0,0,-self.HeightOffset)
	if type(outfit) == "number" && self.Outfits[outfit] then
		local oldMdl = self:GetModel()
		local newMdl = oldMdl
		local useFull = self.Outfits[outfit].UseFullDirectory or false
		self:SetModel(useFull && self.Outfits[outfit].Model or mdl .. self.Outfits[outfit].Model .. ".mdl")
		self.HeightOffset = self.Outfits[outfit].Offset
		self:SetPos(pos +Vector(0,0,self.HeightOffset))
		local newMdl = self:GetModel()
		self:OnChangedOutfit(oldMdl,newMdl,outfit)
		return
	end
	for _,v in pairs(self.Outfits) do
		if v.Name == outfit then
			local oldMdl = self:GetModel()
			local newMdl = oldMdl
			local useFull = v.UseFullDirectory or false
			self:SetModel(useFull && v.Model or mdl .. v.Model .. ".mdl")
			self.HeightOffset = v.Offset
			self:SetPos(pos +Vector(0,0,self.HeightOffset))
			local newMdl = self:GetModel()
			self:OnChangedOutfit(oldMdl,newMdl,outfit)
			break
		end
	end
end
---------------------------------------------------------------------------------------------------------------------------------------------
function ENT:PlayPreview(ply)
	local previewAnim = self.PreviewAnimation or "preview"
	if self:GetSequenceName(self:GetSequence()) != previewAnim then
		self:ResetSequence(previewAnim)
		self:SetPlaybackRate(1)
		-- self:SetCycle(1)
		self:OnPlayPreview(ply)
	end
	net.Start("Persona_Dance_PreviewSong")
		net.WriteEntity(self)
		net.WriteEntity(ply)
	net.Send(ply)

	return self:GetSequenceDuration(self,previewAnim)
end
---------------------------------------------------------------------------------------------------------------------------------------------
function ENT:PlayAnimation(seq,rate,cycle,index,name,noReset)
	local sT = index == 1 && self.SongStartAnimationDelay or 0
	local t = self:GetSequenceDuration(self,seq)
	timer.Simple(sT,function()
		if IsValid(self) then
			local cycle = self.Animations[name][index].cycle or 0
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
				self.DanceIndex = self.DanceIndex +1
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
						local t = self:PlayAnimation(anim,1,cycle,self.Index,name,true)
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
	return VJ_PlaySound(self,(self.Sounds && self.Sounds[name] && VJ_PICK(self.Sounds[name])) or notTable,vol or 75,pit or 100) or {0,0}
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
function ENT:RandomizeExpressions(flexes,anim,frames,chance)
	local chance = chance or 50
	
	for i = 1,frames do
		if math.random(1,chance) == 1 then
			for _,flex in pairs(flexes) do
				self:AddFlexEvent(anim,i,{Name=flex,Value=math.Rand(0,1),Speed=math.Rand(0.5,6)},frames)
			end
		end
	end
end
---------------------------------------------------------------------------------------------------------------------------------------------
function ENT:RandomizeCinematics(anim,frames,chance)
	local chance = chance or 100
	
	for i = 1,frames do
		if i == 1 then
			self:AddCinematicEvent(anim,1,{f=65,r=math.Rand(-15,15),u=math.Rand(-15,15),dist=0,speed=math.random(1,25),bone=self.ViewBone},frames)
		end
		if math.random(1,chance) == 1 && i != 1 then
			self:AddCinematicEvent(anim,i,{f=math.Rand(25,120),r=math.Rand(-60,60),u=math.Rand(-15,15),dist=0,speed=math.random(1,25),bone=self.ViewBone},frames)
		end
	end
end
---------------------------------------------------------------------------------------------------------------------------------------------
function ENT:PlaySound(name,vol,pit,notTable)
	return VJ_PlaySound(self,(self.Sounds && self.Sounds[name] && VJ_PICK(self.Sounds[name])) or notTable,vol or 75,pit or 100)
end
---------------------------------------------------------------------------------------------------------------------------------------------
function ENT:OnChangeCinematicData(oldData,newData) end
---------------------------------------------------------------------------------------------------------------------------------------------
function ENT:SetCinematicData(pos,dist,speed,bone)
	local cBone = bone or self.ViewBone
	local old = {pos=self:GetNW2Vector("LastCinematicPos"),dist=self:GetNW2Int("LastCinematicDist"),speed=self:GetNW2Int("LastCinematicSpeed"),bone=self:GetNW2String("LastCinematicBone")}
	self:SetNW2Vector("LastCinematicPos",pos or Vector(0,0,0))
	self:SetNW2Int("LastCinematicDist",dist or 1)
	self:SetNW2Int("LastCinematicSpeed",speed == false && 85 or math.Clamp(speed or 15,1,100))
	self:SetNW2String("LastCinematicBone",cBone)
	local new = {pos=self:GetNW2Vector("LastCinematicPos"),dist=self:GetNW2Int("LastCinematicDist"),speed=self:GetNW2Int("LastCinematicSpeed"),bone=self:GetNW2String("LastCinematicBone")}
	self:OnChangeCinematicData(old,new)
end
---------------------------------------------------------------------------------------------------------------------------------------------
function ENT:Initialize()
	self:SetModel(self.Model)
	self:SetModelScale(self.ModelScale or 1)
	self:SetSolid(SOLID_OBB)
	self:SetCollisionGroup(COLLISION_GROUP_IN_VEHICLE)
	local col = self.CollisionBounds
	self:SetCollisionBounds(Vector(col.x,col.y,col.z),Vector(-col.x,-col.y,0))

	self:SetSelectedSong("false")
	self.StartedSong = false
	self.DefaultPlaybackRate = 1
	self.Index = 0
	self.DanceIndex = 0
	self.NextDanceT = CurTime()
	self.NextSpeakT = 0

	self:SetCinematicData(Vector(0,100,5),0) // Default

	self.AnimationEvents = {}
	
	self:SetNW2Bool("CustomView",false)

	timer.Simple(0,function()
		if IsValid(self) then
			if IsValid(self:GetCreator()) && self:GetCreator():IsPlayer() then
				self:SetPos(self:GetPos() +Vector(0,0,self.HeightOffset))
				self.ViewMode = GetConVarNumber("vj_persona_dancemode") or 2
				-- self.ViewMode = self:GetViewMode()
				if self.ViewMode != 0 then
					self:GetCreator():SetNW2Entity("Persona_Dancer",self)
					self:GetCreator():SetNW2Int("Persona_DanceMode",self.ViewMode)
					self:GetCreator():SetNW2String("Persona_DanceBone",self.ViewBone)
					self:GetCreator():SetNW2Int("Persona_Dance_Score",0)
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
						[2] = self.Creator:Armor(),
						[3] = weps,
						[4] = (IsValid(self.Creator:GetActiveWeapon()) && self.Creator:GetActiveWeapon():GetClass()) or "",
					}
					self.Creator:StripWeapons()
					for _,v in ipairs(self.SoundTracks) do
						self:SetNW2Int("HS_" .. v.name,PXP.GetDanceData(self.Creator,v.name) or 0)
					end
				end
				self:SetShowSongMenu(true)
				self:OnInit()
			end
		end
	end)
end
---------------------------------------------------------------------------------------------------------------------------------------------
function ENT:GetCinematicEventCoolDown(seq,frame)
	if self.CinematicCoolDown[seq] then
		return self.CinematicCoolDown[seq][frame][1]
	end
end
---------------------------------------------------------------------------------------------------------------------------------------------
function ENT:AddCinematicEventCoolDown(seq,frame)
	if self.CinematicCoolDown[seq] then
		self.CinematicCoolDown[seq][frame][1] = CurTime() +0.1
	end
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
function ENT:AddCinematicEvent(seq,frame,data,frameCount)
	local seq = self:LookupSequence(seq)
	self.CinematicEvents = self.CinematicEvents or {}
	self.CinematicEvents[seq] = self.CinematicEvents[seq] or {}
	self.CinematicEvents[seq][frame] = self.CinematicEvents[seq][frame] or {}
	table.insert(self.CinematicEvents[seq][frame],data)
	
	self.CinematicCoolDown = self.CinematicCoolDown or {}
	self.CinematicCoolDown[seq] = self.CinematicCoolDown[seq] or {}
	self.CinematicCoolDown[seq][frame] = self.CinematicCoolDown[seq][frame] or {}
	table.insert(self.CinematicCoolDown[seq][frame],CurTime())

	if frameCount then
		self.RegisteredSequences = self.RegisteredSequences or {}
		self.RegisteredSequences[seq] = frameCount
	end
end
---------------------------------------------------------------------------------------------------------------------------------------------
function ENT:HandleRandomFlex(seq,frame)
	for _,v in pairs(self.RandomFlex[seq][frame]) do
		net.Start("Persona_Dance_ChangeFlex")
			net.WriteEntity(self)
			net.WriteString(v.Name)
			net.WriteInt(v.Value,32)
			net.WriteInt(v.Speed,32)
		net.Broadcast()
	end
end
---------------------------------------------------------------------------------------------------------------------------------------------
function ENT:AddFlexEvent(seq,frame,flexData,frameCount)
	local seq = self:LookupSequence(seq)
	self.AnimationEvents = self.AnimationEvents or {}
	self.AnimationEvents[seq] = self.AnimationEvents[seq] or {}
	self.AnimationEvents[seq][frame] = self.AnimationEvents[seq][frame] or {}
	table.insert(self.AnimationEvents[seq][frame],"rand_flex")
	
	self.EventCoolDown = self.EventCoolDown or {}
	self.EventCoolDown[seq] = self.EventCoolDown[seq] or {}
	self.EventCoolDown[seq][frame] = self.EventCoolDown[seq][frame] or {}
	table.insert(self.EventCoolDown[seq][frame],CurTime())
	
	self.RandomFlex = self.RandomFlex or {}
	self.RandomFlex[seq] = self.RandomFlex[seq] or {}
	self.RandomFlex[seq][frame] = self.RandomFlex[seq][frame] or {}
	table.insert(self.RandomFlex[seq][frame],flexData)

	if frameCount then
		self.RegisteredSequences = self.RegisteredSequences or {}
		self.RegisteredSequences[seq] = frameCount
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
	if self:GetSelectedSong() == "false" then
		for _,v in ipairs(self.SoundTracks) do
			local highscore = PXP.GetDanceData(self.Creator,v.name) or 0
			self:SetNW2Int("HS_" .. v.name,highscore)
		end
		self:PlayPreview(self.Creator)
		self:SetShowSongMenu(true)
	end
	if self.NextDanceT < CurTime() && self.StartedSong then
		net.Start("Persona_Dance_SongEnd")
			net.WriteString(self:GetSelectedSong())
			net.WriteEntity(self.Creator)
			net.WriteEntity(self)
		net.Broadcast()
		self:SetSelectedSong("false")
		self.StartedSong = false
	end
	if self:GetSelectedSong() != "false" && !self.StartedSong then
		self.StartedSong = true
		local anim = "preview"
		local songName = self:GetSelectedSong()
		local delay = self.SongStartAnimationDelay
		for _,v in pairs(self.SoundTracks) do
			if v.name == self:GetSelectedSong() then
				anim = self.Animations[v.dance][1].anim
				break
			end
		end
		self:StartLamp()
		local t = self:PlayAnimation(anim,1,0,1,anim) +delay +0.1
		if IsValid(self.Creator) && self.ViewMode == 2 then
			local ply = self.Creator
			local highscore = PXP.GetDanceData(ply,self:GetSelectedSong())
			ply:SetNW2Int("Persona_Dance_Score",highscore or 0)
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
	local findSeq = self.RegisteredSequences && self.RegisteredSequences[seq]
	local eventSeq = self.AnimationEvents && self.AnimationEvents[seq]
	local cinSeq = self.CinematicEvents && self.CinematicEvents[seq]
	if (cinSeq && findSeq) or (eventSeq && findSeq) then
		if self.LastSequence != seq then
			self.LastSequence = seq
			self.LastFrame = -1
		end
		local NextFrame = math.floor(self:GetCycle() *(self:GetPlaybackRate() *findSeq))
		self.LastFrame = NextFrame
		-- if self.LastFrame then Entity(1):ChatPrint(self.LastFrame) end
		if cinSeq && self.CinematicEvents[seq][self.LastFrame] then
			for _,v in pairs(self.CinematicEvents[seq][self.LastFrame]) do
				if CurTime() > self:GetCinematicEventCoolDown(seq,self.LastFrame) then
					self:SetCinematicData(Vector(v.r,v.f,v.u),v.dist,v.speed,v.bone or nil)
					self:OnCinematicEvent(seq,v,self.LastFrame)
					self:AddCinematicEventCoolDown(seq,self.LastFrame)
				end
			end
		end
		if eventSeq && eventSeq[self.LastFrame] then
			for _,v in pairs(eventSeq[self.LastFrame]) do
				if CurTime() > self:GetEventCoolDown(seq,self.LastFrame) then
					self:HandleAnimationEvent(seq,v,self.LastFrame)
					if v == "rand_flex" then
						self:HandleRandomFlex(seq,self.LastFrame)
					end
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
if SERVER then
	net.Receive("Persona_Dance_UpdateOutfit",function(len)
		local id = net.ReadString()
		local dancer = net.ReadEntity()
		local ply = net.ReadEntity()
		local checkDancer = ply:GetNW2Entity("Persona_Dancer")

		if !IsValid(checkDancer) then return end
		if checkDancer != dancer then return end
		
		if dancer:OutfitUnlocked(id,ply) then
			dancer:ChangeOutfit(id)
		else
			local song = "N/A"
			local score = 0
			for _,v in pairs(dancer.Outfits) do
				if v.Name == id then
					song = v.ReqSong
					score = v.ReqScore
				end
			end
			ply:ChatPrint(id .. " is not unlocked yet! You must complete [" .. song .. "] with a score of " .. score)
		end
	end)

	net.Receive("Persona_Dance_UpdateSong",function(len)
		local song = net.ReadString()
		local dancer = net.ReadEntity()
		local ply = net.ReadEntity()
		local checkDancer = ply:GetNW2Entity("Persona_Dancer")

		if !IsValid(checkDancer) then return end
		if checkDancer != dancer then return end

		dancer:SetSelectedSong(song)
	end)

	net.Receive("Persona_Dance_SendScore",function(len)
		local score = net.ReadInt(24)
		local song = net.ReadString()
		local ply = net.ReadEntity()
		local dancer = net.ReadEntity()
		local highscore = PXP.GetDanceData(ply,song)

		if score > highscore then
			-- dancer:SetNW2Int("HS_" .. song,highscore or 0)
			PXP.SaveDanceData(ply,song,score)
		end
	end)
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