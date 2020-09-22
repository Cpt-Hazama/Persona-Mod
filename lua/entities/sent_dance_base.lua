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
ENT.DelayBetweenAnimations = 0.05
ENT.SongStartDelay = 0
ENT.SongStartAnimationDelay = 0
ENT.HasLamp = true

ENT.Animations = {}
-- ENT.Animations["dance_lastsurprise"] = {}
-- ENT.Animations["dance_lastsurprise"][1] = {anim = "dance_lastsurprise",next = "dance_lastsurprise2"}
-- ENT.Animations["dance_lastsurprise"][2] = {anim = "dance_lastsurprise2",next = "dance_lastsurprise4"}
-- ENT.Animations["dance_lastsurprise"][3] = {anim = "dance_lastsurprise4",next = "dance_lastsurprise2"}
-- ENT.Animations["dance_lastsurprise"][4] = {anim = "dance_lastsurprise2",next = "dance_lastsurprise5"}
-- ENT.Animations["dance_lastsurprise"][5] = {anim = "dance_lastsurprise5",next = "dance_lastsurprise3"}
-- ENT.Animations["dance_lastsurprise"][6] = {anim = "dance_lastsurprise3",next = "dance_lastsurprise6"}
-- ENT.Animations["dance_lastsurprise"][7] = {anim = "dance_lastsurprise6",next = false}

ENT.SoundTracks = {
	-- [1] = {dance = "dance_lastsurprise", song = "cpthazama/persona5_dance/music/h015.mp3"}
}
---------------------------------------------------------------------------------------------------------------------------------------------
if SERVER then
	function ENT:OnInit() end

	function ENT:HandleAnimationEvent(seq,event,frame) end

	function ENT:OnPlayDance(seq,t) end

	util.AddNetworkString("Persona_Dance_Song")
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

	net.Receive("Persona_Dance_Song",function(len)
		local dir = net.ReadString()
		local ply = net.ReadEntity()
		local me = net.ReadEntity()

		if ply.VJ_Persona_Dance_Theme && ply.VJ_Persona_Dance_ThemeDir == dir then ply.VJ_Persona_Dance_Theme:Stop() end
		timer.Simple(me.SongStartDelay,function()
			if IsValid(ply) then
				ply.VJ_Persona_Dance_ThemeDir = dir
				ply.VJ_Persona_Dance_Theme = CreateSound(ply,dir)
				ply.VJ_Persona_Dance_Theme:SetSoundLevel(0)
				ply.VJ_Persona_Dance_Theme:ChangeVolume(60)
				ply.VJ_Persona_Dance_Theme:Play()
			end
		end)
	end)

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
function ENT:PlayAnimation(seq,rate,cycle,index,name,noReset)
	local sT = index == 1 && self.SongStartAnimationDelay or 0
	local t = self:GetSequenceDuration(self,seq)
	timer.Simple(sT,function()
		if IsValid(self) then
			self:ResetSequence(seq)
			self:SetPlaybackRate(rate)
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
			t = self:GetSequenceDuration(self,seq)
			if self.Index == 0 then
				self.Index = 1
			end
			if self.Animations[name][index].next then
				timer.Simple(t -self.DelayBetweenAnimations,function()
					if IsValid(self) then
						local anim = self.Animations[name][index].next
						self.Index = self.Index +1
						-- Entity(1):ChatPrint("Was Playing - " .. seq .. " | Now Playing - " .. anim .. " | Next Play - " .. (self.Animations[name][index +1] != nil && self.Animations[name][index +1].next) or " N/A")
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
function ENT:ChangeFace(t,id)
	local t = t or 0
	local id = id or 0
	timer.Simple(t,function()
		if IsValid(self) then
			self:SetBodygroup(1,id)
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

	self.Index = 0
	self.NextDanceT = CurTime()
	self.AnimationEvents = {}

	timer.Simple(0,function()
		if IsValid(self) then
			if IsValid(self:GetCreator()) && self:GetCreator():IsPlayer() then
				self:SetPos(self:GetPos() +Vector(0,0,self.HeightOffset))
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
		endpos = self:GetPos() +self:GetForward() *200 +Vector(0,0,self:OBBMaxs().z *2),
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
	self.Lamp:SetBrightness(4)
	-- self.Lamp:SetFashlightTexture("sprites/lamphalo")
	-- self.Lamp:SetFashlightTexture("engine/lightsprite")
	self.Lamp:SetColor(Color(255,255,255))
	if IsValid(self.Lamp.flashlight) then
		self.Lamp.flashlight:SetColor(Color(255,255,255))
		self.Lamp.flashlight:Input("SpotlightTexture",NULL,NULL,"engine/lightsprite")
	end
	self.Lamp:SetCollisionGroup(COLLISION_GROUP_IN_VEHICLE)
	local phys = self:GetPhysicsObject()
	if IsValid(phys) then phys:Sleep() end
end
---------------------------------------------------------------------------------------------------------------------------------------------
function ENT:Think()
	if CurTime() > self.NextDanceT then
		local song = VJ_PICK(self.SoundTracks)
		local anim = self.Animations[song.dance][1].anim
		local delay = self.SongStartAnimationDelay
		self:StartLamp()
		local t = self:PlayAnimation(anim,1,0,1,anim) +delay +0.1
		self.NextDanceT = CurTime() +t
	end
	if IsValid(self.Lamp) then
		self.Lamp:SetAngles((self:GetBonePosition(1) -self.Lamp:GetPos()):Angle())
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
end
/*--------------------------------------------------
	*** Copyright (c) 2012-2020 by DrVrej, All rights reserved. ***
	No parts of this code or any of its contents may be reproduced, copied, modified or adapted,
	without the prior written consent of the author, unless otherwise indicated for persona-alone materials.
--------------------------------------------------*/