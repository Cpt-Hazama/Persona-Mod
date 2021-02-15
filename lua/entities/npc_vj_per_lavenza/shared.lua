ENT.Base 			= "npc_vj_per_character_base"
ENT.Type 			= "ai"
ENT.PrintName 		= ""
ENT.Author 			= "Cpt. Hazama"
ENT.Contact 		= ""
ENT.Purpose 		= ""
ENT.Instructions 	= ""
ENT.Category		= "NPC"

-- include("social_link.lua")

ENT.VJ_PersonaNPC = true
ENT.VJ_Persona_HasTheme = true

function ENT:SetupDataTables()
	self:NetworkVar("Bool",0,"Speaking")
	self:NetworkVar("Entity",0,"SpeakingTo")
end

if CLIENT then
	local lerp_hp = 0
	
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
		self.Theme = "cpthazama/persona5/music/boss_lavenza.mp3"
		self.ThemeT = 315
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
		hook.Remove("HUDPaint","VJ_Persona_HUD_Lavenza")
		hook.Remove("HUDPaint","VJ_Persona_HUD_Lavenza_Speech")
	end

	net.Receive("vj_persona_hud_lavenza_speech",function(len,pl)
		local delete = net.ReadBool()
		local ent = net.ReadEntity()
		local ply = net.ReadEntity()
		local text = net.ReadString()
		local text2 = net.ReadString()
		local text3 = net.ReadString()
		local text4 = net.ReadString()
		local text5 = net.ReadString()

		local matMain = Material("hud/persona/social/lavenza/main.png")
		local matE1 = Material("hud/persona/social/lavenza/eyes1.png")
		local matE2 = Material("hud/persona/social/lavenza/eyes2.png")
		local matEyes = matE2
		local matM1 = Material("hud/persona/social/lavenza/m1.png")
		local matM2 = Material("hud/persona/social/lavenza/m2.png")
		local matM3 = Material("hud/persona/social/lavenza/m3.png")
		local matMouth = matM1
		local posX = 700
		local posY = 600
		local len = 600
		local height = 600
		local ctEyes = CurTime() +math.Rand(0.3,1.5)
		local ctM = CurTime() +0.1
		local name = "Lavenza"
		local dPos = 15
		local dPos1 = dPos *4
		local dPos2 = dPos *6
		local dPos3 = dPos *8
		local dPos4 = dPos *10
		local dPos5 = dPos *12

		hook.Add("HUDPaint","VJ_Persona_HUD_Lavenza_Speech",function()
			local corners = 1
			local boxposX = 1200
			local boxposY = 250
			local boxlen = 900
			local boxheight = 230
			local colM = 35
			local color = Color(colM,colM,colM,255)
			draw.RoundedBox(corners,ScrW() -boxposX,ScrH() -boxposY,boxlen,boxheight,color)

			local tposX = boxposX -15
			local tposY = boxposY -15
			local color = Color(0,100,255,255)
			draw.SimpleText(name,"Persona",ScrW() -tposX,ScrH() -tposY,color)

			local tposX = boxposX -15
			local tposY = boxposY -dPos1
			local color = Color(0,100,255,255)
			draw.SimpleText(text,"Persona",ScrW() -tposX,ScrH() -tposY,color)

			if text2 != "" then
				local tposX = boxposX -15
				local tposY = boxposY -dPos2
				local color = Color(0,100,255,255)
				draw.SimpleText(text2,"Persona",ScrW() -tposX,ScrH() -tposY,color)
			end

			if text3 != "" then
				local tposX = boxposX -15
				local tposY = boxposY -dPos3
				local color = Color(0,100,255,255)
				draw.SimpleText(text3,"Persona",ScrW() -tposX,ScrH() -tposY,color)
			end

			if text4 != "" then
				local tposX = boxposX -15
				local tposY = boxposY -dPos4
				local color = Color(0,100,255,255)
				draw.SimpleText(text4,"Persona",ScrW() -tposX,ScrH() -tposY,color)
			end

			if text5 != "" then
				local tposX = boxposX -15
				local tposY = boxposY -dPos5
				local color = Color(0,100,255,255)
				draw.SimpleText(text5,"Persona",ScrW() -tposX,ScrH() -tposY,color)
			end

			surface.SetMaterial(matMain)
			surface.SetDrawColor(Color(255,255,255,255))
			surface.DrawTexturedRect(ScrW() -posX,ScrH() -posY,len,height)
			
			if CurTime() > ctEyes then
				matEyes = matE2
				timer.Simple(0.15,function()
					matEyes = matE1
				end)
				timer.Simple(0.3,function()
					matEyes = matE2
				end)
				ctEyes = CurTime() +math.Rand(3,8)
			end
			local EposX = 575
			local EposY = 338
			local Elen = 300
			local Eheight = 150
			surface.SetMaterial(matEyes)
			surface.SetDrawColor(Color(255,255,255,255))
			surface.DrawTexturedRect(ScrW() -EposX,ScrH() -EposY,Elen,Eheight)
			if CurTime() > ctM then
				matMouth = matM2
				timer.Simple(0.15,function()
					matMouth = matM3
				end)
				timer.Simple(0.3,function()
					matMouth = matM1
				end)
				ctM = CurTime() +math.Rand(0.35,0.7)
			end
			local MposX = 500
			local MposY = 185
			local Mlen = 150
			local Mheight = 80
			surface.SetMaterial(matMouth)
			surface.SetDrawColor(Color(255,255,255,255))
			surface.DrawTexturedRect(ScrW() -MposX,ScrH() -MposY,Mlen,Mheight)
		end)
		if delete == true then hook.Remove("HUDPaint","VJ_Persona_HUD_Lavenza_Speech") end
	end)

	net.Receive("vj_persona_hud_lavenza",function(len,pl)
		local delete = net.ReadBool()
		local ent = net.ReadEntity()
		hook.Add("HUDPaint","VJ_Persona_HUD_Lavenza",function()
			if !IsValid(ent) then return end
			local persona = ent:GetPersona()
			local card = (IsValid(persona) && persona:GetNW2String("SpecialAttack")) or "BLANK"
			local name = ent:GetPersonaName()
			draw.RoundedBox(1,ScrW() /1.79,ScrH() -120,220,80,Color(0,0,0,150))
			draw.SimpleText("Persona: " .. string.SetChar(name,1,string.upper(string.sub(name,1,1))),"VJFont_Trebuchet24_SmallMedium",ScrW() /1.75,ScrH() -115,Color(255,255,255,255),0,0)

			if persona then
				draw.SimpleText("Skill Card: " .. card,"VJFont_Trebuchet24_SmallMedium",ScrW() /1.75,ScrH() -68,Color(255,255,255,255),0,0)
			end

			local hp = ent:GetSP()
			local maxhp = ent:GetMaxSP()
			local hp_r = 200
			local hp_g = 0
			local hp_b = 255
			lerp_hp = Lerp(5 *FrameTime(),lerp_hp,hp)
			draw.RoundedBox(0,ScrW() /1.75,ScrH() -95,180,20,Color(hp_r,hp_g,hp_b,40))
			draw.RoundedBox(0,ScrW() /1.75,ScrH() -95,(190 *math.Clamp(lerp_hp,0,maxhp)) /maxhp,20,Color(hp_r,hp_g,hp_b,255))
			surface.SetDrawColor(hp_r,hp_g,hp_b,255)
			surface.DrawOutlinedRect(ScrW() /1.75,ScrH() -95,180,20)

			local finalhp = tostring(string.format("%.0f", lerp_hp).."/"..maxhp)
			local distlen = string.len(finalhp)
			local move = 0
			if distlen > 1 then
				move = move -(0.009 *(distlen -1))
			end
			draw.SimpleText(finalhp,"VJFont_Trebuchet24_SmallMedium", ScrW() /(1.6 -move),ScrH() -94,Color(255,255,255,255),0,0)
		end)
		if delete == true then hook.Remove("HUDPaint","VJ_Persona_HUD_Lavenza") end
	end)
end