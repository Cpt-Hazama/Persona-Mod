	--// Thanks NPP, very cool \\--
if SERVER then
	util.AddNetworkString("Persona_ShowStatsMenu")
	util.AddNetworkString("Persona_UpdateSkillMenu")
	util.AddNetworkString("PersonaMod_UpdateSVPersona")

	net.Receive("PersonaMod_UpdateSVPersona",function(len,pl)
		local ply = net.ReadEntity()
		local persona = net.ReadString()
		
		if ply == pl then
			ply:SetPersona(persona)
		end
	end)

	local function MakeLegendary(ply,cmd,args)
		local persona = ply:GetInfo("persona_comp_name")
		if persona == nil then return end
		if PXP.GetLevel(ply) >= 99 && !PXP.IsLegendary(ply) && !PXP.IsVelvet(ply) then
			-- PXP.SetLegendary(ply)
			ply:EmitSound(Sound("cpthazama/persona4/ui_changepersona.wav"))
			ply:ChatPrint("You must defeat your shadow-Persona to obtain its' Legendary form!")
			local tr = util.TraceLine({
				start = ply:EyePos(),
				endpos = ply:EyeAngles():Forward() *350,
				filter = ply
			})

			local shadow = ents.Create("npc_vj_per_shadow")
			shadow:SetPos((tr.Hit && tr.HitPos +tr.HitNormal *35 +Vector(0,0,4)) or ply:GetPos() +ply:OBBCenter() +ply:GetForward() *300)
			shadow:SetAngles(Angle(0,(shadow:GetPos() -ply:GetPos()):Angle().y,0))
			shadow.Player = ply
			shadow.SetPersona = persona
			shadow:Spawn()
			shadow:SetEnemy(ply)
			return
		end
		if PXP.IsLegendary(ply) then
			ply:ChatPrint(PERSONA[ply:GetPersonaName()].Name .. " is already a Legendary Persona!")
			return
		elseif PXP.IsVelvet(ply) then
			ply:ChatPrint("Velvet Personas can not evolve any further!")
			return
		else
			ply:ChatPrint(PERSONA[ply:GetPersonaName()].Name .. " must be a LVL 99 to become a Legendary Persona!")
			return
		end
	end
	concommand.Add("persona_legendary",MakeLegendary)
end

local function UpdateTable(ply)
	local persona = ply:GetPersona()
	if !IsValid(persona) then
		return
	end
	local old = ply:GetNW2Bool("Persona_SkillMenu")
	ply:SetNW2Bool("Persona_SkillMenu",!old)
	if ply:GetNW2Bool("Persona_SkillMenu") then
		-- if SERVER then persona:UpdateCardTable() end
		net.Start("Persona_UpdateSkillMenu")
			net.WriteEntity(ply)
			net.WriteTable(persona.CardTable)
		net.Send(ply)
	end
end
concommand.Add("persona_updateskilltable",UpdateTable)

