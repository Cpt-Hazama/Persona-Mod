AddCSLuaFile("shared.lua")
include('shared.lua')
/*-----------------------------------------------
	*** Copyright (c) 2012-2019 by Cpt. Hazama, All rights reserved. ***
	No parts of this code or any of its contents may be reproduced, copied, modified or adapted,
	without the prior written consent of the author, unless otherwise indicated for stand-alone materials.
-----------------------------------------------*/
ENT.Model = {"models/cpthazama/persona5/makoto_normal.mdl"} -- The game will pick a random model from the table when the SNPC is spawned | Add as many as you want 
ENT.Stats = {
	HP = 556,
	SP = 330,
	STR = 84,
	MAG = 85,
	END = 81,
	AGI = 85,
	LUC = 69,
}
ENT.VJ_NPC_Class = {"CLASS_PLAYER_ALLY","CLASS_PHANTOMTHIEVES"}
ENT.PlayerFriendly = true

ENT.HasDeathAnimation = true
ENT.CanRespawn = true

ENT.SoundTbl_FootStep = {}
ENT.SoundTbl_Alert = {
	"cpthazama/persona5/makoto/0001.wav",
	"cpthazama/persona5/makoto/0002.wav",
	"cpthazama/persona5/makoto/0004.wav",
	"cpthazama/persona5/makoto/0005.wav",
	"cpthazama/persona5/makoto/0010.wav",
	"cpthazama/persona5/makoto/0012.wav",
	"cpthazama/persona5/makoto/0086.wav",
	"cpthazama/persona5/makoto/0087.wav",
}
ENT.SoundTbl_BeforeMeleeAttack = {
	"cpthazama/persona5/makoto/0033.wav",
	"cpthazama/persona5/makoto/0032.wav",
	"cpthazama/persona5/makoto/0037.wav",
	"cpthazama/persona5/makoto/0038.wav",
	"cpthazama/persona5/makoto/0048.wav",
	"cpthazama/persona5/makoto/0078.wav",
}
ENT.SoundTbl_Pain = {
	"cpthazama/persona5/makoto/0091.wav",
	"cpthazama/persona5/makoto/0092.wav",
	"cpthazama/persona5/makoto/0093.wav",
	"cpthazama/persona5/makoto/0094.wav",
	"cpthazama/persona5/makoto/0095.wav",
	"cpthazama/persona5/makoto/0096.wav",
	"cpthazama/persona5/makoto/0097.wav",
	"cpthazama/persona5/makoto/0098.wav",
	"cpthazama/persona5/makoto/0099.wav",
	"cpthazama/persona5/makoto/0100.wav",
	"cpthazama/persona5/makoto/0101.wav",
	"cpthazama/persona5/makoto/0102.wav",
	"cpthazama/persona5/makoto/0107.wav",
	"cpthazama/persona5/makoto/0108.wav",
	"cpthazama/persona5/makoto/0109.wav",
	"cpthazama/persona5/makoto/0110.wav",
	"cpthazama/persona5/makoto/0113.wav",
	"cpthazama/persona5/makoto/0114.wav",
	"cpthazama/persona5/makoto/0115.wav",
	"cpthazama/persona5/makoto/0116.wav",
	"cpthazama/persona5/makoto/0013.wav",
	"cpthazama/persona5/makoto/0015.wav",
	"cpthazama/persona5/makoto/0121.wav",
	"cpthazama/persona5/makoto/0122.wav",
	"cpthazama/persona5/makoto/0123.wav",
	"cpthazama/persona5/makoto/0124.wav",
	"cpthazama/persona5/makoto/0125.wav",
}
ENT.SoundTbl_Death = {
	"cpthazama/persona5/makoto/0103.wav",
	"cpthazama/persona5/makoto/0104.wav",
	"cpthazama/persona5/makoto/0105.wav",
	"cpthazama/persona5/makoto/0106.wav",
	"cpthazama/persona5/makoto/0117.wav",
	"cpthazama/persona5/makoto/0118.wav",
}
ENT.SoundTbl_OnKilledEnemy = {
	"cpthazama/persona5/makoto/0059.wav",
	"cpthazama/persona5/makoto/0062.wav",
	"cpthazama/persona5/makoto/0089.wav",
	"cpthazama/persona5/makoto/0090.wav",
	"cpthazama/persona5/makoto/0205.wav",
	"cpthazama/persona5/makoto/0208.wav",
}
ENT.SoundTbl_Dodge = {
	"cpthazama/persona5/makoto/0126.wav",
	"cpthazama/persona5/makoto/0127.wav",
	"cpthazama/persona5/makoto/0128.wav",
	"cpthazama/persona5/makoto/0129.wav",
	"cpthazama/persona5/makoto/0130.wav",
}
ENT.SoundTbl_Persona = {
	"cpthazama/persona5/makoto/0198.wav",
	"cpthazama/persona5/makoto/0236.wav",
	"cpthazama/persona5/makoto/0237.wav",
	"cpthazama/persona5/makoto/0238.wav",
	"cpthazama/persona5/makoto/0239.wav",
	"cpthazama/persona5/makoto/0240.wav",
	"cpthazama/persona5/makoto/0241.wav",
}
ENT.SoundTbl_PersonaAttack = {
	"cpthazama/persona5/makoto/0199.wav",
}
ENT.SoundTbl_GetUp = {
	"cpthazama/persona5/makoto/0155.wav",
	"cpthazama/persona5/makoto/0159.wav",
}
ENT.SoundTbl_FollowPlayer = {
	"cpthazama/persona5/makoto/0234.wav",
	"cpthazama/persona5/makoto/0235.wav",
}
ENT.SoundTbl_UnFollowPlayer = {
	"cpthazama/persona5/makoto/0218.wav",
	"cpthazama/persona5/makoto/0220.wav",
	"cpthazama/persona5/makoto/0224.wav",
	"cpthazama/persona5/makoto/0229.wav",
	"cpthazama/persona5/makoto/0230.wav",
}
ENT.SoundTbl_MoveOutOfPlayersWay = {
	"cpthazama/persona5/makoto/0225.wav",
}
ENT.SoundTbl_IdleDialogue = {
	"cpthazama/persona5/makoto/0209.wav",
	"cpthazama/persona5/makoto/0215.wav",
}
ENT.SoundTbl_IdleDialogueAnswer = {
	"cpthazama/persona5/makoto/0232.wav",
	"cpthazama/persona5/makoto/0231.wav",
	"cpthazama/persona5/makoto/0230.wav",
	"cpthazama/persona5/makoto/0229.wav",
	"cpthazama/persona5/makoto/0218.wav",
	"cpthazama/persona5/makoto/0204.wav",
	"cpthazama/persona5/makoto/0203.wav",
	"cpthazama/persona5/makoto/0202.wav",
	"cpthazama/persona5/makoto/0196.wav",
}

