AddCSLuaFile("shared.lua")
include("shared.lua")
---------------------------------------------------------------------------------------------------------------------------------------------
ENT.Bot_StopDistance = 100
ENT.Bot_Buttons = {
	[1] = {but={IN_ATTACK},dist=100,chance=1},
}
---------------------------------------------------------------------------------------------------------------------------------------------
function ENT:CustomOnHitEntity(hitEnts,dmginfo)
	if dmginfo:GetDamageType() == DMG_P_CURSE then
		for _,v in pairs(hitEnts) do
			if IsValid(v) && v:Health() > 0 then
				self:Curse(v,10,5)
			end
		end
	end
end
---------------------------------------------------------------------------------------------------------------------------------------------
function ENT:Teleport()
	self:SetTask("TASK_PLAY_ANIMATION")
	self:PlayAnimation("range_start",1)
	self:SetAngles(self.User:GetAngles())
	local tr = self:UserTrace(2000)
	local pos = tr.HitPos +tr.HitNormal *8

	timer.Simple(self:GetSequenceDuration(self,"range_start"),function()
		if IsValid(self) then
			local bloodeffect = EffectData()
			bloodeffect:SetOrigin(self:GetPos() +self:OBBCenter())
			bloodeffect:SetScale(225)
			bloodeffect:SetAttachment(1)
			util.Effect("P4_RedMist",bloodeffect)

			local bloodeffect = EffectData()
			bloodeffect:SetOrigin(self.User:GetPos() +self.User:OBBCenter())
			bloodeffect:SetScale(225)
			bloodeffect:SetAttachment(1)
			util.Effect("P4_RedMist",bloodeffect)
			
			sound.Play("cpthazama/persona5/adachi/blast_charge.wav",self:GetPos(),75)

			self.User:SetPos(pos)
			self:SetPos(self:GetIdlePosition(self.User))
			self:SetTask("TASK_PLAY_ANIMATION")
			self:PlayAnimation("range_end",1)

			local bloodeffect = EffectData()
			bloodeffect:SetOrigin(self:GetPos() +self:OBBCenter())
			bloodeffect:SetScale(225)
			bloodeffect:SetAttachment(1)
			util.Effect("P4_RedMist",bloodeffect)

			local bloodeffect = EffectData()
			bloodeffect:SetOrigin(self.User:GetPos() +self.User:OBBCenter())
			bloodeffect:SetScale(225)
			bloodeffect:SetAttachment(1)
			util.Effect("P4_RedMist",bloodeffect)
			
			sound.Play("cpthazama/persona5/adachi/blast_charge.wav",self:GetPos(),75)

			timer.Simple(self:GetSequenceDuration(self,"range_end"),function()
				if IsValid(self) then
					self:DoIdle()
				end
			end)
		end
	end)
end
---------------------------------------------------------------------------------------------------------------------------------------------
function ENT:PersonaControls(ply,persona)
	local lmb = ply:KeyDown(IN_ATTACK)
	local rmb = ply:KeyDown(IN_ATTACK2)
	local alt = ply:KeyDown(IN_WALK)
	local r = ply:KeyDown(IN_RELOAD)
	if self:GetTask() == "TASK_IDLE" then
		if self.User:Crouching() && self.CurrentIdle != "low_hp" then
			self:DoIdle()
		elseif !self.User:Crouching() && self.CurrentIdle != "idle" then
			self:DoIdle()
		end
	end
	if lmb then
		if alt then
			if self:GetTask() == "TASK_IDLE" then
				self:Teleport()
			end
			return
		end
		if self.User:Health() > self.User:GetMaxHealth() *0.2 && self:GetTask() == "TASK_IDLE" && !self.IsArmed then
			self:SetTask("TASK_ATTACK")
			self:PlayAnimation("attack",1)
			ply:EmitSound("cpthazama/persona5/joker/0031.wav",85)
			self:FindTarget(ply)
			self:SetAngles(self.User:GetAngles())
			self:TakeHP(self.User:GetMaxHealth() *0.2)
			-- timer.Simple(SoundDuration("cpthazama/persona5/joker/0011.wav"),function()
				-- if IsValid(self) then
					-- ply:EmitSound("cpthazama/persona5/joker/0012.wav",85)
				-- end
			-- end)
			timer.Simple(0.7,function()
				if IsValid(self) then
					self:MeleeAttackCode(self.Damage /3,300,75)
				end
			end)
			timer.Simple(0.72,function()
				if IsValid(self) then
					self:MeleeAttackCode(self.Damage /3,300,75)
				end
			end)
			timer.Simple(0.74,function()
				if IsValid(self) then
					self:MeleeAttackCode(self.Damage /3,300,75)
				end
			end)
			timer.Simple(self:GetSequenceDuration(self,"attack"),function()
				if IsValid(self) then
					self:DoIdle()
				end
			end)
		end
	end
	if rmb then
		if self.User:GetSP() > self.CurrentCardCost && !self.IsArmed && self:GetTask() == "TASK_IDLE" then
			self.DamageBuild = 800
			self:SetTask("TASK_PLAY_ANIMATION")
			self:PlayAnimation("range_start",1)
			self:TakeSP(self.CurrentCardCost)
			ply:EmitSound("cpthazama/persona5/joker/0032.wav")
			self:SetAngles(self.User:GetAngles())
			timer.Simple(self:GetSequenceDuration(self,"range_start"),function()
				if IsValid(self) then
					self.IsArmed = true
					self:PlayAnimation("range_pre_idle",1,1)
				end
			end)
		end
	end
	if self.IsArmed && rmb then
		self.DamageBuild = math.Clamp(self.DamageBuild +2,800,2000)
	end
	if self:GetTask() == "TASK_PLAY_ANIMATION" && self.IsArmed && !rmb && CurTime() > self.TimeToMazionga then
		self:MeleeAttackCode(self.DamageBuild,2500,180,1)
		self:PlayAnimation("range",1)
		ply:EmitSound("cpthazama/persona5/joker/0027.wav",85)
		self.TimeToMazionga = CurTime() +self:GetSequenceDuration(self,"range") +0.2
		timer.Simple(self:GetSequenceDuration(self,"range"),function()
			if IsValid(self) then
				self.IsArmed = false
				self:DoIdle()
			end
		end)
	end