if CLIENT then
	net.Receive("Persona_UpdateSkillMenu",function(len,ply)
		local p = net.ReadEntity()
		local pSkills = net.ReadTable()
		p.Persona_CSSkills = pSkills
	end)

	net.Receive("Persona_ShowStatsMenu",function(len,ply)
		local pName = net.ReadString()
		local ply = LocalPlayer()
	
		sound.PlayFile("sound/cpthazama/persona_shared/velvet.mp3","noplay noblock",function(station,errCode,errStr)
			if IsValid(station) then
				station:EnableLooping(true)
				station:Play()
				station:SetVolume(0.6)
				station:SetPlaybackRate(1)
				ply.Persona_VelvetTheme = station
			else
				print("Error playing sound!",errCode,errStr)
			end
			return station
		end)
		
		local currentPersona = LocalPlayer():GetInfo("persona_comp_name")
		surface.PlaySound("cpthazama/persona5/misc/00017.wav")

		local wMin,wMax = 1538,864
		local window = vgui.Create("DFrame")
		window:SetTitle(LocalPlayer():Nick() .. "'s Compendium")
		window:SetSize(math.min(ScrW() -16,wMin),math.min(ScrH() -16,wMax))
		window:SetSizable(true)
		window:SetBackgroundBlur(true)
		window:SetMinWidth(wMin)
		window:SetMinHeight(wMax)
		window:SetDeleteOnClose(false)
		window:Center()
		window:MakePopup()
		window:SetBGColor(15,44,180,255)
		window.OnClose = function()
			if IsValid(ply) then
				ply:EmitSound("cpthazama/persona4/ui_hover.wav",65)
				if IsValid(ply.Persona_VelvetTheme) && ply.Persona_VelvetTheme:GetState() == 1 then
					ply.Persona_VelvetTheme:Stop()
				end
			end
		end

		local mdl = window:Add("DModelPanel")
		mdl:Dock(FILL)
		mdl:SetFOV(36)
		mdl:SetCamPos(vector_origin)
		mdl:SetDirectionalLight(BOX_RIGHT,Color(255,160,80,255))
		mdl:SetDirectionalLight(BOX_LEFT,Color(80,160,255,255))
		mdl:SetAmbientLight(Vector(-64,-64,-64))
		mdl:SetAnimated(true)
		mdl.Angles = angle_zero
		mdl:SetLookAt(Vector(-100,0,-22))

		-- Persona Menu --
		local sheet = window:Add("DPropertySheet")
		sheet:Dock(LEFT)
		sheet:SetSize(430,0)

		local modelListPnl = window:Add("DPanel")
		modelListPnl:DockPadding(8,8,8,8)

		local PanelSelect = modelListPnl:Add("DPanelSelect")
		PanelSelect:Dock(FILL)

		for index,idName in SortedPairs(PXP.GetPersonaData(LocalPlayer(),4) or PERSONA_STARTERS) do
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
		end
		
		local function UpdateStats(panel,optPersona)
			local persona = (mdl.LastName or currentPersona)
			if optPersona then
				persona = optPersona
			end
			local stats = PXP.GetPersonaData(LocalPlayer(),7,persona)
			local stats_lvl = PXP.GetPersonaData(LocalPlayer(),2,persona)
			local stats_exp = PXP.GetPersonaData(LocalPlayer(),1,persona)
			local stats_reqexp = PXP.GetPersonaData(LocalPlayer(),6,persona)
			local stats_enh = PXP.GetPersonaData(LocalPlayer(),8,persona)
			panel.StatsList_Last = persona
			
			local stats5 = panel.Stats5 or vgui.Create("RichText",panel)
			stats5:Dock(BOTTOM)
			stats5:SetText("LUC - " .. stats.LUC)
			local stats4 = panel.Stats4 or vgui.Create("RichText",panel)
			stats4:Dock(BOTTOM)
			stats4:SetText("AGI - " .. stats.AGI)
			local stats3 = panel.Stats3 or vgui.Create("RichText",panel)
			stats3:Dock(BOTTOM)
			stats3:SetText("END - " .. stats.END)
			local stats2 = panel.Stats2 or vgui.Create("RichText",panel)
			stats2:Dock(BOTTOM)
			stats2:SetText("MAG - " .. stats.MAG)
			local stats1 = panel.Stats1 or vgui.Create("RichText",panel)
			stats1:Dock(BOTTOM)
			stats1:SetText("STR - " .. stats.STR)
			local enh = panel.Gap or vgui.Create("RichText",panel)
			enh:Dock(BOTTOM)
			enh:SetText(" ")
			local exp = panel.EXP or vgui.Create("RichText",panel)
			exp:Dock(BOTTOM)
			exp:SetText("EXP - " .. stats_exp .. " / " .. stats_reqexp)
			local level = panel.Level or vgui.Create("RichText",panel)
			level:Dock(BOTTOM)
			level:SetText("Level " .. stats_lvl)
			local statsName = panel.StatsName or vgui.Create("RichText",panel)
			statsName:Dock(BOTTOM)
			statsName:SetText(PERSONA[persona].Name .. (stats_enh > 0 && (stats_enh == 1 && " (Legendary)") or "") .. "'s Stats")

			panel.Stats1 = stats1
			panel.Stats2 = stats2
			panel.Stats3 = stats3
			panel.Stats4 = stats4
			panel.Stats5 = stats5
			panel.Level = level
			panel.EXP = exp
			panel.Gap = enh
			panel.StatsName = statsName
		end

		UpdateStats(modelListPnl)
		
		sheet:AddSheet("Persona",modelListPnl,"vj_hud/persona16.png")

		local function PlayPreviewAnimation(panel,anim)
			if (!panel or !IsValid(panel.Entity)) then return end

			local seq = panel.Entity:LookupSequence(anim or "idle")
			if panel.Entity:GetCycle() >= 1 then
				panel.Entity:SetCycle(0)
				panel.Entity:ResetSequence(seq)
			end
		end

		local modelname = PERSONA[currentPersona].Model
		local aura = PERSONA[currentPersona].Aura
		util.PrecacheModel(modelname)
		mdl:SetModel(modelname)
		mdl.LastModel = modelname
		mdl.LastName = currentPersona
		local dist = select(2,mdl.Entity:GetModelBounds()).z
		mdl.Entity:SetPos(Vector(-dist *2,0,-dist))

		-- ParticleEffectAttach(aura == "persona_aura_red" && "vj_per_idle_chains_evil" or "vj_per_idle_chains",PATTACH_POINT_FOLLOW,mdl.Entity,mdl.Entity:LookupAttachment("origin"))
		-- ParticleEffectAttach(aura == "persona_aura_red" && "jojo_aura_red" or "jojo_aura_blue",PATTACH_POINT_FOLLOW,mdl.Entity,mdl.Entity:LookupAttachment("origin"))

		PlayPreviewAnimation(mdl)

		function mdl:OnMouseReleased(key)
			if key == MOUSE_LEFT then
				self.Pressed = false
			end
		end

		function mdl:OnMousePressed(key)
			if key == MOUSE_LEFT then
				self.PressX, self.PressY = gui.MousePos()
				self.Pressed = true
			end
			if key == MOUSE_RIGHT then
				if self.Entity:GetSequenceName(self.Entity:GetSequence()) == "idle" then
					local seq = (self.Entity:LookupSequence("attack") != -1 && self.Entity:LookupSequence("attack")) or (self.Entity:LookupSequence("melee") != -1 && self.Entity:LookupSequence("melee")) or (self.Entity:LookupSequence("atk_cross_slash") != -1 && self.Entity:LookupSequence("atk_cross_slash"))
					if seq then
						local oldMdl = self.LastModel
						self.Entity:SetCycle(0)
						self.Entity:ResetSequence(seq)
						timer.Simple(self.Entity:SequenceDuration(seq),function()
							if IsValid(self) && IsValid(self.Entity) && self.LastModel == oldMdl then
								PlayPreviewAnimation(self)
							end
						end)
					end
				end
			end
		end

		function modelListPnl:Think()
			local currentPersona = LocalPlayer():GetInfo("persona_comp_name")
			if self.StatsList_Last && self.StatsList_Last != currentPersona then
				UpdateStats(self,currentPersona)
				self.StatsList_Last = currentPersona
				net.Start("PersonaMod_UpdateSVPersona")
					net.WriteEntity(LocalPlayer())
					net.WriteString(currentPersona)
				net.SendToServer()
				surface.PlaySound("cpthazama/persona5/misc/00086.wav")
			end
		end

		function mdl:PreDrawModel(ent)
			local currentPersona = LocalPlayer():GetInfo("persona_comp_name")
			local modelname = PERSONA[currentPersona].Model
			local aura = PERSONA[currentPersona].Aura
			util.PrecacheModel(modelname)
			ent:SetModel(modelname)
			ent.LastModel = modelname
			ent.LastName = currentPersona
			local dist = select(2,ent.Entity:GetModelBounds()).z
			ent.Entity:SetPos(Vector(-dist *2,0,-dist))
			
			PlayPreviewAnimation(self)
		end

		function mdl:LayoutEntity(ent)
			if (self.bAnimated) then
				self:RunAnimation()
			end
			if (self.Pressed) then
				local mx = gui.MousePos()
				self.Angles = self.Angles -Angle(0,((self.PressX or mx) -mx) /2,0)
				self.PressX, self.PressY = gui.MousePos()
			end

			ent:SetAngles(self.Angles)
		end

		-- Skill Menu --

		local skillPanel = window:Add("DPanel")
		skillPanel:DockPadding(8,8,8,8)
		
		local function UpdateSkillList(panel)
			local currentPersona = LocalPlayer():GetInfo("persona_comp_name")
			panel.SkillList:Clear()
			local skills = PXP.GetPersonaData(LocalPlayer(),3,currentPersona)
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
		skillPanel.SkillList = skillList
		skillList:SetTooltip(false)
		skillList:Dock(FILL)
		skillList:SetMultiSelect(false)
		skillList:AddColumn("Name",1)
		skillList:AddColumn("Cost",2)
		skillList:AddColumn("Cost Type",3)
		skillList:AddColumn("Attack Type",4)
		UpdateSkillList(skillPanel)
		skillPanel:Add(skillList)

		local skillsTab = sheet:AddSheet("Skills",skillPanel,"icon16/fire.png")

		function skillPanel:Think()
			local currentPersona = LocalPlayer():GetInfo("persona_comp_name")
			local skills = PXP.GetPersonaData(LocalPlayer(),3,currentPersona)
			if skills && self.SkillCount != #skills then
				UpdateSkillList(skillPanel)
			end
		end

		-- Add Skills Menu --

		skillPanel.PButton = vgui.Create("DButton")
		skillPanel.PButton:SetText("Add Skill")
		skillPanel.PButton:SetSize(100,64)
		skillPanel.PButton:SetConsoleCommand("persona_addskill")
		skillPanel.PButton:Dock(BOTTOM)
		skillPanel:Add(skillPanel.PButton)

		skillPanel.PHP = vgui.Create("DLabel")
		skillPanel.PHP:SetText(GetConVarNumber("persona_skill_useshp") == 1 && "Cost Type: HP" or "Cost Type: SP")
		skillPanel.PHP:Dock(BOTTOM)
		skillPanel:Add(skillPanel.PHP)

		skillPanel.PCost = vgui.Create("DLabel")
		skillPanel.PCost:SetText("Cost: " .. tostring(GetConVarNumber("persona_skill_cost")))
		skillPanel.PCost:Dock(BOTTOM)
		skillPanel:Add(skillPanel.PCost)

		skillPanel.PIcon = vgui.Create("DImage",skillPanel)
		skillPanel.PIcon:SetSize(122,80)
		skillPanel.PIcon:Dock(BOTTOM)
		skillPanel.PIcon:SetImage("hud/persona/png/hud_" .. GetConVarString("persona_skill_icon") .. ".png")
		skillPanel:Add(skillPanel.PIcon)

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
		skill_box_list.OnSelect = function(comboIndex,comboName,comboData)
			local data = skill_box_list:GetOptionData(comboName)
			RunConsoleCommand("persona_skill_name",data.Name)
			RunConsoleCommand("persona_skill_cost",data.Cost)
			RunConsoleCommand("persona_skill_useshp",data.UsesHP == true && 1 or 0)
			RunConsoleCommand("persona_skill_icon",data.Icon)
			-- skillPanel.PName:SetText("Skill Name: " .. data.Name)
			skillPanel.PCost:SetText("Cost: " .. tostring(data.Cost))
			skillPanel.PHP:SetText(data.UsesHP == true && "Cost Type: HP" or "Cost Type: SP")
			skillPanel.PIcon:SetImage("hud/persona/png/hud_" .. data.Icon .. ".png")
			surface.PlaySound("cpthazama/persona4/ui_hover.wav")
			-- surface.PlaySound("cpthazama/persona4/ui_newskill.wav")
		end
		skillPanel:Add(skill_box_list)
		skillPanel:Add(skillPanel)

		-- Misc Menu --

		local miscPanel = window:Add("DPanel")
		miscPanel:DockPadding(8,8,8,8)

		local lText = vgui.Create("DLabel")
		lText:SetText("Once your Persona is Level 99, you can battle your Shadow-Persona")
		lText:Dock(TOP)
		miscPanel:Add(lText)

		local lText = vgui.Create("DLabel")
		lText:SetText("in hopes of evolving your Persona even further!")
		lText:Dock(TOP)
		miscPanel:Add(lText)

		local lButton = vgui.Create("DButton")
		lButton:SetText("Legendary Trial")
		lButton:SetSize(100,54)
		lButton:SetConsoleCommand("persona_legendary",LocalPlayer(),LocalPlayer():GetInfo("persona_comp_name"))
		lButton:Dock(TOP)
		miscPanel:Add(lButton)
		
		local miscTab = sheet:AddSheet("Misc.",miscPanel,"vj_icons/persona16.png")
	end)
