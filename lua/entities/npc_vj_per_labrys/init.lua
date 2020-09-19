AddCSLuaFile("shared.lua")
include('shared.lua')
/*-----------------------------------------------
	*** Copyright (c) 2012-2019 by Cpt. Hazama, All rights reserved. ***
	No parts of this code or any of its contents may be reproduced, copied, modified or adapted,
	without the prior written consent of the author, unless otherwise indicated for stand-alone materials.
-----------------------------------------------*/
ENT.Model = {"models/cpthazama/persona4/labrys.mdl"} -- The game will pick a random model from the table when the SNPC is spawned | Add as many as you want 
ENT.Stats = {
	HP = 5000,
	SP = 999,
	STR = 80,
	MAG = 30,
	END = 43,
	AGI = 50,
	LUC = 45,
}
ENT.BloodColor = "Oil"
ENT.VJ_NPC_Class = {"CLASS_PLAYER_ALLY","CLASS_INVESTIGATION_TEAM"}
ENT.FriendsWithAllPlayerAllies = true

ENT.HasDeathAnimation = true
ENT.CanRespawn = true

ENT.SoundTbl_Alert = {
	"cpthazama/persona4/labrys/chr_la_0.wav",
	"cpthazama/persona4/labrys/chr_la_1.wav",
	"cpthazama/persona4/labrys/chr_la_2.wav",
	"cpthazama/persona4/labrys/chr_la_3.wav",
	"cpthazama/persona4/labrys/la407b.wav",
	"cpthazama/persona4/labrys/la504b.wav",
	"cpthazama/persona4/labrys/la505a.wav",
	"cpthazama/persona4/labrys/la505b.wav",
	"cpthazama/persona4/labrys/la506b.wav",
}
ENT.SoundTbl_CombatIdle = {
	"cpthazama/persona4/labrys/la501a.wav",
	"cpthazama/persona4/labrys/la501b.wav",
	"cpthazama/persona4/labrys/la504a.wav",
	"cpthazama/persona4/labrys/la710ju_s.wav",
}
ENT.SoundTbl_Pain = {
	"cpthazama/persona4/labrys/la009a.wav",
	"cpthazama/persona4/labrys/la009b.wav",
	"cpthazama/persona4/labrys/la010a.wav",
	"cpthazama/persona4/labrys/la010b.wav",
	"cpthazama/persona4/labrys/la011a.wav",
	"cpthazama/persona4/labrys/la011b.wav",
	"cpthazama/persona4/labrys/la012a.wav",
	"cpthazama/persona4/labrys/la012b.wav",
	"cpthazama/persona4/labrys/la013a.wav",
	"cpthazama/persona4/labrys/la013b.wav",
	"cpthazama/persona4/labrys/la014a.wav",
	"cpthazama/persona4/labrys/la014b.wav",
	"cpthazama/persona4/labrys/la015a.wav",
	"cpthazama/persona4/labrys/la015b.wav",
	"cpthazama/persona4/labrys/la016a.wav",
	"cpthazama/persona4/labrys/la016b.wav",
	"cpthazama/persona4/labrys/la017a.wav",
	"cpthazama/persona4/labrys/la017b.wav",
	"cpthazama/persona4/labrys/la018a.wav",
	"cpthazama/persona4/labrys/la018b.wav",
	"cpthazama/persona4/labrys/la019a.wav",
	"cpthazama/persona4/labrys/la019b.wav",
	"cpthazama/persona4/labrys/la020a.wav",
	"cpthazama/persona4/labrys/la020b.wav",
	"cpthazama/persona4/labrys/la021a.wav",
	"cpthazama/persona4/labrys/la021b.wav",
	"cpthazama/persona4/labrys/la022a.wav",
	"cpthazama/persona4/labrys/la022b.wav",
	"cpthazama/persona4/labrys/la023a.wav",
	"cpthazama/persona4/labrys/la023b.wav",
	"cpthazama/persona4/labrys/la024a.wav",
	"cpthazama/persona4/labrys/la024b.wav",
	"cpthazama/persona4/labrys/la025a.wav",
	"cpthazama/persona4/labrys/la025b.wav",
	"cpthazama/persona4/labrys/la026a.wav",
	"cpthazama/persona4/labrys/la026b.wav",
}
ENT.SoundTbl_Death = {
	"cpthazama/persona4/labrys/over_la_00.wav",
	"cpthazama/persona4/labrys/over_la_01.wav",
}
ENT.SoundTbl_OnKilledEnemy = {
	"cpthazama/persona4/labrys/la404a.wav",
	"cpthazama/persona4/labrys/la406b.wav",
	"cpthazama/persona4/labrys/la407a.wav",
	"cpthazama/persona4/labrys/la408a.wav",
	"cpthazama/persona4/labrys/la408b.wav",
	"cpthazama/persona4/labrys/la410a.wav",
	"cpthazama/persona4/labrys/la410b.wav",
	"cpthazama/persona4/labrys/la500a.wav",
	"cpthazama/persona4/labrys/la500b.wav",
}
ENT.SoundTbl_Dodge = {
	"cpthazama/persona4/labrys/la029a.wav",
	"cpthazama/persona4/labrys/la029b.wav",
	"cpthazama/persona4/labrys/la030b.wav",
	"cpthazama/persona4/labrys/la032a.wav",
	"cpthazama/persona4/labrys/la032b.wav",
	"cpthazama/persona4/labrys/la033a.wav",
	"cpthazama/persona4/labrys/la033b.wav",
	"cpthazama/persona4/labrys/la402a.wav",
	"cpthazama/persona4/labrys/la402b.wav",
}
ENT.SoundTbl_BeforeMeleeAttack = {
	"cpthazama/persona4/labrys/la105a.wav",
	"cpthazama/persona4/labrys/la105b.wav",
	"cpthazama/persona4/labrys/la106a.wav",
	"cpthazama/persona4/labrys/la106b.wav",
	"cpthazama/persona4/labrys/la107a.wav",
	"cpthazama/persona4/labrys/la107b.wav",
}
ENT.SoundTbl_Persona = {
	"cpthazama/persona4/labrys/la108a.wav",
	"cpthazama/persona4/labrys/la108b.wav",
	"cpthazama/persona4/labrys/la109a.wav",
	"cpthazama/persona4/labrys/la109b.wav",
	"cpthazama/persona4/labrys/la110a.wav",
	"cpthazama/persona4/labrys/la110b.wav",
	"cpthazama/persona4/labrys/la210a.wav",
	"cpthazama/persona4/labrys/la210b.wav",
	"cpthazama/persona4/labrys/la211a.wav",
	"cpthazama/persona4/labrys/la211b.wav",
	"cpthazama/persona4/labrys/la212a.wav",
	"cpthazama/persona4/labrys/la212b.wav",
	"cpthazama/persona4/labrys/la213a.wav",
	"cpthazama/persona4/labrys/la213b.wav",
}
ENT.SoundTbl_PersonaAttack = {
	"cpthazama/persona4/labrys/la111a.wav",
	"cpthazama/persona4/labrys/la111b.wav",
	"cpthazama/persona4/labrys/la113a.wav",
}
ENT.SoundTbl_GetUp = {
	"cpthazama/persona4/labrys/conti_la_00.wav",
	"cpthazama/persona4/labrys/conti_la_01.wav",
	"cpthazama/persona4/labrys/ingame_la_0.wav",
	"cpthazama/persona4/labrys/ingame_la_1.wav",
	"cpthazama/persona4/labrys/ingame_la_2.wav",
}

