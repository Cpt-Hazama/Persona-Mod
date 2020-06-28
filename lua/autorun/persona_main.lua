DMG_P_ICE = 1000
DMG_P_EARTH = 1001
DMG_P_WIND = 1002
DMG_P_GRAVITY = 1003
DMG_P_NUCLEAR = 1004
DMG_P_EXPEL = 1005
DMG_P_DEATH = 1006
DMG_P_MIRACLE = 1007
DMG_P_FORCE = 1008
DMG_P_TECH = 1009
DMG_P_ALMIGHTY = 1010
DMG_P_PSI = 1011
DMG_P_ELEC = 1012
DMG_P_CURSE = 1013
DMG_P_FEAR = 1014
DMG_P_PHYS = 1015

if SERVER then
	util.AddNetworkString("persona_csound")
end

if CLIENT then
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

function NPC:SetPersonaEntity(ent)
	self:SetNWEntity("PersonaEntity",ent)
	ent.User = self
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
	if !IsValid(personaEntity) then
		local class = "prop_persona_" .. persona
		local ent = ents.Create(class)
		ent:SetModel(ent.Model)
		ent:SetPos(ent:GetSpawnPosition(self) or self:GetPos())
		ent:SetAngles(self:GetAngles())
		ent:Spawn()
		self:SetPersonaEntity(ent)
		ent:RequestAura(ent,ent.Aura)
		ent.User = self
		-- ent.Persona = self:GetPersonaName()
		ent:DoIdle()
		ent:OnSummoned(self)
		ent:SetFeedName(ent.Name,class)
	else
		if !personaEntity.IsFlinching then
			personaEntity:SetTask("TASK_RETURN")
			personaEntity:OnRequestDisappear(self)
		end
	end
end

if SERVER then
	hook.Add("PlayerSpawn","Persona_Spawn",function(ply)
		ply:SetSP(ply:IsSuperAdmin() && 999 or ply:IsAdmin() && 350 or 150)
		ply:SetMaxSP(ply:GetSP())
		ply:SetMaxHealth(100)
	end)

	local wep = "weapon_jojo_nothing"
	hook.Add("Think","Persona_Think",function()
		for _,v in pairs(player.GetAll()) do
			if v:Health() > v:GetMaxHealth() then
				v:SetMaxHealth(v:Health())
			end
			if v:GetSP() > v:GetMaxSP() then
				v:SetMaxSP(v:GetSP())
			end
			if IsValid(v:GetPersona()) then
				if !v:HasWeapon(wep) then
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
			dmginfo:ScaleDamage(1.6)
		end
		if ent:IsPlayer() then
			local dmgtype = dmginfo:GetDamageType()
			local dmg = dmginfo:GetDamage()
			local persona = ent:GetPersona()

			if IsValid(persona) && persona.HandleDamage then
				return persona:HandleDamage(dmg,dmgtype,dmginfo)
			end
		end
		-- return true -- Prevents all damage
	end)

	local function summon_persona(ply)
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
			else
				if !persona.IsFlinching then
					persona:SetTask("TASK_RETURN")
					persona:OnRequestDisappear(ply)
				end
			end
		end
	end
	concommand.Add("summon_persona",summon_persona)
end

if CLIENT then
	surface.CreateFont("Persona",{
		font = "Trebuchet24",
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

		local corners = 1
		local posX = 250
		local posY = 170
		local len = 225
		local height = 140
		local color = Color(50,50,50,255)
		local boxX = posX
		local boxHeight = posY
		draw.RoundedBox(corners,ScrW() -posX,ScrH() -posY,len,height,color)
		
		-- local text = ply:GetPersonaName()
		-- local posX = 200
		-- local posY = 160
		-- local color = Color(200,0,255,255)
		-- draw.SimpleText(text,"Persona",ScrW() -posX,ScrH() -posY,color)
		
			--== SP ==--
		local text = "SP:"
		local posX = boxX -15
		local posY = boxHeight
		local color = Color(200,0,255,255)
		draw.SimpleText(text,"Persona",ScrW() -posX,ScrH() -posY,color)
		
		local text = sp
		local posX = boxX -65
		local posY = boxHeight
		local color = Color(200,0,255,255)
		draw.SimpleText(text,"Persona",ScrW() -posX,ScrH() -posY,color)
		
			--== Req. ==--
		local text = "Cost:"
		local usesHP = persona:GetNWBool("SpecialAttackUsesHP")
		local textF = usesHP && "HP " .. text or "SP " .. text
		local posX = boxX -15
		local posY = boxHeight -35
		local color = usesHP && Color(33,200,0,255) or Color(200,0,255,255)
		draw.SimpleText(textF,"Persona",ScrW() -posX,ScrH() -posY,color)
		
		local text = persona:GetNWInt("SpecialAttackCost")
		local posX = boxX -130
		local posY = boxHeight -35
		draw.SimpleText(text,"Persona",ScrW() -posX,ScrH() -posY,color)
		
		local text = "Persona Card:"
		local posX = boxX -15
		local posY = boxHeight -65
		local color = Color(0,100,255,255)
		draw.SimpleText(text,"Persona",ScrW() -posX,ScrH() -posY,color)
		
		local text = persona:GetNWString("SpecialAttack")
		if text == nil or text == "" then text = "N/A" end
		local posX = boxX -15
		local posY = boxHeight -100
		local color = Color(0,100,255,255)
		draw.SimpleText(text,"Persona",ScrW() -posX,ScrH() -posY,color)
	end)

	hook.Add("ShouldDrawLocalPlayer","Persona_DrawPlayer",function(ply)
		if IsValid(ply:GetNWEntity("PersonaEntity")) then return true end
	end)

	hook.Add("CalcView","Persona_ThirdPerson",function(ply,pos,angles,fov)
		local persona = ply:GetNWEntity("PersonaEntity")
		local cPos = ply:GetNWVector("Persona_CustomPos")
		local enabled = IsValid(persona)
		if enabled then
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