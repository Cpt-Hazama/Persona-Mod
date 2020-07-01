AddCSLuaFile("shared.lua")
include("shared.lua")
---------------------------------------------------------------------------------------------------------------------------------------------
ENT.Model = "models/cpthazama/persona5/persona/johanna.mdl"
ENT.Name = "Johanna"
ENT.Aura = "jojo_aura_blue_light"
ENT.DamageTypes = DMG_P_PHYS
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
function ENT:VajraBlast(owner,enemy)
	if self.User:Health() > self.User:GetMaxHealth() *0.14 && self:GetTask() != "TASK_ATTACK" then
		self:SetTask("TASK_ATTACK")
		owner:VJ_ACT_PLAYACTIVITY("persona_attack",true,false,false)
		VJ_CreateSound(owner,owner.SoundTbl_PersonaAttack,80)
		self:PlayAnimation("attack",1)
		self.Target = enemy
		self:SetAngles(self.User:GetAngles())
		self:TakeHP(self.User:GetMaxHealth() *0.14)
		timer.Simple(0.8,function()
			if IsValid(self) && IsValid(enemy) then
				self.AttackPosition = enemy:GetPos()
				self:MeleeAttackCode(200,150,180)
			end
		end)
		timer.Simple(self:GetSequenceDuration(self,"attack"),function()
			if IsValid(self) then
				self:DoIdle()
			end
		end)
	end
end
---------------------------------------------------------------------------------------------------------------------------------------------
function ENT:Freila(owner,enemy)
	if self.User:GetSP() > self.CurrentCardCost && self:GetTask() != "TASK_ATTACK" then
		self:SetTask("TASK_ATTACK")
		owner:VJ_ACT_PLAYACTIVITY("persona_attack",true,false,false)
		VJ_CreateSound(owner,owner.SoundTbl_PersonaAttack,80)
		self:PlayAnimation("attack",1)
		self.Target = enemy
		self:SetAngles(self.User:GetAngles())
		self:TakeSP(self.CurrentCardCost)
		timer.Simple(0.8,function()
			if IsValid(self) && IsValid(enemy) then
				local proj = ents.Create("obj_vj_per_nuclearblast")
				proj:SetPos(enemy:GetPos() +enemy:OBBMaxs() +Vector(0,0,400))
				proj:SetAngles((enemy:GetPos() +enemy:OBBCenter() -proj:GetPos()):Angle())
				proj:Spawn()
				proj.DirectDamage = 150
				proj:SetOwner(self.User)
				proj:SetPhysicsAttacker(self.User)
				proj:EmitSound("cpthazama/persona5/skills/0338.wav")

				if IsValid(proj:GetPhysicsObject()) then
					proj:GetPhysicsObject():SetVelocity((enemy:GetPos() +enemy:OBBCenter() -proj:GetPos()) *300)
				end
			end
		end)
		timer.Simple(self:GetSequenceDuration(self,"attack"),function()
			if IsValid(self) then
				self:DoIdle()
			end
		end)
	end
end
---------------------------------------------------------------------------------------------------------------------------------------------
function ENT:EnergyShower(owner,enemy)
	
end
---------------------------------------------------------------------------------------------------------------------------------------------
function ENT:Diarahan(owner,enemy)
	
end
---------------------------------------------------------------------------------------------------------------------------------------------
function ENT:AtomicFlare(owner,enemy)
	
end
---------------------------------------------------------------------------------------------------------------------------------------------
function ENT:OnSummoned(owner)
	if !IsValid(self.User) then
		self.User = owner
	end
	self:SetModel(self.Model)
	VJ_CreateSound(owner,owner.SoundTbl_Persona,78)
	self.PersonaDistance = 999999999
	
	self:AddCard("Vajra Blast",14,true) -- Med. Phys damage to all foes
	self:AddCard("Freila",8,false) -- Med. Nuclear damage to one foe
	self:AddCard("Energy Shower",8,false) -- Cure Confuse/Fear/Despair/Rage/Brainwash
	self:AddCard("Diarahan",18,false) -- Fully restore HP
	self:AddCard("Atomic Flare",48,false) -- Sev. Nuclear damage to one foes
	self:SetCard("Freila",8)
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