ENT.Base 			= "npc_vj_creature_base"
ENT.Type 			= "ai"
ENT.PrintName 		= ""
ENT.Author 			= "Cpt. Hazama"
ENT.Contact 		= ""
ENT.Purpose 		= ""
ENT.Instructions 	= ""
ENT.Category		= "NPC"

VJ_AddSound("VJ_YALD_NOMERCY","cpthazama/persona5/yaldabaoth/00000_streaming.wav")
VJ_AddSound("VJ_YALD_CONDEMYOU","cpthazama/persona5/yaldabaoth/00001_streaming.wav")
VJ_AddSound("VJ_YALD_YOURPUNISHMENT","cpthazama/persona5/yaldabaoth/00002_streaming.wav")
VJ_AddSound("VJ_YALD_SENTENCEYOU","cpthazama/persona5/yaldabaoth/00003_streaming.wav")
VJ_AddSound("VJ_YALD_DEATHGRASPYOU","cpthazama/persona5/yaldabaoth/00004_streaming.wav")
VJ_AddSound("VJ_YALD_BEGONE","cpthazama/persona5/yaldabaoth/00005_streaming.wav")
VJ_AddSound("VJ_YALD_ENOUGHCHILDREN","cpthazama/persona5/yaldabaoth/00006_streaming.wav")
VJ_AddSound("VJ_YALD_CRUSHYOU","cpthazama/persona5/yaldabaoth/00007_streaming.wav")
VJ_AddSound("VJ_YALD_SHATTER","cpthazama/persona5/yaldabaoth/00008_streaming.wav")
VJ_AddSound("VJ_YALD_TODUST","cpthazama/persona5/yaldabaoth/00009_streaming.wav")
VJ_AddSound("VJ_YALD_NOESCAPE","cpthazama/persona5/yaldabaoth/00010_streaming.wav")
VJ_AddSound("VJ_YALD_WHAT","cpthazama/persona5/yaldabaoth/00011_streaming.wav")
VJ_AddSound("VJ_YALD_HOWDAREYOU","cpthazama/persona5/yaldabaoth/00012_streaming.wav")
VJ_AddSound("VJ_YALD_FITTINGEND","cpthazama/persona5/yaldabaoth/00013_streaming.wav")
VJ_AddSound("VJ_YALD_EXPECTEDRESULT","cpthazama/persona5/yaldabaoth/00014_streaming.wav")
VJ_AddSound("VJ_YALD_ENDISNIGH","cpthazama/persona5/yaldabaoth/00015_streaming.wav")
VJ_AddSound("VJ_YALD_UNSIGHTLY","cpthazama/persona5/yaldabaoth/00016_streaming.wav")
VJ_AddSound("VJ_YALD_STOPFOOLS","cpthazama/persona5/yaldabaoth/00017_streaming.wav")
VJ_AddSound("VJ_YALD_SHREWDFOOLS","cpthazama/persona5/yaldabaoth/00018_streaming.wav")
VJ_AddSound("VJ_YALD_IMPOSSIBLE","cpthazama/persona5/yaldabaoth/00019_streaming.wav")
VJ_AddSound("VJ_YALD_IMPOSSINGAGOD","cpthazama/persona5/yaldabaoth/00020_streaming.wav")
VJ_AddSound("VJ_YALD_LAUGH","cpthazama/persona5/yaldabaoth/00021_streaming.wav")
VJ_AddSound("VJ_YALD_WHATSTHEMATTER","cpthazama/persona5/yaldabaoth/00022_streaming.wav")
VJ_AddSound("VJ_YALD_BEGFORLIFE","cpthazama/persona5/yaldabaoth/00023_streaming.wav")
VJ_AddSound("VJ_YALD_BOWDOWN","cpthazama/persona5/yaldabaoth/00024_streaming.wav")
VJ_AddSound("VJ_YALD_LOWERGUNS","cpthazama/persona5/yaldabaoth/00025_streaming.wav")
VJ_AddSound("VJ_YALD_IAMAGOD","cpthazama/persona5/yaldabaoth/00026_streaming.wav")
VJ_AddSound("VJ_YALD_MERELYHUMAN","cpthazama/persona5/yaldabaoth/00027_streaming.wav")
VJ_AddSound("VJ_YALD_HEREITCOMES","cpthazama/persona5/yaldabaoth/00028_streaming.wav")
VJ_AddSound("VJ_YALD_PERISH","cpthazama/persona5/yaldabaoth/00029_streaming.wav")
VJ_AddSound("VJ_YALD_UGH","cpthazama/persona5/yaldabaoth/00030_streaming.wav")
VJ_AddSound("VJ_YALD_IMBECILE","cpthazama/persona5/yaldabaoth/00031_streaming.wav")

ENT.VJ_PersonaNPC = true
ENT.VJ_Persona_HasTheme = true

if CLIENT then
	
	function ENT:PlayMusic(bMode)
		if GetConVarNumber("vj_persona_music") == 1 then
			local ply = LocalPlayer()
			ply.VJ_Persona_ThemeTrack = self.Theme
			ply.VJ_Persona_Theme = CreateSound(ply,ply.VJ_Persona_ThemeTrack)
			ply.VJ_Persona_Theme:SetSoundLevel(0)
			ply.VJ_Persona_Theme:ChangeVolume(60)
			ply.VJ_Persona_Theme:Play()
			ply.VJ_Persona_ThemeT = CurTime() +self.ThemeT
		end
	end
	
	function ENT:ToggleTheme(bMode)
		self.VJ_Persona_HasTheme = bMode
		if bMode == true then -- Turn on
			self:PlayMusic()
		else -- Turn off
			if ply.VJ_Persona_Theme then ply.VJ_Persona_Theme:FadeOut(1) end
			ply.VJ_Persona_ThemeT = 0
		end
	end
	
	function ENT:Think()
		local ply = LocalPlayer()
		if GetConVarNumber("vj_persona_music") == 0 then
			if ply.VJ_Persona_Theme then ply.VJ_Persona_Theme:Stop() end
		end
		if ply.VJ_Persona_ThemeT == nil then ply.VJ_Persona_ThemeT = 0 end
		if self.VJ_Persona_HasTheme then
			if ply.VJ_Persona_Theme == nil or ply.VJ_Persona_ThemeT < CurTime() then
				if ply.VJ_Persona_Theme then ply.VJ_Persona_Theme:Stop() end
				self:PlayMusic()
			end
		end
	end
	
	function ENT:Initialize()
		self.Theme = "cpthazama/persona_resource/music/Yaldabaoth.mp3"
		self.ThemeT = 180
	end
	
	function ENT:OnRemove()
		local found = false
		for _,v in pairs(ents.FindByClass(self:GetClass())) do
			if v != self then
				found = true
				break
			end
		end
		local ply = LocalPlayer()
		if ply.VJ_Persona_Theme && ply.VJ_Persona_ThemeTrack == self.Theme && found == false then
			ply.VJ_Persona_Theme:FadeOut(2)
			ply.VJ_Persona_ThemeT = 0
			ply.VJ_Persona_ThemeTrack = "common/null.wav"
		end
	end
end