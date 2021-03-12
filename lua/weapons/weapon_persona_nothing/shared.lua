SWEP.PrintName				=  ""
SWEP.HoldType				=  "normal"
SWEP.Category				=  ""
SWEP.Spawnable				=  false
SWEP.AdminSpawnable			=  false
SWEP.ViewModel				=  ""
SWEP.WorldModel				=  ""

SWEP.Primary.Automatic		=  false
SWEP.Primary.Ammo			=  "none"
SWEP.Secondary.Automatic	=  false
SWEP.Secondary.Ammo			=  "none"

function SWEP:Initialize()
	self:SetHoldType(self.HoldType)
	timer.Simple(0,function() if self.SetActivities then self:SetActivities() end end)
end

function SWEP:CustomAmmoDisplay()
	self.AmmoDisplay = self.AmmoDisplay or {}
	self.AmmoDisplay.Draw = false

	return self.AmmoDisplay
end

function SWEP:SetActivities()
	local gotTable = false
	if IsValid(self.Owner) then
		local persona = self.Owner:GetPersona()
		if IsValid(persona) && persona.SetActivities then
			self.ActivityTranslate = persona:SetActivities()
			-- PrintTable(self.ActivityTranslate)
			gotTable = true
		end
	end
	if gotTable then return end

	self.ActivityTranslate = {}
	self.ActivityTranslate[ACT_MP_STAND_IDLE]					= ACT_HL2MP_IDLE_ANGRY
	self.ActivityTranslate[ACT_MP_WALK]							= ACT_MP_WALK
	self.ActivityTranslate[ACT_MP_RUN]							= ACT_HL2MP_RUN_FAST
	-- self.ActivityTranslate[ACT_MP_CROUCH_IDLE]					= "pose_ducking_01"
	self.ActivityTranslate[ACT_MP_CROUCH_IDLE]					= ACT_MP_CROUCH_IDLE
	self.ActivityTranslate[ACT_MP_CROUCHWALK]					= ACT_MP_CROUCHWALK
	self.ActivityTranslate[ACT_MP_ATTACK_STAND_PRIMARYFIRE]		= ACT_MP_ATTACK_STAND_PRIMARYFIRE
	self.ActivityTranslate[ACT_MP_ATTACK_CROUCH_PRIMARYFIRE]	= ACT_MP_ATTACK_CROUCH_PRIMARYFIRE
	self.ActivityTranslate[ACT_MP_JUMP]							= ACT_MP_JUMP
	self.ActivityTranslate[ACT_RANGE_ATTACK1]					= "taunt_laugh"
end

function SWEP:TranslateActivity(act)
	local trans = self.ActivityTranslate[act]
	if trans != nil then
		if type(trans) == "table" then
			trans = VJ_PICK(trans)
		end
		if type(trans) == "string" then
			trans = VJ_SequenceToActivity(self.Owner,trans)
		end
		return trans
	end
	return -1
end

function SWEP:Think()
	-- if IsValid(self.Owner) then
		-- local persona = self.Owner:GetPersona()
		-- if IsValid(persona) && persona.SetActivities then
			-- self.ActivityTranslate = persona:SetActivities()
		-- end
	-- end
end

function SWEP:Deploy()
	return true
end

function SWEP:Holster()
	return true
end

function SWEP:PrimaryAttack()
	return false
end

function SWEP:CanPrimaryAttack()
	return false
end

function SWEP:CanSecondaryAttack()
	return true
end

function SWEP:SecondaryAttack()
	return false
end

function SWEP:DrawHUD()
	return false
end