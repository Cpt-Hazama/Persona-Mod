include("persona_xp.lua")

local debug = 0

function PGM()
	return gmod.GetGamemode()
end

function IsPersonaGamemode()
	return PGM().Name == "Persona"
end

local File = FindMetaTable("File")

function File:QuickRead(position)
	local text = self:Read(3)
	self:Seek(0)
	return text
end

-- function PGM_B()
	-- local f = file.Open("sound/cpthazama/persona_resource/music/Awakening.mp3","rb","GAME")
	-- for i = 1,8192 do
		-- local uShort = f:ReadUShort()
		-- print("Unassigned 16bit Int - " .. uShort)
		-- print("Pointer Position - " .. tostring(f:Tell()))
	-- end
	-- f:Close()
-- end

function PGM_T()
	local pos = Vector(-2923.764648,-6386.504883,364.3)
	local e = ents.Create("prop_vj_animatable")
	e:SetModel("models/cpthazama/persona5/maps/velvetroom_battle.mdl")
	e:SetPos(pos)
	e:Spawn()
	e:SetCollisionGroup(COLLISION_GROUP_IN_VEHICLE)
end

function PGM_S()
	local ent = Entity(1):GetEyeTrace().Entity
	ent:SetModelScale(ent:GetModelScale() +0.5,0)
end

function PGM_D()
	local tbl = {}
	local ent = Entity(1):GetEyeTrace().Entity
	tbl.Model = ent:GetModel()
	local ePos = ent:GetPos()
	tbl.Pos = "Vector(" .. ePos[1] .. "," .. ePos[2] .. "," .. ePos[3] .. ")"
	local ang = ent:GetAngles()
	if tostring(ang[1]) == "1.3911635221575e-07" then
		ang[1] = 0
	end
	ang[1] = math.Round(ang[1],3)
	ang[2] = math.Round(ang[2],3)
	ang[3] = math.Round(ang[3],3)
	tbl.Ang = "Angle(" .. ang[1] .."," .. ang[2] .."," .. ang[3] .. ")"
	tbl.Scale = ent:GetModelScale()
	PrintTable(tbl)
end

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
	util.AddNetworkString("persona_party_npc")
end

if CLIENT then
	CreateClientConVar("persona_hud_x","350",false,false)
	CreateClientConVar("persona_hud_y","350",false,false)
	CreateClientConVar("persona_hud_damage","1",false,false)
	CreateClientConVar("persona_hud_raidboss","0",false,false)
	-- CreateClientConVar("vj_persona_dancemode","0",false,false)
	-- CreateClientConVar("vj_persona_dancedifficulty","2",false,false)

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
	-- return self:GetNW2Bool("PersonaUser") or false
	return true
end

function PLY:SetPersona(persona)
	-- self:SetNW2Bool("PersonaUser",true)
	self:SetNW2String("PersonaName",persona)
end

function PLY:SetSP(sp)
	self:SetNW2Int("Persona_SP",sp)
end

function PLY:SetMaxSP(spm)
	self:SetNW2Int("Persona_SPMax",spm)
end

function PLY:GetSP()
	return self:GetNW2Int("Persona_SP")
end

function PLY:GetMaxSP()
	return self:GetNW2Int("Persona_SPMax")
end

function PLY:GetPersonaName()
	return self:GetNW2String("PersonaName")
end

function PLY:SetPersonaEntity(ent)
	self:SetNW2Entity("Persona",ent)
end

function PLY:GetPersona()
	return self:GetNW2Entity("Persona")
end

function PLY:SetMaxHealth(mhp)
	self:SetNW2Int("MaxHealth",mhp)
end

function PLY:GetMaxHealth()
	return self:GetNW2Int("MaxHealth")
end

function PLY:GetNextPersonaSummonT()
	return self:GetNW2Int("PersonaSummonT") or 0
end

function PLY:SetNextPersonaSummonT(t)
	self:SetNW2Int("PersonaSummonT",CurTime() +t)
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
	return self:GetNW2Entity("PersonaEntity")
end

