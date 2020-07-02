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
	WK = DMG_PSY,
	STR = DMG_CURSE,
	NUL = DMG_NUCLEAR,
}
ENT.Evasion = 45
ENT.HullType = HULL_HUMAN
---------------------------------------------------------------------------------------------------------------------------------------------
ENT.VJ_NPC_Class = {"CLASS_PLAYER_ALLY","CLASS_PHANTOMTHIEVES"}
ENT.PlayerFriendly = true
ENT.FriendsWithAllPlayerAllies = true

ENT.BloodColor = "Red"

ENT.HasMeleeAttack = true
ENT.AnimTbl_MeleeAttack = {ACT_MELEE_ATTACK1}
ENT.TimeUntilMeleeAttackDamage = false
ENT.MeleeAttackDistance = 80
ENT.MeleeAttackDamageDistance = 110
ENT.MeleeAttackDamage = 25

ENT.HasDeathAnimation = true
ENT.AnimTbl_Death = {ACT_DIESIMPLE}
ENT.DeathCorpseEntityClass = "prop_vj_animatable"

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

ENT.GeneralSoundPitch1 = 100

util.AddNetworkString("vj_persona_hud_makoto")
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
function ENT:CustomOnTakeDamage_BeforeDamage(dmginfo,hitgroup)
	local dmg = dmginfo:GetDamage()
	local dmgtype = dmginfo:GetDamageType()
	
	if dmgtype == self.Stats.WK then
		dmginfo:ScaleDamage(2)
	end
	if dmgtype == self.Stats.STR then
		dmginfo:ScaleDamage(0.35)
	end
	if dmgtype == self.Stats.NUL then
		dmginfo:SetDamage(0)
	end
	
	if dmginfo:GetDamage() > 0 then
		if math.random(1,100) <= self.Evasion then
			self:VJ_ACT_PLAYACTIVITY("dodge",true,false,true)
			dmginfo:SetDamage(0)
		end
	end
end
---------------------------------------------------------------------------------------------------------------------------------------------
function ENT:CustomOnInitialize()
	self:SetHealth((GetConVarNumber("vj_npc_allhealth") > 0) and GetConVarNumber("vj_npc_allhealth") or self:VJ_GetDifficultyValue(self.Stats.HP))
	self.SP = self.Stats.SP
	
	self.MetaVerseMode = false
	
	self.NextMetaChangeT = CurTime() +2
	self.MouthDistance = 0
	self.NextMouthMoveT = 0
	self.NextNumChangeT = 0
	
	self:CapabilitiesAdd(bit.bor(CAP_ANIMATEDFACE))
	self:CapabilitiesAdd(bit.bor(CAP_TURN_HEAD))
	self:CapabilitiesAdd(bit.bor(CAP_OPEN_DOORS))
	self:CapabilitiesAdd(bit.bor(CAP_AUTO_DOORS))
	self:CapabilitiesAdd(bit.bor(CAP_USE))
	
	-- local max,min = self:GetCollisionBounds()
	
	self:SetSP(self.Stats.SP)
	self:SetMaxSP(self.Stats.SP)
end
---------------------------------------------------------------------------------------------------------------------------------------------
function ENT:OnPlayCreateSound(SoundData,SoundFile)
	if !VJ_HasValue(self.SoundTbl_FootStep,SoundFile) then
		self.NextMouthMoveT = CurTime() +SoundDuration(SoundFile)
	end
end
---------------------------------------------------------------------------------------------------------------------------------------------
function ENT:CustomOnAcceptInput(key,activator,caller,data)
	if key == "step" then
		VJ_EmitSound(self,self.SoundTbl_FootStep,self.FootStepSoundLevel,self:VJ_DecideSoundPitch(self.FootStepPitch1,self.FootStepPitch2))
	elseif string.find(key,"melee") then
		local atk = string.Replace(key,"melee ","")
		self:MeleeAttackCode()
	end