end

local function ShowStats(ply)
	net.Start("Persona_ShowStatsMenu")
		net.WriteString(PERSONA[ply:GetPersonaName()].Name)
	net.Send(ply)
	ply:EmitSound(Sound("cpthazama/persona4/ui_shufflebegin.wav"))
end
concommand.Add("persona_showstats",ShowStats)

-- local function MakeLegendary_Legacy(ply)
	-- if PXP.GetLevel(ply) >= 99 && !PXP.IsLegendary(ply) && !PXP.IsVelvet(ply) then
		-- PXP.SetLegendary(ply)
		-- ply:EmitSound(Sound("cpthazama/persona4/ui_changepersona.wav"))
		-- ply:ChatPrint(PERSONA[ply:GetPersonaName()].Name .. " is now a Legendary Persona!")
		-- return
	-- end
	-- if PXP.IsLegendary(ply) then
		-- ply:ChatPrint(PERSONA[ply:GetPersonaName()].Name .. " is already a Legendary Persona!")
		-- return
	-- elseif PXP.IsVelvet(ply) then
		-- ply:ChatPrint("Velvet Personas can not evolve any further!")
		-- return
	-- else
		-- ply:ChatPrint(PERSONA[ply:GetPersonaName()].Name .. " must be a LVL 99 to become a Legendary Persona!")
		-- return
	-- end
