include('shared.lua')

SWEP.PrintName        = ""
SWEP.Author           = ""
SWEP.Purpose          = ""
SWEP.Instructions     = ""
SWEP.Slot             = 0
SWEP.SlotPos          = 0
SWEP.DrawAmmo         = false
SWEP.DrawCrosshair    = true

function SWEP:ShouldDrawViewModel()
	return false
end

function SWEP:DrawWorldModel()
	return false
end