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