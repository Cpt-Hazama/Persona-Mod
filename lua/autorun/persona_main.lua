include("persona_xp.lua")

if SERVER then
	util.AddNetworkString("persona_csound")
end

if CLIENT then
	CreateClientConVar("persona_hud_x","350",false,false)
	CreateClientConVar("persona_hud_y","250",false,false)

	net.Receive("persona_csound",function(len,pl)
		local ply = net.ReadEntity()
		local snd = net.ReadString()
		local vol = net.ReadFloat()
		local pit = net.ReadFloat()

		ply:EmitSound(snd,vol,pit)
	end)
end

function Persona_Pick(tbl)
	return tbl[math.random(1,#tbl)]
end

local PLY = FindMetaTable("Player")

function PLY:HasPersona()
	return self:GetNWBool("PersonaUser") or false
end

function PLY:SetPersona(persona)
	self:SetNWBool("PersonaUser",true)
	self:SetNWString("PersonaName",persona)
end

function PLY:SetSP(sp)
	self:SetNWInt("Persona_SP",sp)
end

function PLY:SetMaxSP(spm)
	self:SetNWInt("Persona_SPMax",spm)
end

function PLY:GetSP()
	return self:GetNWInt("Persona_SP")
end

function PLY:GetMaxSP()
	return self:GetNWInt("Persona_SPMax")
end

function PLY:GetPersonaName()
	return self:GetNWString("PersonaName")
end

function PLY:SetPersonaEntity(ent)
	self:SetNWEntity("Persona",ent)
end

function PLY:GetPersona()
	return self:GetNWEntity("Persona")
end

function PLY:SetMaxHealth(mhp)
	self:SetNWInt("MaxHealth",mhp)
end

function PLY:GetMaxHealth()
	return self:GetNWInt("MaxHealth")
end

function PLY:GetNextPersonaSummonT()
	return self:GetNWInt("PersonaSummonT") or 0
end

function PLY:SetNextPersonaSummonT(t)
	self:SetNWInt("PersonaSummonT",CurTime() +t)
end

function Persona_CSound(ply,snd,vol,pit)
	net.Start("persona_csound")
		net.WriteEntity(ply)
		net.WriteString(snd)
		net.WriteFloat(vol or 75)
		net.WriteFloat(pit or 100)
	net.Send(ply)
end

local NPC = FindMetaTable("NPC")

function NPC:Alive()
	return self:Health() > 0
end

function NPC:GetPersona()
	return self:GetNWEntity("PersonaEntity")
end

function NPC:SetPersonaEntity(ent,name)
	self:SetNWEntity("PersonaEntity",ent)
	self:SetNWString("PersonaName",name)
	ent.User = self
end

function NPC:GetPersonaName()
	return self:GetNWString("PersonaName")
end

function NPC:SetSP(sp)
	self:SetNWInt("Persona_SP",sp)
end

function NPC:SetMaxSP(spm)
	self:SetNWInt("Persona_SPMax",spm)
end

function NPC:GetSP()
	return self:GetNWInt("Persona_SP")
end

function NPC:GetMaxSP()
	return self:GetNWInt("Persona_SPMax")
end

function NPC:HasGodMode()
	return self.GodMode
end

function NPC:SummonPersona(persona)
	local personaEntity = self:GetPersona()
	if self:GetState() != 0 then return end
	if !IsValid(personaEntity) then
		local class = "prop_persona_" .. persona
		local ent = ents.Create(class)
		-- ent:SetModel(ent.Model)
		ent:SetModel(PERSONA[persona] && PERSONA[persona].Model or ent.Model)
		ent:SetPos(ent:GetSpawnPosition(self) or self:GetPos())
		ent:SetAngles(self:GetAngles())
		ent:Spawn()
		self:SetPersonaEntity(ent,persona)
		ent:RequestAura(ent,PERSONA[persona] && PERSONA[persona].Aura or ent.Aura)
		ent.User = self
		-- ent.Persona = self:GetPersonaName()
		ent:DoIdle()
		ent:OnSummoned(self)
		ent:SetFeedName(PERSONA[persona] && PERSONA[persona].Name or ent.Name,class)
		if self.OnSummonPersona then
			self:OnSummonPersona(ent)
		end
	else
		if personaEntity:GetTask() != "TASK_RETURN" then
			personaEntity:SetTask("TASK_RETURN")
			personaEntity:OnRequestDisappear(self)
		end
	end
end

hook.Add("PlayerInitialSpawn","Persona_InitialSpawn",function(ply)
	ply:SetPersona(PXP.GetPersonaData(ply,5))
	local exp = PXP.GetPersonaData(ply,1)
	local lvl = PXP.GetPersonaData(ply,2)
	local comp = PXP.GetPersonaData(ply,4)
	PXP.SetPersonaData(ply,1,exp != nil && exp or 0)
	PXP.SetPersonaData(ply,2,lvl != nil && lvl or 0)
	PXP.SetPersonaData(ply,4,comp != nil && comp or {})
	PXP.SetRequiredXP(ply,PXP.GetRequiredXP(ply))

	ply:SetSP(ply:IsSuperAdmin() && 999 or ply:IsAdmin() && 350 or 150)
	ply:SetMaxSP(ply:GetSP())
	ply.Persona_MaxHealth = 100
	ply:SetMaxHealth(100)
	ply.PXP_NextXPChange = CurTime()
	
	ply.Persona_TarundaT = 0
	ply.Persona_DebilitateT = 0
	ply.Persona_HeatRiserT = 0
	ply.Persona_ChaosT = 0
	ply.Persona_ChargedT = 0
	ply.Persona_FocusedT = 0
end)

if SERVER then
	hook.Add("PlayerSpawn","Persona_Spawn",function(ply)
		ply:SetSP(ply:IsSuperAdmin() && 999 or ply:IsAdmin() && 350 or 150)
		ply:SetMaxSP(ply:GetSP())
		timer.Simple(0,function()
			if IsValid(ply) then
				ply:SetHealth(ply.Persona_MaxHealth)
			end
		end)
		ply.PXP_NextXPChange = CurTime()
	
		ply.Persona_TarundaT = 0
		ply.Persona_DebilitateT = 0
		ply.Persona_HeatRiserT = 0
		ply.Persona_ChaosT = 0
		ply.Persona_ChargedT = 0
		ply.Persona_FocusedT = 0
	end)

	hook.Add("OnEntityCreated","Persona_EntitySpawn",function(ent)
		if ent:IsNPC() then
			timer.Simple(0,function()
				if IsValid(ent) then
					ent.Persona_TarundaT = 0
					ent.Persona_DebilitateT = 0
					ent.Persona_HeatRiserT = 0
					ent.Persona_ChaosT = 0
					ent.Persona_ChargedT = 0
					ent.Persona_FocusedT = 0
					local mLevel = ent:GetNWInt("PXP_Level") or (ent.Stats && ent.Stats.LVL) or nil
					if mLevel == nil or mLevel == 0 then
						local ply = VJ_PICK(player.GetAll())
						local pLevel = 1
						if IsValid(ply) then
							pLevel = PXP.GetLevel(ply)
						end
						local gLevel = math.Round(((ent:GetMaxHealth() /800) *pLevel))
						local level = math.Clamp(math.random(math.Clamp(gLevel -10,1,99),math.Clamp(gLevel +10,1,99)),1,99)
						local exp = math.Round(((ent:GetMaxHealth() /50) *level))
						ent:SetNWInt("PXP_Level",level)
						ent:SetNWInt("PXP_EXP",exp *math.random(2,20))
					end
				end
			end)
		end
	end)

	local wep = "weapon_jojo_nothing"
	hook.Add("Think","Persona_Think",function()
		for _,v in pairs(player.GetAll()) do
			-- if CurTime() > v.PXP_NextXPChange && PXP.GetPersonaData(v,1) >= PXP.GetRequiredXP(v) then
				-- PXP.LevelUp(v)
			-- end
			if v:Health() > v:GetMaxHealth() then
				v:SetMaxHealth(v:Health())
				v.Persona_MaxHealth = v:Health()
			end
			if v:GetSP() > v:GetMaxSP() then
				v:SetMaxSP(v:GetSP())
			end
			if IsValid(v:GetPersona()) then
				if !v:HasWeapon(wep) && !v:IsFrozen() then
					v:Give(wep)
				end
				v:SelectWeapon(wep)
			else
				if v:HasWeapon(wep) then
					for _,v in pairs(v:GetWeapons()) do
						if v:GetClass() == wep then
							SafeRemoveEntity(v)
							break
						end
					end
				end
			end
		end
	end)

	hook.Add("EntityTakeDamage","Persona_ModifyPlayerDMG",function(ent,dmginfo)
		if ent.Persona_DMG_Fear && ent.Persona_DMG_Fear > CurTime() then
			dmginfo:ScaleDamage(1.5)
		end
		if ent.Persona_DebilitateT && ent.Persona_DebilitateT > CurTime() then
			dmginfo:ScaleDamage(1.5)
		end
		if ent.Persona_HeatRiserT && ent.Persona_HeatRiserT > CurTime() then
			dmginfo:ScaleDamage(0.5)
		end
		if ent:IsPlayer() or ent:IsNPC() then
			local dmgtype = dmginfo:GetDamageType()
			local dmg = dmginfo:GetDamage()
			local attacker = dmginfo:GetAttacker()
			local persona = ent:GetPersona()

			if IsValid(persona) then
				if persona.Stats then
					local stats = persona.Stats
					if VJ_HasValue(stats.WK,dmgtype) then
						dmginfo:ScaleDamage(2)
					end
					if VJ_HasValue(stats.RES,dmgtype) then
						dmginfo:ScaleDamage(0.25)
					end
					if VJ_HasValue(stats.NUL,dmgtype) then
						dmginfo:SetDamage(0)
					end
					if stats.ABS && VJ_HasValue(stats.ABS,dmgtype) then
						dmginfo:SetDamage(0)
						ent:SetHealth(math.Clamp(ent:Health() +dmg,1,ent:GetMaxHealth()))
						ent:EmitSound("cpthazama/persona5/skills/0679.wav",80)
					end
					if stats.REF && VJ_HasValue(stats.REF,dmgtype) then
						dmginfo:SetDamage(0)
						if IsValid(attacker) then
							local reflect = DamageInfo()
							reflect:SetDamage(dmg)
							reflect:SetDamageType(dmgtype)
							reflect:SetInflictor(persona)
							reflect:SetAttacker(ent)
							reflect:SetDamagePosition(attacker:NearestPoint(ent:GetPos()))
							attacker:TakeDamageInfo(reflect)
						end
					end
				end
				if persona.HandleDamage then
					return persona:HandleDamage(dmg,dmgtype,dmginfo)
				end
			end
		end
		-- return true -- Prevents all damage
	end)

	local function summon_persona(ply)
		if !ply:Alive() then return end
		if ply:HasPersona() && CurTime() > ply:GetNextPersonaSummonT() then
			local persona = ply:GetPersona()
			if !IsValid(persona) then
				local class = "prop_persona_" .. ply:GetPersonaName()
				local ent = ents.Create(class)
				ent:SetModel(PERSONA[ply:GetPersonaName()].Model)
				ent:SetPos(ent:GetSpawnPosition(ply) or ply:GetPos())
				ent:SetAngles(ply:GetAngles())
				ent:Spawn()
				ply:SetPersonaEntity(ent)
				ent:RequestAura(ply,PERSONA[ply:GetPersonaName()].Aura)
				ent.User = ply
				ent.Persona = ply:GetPersonaName()
				ent:DoIdle()
				ent:OnSummoned(ply)
				ply:SetNWEntity("PersonaEntity",ent)
				ent:SetFeedName(PERSONA[ply:GetPersonaName()].Name,class)

				if PXP.IsLegendary(ply) then
					ent:MakeLegendary()
				end

				local exp = PXP.GetPersonaData(ply,1)
				local lvl = PXP.GetPersonaData(ply,2)
				ent.EXP = exp != nil && exp or 0
				ent.Level = lvl != nil && lvl or ent.Stats.LVL
				if ent.Level < ent.Stats.LVL then
					ent.Level = ent.Stats.LVL
				end
				PXP.AddToCompendium(ply,ply:GetPersonaName())
				ent:CheckCards()
				PXP.SavePersonaData(ply,ent.EXP,ent.Level,ent.CardTable)
			else
				if persona:GetTask() == "TASK_IDLE" then
					if !persona.IsFlinching then
						persona:SetTask("TASK_RETURN")
						persona:OnRequestDisappear(ply)
					end
				end
			end
		end
	end
	concommand.Add("summon_persona",summon_persona)

	local function findTarget(ply)
		ply.NextLockOnT = ply.NextLockOnT or CurTime()
		if IsValid(ply:GetPersona()) && ply:Alive() then
			if CurTime() > ply.NextLockOnT then
				if IsValid(ply.Persona_EyeTarget) then
					ply.Persona_EyeTarget = NULL
					ply:EmitSound("cpthazama/persona5/misc/00019.wav",70,100)
				else
					local ent = ply:GetEyeTrace().Entity
					if IsValid(ent) then
						if (ent:IsNPC() or ent:IsPlayer() or (ent.IsPersona && ent != ply:GetPersona())) then
							ply.Persona_EyeTarget = ent
							ply:EmitSound("cpthazama/persona5/misc/00007.wav",70,100)
						end
					else
						local ents = ply:GetPersona():FindEnemies(ply:GetPos(),2000)
						local ent = VJ_PICK(ents)
						if IsValid(ent) then
							ply.Persona_EyeTarget = ent
							ply:EmitSound("cpthazama/persona5/misc/00007.wav",70,100)
						end
					end
				end
				ply.NextLockOnT = CurTime() +0.2
			end
		end
	end
	concommand.Add("target_persona",findTarget)
end

if CLIENT then
	surface.CreateFont("Persona",{
		font = "p5hatty",
		extended = false,
		size = 35,
		weight = 500,
		blursize = 0,
		scanlines = 0,
		antialias = true,
		underline = false,
		italic = false,
		strikeout = false,
		symbol = false,
		rotary = false,
		shadow = false,
		additive = false,
		outline = true,
	})

	surface.CreateFont("PXP_EXP",{
		font = "p5hatty",
		extended = false,
		size = 25,
		weight = 500,
		blursize = 0,
		scanlines = 0,
		antialias = true,
		underline = false,
		italic = false,
		strikeout = false,
		symbol = false,
		rotary = false,
		shadow = false,
		additive = false,
		outline = true,
	})

	hook.Add("HUDPaint","Persona_HUD",function()
		local ply = LocalPlayer()
		local persona = ply:GetNWEntity("PersonaEntity")

		if !IsValid(persona) then
			if ply.PersonaRender then
				ply.PersonaRender:Remove()
			end
			if ply.PersonaRenderBackground then
				ply.PersonaRenderBackground:Remove()
			end
			return
		end

		local posX = 250
		local posY = 355
		local len = 225
		local height = 175
		
		-- if !IsValid(ply.PersonaRender) && !IsValid(ply.PersonaRenderBackground) then
			-- ply.PersonaRenderBackground = vgui.Create("DPanel",ply)
			-- ply.PersonaRenderBackground:SetPos(ScrW() -posX,ScrH() -posY)
			-- ply.PersonaRenderBackground:SetSize(len,height)

			-- ply.PersonaRender = vgui.Create("DModelPanel",ply)
			-- ply.PersonaRender:SetPos(ScrW() -posX,ScrH() -posY)
			-- ply.PersonaRender:SetSize(len,height)
			-- ply.PersonaRender:SetModel(persona:GetModel())
			-- ply.PersonaRender:SetCamPos(Vector(100,100,300))
			-- ply.PersonaRender:SetLookAt(Vector(0,0,80))
			-- ply.PersonaRender:SetAnimated(true)
			-- function ply.PersonaRender:LayoutEntity(Entity)
				-- if (self.bAnimated) then
					-- self:RunAnimation()
				-- end
			-- end
		-- else
			-- ply.PersonaRender:SetAnimSpeed(persona:GetPlaybackRate())
			-- ply.PersonaRender:SetFOV(20)
			-- ply.PersonaRender:SetCamPos(Vector(120,60,90))
			-- ply.PersonaRender:SetLookAt(Vector(0,-20,180))
		-- end
		
		local sp = ply:GetSP()
		local target = ply:GetNWEntity("Persona_Target")

		local corners = 1
		local posX = GetConVarNumber("persona_hud_x") or 350
		local posY = GetConVarNumber("persona_hud_y") or 250
		local len = 325
		local height = 230
		local colM = 35
		local color = Color(colM,colM,colM,255)
		local boxX = posX
		local boxHeight = posY
		draw.RoundedBox(corners,ScrW() -posX,ScrH() -posY,len,height,color)
		
		-- local text = ply:GetPersonaName()
		-- local posX = 200
		-- local posY = 160
		-- local color = Color(200,0,255,255)
		-- draw.SimpleText(text,"Persona",ScrW() -posX,ScrH() -posY,color)

		-- local posX = 700
		-- local posY = 600
		-- local len = 600
		-- local height = 600
		-- surface.SetMaterial(Material("hud/persona/social/lavenza/main.png"))
		-- surface.SetDrawColor(Color(255,255,255,255))
		-- surface.DrawTexturedRect(ScrW() -posX,ScrH() -posY,len,height)
		-- local EposX = 575
		-- local EposY = 338
		-- local Elen = 300
		-- local Eheight = 150
		-- surface.SetMaterial(Material("hud/persona/social/lavenza/eyes2.png"))
		-- surface.SetDrawColor(Color(255,255,255,255))
		-- surface.DrawTexturedRect(ScrW() -EposX,ScrH() -EposY,Elen,Eheight)
		-- local MposX = 500
		-- local MposY = 185
		-- local Mlen = 150
		-- local Mheight = 80
		-- surface.SetMaterial(Material("hud/persona/social/lavenza/m2.png"))
		-- surface.SetDrawColor(Color(255,255,255,255))
		-- surface.DrawTexturedRect(ScrW() -MposX,ScrH() -MposY,Mlen,Mheight)
		
			--== SP ==--
		local text = "SP:"
		local posX = boxX -15
		local posY = boxHeight -5
		local color = Color(200,0,255,255)
		draw.SimpleText(text,"Persona",ScrW() -posX,ScrH() -posY,color)

		local text = sp
		local posX = boxX -75
		local posY = boxHeight -5
		local color = Color(200,0,255,255)
		draw.SimpleText(text,"Persona",ScrW() -posX,ScrH() -posY,color)

			--== Req. ==--
		local text = "Cost:"
		local usesHP = persona:GetNWBool("SpecialAttackUsesHP")
		local textF = usesHP && "HP " .. text or "SP " .. text
		local posX = boxX -15
		local posY = boxHeight -40
		local color = usesHP && Color(33,200,0,255) or Color(200,0,255,255)
		draw.SimpleText(textF,"Persona",ScrW() -posX,ScrH() -posY,color)

		local text = persona:GetNWInt("SpecialAttackCost")
		if usesHP then
			text = math.Round(ply:GetMaxHealth() *(text *0.01))
		end
		local posX = boxX -160
		local posY = boxHeight -40
		draw.SimpleText(text,"Persona",ScrW() -posX,ScrH() -posY,color)

		local text = "Skill Card"
		local posX = boxX -15
		local posY = boxHeight -75
		local color = Color(0,100,255,255)
		draw.SimpleText(text,"Persona",ScrW() -posX,ScrH() -posY,color)

		local text = persona:GetNWString("SpecialAttack")
		if text == nil or text == "" then text = "BLANK" end
		local posX = boxX -15
		local posY = boxHeight -110
		local color = Color(0,100,255,255)
		draw.SimpleText(text,"Persona",ScrW() -posX,ScrH() -posY,color)

		local icon = persona:GetNWString("SpecialAttackIcon")
		local matIcon = Material("hud/persona/png/hud_" .. icon .. ".png")
		local posX = boxX -192
		local posY = boxHeight -75
		local len = 100
		local height = 35
		surface.SetMaterial(matIcon)
		surface.SetDrawColor(Color(255,255,255,255))
		surface.DrawTexturedRect(ScrW() -posX,ScrH() -posY,len,height)

		local text = "Level"
		local posX = boxX -15
		local posY = boxHeight -150
		local color = Color(0,100,255,255)
		draw.SimpleText(text,"Persona",ScrW() -posX,ScrH() -posY,Color(200,0,0))

		local text = ply:GetNWInt("PXP_Level")
		local posX = boxX -110
		local posY = boxHeight -150
		local color = Color(0,100,255,255)
		draw.SimpleText(text,"Persona",ScrW() -posX,ScrH() -posY,Color(200,0,0))

		local text = "Req: " .. ply:GetNWInt("PXP_EXP") .. "/" .. ply:GetNWInt("PXP_RequiredEXP")
		local font = "PXP_EXP"
		local color = Color(200,0,0)
		local posX = boxX -15
		local posY = boxHeight -192
		if ply:GetNWInt("PXP_Level") == 99 then
			text = "MAX"
			font = "Persona"
			color = Color(200,0,255,255)
			posX = boxX -120
			posY = boxHeight -190
		end
		draw.SimpleText(text,font,ScrW() -posX,ScrH() -posY,color)

		if IsValid(target) then
			local icon = persona:GetNWString("SpecialAttackIcon")
			local matIcon = Material("hud/persona/crosshair")
			local posX = boxX -192
			local posY = boxHeight -75
			local size = 450
			local offset = 225
			-- local entPos = target:LocalToWorld(target:OBBMaxs()):ToScreen()
			local entPos = (target:GetPos() +target:OBBCenter()):ToScreen()
			surface.SetMaterial(matIcon)
			surface.SetDrawColor(Color(255,255,255,255))
			surface.DrawTexturedRect(entPos.x -offset,entPos.y -offset,size,size)

			local text = "Level " .. (tostring(target:GetNWInt("PXP_Level")) or "0")
			local offset = 100
			local color = Color(248,60,64,255)
			draw.SimpleText(text,"Persona",entPos.x -offset,entPos.y -offset -35,color)

			local text = "EXP " .. (tostring(target:GetNWInt("PXP_EXP")) or "0")
			local offset = 100
			local color = Color(248,60,64,255)
			draw.SimpleText(text,"Persona",entPos.x -offset,entPos.y -offset,color)
		end
	end)

	hook.Add("ShouldDrawLocalPlayer","Persona_DrawPlayer",function(ply)
		if IsValid(ply:GetNWEntity("PersonaEntity")) then return true end
	end)

	hook.Add("CalcView","Persona_ThirdPerson",function(ply,pos,angles,fov)
		local persona = ply:GetNWEntity("PersonaEntity")
		local cPos = ply:GetNWVector("Persona_CustomPos")
		local enabled = IsValid(persona)
		if enabled then
			if IsValid(ply:GetViewEntity()) && ply:GetViewEntity():GetClass() == "gmod_cameraprop" then
				return
			end
			local function Position(ply,origin,angles,dist,cPos)
				local allplayers = player.GetAll()
				local ePos = angles:Right() *30
				if cPos != Vector(0,0,0) && cPos != nil then
					ePos = angles:Forward() *cPos.y +angles:Right() *cPos.x +angles:Up() *cPos.z
				end
				local tr = util.TraceHull({
					start = origin,
					endpos = origin +angles:Forward() *-math.max(dist,ply:BoundingRadius()) +ePos,
					mask = MASK_SHOT,
					filter = allplayers,
					mins = Vector(-8,-8,-8),
					maxs = Vector(8,8,8)
				})
				return tr.HitPos +tr.HitNormal *5
			end

			local view = {}
			view.origin = Position(ply,pos,angles,40,cPos)
			view.angles = ply:EyeAngles()
			view.fov = fov
			return view
		end
	end)
end

local function ShowStats(ply)
	local persona = ply:GetPersona()
	if IsValid(persona) then
		local stats = persona.Stats
		ply:ChatPrint(persona.FeedName .. " Stats:")
		ply:ChatPrint("STR - " .. stats.STR)
		ply:ChatPrint("MAG - " .. stats.MAG)
		ply:ChatPrint("END - " .. stats.END)
		ply:ChatPrint("AGI - " .. stats.AGI)
		ply:ChatPrint("LUC - " .. stats.LUC)
	else
		ply:ChatPrint("Summon your Persona first!")
	end
	ply:EmitSound(Sound("cpthazama/persona4/ui_changepersona.wav"))
end
concommand.Add("persona_showstats",ShowStats)

local function MakeLegendary(ply)
	if PXP.GetLevel(ply) >= 99 && !PXP.IsLegendary(ply) && !PXP.IsVelvet(ply) then
		PXP.SetLegendary(ply)
		ply:EmitSound(Sound("cpthazama/persona4/ui_changepersona.wav"))
		ply:ChatPrint(PERSONA[ply:GetPersonaName()].Name .. " is now a Legendary Persona!")
		return
	end
	if PXP.IsLegendary(ply) then
		ply:ChatPrint(PERSONA[ply:GetPersonaName()].Name .. " is already a Legendary Persona!")
		return
	elseif PXP.IsVelvet(ply) then
		ply:ChatPrint("Velvet Personas can not evolve any further!")
		return
	else
		ply:ChatPrint(PERSONA[ply:GetPersonaName()].Name .. " must be a LVL 99 to become a Legendary Persona!")
		return
	end
end
concommand.Add("persona_legendary",MakeLegendary)

if CLIENT then
	hook.Add("AddToolMenuTabs","Persona_MainMenuIcon",function()
		spawnmenu.AddToolTab("Persona","Persona","vj_icons/persona16.png")
	end)
	hook.Add("PopulateToolMenu","Persona_MainMenu",function()
		spawnmenu.AddToolMenuOption("Persona","Main Settings","HUD","HUD","","",function(Panel)
			local DefaultBox = {Options = {},CVars = {},Label = "#Presets",MenuButton = "1",Folder = "Main Settings"}
			DefaultBox.Options["#Default"] = {
				persona_hud_x = "350",
				persona_hud_y = "250",
			}
			Panel:AddControl("ComboBox",DefaultBox)
			-- Panel:AddControl("Label",{Text = "Default: X = 350 Y = 250"})
			Panel:AddControl("Slider",{Label = "Box X Position",Command = "persona_hud_x",Min = 0,Max = 1920})
			Panel:AddControl("Slider",{Label = "Box Y Position",Command = "persona_hud_y",Min = 0,Max = 1080})
		end,{})

		spawnmenu.AddToolMenuOption("Persona","Persona","Commands","Commands","","",function(Panel)
			Panel:AddControl("Button",{Label = "Print Persona Stats",Command = "persona_showstats"})
			Panel:AddControl("Button",{Label = "Create Legendary Persona",Command = "persona_legendary"})
			Panel:AddControl("Label",{Text = "Persona must be LVL 99 to become Legendary!"})
		end,{})

		spawnmenu.AddToolMenuOption("Persona","Admin Settings","Cheats","Cheats","","",function(Panel)
			Panel:AddControl("TextBox",{Label = "Level",Command = "persona_i_setlevel",WaitForEnter = "1"})
			Panel:AddControl("Button",{Label = "Set Level",Command = "persona_setlevel"})

			Panel:AddControl("TextBox",{Label = "EXP",Command = "persona_i_setexp",WaitForEnter = "0"})
			Panel:AddControl("Button",{Label = "Set EXP",Command = "persona_setexp"})

			Panel:AddControl("Button",{Label = "Give Req. EXP",Command = "persona_giveexp"})

			Panel:AddControl("TextBox",{Label = "SP",Command = "persona_i_setsp",WaitForEnter = "1"})
			Panel:AddControl("Button",{Label = "Set SP",Command = "persona_setsp"})
		end,{})
	end)

	CreateClientConVar("persona_i_setlevel","1",false,false)
	CreateClientConVar("persona_i_setexp","0",false,false)
	CreateClientConVar("persona_i_setsp","1",false,false)
end

local function persona_setlevel(ply)
	if !ply:IsAdmin() or !ply:IsSuperAdmin() then return end
	PXP.SetLevel(ply,math.Clamp(GetConVarNumber("persona_i_setlevel"),1,99))
end
concommand.Add("persona_setlevel",persona_setlevel)

local function persona_setexp(ply)
	if !ply:IsAdmin() or !ply:IsSuperAdmin() then return end
	PXP.SetEXP(ply,GetConVarNumber("persona_i_setexp"))
end
concommand.Add("persona_setexp",persona_setexp)

local function persona_setsp(ply)
	if !ply:IsAdmin() or !ply:IsSuperAdmin() then return end
	local sp = GetConVarNumber("persona_i_setsp")
	ply:SetSP(sp)
	if sp > ply:GetMaxSP() then
		ply:SetMaxSP(sp)
	end
end
concommand.Add("persona_setsp",persona_setsp)

local function persona_giveexp(ply)
	if !ply:IsAdmin() or !ply:IsSuperAdmin() then return end
	PXP.GiveRequiredEXP(ply)
end
concommand.Add("persona_giveexp",persona_giveexp)

game.AddParticles("particles/magatsu_izanagi.pcf")

game.AddParticles("particles/jojo_aura.pcf")
local pParticleList = {
	"jojo_aura",
	"jojo_aura_act3",
	"jojo_aura_black",
	"jojo_aura_blue",
	"jojo_aura_blue_light",
	"jojo_aura_gold",
	"jojo_aura_green",
	"jojo_aura_killerqueen",
	"jojo_aura_orange",
	"jojo_aura_pink",
	"jojo_aura_purple",
	"jojo_aura_red",
	"jojo_aura_silver",
	"jojo_aura_yellow",
}
for _,v in ipairs(pParticleList) do PrecacheParticleSystem(v) end

game.AddParticles("particles/persona_fx.pcf")
local pParticleList = {
	"persona_fx_dmg_death",
	"persona_fx_dmg_elec",
	"persona_fx_dmg_fear",
	"persona_fx_dmg_ice",
	"persona_fx_dmg_miracle",
	"persona_fx_dmg_nuclear",
	"persona_fx_dmg_psi",
}
for _,v in ipairs(pParticleList) do PrecacheParticleSystem(v) end

game.AddParticles("particles/persona_support_fx.pcf")
local pParticleList = {
	"vj_per_skill_atk",
	"vj_per_skill_def",
	"vj_per_skill_evasion",
	"vj_per_skill_heatriser",
	"vj_per_idle_chains",
	"vj_per_idle_chains_evil",
	"vj_per_skill_bless",
	"vj_per_skill_bless_insta",
}
for _,v in ipairs(pParticleList) do PrecacheParticleSystem(v) end