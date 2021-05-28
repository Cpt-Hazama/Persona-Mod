AddCSLuaFile("shared.lua")
include('shared.lua')
/*-----------------------------------------------
	*** Copyright (c) 2012-2019 by Cpt. Hazama, All rights reserved. ***
	No parts of this code or any of its contents may be reproduced, copied, modified or adapted,
	without the prior written consent of the author, unless otherwise indicated for stand-alone materials.
-----------------------------------------------*/
ENT.Model = {"models/cpthazama/persona5/enemies/kamoshidaguard.mdl"} -- The game will pick a random model from the table when the SNPC is spawned | Add as many as you want 

ENT.VJ_NPC_Class = {"CLASS_PERSONA_ENEMY","CLASS_KAMOSHIDA","CLASS_SHADOW"}

ENT.AvailablePersonae = {
	"jack",
	"hypnos",
	"medea",
	"yoshitsune",
}
---------------------------------------------------------------------------------------------------------------------------------------------
function ENT:BeforeInit()
	self.Persona = VJ_PICK(self.AvailablePersonae)
	
	self.Stats = {
		HP = math.random(40,110),
		SP = math.random(54,124),
	}
end
/*-----------------------------------------------
	*** Copyright (c) 2012-2019 by Cpt. Hazama, All rights reserved. ***
	No parts of this code or any of its contents may be reproduced, copied, modified or adapted,
	without the prior written consent of the author, unless otherwise indicated for stand-alone materials.
-----------------------------------------------*/