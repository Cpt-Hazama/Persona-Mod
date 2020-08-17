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
	return ply:GetPos()
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
---------------------------------------------------------------------------------------------------------------------------------------------
function ENT:RequestAura(ply,aura)
	self:EmitSound("cpthazama/persona5/misc/00118.wav",75,100)
	ParticleEffectAttach(aura,PATTACH_POINT_FOLLOW,self,self:LookupAttachment("origin"))
	ParticleEffectAttach(aura,PATTACH_POINT_FOLLOW,ply,ply:LookupAttachment("origin"))
	local fx = EffectData()
	fx:SetOrigin(self:GetIdlePosition(ply))
	fx:SetScale(80)
	util.Effect("JoJo_Summon",fx)
end