-- end
-- concommand.Add("persona_legendary",MakeLegendary)

if CLIENT then
	hook.Add("AddToolMenuTabs","Persona_MainMenuIcon",function()
		spawnmenu.AddToolTab("Persona","Persona","vj_icons/persona16.png")
	end)
	hook.Add("PopulateToolMenu","Persona_MainMenu",function()
		spawnmenu.AddToolMenuOption("Persona","Main Settings","HUD","HUD","","",function(Panel)
			local DefaultBox = {Options = {},CVars = {},Label = "#Presets",MenuButton = "1",Folder = "Main Settings"}
			DefaultBox.Options["#Default"] = {
				persona_hud_x = "350",
				persona_hud_y = "350",
				persona_hud_damage = "1",
				-- persona_hud_raidboss = "0",
			}
			Panel:AddControl("ComboBox",DefaultBox)
			Panel:AddControl("Slider",{Label = "Box X Position",Command = "persona_hud_x",Min = 0,Max = 1920})
			Panel:AddControl("Slider",{Label = "Box Y Position",Command = "persona_hud_y",Min = 0,Max = 1080})
			Panel:AddControl("CheckBox",{Label = "Enable Damage Markers",Command = "persona_hud_damage"})
			-- Panel:AddControl("CheckBox",{Label = "Enable Raid Boss Portraits",Command = "persona_hud_raidboss"})
		end,{})

		spawnmenu.AddToolMenuOption("Persona","Main Settings","Combat","Combat","","",function(Panel)
			Panel:AddControl("CheckBox",{Label = "Enable Level-Based Damage Scaling",Command = "persona_dmg_scaling"})
			Panel:AddControl("CheckBox",{Label = "Enable Summon Meter",Command = "persona_meter_enabled"})
			Panel:AddControl("Slider",{Label = "Extend Summon Time by X",Command = "persona_meter_mul",Min = 1,Max = 20})
			Panel:AddControl("CheckBox",{Label = "Enable Battle Mode",Command = "vj_persona_battle"})
			Panel:AddControl("CheckBox",{Label = "Force Positions In Battle Mode",Command = "vj_persona_battle_positions"})
			Panel:AddControl("CheckBox",{Label = "Only Target Visible Enemies In Battle Mode",Command = "vj_persona_battle_visible"})
			Panel:AddControl("CheckBox",{Label = "Allow More Enemies To Join Battles At Any Time",Command = "vj_persona_battle_newcomers"})
			Panel:AddControl("CheckBox",{Label = "Take Turns In Battle",Command = "vj_persona_battle_turns"})
			Panel:AddControl("Slider",{Label = "Max Time Per Turn",Command = "vj_persona_battle_turntime",Min = 5,Max = 180})
			Panel:AddControl("Slider",{Label = "Non-Persona users have X seconds to deal damage",Command = "vj_persona_battle_damagetime",Min = 1,Max = 20})
			Panel:AddControl("Label",{Text = "After a Non-Persona user deals damage on their turn, they'll have X seconds to finish attacking before their turn is up. This is useful for enemies with unique atttacks (Ex.: Alien Grunt hornets)"})
		end,{})

		spawnmenu.AddToolMenuOption("Persona","Main Settings","NPCs","NPCs","","",function(Panel)
			Panel:AddControl("CheckBox",{Label = "Enable NPC Themes",Command = "vj_persona_music"})
			Panel:AddControl("Label",{Text = "Note: You can also enable/disable them per NPC!"})
		end,{})

		spawnmenu.AddToolMenuOption("Persona","Dance Settings","Dance","Dance","","",function(Panel)
			Panel:AddControl("Slider",{Label = "Music Volume",Command = "vj_persona_dancevol",Min = 0,Max = 100})
			Panel:AddControl("Label",{Text = "Default = 60%"})
			Panel:AddControl("Slider",{Label = "Dance Mode",Command = "vj_persona_dancemode",Min = 1,Max = 2})
			Panel:AddControl("Label",{Text = "1 = Spectate, 2 = Dance, Dance!"})
			Panel:AddControl("Slider",{Label = "Dance Difficulty",Command = "vj_persona_dancedifficulty",Min = 1,Max = 5})
			Panel:AddControl("Label",{Text = "1 = Easy, 2 = Normal, 3 = Hard, 4+ = You're Crazy"})
			Panel:AddControl("Slider",{Label = "Note Speed",Command = "persona_dance_notespeed",Min = 1,Max = 8})
			Panel:AddControl("Label",{Text = "Default = 4"})
			
			Panel:AddControl("Label",{Text = " "})
			Panel:AddControl("CheckBox",{Label = "Enable Perfect Play",Command = "persona_dance_perfect"})
			Panel:AddControl("Label",{Text = "Scores will not be saved in Perfect Play mode!"})
			Panel:AddControl("CheckBox",{Label = "Controller Mode",Command = "persona_dance_controller"})
			Panel:AddControl("Label",{Text = "Enable this to play with a controller!"})
			Panel:AddControl("CheckBox",{Label = "Cinematic Mode",Command = "persona_dance_cinematic"})
			Panel:AddControl("Label",{Text = "If the Dancer has a Cinematic Mode, this will give Dance Mode 1 & 2 an authentic feel!"})

			Panel:AddControl("Label",{Text = " "})
			Panel:AddControl("Slider",{Label = "Commentator Chance",Command = "persona_dance_voicechance",Min = 0,Max = 100})
			Panel:AddControl("Label",{Text = "Chance they will talk during an action."})
			Panel:AddControl("Label",{Text = "This only works if you have a commentator pack!"})
			Panel:AddControl("Slider",{Label = "Commentator Volume",Command = "persona_dance_voicevolume",Min = 0,Max = 100})
			Panel:AddControl("Label",{Text = "Default = 50%"})
			
			if !(!game.SinglePlayer() && !LocalPlayer():IsAdmin()) then
				Panel:AddControl("Label",{Text = " "})
				Panel:AddControl("Label",{Text = "Developer Settings"})
				Panel:AddControl("CheckBox",{Label = "Enable Developer Tools",Command = "persona_dance_dev"})
				Panel:AddControl("Slider",{Label = "FFT Channel To Check",Command = "persona_dance_dev_fftpos",Min = 0,Max = 256})
				Panel:AddControl("CheckBox",{Label = "Check All FFT Channels?",Command = "persona_dance_dev_fftall"})
				Panel:AddControl("Slider",{Label = "FFT Channel Check Strength",Command = "persona_dance_dev_fftstr",Min = 0,Max = 3000})
			end

			Panel:AddControl("Label",{Text = " "})
			Panel:AddControl("Numpad",{Label = "Top-Left Key", Command = "persona_dance_top_l"})
			Panel:AddControl("Numpad",{Label = "Middle-Left Key", Command = "persona_dance_mid_l"})
			Panel:AddControl("Numpad",{Label = "Bottom-Left Key", Command = "persona_dance_bot_l"})
			Panel:AddControl("Numpad",{Label = "Top-Right Key", Command = "persona_dance_top_r"})
			Panel:AddControl("Numpad",{Label = "Middle-Right Key", Command = "persona_dance_mid_r"})
			Panel:AddControl("Numpad",{Label = "Bottom-Right Key", Command = "persona_dance_bot_r"})
			Panel:AddControl("Numpad",{Label = "Scratch Key", Command = "persona_dance_scratch"})
			Panel:AddControl("Color",{
				Label = "HUD Color", 
				Red = "persona_dance_hud_r",
				Green = "persona_dance_hud_g",
				Blue = "persona_dance_hud_b",
				ShowAlpha = "0", 
				ShowHSV = "1",
				ShowRGB = "1"
			})
		end,{})

		spawnmenu.AddToolMenuOption("Persona","Persona","Commands","Commands","","",function(Panel)
			Panel:AddControl("Button",{Label = "Open Compendium",Command = "persona_showstats"})
			Panel:AddControl("Button",{Label = "Add To Party",Command = "persona_party"})
			Panel:AddControl("Button",{Label = "Remove From Party",Command = "persona_partyremove"})
			Panel:AddControl("Button",{Label = "Disband Party",Command = "persona_partyclear"})
			Panel:AddControl("Label",{Text = "Must be looking at a Player to add/remove them!"})
			-- Panel:AddControl("Button",{Label = "Create Legendary Persona",Command = "persona_legendary"})
			-- Panel:AddControl("Label",{Text = "Persona must be LVL 99 to become Legendary!"})

			-- local skill_box_list = vgui.Create("DComboBox")
			-- skill_box_list:SetSize(100,30)
			-- skill_box_list:SetValue("Select A Skill")
			-- for i = 1,#PERSONA_SKILLS do
				-- local skill = PERSONA_SKILLS[i]
				-- local name = skill.Name
				-- local cost = skill.Cost
				-- local useshp = skill.UsesHP
				-- local icon = skill.Icon
				-- local canAdd = skill.CanObtain or true
				-- if canAdd == false then return end
				-- skill_box_list:AddChoice(name,{Name = name,Cost = cost,UsesHP = useshp,Icon = icon},false,"hud/persona/png/hud_" .. icon .. ".png")
			-- end
			-- skill_box_list.OnSelect = function(comboIndex,comboName,comboData)
				-- local data = skill_box_list:GetOptionData(comboName)
				-- RunConsoleCommand("persona_skill_name",data.Name)
				-- RunConsoleCommand("persona_skill_cost",data.Cost)
				-- RunConsoleCommand("persona_skill_useshp",data.UsesHP == true && 1 or 0)
				-- RunConsoleCommand("persona_skill_icon",data.Icon)
				-- Panel.PCost:SetText("Cost: " .. tostring(data.Cost))
				-- Panel.PHP:SetText(data.UsesHP == 1 && "Uses HP: Yes" or "Uses HP: No")
				-- Panel.PIcon:SetImage("hud/persona/png/hud_" .. data.Icon .. ".png")
				-- surface.PlaySound("cpthazama/persona4/ui_hover.wav")
			-- end
			-- Panel:AddPanel(skill_box_list)

			-- Panel.PIcon = vgui.Create("DImage",Panel)
			-- Panel.PIcon:SetSize(122,41)
			-- Panel.PIcon:SetImage("hud/persona/png/hud_" .. GetConVarString("persona_skill_icon") .. ".png")
			-- Panel:AddPanel(Panel.PIcon)

			-- Panel.PCost = vgui.Create("DLabel")
			-- Panel.PCost:SetText("Cost: " .. tostring(GetConVarNumber("persona_skill_cost")))
			-- Panel:AddPanel(Panel.PCost)

			-- Panel.PHP = vgui.Create("DLabel")
			-- Panel.PHP:SetText(GetConVarNumber("persona_skill_useshp") == 1 && "Uses HP: Yes" or "Uses HP: No")
			-- Panel:AddPanel(Panel.PHP)

			-- Panel:AddControl("Button",{Label = "Add Skill",Command = "persona_addskill"})
		end,{})

		-- spawnmenu.AddToolMenuOption("Persona","Persona","Skill Select","Skill Select","","",function(Panel)
			-- Panel:AddControl("Label",{Text = "Don't like pressing R to cycle skills? Here's your low-quality Skill Menu because I suck at GUI! :D"})

			-- Panel.SkillList = vgui.Create("DComboBox")
			-- Panel.SkillList:SetSize(100,30)
			-- Panel.SkillList:SetValue("Select A Skill")
			-- for index,data in pairs(skills) do
				-- local sName = data.Name
				-- local sCost = data.Cost
				-- local sHP = data.UsesHP
				-- local sIcon = data.Icon
				-- Panel.SkillList:AddChoice(sName,{Index = index,Name = sName,Cost = sCost,UsesHP = sHP,Icon = sIcon},false,"hud/persona/png/hud_" .. sIcon .. ".png")
			-- end
			-- Panel.SkillList.OnSelect = function(comboIndex,comboName,comboData)
				-- local data = Panel.SkillList:GetOptionData(comboName)
				-- if IsValid(ply) then
					
				-- end
				-- if IsValid(persona) then
					-- persona:SetActiveCard(data.Name,data.Cost,data.UsesHP,data.Icon,data.index)
				-- end
			-- end
			-- Panel:AddPanel(Panel.SkillList)
		-- end,{})

		-- spawnmenu.AddToolMenuOption("Persona","Party","Set-Up","Set-Up","","",function(Panel)
			-- Panel:AddControl("Button",{Label = "Add To Party",Command = "persona_party"})
			-- Panel:AddControl("Button",{Label = "Remove From Party",Command = "persona_partyremove"})
			-- Panel:AddControl("Button",{Label = "Disband Party",Command = "persona_partyclear"})
			-- Panel:AddControl("Label",{Text = "Must be looking at a Player to add/remove them!"})
		-- end,{})

		spawnmenu.AddToolMenuOption("Persona","Admin Settings","Cheats","Cheats","","",function(Panel)
			Panel:AddControl("TextBox",{Label = "Player Level",Command = "persona_i_ply_setlevel",WaitForEnter = "1"})
			Panel:AddControl("Button",{Label = "Set Player Level",Command = "persona_ply_setlevel"})

			Panel:AddControl("TextBox",{Label = "Player EXP",Command = "persona_i_ply_setexp",WaitForEnter = "0"})
			Panel:AddControl("Button",{Label = "Set Player EXP",Command = "persona_ply_setexp"})

			Panel:AddControl("Button",{Label = "Level Up Player",Command = "persona_player_giveexp"})

			Panel:AddControl("TextBox",{Label = "Player SP",Command = "persona_i_setsp",WaitForEnter = "1"})
			Panel:AddControl("Button",{Label = "Set Player SP",Command = "persona_setsp"})

			Panel:AddControl("TextBox",{Label = "Persona Level",Command = "persona_i_setlevel",WaitForEnter = "1"})
			Panel:AddControl("Button",{Label = "Set Persona Level",Command = "persona_setlevel"})

			Panel:AddControl("TextBox",{Label = "Persona EXP",Command = "persona_i_setexp",WaitForEnter = "0"})
			Panel:AddControl("Button",{Label = "Set Persona EXP",Command = "persona_setexp"})

			Panel:AddControl("Button",{Label = "Level Up Persona",Command = "persona_giveexp"})
		end,{})
	end)

	CreateClientConVar("persona_skill_name","BLANK",false,true)
	CreateClientConVar("persona_skill_cost","0",false,true)
	CreateClientConVar("persona_skill_useshp","0",false,true)
	CreateClientConVar("persona_skill_icon","unknown",false,true)
	CreateClientConVar("persona_i_setlevel","1",false,true)
	CreateClientConVar("persona_i_setexp","0",false,true)
	CreateClientConVar("persona_i_setsp","1",false,true)
	CreateClientConVar("persona_i_ply_setlevel","1",false,true)
	CreateClientConVar("persona_i_ply_setexp","0",false,true)
