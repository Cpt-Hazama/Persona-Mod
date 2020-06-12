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
function ENT:PlayAnimation(seq,rate,cycle)
	self:ResetSequence(seq)
	self:SetPlaybackRate(rate)
	self:SetCycle(cycle or 0)
	return self:GetSequenceDuration(self,seq)
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
	self.CurrentTaskID = STAND_TASKS[task]
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