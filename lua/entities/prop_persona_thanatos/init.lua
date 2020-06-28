AddCSLuaFile("shared.lua")
include("shared.lua")
---------------------------------------------------------------------------------------------------------------------------------------------
ENT.Bot_StopDistance = 100
ENT.Bot_Buttons = {
	[1] = {but={IN_ATTACK},dist=100,chance=1},
}
---------------------------------------------------------------------------------------------------------------------------------------------
function ENT:PersonaControls(ply,persona)
	local lmb = ply:KeyDown(IN_ATTACK)
	local rmb = ply:KeyDown(IN_ATTACK2)
	local r = ply:KeyDown(IN_RELOAD)
	if self:GetTask() == "TASK_IDLE" then
		if self.User:Crouching() && self.CurrentIdle != "low_hp" then
			self:DoIdle()
		elseif !self.User:Crouching() && self.CurrentIdle != "idle" then
			self:DoIdle()
		end
	end
	if lmb then
		if self.User:Health() > self.User:GetMaxHealth() *0.17 && self:GetTask() != "TASK_ATTACK" && !self.IsArmed then
			self:SetTask("TASK_ATTACK")
			self:PlayAnimation("attack",1)
			ply:EmitSound("cpthazama/persona5/joker/0008.wav",85)
			self:FindTarget(ply)
			self:SetAngles(self.User:GetAngles())
			self:TakeHP(self.User:GetMaxHealth() *0.17)
			-- timer.Simple(SoundDuration("cpthazama/persona5/joker/0011.wav"),function()
				-- if IsValid(self) then
					-- ply:EmitSound("cpthazama/persona5/joker/0012.wav",85)
				-- end
			-- end)
			timer.Simple(0.9,function()
				if IsValid(self) then
					self:MeleeAttackCode(self.Damage,300,75)
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
		if self.User:GetSP() > self.CurrentCardCost && !self.IsArmed && self:GetTask() != "TASK_PLAY_ANIMATION" && self:GetTask() != "TASK_ATTACK" then
			self.DamageBuild = 800
			self:SetTask("TASK_PLAY_ANIMATION")
			self:PlayAnimation("range_pre",1)
			self:TakeSP(self.CurrentCardCost)
			ply:EmitSound("cpthazama/persona5/joker/0007.wav")
			self:SetAngles(self.User:GetAngles())
			timer.Simple(self:GetSequenceDuration(self,"range_pre"),function()
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
		ply:EmitSound("cpthazama/persona5/joker/0028.wav",85)
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
	if FindEnts != nil then
		for _,v in pairs(FindEnts) do
			if (v != self && v != self.User) && (((v:IsNPC() or (v:IsPlayer() && v:Alive()))) or v:GetClass() == "func_breakable_surf" or v:GetClass() == "prop_physics") then
				if (self:GetForward():Dot((Vector(v:GetPos().x,v:GetPos().y,0) - Vector(self:GetPos().x,self:GetPos().y,0)):GetNormalized()) > math.cos(math.rad(rad))) then
					if snd == 1 then
						local doactualdmg = DamageInfo()
						if math.random(1,3) == 1 then
							dmg = 999999999
							v:SetHealth(0)
						end
						doactualdmg:SetDamage(dmg)
						doactualdmg:SetDamageType(DMG_P_ALMIGHTY)
						doactualdmg:SetInflictor(self)
						doactualdmg:SetAttacker(self.User)
						v:TakeDamageInfo(doactualdmg,self.User)
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
		if self.CustomOnHitEntity then self:CustomOnHitEntity(hitEnts) end
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
	ply:EmitSound("cpthazama/persona5/joker/0005.wav")
	self.PersonaDistance = 393.7 *4 -- 40 meters
	self.TimeToMazionga = CurTime() +2
	self.IsArmed = false

	self.Damage = 1000
	self.DamageBuild = 800
	
	self:AddCard("Doors of Hades",32,false)
	self:SetCard("Doors of Hades",32)

	local v = {forward=-200,right=80,up=50}
	ply:SetNWVector("Persona_CustomPos",Vector(v.right,v.forward,v.up))
end
---------------------------------------------------------------------------------------------------------------------------------------------
function ENT:OnRequestDisappear(ply)
	ply:EmitSound("cpthazama/persona5/joker/0" .. math.random(106,120) .. ".wav")
end