AddCSLuaFile("shared.lua")
include("shared.lua")
---------------------------------------------------------------------------------------------------------------------------------------------
ENT.Model = "models/cpthazama/persona5/persona/johanna.mdl"
ENT.Aura = "jojo_aura_blue"
ENT.Name = "Johanna"
---------------------------------------------------------------------------------------------------------------------------------------------
ENT.DamageTypes = DMG_P_PHYS
---------------------------------------------------------------------------------------------------------------------------------------------
ENT.Animations = {}
ENT.Animations["idle"] = "idle"
ENT.Animations["idle_low"] = "idle"
ENT.Animations["melee"] = "attack"
ENT.Animations["range_start"] = "range_start"
ENT.Animations["range_start_idle"] = "range_pre_idle"
ENT.Animations["range"] = "attack"
ENT.Animations["range_idle"] = "range_loop"
ENT.Animations["range_end"] = "range_end"
---------------------------------------------------------------------------------------------------------------------------------------------
ENT.Stats = {
	LVL = 21, -- Innate level
	STR = 15, -- Effectiveness of phys. attacks
	MAG = 15, -- Effectiveness of magic. attacks
	END = 14, -- Effectiveness of defense
	AGI = 15, -- Effectiveness of hit and evasion rates
	LUC = 11, -- Chance of getting a critical
	WK = {DMG_P_PSY,DMG_P_PSI},
	RES = {DMG_P_NUCLEAR},
	NUL = {},
}
---------------------------------------------------------------------------------------------------------------------------------------------
function ENT:IdleAnimationCode(ply)
	local ply = self.User
	self.CurrentIdle = ply:IsMoving() && ply:GetSequenceName(ply:GetSequence()) or "idle"
	if self:GetSequenceName(self:GetSequence()) != self.CurrentIdle then
		self:DoIdle()
	end
	self:SetPos(self:GetIdlePosition(ply))
	self:FacePlayerAim(self.User)
end
---------------------------------------------------------------------------------------------------------------------------------------------
function ENT:DoIdle()
	self:SetTask("TASK_IDLE")
	self.IdleAnimation = self.CurrentIdle
	self:PlayAnimation(self.IdleAnimation,self.IdleSpeed,1)
end
---------------------------------------------------------------------------------------------------------------------------------------------
function ENT:HandleEvents(skill,animBlock,seq,t)
	local ply = self.User
	if animBlock == "melee" then
		VJ_CreateSound(ply,ply.SoundTbl_PersonaAttack,80)
	end
	if animBlock == "range" then
		VJ_CreateSound(ply,ply.SoundTbl_PersonaAttack,80)
	end
end
---------------------------------------------------------------------------------------------------------------------------------------------
function ENT:GetAttackPosition()
	return self.AttackPosition or self:GetPos() +self:OBBCenter()
end
---------------------------------------------------------------------------------------------------------------------------------------------
function ENT:GetSpawnPosition(ply)
	return ply:GetPos()
end
---------------------------------------------------------------------------------------------------------------------------------------------
function ENT:GetIdlePosition(ply)
	return self.CurrentIdle == "drive" && (ply:GetPos() +ply:GetForward() *5) or self.CurrentIdle == "drive_fast" && (ply:GetPos() +ply:GetForward() *10) or ply:GetPos()
end
---------------------------------------------------------------------------------------------------------------------------------------------
function ENT:CustomOnHitEntity(entities,dmginfo)
	for _,v in pairs(entities) do
		if IsValid(v) then
			VJ_EmitSound(v,"cpthazama/persona5/misc/00050.wav",75)
		end
	end
end
---------------------------------------------------------------------------------------------------------------------------------------------
function ENT:OnSummoned(owner)
	if !IsValid(self.User) then
		self.User = owner
	end
	VJ_CreateSound(owner,owner.SoundTbl_Persona,78)
	
	self:AddCard("Vajra Blast",14,true,"phys") -- Med. Phys damage to all foes
	self:AddCard("Freila",8,false,"nuclear") -- Med. Nuclear damage to one foe
	-- self:AddCard("Energy Shower",8,false,"heal") -- Cure Confuse/Fear/Despair/Rage/Brainwash
	self:AddCard("Diarahan",18,false,"heal") -- Fully restore HP
	-- self:AddCard("Atomic Flare",48,false,"nuclear") -- Sev. Nuclear damage to one foes

	self:SetCard("Freila")
	self:SetCard("Vajra Blast",true)
end