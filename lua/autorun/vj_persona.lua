/*--------------------------------------------------
	=============== Autorun File ===============
	*** Copyright (c) 2012-2021 by Cpt. Hazama, All rights reserved. ***
	No parts of this code or any of its contents may be reproduced, copied, modified or adapted,
	without the prior written consent of the author, unless otherwise indicated for stand-alone materials.
--------------------------------------------------*/
------------------ Addon Information ------------------
local PublicAddonName = "Persona Mod"
local AddonName = "Persona"
local AddonType = "SNPC"
local AutorunFile = "autorun/vj_persona.lua"
-------------------------------------------------------
local VJExists = file.Exists("lua/autorun/vj_base_autorun.lua","GAME")
if VJExists == true then
	include('autorun/vj_controls.lua')

	local vCat = "Persona"
	local vCatBad = "Persona - Villains"
	VJ.AddCategoryInfo(vCat,{Icon = "vj_icons/persona.png"})
	VJ.AddCategoryInfo(vCat .. " - Villains",{Icon = "vj_icons/persona.png"})
	VJ.AddCategoryInfo(vCat .. " - Bosses",{Icon = "vj_icons/persona.png"})
	VJ.AddCategoryInfo(vCat .. " - Gamemode",{Icon = "vj_icons/persona.png"})

	-- VJ.AddNPC("Ren Amamiya","npc_vj_per_ren",vCat)
	VJ.AddNPC("Ann Takamaki","npc_vj_per_ann",vCat)
	VJ.AddNPC("Makoto Niijima","npc_vj_per_makoto",vCat)
	VJ.AddNPC("Goro Akechi","npc_vj_per_akechi_crow",vCat)
	VJ.AddNPC("Lavenza","npc_vj_per_lavenza",vCat)

	-- VJ.AddNPC("Holy Grail","npc_vj_per_yaldabaoth_stage1",vCatBad)
	-- VJ.AddNPC("Yaldabaoth","npc_vj_per_yaldabaoth",vCatBad)
	VJ.AddNPC("Goro Akechi (Black Mask)","npc_vj_per_akechi",vCatBad)
	
	VJ.AddNPC("Yu Narukami","npc_vj_per_yu",vCat)
	VJ.AddNPC("Labrys","npc_vj_per_labrys",vCat)
	
	VJ.AddNPC("Tohru Adachi","npc_vj_per_adachi",vCatBad)
	VJ.AddNPC("Shadow Labrys","npc_vj_per_labrys_shadow",vCatBad)
	
	VJ.AddNPC("Makoto Yuki","npc_vj_per_yuki",vCat)
	-- VJ.AddNPC("Elizabeth","npc_vj_per_elizabeth",vCat)

		-- Shadows --
	VJ.AddNPC("Tohru Adachi (Shadow)","npc_vj_per_adachi_boss",vCatBad)
	VJ.AddNPC("Yu Narukami (Shadow)","npc_vj_per_yu_shadow",vCatBad)

	VJ.AddNPC("(Shadow) Player","npc_vj_per_shadow",vCatBad)

		-- Persona Gamemode Exclusives --
	VJ.AddNPC("(Shadow) Kamoshida Guard","npc_vj_per_enemy_kamoshidaguard",vCatBad)
	-- VJ.AddNPC("Kamoshida Guard","npc_vj_per_enemy_kamoshidaguard",vCat .. " - Gamemode")
	-- VJ.AddNPC("Munehisa Iwai","npc_vj_per_vendor_iwai",vCat .. " - Gamemode")
	
		-- Unused but, maybe in the future? It's easier to just manually code than make a cue system
	CUE_BATTLE_DISADVANTAGE = 1
	CUE_BATTLE_ADVANTAGE = 2
	CUE_BATTLE_ALLOUTATTACK = 3
	CUE_BATTLE_ = 4
	CUE_BATTLE_MELEEATTACK = 21
	CUE_BATTLE_GETUP = 22
	CUE_BATTLE_PERSONA_PHYS_A = 23
	CUE_BATTLE_PERSONA_PHYS_B = 34
	CUE_BATTLE_PERSONA_PHYS_C = 1004
	CUE_BATTLE_PERSONA_MAGIC = 24
	CUE_BATTLE_MISSENEMY_A = 25
	CUE_BATTLE_MISSENEMY_B = 31
	CUE_BATTLE_ENEMYRESIST = 26
	CUE_BATTLE_ENEMYCOUNT_FOUR = 27
	CUE_BATTLE_ENEMYCOUNT_THREE = 28
	CUE_BATTLE_ENEMYCOUNT_TWO = 29
	CUE_BATTLE_ENEMYCOUNT_ONE = 30
	CUE_BATTLE_ENEMYCOUNT_ONE_B = 66
	CUE_BATTLE_PERSONA_SUMMON_A = 32
	CUE_BATTLE_PERSONA_SUMMON_B = 104
	CUE_BATTLE_PERSONA_SUMMON_C = 80
	CUE_BATTLE_GIVE_ITEM = 33
	CUE_BATTLE_KILLENEMY = 35
	CUE_BATTLE_SELFPAIN_A = 36
	CUE_BATTLE_SELFPAIN_B = 37
	CUE_BATTLE_SELFPAIN_C = 50
	CUE_BATTLE_DEATH = 38
	CUE_BATTLE_CRITICAL_ENTER = 39
	CUE_BATTLE_DODGE = 51
	CUE_BATTLE_BATON_OTHER = 52
	CUE_BATTLE_BATON_SELF = 53
	CUE_BATTLE_ASSISTBRAINWASH_START = 64
	CUE_BATTLE_ASSISTBRAINWASH = 65
	CUE_BATTLE_HEAL_RECIEVE = 81
	CUE_BATTLE_FINISH = 82
	CUE_BATTLE_LEVELUP = 85
	CUE_BATTLE_PLAYERTURN_IDLE = 1001
	CUE_BATTLE_SKILL_TAUNT = 1003
	CUE_BATTLE_HITENEMY = 1007
	CUE_BATTLE_ENEMYRESIST_GUN = 1008
	CUE_BATTLE_ACCEPTCOMMAND = 1022
	CUE_BATTLE_OPEN_SKILLMENU = 104
	
	function VJ_AddSound(sName,sSound,iLevel)
		sound.Add({
			name = sName,
			channel = CHAN_STATIC,
			volume = 1.0,
			level = iLevel or 180,
			sound = sSound
		})
	end

	properties.Add("Toggle Music", {
		MenuLabel = "#Toggle Music",
		Order = 1,
		MenuIcon = "vj_icons/persona16.png",

		Filter = function(self,ent,ply)
			if !IsValid(ent) then return false end
			if !ent:IsNPC() then return false end
			if !ent.VJ_PersonaNPC then return false end
			if ent.ToggleTheme then
				return true
			end
		end,
		Action = function(self,ent) -- CS
			self:MsgStart()
				net.WriteEntity(ent)
			self:MsgEnd()
			ent:ToggleTheme(!ent.VJ_Persona_HasTheme)
		end,
		Receive = function(self,length,player) -- SV
			local ent = net.ReadEntity()
			if !self:Filter(ent,player) then return end
			player:ChatPrint("Toggled Theme")
		end
	})