util.AddNetworkString("vj_persona_hud_makoto")

ENT.Animations = {}
ENT.Animations["idle"] = ACT_IDLE
ENT.Animations["idle_combat"] = ACT_IDLE_ANGRY
ENT.Animations["idle_low"] = ACT_IDLE_STIMULATED
ENT.Animations["walk"] = ACT_WALK
ENT.Animations["run"] = ACT_RUN
ENT.Animations["run_combat"] = ACT_RUN_STIMULATED
ENT.Animations["melee"] = "persona_attack"
ENT.Animations["range_start"] = "persona_attack_start"
ENT.Animations["range_start_idle"] = "persona_attack_start_idle"
ENT.Animations["range"] = "persona_attack"
ENT.Animations["range_idle"] = "persona_attack_start_idle"
ENT.Animations["range_end"] = "persona_attack_end"

ENT.Persona = "johanna"
---------------------------------------------------------------------------------------------------------------------------------------------
function ENT:Controller_Initialize(ply)
    net.Start("vj_persona_hud_makoto")
		net.WriteBool(false)
		net.WriteEntity(self)
    net.Send(ply)

	function self.VJ_TheControllerEntity:CustomOnStopControlling()
		net.Start("vj_persona_hud_makoto")
			net.WriteBool(true)
			net.WriteEntity(self)
		net.Send(ply)
	end
end
---------------------------------------------------------------------------------------------------------------------------------------------
function ENT:PersonaInit()
	-- self:SetBodygroup(1,1)
end
---------------------------------------------------------------------------------------------------------------------------------------------
function ENT:OnSwitchMetaVerse(didSwitch)
	if didSwitch then
		self:SetModel("models/cpthazama/persona5/makoto.mdl")
		self:SetBodygroup(1,1)
	else
		self:SetModel("models/cpthazama/persona5/makoto_normal.mdl")
		self:SetBodygroup(1,0)
	end
	self:SetPos(self:GetPos() +Vector(0,0,8))
end
---------------------------------------------------------------------------------------------------------------------------------------------
function ENT:OnSummonPersona(persona)
	self:StopMoving()
	self:ClearSchedule()
	self:GetPersona():SetTask("TASK_PLAY_ANIMATION")
	self:GetPersona():PlayAnimation("summon",1)
	self:SetPos(self:GetPos() +self:GetForward() *-20)
	self:VJ_ACT_PLAYACTIVITY("persona_attack_start",true,false,false)
	timer.Simple(1.35,function()
		if IsValid(self) && IsValid(self:GetPersona()) then
			self:GetPersona():DoIdle()
		end
	end)
end
---------------------------------------------------------------------------------------------------------------------------------------------
function ENT:OnThink()
	if self.MetaVerseMode && self:Health() > 0 then
		self.DisableChasingEnemy = true
		self:SetPoseParameter("serious",1)
	else
		self:SetPoseParameter("serious",0)
		self.DisableChasingEnemy = false
	end
end
/*-----------------------------------------------
	*** Copyright (c) 2012-2019 by Cpt. Hazama, All rights reserved. ***
	No parts of this code or any of its contents may be reproduced, copied, modified or adapted,
	without the prior written consent of the author, unless otherwise indicated for stand-alone materials.
-----------------------------------------------*/