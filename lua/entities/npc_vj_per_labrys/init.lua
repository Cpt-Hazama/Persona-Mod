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
	"cpthazama/vo/labrys/chr_la_0.wav",
	"cpthazama/vo/labrys/chr_la_1.wav",
	"cpthazama/vo/labrys/chr_la_2.wav",
	"cpthazama/vo/labrys/chr_la_3.wav",
	"cpthazama/vo/labrys/la407b.wav",
	"cpthazama/vo/labrys/la504b.wav",
	"cpthazama/vo/labrys/la505a.wav",
	"cpthazama/vo/labrys/la505b.wav",
	"cpthazama/vo/labrys/la506b.wav",
}
ENT.SoundTbl_CombatIdle = {
	"cpthazama/vo/labrys/la501a.wav",
	"cpthazama/vo/labrys/la501b.wav",
	"cpthazama/vo/labrys/la504a.wav",
	"cpthazama/vo/labrys/la710ju_s.wav",
}
ENT.SoundTbl_Pain = {
	"cpthazama/vo/labrys/la009a.wav",
	"cpthazama/vo/labrys/la009b.wav",
	"cpthazama/vo/labrys/la010a.wav",
	"cpthazama/vo/labrys/la010b.wav",
	"cpthazama/vo/labrys/la011a.wav",
	"cpthazama/vo/labrys/la011b.wav",
	"cpthazama/vo/labrys/la012a.wav",
	"cpthazama/vo/labrys/la012b.wav",
	"cpthazama/vo/labrys/la013a.wav",
	"cpthazama/vo/labrys/la013b.wav",
	"cpthazama/vo/labrys/la014a.wav",
	"cpthazama/vo/labrys/la014b.wav",
	"cpthazama/vo/labrys/la015a.wav",
	"cpthazama/vo/labrys/la015b.wav",
	"cpthazama/vo/labrys/la016a.wav",
	"cpthazama/vo/labrys/la016b.wav",
	"cpthazama/vo/labrys/la017a.wav",
	"cpthazama/vo/labrys/la017b.wav",
	"cpthazama/vo/labrys/la018a.wav",
	"cpthazama/vo/labrys/la018b.wav",
	"cpthazama/vo/labrys/la019a.wav",
	"cpthazama/vo/labrys/la019b.wav",
	"cpthazama/vo/labrys/la020a.wav",
	"cpthazama/vo/labrys/la020b.wav",
	"cpthazama/vo/labrys/la021a.wav",
	"cpthazama/vo/labrys/la021b.wav",
	"cpthazama/vo/labrys/la022a.wav",
	"cpthazama/vo/labrys/la022b.wav",
	"cpthazama/vo/labrys/la023a.wav",
	"cpthazama/vo/labrys/la023b.wav",
	"cpthazama/vo/labrys/la024a.wav",
	"cpthazama/vo/labrys/la024b.wav",
	"cpthazama/vo/labrys/la025a.wav",
	"cpthazama/vo/labrys/la025b.wav",
	"cpthazama/vo/labrys/la026a.wav",
	"cpthazama/vo/labrys/la026b.wav",
}
ENT.SoundTbl_Death = {
	"cpthazama/vo/labrys/over_la_00.wav",
	"cpthazama/vo/labrys/over_la_01.wav",
}
ENT.SoundTbl_OnKilledEnemy = {
	"cpthazama/vo/labrys/la404a.wav",
	"cpthazama/vo/labrys/la406b.wav",
	"cpthazama/vo/labrys/la407a.wav",
	"cpthazama/vo/labrys/la408a.wav",
	"cpthazama/vo/labrys/la408b.wav",
	"cpthazama/vo/labrys/la410a.wav",
	"cpthazama/vo/labrys/la410b.wav",
	"cpthazama/vo/labrys/la500a.wav",
	"cpthazama/vo/labrys/la500b.wav",
}
ENT.SoundTbl_Dodge = {
	"cpthazama/vo/labrys/la029a.wav",
	"cpthazama/vo/labrys/la029b.wav",
	"cpthazama/vo/labrys/la030b.wav",
	"cpthazama/vo/labrys/la032a.wav",
	"cpthazama/vo/labrys/la032b.wav",
	"cpthazama/vo/labrys/la033a.wav",
	"cpthazama/vo/labrys/la033b.wav",
	"cpthazama/vo/labrys/la402a.wav",
	"cpthazama/vo/labrys/la402b.wav",
}
ENT.SoundTbl_BeforeMeleeAttack = {
	"cpthazama/vo/labrys/la105a.wav",
	"cpthazama/vo/labrys/la105b.wav",
	"cpthazama/vo/labrys/la106a.wav",
	"cpthazama/vo/labrys/la106b.wav",
	"cpthazama/vo/labrys/la107a.wav",
	"cpthazama/vo/labrys/la107b.wav",
}
ENT.SoundTbl_Persona = {
	"cpthazama/vo/labrys/la108a.wav",
	"cpthazama/vo/labrys/la108b.wav",
	"cpthazama/vo/labrys/la109a.wav",
	"cpthazama/vo/labrys/la109b.wav",
	"cpthazama/vo/labrys/la110a.wav",
	"cpthazama/vo/labrys/la110b.wav",
	"cpthazama/vo/labrys/la210a.wav",
	"cpthazama/vo/labrys/la210b.wav",
	"cpthazama/vo/labrys/la211a.wav",
	"cpthazama/vo/labrys/la211b.wav",
	"cpthazama/vo/labrys/la212a.wav",
	"cpthazama/vo/labrys/la212b.wav",
	"cpthazama/vo/labrys/la213a.wav",
	"cpthazama/vo/labrys/la213b.wav",
}
ENT.SoundTbl_PersonaAttack = {
	"cpthazama/vo/labrys/la111a.wav",
	"cpthazama/vo/labrys/la111b.wav",
	"cpthazama/vo/labrys/la113a.wav",
}
ENT.SoundTbl_GetUp = {
	"cpthazama/vo/labrys/conti_la_00.wav",
	"cpthazama/vo/labrys/conti_la_01.wav",
	"cpthazama/vo/labrys/ingame_la_0.wav",
	"cpthazama/vo/labrys/ingame_la_1.wav",
	"cpthazama/vo/labrys/ingame_la_2.wav",
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

ENT.Persona = "ariadne"
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
function ENT:OnThink()
	if self.FriendsWithAllPlayerAllies then
		if IsValid(self:GetEnemy()) then
			self.Axe = self:Give("weapon_vj_persona_axe_labrys")
		else
			if IsValid(self.Axe) then
				self.Axe:Remove()
			end
		end
	end
end
/*-----------------------------------------------
	*** Copyright (c) 2012-2019 by Cpt. Hazama, All rights reserved. ***
	No parts of this code or any of its contents may be reproduced, copied, modified or adapted,
	without the prior written consent of the author, unless otherwise indicated for stand-alone materials.
-----------------------------------------------*/