-- !!!!!! DON'T TOUCH ANYTHING BELOW THIS !!!!!! -------------------------------------------------------------------------------------------------------------------------
	AddCSLuaFile(AutorunFile)
	VJ.AddAddonProperty(AddonName,AddonType)
else
	if (CLIENT) then
		chat.AddText(Color(0,200,200),PublicAddonName,
		Color(0,255,0)," was unable to install, you are missing ",
		Color(255,100,0),"VJ Base!")
	end
	timer.Simple(1,function()
		if not VJF then
			if (CLIENT) then
				VJF = vgui.Create("DFrame")
				VJF:SetTitle("ERROR!")
				VJF:SetSize(790,560)
				VJF:SetPos((ScrW()-VJF:GetWide())/2,(ScrH()-VJF:GetTall())/2)
				VJF:MakePopup()
				VJF.Paint = function()
					draw.RoundedBox(8,0,0,VJF:GetWide(),VJF:GetTall(),Color(200,0,0,150))
				end
				
				local VJURL = vgui.Create("DHTML",VJF)
				VJURL:SetPos(VJF:GetWide()*0.005, VJF:GetTall()*0.03)
				VJURL:Dock(FILL)
				VJURL:SetAllowLua(true)
				VJURL:OpenURL("https://sites.google.com/site/vrejgaming/vjbasemissing")
			elseif (SERVER) then
				timer.Create("VJBASEMissing",5,0,function() print("VJ Base is Missing! Download it from the workshop!") end)
			end
		end
	end)
end