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
---------------------------------------------------------------------------------------------------------------------------------------------
if SERVER then
	function ENT:HandleKeys(ply) end

	function ENT:OnInit() end

	function ENT:HandleAnimationEvent(seq,event,frame) end

	function ENT:OnPlayDance(seq,t) end

	util.AddNetworkString("Persona_Dance_Song")
	util.AddNetworkString("Persona_Dance_ModeStart")
end
---------------------------------------------------------------------------------------------------------------------------------------------
function ENT:SetupDataTables()
	self:NetworkVar("String",0,"Song")
end
---------------------------------------------------------------------------------------------------------------------------------------------
if (CLIENT) then
	function ENT:Draw()
		self:DrawModel()
	end

	hook.Add("PlayerBindPress", "Persona_DanceViewScroll", function(ply,bind,pressed)
		local dancer = ply:GetNWEntity("Persona_Dancer")
		if !IsValid(dancer) then return end
		local mode = ply:GetNWInt("Persona_DanceMode")
		if mode == 0 then return end
		
		local w = bind == "+forward" && pressed
		local a = bind == "+moveleft" && pressed
		local s = bind == "+back" && pressed
		local d = bind == "+moveright" && pressed
		local e = bind == "+use" && pressed
		
		if mode == 2 then
			ply.Persona_HitTime = ply.Persona_HitTime or 0
			ply.Persona_Dance_Score = ply.Persona_Dance_Score or 0
			ply.Persona_Dance_LastNoteT = ply.Persona_Dance_LastNoteT or 0
			ply.Persona_NoteDir = ply.Persona_NoteDir or "e"
			local function CheckHit()
				local hNoMore = 0.03
				local hPerfect = 0.075
				local hGreat = 0.013
				local hGood = 0.2
				if ply.Persona_HitTime > CurTime() then
					local tDif = ply.Persona_HitTime -CurTime()
					local old = ply.Persona_Dance_Score
					if tDif <= hPerfect && tDif > hNoMore then -- Perfect
						ply:EmitSound("cpthazama/persona5_dance/clap_mega.wav")
						ply:ChatPrint("PERFECT!")
						ply.Persona_Dance_Score = ply.Persona_Dance_Score +math.Round(100 *(1 -tDif))
					elseif tDif > hPerfect && tDif <= hGreat then -- Great
						ply:EmitSound("cpthazama/persona5_dance/clap_cyl.wav")
						ply:ChatPrint("GREAT!")
						ply.Persona_Dance_Score = ply.Persona_Dance_Score +math.Round(50 *(1 -tDif))
					elseif tDif > hGreat && tDif <= hGood then -- Good
						ply:EmitSound("cpthazama/persona5_dance/clap.wav")
						ply:ChatPrint("GOOD!")
						ply.Persona_Dance_Score = ply.Persona_Dance_Score +math.Round(25 *(1 -tDif))
					else
						ply:EmitSound("cpthazama/persona5/misc/00103.wav")
						ply:ChatPrint("MISS!")
					end
					ply:ChatPrint("Gained " .. tostring(ply.Persona_Dance_Score -old) .. " points!")
					ply.Persona_Dance_LastNoteT = CurTime() +5
				else
					ply:EmitSound("cpthazama/persona5/misc/00103.wav")
					ply:ChatPrint("MISS!")
				end
				ply.Persona_HitTime = 0
			end
			if w then
				if ply.Persona_NoteDir != "w" then return end
				CheckHit()
			end
			if a then
				if ply.Persona_NoteDir != "a" then return end
				CheckHit()
			end
			if s then
				if ply.Persona_NoteDir != "s" then return end
				CheckHit()
			end
			if d then
				if ply.Persona_NoteDir != "d" then return end
				CheckHit()
			end
			if e then
				ply:ChatPrint("E")
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

	hook.Add("HUDPaint","Persona_DanceViewMode_HUD",function(ply)
		local ply = LocalPlayer()
		local dancer = ply:GetNWEntity("Persona_Dancer")
		if !IsValid(dancer) then return end
		local mode = ply:GetNWInt("Persona_DanceMode")
		if mode != 2 then return end

		dancer.Persona_NextNoteT = dancer.Persona_NextNoteT or 0
		ply.Persona_NoteDir = ply.Persona_NoteDir or "w"
		ply.Persona_HitTimeTotal = ply.Persona_HitTimeTotal or 0
		ply.Persona_Dance_Score = ply.Persona_Dance_Score or 0
		local noteT = dancer.Persona_NextNoteT
		if CurTime() > noteT then
			ply.Persona_NoteDir = VJ_PICK({"w","a","s","d"})
			local pick = math.Rand(0.7,2)
			ply.Persona_HitTimeTotal = pick
			ply.Persona_HitTime = CurTime() +pick
			dancer.Persona_NextNoteT = CurTime() +math.Rand(pick +0.1,2.5)
		end
		draw.RoundedBox(8,ScrW() /2 -30, ScrH() /2 -30,60,60,Color(0,255,255,150))
		draw.SimpleText("Score - " .. ply.Persona_Dance_Score,"Persona",ScrW() /2 -30,ScrH() /2 -60,Color(255,0,0))
		if ply.Persona_HitTime && ply.Persona_HitTime > CurTime() then
			local nDir = ply.Persona_NoteDir
			draw.SimpleText(nDir,"Persona",ScrW() /2 -30,ScrH() /2 -30,Color(255,0,0))
			local mTbl = {}
			mTbl["w"] = {scr = "H",dir = -50,div = 1}
			mTbl["a"] = {scr = "W",dir = -50,div = 1}
			mTbl["s"] = {scr = "H",dir = -50,div = 2}
			mTbl["d"] = {scr = "W",dir = -50,div = 2}
			local time = (ply.Persona_HitTime -CurTime())
			draw.SimpleText(tostring(math.Round(time,3)),"Persona",ScrW() /2 -30,ScrH() /2,Color(255,0,0))
			local col = nDir == "w" && Color(29,0,255,180) or nDir == "a" && Color(255,0,0,180) or nDir == "s" && Color(255,255,0,180) or nDir == "d" && Color(50,255,0,180)
			local mul = mTbl[nDir].div == 1
			local scrWData = (mTbl[nDir].scr == "W" && (mul == 1 && ScrW() or ScrW() /2) +(time *(mul == 1 && ScrW() or ScrW() /2)) +mTbl[nDir].dir) or ScrW() /2
			local scrHData = (mTbl[nDir].scr == "H" && (mul == 1 && ScrH() or ScrH() /2) +(time *(mul == 1 && ScrH() or ScrH() /2)) +mTbl[nDir].dir) or ScrH() /2
			draw.RoundedBox(8,scrWData -25,scrHData -25,50,50,col)
		end
	end)

	local P_LerpVec = Vector(0,0,0)
	local P_LerpAng = Angle(0,0,0)
	hook.Add("CalcView","Persona_DanceViewMode",function(ply,pos,angles,fov)
		local dancer = ply:GetNWEntity("Persona_Dancer")
		local danceMode = ply:GetNWInt("Persona_DanceMode")
		local danceBone = ply:GetNWString("Persona_DanceBone")
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

		me.Persona_NextNoteT = CurTime() +3
		if ply.VJ_Persona_Dance_Theme && ply.VJ_Persona_Dance_ThemeDir == dir then ply.VJ_Persona_Dance_Theme:Stop() end
		timer.Simple(me.SongStartDelay,function()
			if IsValid(ply) then
				ply.VJ_Persona_Dance_ThemeDir = dir
				ply.VJ_Persona_Dance_Theme = CreateSound(ply,dir)
				ply.VJ_Persona_Dance_Theme:SetSoundLevel(0)
				ply.VJ_Persona_Dance_Theme:Play()
				ply.VJ_Persona_Dance_Theme:ChangeVolume(60)
				ply.VJ_Persona_Dance_Theme:ChangePitch(100 *GetConVarNumber("host_timescale"))
			end
		end)
	end)

	net.Receive("Persona_Dance_ModeStart",function(len)
		local ply = net.ReadEntity()
		local me = net.ReadEntity()

		ply.Persona_Dance_Score = 0
		ply.Persona_Dance_LastNoteT = 0
		ply.Persona_Dance_StartSound = CreateSound(ply,"cpthazama/persona5_dance/crowd.wav")
		ply.Persona_Dance_StartSound:SetSoundLevel(0)
		ply.Persona_Dance_StartSound:Play()
		ply.Persona_Dance_StartSound:ChangeVolume(60)
		ply:ChatPrint("'Dance, Dance!' mode is very WIP right now! Currently, only one note appears at a time and the hit time is a bit off at times. The notes are randomly generated as well for the time being!")
	end)

	function ENT:Think()
		local ply = LocalPlayer()
		if ply.VJ_Persona_Dance_Theme && ply.VJ_Persona_Dance_Theme:IsPlaying() then
			ply.VJ_Persona_Dance_Theme:ChangePitch(100 *GetConVarNumber("host_timescale"))
		end
	end

	function ENT:OnRemove()
		local ply = LocalPlayer()
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
			local song = nil
			for _,v in pairs(self.SoundTracks) do
				if v.dance == seq then
					song = v.song
					break
				end
			end
			if !noReset then
				for _,v in pairs(player.GetAll()) do
					net.Start("Persona_Dance_Song")
						net.WriteString(song)
						net.WriteEntity(v)
						net.WriteEntity(self)
					net.Broadcast()
				end
				self:SetSong(song)
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
function ENT:Initialize()
	self:SetModel(self.Model)
	self:SetSolid(SOLID_OBB)
	self:SetCollisionGroup(COLLISION_GROUP_IN_VEHICLE)
	local col = self.CollisionBounds
	self:SetCollisionBounds(Vector(col.x,col.y,col.z),Vector(-col.x,-col.y,0))

	self.DefaultPlaybackRate = 1
	self.Index = 0
	self.NextDanceT = CurTime()
	self.AnimationEvents = {}

	timer.Simple(0,function()
		if IsValid(self) then
			if IsValid(self:GetCreator()) && self:GetCreator():IsPlayer() then
				self:SetPos(self:GetPos() +Vector(0,0,self.HeightOffset))
				self.ViewMode = GetConVarNumber("vj_persona_dancemode")
				if self.ViewMode != 0 then
					self:GetCreator():SetNWEntity("Persona_Dancer",self)
					self:GetCreator():SetNWInt("Persona_DanceMode",self.ViewMode)
					self:GetCreator():SetNWString("Persona_DanceBone",self.ViewBone)
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
function ENT:Think()
	self:HandleKeys(IsValid(self.Creator) && self.Creator)
	if CurTime() > self.NextDanceT then
		local song = VJ_PICK(self.SoundTracks)
		local anim = self.Animations[song.dance][1].anim
		local delay = self.SongStartAnimationDelay
		self:StartLamp()
		local t = self:PlayAnimation(anim,1,0,1,anim) +delay +0.1
		if IsValid(self.Creator) && self.ViewMode == 2 then
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
	self:NextThink(CurTime())
	return true
end
---------------------------------------------------------------------------------------------------------------------------------------------
function ENT:OnRemove()
	SafeRemoveEntity(self.Lamp)
	if IsValid(self.Creator) then
		self.Creator:SetNWEntity("Persona_Dancer",NULL)
		self.Creator:SetNWInt("Persona_DanceMode",0)
		self.Creator:SetNWString("Persona_DanceBone",nil)
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
	*** Copyright (c) 2012-2020 by DrVrej, All rights reserved. ***
	No parts of this code or any of its contents may be reproduced, copied, modified or adapted,
	without the prior written consent of the author, unless otherwise indicated for persona-alone materials.
--------------------------------------------------*/