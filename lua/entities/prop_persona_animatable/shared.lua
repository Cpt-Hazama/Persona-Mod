if (!file.Exists("autorun/vj_base_autorun.lua","LUA")) then return end

ENT.Base 			= "base_gmodentity"
ENT.Type 			= "anim"
ENT.PrintName 		= "VJ Prop Animatable"
ENT.Author 			= "DrVrej"
ENT.Contact 		= "http://steamcommunity.com/groups/vrejgaming"
ENT.Purpose 		= "Used to make simple props and animate them, since prop_dynamic doesn't work properly in Garry's Mod."
ENT.Instructions 	= "Don't change anything."
ENT.Category		= "VJ Base"

ENT.Spawnable = false
ENT.AdminOnly = false
ENT.AutomaticFrameAdvance = true
---------------------------------------------------------------------------------------------------------------------------------------------
function ENT:PlayAnimation(anim,rate,cycle)
	self:ResetSequence(anim)
	self:SetPlaybackRate(rate or 1)
	self:SetCycle(cycle or 0)

	local t = VJ_GetSequenceDuration(self,anim)
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

	function ENT:ResetFlex(name)
		if name == true then
			for i = 0,self:GetFlexNum() -1 do
				self:ChangeFlex(self:GetFlexName(i),0,20)
			end
			return
		end
		self:ChangeFlex(name,0,20)
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
		
		for ind,flex in ipairs(self.Flexes) do
			if flex then
				local id = self:GetFlexIDByName(flex.Name)
				if !id then MsgN("Failed to load flex [" .. flex.Name .. "] on " .. tostring(self) .. "!") table.remove(self.Flexes,ind) return end
				local oldVal = self:GetFlexWeight(id)
				local target = flex.Target
				if (math.abs(target -oldVal) > 0.0125) then
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
	
	function ENT:DrawTranslucent()
		self:Draw()
	end

	net.Receive("Persona_Dance_ChangeFlex",function(len)
		local dancer = net.ReadEntity()
		local flex = net.ReadString()
		local val = net.ReadFloat(32)
		local speed = net.ReadInt(32)

		dancer:ChangeFlex(flex,val,speed)
	end)

	net.Receive("Persona_Dance_RemoveFlexes",function(len)
		local dancer = net.ReadEntity()
		local tbl = net.ReadTable()

		for i = 0,dancer:GetFlexNum() -1 do
			local cName = dancer:GetFlexName(i)
			if !VJ_HasValue(tbl,cName) && cName != "blink" then
				dancer:ChangeFlex(cName,0,15)
			end
		end
	end)

	net.Receive("Persona_Dance_ResetFlex",function(len)
		local dancer = net.ReadEntity()

		dancer:ResetFlex(true)
	end)
end