util.AddNetworkString("vj_persona_hud_labrys")

ENT.Animations = {}
ENT.Animations["idle"] = ACT_IDLE
ENT.Animations["idle_combat"] = ACT_IDLE_ANGRY
ENT.Animations["idle_low"] = ACT_IDLE_STIMULATED
ENT.Animations["walk"] = ACT_WALK
ENT.Animations["walk_combat"] = ACT_RUN_STIMULATED
ENT.Animations["run"] = ACT_RUN
ENT.Animations["run_combat"] = ACT_RUN_STIMULATED
ENT.Animations["melee"] = "persona_attack"
ENT.Animations["range_start"] = "persona_attack_start"
ENT.Animations["range_start_idle"] = "persona_attack_start_idle"
ENT.Animations["range"] = "persona_attack"
ENT.Animations["range_idle"] = "persona_attack_idle"
ENT.Animations["range_end"] = "persona_attack_end"
ENT.Animations["critical_start"] = "critical"
ENT.Animations["critical"] = "critical_idle"
ENT.Animations["critical_end"] = "critical_end"

ENT.Persona = "ariadne_picaro"
---------------------------------------------------------------------------------------------------------------------------------------------
function ENT:Controller_Initialize(ply)
    net.Start("vj_persona_hud_labrys")
		net.WriteBool(false)
		net.WriteEntity(self)
    net.Send(ply)

	function self.VJ_TheControllerEntity:CustomOnStopControlling()
		net.Start("vj_persona_hud_labrys")
			net.WriteBool(true)
			net.WriteEntity(self)
		net.Send(ply)
	end
