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
		if self:GetTask() != "TASK_ATTACK" && !self.IsArmed then
			self:SetTask("TASK_ATTACK")
			self:PlayAnimation("atk_cross_slash",1)
			ply:EmitSound("cpthazama/persona5/joker/0011.wav",85)
			self:FindTarget(ply)
			self:SetAngles(self.User:GetAngles())
			self:TakeHP(self.User:Health() *0.08)
			timer.Simple(0.8,function()
				if IsValid(self) then
					self:MeleeAttackCode(self.Damage,450,60)
				end
			end)
			timer.Simple(1.65,function()
				if IsValid(self) then
					self:MeleeAttackCode(self.Damage,450,100)
				end
			end)
			timer.Simple(1.7,function()
				if IsValid(self) then
					self:MeleeAttackCode(self.Damage /6,2500,160)
				end
			end)
			timer.Simple(self:GetSequenceDuration(self,"atk_cross_slash"),function()
				if IsValid(self) then
					self:DoIdle()
				end
			end)
		end
	end
	if rmb then
		if !self.IsArmed && self:GetTask() != "TASK_PLAY_ANIMATION" && self:GetTask() != "TASK_ATTACK" then
			self:SetTask("TASK_PLAY_ANIMATION")
			self:PlayAnimation("myriad_pre",1)
			ply:EmitSound("cpthazama/persona5/joker/0009.wav")
			self:TakeSP(40)
			timer.Simple(self:GetSequenceDuration(self,"myriad_pre"),function()
				if IsValid(self) then
					self.IsArmed = true
					self:PlayAnimation("myriad_pre_idle",1,1)
				end
			end)
		end
	end
	if self:GetTask() == "TASK_PLAY_ANIMATION" && self.IsArmed && !rmb && CurTime() > self.TimeToRange then
		self:PlayAnimation("myriad",1)
		self.TimeToRange = CurTime() +self:GetSequenceDuration(self,"myriad") +0.2
		timer.Simple(self:GetSequenceDuration(self,"myriad"),function()
			if IsValid(self) then
				self.IsArmed = false
				self:DoIdle()
			end
		end)
	end
end
---------------------------------------------------------------------------------------------------------------------------------------------
function ENT:HandleDamage(dmg,dmgtype,dmginfo)
	dmginfo:ScaleDamage(0.025) // Okami has the highest resistance to all damage types in Persona
	return false
end
---------------------------------------------------------------------------------------------------------------------------------------------
function ENT:DoIdle()
	self:SetTask("TASK_IDLE")
	self.CurrentIdle = self.User:Crouching() && "low_hp" or "idle"
	self:PlayAnimation(self.CurrentIdle,1,1)
end
---------------------------------------------------------------------------------------------------------------------------------------------
function ENT:GetSpawnPosition(ply)
	return ply:GetPos() +ply:GetForward() *-50 +ply:GetRight() *-15 +ply:GetUp() *(ply:Crouching() && 0 or 45)
end
---------------------------------------------------------------------------------------------------------------------------------------------
function ENT:GetIdlePosition(ply)
	return ply:GetPos() +ply:GetForward() *-50 +ply:GetRight() *-15 +ply:GetUp() *(ply:Crouching() && 0 or 45)
end
---------------------------------------------------------------------------------------------------------------------------------------------
function ENT:OnSummoned(ply)
	ply:EmitSound("cpthazama/persona5/joker/0009.wav")
	self.StandDistance = 393.7 *10 -- 100 meters
	self.TimeToRange = CurTime() +2
	self.IsArmed = false

	self.Damage = 2500
	
	self:SetNWString("SpecialAttack","Myriad Truths")

	local v = {forward=-200,right=80,up=50}
	ply:SetNWVector("Persona_CustomPos",Vector(v.right,v.forward,v.up))
end
---------------------------------------------------------------------------------------------------------------------------------------------
function ENT:OnRequestDisappear(ply)
	ply:EmitSound("cpthazama/persona5/joker/0" .. math.random(106,120) .. ".wav")
end