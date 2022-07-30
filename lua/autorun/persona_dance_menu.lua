if CLIENT then
    PERSONA_DANCE_MENU = {}

    function PERSONA_DANCE_MENU:Open(ply,dancer)
        if ply.Persona_DanceMenu_Open == true then
            if ply.Persona_DanceMenu_MainBG then
                ply.Persona_DanceMenu_MainBG:Delete()
                ply.Persona_DanceMenu_MainBG = nil
            end
            self:Close(ply,dancer)
            return
        end

        ply.Persona_DanceMenu_Open = true
	
		local song = dancer.PreviewThemes && VJ_PICK(dancer.PreviewThemes) or "cpthazama/persona3_dance/music/preview.wav"
		sound.PlayFile("sound/" .. song,"noplay noblock",function(station,errCode,errStr)
			if IsValid(station) then
				station:EnableLooping(true)
				station:Play()
				station:SetVolume(GetConVarNumber("vj_persona_dancevol") *0.01)
				station:SetPlaybackRate(GetConVarNumber("host_timescale"))
				ply.Persona_DanceMenu_PreviewTheme = station
			else
				print("Error playing sound!",errCode,errStr)
			end
			return station
		end)

        local scrW = ScrW()
        local scrH = ScrH()
        local colorMain = Color(GetConVarNumber("persona_dance_hud_r"),GetConVarNumber("persona_dance_hud_g"),GetConVarNumber("persona_dance_hud_b"))
        local colorOpposite = Color(255- GetConVarNumber("persona_dance_hud_r"),255- GetConVarNumber("persona_dance_hud_g"),255- GetConVarNumber("persona_dance_hud_b"))

		local menuBackground = vgui.Create("DFrame")
		menuBackground:ShowCloseButton(false)
		menuBackground:SetTitle("")
		menuBackground:SetSize(scrW,scrH)
		menuBackground:Center()
		menuBackground:SetDraggable(false)
		menuBackground:MakePopup()
		menuBackground.y = scrH /2
		menuBackground:MoveTo(0,0,0)
		menuBackground:SetPopupStayAtBack(true)
		menuBackground.Paint = function(self,w,h)
	    	surface.SetDrawColor(Color(255,255,255,0))
			surface.DrawRect(0,0,w,h)
		end
        ply.Persona_DanceMenu_MainBG = menuBackground

		menuBackground.OnKeyCodePressed = function(...)
            local panel,code = ...
			if code == KEY_Z then
				self:Close(ply,dancer)
			end
            -- if code == KEY_BACKSPACE or code == KEY_SPACE or code == KEY_ESCAPE then
            --     self:Close(ply,dancer)
			--     panel:Delete()
            --     ply.Persona_DanceMenu_MainBG = nil
            -- end
			return true
		end

		function menuBackground:Delete()
			menuBackground:AlphaTo(0,0.5,0)
			menuBackground:SetKeyboardInputEnabled(false)
			menuBackground:SetMouseInputEnabled(false)
			menuBackground:Remove()
		end

		local sideBar = vgui.Create("DPanel",menuBackground)
		sideBar:SetSize(scrW,scrH)
		sideBar:SetPos(0,0)

		sideBar.OnKeyCodePressed = function(...)
            local panel,code = ...
			return true
		end

		sideBar.OnMousePressed = function(...)
            local panel,key = ...
			if key == MOUSE_LEFT then
				if ply.Persona_DanceMenu_HoveredOutfit then
					net.Start("Persona_Dance_UpdateOutfit")
						net.WriteString(dancer.Outfits[ply.Persona_DanceMenu_HoveredOutfit].Name)
						net.WriteEntity(dancer)
						net.WriteEntity(ply)
					net.SendToServer()
					surface.PlaySound("cpthazama/persona5/misc/00031.wav")
				elseif ply.Persona_DanceMenu_HoveredDifficulty then
					RunConsoleCommand("vj_persona_dance_difficulty",ply.Persona_DanceMenu_HoveredDifficulty)
					net.Start("Persona_Dance_UpdateDifficulty")
						net.WriteFloat(ply.Persona_DanceMenu_HoveredDifficulty,24)
						net.WriteEntity(ply)
						net.WriteEntity(dancer)
					net.SendToServer()
					surface.PlaySound("cpthazama/persona5/misc/00031.wav")
				elseif ply.Persona_DanceMenu_HoveredSong then
					net.Start("Persona_Dance_UpdateSong")
						net.WriteString(dancer.SoundTracks[ply.Persona_DanceMenu_HoveredSong].name)
						net.WriteEntity(dancer)
						net.WriteEntity(ply)
					net.SendToServer()
					surface.PlaySound("cpthazama/persona5/misc/00031.wav")
            		self:Close(ply)
				end
			end
		end
    
		local lastOutfitHover = nil
		local lastSongHover = nil
		local lastDifficultyHover = nil
		sideBar.Paint = function(panel,w,h)
			local boostColor = dancer:HSL((RealTime() *250 -(0 *15)),128,128)
			
            local function GetCursorDist(posX,posY,checkA,checkB)
				local cX,cY = panel:LocalCursorPos()
				if checkA then
					if checkB then
						return cX >= posX && math.abs(cY -posY *1.05) <= (checkA or 25) && cX < checkB
					end
					return cX >= posX && math.abs(cY -posY *1.05) <= (checkA or 25)
				else
					local dist = math.sqrt((cX -posX)^2 +(cY -posY)^2)
				end
			end

            local function DrawText(text,x,y,color,font,alignX,alignY)
                local textW,textH = surface.GetTextSize(text)
                local textX = x *0.5 -textW
                local textY = y *0.5 -textH *0.5
                if alignX != true then
                    textX = x
                end
                if alignY != true then
                    textY = y
                end

                surface.SetFont(font)
                surface.SetTextColor(color.r,color.g,color.b,color.a or 255)
                surface.SetTextPos(textX,textY)
                surface.DrawText(text)
            end

			//-- Outfits --//

			local boxX, boxY = ScrW() /1.3, mode == 2 && ScrH() /4 or ScrH() /12
			local boxW, boxH = ScrW() /4.6, 165
			local outfitX = boxX *0.975

			for i = 1,#dancer.Outfits do
				if i == 1 then continue end
				boxH = boxH +40
			end

			surface.SetDrawColor(0,0,0,245)
	    	surface.DrawRect(boxX,boxY,boxW,boxH)

			DrawText("SELECT AN OUTFIT",boxX *1.06,boxY +10,colorMain,"Persona",false,false)
			local stPos = boxY +70
			local tX,tY = boxX +10,stPos +10
			local selectedOutfit = nil
			for i = 1,#dancer.Outfits do
				local textColor = colorMain
				stPos = stPos +40
				local name = dancer.Outfits[i].Name
				tX,tY = boxX +10,stPos
				local unlocked = dancer:OutfitUnlocked(i,ply)
				if unlocked && GetCursorDist(tX,tY,25) && selectedOutfit == nil then
					textColor = boostColor
					selectedOutfit = i
					if lastOutfitHover != i then
						lastOutfitHover = i
						surface.PlaySound("cpthazama/persona4/ui_hover.wav")
					end
				end
				if !unlocked then
					textColor = colorOpposite
				end
				DrawText(name,tX,tY,textColor,"Persona",false,false)
			end

			if selectedOutfit == nil then
				lastOutfitHover = nil
			end

			ply.Persona_DanceMenu_HoveredOutfit = selectedOutfit

			//-- Songs --//

			local iDif = dancer:GetNW2Float("Difficulty")
			local dif = iDif == 1 && "Easy" or iDif == 2 && "Normal" or iDif == 3 && "Hard" or iDif == 4 && "Crazy" or "Insane"
			boxX, boxY = ScrW() /5, mode == 2 && ScrH() /4 or ScrH() /12
			boxW, boxH = ScrW() /2, 145
			local songX = boxX *0.975

			for i = 1,#dancer.SoundTracks do
				if i == 1 then continue end
				boxH = boxH +40
			end

			surface.SetDrawColor(0,0,0,245)
	    	surface.DrawRect(boxX,boxY,boxW,boxH)

			DrawText("SELECT A SONG",boxX *2,boxY +10,colorMain,"Persona",false,false)
			local stPos = boxY +70
			local tX,tY = boxX +10,stPos +10
			local selectedDance = nil
			for i = 1,#dancer.SoundTracks do
				local textColor = colorMain
				stPos = stPos +40
				local name = dancer.SoundTracks[i].name
				tX,tY = boxX +10,stPos
				if GetCursorDist(tX,tY,25,outfitX) && selectedDance == nil then
					textColor = boostColor
					selectedDance = i
					if lastSongHover != i then
						lastSongHover = i
						surface.PlaySound("cpthazama/persona4/ui_hover.wav")
					end
				end
				local score = dancer:GetNW2Int("HS_" .. name)
				DrawText(name .. " : High Score - " .. tostring(score) .. " / " .. dif,tX,tY,textColor,"Persona",false,false)
			end

			if selectedDance == nil then
				lastSongHover = nil
			end

			ply.Persona_DanceMenu_HoveredSong = selectedDance

			//-- Difficulty --//

			local iDif = dancer:GetNW2Float("Difficulty")
			local dif = iDif == 1 && "Easy" or iDif == 2 && "Normal" or iDif == 3 && "Hard" or iDif == 4 && "Crazy" or "Insane"
			boxX, boxY = ScrW() *0.015, ScrH() /12
			boxW, boxH = ScrW() *0.115, ScrH() *0.22

			surface.SetDrawColor(0,0,0,245)
	    	surface.DrawRect(boxX,boxY,boxW,boxH)
			DrawText("DIFFICULTY",boxX *2.3,boxY +10,colorMain,"Persona",false,false)
			local stPos = boxY +70
			local tX,tY = boxX +10,stPos +10
			local selectedDifficulty = nil
			for i = 1,5 do
				local textColor = colorMain
				stPos = stPos +40
				local name = i == 1 && "Easy" or i == 2 && "Normal" or i == 3 && "Hard" or i == 4 && "Crazy" or "Insane"
				tX,tY = boxX +10,stPos
				if GetCursorDist(tX,tY,25,songX) && selectedDifficulty == nil then
					textColor = boostColor
					selectedDifficulty = i
					if lastDifficultyHover != i then
						lastDifficultyHover = i
						surface.PlaySound("cpthazama/persona4/ui_hover.wav")
					end
				end
				DrawText(name,tX,tY,textColor,"Persona",false,false)
			end

			if selectedDifficulty == nil then
				lastDifficultyHover = nil
			end

			ply.Persona_DanceMenu_HoveredDifficulty = selectedDifficulty
		end
    end

    function PERSONA_DANCE_MENU:Close(ply,dancer)
        ply.Persona_DanceMenu_Open = false
		if ply.Persona_DanceMenu_MainBG then
			ply.Persona_DanceMenu_MainBG:Delete()
			ply.Persona_DanceMenu_MainBG = nil
		end
        surface.PlaySound("cpthazama/persona4/ui_hover.wav")
        if IsValid(ply.Persona_DanceMenu_PreviewTheme) && ply.Persona_DanceMenu_PreviewTheme:GetState() == 1 then
            ply.Persona_DanceMenu_PreviewTheme:Stop()
        end
		if dancer then
			net.Start("Persona_Dance_OnClose")
				net.WriteEntity(dancer)
			net.SendToServer()
		end
    end

	net.Receive("Persona_Dance_Menu",function(len,ply)
		local ply = net.ReadEntity()
		local ent = net.ReadEntity()

		PERSONA_DANCE_MENU:Open(ply,ent)
    end)
else
	util.AddNetworkString("Persona_Dance_Menu")
	util.AddNetworkString("Persona_Dance_OnClose")

	net.Receive("Persona_Dance_OnClose",function(len,ply)
		local ent = net.ReadEntity()

		ent:Remove()
    end)
end