end
---------------------------------------------------------------------------------------------------------------------------------------------
function ENT:PersonaThink(persona,enemy,dist)
	if self.VJ_IsBeingControlled then
		local ply = self.VJ_TheController
		local lmb = ply:KeyDown(IN_ATTACK)
		local rmb = ply:KeyDown(IN_ATTACK2)
		local r = ply:KeyDown(IN_RELOAD)
		
		if lmb then
			if persona:GetTask() == "TASK_IDLE" then
				persona:VajraBlast(self,enemy)
			end
		end
		if rmb then
			if persona:GetTask() == "TASK_IDLE" then
				persona:Freila(self,enemy)
			end
		end
		return
	end
	if IsValid(enemy) && self:Visible(enemy) then
		if dist < 2000 && dist > 500 then
			if persona:GetTask() == "TASK_IDLE" then
				persona:Freila(self,enemy)
			end
		elseif dist <= 500 then
			if persona:GetTask() == "TASK_IDLE" then
				persona:VajraBlast(self,enemy)
			end
		end
	end
end
---------------------------------------------------------------------------------------------------------------------------------------------
function ENT:CustomOnThink()
	local idle = self.MetaVerseMode && ACT_IDLE_ANGRY or ACT_IDLE
	local run = self.MetaVerseMode && ACT_RUN_STIMULATED or ACT_RUN
	
	if self:Health() <= self:GetMaxHealth() *0.3 then
		idle = ACT_IDLE_STIMULATED
	end
	if IsValid(self:GetPersona()) then
		-- idle = VJ_SequenceToActivity(self,"persona_idle")
		-- if self.PreparedToAttack then
			idle = VJ_SequenceToActivity(self,"persona_attack_start_idle")
		-- end
	end

	self.AnimTbl_IdleStand = {idle}
	self.AnimTbl_Run = {run}

	-- if self.FollowingPlayer && !IsValid(self:GetEnemy()) then
		-- self:DoPoseParameterLooking(false,self.FollowPlayer_Entity)
	-- end
	
	self.DisableChasingEnemy = IsValid(self:GetPersona())
	if self.DisableChasingEnemy then
		if self:IsMoving() then
			self:StopMoving()
			self:ClearSchedule()
		end
	end
	
	if self.MetaVerseMode && self:Health() > 0 then
		if !IsValid(self:GetPersona()) then
			if IsValid(self:GetEnemy()) then
				self:SummonPersona("johanna")
				ParticleEffectAttach("jojo_aura_blue_light",PATTACH_POINT_FOLLOW,self,self:LookupAttachment("origin"))
			end
		elseif IsValid(self:GetPersona()) then
			self:SetBodygroup(1,0)
			if !IsValid(self:GetEnemy()) then
				self:SummonPersona("johanna")
				self:SetBodygroup(1,1)
			end
			self:PersonaThink(self:GetPersona(),self:GetEnemy(),self:VJ_GetNearestPointToEntityDistance(self:GetEnemy()))
		end
	end

	if IsValid(self:GetEnemy()) then
		if self.MetaVerseMode == false then
			if CurTime() > self.NextMetaChangeT then
				self.MetaVerseMode = true
				self.NextMetaChangeT = CurTime() +5
				self:SetModel("models/cpthazama/persona5/makoto.mdl")
				self:SetBodygroup(1,1)
			end
		else
			self.NextMetaChangeT = CurTime() +5
		end
	else
		if self.MetaVerseMode then
			if CurTime() > self.NextMetaChangeT then
				self.MetaVerseMode = false
				self.NextMetaChangeT = CurTime() +2
				self:SetModel("models/cpthazama/persona5/makoto_normal.mdl")
				self:SetBodygroup(1,0)
			end
		else
			self.NextMetaChangeT = CurTime() +2
		end
	end
	if CurTime() < self.NextMouthMoveT then
		if CurTime() > self.NextNumChangeT then
			self.MouthDistance = math.Rand(0,1)
			self.NextNumChangeT = CurTime() +0.2
		end
		local pp = self:GetPoseParameter("talk")
		local targ = self.MouthDistance
		local input = self:GetPoseParameter("talk")
		if pp != targ then
			if self.MouthDistance > input then
				input = pp +0.2
			else
				input = pp -0.2
			end
		end
		local fin = Lerp(1,pp,input)
		self:SetPoseParameter("talk",fin)
	else
		self:SetPoseParameter("talk",0)
	end
