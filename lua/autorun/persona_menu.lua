local function ShowStats(ply)
	local persona = ply:GetPersona()
	if IsValid(persona) then
		local stats = persona.Stats
		ply:ChatPrint(persona.FeedName .. " Stats:")
		ply:ChatPrint("STR - " .. stats.STR)
		ply:ChatPrint("MAG - " .. stats.MAG)
		ply:ChatPrint("END - " .. stats.END)
		ply:ChatPrint("AGI - " .. stats.AGI)
		ply:ChatPrint("LUC - " .. stats.LUC)
	else
		ply:ChatPrint("Summon your Persona first!")
	end
	ply:EmitSound(Sound("cpthazama/persona4/ui_changepersona.wav"))
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
				persona_hud_y = "250",
				persona_hud_damage = "1",
				-- persona_hud_raidboss = "0",
			}
			Panel:AddControl("ComboBox",DefaultBox)
			Panel:AddControl("Slider",{Label = "Box X Position",Command = "persona_hud_x",Min = 0,Max = 1920})
			Panel:AddControl("Slider",{Label = "Box Y Position",Command = "persona_hud_y",Min = 0,Max = 1080})
			Panel:AddControl("CheckBox",{Label = "Enable Damage Markers",Command = "persona_hud_damage"})
			-- Panel:AddControl("CheckBox",{Label = "Enable Raid Boss Portraits",Command = "persona_hud_raidboss"})
		end,{})

		spawnmenu.AddToolMenuOption("Persona","Main Settings","NPCs","NPCs","","",function(Panel)
			Panel:AddControl("CheckBox",{Label = "Enable NPC Themes",Command = "vj_persona_music"})
			Panel:AddControl("Label",{Text = "Note: You can also enable/disable them per NPC!"})
		end,{})

		spawnmenu.AddToolMenuOption("Persona","Dance Settings","Dance","Dance","","",function(Panel)
			Panel:AddControl("Slider",{Label = "Dancer Mode",Command = "vj_persona_dancemode",Min = 0,Max = 2})
			Panel:AddControl("Label",{Text = "0 - Default, 1 - Spectate, 2 - Dance, Dance!"})
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

		spawnmenu.AddToolMenuOption("Persona","Party","Set-Up","Set-Up","","",function(Panel)
			Panel:AddControl("Button",{Label = "Add To Party",Command = "persona_party"})
			Panel:AddControl("Button",{Label = "Remove From Party",Command = "persona_partyremove"})
			Panel:AddControl("Button",{Label = "Disband Party",Command = "persona_partyclear"})
			Panel:AddControl("Label",{Text = "Must be looking at a Player to add/remove them!"})
		end,{})

		spawnmenu.AddToolMenuOption("Persona","Admin Settings","Cheats","Cheats","","",function(Panel)
			Panel:AddControl("TextBox",{Label = "Level",Command = "persona_i_setlevel",WaitForEnter = "1"})
			Panel:AddControl("Button",{Label = "Set Level",Command = "persona_setlevel"})

			Panel:AddControl("TextBox",{Label = "EXP",Command = "persona_i_setexp",WaitForEnter = "0"})
			Panel:AddControl("Button",{Label = "Set EXP",Command = "persona_setexp"})

			Panel:AddControl("Button",{Label = "Give Req. EXP",Command = "persona_giveexp"})

			Panel:AddControl("TextBox",{Label = "SP",Command = "persona_i_setsp",WaitForEnter = "1"})
			Panel:AddControl("Button",{Label = "Set SP",Command = "persona_setsp"})
		end,{})
	end)

	CreateClientConVar("persona_skill_name","BLANK",false,true)
	CreateClientConVar("persona_skill_cost","0",false,true)
	CreateClientConVar("persona_skill_useshp","0",false,true)
	CreateClientConVar("persona_skill_icon","unknown",false,true)
	CreateClientConVar("persona_i_setlevel","1",false,true)
	CreateClientConVar("persona_i_setexp","0",false,true)
	CreateClientConVar("persona_i_setsp","1",false,true)
end

local function persona_addskill(ply)
	if ply:IsAdmin() or ply:IsSuperAdmin() then
		local Data = {}
		Data.Name = GetConVarString("persona_skill_name") or "BLANK"
		Data.Cost = GetConVarNumber("persona_skill_cost") or 0
		Data.UsesHP = GetConVarNumber("persona_skill_useshp") == 1 && true or false
		Data.Icon = GetConVarString("persona_skill_icon") or "unknown"
		if SERVER then
			if Data.Name == "BLANK" then
				ply:ChatPrint("Select A Skill First!")
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

local function persona_giveexp(ply)
	if ply:IsAdmin() or ply:IsSuperAdmin() then
		PXP.GiveRequiredEXP(ply)
	end
end
concommand.Add("persona_giveexp",persona_giveexp)