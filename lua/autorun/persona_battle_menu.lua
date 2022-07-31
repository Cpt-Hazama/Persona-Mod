if CLIENT then
    PERSONA_BATTLE_MENU = {}

	local string_len = string.len

    function PERSONA_BATTLE_MENU:Open(ply,battleData,battleEnt)
        if ply.Persona_BattleMenu_Open == true then
            if ply.Persona_BattleMenu_MainBG then
                ply.Persona_BattleMenu_MainBG:Delete()
                ply.Persona_BattleMenu_MainBG = nil
            end
            self:Close(ply)
            return
        end

        ply.Persona_BattleMenu_Open = true

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
        ply.Persona_BattleMenu_MainBG = menuBackground

		menuBackground.OnKeyCodePressed = function(...)
            local panel,code = ...
			if code == KEY_E then
				self:Close(ply) -- Debug emergency escape
			end
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
				if ply.Persona_BattleMenu_HoveredOption_Main then
					local option = ply.Persona_BattleMenu_HoveredOption_Main
					if option == "Use Skill" then
						
					elseif option == "Use Item" then

					elseif option == "Change Persona" then
						PERSONA_MENU:Open(ply)
					elseif option == "Skip Turn" then
						net.Start("Persona_SkipTurn")
							net.WriteEntity(battleEnt)
						net.SendToServer()
					elseif option == "Attempt Escape" then
						ply:SetNW2Bool("Persona_BattleMode",false)
						if ply.Persona_BattleTheme then
							ply.Persona_BattleTheme:FadeOut(2)
						end
						net.Start("Persona_EndBattle")
							net.WriteEntity(battleEnt)
							net.WriteEntity(ply)
							net.WriteTable(battleEnt.BattleEntitiesTable)
						net.SendToServer()
						PERSONA_BATTLE_MENU:Close(ply)
					end
					self.CurrentSubsetMenu = option
					surface.PlaySound("cpthazama/persona5/misc/00031.wav")
				end

				if ply.Persona_BattleMenu_HoveredOption_Sub then
					if self.CurrentSubsetMenu == "Use Skill" then
						net.Start("Persona_Battle_RunCommand")
							net.WriteEntity(ply)
							net.WriteFloat(1,16)
							net.WriteTable(ply.Persona_BattleMenu_LastSkillData)
						net.SendToServer()
						surface.PlaySound("cpthazama/persona5/misc/00031.wav")
					end
				end
			end
		end
    
		local lastMainOptionHover = nil
		local lastSubOptionHover = nil

		local options = {}
		options["SELECT MOVE"] = {
			"Use Skill",
			"Use Item",
			"Change Persona",
			"Skip Turn",
			"Attempt Escape"
		}
		sideBar.Paint = function(panel,w,h)			
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

			local persona = ply:GetNW2Entity("PersonaEntity")
			local skillMenu = ply.Persona_CSSkills or {}

			boxX, boxY = ScrW() *0.1, ScrH() *0.2
			boxW, boxH = ScrW() *0.115, ScrH() *0.22

			surface.SetDrawColor(0,0,0,245)
	    	surface.DrawRect(boxX,boxY,boxW,boxH)
			local firstIndex = next(options)
			DrawText(firstIndex,boxX *1.1,boxY +10,colorMain,"Persona",false,false)
			local stPos = boxY +70
			local tX,tY = boxX +10,stPos +10
			local currentMainOption = nil
			for index,option in pairs(options[firstIndex]) do
				local textColor = colorMain
				stPos = stPos +40
				tX,tY = boxX +10,stPos
				if GetCursorDist(tX,tY *0.98,25,boxX +boxW) && currentMainOption == nil then
					textColor = colorOpposite
					currentMainOption = option
					if lastMainOptionHover != option then
						lastMainOptionHover = option
						surface.PlaySound("cpthazama/persona4/ui_hover.wav")
					end
				end
				DrawText(option,tX,tY,textColor,"Persona",false,false)
			end

			if currentMainOption == nil then
				lastMainOptionHover = nil
			end

			ply.Persona_BattleMenu_HoveredOption_Main = currentMainOption

			if self.CurrentSubsetMenu then
				if self.CurrentSubsetMenu == "Use Skill" then
					local longestName = 1
					local heightAdjust = 0
					for index,skill in pairs(skillMenu) do
						heightAdjust = heightAdjust +37
						if skill && string_len(skill.Name) > longestName then
							longestName = string_len(skill.Name)
						end
					end
					local pos = (boxX +boxW) *1.05
					boxX = pos
					boxW, boxH = (ScrW() *0.115) *(longestName *0.085), (ScrH() *0.035) +heightAdjust

					surface.SetDrawColor(0,0,0,245)
					surface.DrawRect(boxX,boxY,boxW,boxH)
					local stPos = boxY *0.9
					local tX,tY = boxX +10,stPos +10
					local currentSkill = nil
					for i,skill in pairs(skillMenu) do
						if skill then
							local textColor = colorMain
							stPos = stPos +40
							tX,tY = boxX +10,stPos

							local name = skill.Name
							local cost = skill.Cost
							local doHP = skill.UsesHP
							
							if doHP then
								textColor = Color(107,255,222)
							else
								textColor = Color(255,101,239)
							end
							if GetCursorDist(tX,tY *0.98,25,boxX +boxW) && currentSkill == nil then
								textColor = colorOpposite
								currentSkill = name
								if lastSubOptionHover != name then
									lastSubOptionHover = name
									ply.Persona_BattleMenu_LastSkillData = skill
									surface.PlaySound("cpthazama/persona4/ui_hover.wav")
								end
							end
							local strCost = doHP && " HP)" or " SP)"
							DrawText(name .. " (" .. cost .. strCost,tX,tY,textColor,"Persona",false,false)
						end
					end

					if currentSkill == nil then
						lastSubOptionHover = nil
					end

					ply.Persona_BattleMenu_HoveredOption_Sub = currentSkill
				end
			end
		end
    end

    function PERSONA_BATTLE_MENU:Close(ply)
        ply.Persona_BattleMenu_Open = false
		if ply.Persona_BattleMenu_MainBG then
			ply.Persona_BattleMenu_MainBG:Delete()
			ply.Persona_BattleMenu_MainBG = nil
		end
        surface.PlaySound("cpthazama/persona4/ui_hover.wav")
    end

	net.Receive("Persona_Battle_DoClose",function(len,ply)
		local ply = net.ReadEntity()

		if ply.Persona_BattleMenu_Open then
			PERSONA_BATTLE_MENU:Close(ply)
		end
    end)
else
	util.AddNetworkString("Persona_Battle_DoClose")
	util.AddNetworkString("Persona_Battle_RunCommand")

	net.Receive("Persona_Battle_RunCommand",function(len,ply)
		local ply = net.ReadEntity()
		local persona = ply:GetPersona()
		local commandType = net.ReadFloat(16)
		local data = net.ReadTable()

		if commandType == 1 then -- Use Skill
			if IsValid(persona) then
				if data.UsesHP then
					persona:DoMeleeAttack(ply,persona,data.Name)
				else
					persona:DoSpecialAttack(ply,persona,data.Name)
				end
			end
		elseif commandType == 2 then -- Use Item

		end
    end)
end