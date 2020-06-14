AddCSLuaFile("cl_init.lua")
AddCSLuaFile("shared.lua")
include('shared.lua')

SWEP.Weight         = 0
SWEP.AutoSwitchTo   = false
SWEP.AutoSwitchFrom = false

function SWEP:GetCapabilities()
	return 0
end