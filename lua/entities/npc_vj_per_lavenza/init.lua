AddCSLuaFile("shared.lua")
include('shared.lua')
/*-----------------------------------------------
	*** Copyright (c) 2012-2019 by Cpt. Hazama, All rights reserved. ***
	No parts of this code or any of its contents may be reproduced, copied, modified or adapted,
	without the prior written consent of the author, unless otherwise indicated for stand-alone materials.
-----------------------------------------------*/
ENT.Model = {"models/cpthazama/persona5/lavenza.mdl"} -- The game will pick a random model from the table when the SNPC is spawned | Add as many as you want 
ENT.Stats = {
	HP = 20000,
	SP = 999,
	LVL = 99,
	STR = 99,
	MAG = 99,
	END = 99,
	AGI = 99,
	LUC = 99,
}
ENT.VJ_NPC_Class = {"CLASS_PLAYER_ALLY","CLASS_VELVET_ROOM"}

util.AddNetworkString("vj_persona_hud_lavenza")
util.AddNetworkString("vj_persona_hud_lavenza_speech")
---------------------------------------------------------------------------------------------------------------------------------------------
function ENT:Controller_Initialize(ply)
    net.Start("vj_persona_hud_lavenza")
		net.WriteBool(false)
		net.WriteEntity(self)
    net.Send(ply)

	function self.VJ_TheControllerEntity:CustomOnStopControlling()
		net.Start("vj_persona_hud_lavenza")
			net.WriteBool(true)
			net.WriteEntity(self)
		net.Send(ply)
	end
end
---------------------------------------------------------------------------------------------------------------------------------------------
function ENT:PersonaInit()
	self:SetCollisionBounds(Vector(8,8,48),Vector(-8,-8,0))
end
---------------------------------------------------------------------------------------------------------------------------------------------
function ENT:CustomOnAcceptInput(key,ent,caller,data)
	if ent:IsPlayer() then
		self:OnInteract(ent)
	end
end
/*-----------------------------------------------
	*** Copyright (c) 2012-2019 by Cpt. Hazama, All rights reserved. ***
	No parts of this code or any of its contents may be reproduced, copied, modified or adapted,
	without the prior written consent of the author, unless otherwise indicated for stand-alone materials.
-----------------------------------------------*/