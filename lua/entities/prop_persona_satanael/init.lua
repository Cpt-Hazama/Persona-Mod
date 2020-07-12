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
function ENT:GetSpawnPosition(ply)
	return ply:GetPos() +ply:GetForward() *-400 +ply:GetRight() *-15
end
---------------------------------------------------------------------------------------------------------------------------------------------
function ENT:GetIdlePosition(ply)
	return ply:GetPos() +ply:GetForward() *-400 +ply:GetRight() *-15
end
---------------------------------------------------------------------------------------------------------------------------------------------
function ENT:OnSummoned(ply)
	ply:EmitSound("cpthazama/persona5/joker/0005.wav")
	self.PersonaDistance = 999999999
	self.TimeToMazionga = CurTime() +2
	self.IsArmed = false

	self.Damage = 1000
	self.DamageBuild = 800
	
	self:AddCard("Doors of Hades",32,false)
	self:SetCard("Doors of Hades",32)

	local v = {forward=-600,right=300,up=300}
	ply:SetNWVector("Persona_CustomPos",Vector(v.right,v.forward,v.up))
end
---------------------------------------------------------------------------------------------------------------------------------------------
function ENT:OnRequestDisappear(ply)
	ply:EmitSound("cpthazama/persona5/joker/0" .. math.random(106,120) .. ".wav")
end