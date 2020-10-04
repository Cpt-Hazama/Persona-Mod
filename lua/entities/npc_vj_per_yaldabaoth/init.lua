AddCSLuaFile("shared.lua")
include('shared.lua')
/*-----------------------------------------------
	*** Copyright (c) 2012-2019 by Cpt. Hazama, All rights reserved. ***
	No parts of this code or any of its contents may be reproduced, copied, modified or adapted,
	without the prior written consent of the author, unless otherwise indicated for stand-alone materials.
-----------------------------------------------*/
ENT.Model = {"models/cpthazama/persona5/enemies/yaldabaoth.mdl"} -- The game will pick a random model from the table when the SNPC is spawned | Add as many as you want 
ENT.Stats = {
	HP = 1500000,
	SP = 750000,
	STR = 28,
	MAG = 90,
	END = 46,
	AGI = 72,
	LUC = 41,
}
ENT.HullType = HULL_LARGE
ENT.SightDistance = 20000
ENT.SightAngle = 110
ENT.TurningSpeed = 5
ENT.VJ_IsHugeMonster = true
ENT.MovementType = VJ_MOVETYPE_STATIONARY
ENT.Stationary_UseNoneMoveType = true
---------------------------------------------------------------------------------------------------------------------------------------------
ENT.VJ_NPC_Class = {"CLASS_YALDABAOTH"}

ENT.Bleeds = false
ENT.HasMeleeAttack = false

ENT.SoundTbl_CombatIdle = {
	"VJ_YALD_NOMERCY",
	"VJ_YALD_CONDEMYOU",
	"VJ_YALD_YOURPUNISHMENT",
	"VJ_YALD_SENTENCEYOU",
	"VJ_YALD_DEATHGRASPYOU",
	"VJ_YALD_BEGONE",
	"VJ_YALD_ENOUGHCHILDREN",
}
ENT.SoundTbl_Attack = {
	"VJ_YALD_CRUSHYOU",
	"VJ_YALD_SHATTER",
	"VJ_YALD_TODUST",
	"VJ_YALD_NOESCAPE",
}
ENT.SoundTbl_OnKilledEnemy = {
	"VJ_YALD_FITTINGEND",
	"VJ_YALD_EXPECTEDRESULT",
	"VJ_YALD_ENDISNIGH",
}
ENT.SoundTbl_Pain = {
	"VJ_YALD_UGH",
	"VJ_YALD_MERELYHUMAN",
	"VJ_YALD_IMPOSSINGAGOD",
	"VJ_YALD_IMPOSSIBLE",
	"VJ_YALD_STOPFOOLS",
	"VJ_YALD_UNSIGHTLY",
	"VJ_YALD_HOWDAREYOU",
	"VJ_YALD_WHAT",
	"VJ_YALD_IMBECILE",
	"VJ_YALD_SHREWDFOOLS",
}
ENT.SoundTbl_Death = {
	"VJ_YALD_IAMAGOD",
}

ENT.CombatIdleSoundLevel = 150
ENT.OnKilledEnemySoundLevel = 150
ENT.PainSoundLevel = 150
ENT.DeathSoundLevel = 150
ENT.GeneralSoundPitch1 = 100

ENT.VJC_Data = {
    CameraMode = 1, -- Sets the default camera mode | 1 = Third Person, 2 = First Person
    ThirdP_Offset = Vector(-1000, 700, -3500), -- The offset for the controller when the camera is in third person
    FirstP_Bone = "h head06", -- If left empty, the base will attempt to calculate a position for first person
    FirstP_Offset = Vector(55, 0, 0), -- The offset for the controller when the camera is in first person
}
---------------------------------------------------------------------------------------------------------------------------------------------
function ENT:CustomOnInitialize()
	self:SetHealth((GetConVarNumber("vj_npc_allhealth") > 0) and GetConVarNumber("vj_npc_allhealth") or self:VJ_GetDifficultyValue(self.Stats.HP))
	self.SP = self.Stats.SP
	self:SetCollisionBounds(Vector(2000,2000,2305),-(Vector(2000,2000,4305)))

	timer.Simple(0,function()
		self:SetPos(self:GetPos() +Vector(0,0,1500))
	end)

	self:SetSP(self.Stats.SP)
	self:SetMaxSP(self.Stats.SP)
end
---------------------------------------------------------------------------------------------------------------------------------------------
function ENT:CustomOnThink()

end
/*-----------------------------------------------
	*** Copyright (c) 2012-2019 by Cpt. Hazama, All rights reserved. ***
	No parts of this code or any of its contents may be reproduced, copied, modified or adapted,
	without the prior written consent of the author, unless otherwise indicated for stand-alone materials.
-----------------------------------------------*/