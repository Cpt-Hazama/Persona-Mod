AddCSLuaFile("shared.lua")
include('shared.lua')
/*-----------------------------------------------
	*** Copyright (c) 2012-2019 by Cpt. Hazama, All rights reserved. ***
	No parts of this code or any of its contents may be reproduced, copied, modified or adapted,
	without the prior written consent of the author, unless otherwise indicated for stand-alone materials.
-----------------------------------------------*/
ENT.Stats = {
	HP = 30000,
	SP = 20000,
	STR = 80,
	MAG = 30,
	END = 43,
	AGI = 50,
	LUC = 45,
}
ENT.VJ_NPC_Class = {"CLASS_SHADOW","CLASS_SHADOWLABRYS"}
ENT.FriendsWithAllPlayerAllies = false

ENT.HasDeathAnimation = true
ENT.CanRespawn = false

util.AddNetworkString("vj_persona_hud_labrys_shadow")

ENT.Animations = {}
ENT.Animations["idle"] = ACT_IDLE_ANGRY
ENT.Animations["idle_combat"] = ACT_IDLE_ANGRY
ENT.Animations["idle_low"] = ACT_IDLE_STIMULATED
ENT.Animations["walk"] = ACT_RUN_STIMULATED
ENT.Animations["walk_combat"] = ACT_RUN_STIMULATED
ENT.Animations["run"] = ACT_RUN_STIMULATED
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

ENT.Persona = "asterius"
ENT.CriticalDownTime = 20
---------------------------------------------------------------------------------------------------------------------------------------------
function ENT:Controller_Initialize(ply)
    net.Start("vj_persona_hud_labrys_shadow")
		net.WriteBool(false)
		net.WriteEntity(self)
    net.Send(ply)

	function self.VJ_TheControllerEntity:CustomOnStopControlling()
		net.Start("vj_persona_hud_labrys_shadow")
			net.WriteBool(true)
			net.WriteEntity(self)
		net.Send(ply)
	end
end
---------------------------------------------------------------------------------------------------------------------------------------------
function ENT:OnDisablePersona(persona)
	self.VJC_Data.ThirdP_Offset = Vector(-15, 40, -35)
	ParticleEffectAttach("vj_per_shadow_idle",PATTACH_POINT_FOLLOW,self,self:LookupAttachment("origin"))