function NPC:SetPersonaEntity(ent,name)
	self:SetNW2Entity("PersonaEntity",ent)
	self:SetNW2String("PersonaName",name)
	ent.User = self
end

function NPC:GetPersonaName()
	return self:GetNW2String("PersonaName")
end

function NPC:SetSP(sp)
	self:SetNW2Int("Persona_SP",sp)
end

function NPC:SetMaxSP(spm)
	self:SetNW2Int("Persona_SPMax",spm)
end

function NPC:GetSP()
	return self:GetNW2Int("Persona_SP")
end

function NPC:GetMaxSP()
	return self:GetNW2Int("Persona_SPMax")
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
			if self.UpdateCamera then
				self:UpdateCamera(2)
			end
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
	
	ply.Persona_TarukajaT = 0 -- Inc. ATK
	ply.Persona_TarundaT = 0 -- Dec. ATK
	ply.Persona_RakukajaT = 0 -- Inc. DEF
	ply.Persona_RakundaT = 0 -- Dec. DEF
	ply.Persona_SukukajaT = 0 -- Inc. AGI
	ply.Persona_SukundaT = 0 -- Dec. AGI

	ply.Persona_DebilitateT = 0
	ply.Persona_HeatRiserT = 0
	ply.Persona_ChaosT = 0
	ply.Persona_ChargedT = 0
	ply.Persona_FocusedT = 0
end)

