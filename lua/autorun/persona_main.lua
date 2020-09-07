include("persona_xp.lua")

local debug = 1

local Persona_DMGMarkers = {}
local Persona_HUDEffects = {
	[1] = "hud/persona/png/ico_weak.png",
	[2] = "hud/persona/png/ico_resist.png",
	[3] = "hud/persona/png/ico_block.png",
	-- [4] = "hud/persona/png/ico_absorb.png",
	-- [5] = "hud/persona/png/ico_block.png",
	[6] = "hud/persona/png/ico_critical.png",
}

local function useMarkers()
	return GetConVarNumber("persona_hud_damage") == 1
end

if SERVER then
	util.AddNetworkString("persona_csound")
	util.AddNetworkString("persona_spawndmg")
	util.AddNetworkString("persona_party")
end

if CLIENT then
	CreateClientConVar("persona_hud_x","350",false,false)
	CreateClientConVar("persona_hud_y","250",false,false)
	CreateClientConVar("persona_hud_damage","1",false,false)

	net.Receive("persona_csound",function(len,pl)
		local ply = net.ReadEntity()
		local snd = net.ReadString()
		local vol = net.ReadFloat()
		local pit = net.ReadFloat()

		ply:EmitSound(snd,vol,pit)
	end)

	local function SpawnMarker(text,col,pos,vel,dmg,bonus)
		if !useMarkers() then return end
		
		local split = string.Split(text,"")
		-- for i = 1,#split do
			local marker = {}
			marker.text = text
			-- marker.text = split[i]
			marker.numbers = split
			marker.effects = bonus
			marker.initialized = false
			marker.pos = Vector(pos.x,pos.y,pos.z)
			marker.vel = Vector(vel.x,vel.y,vel.z)
			marker.col = Color(col.r,col.g,col.b)
			marker.duration = 1.5
			marker.dmg = dmg
			marker.spawntime = CurTime()
			marker.deathtime = CurTime() +1.5

			surface.SetFont("Persona")
			local w,h = surface.GetTextSize(text)

			marker.widthH = w /2
			marker.heightH = h /2

			table.insert(Persona_DMGMarkers,marker)
		-- end
	end

	net.Receive("persona_spawndmg",function()
		if !useMarkers() then return end

		local dmg = net.ReadFloat()
		dmg = dmg < 1 && math.Round(dmg,3) or math.floor(dmg)
		local dmgtype = net.ReadUInt(32)
		local crit = (net.ReadBit() ~= 0)
		local pos = net.ReadVector()
		local force = net.ReadVector()
		local col = crit && Color(255,255,0) or net.ReadVector()
		local bonus = net.ReadFloat() or 0
		if bonus == 0 && crit then
			bonus = 6
		end

		SpawnMarker(tostring(math.abs(dmg)),col,pos,force +Vector(math.Rand(-1,1),math.Rand(-1,1),math.Rand(0,1) *1.5),dmg,bonus)
	end)

	hook.Add("Tick","Persona_CleanMarkers",function()		
		local Cur = CurTime()
		if #Persona_DMGMarkers == 0 then return end

		local marker
		for i=1,#Persona_DMGMarkers do
			marker = Persona_DMGMarkers[i]
			marker.pos = marker.pos +Vector(0,0,0.6)
		end

		local i = 1
		while i <= #Persona_DMGMarkers do
			if Persona_DMGMarkers[i].deathtime < Cur then
				table.remove(Persona_DMGMarkers,i)
			else
				i = i +1
			end
		end
	end)

	hook.Add("PostDrawTranslucentRenderables","Persona_DrawMarkers",function()
		if #Persona_DMGMarkers == 0 then return end

		local ply = (LocalPlayer():GetViewEntity() or LocalPlayer())
		local ang = ply:EyeAngles()
		ang:RotateAroundAxis(ang:Forward(),90)
		ang:RotateAroundAxis(ang:Right(),90)
		ang = Angle(0,ang.y,ang.r)
		local scale = 0.0045
		local alphamul = 255

		local marker
		for i=1,#Persona_DMGMarkers do
		-- for _,marker in  pairs(Persona_DMGMarkers) do
			marker = Persona_DMGMarkers[i]
			scale = math.Clamp(scale *marker.dmg,5,12)
			local pos = (marker.pos):ToScreen()
			local offsetX = 0
			cam.Start3D2D(marker.pos,ang,3)
				local ran = marker.initialized
				if !ran then
					marker.initialized = true
				end
				if marker.dmg > 999999999 then
					draw.SimpleText("PLUS ULTRA!","PXP_EXP",0,-scale *2,Color(marker.col.r,marker.col.g,marker.col.b,((CurTime() -marker.spawntime /marker.duration) *alphamul)))
				end
				for _,num in pairs(marker.numbers) do
					offsetX = offsetX +scale -(scale /4.25)
					surface.SetMaterial(Material("hud/persona/dmg/".. num .. ".png"))
					surface.SetDrawColor(marker.col.r,marker.col.g,marker.col.b,((CurTime() -marker.spawntime /marker.duration) *alphamul))
					surface.DrawTexturedRect(offsetX,0,scale,scale)
				end
				if marker.effects && Persona_HUDEffects[marker.effects] then
					surface.SetMaterial(Material(Persona_HUDEffects[marker.effects]))
					surface.SetDrawColor(255,255,255,((CurTime() -marker.spawntime /marker.duration) *alphamul))
					surface.DrawTexturedRect(scale,scale,offsetX,scale)
				end
			cam.End3D2D()
		end
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
		if self.SoundTbl_Persona then
			VJ_CreateSound(self,self.SoundTbl_Persona,80,100)
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
		
		if ply:IsBot() && debug == 1 then
			ply:SetPersona("izanagi")
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
			summon_persona(ply)
			-- ply:ConCommand("summon_persona")
		end
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

	local function SpawnMarker_SV(dmgAmount,dmgType,dmgPosition,dmgForce,isCrit,color,flag)
		if !useMarkers() then return end
		local col = Vector(color.r,color.g,color.b)
		net.Start("persona_spawndmg",true)
			net.WriteFloat(dmgAmount)
			net.WriteUInt(dmgType,32)
			net.WriteBit(isCrit)
			net.WriteVector(dmgPosition)
			net.WriteVector(dmgForce)
			net.WriteVector(col)
			net.WriteFloat(flag)
		net.Broadcast()
	end

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
			
			if IsValid(attacker) && (attacker:IsNPC() or attacker:IsPlayer()) && IsValid(attacker:GetPersona()) && useMarkers() then
				local color = Color(0,161,255)
				local bonus = 0
				if IsValid(persona) then
					local stats = persona.Stats
					local weak = stats.WK
					local resist = stats.RES
					local block = stats.NUL
					local absorb = stats.ABS
					local reflect = stats.REF
					
					if VJ_HasValue(weak,dmgtype) then
						color = Color(255,0,0)
						bonus = 1
					end
					if VJ_HasValue(resist,dmgtype) then
						color = Color(110,0,0)
						bonus = 2
					end
					if VJ_HasValue(block,dmgtype) then
						color = Color(255,255,255)
						bonus = 3
					end
					if VJ_HasValue(absorb,dmgtype) then
						color = Color(95,63,127)
						bonus = 4
					end
					if VJ_HasValue(reflect,dmgtype) then
						color = Color(127,255,255)
						bonus = 5
					end
				end
				SpawnMarker_SV(dmg,dmgtype,dmginfo:GetDamagePosition(),dmginfo:GetDamageForce(),attacker:GetPersona():GetCritical() or false,color,bonus)
			end

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

	surface.CreateFont("Persona_Small",{
		font = "p5hatty",
		extended = false,
		size = 22,
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

		-- if #Persona_DMGMarkers > 0 then
			-- local marker
			-- local scale = 0.0045
			-- for i=1,#Persona_DMGMarkers do
				-- marker = Persona_DMGMarkers[i]
				-- scale = math.Clamp(scale *marker.dmg,0.5,3)
				-- local pos = (marker.pos):ToScreen()
				-- local offsetX = 100
				-- local offsetY = 100
				-- local ran = marker.initialized
				-- if !ran then
					-- marker.initialized = true
					-- marker.activenums = {}
				-- end
				-- if #marker.activenums < #marker.numbers then
					-- for _,num in pairs(marker.numbers) do
						-- offsetX = offsetX +scale *15
						-- surface.SetMaterial(Material("hud/persona/dmg/".. marker.text .. ".png"))
						-- surface.SetDrawColor(Color(255,255,255,255))
						-- surface.DrawTexturedRect(pos.x -offsetX,pos.y -offsetY,50,50)
					-- end
				-- end
			-- end
		-- end
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
				persona_hud_damage = "1",
			}
			Panel:AddControl("ComboBox",DefaultBox)
			Panel:AddControl("Slider",{Label = "Box X Position",Command = "persona_hud_x",Min = 0,Max = 1920})
			Panel:AddControl("Slider",{Label = "Box Y Position",Command = "persona_hud_y",Min = 0,Max = 1080})
			Panel:AddControl("CheckBox",{Label = "Enable Damage Markers",Command = "persona_hud_damage"})
		end,{})

		spawnmenu.AddToolMenuOption("Persona","Persona","Commands","Commands","","",function(Panel)
			Panel:AddControl("Button",{Label = "Print Persona Stats",Command = "persona_showstats"})
			Panel:AddControl("Button",{Label = "Create Legendary Persona",Command = "persona_legendary"})
			Panel:AddControl("Label",{Text = "Persona must be LVL 99 to become Legendary!"})
		end,{})

		spawnmenu.AddToolMenuOption("Persona","Party","Set-Up","Set-Up","","",function(Panel)
			Panel:AddControl("Button",{Label = "Add To Party",Command = "persona_party"})
			Panel:AddControl("Button",{Label = "Remove From Party",Command = "persona_partyremove"})
			Panel:AddControl("Button",{Label = "Disband Party",Command = "persona_partyclear"})
			Panel:AddControl("Label",{Text = "Must be looking at a Player to add/remove them!"})
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
	if ply:IsAdmin() or ply:IsSuperAdmin() then
		PXP.SetLevel(ply,math.Clamp(GetConVarNumber("persona_i_setlevel"),1,99))
	end
end
concommand.Add("persona_setlevel",persona_setlevel)

local function persona_setexp(ply)
	if ply:IsAdmin() or ply:IsSuperAdmin() then
		PXP.SetEXP(ply,GetConVarNumber("persona_i_setexp"))
	end
end
concommand.Add("persona_setexp",persona_setexp)

local function persona_setsp(ply)
	if ply:IsAdmin() or ply:IsSuperAdmin() then
		local sp = GetConVarNumber("persona_i_setsp")
		ply:SetSP(sp)
		if sp > ply:GetMaxSP() then
			ply:SetMaxSP(sp)
		end
	end
end
concommand.Add("persona_setsp",persona_setsp)

local function persona_giveexp(ply)
	if ply:IsAdmin() or ply:IsSuperAdmin() then
		PXP.GiveRequiredEXP(ply)
	end
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