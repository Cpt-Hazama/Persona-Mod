
ENT.SocialInteractions = {
	[0] = {
		OnSpokenTo = {
			ID = 1,
			Chat = {
				[1] = "Oh hello, just who might you be?",
			},
			Expression = "neutral",
			Feedback = true,
			FeedbackChat = {
				[1] = "My name is [P_NICK].",
				[2] = "You first.",
				[3] = "Uhh...",
			},
			EndChat = false
		},
		RecieveFeedback = {
			ID = 2,
			Chat = {
				[1] = "Nice to meet you [P_NICK].",
				[2] = "My name is Makoto Niijima, I'm the Student Council President of Shujin Academy.",
				[3] = "...Was it something I said?",
			},
			Expression = "neutral",
			Feedback = false,
			FeedbackChat = {},
			EndChat = false
		},
		Cont = {
			ID = 3,
			Chat = {
				[1] = "Well, I have to get going. I was on my way back home. It was a pleasure speaking to you.",
			},
			Expression = "neutral",
			Feedback = false,
			FeedbackChat = {},
			EndChat = true
		},
	}
}

function ENT:SetUpSocialLinkData()
	self.SocialLinkData = {}
	for i = 0,#self.SocialInteractions do
		self:SetSocialLinkData(i,self.SocialInteractions[i])
	end
end

function ENT:SetSocialLinkData(rank,data)
	self.SocialLinkData = {Rank = rank,Layout = data}
	-- PrintTable(self.SocialLinkData)
end