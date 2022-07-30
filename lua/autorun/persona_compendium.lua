if CLIENT then
    PERSONA_MENU = {}

	local randomLines = {
		"cpthazama/persona4/margaret/chrna_ma_004.ogg",
		"cpthazama/persona4/margaret/chrna_ma_015.ogg",
		"cpthazama/persona4/margaret/chrna_ma_016.ogg",
		"cpthazama/persona4/margaret/chrna_ma_017.ogg",
	}
	local curLine = 0
    local matBackground = Material("persona/bg_placeholder.png")
    function PERSONA_MENU:Open(ply)
        if ply.Persona_Menu_Open == true then
            if ply.Persona_Menu_MainBG then
                ply.Persona_Menu_MainBG:Delete()
                ply.Persona_Menu_MainBG = nil
            end
            self:Close(ply)
            return
        end

        ply.Persona_Menu_Open = true
	
		sound.PlayFile("sound/cpthazama/persona_shared/velvet.mp3","noplay noblock",function(station,errCode,errStr)
			if IsValid(station) then
				station:EnableLooping(true)
				station:Play()
				station:SetVolume(0.6)
				station:SetPlaybackRate(1)
				ply.Persona_Menu_VelvetTheme = station
			else
				print("Error playing sound!",errCode,errStr)
			end
			return station
		end)

		ply.Persona_Menu_RandomLineTime = CurTime() +math.random(30,40)
		ply.Persona_Menu_CurrentSound = ply.Persona_Menu_CurrentSound or nil
		if math.random(1,6) == 1 then
			ply.Persona_Menu_CurrentSound = CreateSound(ply,"cpthazama/persona4/igor/intro.ogg")
			ply.Persona_Menu_CurrentSound:SetSoundLevel(0)
			ply.Persona_Menu_CurrentSound:Play()
			ply.Persona_Menu_RandomLineTime = CurTime() +math.random(30,40)
		end

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
		menuBackground.y = scrH/2
		menuBackground:MoveTo(0,0,0)
		menuBackground:SetPopupStayAtBack(true)
		menuBackground.Paint = function(self,w,h)
	    	surface.SetDrawColor(colorMain)
			surface.DrawRect(0,0,w,h)
		end
        ply.Persona_Menu_MainBG = menuBackground

		menuBackground.OnKeyCodePressed = function(...)
            local panel,code = ...
            if code == KEY_BACKSPACE or code == KEY_SPACE or code == KEY_ESCAPE then
                self:Close(ply)
			    panel:Delete()
                ply.Persona_Menu_MainBG = nil
            end
			return true
		end

		function menuBackground:Delete()
			menuBackground:AlphaTo(0,0.5,0)
			menuBackground:SetKeyboardInputEnabled(false)
			menuBackground:SetMouseInputEnabled(false)
			menuBackground:Remove()
		end

        local totalPersonas = #PERSONA

		local personaRender = vgui.Create("DModelPanel",menuBackground)
        local modScrY = 0.9
        for i=1,totalPersonas do
            if i%40 == 1 then
                modScrY = modScrY -0.1
            end
        end
		personaRender:SetSize(scrW *0.8,scrH *modScrY)
		personaRender:SetPos(0,scrH *(1 -modScrY))
		personaRender.Angles = angle_zero

        local currentPersona = GetConVar("persona_comp_name"):GetString()

		function personaRender:UpdateCharacter(persona)
            if persona == nil then
                persona = currentPersona
            end
			local dat = PERSONA[persona]
            local options = dat.MenuOptions
			local modelname = dat.Model

            util.PrecacheModel(modelname)
            -- if IsValid(self.Aura) then
            --     self.Aura:StopEmission()
            --     self.Aura = nil
            -- end
			self:SetAmbientLight(Color(255,255,255,255))
			self:SetModel(modelname)
            self:SetFOV(60)

            local personaEnt = self:GetEntity()
            -- self.Aura = CreateParticleSystem(personaEnt,dat.Aura,PATTACH_POINT_FOLLOW,0)
            local height = select(2,personaEnt:GetModelBounds()).z
            if height > 5000 then
                personaEnt:SetModelScale(0.045)
            else
                personaEnt:SetModelScale(1)
            end
            height = height *personaEnt:GetModelScale()
            self:SetCamPos(personaEnt:GetPos() +personaEnt:OBBCenter() +personaEnt:GetForward() *height *2 +personaEnt:GetUp() *height)
            self:SetLookAt(personaEnt:GetPos() +personaEnt:GetUp() *height *0.5)

            if options then
                if options.Skin then
                    personaEnt:SetSkin(options.Skin)
                end
                if options.Custom then
                    options.Custom(personaEnt)
                end
            end

            personaEnt:SetAngles(Angle(0,-25,0))
            self:PlayAnimation(dat.MenuOptions && dat.MenuOptions.Anim_Idle or "idle")
		end

		function personaRender:PlayAnimation(seq)
            local personaEnt = self:GetEntity()
            if !IsValid(personaEnt) then return end
            personaEnt:ResetSequenceInfo(seq)
            personaEnt:SetSequence(seq)
            personaEnt:SetCycle(0)
        end

		personaRender:UpdateCharacter()

		function personaRender:OnMouseReleased(key)
			if key == MOUSE_LEFT then
				self.Pressed = false
			end
		end

		function personaRender:OnMousePressed(key)
            local personaEnt = self.Entity
            currentPersona = GetConVar("persona_comp_name"):GetString()
			local dat = PERSONA[currentPersona]
            local options = dat.MenuOptions
			if key == MOUSE_LEFT then
				self.PressX,self.PressY = gui.MousePos()
				self.Pressed = true
			end
			if key == MOUSE_RIGHT then
                if !IsValid(personaEnt) then return end
                local atkAnim = dat.MenuOptions && dat.MenuOptions.Anim_Attack
				if personaEnt:GetSequenceName(personaEnt:GetSequence()) == (dat.MenuOptions && dat.MenuOptions.Anim_Idle or "idle") then
					local seq = atkAnim or (personaEnt:LookupSequence("attack") != -1 && personaEnt:LookupSequence("attack")) or (personaEnt:LookupSequence("melee") != -1 && personaEnt:LookupSequence("melee")) or (personaEnt:LookupSequence("atk_cross_slash") != -1 && personaEnt:LookupSequence("atk_cross_slash"))
					if seq then
                        local lastModel = personaEnt:GetModel()
                        self:PlayAnimation(seq)
						timer.Simple(personaEnt:SequenceDuration(seq),function()
							if IsValid(self) && IsValid(personaEnt) && personaEnt:GetModel() == lastModel then
								self:PlayAnimation(dat.MenuOptions && dat.MenuOptions.Anim_Idle or "idle")
							end
						end)
					end
				end
			end
        end

		function personaRender:LayoutEntity(ent)
			self:RunAnimation()

			if (self.Pressed) then
				local mx = gui.MousePos()
				self.Angles = self.Angles -Angle(0,((self.PressX or mx) -mx) /2,0)
				self.PressX,self.PressY = gui.MousePos()
			end

			ent:SetAngles(self.Angles or ent:GetAngles())
		end

		function personaRender:Paint()
            local personaEnt = self.Entity
			if !IsValid(personaEnt) then
                return
            end

			local x,y = self:LocalToScreen(0,0)
			self:LayoutEntity(personaEnt)

			if CurTime() > ply.Persona_Menu_RandomLineTime then
				if ply.Persona_Menu_CurrentSound then
					ply.Persona_Menu_CurrentSound:Stop()
				end
				ply.Persona_Menu_CurrentSound = nil
				curLine = curLine +1
				if curLine >= #randomLines then
					curLine = 1
				end
				ply.Persona_Menu_CurrentSound = CreateSound(ply,randomLines[curLine])
				ply.Persona_Menu_CurrentSound:SetSoundLevel(0)
				ply.Persona_Menu_CurrentSound:Play()
				ply.Persona_Menu_RandomLineTime = CurTime() +math.random(25,60)
			end

			if !IsValid(self.Room) then
				self.Room = ClientsideModel("models/cpthazama/persona5/maps/velvetroom_battle.mdl",RENDER_GROUP_OPAQUE_ENTITY)
				self.Room:SetPos(personaEnt:GetPos())
				self.Room:SetModelScale(2)
				self.Room:SetParent(personaEnt)
				self.Room:SetNoDraw(true)
				local index = "Persona_CSRemove_" .. personaEnt:EntIndex()
				hook.Add("Think",index,function()
					if !IsValid(personaEnt) then
						SafeRemoveEntity(self.Room)
						hook.Remove("Think",index)
					end
				end)
			end

			local ang = self.aLookAngle
			if (!ang) then
				ang = (self.vLookatPos -self.vCamPos):Angle()
			end
			local w,h = self:GetSize()
			cam.Start3D(self.vCamPos,ang,self.fFOV,x,y,w,h,5,4096)
                cam.IgnoreZ(true)
                render.SuppressEngineLighting(true)
                render.SetLightingOrigin(personaEnt:GetPos())
                render.ResetModelLighting(self.colAmbientLight.r /255,self.colAmbientLight.g /255,self.colAmbientLight.b /255)
                render.SetColorModulation(self.colColor.r /255,self.colColor.g /255,self.colColor.b /255)
                render.SetBlend(self.colColor.a /255)
                for i = 0,6 do
                    local col = self.DirectionalLight[i]
                    if (col) then
                        render.SetModelLighting(i,col.r /255,col.g /255,col.b /255)
                    end
                end
                if IsValid(self.Room) then
                    self.Room:DrawModel()
                end
                self:DrawModel()
                personaEnt:DrawModel()
                render.SuppressEngineLighting(false)
                cam.IgnoreZ(false)
			cam.End3D()
			self.LastPaint = RealTime()
		end

		function personaRender:OnRemove()
			if IsValid(personaRender.Entity) then
				personaRender.Entity:Remove()
			end
			if IsValid(self.Room) then
				self.Room:Remove()
			end
		end

		local personaListBackground = vgui.Create("DPanel",menuBackground)
		personaListBackground:SetSize(scrW,scrH *(1 -modScrY))
		personaListBackground:SetPos(0,0)

		function personaListBackground:Delete()
			menuBackground:Delete()
		end
    
		personaListBackground.Paint = function(panel,w,h)
			surface.SetDrawColor(0,0,0,100)
	    	surface.DrawRect(0,0,w,h)
		end

		local PanelSelect = personaListBackground:Add("DPanelSelect")
		PanelSelect:Dock(FILL)

		for index,idName in SortedPairs(PXP.GetPersonaData(ply,4) or PERSONA_STARTERS) do
			if PERSONA[idName] == nil then continue end
			local name = PERSONA[idName].Name
			local model = PERSONA[idName].Model
			local icon = vgui.Create("SpawnIcon")
			icon:SetModel(model)
			icon:SetSize(64,64)
			icon:SetTooltip(name)
			icon.PersonaID = idName
			icon.PersonaName = name
			icon.PersonaModel = model
			PanelSelect:AddPanel(icon,{persona_comp_name = idName})
			function icon:DoClick()
                net.Start("PersonaMod_UpdateSVPersona")
                    net.WriteEntity(ply)
                    net.WriteString(idName)
                net.SendToServer()
                surface.PlaySound("cpthazama/persona5/misc/00086.wav")

                timer.Simple(0.1,function()
                    personaRender:UpdateCharacter(idName)
                end)
                local cvar = GetConVar("persona_comp_name")
                cvar:SetString(idName)
			end
		end

		local sideBar = vgui.Create("DPanel",menuBackground)
		sideBar:SetSize(scrW *0.2,scrH *modScrY *0.28)
		sideBar:SetPos(scrW *0.8,scrH *(1 -modScrY))
    
		sideBar.Paint = function(panel,w,h)
			surface.SetDrawColor(0,0,0,100)
	    	surface.DrawRect(0,0,w,h)

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

            local currentPersona = GetConVar("persona_comp_name"):GetString()
            local personaData = PERSONA[currentPersona]

            local name = personaData.Name
            local model = personaData.Model
            local class = personaData.Class
            local category = personaData.Category
            local options = personaData.MenuOptions
			local stats = PXP.GetPersonaData(ply,7,persona) or {LUC=0,AGI=0,END=0,STR=0,MAG=0}
			local stats_lvl = PXP.GetPersonaData(ply,2,persona) or 1
			local stats_exp = PXP.GetPersonaData(ply,1,persona) or 0
			local stats_reqexp = PXP.GetPersonaData(ply,6,persona) or 0
			local stats_enh = PXP.GetPersonaData(ply,8,persona) or 0

            DrawText(name,w,0,colorOpposite,"Persona",true,false)
            DrawText((stats_enh > 0 && (stats_enh == 1 && " (Legendary)") or ""),w *0.25,h *0.085,colorOpposite,"Persona",false,false)

            DrawText("Level " .. stats_lvl,w *0.1,h *0.225,colorOpposite,"Persona",false,false)
            DrawText("EXP - " .. stats_exp .. " / " .. stats_reqexp,w *0.1,h *0.325,colorOpposite,"Persona",false,false)
            DrawText("STR - " .. stats.STR,w *0.1,h *0.5,colorOpposite,"Persona",false,false)
            DrawText("MAG - " .. stats.MAG,w *0.1,h *0.6,colorOpposite,"Persona",false,false)
            DrawText("END - " .. stats.END,w *0.1,h *0.7,colorOpposite,"Persona",false,false)
            DrawText("AGI - " .. stats.AGI,w *0.1,h *0.8,colorOpposite,"Persona",false,false)
            DrawText("LUC - " .. stats.LUC,w *0.1,h *0.9,colorOpposite,"Persona",false,false)
		end

		local sideSkillBar = vgui.Create("DPanel",menuBackground)
		sideSkillBar:SetSize(scrW *0.2,scrH *modScrY *0.72)
		sideSkillBar:SetPos(scrW *0.8,scrH *(1 -modScrY) *3.5)
    
		sideSkillBar.Paint = function(panel,w,h)
			surface.SetDrawColor(0,0,0,100)
	    	surface.DrawRect(0,0,w,h)
        end

		local function UpdateSkillList(panel)
			local currentPersona = GetConVar("persona_comp_name"):GetString()
			panel.SkillList:Clear()
			local skills = PXP.GetPersonaData(ply,3,currentPersona)
			panel.SkillCount = 0
			if skills then
				for _,skill in SortedPairs(skills) do
					panel.SkillList:AddLine(skill.Name,skill.Cost,skill.UsesHP && "HP" or "SP",(skill.Icon:gsub("^%l",string.upper)))
					panel.SkillCount = panel.SkillCount +1
				end
			end
			panel.SkillList:SortByColumn(1,false)
		end
		
		local skillList = vgui.Create("DListView")
		sideSkillBar.SkillList = skillList
		skillList:SetTooltip(false)
		skillList:Dock(FILL)
		skillList:SetMultiSelect(false)
		skillList:AddColumn("Name",1)
		skillList:AddColumn("Cost",2)
		skillList:AddColumn("Cost Type",3)
		skillList:AddColumn("Attack Type",4)
		UpdateSkillList(sideSkillBar)
		sideSkillBar:Add(skillList)
    
		skillList.Paint = function(panel,w,h)
			surface.SetDrawColor(colorMain.r,colorMain.g,colorMain.b,100)
	    	surface.DrawRect(0,0,w,h)
        end

		function sideSkillBar:Think()
			local currentPersona = GetConVar("persona_comp_name"):GetString()
			local stats_lvl = PXP.GetPersonaData(ply,2,persona) or 1
			local skills = PXP.GetPersonaData(ply,3,currentPersona)
			local points = PXP.GetPersonaData(ply,11,currentPersona)
			local isLegendary = (PXP.GetPersonaData(ply,8,persona) or 0) == 1
			local cost = math.Round(GetConVarNumber("persona_skill_cost") *3.5)
			if self.PButton then
				self.PButton:SetText(cost > points && "Not Enough Persona Points! " .. tostring(cost) .. " Points Required!" or "Buy Skill (" .. tostring(cost) .. " Points)")
			end
			if self.LegendaryButton then
				self.LegendaryButton:SetText((stats_lvl >= 99 && !isLegendary) && "Legendary Trial" or "[Locked] Legendary Trial")
				self.LegendaryButton:SetEnabled((stats_lvl >= 99 && !isLegendary) && true or false)
			end
			if self.PPT then
				self.PPT:SetText("Persona Points: " .. points)
			end
			if skills && self.SkillCount != #skills then
				UpdateSkillList(sideSkillBar)
			end
		end

		sideSkillBar.LegendaryButton = vgui.Create("DButton")
		sideSkillBar.LegendaryButton:SetText("Legendary Trial")
		sideSkillBar.LegendaryButton:SetSize(100,64)
		sideSkillBar.LegendaryButton:SetConsoleCommand("persona_legendary",ply,ply:GetInfo("persona_comp_name"))
		sideSkillBar.LegendaryButton:Dock(BOTTOM)
		sideSkillBar:Add(sideSkillBar.LegendaryButton)
    
		sideSkillBar.LegendaryButton.Paint = function(panel,w,h)
			local currentPersona = GetConVar("persona_comp_name"):GetString()
			local stats_lvl = PXP.GetPersonaData(ply,2,persona) or 1
			local isLegendary = (PXP.GetPersonaData(ply,8,persona) or 0) == 1
        
            local col = (stats_lvl >= 99 && !isLegendary) && colorMain or colorOpposite
			surface.SetDrawColor(col.r,col.g,col.b,255)
	    	surface.DrawRect(0,0,w,h)
        end

		sideSkillBar.PButton = vgui.Create("DButton")
		sideSkillBar.PButton:SetText("Add Skill")
		sideSkillBar.PButton:SetSize(100,64)
		sideSkillBar.PButton:SetConsoleCommand("persona_addskill")
		sideSkillBar.PButton:Dock(BOTTOM)
		sideSkillBar:Add(sideSkillBar.PButton)
    
		sideSkillBar.PButton.Paint = function(panel,w,h)
			surface.SetDrawColor(colorMain.r,colorMain.g,colorMain.b,255)
	    	surface.DrawRect(0,0,w,h)
        end

		sideSkillBar.PHP = vgui.Create("DLabel")
		sideSkillBar.PHP:SetText(GetConVarNumber("persona_skill_useshp") == 1 && "Cost Type: HP" or "Cost Type: SP")
		sideSkillBar.PHP:Dock(BOTTOM)
		sideSkillBar:Add(sideSkillBar.PHP)

		sideSkillBar.PCost = vgui.Create("DLabel")
		sideSkillBar.PCost:SetText("Cost: " .. tostring(GetConVarNumber("persona_skill_cost")))
		sideSkillBar.PCost:Dock(BOTTOM)
		sideSkillBar:Add(sideSkillBar.PCost)

		sideSkillBar.PIcon = vgui.Create("DImage",sideSkillBar)
		sideSkillBar.PIcon:SetSize(122,80)
		sideSkillBar.PIcon:Dock(BOTTOM)
		sideSkillBar.PIcon:SetImage("hud/persona/png/hud_" .. GetConVarString("persona_skill_icon") .. ".png")
		sideSkillBar:Add(sideSkillBar.PIcon)

		local skill_box_list = vgui.Create("DComboBox")
		skill_box_list:SetSize(100,30)
		skill_box_list:Dock(BOTTOM)
		skill_box_list:SetValue("Select A Skill")
		for i = 1,#PERSONA_SKILLS do
			local skill = PERSONA_SKILLS[i]
			local name = skill.Name
			local cost = skill.Cost
			local useshp = skill.UsesHP
			local icon = skill.Icon
			local canAdd = skill.CanObtain or true
			if canAdd == false then return end
			skill_box_list:AddChoice(name,{Name = name,Cost = cost,UsesHP = useshp,Icon = icon},false,"hud/persona/png/hud_" .. icon .. ".png")
		end
		skill_box_list.Paint = function(panel,w,h)
			surface.SetDrawColor(colorMain.r,colorMain.g,colorMain.b,255)
	    	surface.DrawRect(0,0,w,h)
        end
		skill_box_list.OnSelect = function(comboIndex,comboName,comboData)
			local data = skill_box_list:GetOptionData(comboName)
			RunConsoleCommand("persona_skill_name",data.Name)
			RunConsoleCommand("persona_skill_cost",data.Cost)
			RunConsoleCommand("persona_skill_useshp",data.UsesHP == true && 1 or 0)
			RunConsoleCommand("persona_skill_icon",data.Icon)
			-- sideSkillBar.PName:SetText("Skill Name: " .. data.Name)
			sideSkillBar.PCost:SetText("Cost: " .. tostring(data.Cost))
			sideSkillBar.PHP:SetText(data.UsesHP == true && "Cost Type: HP" or "Cost Type: SP")
			sideSkillBar.PIcon:SetImage("hud/persona/png/hud_" .. data.Icon .. ".png")
			surface.PlaySound("cpthazama/persona4/ui_hover.wav")
			-- surface.PlaySound("cpthazama/persona4/ui_newskill.wav")
		end
		sideSkillBar:Add(skill_box_list)

		sideSkillBar.PPT = vgui.Create("DLabel")
		sideSkillBar.PPT:SetText("Persona Points: 0")
		sideSkillBar.PPT:Dock(BOTTOM)
		sideSkillBar:Add(sideSkillBar.PPT)

		sideSkillBar:Add(sideSkillBar)
    end

    function PERSONA_MENU:Close(ply)
        ply.Persona_Menu_Open = false
        surface.PlaySound("cpthazama/persona4/ui_hover.wav")
        if IsValid(ply.Persona_Menu_VelvetTheme) && ply.Persona_Menu_VelvetTheme:GetState() == 1 then
            ply.Persona_Menu_VelvetTheme:Stop()
        end
		if ply.Persona_Menu_CurrentSound then
			ply.Persona_Menu_CurrentSound:Stop()
			ply.Persona_Menu_CurrentSound = nil
		end
    end

	net.Receive("Persona_ShowStatsMenu",function(len,ply)
		local personaName = net.ReadString()
		local ply = LocalPlayer()

		PERSONA_MENU:Open(ply)
    end)
end