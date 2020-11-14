AddCSLuaFile("shared.lua")
include('shared.lua')
/*-----------------------------------------------
	*** Copyright (c) 2012-2019 by Cpt. Hazama, All rights reserved. ***
	No parts of this code or any of its contents may be reproduced, copied, modified or adapted,
	without the prior written consent of the author, unless otherwise indicated for stand-alone materials.
-----------------------------------------------*/
ENT.Model = {"models/cpthazama/persona5/adachi.mdl"} -- The game will pick a random model from the table when the SNPC is spawned | Add as many as you want 
ENT.Stats = {
	HP = 9500,
	SP = 2200,
	STR = 65,
	MAG = 55,
	END = 66,
	AGI = 45,
	LUC = 45,
}
ENT.VJ_NPC_Class = {"CLASS_ADACHI"}

ENT.SoundTbl_FootStep = {}
ENT.SoundTbl_CombatIdle = {
	"cpthazama/vo/adachi/vo/npc/vbtl_pad_0#1 (pad000).wav",
	"cpthazama/vo/adachi/vo/npc/vbtl_pad_0#140 (pad202_2).wav",
	"cpthazama/vo/adachi/vo/npc/vbtl_pad_0#141 (pad203_0).wav",
	"cpthazama/vo/adachi/vo/npc/vbtl_pad_0#145 (pad204_1).wav",
	"cpthazama/vo/adachi/vo/npc/vbtl_pad_0#148 (pad205_1).wav",
	"cpthazama/vo/adachi/vo/npc/vbtl_pad_0#178 (pad300_0).wav",
	"cpthazama/vo/adachi/vo/npc/vbtl_pad_0#180 (pad300_2).wav",
	"cpthazama/vo/adachi/vo/npc/vbtl_pad_0#208 (pad600def).wav",
	"cpthazama/vo/adachi/vo/npc/vbtl_pad_0#209 (pad601def).wav",
}
ENT.SoundTbl_Pain = {
	"cpthazama/vo/adachi/vo/npc/vbtl_pad_0#101 (pad155).wav",
	"cpthazama/vo/adachi/vo/npc/vbtl_pad_0#11 (pad010).wav",
	"cpthazama/vo/adachi/vo/npc/vbtl_pad_0#12 (pad015).wav",
	"cpthazama/vo/adachi/vo/npc/vbtl_pad_0#13 (pad016).wav",
	"cpthazama/vo/adachi/vo/npc/vbtl_pad_0#130 (pad170_0).wav",
	"cpthazama/vo/adachi/vo/npc/vbtl_pad_0#131 (pad170_1).wav",
	"cpthazama/vo/adachi/vo/npc/vbtl_pad_0#14 (pad017).wav",
	"cpthazama/vo/adachi/vo/npc/vbtl_pad_0#15 (pad018).wav",
	"cpthazama/vo/adachi/vo/npc/vbtl_pad_0#16 (pad019).wav",
	"cpthazama/vo/adachi/vo/npc/vbtl_pad_0#17 (pad020).wav",
}
ENT.SoundTbl_Death = {
	"cpthazama/vo/adachi/vo/npc/vbtl_pad_0#18 (pad021).wav",
	"cpthazama/vo/adachi/vo/npc/vbtl_pad_0#19 (pad022).wav",
	"cpthazama/vo/adachi/vo/npc/vbtl_pad_0#200 (pad400_0).wav",
	"cpthazama/vo/adachi/vo/npc/vbtl_pad_0#201 (pad400_1).wav",
	"cpthazama/vo/adachi/vo/npc/vbtl_pad_0#202 (pad401_0).wav",
	"cpthazama/vo/adachi/vo/npc/vbtl_pad_0#203 (pad401_1).wav",
}
ENT.SoundTbl_OnKilledEnemy = {
	"cpthazama/vo/adachi/vo/npc/vbtl_pad_0#102 (pad156_0).wav",
	"cpthazama/vo/adachi/vo/npc/vbtl_pad_0#109 (pad159_1).wav",
	"cpthazama/vo/adachi/vo/npc/vbtl_pad_0#110 (pad160_0).wav",
	"cpthazama/vo/adachi/vo/npc/vbtl_pad_0#122 (pad166_0).wav",
	"cpthazama/vo/adachi/vo/npc/vbtl_pad_0#133 (pad200_1).wav",
	"cpthazama/vo/adachi/vo/npc/vbtl_pad_0#134 (pad200_2).wav",
	"cpthazama/vo/adachi/vo/npc/vbtl_pad_0#135 (pad201_0).wav",
	"cpthazama/vo/adachi/vo/npc/vbtl_pad_0#137 (pad201_2).wav",
	"cpthazama/vo/adachi/vo/npc/vbtl_pad_0#143 (pad203_2).wav",
	"cpthazama/vo/adachi/vo/npc/vbtl_pad_0#155 (pad207_2).wav",
	"cpthazama/vo/adachi/vo/npc/vbtl_pad_0#179 (pad300_1).wav",
	"cpthazama/vo/adachi/vo/npc/vbtl_pad_0#183 (pad301_2).wav",
	"cpthazama/vo/adachi/vo/npc/vbtl_pad_0#204 (pad402_0).wav",
	"cpthazama/vo/adachi/vo/npc/vbtl_pad_0#205 (pad402_1).wav",
	"cpthazama/vo/adachi/vo/npc/vbtl_pad_0#206 (pad403_0).wav",
}
ENT.SoundTbl_Dodge = {
	"cpthazama/vo/adachi/vo/npc/vbtl_pad_0#113 (pad161_1).wav",
	"cpthazama/vo/adachi/vo/npc/vbtl_pad_0#114 (pad162_0).wav",
	"cpthazama/vo/adachi/vo/npc/vbtl_pad_0#116 (pad163_0).wav",
	"cpthazama/vo/adachi/vo/npc/vbtl_pad_0#117 (pad163_1).wav",
	"cpthazama/vo/adachi/vo/npc/vbtl_pad_0#119 (pad164_1).wav",
	"cpthazama/vo/adachi/vo/npc/vbtl_pad_0#121 (pad165_1).wav",
	"cpthazama/vo/adachi/vo/npc/vbtl_pad_0#132 (pad200_0).wav",
	"cpthazama/vo/adachi/vo/npc/vbtl_pad_0#136 (pad201_1).wav",
	"cpthazama/vo/adachi/vo/npc/vbtl_pad_0#181 (pad301_0).wav",
	"cpthazama/vo/adachi/vo/npc/vbtl_pad_0#182 (pad301_1).wav",
	"cpthazama/vo/adachi/vo/npc/vbtl_pad_0#185 (pad302_1).wav",
	"cpthazama/vo/adachi/vo/npc/vbtl_pad_0#186 (pad302_2).wav",
	"cpthazama/vo/adachi/vo/npc/vbtl_pad_0#187 (pad303_0).wav",
}
ENT.SoundTbl_Persona = {
	"cpthazama/vo/adachi/vo/summon_01.wav",
	"cpthazama/vo/adachi/vo/summon_02.wav",
	"cpthazama/vo/adachi/vo/summon_03.wav",
	"cpthazama/vo/adachi/vo/summon_04.wav",
	"cpthazama/vo/adachi/vo/summon_05.wav",
	"cpthazama/vo/adachi/vo/summon_06.wav",
	"cpthazama/vo/adachi/vo/summon_07.wav",
	"cpthazama/vo/adachi/vo/summon_08.wav",
}
ENT.SoundTbl_PersonaAttack = {
	"cpthazama/vo/adachi/vo/npc/vbtl_pad_0#104 (pad157_0).wav",
	"cpthazama/vo/adachi/vo/npc/vbtl_pad_0#105 (pad157_1).wav",
	"cpthazama/vo/adachi/vo/npc/vbtl_pad_0#106 (pad158_0).wav",
	"cpthazama/vo/adachi/vo/npc/vbtl_pad_0#107 (pad158_1).wav",
	"cpthazama/vo/adachi/vo/npc/vbtl_pad_0#108 (pad159_0).wav",
	"cpthazama/vo/adachi/vo/npc/vbtl_pad_0#120 (pad165_0).wav",
	"cpthazama/vo/adachi/vo/npc/vbtl_pad_0#124 (pad167_0).wav",
	"cpthazama/vo/adachi/vo/npc/vbtl_pad_0#125 (pad167_1).wav",
	"cpthazama/vo/adachi/vo/npc/vbtl_pad_0#126 (pad168_0).wav",
	"cpthazama/vo/adachi/vo/npc/vbtl_pad_0#127 (pad168_1).wav",
	"cpthazama/vo/adachi/vo/npc/vbtl_pad_0#128 (pad169_0).wav",
	"cpthazama/vo/adachi/vo/npc/vbtl_pad_0#129 (pad169_1).wav",
	"cpthazama/vo/adachi/vo/npc/vbtl_pad_0#139 (pad202_1).wav",
	"cpthazama/vo/adachi/vo/npc/vbtl_pad_0#149 (pad205_2).wav",
	"cpthazama/vo/adachi/vo/npc/vbtl_pad_0#156 (pad250_0).wav",
	"cpthazama/vo/adachi/vo/npc/vbtl_pad_0#157 (pad250_1).wav",
	"cpthazama/vo/adachi/vo/npc/vbtl_pad_0#158 (pad251_0).wav",
	"cpthazama/vo/adachi/vo/npc/vbtl_pad_0#160 (pad252_0).wav",
	"cpthazama/vo/adachi/vo/npc/vbtl_pad_0#162 (pad253_0).wav",
	"cpthazama/vo/adachi/vo/npc/vbtl_pad_0#161 (pad252_1).wav",
	"cpthazama/vo/adachi/vo/npc/vbtl_pad_0#168 (pad290_0).wav",
	"cpthazama/vo/adachi/vo/npc/vbtl_pad_0#169 (pad290_1).wav",
	"cpthazama/vo/adachi/vo/npc/vbtl_pad_0#171 (pad291_1).wav",
	"cpthazama/vo/adachi/vo/npc/vbtl_pad_0#188 (pad303_1).wav",
}
ENT.SoundTbl_GetUp = {
}