if SERVER then
	hook.Add("PlayerSpawn","Persona_Spawn",function(ply)
		ply:SetSP(ply:GetMaxSP() or (ply:IsSuperAdmin() && 999 or ply:IsAdmin() && 350 or 150))
		ply:SetMaxSP(ply:GetSP())
		timer.Simple(0,function()
			if IsValid(ply) then
				ply:SetHealth(ply.Persona_MaxHealth)
			end
		end)
		ply.PXP_NextXPChange = CurTime()

		ply.Persona_TarukajaT = 0 -- Inc. ATK
		ply.Persona_TarundaT = 0 -- Dec. ATK
		ply.Persona_RakukajaT = 0 -- Inc. DEF
		ply.Persona_RakundaT = 0 -- Dec. DEF
		ply.Persona_SukukajaT = 0 -- Inc. AGI
		ply.Persona_SukundaT = 0 -- Dec. AGI

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
						ply:SetNW2Entity("PersonaEntity",ent)
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
					ent.Persona_TarukajaT = 0 -- Inc. ATK
					ent.Persona_TarundaT = 0 -- Dec. ATK
					ent.Persona_RakukajaT = 0 -- Inc. DEF
					ent.Persona_RakundaT = 0 -- Dec. DEF
					ent.Persona_SukukajaT = 0 -- Inc. AGI
					ent.Persona_SukundaT = 0 -- Dec. AGI

					ent.Persona_DebilitateT = 0
					ent.Persona_HeatRiserT = 0
					ent.Persona_ChaosT = 0
					ent.Persona_ChargedT = 0
					ent.Persona_FocusedT = 0
					local mLevel = ent:GetNW2Int("PXP_Level") or (ent.Stats && ent.Stats.LVL) or nil
					if mLevel == nil or mLevel == 0 then
						local ply = VJ_PICK(player.GetAll())
						local pLevel = 1
						if IsValid(ply) then
							pLevel = PXP.GetLevel(ply)
						end
						local gLevel = math.Round(((ent:GetMaxHealth() /800) *pLevel))
						local level = math.Clamp(math.random(math.Clamp(gLevel -10,1,99),math.Clamp(gLevel +10,1,99)),1,99)
						local exp = math.Round(((ent:GetMaxHealth() /50) *level))
						ent:SetNW2Int("PXP_Level",level)
						ent:SetNW2Int("PXP_EXP",exp *math.random(2,20))
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
				ply:SetNW2Entity("PersonaEntity",ent)
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
	
	local function HSL(h,s,l)
		h = h %256
		if s == 0 then 
			return Color(l,l,l)
		end
		h, s, l = h /256 *6, s /255, l /255
		local c = (1 -math.abs(2 *l -1)) *s
		local x = (1 - math.abs(h %2 -1)) *c
		local m, r, g, b = (l -0.5 *c),0,0,0
		if h < 1 then 
			r,g,b = c,x,0
		elseif h < 2 then
			r,g,b = x,c,0
		elseif h < 3 then
			r,g,b = 0,c,x
		elseif h < 4 then
			r,g,b = 0,x,c
		elseif h < 5 then
			r,g,b = x,0,c
		else
			r,g,b = c,0,x
		end
		return Color(math.ceil((r +m) *256),math.ceil((g +m) *256),math.ceil((b +m) *256))
	end

	local lerp_hp = 0
	local calc_hp = 0
	local lerp_e_hp = 0
	local calc_e_hp = 0
	local lerp_sp = 0
	local calc_sp = 0
	local lerp_xp = 0
	local calc_xp = 0
	local lerp_skill_cost = 0
	local lerp_req = 0
	local types = {
		["hud_almighty"] = "Almighty",
		["hud_automatic"] = "Automatic",
		["hud_bless"] = "Bless",
		["hud_curse"] = "Curse",
		["hud_elec"] = "Electric",
		["hud_fire"] = "Fire",
		["hud_frost"] = "Ice",
		["hud_gun"] = "Gun",
		["hud_heal"] = "Healing",
		["hud_necro"] = "Support",
		["hud_nuclear"] = "Nuclear",
		["hud_passive"] = "Passive",
		["hud_phys"] = "Physical",
		["hud_psi"] = "Psychokinesis",
		["hud_sleep"] = "Physiological",
		["hud_wind"] = "Wind",
		["hud_unknown"] = "Unknown"
	}
	local color = Color
	hook.Add("HUDPaint","Persona_HUD",function()
		local ply = LocalPlayer()
		local persona = ply:GetNW2Entity("PersonaEntity")

		if !IsValid(persona) then
			if ply.PersonaRender then
				ply.PersonaRender:Remove()
			end
			if ply.PersonaRenderBackground then
				ply.PersonaRenderBackground:Remove()
			end
			return
		end

		local hp = ply:Health()
		local hpMax = ply:GetMaxHealth()
		local sp = ply:GetSP()
		local spMax = ply:GetMaxSP()
		local target = ply:GetNW2Entity("Persona_Target")
		local usesHP = persona:GetNW2Bool("SpecialAttackUsesHP")
		local cost = persona:GetNW2Int("SpecialAttackCost")
		local skillName = persona:GetNW2String("SpecialAttack")
		local skillIcon = persona:GetNW2String("SpecialAttackIcon")
		local lvl = ply:GetNW2Int("PXP_Level")
		local xp = ply:GetNW2Int("PXP_EXP")
		local req_xp = ply:GetNW2Int("PXP_RequiredEXP")

		local corners = 1
		local posX = GetConVarNumber("persona_hud_x") or 350
		local posY = GetConVarNumber("persona_hud_y") or 350
		local len = 325
		local height = 330
		local colM = 35
		local bColor = color(colM,colM,colM,255)
		local boxX = posX
		local boxHeight = posY
		draw.RoundedBox(corners,ScrW() -posX,ScrH() -posY,len,height,bColor)

		local perHP = (hp -cost) /hpMax
		local perSP = (sp -cost) /spMax
		local perXP = (req_xp -xp) /req_xp
		lerp_hp = Lerp(5 *FrameTime(), lerp_hp, hp)
		lerp_sp = Lerp(5 *FrameTime(), lerp_sp, sp)
		calc_hp = Lerp(5 *FrameTime(), calc_hp, perHP)
		calc_sp = Lerp(5 *FrameTime(), calc_sp, perSP)
		lerp_xp = Lerp(5 *FrameTime(), lerp_xp, xp)
		calc_xp = Lerp(5 *FrameTime(), calc_xp, perXP)
		local perHPB = lerp_hp *100 /hpMax
		local perSPB = lerp_sp *100 /spMax

		local r,g,b = 255, 101, 239
		if usesHP then
			r,g,b = 107, 255, 222
		end
		local posX = boxX -10
		local posY = boxHeight -80
		local len = boxX -45
		local height = 20

		// SP Bar
		draw.RoundedBox(corners, ScrW() -posX, ScrH() -posY, len, height, color(0, 0, 0, 150))
		draw.RoundedBox(corners, ScrW() -posX, ScrH() -posY, math.Clamp((usesHP && perHPB or perSPB) *0.01 *len,0,len), height, color(r, g, b, 255))

		// SP Requirement Bar
		r,g,b = 255, 0, 0
		draw.RoundedBox(corners, ScrW() -posX, ScrH() -posY, math.Clamp(len *(usesHP && calc_hp or calc_sp),0,999999999), height, color(r, g, b, math.abs(math.sin(CurTime() *2.25) *255)))

		r,g,b = 255, 101, 239
		if usesHP then
			r,g,b = 107, 255, 222
		end
		
		// HP/SP Text
		local min,max = usesHP && hp or sp, usesHP && hpMax or spMax
		local text = (usesHP && "HP: " or "SP: ") .. min .. "/" .. max
		local posX = boxX -10
		local posY = boxHeight -10
		draw.SimpleText(text,"Persona",ScrW() -posX,ScrH() -posY,color(r, g, b, 255))

		// HP/SP Cost Text
		local text = "Cost: " .. cost
		local posX = boxX -10
		local posY = boxHeight -40
		draw.SimpleText(text,"Persona",ScrW() -posX,ScrH() -posY,color(r, g, b, 255))

		// Skill Card Text
		local text = skillName
		if text == nil or text == "" then text = "BLANK" end
		local posX = boxX -10
		local posY = boxHeight -112
		draw.SimpleText(text,"Persona",ScrW() -posX,ScrH() -posY,color(r, g, b, 255))

		// Skill Card Icon Text
		local text = types["hud_" .. skillIcon]
		local posX = boxX -10
		local posY = boxHeight -150
		-- draw.SimpleText(text,"Persona",ScrW() -posX,ScrH() -posY,color(r, g, b, 255))
		surface.SetTextColor(r, g, b)
		surface.SetTextPos(ScrW() -posX,ScrH() -posY)
		surface.SetFont("Persona")
		surface.DrawText(text)

		// Skill Card Icon
		local icon = skillIcon
		local matIcon = Material("hud/persona/png/hud_" .. icon .. ".png")
		local posX = boxX -15 -surface.GetTextSize(text)
		local posY = boxHeight -148
		local len = 100
		local height = 35
		surface.SetMaterial(matIcon)
		surface.SetDrawColor(Color(255,255,255,255))
		surface.DrawTexturedRect(ScrW() -posX,ScrH() -posY,len,height)

		// Level Text
		r,g,b = 200, 0, 0
		local text = "Level " .. lvl
		local posX = boxX -90
		local posY = boxHeight -205
		local canShowXP = true
		if lvl == 99 then
			text = "MAX"
			local rgb = HSL((RealTime() *150 -(0 *15)),128,128)
			r,g,b = rgb.r, rgb.g, rgb.b
			posX = boxX -110
			canShowXP = false
		end
		draw.SimpleText(text,"Persona",ScrW() -posX,ScrH() -posY,color(r, g, b, 255))

		// EXP Text
		r,g,b = 200, 0, 0
		local text = canShowXP && "Req: " .. xp .. "/" .. req_xp or "Req: N/A"
		local posX = canShowXP && boxX -37.5 or boxX -95
		local posY = boxHeight -250
		draw.SimpleText(text,"PXP_EXP",ScrW() -posX,ScrH() -posY,color(r, g, b, 255))
		
		// EXP Bar
		local r,g,b = 200, 0, 0
		if math.Round(lerp_xp) != xp then
			local rgb = HSL((RealTime() *200 -(0 *15)),128,128)
			r,g,b = rgb.r, rgb.g, rgb.b
		end
		local posX = boxX -10
		local posY = boxHeight -290
		local len = boxX -45
		local height = 30
		draw.RoundedBox(corners, ScrW() -posX, ScrH() -posY, len, height, color(0, 0, 0, 150))
		draw.RoundedBox(corners, ScrW() -posX, ScrH() -posY, math.Clamp(len -(calc_xp *len),0,len), height, color(r, g, b, 255))

		if IsValid(target) then
			local len = 200
			local height = 100
			local bColor = color(colM,colM,colM,230)

			local hp = ply:GetNW2Int("Persona_TargetHealth") or target:Health()
			local hpMax = target:GetMaxHealth()
			local perHP = (hp -cost) /hpMax
			lerp_e_hp = Lerp(5 *FrameTime(), lerp_e_hp, hp)
			calc_e_hp = Lerp(5 *FrameTime(), calc_e_hp, perHP)
			local perHPB = lerp_e_hp *100 /hpMax
			
			local icon = persona:GetNW2String("SpecialAttackIcon")
			local matIcon = Material("hud/persona/crosshair")
			local offset = 225
			local entPos = (target:GetPos() +target:OBBCenter()):ToScreen()
			surface.SetMaterial(matIcon)
			surface.SetDrawColor(color(255,255,255,255))
			surface.DrawTexturedRect(entPos.x -offset,entPos.y -offset,450,450)

			local boxX = entPos.x -offset -35
			local boxY = entPos.y -offset -35
			draw.RoundedBox(corners,boxX,boxY,len,height,bColor)

			local r,g,b = 107, 255, 222
			local posX = boxX +5
			local posY = boxY +5
			local nlen = len -10
			local height = 20
			local f = math.Clamp(perHPB *0.01 *nlen,0,nlen)

			draw.RoundedBox(corners, posX, posY, nlen, height, color(0, 0, 0, 150))
			draw.RoundedBox(corners, posX, posY, f, height, color(r, g, b, 255))

			local text = "Level " .. (tostring(target:GetNW2Int("PXP_Level")) or "0")
			draw.SimpleText(text,"Persona",boxX +5,boxY +30,color(248,60,64,255))

			local text = (tostring(target:GetNW2Int("PXP_EXP")) or "0") .. " EXP"
			draw.SimpleText(text,"PXP_EXP",boxX +5,boxY +70,color(248,60,64,255))
		end
	end)

	hook.Add("ShouldDrawLocalPlayer","Persona_DrawPlayer",function(ply)
		if IsPersonaGamemode() then return end
		if IsValid(ply:GetNW2Entity("PersonaEntity")) then return true end
	end)

	local P_LerpVec = Vector(0,0,0)
	local P_LerpAng = Angle(0,0,0)
	hook.Add("CalcView","Persona_ThirdPerson",function(ply,pos,angles,fov)
		local persona = ply:GetNW2Entity("PersonaEntity")
		local cPos = ply:GetNW2Vector("Persona_CustomPos")
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

			pos = Position(ply,pos,angles,40,cPos)
			P_LerpVec = LerpVector(FrameTime() *15,P_LerpVec,pos)
			P_LerpAng = LerpAngle(FrameTime() *15,P_LerpAng,ply:EyeAngles())

			local view = {}
			view.origin = P_LerpVec
			view.angles = P_LerpAng
			view.fov = fov
			return view
		end
	end)
end

function VJ_PlaySound(argent,sound,soundlevel,soundpitch,stoplatestsound,sounddsp)
	if not sound then return end
	if istable(sound) then
		if #sound < 1 then return end -- If the table is empty then end it
		sound = sound[math.random(1,#sound)]
	end
	/*if stoplatestsound == true then -- If stopsounds is true, then the current sound
		//if argent.CurrentSound then argent.CurrentSound:Stop() end
		if soundid then
			soundid:Stop()
			soundid = nil
		end
	end*/
	//print(sound)
	soundid = CreateSound(argent, sound)
	soundid:SetSoundLevel(soundlevel or 75)
	soundid:PlayEx(1,soundpitch or 100)
	if sounddsp then -- For modulation, like helmets(?)
		soundid:SetDSP(sounddsp)
	end
	argent.LastPlayedVJSound = soundid
	if argent.IsVJBaseSNPC == true then argent:OnPlayCreateSound(soundid,sound) end
	local tbl = {soundid,sound}
	return tbl
end

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