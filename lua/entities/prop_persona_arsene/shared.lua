ENT.Base 			= "prop_persona"
ENT.Type 			= "anim"
ENT.PrintName 		= ""
ENT.Author 			= "Cpt. Hazama"
ENT.Contact 		= ""
ENT.Purpose 		= ""
ENT.Instructions 	= ""
ENT.Category		= ""

ENT.Spawnable = false
ENT.AdminOnly = false
ENT.AutomaticFrameAdvance = true
---------------------------------------------------------------------------------------------------------------------------------------------
if CLIENT then
	function ENT:SetActivities()
		local tbl = {}
		tbl[ACT_MP_STAND_IDLE]					= "pose_standing_01"
		tbl[ACT_MP_WALK]						= ACT_MP_WALK
		tbl[ACT_MP_RUN]							= ACT_HL2MP_RUN_FAST
		tbl[ACT_MP_CROUCH_IDLE]					= "pose_ducking_01"
		tbl[ACT_MP_CROUCHWALK]					= ACT_MP_CROUCHWALK
		tbl[ACT_MP_ATTACK_STAND_PRIMARYFIRE]	= ACT_MP_ATTACK_STAND_PRIMARYFIRE
		tbl[ACT_MP_ATTACK_CROUCH_PRIMARYFIRE]	= ACT_MP_ATTACK_CROUCH_PRIMARYFIRE
		tbl[ACT_MP_JUMP]						= ACT_MP_JUMP
		tbl[ACT_RANGE_ATTACK1]					= "taunt_laugh"

		return tbl
	end
end