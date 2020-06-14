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
	if self.IsArmed then
		self:FacePlayerAim(ply)
	end
	if lmb then
		if self.User:Health() > self.User:GetMaxHealth() *0.08 && self:GetTask() != "TASK_ATTACK" && !self.IsArmed then
			self:SetTask("TASK_ATTACK")
			self:PlayAnimation("atk_cross_slash",1)
			ply:EmitSound("cpthazama/persona5/joker/0011.wav",85)
			self:FindTarget(ply)
			self:SetAngles(self.User:GetAngles())
			self:TakeHP(self.User:GetMaxHealth() *0.08)
			timer.Simple(0.8,function()
				if IsValid(self) then
					self:MeleeAttackCode(self.HeatRiserT > CurTime() && self.Damage *1.5 or self.Damage,450,60)
				end
			end)
			timer.Simple(1.65,function()
				if IsValid(self) then
					self:MeleeAttackCode(self.HeatRiserT > CurTime() && self.Damage *1.5 or self.Damage,450,100)
				end
			end)
			timer.Simple(1.7,function()
				if IsValid(self) then
					self:MeleeAttackCode(self.HeatRiserT > CurTime() && self.Damage /6 *1.5 or self.Damage /6,2500,160)
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
		if self:GetCard() == "Myriad Truths" then 
			if self.User:GetSP() > self.CurrentCardCost && !self.IsArmed && self:GetTask() != "TASK_PLAY_ANIMATION" && self:GetTask() != "TASK_ATTACK" then
				self:SetTask("TASK_PLAY_ANIMATION")
				self:PlayAnimation("myriad_pre",1)
				self:TakeSP(self.CurrentCardCost)
				ply:EmitSound("cpthazama/persona5/joker/0009.wav")
				timer.Simple(self:GetSequenceDuration(self,"myriad_pre"),function()
					if IsValid(self) then
						self.IsArmed = true
						self:PlayAnimation("myriad_pre_idle",1,1)
					end
				end)
			end
		elseif self:GetCard() == "Concentrate" then
			if !self.IsConcentrating && self:GetTask() != "TASK_PLAY_ANIMATION" then
				self:SetTask("TASK_PLAY_ANIMATION")
				self:PlayAnimation("myriad_pre",1)
				self:TakeSP(self.CurrentCardCost)
				timer.Simple(self:GetSequenceDuration(self,"myriad_pre"),function()
					if IsValid(self) then
						self:PlayAnimation("myriad",1)
						self.IsConcentrating = true
						self.User:ChatPrint("Next Myriad Truths attack inflicts 2.5x damage!")
						self:EmitSound("cpthazama/persona5/skills/0434.wav",85)
						timer.Simple(self:GetSequenceDuration(self,"myriad"),function()
							if IsValid(self) then
								self:SetTask("TASK_IDLE")
								self:DoIdle()
							end
						end)
					end
				end)
			end
		elseif self:GetCard() == "Heat Riser" then
			if CurTime() > self.HeatRiserT && self:GetTask() != "TASK_PLAY_ANIMATION" then
				self:SetTask("TASK_PLAY_ANIMATION")
				self:PlayAnimation("myriad_pre",1)
				self:TakeSP(self.CurrentCardCost)
				timer.Simple(self:GetSequenceDuration(self,"myriad_pre"),function()
					if IsValid(self) then
						self:PlayAnimation("myriad",1)
						self.HeatRiserT = CurTime() +60
						self:EmitSound("cpthazama/persona5/skills/0361.wav",85)
						self.User:ChatPrint("Buffed melee attacks for 1 minute!")
						timer.Simple(self:GetSequenceDuration(self,"myriad"),function()
							if IsValid(self) then
								self:SetTask("TASK_IDLE")
								self:DoIdle()
							end
						end)
					end
				end)
			end
		elseif self:GetCard() == "Salvation" then
			if self:GetTask() != "TASK_PLAY_ANIMATION" then
				self:SetTask("TASK_PLAY_ANIMATION")
				self:PlayAnimation("myriad_pre",1)
				self:TakeSP(self.CurrentCardCost)
				timer.Simple(self:GetSequenceDuration(self,"myriad_pre"),function()
					if IsValid(self) then
						self:PlayAnimation("myriad",1)
						self.User:SetHealth(self.User:GetMaxHealth())
						self.User:ChatPrint("Restored HP!")
						self:EmitSound("cpthazama/persona5/skills/0302.wav",85)
						timer.Simple(self:GetSequenceDuration(self,"myriad"),function()
							if IsValid(self) then
								self:SetTask("TASK_IDLE")
								self:DoIdle()
							end
						end)
					end
				end)
			end
		end
	end
	if r && CurTime() > self.NextCardSwitchT then
		if self:GetCard() == "Myriad Truths" then
			self:SetCard("Concentrate")
		elseif self:GetCard() == "Concentrate" then
			self:SetCard("Heat Riser")
		elseif self:GetCard() == "Heat Riser" then
			self:SetCard("Salvation")
		elseif self:GetCard() == "Salvation" then
			self:SetCard("Myriad Truths")
		end
	end
	if self:GetTask() == "TASK_PLAY_ANIMATION" && self.IsArmed && !rmb && CurTime() > self.TimeToRange then
		self:PlayAnimation("myriad",1)
		local tb = {
			[1] = self:GetUp() *350,
			[2] = self:GetUp() *310 +self:GetRight() *50,
			[3] = self:GetUp() *270 +self:GetRight() *100,
			[4] = self:GetUp() *230 +self:GetRight() *150,
			[5] = self:GetUp() *190 +self:GetRight() *200,
			[6] = self:GetUp() *310 +self:GetRight() *-50,
			[7] = self:GetUp() *270 +self:GetRight() *-100,
			[8] = self:GetUp() *230 +self:GetRight() *-150,
			[9] = self:GetUp() *190 +self:GetRight() *-200,
		}
		for i = 1,9 do
			local proj = ents.Create("obj_vj_per_okamiblast")
			proj:SetPos(self:GetPos() +self:OBBCenter() +tb[i])
			proj:SetAngles(IsValid(self:UserTrace().Entity) && (self:UserTrace().Entity:GetPos() +self:UserTrace().Entity:OBBCenter() -proj:GetPos()):Angle() or (self:UserTrace().HitPos -self:GetPos() +self:OBBCenter()):Angle())
			proj:Spawn()
			proj.DirectDamage = 100 *(self.IsConcentrating && 2.5 or 1)
			proj.DirectDamage = proj.DirectDamage *1.25 // Automatic boost
			proj:SetOwner(self.User)
			proj:SetPhysicsAttacker(self.User)
			proj:EmitSound("cpthazama/persona5/skills/0338.wav")
			
			if IsValid(proj:GetPhysicsObject()) then
				proj:GetPhysicsObject():SetVelocity(IsValid(self:UserTrace().Entity) && (self:UserTrace().Entity:GetPos() +self:UserTrace().Entity:OBBCenter() -proj:GetPos()) *5000 or (self:UserTrace().HitPos -proj:GetPos()) *5000)
			end
			if i == 9 && self.IsConcentrating then self.IsConcentrating = false end
		end
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
	
	self.IsConcentrating = false
	self.HeatRiserT = CurTime()

	self.Damage = 2500

	self:AddCard("Myriad Truths",40,false)
	self:AddCard("Concentrate",15,false)
	self:AddCard("Heat Riser",30,false)
	self:AddCard("Salvation",48,false)
	self:SetCard("Myriad Truths",40)

	local v = {forward=-200,right=80,up=110}
	ply:SetNWVector("Persona_CustomPos",Vector(v.right,v.forward,v.up))
end
---------------------------------------------------------------------------------------------------------------------------------------------
function ENT:OnKilledEnemy(ent)
	self.User:SetSP(self.User:GetMaxSP())
	self.User:SetHealth(self.User:GetMaxHealth())
end
---------------------------------------------------------------------------------------------------------------------------------------------
function ENT:OnRequestDisappear(ply)
	ply:EmitSound("cpthazama/persona5/joker/0" .. math.random(106,120) .. ".wav")
end