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
---------------------------------------------------------------------------------------------------------------------------------------------
function ENT:FadeIn()
	self:SetRenderMode(RENDERMODE_TRANSADD)
	-- self:SetRenderFX(kRenderFxSolidSlow)
	self:SetKeyValue("RenderFX",kRenderFxSolidSlow)
	-- self:SetColor(Color(255,255,255,255))
end
---------------------------------------------------------------------------------------------------------------------------------------------
function ENT:FadeOut()
	self:SetRenderMode(RENDERMODE_TRANSADD)
	self:SetKeyValue("RenderFX",kRenderFxFadeSlow)
	-- self:SetRenderFX(kRenderFxFadeSlow)
end
---------------------------------------------------------------------------------------------------------------------------------------------
function ENT:PlaySet(skill,name,rate,cycle)
	local seq = self.Animations[name]
	local canDo = {"idle","melee","range","idle_low"}
	if name == "idle" then
		self:FadeIn()
	end
	if name == "melee" then
		timer.Simple(self:GetSequenceDuration(self,self.Animations["melee"]) *0.5,function()
			if IsValid(self) then self:FadeOut() end
		end)
	end
	if name == "range_end" then
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
		return name == "range_end" && self:GetSequenceDuration(self,self.Animations["range"]) *1.5 or 0
	end
end