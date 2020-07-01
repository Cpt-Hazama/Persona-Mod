AddCSLuaFile("shared.lua")
include("shared.lua")
---------------------------------------------------------------------------------------------------------------------------------------------
ENT.Model = "models/cpthazama/persona5/persona/loki.mdl"
ENT.Name = "Loki"
ENT.Aura = "jojo_aura_red"
ENT.DamageTypes = DMG_P_PHYS
---------------------------------------------------------------------------------------------------------------------------------------------
function ENT:GetSpawnPosition(ply)
	return ply:GetPos() +ply:GetForward() *-25
end
---------------------------------------------------------------------------------------------------------------------------------------------
function ENT:GetIdlePosition(ply)
	return ply:GetPos() +ply:GetForward() *-25
end
---------------------------------------------------------------------------------------------------------------------------------------------
function ENT:GetAttackPosition()
	return self.AttackPosition or self:GetPos() +self:OBBCenter()
end
---------------------------------------------------------------------------------------------------------------------------------------------
function ENT:CustomOnHitEntity(entities,dmginfo)
	for _,v in pairs(entities) do
		if IsValid(v) then
			VJ_EmitSound(v,"cpthazama/persona5/misc/00050.wav",75)
			if v:Health() > 0 then
				self:Curse(v,10,5)
			end
		end
	end
end
---------------------------------------------------------------------------------------------------------------------------------------------
function ENT:Laevateinn(owner,enemy)
	if self.User:Health() > self.User:GetMaxHealth() *0.25 && self:GetTask() != "TASK_ATTACK" then
		self:SetTask("TASK_ATTACK")
		owner:VJ_ACT_PLAYACTIVITY("persona_attack",true,false,false)
		VJ_CreateSound(owner,owner.SoundTbl_PersonaAttack,80)
		self:PlayAnimation("attack",1)
		self.Target = enemy
		self:SetAngles(self.User:GetAngles())
		self:TakeHP(self.User:GetMaxHealth() *0.25)
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
function ENT:Megidolaon(owner,enemy)
	
end
---------------------------------------------------------------------------------------------------------------------------------------------
function ENT:Debilitate(owner,enemy)
	
end
---------------------------------------------------------------------------------------------------------------------------------------------
function ENT:RiotGun(owner,enemy)
	
end
---------------------------------------------------------------------------------------------------------------------------------------------
function ENT:Eigaon(owner,enemy)
	
end
---------------------------------------------------------------------------------------------------------------------------------------------
function ENT:OnSummoned(owner)
	if !IsValid(self.User) then
		self.User = owner
	end
	self:SetModel(self.Model)
	VJ_CreateSound(owner,owner.SoundTbl_Persona,78)
	self.PersonaDistance = 999999999
	
	-- self:AddCard("Laevateinn",25,true) -- Collossal Phys damage to one foes
	self:AddCard("Megidolaon",38,false) -- Sev. Almighty damage to all foe
	self:AddCard("Debilitate",30,false) -- Decrease ATK/DEF/EV of one foe for 3 minutes
	self:AddCard("Riot Gun",24,true) -- Sev. Gun damage to all foes
	self:AddCard("Eigaon",12,false) -- Heavy Curse damage to one foe
	self:SetCard("Eigaon",12)
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