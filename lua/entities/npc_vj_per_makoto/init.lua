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
ENT.FriendsWithAllPlayerAllies = true

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
ENT.Animations["walk_combat"] = ACT_WALK_STIMULATED
ENT.Animations["run"] = ACT_RUN
ENT.Animations["run_combat"] = ACT_RUN_AGITATED
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
	local bounds = self.Bounds
	self:SetCollisionBounds(Vector(bounds.x,bounds.y,bounds.z),-Vector(bounds.x,bounds.y,0))
	self:SetPos(self:GetPos() +Vector(0,0,5))
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
	self.VJC_Data.ThirdP_Offset = Vector(-80, 80, 0)
	persona.IdleLoop = CreateSound(persona,"cpthazama/persona5/makoto/johanna/idle.wav")
	persona.IdleLoop:SetSoundLevel(78)
	persona.Drive1Loop = CreateSound(persona,"cpthazama/persona5/makoto/johanna/drive1.wav")
	persona.Drive1Loop:SetSoundLevel(85)
	persona.Drive2Loop = CreateSound(persona,"cpthazama/persona5/makoto/johanna/drive2.wav")
	persona.Drive2Loop:SetSoundLevel(110)
	table.insert(persona.Loops,persona.IdleLoop)
	table.insert(persona.Loops,persona.Drive1Loop)
	table.insert(persona.Loops,persona.Drive2Loop)
end
---------------------------------------------------------------------------------------------------------------------------------------------
function ENT:OnDisablePersona(persona)
	self.VJC_Data.ThirdP_Offset = Vector(-15, 40, -35)
end
---------------------------------------------------------------------------------------------------------------------------------------------
function ENT:OnThink()
	if self.MetaVerseMode && self:Health() > 0 then
		self:SetPoseParameter("serious",1)
	else
		self:SetPoseParameter("serious",0)
	end
	local persona = IsValid(self:GetPersona()) && self:GetPersona() or false
	if self:IsMoving() then
		if persona then
			self.VJC_Data.ThirdP_Offset = Vector(0, 0, -30)
			persona.IdleLoop:Stop()
			persona.Drive2Loop:Play()
			local fast = self:GetActivity() == ACT_RUN_AGITATED
			persona.Drive2Loop:ChangePitch(fast && 100 or 75,0)
			persona.Drive2Loop:ChangeVolume(fast && 120 or 75,0)
		end
	else
		if persona then
			persona.IdleLoop:Play()
			-- persona.Drive1Loop:Stop()
			persona.Drive2Loop:Stop()
		end
		self.VJC_Data.ThirdP_Offset = persona && Vector(-80, 80, 0) or Vector(-15, 40, -35)
	end
end
---------------------------------------------------------------------------------------------------------------------------------------------
function ENT:HandleAnimations()
	local hasPersona = IsValid(self:GetPersona())
	if hasPersona then
		self.Animations["idle_combat"] = VJ_SequenceToActivity(self,"persona_attack_start_idle")
	else
		self.Animations["idle_combat"] = ACT_IDLE_ANGRY
	end
	self.CurrentIdle = hasPersona && self.Animations["idle_combat"] or self.Animations["idle"]
	self.CurrentWalk = hasPersona && self.Animations["walk_combat"] or self.Animations["walk"]
	self.CurrentRun = hasPersona && self.Animations["run_combat"] or self.Animations["run"]

	if self:Health() <= self:GetMaxHealth() *0.4 && !hasPersona then
		self.CurrentIdle = self.Animations["idle_low"]
	end
	
	if self.MetaVerseMode then
		if hasPersona then
			self:SetBodygroup(1,0)
		else
			self:SetBodygroup(1,1)
		end
	end

	if self:GetState() == 0 then
		self.AnimTbl_IdleStand = {self.CurrentIdle}
		self.AnimTbl_Walk = {self.CurrentWalk}
		self.AnimTbl_Run = {self.CurrentRun}
	end
end
---------------------------------------------------------------------------------------------------------------------------------------------
function ENT:OnPersonaAnimation(persona,skill,animBlock,seq,t)
	local myAnim = self.Animations[animBlock]
	if animBlock == "melee" then
		-- self:SetState(VJ_STATE_ONLY_ANIMATION)
		self:VJ_ACT_PLAYACTIVITY(myAnim,true,false,true)
	end
	if animBlock == "range_start" then
		-- self.DisableChasingEnemy = true
		-- self:StopMoving()
		self:StartLoopAnimation("range_idle")
		self:VJ_ACT_PLAYACTIVITY(myAnim,true,false,true)
	end
	if animBlock == "range_start_idle" then
		self:VJ_ACT_PLAYACTIVITY(myAnim,true,false,true)
	end
	if animBlock == "range" then
		self:VJ_ACT_PLAYACTIVITY(myAnim,true,false,true)
	end
	if animBlock == "range_idle" then
		self:VJ_ACT_PLAYACTIVITY(myAnim,true,false,true)
	end
	if animBlock == "range_end" then
		self:ResetLoopAnimation()
		self:VJ_ACT_PLAYACTIVITY(myAnim,true,false,true)
	end
end
/*-----------------------------------------------
	*** Copyright (c) 2012-2019 by Cpt. Hazama, All rights reserved. ***
	No parts of this code or any of its contents may be reproduced, copied, modified or adapted,
	without the prior written consent of the author, unless otherwise indicated for stand-alone materials.
-----------------------------------------------*/