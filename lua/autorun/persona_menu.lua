	--// Thanks NPP, very cool \\--
if SERVER then
	util.AddNetworkString("Persona_ShowStatsMenu")
	util.AddNetworkString("Persona_UpdateSkillMenu")
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
		-- local pSTR = net.ReadInt(32)
		-- local pMAG = net.ReadInt(32)
		-- local pEND = net.ReadInt(32)
		-- local pAGI = net.ReadInt(32)
		-- local pLUC = net.ReadInt(32)
		local tbl = {}
		tbl[1] = {t="STR",val=net.ReadInt(32)}
		tbl[2] = {t="MAG",val=net.ReadInt(32)}
		tbl[3] = {t="END",val=net.ReadInt(32)}
		tbl[4] = {t="AGI",val=net.ReadInt(32)}
		tbl[5] = {t="LUC",val=net.ReadInt(32)}

		local Frame = vgui.Create("DFrame")
		Frame:SetSize(225,175)
		Frame:SetPos(ScrW() *0.5, ScrH() *0.5)
		Frame:SetTitle(pName .. "'s Stats")
		Frame:SetBackgroundBlur(true)
		Frame:SetSizable(false)
		Frame:SetDeleteOnClose(false)
		Frame:MakePopup()
		Frame.OnClose = function()
			if IsValid(ply) then
				ply:EmitSound("cpthazama/persona4/ui_hover.wav",65)
			end
		end

		local posChange = 30
		for _,v in pairs(tbl) do
			local label = vgui.Create("DLabel",Frame)
			label:SetPos(10,posChange)
			label:SetText(v.t .. " - " .. v.val .. " / 99")
			label:SizeToContents()
			posChange = posChange +30
		end
	end)
end

local function ShowStats(ply)
	-- if SERVER then
		local persona = ply:GetPersona()
		if !IsValid(persona) then
			ply:ChatPrint("Summon your Persona first!")
			return
		end
		local stats = persona.Stats
		if stats then
			net.Start("Persona_ShowStatsMenu")
				net.WriteString(PERSONA[ply:GetPersonaName()].Name)
				net.WriteInt(stats.STR,32)
				net.WriteInt(stats.MAG,32)
				net.WriteInt(stats.END,32)
				net.WriteInt(stats.AGI,32)
				net.WriteInt(stats.LUC,32)
			net.Send(ply)
		end
		local stats = persona.Stats
		ply:ChatPrint(persona.FeedName .. "'s Stats:")
		ply:ChatPrint("STR - " .. stats.STR)
		ply:ChatPrint("MAG - " .. stats.MAG)
		ply:ChatPrint("END - " .. stats.END)
		ply:ChatPrint("AGI - " .. stats.AGI)
		ply:ChatPrint("LUC - " .. stats.LUC)
		ply:EmitSound(Sound("cpthazama/persona4/ui_shufflebegin.wav"))
	-- end
	-- local persona = ply:GetPersona()
	-- if IsValid(persona) then
		-- local stats = persona.Stats
		-- ply:ChatPrint(persona.FeedName .. " Stats:")
		-- ply:ChatPrint("STR - " .. stats.STR)
		-- ply:ChatPrint("MAG - " .. stats.MAG)
		-- ply:ChatPrint("END - " .. stats.END)
		-- ply:ChatPrint("AGI - " .. stats.AGI)
		-- ply:ChatPrint("LUC - " .. stats.LUC)
	-- else
		-- ply:ChatPrint("Summon your Persona first!")
	-- end
	-- ply:EmitSound(Sound("cpthazama/persona4/ui_changepersona.wav"))
end
concommand.Add("persona_showstats",ShowStats)

