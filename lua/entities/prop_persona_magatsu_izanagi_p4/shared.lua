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
-- if CLIENT then
	-- function ENT:Think()
		-- if IsValid(self) then
			-- hook.Add("HUDPaint","Persona_HUD_MagatsuIzanagi",function()
				-- local ply = LocalPlayer()
				-- local persona = ply:GetNWEntity("PersonaEntity")

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
				-- local camPos = Vector(120,60,90)
				-- local lookPos = Vector(0,-20,180)

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
		-- else
			-- hook.Remove("HUDPaint","Persona_HUD_MagatsuIzanagi")
		-- end
	-- end
-- end