end

local function persona_addskill(ply)
	local persona = ply:GetInfo("persona_comp_name")
	if ply:IsAdmin() or ply:IsSuperAdmin() then
		local Data = {}
		Data.Name = GetConVarString("persona_skill_name") or "BLANK"
		Data.Cost = GetConVarNumber("persona_skill_cost") or 0
		Data.UsesHP = GetConVarNumber("persona_skill_useshp") == 1 && true or false
		Data.Icon = GetConVarString("persona_skill_icon") or "unknown"
		-- if CLIENT then
			local snd = CreateSound(ply,"cpthazama/persona5/misc/00104.wav")
			snd:SetSoundLevel(0)
			snd:Play()
			snd:ChangeVolume(0.5)
			local snd = CreateSound(ply,"cpthazama/persona4/ui_newskill.wav")
			snd:SetSoundLevel(0)
			snd:Play()
			snd:ChangeVolume(0.5)
		-- end
		if SERVER then
			if Data.Name == "BLANK" then
				ply:ChatPrint("Select A Skill First!")
				local snd = CreateSound(ply,"cpthazama/persona5/misc/00103.wav")
				snd:SetSoundLevel(0)
				snd:Play()
				snd:ChangeVolume(0.5)
				return
			end
			local skill = ents.Create("item_persona_skill")
			if IsValid(skill) then
				skill:SetPos(ply:GetPos() +Vector(0,0,10))
				skill:SetSpawner(ply)
				skill:SetPersona(persona)
				skill:Spawn()
				skill.SkillData = {Name = Data.Name, Cost = Data.Cost, UsesHP = Data.UsesHP, Icon = Data.Icon}
			end
		end
	end
