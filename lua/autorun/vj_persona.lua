/*--------------------------------------------------
	=============== Autorun File ===============
	*** Copyright (c) 2012-2020 by Cpt. Hazama, All rights reserved. ***
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
	VJ.AddCategoryInfo(vCat,{Icon = "vj_icons/persona.png"})

		-- Persona - Raid Bossess --
	-- These all use the song Shadow as their theme --
	-- VJ.AddNPC("Makoto Niijima (Shadow)","npc_vj_per_makoto_shadow",vCat)
	-- VJ.AddNPC("Yu Narukami (Shadow)","npc_vj_per_yu_shadow",vCat)
	-- VJ.AddNPC("Tohru Adachi (Shadow)","npc_vj_per_adachi_shadow",vCat)
	-- VJ.AddNPC("Sho Minazuki (Shadow)","npc_vj_per_sho_shadow",vCat)

		-- Persona 5 - Protagonists --
	-- VJ.AddNPC("Ren Amamiya","npc_vj_per_ren",vCat) -- Persona: Arsène and Satanael | Theme: Last Surprise / Groovy
	VJ.AddNPC("Makoto Niijima","npc_vj_per_makoto",vCat) -- Johanna and Anat | Theme: Price
	VJ.AddNPC("Goro Akechi","npc_vj_per_akechi_crow",vCat) -- Persona: Robin Hood | Theme: Ark
	VJ.AddNPC("Lavenza","npc_vj_per_lavenza",vCat) -- Persona: Thor, Berith and Atavaka | Theme: Rivers in The Desert

		-- Persona 5 - Antagonists --
	-- VJ.AddNPC("Shido (Shadow)","npc_vj_per_shido",vCat) -- Theme: Rivers in The Desert -instrumental-
	-- VJ.AddNPC("Sae Niijima (Shadow)","npc_vj_per_sae",vCat) -- Persona: Leviathan | Theme: The Whims Of Fate
	-- VJ.AddNPC("Holy Grail","npc_vj_per_yaldabaoth_stage1",vCat) -- Theme: Yaldabaoth
	-- VJ.AddNPC("Yaldabaoth","npc_vj_per_yaldabaoth",vCat) -- Theme: Yaldabaoth
	VJ.AddNPC("Goro Akechi (Black Mask)","npc_vj_per_akechi",vCat) -- Persona: Loki and Hereward | Theme: Reincarnation (I'll Face Myself)
	
		-- Persona 4 - Protagonists --
	VJ.AddNPC("Yu Narukami","npc_vj_per_yu",vCat) -- Izanagi / Izanagi-no-Okami | Theme: Reach Out To The Truth (Arena Ver.)
	VJ.AddNPC("Labrys","npc_vj_per_labrys",vCat) -- Ariadne | Theme: Spirited Girl
	
	-- VJ.AddNPC("Elizabeth","npc_vj_per_elizabeth",vCat) -- Thanatos | Theme: Whims Of Everyone's Souls
	-- VJ.AddNPC("Margaret","npc_vj_per_margaret",vCat) -- Yoshitsune | Theme: Electronica In The Velvet Room
	
		-- Persona 4 - Antagonists -- 
	VJ.AddNPC("Tohru Adachi","npc_vj_per_adachi",vCat) -- Magatsu-Izanagi | Theme: A Fool or A Clown? / A New World Fool
	-- VJ.AddNPC("Sho Minazuki","npc_vj_per_sho",vCat) -- Tsukiyomi | Theme: Blood Red Moon
	VJ.AddNPC("Shadow Labrys","npc_vj_per_labrys_shadow",vCat) -- Asterius | Theme: Shadows of the Labrynth
	
		-- Persona 3 - Protagonists
	VJ.AddNPC("Makoto Yuki","npc_vj_per_yuki",vCat) -- Orpheos / Messiah | Theme: Mass Destruction
	-- VJ.AddNPC("Yukari Takeba","npc_vj_per_yukari",vCat) -- Isis | Theme: Pink Sniper

	VJ.AddClientConVar("vj_persona_music",1)

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