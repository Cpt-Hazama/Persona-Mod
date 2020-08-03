ENT.Base 			= "base_gmodentity"
ENT.Type 			= "anim"
ENT.PrintName 		= ""
ENT.Author 			= "Cpt. Hazama"
ENT.Contact 		= ""
ENT.Purpose 		= ""
ENT.Instructions 	= ""
ENT.Category		= ""

ENT.Spawnable = false
ENT.AdminOnly = false
ENT.AutomaticFrameAdvance = true

ENT.IsPersona = true
ENT.ControlType = 1 -- 1 = Follow User, 2 = User Controls
---------------------------------------------------------------------------------------------------------------------------------------------
if SERVER then
	util.AddNetworkString("Persona_SetName")
end
---------------------------------------------------------------------------------------------------------------------------------------------
function ENT:HandleEvents(skill,animBlock,seq,t)
	// Custom code here
	/*
		skill = The Skill in which this was called from
		animBlock = The pre-set name in the Animations table for the sequence
		seq = The sequence that has just been set to play
		t = The length of the sequence in seconds
	*/
end
---------------------------------------------------------------------------------------------------------------------------------------------
function ENT:SetupDataTables()
	self:NetworkVar("Bool",0,"Critical")
end
---------------------------------------------------------------------------------------------------------------------------------------------
function ENT:SetFeedName(name,class)
	net.Start("Persona_SetName")
		net.WriteString(name)
		net.WriteString(class)
	net.Broadcast()
end
---------------------------------------------------------------------------------------------------------------------------------------------
if CLIENT then
	net.Receive("Persona_SetName",function(len)
		local name = net.ReadString()
		local class = net.ReadString()

		language.Add(class,name)
		killicon.Add(class,"HUD/killicons/default",Color(255,80,0,255))
	end)
end
---------------------------------------------------------------------------------------------------------------------------------------------
function ENT:PlaySet(skill,name,rate,cycle)
	local seq = self.Animations[name]
	return self:PlayAnimation(seq,rate,cycle,name,skill)
end
---------------------------------------------------------------------------------------------------------------------------------------------
function ENT:PlayAnimation(seq,rate,cycle,tbName,skill)
	self:ResetSequence(seq)
	self:SetPlaybackRate(rate)
	self:SetCycle(cycle or 0)
	local t = self:GetSequenceDuration(self,seq)
	self:HandleEvents(skill or "BLANK",tbName or "N/A",seq,t)
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
function ENT:GetAnimation()
	return self:GetSequenceName(self:GetSequence())
end
---------------------------------------------------------------------------------------------------------------------------------------------
function ENT:SetTask(task)
	self.CurrentTask = task
	self.CurrentTaskID = PERSONA_TASKS[task]
end
---------------------------------------------------------------------------------------------------------------------------------------------
function ENT:GetTask()
	return self.CurrentTask
end
---------------------------------------------------------------------------------------------------------------------------------------------
function ENT:GetTaskID()
	return self.CurrentTaskID
end
---------------------------------------------------------------------------------------------------------------------------------------------
if (CLIENT) then
	function ENT:Draw()
		self:DrawModel()
	end
	
	function ENT:DrawTranslucent()
		self:Draw()
	end
end
---------------------------------------------------------------------------------------------------------------------------------------------
sound.Add({
	name = "PERSONA_MEGIDOLAON",
	channel = CHAN_STATIC,
	volume = 1.0,
	level = 125,
	sound = "cpthazama/persona5/skills/megidolaon.wav"
})