end
concommand.Add("persona_addskill",persona_addskill)

local function persona_ply_setlevel(ply)
	if ply:IsAdmin() or ply:IsSuperAdmin() then
		PXP.SetPlayerLevel(ply,math.Clamp(GetConVarNumber("persona_i_ply_setlevel"),1,99))
	end
end
concommand.Add("persona_ply_setlevel",persona_ply_setlevel)

local function persona_ply_setexp(ply)
	if ply:IsAdmin() or ply:IsSuperAdmin() then
		PXP.SetPlayerEXP(ply,GetConVarNumber("persona_i_ply_setexp"))
	end
end
concommand.Add("persona_ply_setexp",persona_ply_setexp)

local function persona_setlevel(ply)
	if ply:IsAdmin() or ply:IsSuperAdmin() then
		PXP.SetLevel(ply,math.Clamp(GetConVarNumber("persona_i_setlevel"),1,99))
	end
end
concommand.Add("persona_setlevel",persona_setlevel)

local function persona_setexp(ply)
	if ply:IsAdmin() or ply:IsSuperAdmin() then
		PXP.SetEXP(ply,GetConVarNumber("persona_i_setexp"))
	end
end
concommand.Add("persona_setexp",persona_setexp)

local function persona_setsp(ply)
	if ply:IsAdmin() or ply:IsSuperAdmin() then
		local sp = GetConVarNumber("persona_i_setsp")
		ply:SetSP(sp)
		if sp > ply:GetMaxSP() then
			ply:SetMaxSP(sp)
		end
	end
end
concommand.Add("persona_setsp",persona_setsp)

local function persona_player_giveexp(ply)
	if ply:IsAdmin() or ply:IsSuperAdmin() then
		PXP.GiveRequiredPlayerEXP(ply)
	end
end
concommand.Add("persona_player_giveexp",persona_player_giveexp)

local function persona_giveexp(ply)
	if ply:IsAdmin() or ply:IsSuperAdmin() then
		PXP.GiveRequiredEXP(ply)
	end
end
concommand.Add("persona_giveexp",persona_giveexp)