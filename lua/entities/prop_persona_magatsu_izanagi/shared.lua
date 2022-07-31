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

	function ENT:Think()
		if IsValid(self) then
			local ent = self
			hook.Add("HUDPaint","Persona_HUD_MagatsuIzanagi_FX",function()
				local ply = LocalPlayer()
				local persona = ply:GetNW2Entity("PersonaEntity")
				
				if persona == ent && IsValid(persona) && persona:GetCriticalFX() then
					local background = surface.GetTextureID("hud/persona/critical_adachi")
					surface.SetTexture(background)
					surface.SetDrawColor(255,255,255,255)
					surface.DrawTexturedRectRotated(ScrW() *0.5,ScrH() *0.5,ScrW(),ScrH() *0.4,0)
				end
			end)
		end
	end
end