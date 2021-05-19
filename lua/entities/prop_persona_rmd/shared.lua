ENT.Base 			= "prop_persona"
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
ENT.IsPersonaRMD = true

ENT.AllowFading = true
---------------------------------------------------------------------------------------------------------------------------------------------
function ENT:PlaySet(skill,name,rate,cycle)
	local seq = self.Animations[name]
	local canDo = {"idle","melee","range","idle_low"}
	if name == "idle" then
		self:FadeIn()
	end
	if name == "melee" then
		-- timer.Simple(self:GetSequenceDuration(self,self.Animations["melee"]) *0.5,function()
			-- if IsValid(self) && IsValid(self.User) then
				-- local battleEnt = self.User:GetNW2Entity("BattleEnt")
				-- local target = self.User:GetNW2Entity("Persona_Target")
				-- if IsValid(battleEnt) && IsValid(target) then
					-- battleEnt:SetNW2Entity("CurrentTurnEntity",target)
				-- end
			-- end
		-- end)
		timer.Simple(self:GetSequenceDuration(self,self.Animations["melee"]) *0.5,function()
			if IsValid(self) then self:FadeOut() end
		end)
		timer.Simple(self:GetSequenceDuration(self,self.Animations["melee"]),function()
			if IsValid(self) then self:OnFinishedAttack(skill) end
		end)
	end
	if name == "range_idle" then
		-- if IsValid(self) && IsValid(self.User) then
			-- local battleEnt = self.User:GetNW2Entity("BattleEnt")
			-- local target = self.User:GetNW2Entity("Persona_Target")
			-- if IsValid(battleEnt) && IsValid(target) then
				-- battleEnt:SetNW2Entity("CurrentTurnEntity",target)
			-- end
		-- end
	end
	if name == "range_end" then
		timer.Simple(self:GetSequenceDuration(self,self.Animations["range"]),function()
			if IsValid(self) then self:OnFinishedAttack(skill) end
		end)
		timer.Simple(self:GetSequenceDuration(self,self.Animations["range"]) *0.5,function()
			if IsValid(self) then self:FadeOut() end
		end)
	end
	if VJ_HasValue(canDo,name) then
		-- self.User:ChatPrint(name .. "/" .. seq)
		-- self.User:ChatPrint("Regular")
		return self:PlayAnimation(seq,rate,cycle,name,skill)
	else
		-- self.User:ChatPrint(name .. "/" .. seq)
		-- self.User:ChatPrint("Set to Zero")
		self:HandleEvents(skill or "BLANK",tbName or "N/A",nil,0)
		if IsValid(self.User) && self.User:IsNPC() && self.User.OnPersonaAnimation then
			self.User:OnPersonaAnimation(self,skill or "BLANK",tbName or "N/A",nil,0)
		end
		local t = name == "range_end" && self:GetSequenceDuration(self,self.Animations["range"]) *1.5 or 0
		timer.Simple(t -0.01,function()
			if IsValid(self) then
				self:FadeIn()
			end
		end)
		return t
	end
end