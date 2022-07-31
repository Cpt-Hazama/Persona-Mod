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
---------------------------------------------------------------------------------------------------------------------------------------------
-- if CLIENT then
	-- hook.Add("HUDPaint","Persona_HUD_Izanagi",function()
		-- local ply = LocalPlayer()
		-- local persona = ply:GetNW2Entity("PersonaEntity")

		-- if !IsValid(persona) then
			-- if ply.PersonaRender then
				-- ply.PersonaRender:Remove()
			-- end
			-- if ply.PersonaRenderBackground then
				-- ply.PersonaRenderBackground:Remove()
			-- end
			-- return
		-- end

		-- local posX = 250
		-- local posY = 355
		-- local len = 225
		-- local height = 175
		-- local fov = 20
		-- local camPos = Vector(120,60,200)
		-- local lookPos = Vector(0,10,215)

		-- if !IsValid(ply.PersonaRender) then
			-- ply.PersonaRenderBackground = vgui.Create("DPanel",ply)
			-- ply.PersonaRenderBackground:SetPos(ScrW() -posX,ScrH() -posY)
			-- ply.PersonaRenderBackground:SetSize(len,height)

			-- ply.PersonaRender = vgui.Create("DModelPanel",ply)
			-- ply.PersonaRender:SetPos(ScrW() -posX,ScrH() -posY)
			-- ply.PersonaRender:SetSize(len,height)
			-- ply.PersonaRender:SetModel(persona:GetModel())
			-- ply.PersonaRender:SetCamPos(camPos)
			-- ply.PersonaRender:SetLookAt(lookPos)
			-- ply.PersonaRender:SetAnimated(true)
			-- ply.PersonaRender:SetAnimSpeed(1)
			-- ply.PersonaRender:SetFOV(20)
			-- function ply.PersonaRender:LayoutEntity(Entity)
				-- if (self.bAnimated) then
					-- self:RunAnimation()
				-- end
			-- end
		-- end
		
		-- if ply.PersonaRender then
			-- ply.PersonaRender:SetCamPos(camPos)
			-- ply.PersonaRender:SetLookAt(lookPos)
		-- end
	-- end)
-- end