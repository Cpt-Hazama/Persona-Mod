AddCSLuaFile("shared.lua")
include("shared.lua")
/*-----------------------------------------------
	*** Copyright (c) 2012-2019 by Cpt. Hazama, All rights reserved. ***
	No parts of this code or any of its contents may be reproduced, copied, modified or adapted,
	without the prior written consent of the author, unless otherwise indicated for stand-alone materials.
-----------------------------------------------*/
ENT.Model = {"models/cpthazama/persona5/effects/sinfulshell.mdl"} -- The models it should spawn with | Picks a random one from the table
ENT.DoesDirectDamage = false -- Should it do a direct damage when it hits something?
ENT.DoesRadiusDamage = false -- Should it do a blast damage when it hits something?
ENT.DecalTbl_DeathDecals = {"Scorch"}
ENT.SoundTbl_OnCollide = {"cpthazama/persona5/skills/0230.wav"}
---------------------------------------------------------------------------------------------------------------------------------------------
function ENT:CustomPhysicsObjectOnInitialize(phys)
	phys:Wake()
	phys:SetMass(1)
	phys:EnableDrag(false)
	phys:EnableGravity(false)
	phys:SetBuoyancyRatio(0)
end
---------------------------------------------------------------------------------------------------------------------------------------------
function ENT:CustomOnInitialize()
	self:DrawShadow(false)
end
---------------------------------------------------------------------------------------------------------------------------------------------
function ENT:CustomOnThink()
	local phys = self:GetPhysicsObject()
	if IsValid(phys) then
		-- phys:SetVelocity(self:GetAngles():Forward() *3000)
	end
end
---------------------------------------------------------------------------------------------------------------------------------------------
function ENT:DeathEffects(data,phys)
	self:SinfulShellEffect(data.HitPos)
end
---------------------------------------------------------------------------------------------------------------------------------------------
function ENT:SinfulShellEffect(pos,dmg)
	local dmg = dmg or 999999999
	local scale = 20
	local m = ents.Create("prop_vj_animatable")
	m:SetModel("models/cpthazama/persona5/effects/megidolaon.mdl")
	m:SetPos(pos)
	m:Spawn()
	m:DrawShadow(false)
	m:SetCollisionGroup(COLLISION_GROUP_IN_VEHICLE)
	m:ResetSequence("idle")
	m:SetModelScale(scale,1)
	VJ_CreateSound(m,"cpthazama/persona5/skills/megidolaon.wav",150)
	local Light = ents.Create("light_dynamic")
	Light:SetKeyValue("brightness","7")
	Light:SetKeyValue("distance",tostring(30 *scale))
	Light:SetPos(m:GetPos())
	Light:Fire("Color","180 255 255")
	Light:SetParent(m)
	Light:Spawn()
	Light:Activate()
	Light:Fire("TurnOn","",0)
	Light:Fire("TurnOff","",1)
	m:DeleteOnRemove(Light)
	local owner = self.Persona
	timer.Simple(0.75,function()
		if IsValid(m) && IsValid(owner) then
			local ents = owner:FindEnemies(m:GetPos(),30 *scale)
			if ents != nil then
				for _,v in pairs(ents) do
					if IsValid(v) then
						v:SetHealth(0)
						if v:IsPlayer() then
							v:GodDisable()
						end
						if v.GodMode then
							v.GodMode = false
						end
						local dmginfo = DamageInfo()
						dmginfo:SetDamage(IsValid(owner) && owner:AdditionalInput(dmg,2) or dmg)
						dmginfo:SetDamageType(DMG_P_ALMIGHTY)
						dmginfo:SetInflictor(IsValid(owner) && owner or v)
						dmginfo:SetAttacker(IsValid(owner) && IsValid(owner.User) && owner.User or v)
						dmginfo:SetDamagePosition(m:NearestPoint(v:GetPos() +v:OBBCenter()))
						v:TakeDamageInfo(dmginfo,IsValid(owner) && IsValid(owner.User) && owner.User or v)
						v:EmitSound("cpthazama/persona5/skills/0014.wav",70)
					end
				end
			end
		end
	end)
	timer.Simple(1,function()
		if IsValid(m) then
			SafeRemoveEntity(m)
		end
	end)
end
/*-----------------------------------------------
	*** Copyright (c) 2012-2019 by Cpt. Hazama, All rights reserved. ***
	No parts of this code or any of its contents may be reproduced, copied, modified or adapted,
	without the prior written consent of the author, unless otherwise indicated for stand-alone materials.
-----------------------------------------------*/