if (!file.Exists("autorun/vj_base_autorun.lua","LUA")) then return end
AddCSLuaFile("shared.lua")
include("shared.lua")
/*--------------------------------------------------
	=============== VJ Prop Animatable Entity ===============
	*** Copyright (c) 2012-2020 by DrVrej, All rights reserved. ***
	No parts of this code or any of its contents may be reproduced, copied, modified or adapted,
	without the prior written consent of the author, unless otherwise indicated for stand-alone materials.
INFO: Used to make simple props and animate them, since prop_dynamic doesn't work properly in Garry's Mod...
--------------------------------------------------*/
---------------------------------------------------------------------------------------------------------------------------------------------
function ENT:Initialize()
	self:SetSolid(SOLID_OBB)
end
---------------------------------------------------------------------------------------------------------------------------------------------
function ENT:RandomizeExpressions(flexes,anim,frames,chance)
	local chance = chance or 50

	self.RandomizedFlexes = self.RandomizedFlexes or {}
	self.RandomizedFlexes[anim] = self.RandomizedFlexes[anim] or {}
	for _,v in pairs(flexes) do
		table.insert(self.RandomizedFlexes[anim],v)
	end
	for i = 1,frames do
		if math.random(1,chance) == 1 then
			for _,flex in pairs(flexes) do
				local name, val, speed = flex, math.Rand(0,1), math.Rand(0.1,5)
				self:AddFlexEvent(anim,i,{Name=name,Value=val,Speed=speed},frames)
				-- print(name,val,speed)
			end
		end
	end
end
---------------------------------------------------------------------------------------------------------------------------------------------
function ENT:HandleAnimationEvent(seq,event,frame) end
---------------------------------------------------------------------------------------------------------------------------------------------
function ENT:Think()
	local seq = self:GetSequence()
	local findSeq = self.RegisteredSequences && self.RegisteredSequences[seq]
	local eventSeq = self.AnimationEvents && self.AnimationEvents[seq]
	if (eventSeq && findSeq) then
		if self.LastSequence != seq then
			self.LastSequence = seq
			self.LastFrame = -1
		end
		local NextFrame = math.floor(self:GetCycle() *(self:GetPlaybackRate() *findSeq))
		self.LastFrame = NextFrame
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
	self:NextThink(CurTime())
	return true
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
function ENT:SendFlexData(name,value,speed)
	net.Start("Persona_Dance_ChangeFlex")
		net.WriteEntity(self)
		net.WriteString(name)
		net.WriteFloat(value,32)
		net.WriteInt(speed,32)
	net.Broadcast()
end
---------------------------------------------------------------------------------------------------------------------------------------------
function ENT:ResetFlexes()
	net.Start("Persona_Dance_ResetFlex")
		net.WriteEntity(self)
	net.Broadcast()
end
---------------------------------------------------------------------------------------------------------------------------------------------
function ENT:RemoveOldFlexes(tbl)
	net.Start("Persona_Dance_RemoveFlexes")
		net.WriteEntity(self)
		net.WriteTable(tbl)
	net.Broadcast()
end
---------------------------------------------------------------------------------------------------------------------------------------------
function ENT:HandleRandomFlex(seq,frame)
	for _,v in pairs(self.RandomFlex[seq][frame]) do
		-- Entity(1):ChatPrint(v.Name .. " | " .. v.Value .. " | " .. v.Speed .. " | " .. frame)
		self:RemoveOldFlexes(self.RandomizedFlexes[self:GetSequenceName(self:GetSequence())])
		self:SendFlexData(v.Name,v.Value,v.Speed)
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
/*--------------------------------------------------
	=============== VJ Prop Animatable Entity ===============
	*** Copyright (c) 2012-2020 by DrVrej, All rights reserved. ***
	No parts of this code or any of its contents may be reproduced, copied, modified or adapted,
	without the prior written consent of the author, unless otherwise indicated for stand-alone materials.
INFO: Used to make simple props and animate them, since prop_dynamic doesn't work properly in Garry's Mod...
--------------------------------------------------*/
