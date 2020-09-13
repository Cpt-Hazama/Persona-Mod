if (!file.Exists("autorun/vj_base_autorun.lua","LUA")) then return end
---------------------------------------------------------------------------------------------------------------------------------------------
SWEP.Base = "weapon_vj_base"
SWEP.PrintName = "Axe"
SWEP.Author = "Cpt. Hazama"
SWEP.Contact = "http://steamcommunity.com/groups/vrejgaming"
SWEP.Purpose = "This weapon is made for Players and NPCs"
SWEP.Instructions = "Controls are like a regular weapon."
SWEP.MadeForNPCsOnly = true -- Is this weapon meant to be for NPCs only?
	-- NPC Settings ---------------------------------------------------------------------------------------------------------------------------------------------
SWEP.NPC_NextPrimaryFire = 1 -- Next time it can use primary fire
SWEP.NPC_TimeUntilFire = 0 -- How much time until the bullet/projectile is fired?
	-- Main Settings ---------------------------------------------------------------------------------------------------------------------------------------------
SWEP.WorldModel = "models/cpthazama/persona4/weapons/labrys_axe.mdl"
SWEP.HoldType = "melee"
	-- Primary Fire ---------------------------------------------------------------------------------------------------------------------------------------------
SWEP.Primary.Damage = 95 -- Damage
SWEP.Primary.ClipSize = 0 -- Damage

SWEP.WorldModel_UseCustomPosition = true -- Should the gun use custom position? This can be used to fix guns that are in the crotch
SWEP.WorldModel_CustomPositionBone = "Bip01 L Hand"
SWEP.WorldModel_CustomPositionAngle = Vector(0,0,180)
SWEP.WorldModel_CustomPositionOrigin = Vector(0.5,3,-20)
---------------------------------------------------------------------------------------------------------------------------------------------
function SWEP:PrimaryAttack()
	return false
end
---------------------------------------------------------------------------------------------------------------------------------------------
function SWEP:DecideBulletPosition()
	local owner = self:GetOwner()
	if !IsValid(owner) then return nil end
	return owner:EyePos()
end