ENT.MaxRank = 6

function ENT:OnInteract(ply)
	if self:GetSpeaking() && self:GetSpeakingTo() != ply then return end
	local lvl = PXP.GetSocialLinkData(ply,"lavenza")
	if lvl <= 0 then
		self:DoSentence(ply,{
			[1] = "Hello there " .. ply:Nick() .. "...",
			[2] = "I've been patiently waiting for you",
			[3] = "to find me. We have much work",
			[4] = "to be done. Come, let us find my",
			[5] = "master.",
		},6,replies,false)
		timer.Simple(6,function()
			if IsValid(self) && IsValid(ply) then
				self:DoSentence(ply,{
					[1] = "I will accompany you for the time",
					[2] = "being. Just come talk to me",
					[3] = "when you're ready to head out.",
					[4] = "Only then can we begin your",
					[5] = "rehibilitation.",
				},6,replies,true)
			end
		end)
		return
	end
end

function ENT:DoSentence(ply,tblText,time,replies,rankup)
	self:SetSpeaking(true)
	self:GetSpeakingTo(ply)
	
	local text = tblText[1]
	local text2 = tblText[2]
	local text3 = tblText[3]
	local text4 = tblText[4]
	local text5 = tblText[5]

    net.Start("vj_persona_hud_lavenza_speech")
		net.WriteBool(false)
		net.WriteEntity(self)
		net.WriteEntity(ply)
		net.WriteString(text)
		net.WriteString(text2)
		net.WriteString(text3)
		net.WriteString(text4)
		net.WriteString(text5)
    net.Send(ply)

	timer.Simple(time,function()
		if IsValid(self) then

			net.Start("vj_persona_hud_lavenza_speech")
				net.WriteBool(true)
				net.WriteEntity(self)
				net.WriteEntity(ply)
				net.WriteString("")
				net.WriteString("")
				net.WriteString("")
				net.WriteString("")
				net.WriteString("")
			net.Send(ply)
			
			if rankup then
				self:SetSpeaking(false)
				self:GetSpeakingTo(NULL)
				if IsValid(ply) then
					PXP.SetSocialLinkData(ply,"lavenza",math.Clamp(PXP.GetSocialLinkData(ply,"lavenza") +1,0,self.MaxRank))
				end
			end
		end
	end)
end