end
---------------------------------------------------------------------------------------------------------------------------------------------
function ENT:CustomOnDeath_AfterCorpseSpawned(dmginfo,hitgroup,GetCorpse)
	GetCorpse:ResetSequence("death")
	GetCorpse:SetCycle(1)
	GetCorpse.SP = self.SP
	GetCorpse.Class = self:GetClass()
	undo.ReplaceEntity(self,GetCorpse)
	timer.Simple(20,function()
		if IsValid(GetCorpse) then
			local e = ents.Create(GetCorpse.Class)
			e:SetPos(GetCorpse:GetPos())
			e:SetAngles(GetCorpse:GetAngles())
			e:Spawn()
			e:SetNoDraw(true)
			e:SetModel(GetCorpse:GetModel())
			e:SetHealth(e:Health() /2)
			e.SP = GetCorpse.SP
			undo.ReplaceEntity(GetCorpse,e)
			e:VJ_ACT_PLAYACTIVITY("getup",true,false,false)
			e:SetState(VJ_STATE_FREEZE,e:DecideAnimationLength("getup"))
			e:StopAllCommonSpeechSounds()
			VJ_CreateSound(e,e.SoundTbl_GetUp,80,e:VJ_DecideSoundPitch(e.GeneralSoundPitch1,e.GeneralSoundPitch2))
			timer.Simple(0.2,function() SafeRemoveEntity(GetCorpse) if IsValid(e) then e:SetNoDraw(false) end end)
		end
	end)
end
---------------------------------------------------------------------------------------------------------------------------------------------
function ENT:DoPoseParameterLooking(ResetPoses,ovEnt)
	if self.HasPoseParameterLooking == false then return end
	ResetPoses = ResetPoses or false
	//self:VJ_GetAllPoseParameters(true)
	local ent = NULL
	if self.VJ_IsBeingControlled == true then ent = self.VJ_TheController else ent = self:GetEnemy() end
	if ovEnt then
		ent = ovEnt
		ResetPoses = false
	end
	local p_enemy = 0 -- Pitch
	local y_enemy = 0 -- Yaw
	local r_enemy = 0 -- Roll
	if IsValid(ent) && ResetPoses == false then
		local enemy_pos = false
		if self.VJ_IsBeingControlled == true then
			//enemy_pos = self.VJ_TheController:GetEyeTrace().HitPos
			local gettr = util.GetPlayerTrace(self.VJ_TheController) -- Get the player's trace
			local tr = util.TraceLine({start = gettr.start, endpos = gettr.endpos, filter = {self, self.VJ_TheController}}) -- Apply the filter to it (The player and the NPC)
			enemy_pos = tr.HitPos
		else
			enemy_pos = ent:GetPos() + ent:OBBCenter()
		end
		if enemy_pos == false then return end
		local self_ang = self:GetAngles()
		local enemy_ang = (enemy_pos - (self:GetPos() + self:OBBCenter())):Angle()
		p_enemy = math.AngleDifference(enemy_ang.p, self_ang.p)
		if self.PoseParameterLooking_InvertPitch == true then p_enemy = -p_enemy end
		y_enemy = math.AngleDifference(enemy_ang.y, self_ang.y)
		if self.PoseParameterLooking_InvertYaw == true then y_enemy = -y_enemy end
		r_enemy = math.AngleDifference(enemy_ang.z, self_ang.z)
		if self.PoseParameterLooking_InvertRoll == true then r_enemy = -r_enemy end
	elseif self.PoseParameterLooking_CanReset == false then -- Should it reset its pose parameters if there is no enemies?
		return
	end
	
	self:CustomOn_PoseParameterLookingCode(p_enemy, y_enemy, r_enemy)
	
	local ang_app = math.ApproachAngle
	local names = self.PoseParameterLooking_Names
	for x = 1, #names.pitch do
		self:SetPoseParameter(names.pitch[x], ang_app(self:GetPoseParameter(names.pitch[x]), p_enemy, self.PoseParameterLooking_TurningSpeed))
	end
	for x = 1, #names.yaw do
		self:SetPoseParameter(names.yaw[x], ang_app(self:GetPoseParameter(names.yaw[x]), y_enemy, self.PoseParameterLooking_TurningSpeed))
	end
	for x = 1, #names.roll do
		self:SetPoseParameter(names.roll[x], ang_app(self:GetPoseParameter(names.roll[x]), r_enemy, self.PoseParameterLooking_TurningSpeed))
	end
end
/*-----------------------------------------------
	*** Copyright (c) 2012-2019 by Cpt. Hazama, All rights reserved. ***
	No parts of this code or any of its contents may be reproduced, copied, modified or adapted,
	without the prior written consent of the author, unless otherwise indicated for stand-alone materials.
-----------------------------------------------*/