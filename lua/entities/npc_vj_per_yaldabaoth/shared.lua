ENT.Base 			= "npc_vj_creature_base"
ENT.Type 			= "ai"
ENT.PrintName 		= ""
ENT.Author 			= "Cpt. Hazama"
ENT.Contact 		= ""
ENT.Purpose 		= ""
ENT.Instructions 	= ""
ENT.Category		= "NPC"

VJ_AddSound("VJ_YALD_NOMERCY","cpthazama/vo/yaldabaoth/00000_streaming.wav")
VJ_AddSound("VJ_YALD_CONDEMYOU","cpthazama/vo/yaldabaoth/00001_streaming.wav")
VJ_AddSound("VJ_YALD_YOURPUNISHMENT","cpthazama/vo/yaldabaoth/00002_streaming.wav")
VJ_AddSound("VJ_YALD_SENTENCEYOU","cpthazama/vo/yaldabaoth/00003_streaming.wav")
VJ_AddSound("VJ_YALD_DEATHGRASPYOU","cpthazama/vo/yaldabaoth/00004_streaming.wav")
VJ_AddSound("VJ_YALD_BEGONE","cpthazama/vo/yaldabaoth/00005_streaming.wav")
VJ_AddSound("VJ_YALD_ENOUGHCHILDREN","cpthazama/vo/yaldabaoth/00006_streaming.wav")
VJ_AddSound("VJ_YALD_CRUSHYOU","cpthazama/vo/yaldabaoth/00007_streaming.wav")
VJ_AddSound("VJ_YALD_SHATTER","cpthazama/vo/yaldabaoth/00008_streaming.wav")
VJ_AddSound("VJ_YALD_TODUST","cpthazama/vo/yaldabaoth/00009_streaming.wav")
VJ_AddSound("VJ_YALD_NOESCAPE","cpthazama/vo/yaldabaoth/00010_streaming.wav")
VJ_AddSound("VJ_YALD_WHAT","cpthazama/vo/yaldabaoth/00011_streaming.wav")
VJ_AddSound("VJ_YALD_HOWDAREYOU","cpthazama/vo/yaldabaoth/00012_streaming.wav")
VJ_AddSound("VJ_YALD_FITTINGEND","cpthazama/vo/yaldabaoth/00013_streaming.wav")
VJ_AddSound("VJ_YALD_EXPECTEDRESULT","cpthazama/vo/yaldabaoth/00014_streaming.wav")
VJ_AddSound("VJ_YALD_ENDISNIGH","cpthazama/vo/yaldabaoth/00015_streaming.wav")
VJ_AddSound("VJ_YALD_UNSIGHTLY","cpthazama/vo/yaldabaoth/00016_streaming.wav")
VJ_AddSound("VJ_YALD_STOPFOOLS","cpthazama/vo/yaldabaoth/00017_streaming.wav")
VJ_AddSound("VJ_YALD_SHREWDFOOLS","cpthazama/vo/yaldabaoth/00018_streaming.wav")
VJ_AddSound("VJ_YALD_IMPOSSIBLE","cpthazama/vo/yaldabaoth/00019_streaming.wav")
VJ_AddSound("VJ_YALD_IMPOSSINGAGOD","cpthazama/vo/yaldabaoth/00020_streaming.wav")
VJ_AddSound("VJ_YALD_LAUGH","cpthazama/vo/yaldabaoth/00021_streaming.wav")
VJ_AddSound("VJ_YALD_WHATSTHEMATTER","cpthazama/vo/yaldabaoth/00022_streaming.wav")
VJ_AddSound("VJ_YALD_BEGFORLIFE","cpthazama/vo/yaldabaoth/00023_streaming.wav")
VJ_AddSound("VJ_YALD_BOWDOWN","cpthazama/vo/yaldabaoth/00024_streaming.wav")
VJ_AddSound("VJ_YALD_LOWERGUNS","cpthazama/vo/yaldabaoth/00025_streaming.wav")
VJ_AddSound("VJ_YALD_IAMAGOD","cpthazama/vo/yaldabaoth/00026_streaming.wav")
VJ_AddSound("VJ_YALD_MERELYHUMAN","cpthazama/vo/yaldabaoth/00027_streaming.wav")
VJ_AddSound("VJ_YALD_HEREITCOMES","cpthazama/vo/yaldabaoth/00028_streaming.wav")
VJ_AddSound("VJ_YALD_PERISH","cpthazama/vo/yaldabaoth/00029_streaming.wav")
VJ_AddSound("VJ_YALD_UGH","cpthazama/vo/yaldabaoth/00030_streaming.wav")
VJ_AddSound("VJ_YALD_IMBECILE","cpthazama/vo/yaldabaoth/00031_streaming.wav")

ENT.VJ_PersonaNPC = true
ENT.VJ_Persona_HasTheme = true

if CLIENT then
	
	-- function ENT:PlayMusic(bMode)
		-- if GetConVarNumber("vj_persona_music") == 1 then
			-- local ply = LocalPlayer()
			-- ply.VJ_Persona_ThemeTrack = self.Theme
			-- ply.VJ_Persona_Theme = CreateSound(ply,ply.VJ_Persona_ThemeTrack)
			-- ply.VJ_Persona_Theme:SetSoundLevel(0)
			-- ply.VJ_Persona_Theme:ChangeVolume(60)
			-- ply.VJ_Persona_Theme:Play()
			-- ply.VJ_Persona_ThemeT = CurTime() +self.ThemeT
		-- end
	-- end
	
	-- function ENT:ToggleTheme(bMode)
		-- self.VJ_Persona_HasTheme = bMode
		-- if bMode == true then -- Turn on
			-- self:PlayMusic()
		-- else -- Turn off
			-- if ply.VJ_Persona_Theme then ply.VJ_Persona_Theme:FadeOut(1) end
			-- ply.VJ_Persona_ThemeT = 0
		-- end
	-- end
	
	-- function ENT:Think()
		-- local ply = LocalPlayer()
		-- if GetConVarNumber("vj_persona_music") == 0 then
			-- if ply.VJ_Persona_Theme then ply.VJ_Persona_Theme:Stop() end
		-- end
		-- if ply.VJ_Persona_ThemeT == nil then ply.VJ_Persona_ThemeT = 0 end
		-- if self.VJ_Persona_HasTheme then
			-- if ply.VJ_Persona_Theme == nil or ply.VJ_Persona_ThemeT < CurTime() then
				-- if ply.VJ_Persona_Theme then ply.VJ_Persona_Theme:Stop() end
				-- self:PlayMusic()
			-- end
		-- end
	-- end
	
	-- function ENT:Initialize()
		-- self.Theme = "cpthazama/persona_resource/music/Yaldabaoth.mp3"
		-- self.ThemeT = 180
	-- end
	
	-- function ENT:OnRemove()
		-- local found = false
		-- for _,v in pairs(ents.FindByClass(self:GetClass())) do
			-- if v != self then
				-- found = true
				-- break
			-- end
		-- end
		-- local ply = LocalPlayer()
		-- if ply.VJ_Persona_Theme && ply.VJ_Persona_ThemeTrack == self.Theme && found == false then
			-- ply.VJ_Persona_Theme:FadeOut(2)
			-- ply.VJ_Persona_ThemeT = 0
			-- ply.VJ_Persona_ThemeTrack = "common/null.wav"
		-- end
	-- end
end