end
---------------------------------------------------------------------------------------------------------------------------------------------
function ENT:PersonaInit()
	self:SetSkin(1)
	self:Give("weapon_vj_persona_axe_labrys")

	ParticleEffectAttach("vj_per_shadow_idle",PATTACH_POINT_FOLLOW,self,self:LookupAttachment("origin"))

	for _,v in pairs(player.GetAll()) do
		if !IsValid(v:GetNW2Entity("VJ_Persona_ShadowBoss")) then
			v:SetNW2Entity("VJ_Persona_ShadowBoss",self)
		end
	end

	self.SoundTbl_Alert = {
		"cpthazama/vo/labrys/shadow/chr_ls_0.wav",
		"cpthazama/vo/labrys/shadow/chr_ls_1.wav",
		"cpthazama/vo/labrys/shadow/chr_ls_2.wav",
		"cpthazama/vo/labrys/shadow/chr_ls_3.wav",
		"cpthazama/vo/labrys/shadow/ingame_ls_1.wav",
		"cpthazama/vo/labrys/shadow/ingame_ls_2.wav",
		"cpthazama/vo/labrys/shadow/ls504bc.wav",
	}
	self.SoundTbl_CombatIdle = {
		"cpthazama/vo/labrys/shadow/ls505b.wav",
		"cpthazama/vo/labrys/shadow/ls506a.wav",
		"cpthazama/vo/labrys/shadow/ls506b.wav",
		"cpthazama/vo/labrys/shadow/ls203b.wav",
		"cpthazama/vo/labrys/shadow/ls205a.wav",
		"cpthazama/vo/labrys/shadow/ls205b.wav",
		"cpthazama/vo/labrys/shadow/ls206a.wav",
		"cpthazama/vo/labrys/shadow/ls206b.wav",
		"cpthazama/vo/labrys/shadow/ls207b.wav",
		"cpthazama/vo/labrys/shadow/ls122a.wav",
	}
	self.SoundTbl_Pain = {
		"cpthazama/vo/labrys/shadow/ls009a.wav",
		"cpthazama/vo/labrys/shadow/ls009b.wav",
		"cpthazama/vo/labrys/shadow/ls010a.wav",
		"cpthazama/vo/labrys/shadow/ls010b.wav",
		"cpthazama/vo/labrys/shadow/ls011a.wav",
		"cpthazama/vo/labrys/shadow/ls011b.wav",
		"cpthazama/vo/labrys/shadow/ls012a.wav",
		"cpthazama/vo/labrys/shadow/ls012b.wav",
		"cpthazama/vo/labrys/shadow/ls013a.wav",
		"cpthazama/vo/labrys/shadow/ls013b.wav",
		"cpthazama/vo/labrys/shadow/ls014a.wav",
		"cpthazama/vo/labrys/shadow/ls014b.wav",
		"cpthazama/vo/labrys/shadow/ls015a.wav",
		"cpthazama/vo/labrys/shadow/ls015b.wav",
		"cpthazama/vo/labrys/shadow/ls016a.wav",
		"cpthazama/vo/labrys/shadow/ls016b.wav",
		"cpthazama/vo/labrys/shadow/ls017a.wav",
		"cpthazama/vo/labrys/shadow/ls017b.wav",
		"cpthazama/vo/labrys/shadow/ls018a.wav",
		"cpthazama/vo/labrys/shadow/ls018b.wav",
		"cpthazama/vo/labrys/shadow/ls019a.wav",
		"cpthazama/vo/labrys/shadow/ls019b.wav",
		"cpthazama/vo/labrys/shadow/ls020a.wav",
		"cpthazama/vo/labrys/shadow/ls020b.wav",
		"cpthazama/vo/labrys/shadow/ls021a.wav",
		"cpthazama/vo/labrys/shadow/ls021b.wav",
		"cpthazama/vo/labrys/shadow/ls022a.wav",
		"cpthazama/vo/labrys/shadow/ls022b.wav",
		"cpthazama/vo/labrys/shadow/ls023a.wav",
		"cpthazama/vo/labrys/shadow/ls023b.wav",
		"cpthazama/vo/labrys/shadow/ls024a.wav",
		"cpthazama/vo/labrys/shadow/ls024b.wav",
		"cpthazama/vo/labrys/shadow/ls025a.wav",
		"cpthazama/vo/labrys/shadow/ls025b.wav",
		"cpthazama/vo/labrys/shadow/ls026a.wav",
		"cpthazama/vo/labrys/shadow/ls026b.wav",
	}
	self.SoundTbl_Death = {
		"cpthazama/vo/labrys/shadow/ls000a.wav",
		"cpthazama/vo/labrys/shadow/ls000b.wav",
		"cpthazama/vo/labrys/shadow/ls001a.wav",
		"cpthazama/vo/labrys/shadow/ls001b.wav",
		"cpthazama/vo/labrys/shadow/ls002a.wav",
		"cpthazama/vo/labrys/shadow/ls002ag.wav",
		"cpthazama/vo/labrys/shadow/ls002b.wav",
		"cpthazama/vo/labrys/shadow/ls002mi.wav",
		"cpthazama/vo/labrys/shadow/ls003a.wav",
		"cpthazama/vo/labrys/shadow/ls003b.wav",
	}
	self.SoundTbl_OnKilledEnemy = {
		"cpthazama/vo/labrys/shadow/ls303b.wav",
		"cpthazama/vo/labrys/shadow/ls313a.wav",
		"cpthazama/vo/labrys/shadow/ls316b.wav",
		"cpthazama/vo/labrys/shadow/ls320b.wav",
		"cpthazama/vo/labrys/shadow/ls500b.wav",
		"cpthazama/vo/labrys/shadow/ls501a.wav",
		"cpthazama/vo/labrys/shadow/ls501b.wav",
		"cpthazama/vo/labrys/shadow/ls502a.wav",
		"cpthazama/vo/labrys/shadow/ls502mi.wav",
		"cpthazama/vo/labrys/shadow/ls504ag.wav",
		"cpthazama/vo/labrys/shadow/win_ls_02.wav",
		"cpthazama/vo/labrys/shadow/win_ls_03.wav",
		"cpthazama/vo/labrys/shadow/win_ls_04.wav",
		"cpthazama/vo/labrys/shadow/win_ls_05.wav",
	}
	self.SoundTbl_Dodge = {
		"cpthazama/vo/labrys/shadow/ls005b.wav",
		"cpthazama/vo/labrys/shadow/ls006a.wav",
		"cpthazama/vo/labrys/shadow/ls006b.wav",
		"cpthazama/vo/labrys/shadow/ls007a.wav",
		"cpthazama/vo/labrys/shadow/ls007b.wav",
		"cpthazama/vo/labrys/shadow/ls008a.wav",
		"cpthazama/vo/labrys/shadow/ls008b.wav",
		"cpthazama/vo/labrys/shadow/ls027a.wav",
		"cpthazama/vo/labrys/shadow/ls027b.wav",
		"cpthazama/vo/labrys/shadow/ls028a.wav",
		"cpthazama/vo/labrys/shadow/ls028b.wav",
		"cpthazama/vo/labrys/shadow/ls029a.wav",
		"cpthazama/vo/labrys/shadow/ls029b.wav",
		"cpthazama/vo/labrys/shadow/ls030a.wav",
		"cpthazama/vo/labrys/shadow/ls030b.wav",
		"cpthazama/vo/labrys/shadow/ls031a.wav",
		"cpthazama/vo/labrys/shadow/ls031b.wav",
		"cpthazama/vo/labrys/shadow/ls032a.wav",
		"cpthazama/vo/labrys/shadow/ls032b.wav",
		"cpthazama/vo/labrys/shadow/ls033a.wav",
		"cpthazama/vo/labrys/shadow/ls033b.wav",
		"cpthazama/vo/labrys/shadow/ls301a.wav",
	}
	self.SoundTbl_BeforeMeleeAttack = {
		"cpthazama/vo/labrys/shadow/ls100a.wav",
		"cpthazama/vo/labrys/shadow/ls100b.wav",
		"cpthazama/vo/labrys/shadow/ls101a.wav",
		"cpthazama/vo/labrys/shadow/ls101b.wav",
		"cpthazama/vo/labrys/shadow/ls102a.wav",
		"cpthazama/vo/labrys/shadow/ls102b.wav",
		"cpthazama/vo/labrys/shadow/ls103a.wav",
		"cpthazama/vo/labrys/shadow/ls103b.wav",
		"cpthazama/vo/labrys/shadow/ls104a.wav",
		"cpthazama/vo/labrys/shadow/ls120b.wav",
		"cpthazama/vo/labrys/shadow/ls121a.wav",
	}
	self.SoundTbl_Persona = {
		"cpthazama/vo/labrys/shadow/ls210a.wav",
		"cpthazama/vo/labrys/shadow/ls210b.wav",
		"cpthazama/vo/labrys/shadow/ls211a.wav",
		"cpthazama/vo/labrys/shadow/ls211b.wav",
		"cpthazama/vo/labrys/shadow/ls212a.wav",
		"cpthazama/vo/labrys/shadow/ls212b.wav",
		"cpthazama/vo/labrys/shadow/ls213a.wav",
		"cpthazama/vo/labrys/shadow/ls213b.wav",
	}
	self.SoundTbl_PersonaAttack = {
		"cpthazama/vo/labrys/shadow/ls105a.wav",
		"cpthazama/vo/labrys/shadow/ls105b.wav",
		"cpthazama/vo/labrys/shadow/ls106a.wav",
		"cpthazama/vo/labrys/shadow/ls106b.wav",
		"cpthazama/vo/labrys/shadow/ls107a.wav",
		"cpthazama/vo/labrys/shadow/ls107b.wav",
		"cpthazama/vo/labrys/shadow/ls108a.wav",
		"cpthazama/vo/labrys/shadow/ls108b.wav",
		"cpthazama/vo/labrys/shadow/ls109a.wav",
		"cpthazama/vo/labrys/shadow/ls109b.wav",
		"cpthazama/vo/labrys/shadow/ls110a.wav",
		"cpthazama/vo/labrys/shadow/ls110b.wav",
		"cpthazama/vo/labrys/shadow/ls111a.wav",
		"cpthazama/vo/labrys/shadow/ls111b.wav",
		"cpthazama/vo/labrys/shadow/ls126b.wav",
		"cpthazama/vo/labrys/shadow/ls207a.wav",
		"cpthazama/vo/labrys/shadow/ls319b.wav",
	}
	self.SoundTbl_GetUp = {
		"cpthazama/vo/labrys/shadow/conti_ls_00.wav",
		"cpthazama/vo/labrys/shadow/conti_ls_01.wav",
		"cpthazama/vo/labrys/shadow/ls504la.wav",
	}
	self.SoundTbl_FollowPlayer = {"cpthazama/vo/labrys/shadow/ingame_ls_0.wav"}
end
---------------------------------------------------------------------------------------------------------------------------------------------
function ENT:CustomOnRemove()
	for _,v in pairs(player.GetAll()) do
		if IsValid(v:GetNW2Entity("VJ_Persona_ShadowBoss")) && v:GetNW2Entity("VJ_Persona_ShadowBoss") == self then
			v:SetNW2Entity("VJ_Persona_ShadowBoss",NULL)
		end
	end
end
/*-----------------------------------------------
	*** Copyright (c) 2012-2019 by Cpt. Hazama, All rights reserved. ***
	No parts of this code or any of its contents may be reproduced, copied, modified or adapted,
	without the prior written consent of the author, unless otherwise indicated for stand-alone materials.
-----------------------------------------------*/