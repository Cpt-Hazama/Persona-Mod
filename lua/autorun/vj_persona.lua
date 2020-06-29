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
	
	/*
		Characters with the wild card ability:
		- Ren
		- Caroline
		- Justine
		- Lavenza
		- Akechi

		- Yu
		- Elizabeth
		- Margaret
	*/

		-- Persona 5 - Protagonists --
	VJ.AddNPC("Ren Amamiya","npc_vj_per_ren",vCat) -- Persona: Arsène and Satanael
	VJ.AddNPC("Makoto Niijima","npc_vj_per_makoto",vCat) -- Johanna
	VJ.AddNPC("Ann Takamaki","npc_vj_per_ann",vCat) -- Carmen
	VJ.AddNPC("Caroline","npc_vj_per_caroline",vCat) -- Shiisaa
	VJ.AddNPC("Justine","npc_vj_per_justine",vCat) -- Sudama
	VJ.AddNPC("Lavenza","npc_vj_per_lavenza",vCat) -- Persona: Thor, Berith and Atavaka | Theme: Rivers in The Desert

		-- Persona 5 - Antagonists --
	VJ.AddNPC("Kamoshida (Shadow)","npc_vj_per_kamoshida",vCat)
	VJ.AddNPC("Madarame (Shadow)","npc_vj_per_madarame",vCat)
	VJ.AddNPC("Yaldabaoth","npc_vj_per_yaldabaoth",vCat)
	VJ.AddNPC("Goro Akechi","npc_vj_per_akechi",vCat) -- Persona: Loki and Hereward | Theme: Reincarnation (I'll Face Myself)
	
		-- Persona 4 - Protagonists --
	VJ.AddNPC("Yu Narukami","npc_vj_per_yu",vCat) -- Izanagi / Izanagi-no-Okami
	-- VJ.AddNPC("Elizabeth","npc_vj_per_elizabeth",vCat) -- Thanatos
	-- VJ.AddNPC("Margaret","npc_vj_per_margaret",vCat) -- Yoshitsune
	
		-- Persona 4 - Antagonists -- 
	VJ.AddNPC("Tohru Adachi","npc_vj_per_adachi",vCat) -- Magatsu-Izanagi

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