local function MakeLegendary(ply)
	if PXP.GetLevel(ply) >= 99 && !PXP.IsLegendary(ply) && !PXP.IsVelvet(ply) then
		PXP.SetLegendary(ply)
		ply:EmitSound(Sound("cpthazama/persona4/ui_changepersona.wav"))
		ply:ChatPrint(PERSONA[ply:GetPersonaName()].Name .. " is now a Legendary Persona!")
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
		end,{})

		spawnmenu.AddToolMenuOption("Persona","Main Settings","NPCs","NPCs","","",function(Panel)
			Panel:AddControl("CheckBox",{Label = "Enable NPC Themes",Command = "vj_persona_music"})
			Panel:AddControl("Label",{Text = "Note: You can also enable/disable them per NPC!"})
		end,{})

		spawnmenu.AddToolMenuOption("Persona","Dance Settings","Dance","Dance","","",function(Panel)
			Panel:AddControl("Slider",{Label = "Music Volume",Command = "vj_persona_dancevol",Min = 15,Max = 100})
			Panel:AddControl("Label",{Text = "Default = 60%"})
			Panel:AddControl("Slider",{Label = "Dance Mode",Command = "vj_persona_dancemode",Min = 1,Max = 2})
			Panel:AddControl("Label",{Text = "1 = Spectate, 2 = Dance, Dance!"})
			Panel:AddControl("Slider",{Label = "Dance Difficulty",Command = "vj_persona_dancedifficulty",Min = 1,Max = 5})
			Panel:AddControl("Label",{Text = "1 = Easy, 2 = Normal, 3 = Hard, 4+ = You're Crazy"})
			Panel:AddControl("Slider",{Label = "Note Speed",Command = "persona_dance_notespeed",Min = 1,Max = 8})
			Panel:AddControl("Label",{Text = "Default = 4"})
			Panel:AddControl("CheckBox",{Label = "Enable Perfect Play",Command = "persona_dance_perfect"})
			Panel:AddControl("Label",{Text = "Scores will not be saved in Perfect Play mode!"})
			Panel:AddControl("CheckBox",{Label = "Controller Mode",Command = "persona_dance_controller"})
			Panel:AddControl("Label",{Text = "Enable this to play with a controller!"})
			Panel:AddControl("CheckBox",{Label = "Cinematic Mode",Command = "persona_dance_cinematic"})
			Panel:AddControl("Label",{Text = "If the Dancer has a Cinematic Mode, this will give Dance Mode 1 & 2 an authentic feel!"})
			if !(!game.SinglePlayer() && !LocalPlayer():IsAdmin()) then
				Panel:AddControl("Label",{Text = "Admin Settings"})
				Panel:AddControl("CheckBox",{Label = "Enable Developer Tools",Command = "persona_dance_dev"})
			end
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
			Panel:AddControl("Button",{Label = "Print Persona Stats",Command = "persona_showstats"})
			Panel:AddControl("Button",{Label = "Create Legendary Persona",Command = "persona_legendary"})
			Panel:AddControl("Label",{Text = "Persona must be LVL 99 to become Legendary!"})

			local skill_box_list = vgui.Create("DComboBox")
			skill_box_list:SetSize(100,30)
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
				-- Panel.PName:SetText("Skill Name: " .. data.Name)
				Panel.PCost:SetText("Cost: " .. tostring(data.Cost))
				Panel.PHP:SetText(data.UsesHP == 1 && "Uses HP: Yes" or "Uses HP: No")
				Panel.PIcon:SetImage("hud/persona/png/hud_" .. data.Icon .. ".png")
				surface.PlaySound("cpthazama/persona4/ui_hover.wav")
				-- surface.PlaySound("cpthazama/persona4/ui_newskill.wav")
			end
			Panel:AddPanel(skill_box_list)

			-- local text = vgui.Create("DLabel")
			-- text:SetText("Current Selected Skill")

			Panel.PIcon = vgui.Create("DImage",Panel)
			Panel.PIcon:SetSize(122,41)
			Panel.PIcon:SetImage("hud/persona/png/hud_" .. GetConVarString("persona_skill_icon") .. ".png")
			Panel:AddPanel(Panel.PIcon)

			-- Panel.PName = vgui.Create("DLabel")
			-- Panel.PName:SetText("Skill Name: " .. GetConVarString("persona_skill_name"))
			-- Panel:AddPanel(Panel.PName)

			Panel.PCost = vgui.Create("DLabel")
			Panel.PCost:SetText("Cost: " .. tostring(GetConVarNumber("persona_skill_cost")))
			Panel:AddPanel(Panel.PCost)

			Panel.PHP = vgui.Create("DLabel")
			Panel.PHP:SetText(GetConVarNumber("persona_skill_useshp") == 1 && "Uses HP: Yes" or "Uses HP: No")
			Panel:AddPanel(Panel.PHP)

			Panel:AddControl("Button",{Label = "Add Skill",Command = "persona_addskill"})
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

		spawnmenu.AddToolMenuOption("Persona","Party","Set-Up","Set-Up","","",function(Panel)
			Panel:AddControl("Button",{Label = "Add To Party",Command = "persona_party"})
			Panel:AddControl("Button",{Label = "Remove From Party",Command = "persona_partyremove"})
			Panel:AddControl("Button",{Label = "Disband Party",Command = "persona_partyclear"})
			Panel:AddControl("Label",{Text = "Must be looking at a Player to add/remove them!"})
		end,{})

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