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
			self:SetPos(self.User:GetPos() +self.User:GetForward() *60)
			self:SetAngles(self.User:GetAngles())
			-- timer.Simple(SoundDuration("cpthazama/persona5/joker/0011.wav"),function()
				-- if IsValid(self) then
					-- ply:EmitSound("cpthazama/persona5/joker/0012.wav",85)
				-- end
			-- end)
			timer.Simple(0.85,function()
				if IsValid(self) then
					self:MeleeAttackCode(self.Damage,300,75)
				end
			end)
			timer.Simple(0.9,function()
				if IsValid(self) then
					self:MeleeAttackCode(self.Damage /6,1000,95)
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
		if self.User:GetSP() > self.CurrentCardCost && !self.IsArmed && self:GetTask() != "TASK_PLAY_ANIMATION" && self:GetTask() != "TASK_ATTACK" then
			self.DamageBuild = 250
			self:SetTask("TASK_PLAY_ANIMATION")
			self:PlayAnimation("atk_mazionga_pre",1)
			self:TakeSP(self.CurrentCardCost)
			ply:EmitSound("cpthazama/persona5/joker/0009.wav")
			timer.Simple(self:GetSequenceDuration(self,"atk_mazionga_pre"),function()
				if IsValid(self) then
					self.IsArmed = true
					self:PlayAnimation("atk_mazionga_pre_idle",1,1)
				end
			end)
		end
	end
	if self.IsArmed && rmb then
		self.DamageBuild = math.Clamp(self.DamageBuild +2,250,1500)
	end
	if self:GetTask() == "TASK_PLAY_ANIMATION" && self.IsArmed && !rmb && CurTime() > self.TimeToMazionga then
		self:MeleeAttackCode(self.DamageBuild,2500,180,false)
		self:PlayAnimation("atk_mazionga",1)
		ply:EmitSound("cpthazama/persona5/joker/0012.wav",85)
		self.TimeToMazionga = CurTime() +self:GetSequenceDuration(self,"atk_mazionga") +0.2
		timer.Simple(self:GetSequenceDuration(self,"atk_mazionga"),function()
			if IsValid(self) then
				self.IsArmed = false
				self:DoIdle()
			end
		end)
	end
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
function ENT:OnRequestDisappear(ply)
	ply:EmitSound("cpthazama/persona5/joker/0" .. math.random(106,120) .. ".wav")
end
---------------------------------------------------------------------------------------------------------------------------------------------
function ENT:OnSummoned(ply)
	ply:EmitSound("cpthazama/persona5/joker/0010.wav")
	self.StandDistance = 393.7 *4.5 -- 45 meters
	self.TimeToMazionga = CurTime() +1
	self.IsArmed = false

	self.Damage = 850
	self.DamageBuild = 300
	
	self:SetSkin(1)
	
	self:AddCard("Zionga",8,false)
	self:SetCard("Zionga",8)

	local v = {forward=-200,right=80,up=50}
	ply:SetNWVector("Persona_CustomPos",Vector(v.right,v.forward,v.up))
end