end
---------------------------------------------------------------------------------------------------------------------------------------------
function ENT:UseItem(class,t)
	if CurTime() > self.NextUseT && !self:BusyWithActivity() then
		self:VJ_ACT_PLAYACTIVITY("item_start",true,false,true)
		timer.Simple(self:DecideAnimationLength("item_start",false),function()
			if IsValid(self) then
				local ent = ents.Create(class)
				ent:SetPos(self:GetPos() +self:OBBCenter())
				ent:Spawn()
				ent:SetCollisionGroup(COLLISION_GROUP_IN_VEHICLE)
				ent:Use(self,self)
				self.NextUseT = CurTime() +(t or math.Rand(2,4))
				
				self:VJ_ACT_PLAYACTIVITY("item_end",true,false,true)
			end
		end)
	end
end
---------------------------------------------------------------------------------------------------------------------------------------------
function ENT:HandleAnimations()
	-- self.CurrentIdle = IsValid(self:GetPersona()) && self.Animations["idle_combat"] or self.Animations["idle"]
	-- self.CurrentWalk = IsValid(self:GetPersona()) && self.Animations["walk_combat"] or self.Animations["walk"]
	-- self.CurrentRun = IsValid(self:GetPersona()) && self.Animations["run_combat"] or self.Animations["run"]
	self.CurrentIdle = IsValid(self:GetEnemy()) && self.Animations["idle_combat"] or self.Animations["idle"]
	self.CurrentWalk = IsValid(self:GetEnemy()) && self.Animations["walk_combat"] or self.Animations["walk"]
	self.CurrentRun = IsValid(self:GetEnemy()) && self.Animations["run_combat"] or self.Animations["run"]
	
	if self.FriendsWithAllPlayerAllies then
		if IsValid(self:GetEnemy()) then
			self.Axe = self:Give("weapon_vj_persona_axe_labrys")
		else
			if IsValid(self.Axe) then
				self.Axe:Remove()
			end
		end
	end

	if self:Health() <= self:GetMaxHealth() *0.4 then
		self.CurrentIdle = self.Animations["idle_low"]
	end

	if self:GetState() == 0 then
		self.AnimTbl_IdleStand = {self.CurrentIdle}
		self.AnimTbl_Walk = {self.CurrentWalk}
		self.AnimTbl_Run = {self.CurrentRun}
	end
end
/*-----------------------------------------------
	*** Copyright (c) 2012-2019 by Cpt. Hazama, All rights reserved. ***
	No parts of this code or any of its contents may be reproduced, copied, modified or adapted,
	without the prior written consent of the author, unless otherwise indicated for stand-alone materials.
-----------------------------------------------*/