end
---------------------------------------------------------------------------------------------------------------------------------------------
function ENT:MeleeAttackCode(dmg,dmgdist,rad,snd)
	local AttackDist = dmgdist
	local FindEnts = ents.FindInSphere(self:GetAttackPosition(),AttackDist)
	local hitentity = false
	local hitEnts = {}
	local snd = snd or true
	local doactualdmg = DamageInfo()
	if FindEnts != nil then
		for _,v in pairs(FindEnts) do
			if (v != self && v != self.User) && (((v:IsNPC() or (v:IsPlayer() && v:Alive()))) or v:GetClass() == "func_breakable_surf" or v:GetClass() == "prop_physics") then
				if (self:GetForward():Dot((Vector(v:GetPos().x,v:GetPos().y,0) - Vector(self:GetPos().x,self:GetPos().y,0)):GetNormalized()) > math.cos(math.rad(rad))) then
					if snd == 1 then
						doactualdmg:SetDamage(dmg)
						doactualdmg:SetDamageType(DMG_P_CURSE)
						doactualdmg:SetInflictor(self)
						doactualdmg:SetAttacker(self.User)
						v:TakeDamageInfo(doactualdmg,self.User)
						v:EmitSound("cpthazama/persona5/adachi/curse.wav",math.random(60,72))
					else
						local doactualdmg = DamageInfo()
						doactualdmg:SetDamage(dmg)
						doactualdmg:SetDamageType(bit.bor(DMG_SLASH,DMG_CRUSH,DMG_ALWAYSGIB))
						doactualdmg:SetDamageForce(self:GetForward() *((doactualdmg:GetDamage() +100) *70))
						doactualdmg:SetInflictor(self)
						doactualdmg:SetAttacker(self.User)
						v:TakeDamageInfo(doactualdmg,self.User)
						if v:IsPlayer() then
							v:ViewPunch(Angle(math.random(-1,1) *dmg,math.random(-1,1) *dmg,math.random(-1,1) *dmg))
						end
					end
					hitentity = true
					table.insert(hitEnts,v)
					if snd then v:EmitSound("cpthazama/persona5/misc/00051.wav",math.random(60,72),math.random(100,120)) end
					
					-- if v:GetClass() == "prop_physics" then
						local phys = v:GetPhysicsObject()
						if IsValid(phys) then
							phys:ApplyForceCenter(v:GetPos() +self:GetForward() *phys:GetMass() *(dmg *20) +self:GetUp() *phys:GetMass() *(dmg))
						end
					-- end
				end
			end
		end
	end
	if hitentity then
		if self.CustomOnHitEntity then self:CustomOnHitEntity(hitEnts,doactualdmg) end
	else
		self:EmitSound("npc/zombie/claw_miss1.wav",math.random(50,65),math.random(100,125))
		if self.CustomOnMissEntity then self:CustomOnMissEntity() end
	end
end
---------------------------------------------------------------------------------------------------------------------------------------------
function ENT:GetAttackPosition()
	return self:GetTask() == "TASK_ATTACK" && self:GetPos() +self:OBBCenter() +self:GetForward() *350 or self:GetPos() +self:OBBCenter()
end
---------------------------------------------------------------------------------------------------------------------------------------------
function ENT:DoIdle()
	self:SetTask("TASK_IDLE")
	self.CurrentIdle = self.User:Crouching() && "low_hp" or "idle"
	self:PlayAnimation(self.CurrentIdle,1,1)
end
---------------------------------------------------------------------------------------------------------------------------------------------
function ENT:GetSpawnPosition(ply)
	return ply:GetPos() +ply:GetForward() *-50 +ply:GetRight() *-15
end
---------------------------------------------------------------------------------------------------------------------------------------------
function ENT:GetIdlePosition(ply)
	return ply:GetPos() +ply:GetForward() *-50 +ply:GetRight() *-15
end
---------------------------------------------------------------------------------------------------------------------------------------------
function ENT:OnSummoned(ply)
	ply:EmitSound("cpthazama/persona5/joker/0029.wav")
	self.StandDistance = 393.7 *4 -- 40 meters
	self.TimeToMazionga = CurTime() +2
	self.IsArmed = false

	self.Damage = 500
	self.DamageBuild = 800
	
	self:AddCard("Abyssal Wings",30,false)
	self:AddCard("Life Drain",3,false)
	self:AddCard("Vorpal Blade",23,true)
	self:SetCard("Abyssal Wings",30)

	local v = {forward=-125,right=60,up=35}
	ply:SetNWVector("Persona_CustomPos",Vector(v.right,v.forward,v.up))
end
---------------------------------------------------------------------------------------------------------------------------------------------
function ENT:OnRequestDisappear(ply)
	ply:EmitSound("cpthazama/persona5/joker/0" .. math.random(106,120) .. ".wav")
end