util.AddNetworkString("vj_persona_hud_adachi")

ENT.Animations = {}
ENT.Animations["idle"] = ACT_IDLE
ENT.Animations["idle_combat"] = ACT_IDLE_ANGRY
ENT.Animations["idle_low"] = ACT_IDLE_STIMULATED
ENT.Animations["walk"] = ACT_WALK
ENT.Animations["run"] = ACT_RUN
ENT.Animations["run_combat"] = ACT_RUN
ENT.Animations["melee"] = "persona_attack"
ENT.Animations["range_start"] = "persona_attack_start"
ENT.Animations["range_start_idle"] = "persona_attack_start_idle"
ENT.Animations["range"] = "persona_attack"
ENT.Animations["range_idle"] = "persona_attack_idle"
ENT.Animations["range_end"] = "persona_attack_end"

ENT.Persona = "magatsu_izanagi_p4"
---------------------------------------------------------------------------------------------------------------------------------------------
function ENT:Controller_Initialize(ply)
    net.Start("vj_persona_hud_adachi")
		net.WriteBool(false)
		net.WriteEntity(self)
    net.Send(ply)

	function self.VJ_TheControllerEntity:CustomOnStopControlling()
		net.Start("vj_persona_hud_adachi")
			net.WriteBool(true)
			net.WriteEntity(self)
		net.Send(ply)
	end
end
---------------------------------------------------------------------------------------------------------------------------------------------
function ENT:PersonaInit()
	self:SetBodygroup(1,1)

	self:Give("weapon_vj_persona_revolver_adachi")

	self.WeaponSpread = 1
end
---------------------------------------------------------------------------------------------------------------------------------------------
function ENT:OnSwitchMetaVerse(didSwitch)
	if didSwitch then
		self:SetSkin(1)
	else
		self:SetSkin(0)
	end
end
---------------------------------------------------------------------------------------------------------------------------------------------
function ENT:OnThink()
	self:SetPoseParameter("smile",self:IsMoving() && 0.65 or self:Health() <= self:GetMaxHealth() *0.3 && 0 or 0.2)
	if self.MetaVerseMode && self:Health() > 0 then
		self:SetPoseParameter("anger",0.6)
	else
		self:SetPoseParameter("anger",0)
	end
end
/*-----------------------------------------------
	*** Copyright (c) 2012-2019 by Cpt. Hazama, All rights reserved. ***
	No parts of this code or any of its contents may be reproduced, copied, modified or adapted,
	without the prior written consent of the author, unless otherwise indicated for stand-alone materials.
-----------------------------------------------*/