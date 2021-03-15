include("persona_xp.lua")

local debug = 0

CreateConVar("persona_dmg_scaling","1",128,"Toggles the damage scaling feature of the mod.",0,1)
CreateConVar("persona_meter_enabled","1",128,"Toggles the Persona Summon meter. Note that with sv_cheats set to 1, the meter will always be full!",0,1)
CreateConVar("persona_meter_mul","1",128,"Multiplies the max value of your Persona Summon meter by X amount, allowing you to have your Persona out for longer!",1,20)

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
	local function CConVar(name,val,save,min,max)
		CreateClientConVar(name,val,save,true,nil,min,max)
	end

	CConVar("vj_persona_music","1",true,0,1)
	CConVar("vj_persona_dancemode","1",true,0,2)
	CConVar("vj_persona_dancedifficulty","2",true,1,5)
	CConVar("vj_persona_dancevol","60",true,15,100)
	CConVar("persona_dance_perfect","0",true,0,1)
	CConVar("persona_dance_controller","0",true,0,1)
	CConVar("persona_dance_cinematic","0",true,0,1)

	CConVar("persona_dance_top_l","11",true,0,159)
	CConVar("persona_dance_mid_l","29",true,0,159)
	CConVar("persona_dance_bot_l","14",true,0,159)
	CConVar("persona_dance_top_r","8",true,0,159)
	CConVar("persona_dance_mid_r","9",true,0,159)
	CConVar("persona_dance_bot_r","10",true,0,159)
	CConVar("persona_dance_scratch","15",true,0,159)

	CConVar("persona_dance_hud_r","255",true,0,255)
	CConVar("persona_dance_hud_g","255",true,0,255)
	CConVar("persona_dance_hud_b","255",true,0,255)

	CConVar("persona_hud_x","350",true)
	CConVar("persona_hud_y","350",true)
	-- CConVar("persona_hud_skills_x","700",true)
	-- CConVar("persona_hud_skills_y","350",true)
	CConVar("persona_hud_damage","1",true,0,1)
	CConVar("persona_hud_raidboss","0",true,0,1)

	net.Receive("persona_csound",function(len,pl)
		local ply = net.ReadEntity()
		local snd = net.ReadString()
		local vol = net.ReadFloat()
		local pit = net.ReadFloat()

		if !IsValid(ply) then return end
		ply:EmitSound(snd,vol,pit)
	end)

	local function SpawnMarker(text,col,pos,vel,dmg,bonus)
		if !useMarkers() then return end
		
		local split = string.Split(text,"")
		local marker = {}
		marker.initialized = false
		marker.text = text
		marker.numbers = split
		marker.effects = bonus
		marker.dmg = dmg
		marker.duration = 1.5
		marker.pos = Vector(pos.x,pos.y,pos.z)
		marker.vel = Vector(vel.x,vel.y,vel.z)
		marker.col = Color(col.r,col.g,col.b)
		marker.spawntime = CurTime()
		marker.deathtime = CurTime() +marker.duration

		surface.SetFont("Persona")
		local w,h = surface.GetTextSize(text)

		marker.widthH = w /2
		marker.heightH = h /2

		table.insert(Persona_DMGMarkers,marker)
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

		SpawnMarker(tostring(math.abs(math.Round(dmg))),col,pos,force +Vector(math.Rand(-1,1),math.Rand(-1,1),math.Rand(0,1) *1.5),dmg,bonus)
	end)
	
	hook.Add("RenderScreenspaceEffects","Persona_ScreenFX",function()
		local CM_DreamFog = {
			["$pp_colour_addr"] = 0,
			["$pp_colour_addg"] = 0,
			["$pp_colour_addb"] = 0,
			["$pp_colour_brightness"] = -0.65,
			["$pp_colour_contrast"] = 0.1,
			["$pp_colour_colour"] = 0,
			["$pp_colour_mulr"] = 0,
			["$pp_colour_mulg"] = 0,
			["$pp_colour_mulb"] = 0
		}
		local ply = LocalPlayer()
		if !ply:Alive() then return end
		if ply:GetNW2Bool("Persona_DreamFog") then
			DrawColorModify(CM_DreamFog)
		end
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

function PLY:SetPersonaMeter(i)
	return self:SetNW2Float("PersonaMeter",i)
end

function PLY:GetPersonaMeter()
	return self:GetNW2Float("PersonaMeter")
end

function PLY:GetMaxPersonaMeter()
	local calc = math.Round(self:GetMaxSP() /2 *(PXP.IsLegendary(self) && 2 or 1)) *GetConVarNumber("persona_meter_mul")
	return math.Clamp(calc,35,999999999)
end

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

function NPC:SetPersonaMeter(i)
	return self:SetNW2Float("PersonaMeter",i)
end

function NPC:GetPersonaMeter()
	return self:GetNW2Float("PersonaMeter")
end

function NPC:GetMaxPersonaMeter()
	return math.Round(self:GetMaxSP() /5) *GetConVarNumber("persona_meter_mul")
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
		hook.Call("PersonaMod_PersonaSummoned",nil,self,ent)
	else
		if personaEntity:GetTask() != "TASK_RETURN" then
			personaEntity:SetTask("TASK_RETURN")
			personaEntity:OnRequestDisappear(self)
		end
		hook.Call("PersonaMod_PersonaUnsummoned",nil,self,personaEntity)
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

	local Pexp = PXP.GetPersonaData(ply,10)
	local Plvl = PXP.GetPersonaData(ply,9) or 0
	PXP.SetPersonaData(ply,10,Pexp != nil && Pexp or 0)
	PXP.SetPersonaData(ply,9,Plvl != nil && Plvl or 0)
	PXP.SetRequiredPlayerXP(ply,PXP.GetRequiredPlayerXP(ply))

	-- ply:SetSP(ply:IsSuperAdmin() && 999 or ply:IsAdmin() && 350 or 150)
	-- ply:SetMaxSP(ply:GetSP())
	ply:SetNW2Bool("Persona_BattleMode",false)
	ply:SetNW2Bool("Persona_SkillMenu",false)
	timer.Simple(0,function()
		ply.Persona_MaxHealth = 100
		ply:SetMaxHealth(100)
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
end)

if SERVER then

	function P_HasEnhancements(ent,incSPE)
		if !IsValid(ent) then return false end
		local incSPE = incSPE or false
		local t = CurTime()
		return ent.Persona_TarukajaT > t || ent.Persona_RakukajaT > t || ent.Persona_ChargedT > t && incSPE || ent.Persona_SukukajaT > t || ent.Persona_HeatRiserT > t && incSPE || ent.Persona_FocusedT > t && incSPE
	end

	function P_HasPenalties(ent)
		if !IsValid(ent) then return false end
		local t = CurTime()
		return ent.Persona_TarundaT > t || ent.Persona_RakundaT > t || ent.Persona_SukundaT > t || ent.Persona_DebilitateT > t
	end
	
	hook.Add("PlayerSpawn","Persona_Spawn",function(ply)
		ply:SetNW2Bool("Persona_BattleMode",false)
		ply:SetNW2Bool("Persona_SkillMenu",false)
		local lvl = PXP.GetPlayerLevel(ply)
		local shouldBe = math.Clamp(math.Round(lvl *10.09),100,654698468)
		local shouldBeSP = math.Clamp(math.Round(lvl *8),25,654698468)
		ply:SetNW2Int("PXP_Player_Level",lvl)
		timer.Simple(0,function()
			ply:SetHealth(shouldBe)
			ply:SetSP(shouldBeSP)
			ply:SetMaxSP(ply:GetSP())
			ply:SetPersonaMeter(ply:GetMaxPersonaMeter())
			-- ply:SetHealth(ply.Persona_MaxHealth)
		end)
		ply.PXP_NextXPChange = CurTime()
		ply.Persona_NextRegenMeterT = 0
		ply.Persona_NextRegenMeterSoundT = 0
		ply.Persona_NextRegenMeterStopSoundT = 0

		ply.Persona_TarukajaT = 0 -- Inc. ATK
		ply.Persona_TarundaT = 0 -- Dec. ATK
		ply.Persona_RakukajaT = 0 -- Inc. DEF
		ply.Persona_RakundaT = 0 -- Dec. DEF
		ply.Persona_SukukajaT = 0 -- Inc. AGI
		ply.Persona_SukundaT = 0 -- Dec. AGI
		
		ply.Persona_Tetrakarn = false -- Shield for Phys (non-Almighty)
		ply.Persona_Makarakarn = false -- Shield for Magic (non-Almighty)

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
		
					ent.Persona_Tetrakarn = false -- Shield for Phys (non-Almighty)
					ent.Persona_Makarakarn = false -- Shield for Magic (non-Almighty)

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

	local wep = "weapon_persona_nothing"
	hook.Add("Think","Persona_Think",function()
		local cheats = GetConVarNumber("persona_meter_enabled") == 0 or GetConVarNumber("sv_cheats") == 1
		for _,v in pairs(player.GetAll()) do
			local meter = v:GetPersonaMeter()
			local maxMeter = v:GetMaxPersonaMeter()
			local persona = v:GetPersona()
			local lvl = PXP.GetPlayerLevel(v)
			local shouldBe = math.Clamp(math.Round(lvl *10.09),100,654698468)
			local shouldBeSP = math.Clamp(math.Round(lvl *8),25,654698468)
			if shouldBe > v:GetMaxHealth() then
				v:SetMaxHealth(shouldBe)
				v.Persona_MaxHealth = shouldBe
			end
			if shouldBeSP > v:GetMaxSP() then
				v:SetMaxSP(shouldBeSP)
			end
			if IsValid(persona) then
				if !v:HasWeapon(wep) && !v:IsFrozen() then
					v:Give(wep)
				end
				v:SelectWeapon(wep)
				v:SetPersonaMeter(cheats && maxMeter or math.Clamp(meter -0.1,0,maxMeter))
				v.Persona_NextRegenMeterT = CurTime() +5
				if meter <= 0 && persona:GetTask() != "TASK_RETURN" then
					persona:SetTask("TASK_RETURN")
					persona:OnRequestDisappear(v)
					if CurTime() > v.Persona_NextRegenMeterStopSoundT then
						local snd = "cpthazama/persona5/misc/00045.wav"
						Persona_CSound(v,snd,65)
						v.Persona_NextRegenMeterStopSoundT = CurTime() +SoundDuration(snd)
					end
				end
				if persona.HasOverdrive then
					-- PXP.RemoveEXP(v,20)
					if v:GetSP() <= 0 then
						persona:Overdrive(false)
					else
						persona:TakeSP(cheats && 0 or 1)
					end
				end
			else
				if CurTime() > v.Persona_NextRegenMeterT && meter < maxMeter then
					v:SetPersonaMeter(cheats && maxMeter or math.Clamp(meter +1,0,maxMeter))
					if v:GetPersonaMeter() >= maxMeter && CurTime() > v.Persona_NextRegenMeterSoundT then
						local snd = "cpthazama/persona5/misc/00084.wav"
						Persona_CSound(v,snd,65)
						v.Persona_NextRegenMeterSoundT = CurTime() +SoundDuration(snd)
					end
				end
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
		if dmginfo:GetDamage() > 0 && ent.Persona_Tetrakarn && !dmginfo:IsDamageType(DMG_P_ALMIGHTY) && (dmginfo:IsDamageType(DMG_P_PHYS) || dmginfo:IsDamageType(DMG_P_GUN) || dmginfo:IsDamageType(DMG_SLASH) || dmginfo:IsDamageType(DMG_AIRBOAT) || dmginfo:IsDamageType(DMG_BUCKSHOT) || dmginfo:IsDamageType(DMG_SNIPER) || dmginfo:IsDamageType(DMG_BULLET) || dmginfo:IsDamageType(DMG_CLUB) || dmginfo:IsDamageType(DMG_GENERIC)) then
			local attacker = (IsValid(dmginfo:GetAttacker()) && dmginfo:GetAttacker() or dmginfo:GetInflictor())
			dmginfo:SetAttacker(ent)
			dmginfo:SetInflictor(ent)
			attacker:TakeDamageInfo(dmginfo)
			dmginfo:SetDamage(0)
			VJ_CreateSound(ent,"cpthazama/persona5/skills/0375.wav",80)
			if ent:IsPlayer() then ent:ChatPrint("[Tetrakarn] Reflected damage back at attacker!") end
			ent.Persona_Tetrakarn = false
		end
		if dmginfo:GetDamage() > 0 && ent.Persona_Makarakarn && !dmginfo:IsDamageType(DMG_P_ALMIGHTY) && (dmginfo:IsDamageType(DMG_P_ICE) || dmginfo:IsDamageType(DMG_P_EARTH) || dmginfo:IsDamageType(DMG_P_WIND) || dmginfo:IsDamageType(DMG_P_GRAVITY) || dmginfo:IsDamageType(DMG_P_NUCLEAR) || dmginfo:IsDamageType(DMG_P_EXPEL) || dmginfo:IsDamageType(DMG_P_DEATH) || dmginfo:IsDamageType(DMG_P_MIRACLE) || dmginfo:IsDamageType(DMG_P_FORCE) || dmginfo:IsDamageType(DMG_P_TECH) || dmginfo:IsDamageType(DMG_P_PSI) || dmginfo:IsDamageType(DMG_P_ELEC) || dmginfo:IsDamageType(DMG_P_CURSE) || dmginfo:IsDamageType(DMG_P_FEAR) || dmginfo:IsDamageType(DMG_P_BLESS) || dmginfo:IsDamageType(DMG_P_FIRE) || dmginfo:IsDamageType(DMG_P_BURN) || dmginfo:IsDamageType(DMG_P_SEAL) || dmginfo:IsDamageType(DMG_P_SLEEP) || dmginfo:IsDamageType(DMG_P_PARALYZE) || dmginfo:IsDamageType(DMG_BURN) || dmginfo:IsDamageType(DMG_SHOCK) || dmginfo:IsDamageType(DMG_SONIC) || dmginfo:IsDamageType(DMG_ENERGYBEAM) || dmginfo:IsDamageType(DMG_DROWN) || dmginfo:IsDamageType(DMG_PARALYZE) || dmginfo:IsDamageType(DMG_NERVEGAS) || dmginfo:IsDamageType(DMG_POISON) || dmginfo:IsDamageType(DMG_ACID) || dmginfo:IsDamageType(DMG_PLASMA) || dmginfo:IsDamageType(DMG_PHYSGUN) || dmginfo:IsDamageType(DMG_DISSOLVE)) then
			local attacker = (IsValid(dmginfo:GetAttacker()) && dmginfo:GetAttacker() or dmginfo:GetInflictor())
			dmginfo:SetAttacker(ent)
			dmginfo:SetInflictor(ent)
			attacker:TakeDamageInfo(dmginfo)
			dmginfo:SetDamage(0)
			VJ_CreateSound(ent,"cpthazama/persona5/skills/0375.wav",80)
			if ent:IsPlayer() then ent:ChatPrint("[Makarakarn] Reflected damage back at attacker!") end
			ent.Persona_Makarakarn = false
		end
		
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
			if GetConVarNumber("persona_dmg_scaling") == 1 then
				local aPLvl = ((attacker:IsPlayer() && PXP.GetLevel(attacker)) or (attacker:IsNPC() && IsValid(attacker:GetPersona()) && attacker:GetPersona():GetLVL())) or 1
				local aLvl = ((attacker:IsPlayer()) && ((aPLvl +PXP.GetPlayerLevel(attacker)) /2 or 1)) or ((attacker:IsNPC()) && (/*aPLvl or */attacker:GetNW2Int("PXP_Level"))) or 1
				local PLvl = ((ent:IsPlayer() && PXP.GetLevel(ent)) or (ent:IsNPC() && IsValid(persona) && persona:GetLVL())) or 1
				local lvl = ((ent:IsPlayer()) && ((PLvl +PXP.GetPlayerLevel(ent)) /2 or 1)) or ((ent:IsNPC()) && (/*PLvl or */ent:GetNW2Int("PXP_Level"))) or 1
				aLvl = math.Round(aLvl)
				lvl = math.Round(lvl)
				local lvlDif = aLvl -lvl
				local lvlDifAbs = math.abs(lvlDif)
				
				local modDMG = dmg
				if lvlDifAbs > 5 then
					modDMG = (lvl > aLvl && (modDMG /(lvlDifAbs /6))) or (lvlDif *0.1) *modDMG
				end
				dmginfo:SetDamage(modDMG)
			end

			if ent.Persona_BrainWashed then
				if ent.Persona_BrainWashers then
					if IsValid(attacker) && VJ_HasValue(ent.Persona_BrainWashers,attacker) then
						dmginfo:SetDamage(0)
					end
				end
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
			end
			-- Entity(1):ChatPrint("Alterations - " .. tostring(dmginfo:GetDamage()))

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
				SpawnMarker_SV(dmginfo:GetDamage(),dmgtype,dmginfo:GetDamagePosition(),dmginfo:GetDamageForce(),attacker:GetPersona():GetCritical() or false,color,bonus)
			end

			if IsValid(persona) then
				if persona.HandleDamage then
					return persona:HandleDamage(dmg,dmgtype,dmginfo)
				end
			end
		end
		-- return true -- Prevents all damage
	end)

	local function summon_persona(ply)
		if !ply:Alive() then return end
		if ply:GetPersonaMeter() <= 0 then
			ply:ChatPrint("You are currently exhausted. Wait a few seconds to regenerate Persona Meter!")
			return
		end
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
		local pickEnt = ply:GetNW2Entity("Persona_SetTarget")
		if IsValid(ply:GetPersona()) && ply:Alive() then
			if CurTime() > ply.NextLockOnT then
				if IsValid(pickEnt) then
					ply.Persona_EyeTarget = pickEnt
					ply:SetNW2Entity("Persona_Target",pickEnt)
					ply:SetNW2Entity("Persona_SetTarget",NULL)
					ply:EmitSound("cpthazama/persona5/misc/00007.wav",70,100)
					ply.NextLockOnT = CurTime() +0.2
					return
				end
				if IsValid(ply.Persona_EyeTarget) then
					ply.Persona_EyeTarget = NULL
					ply:EmitSound("cpthazama/persona5/misc/00019.wav",70,100)
				else
					local ent = ply:GetEyeTrace().Entity
					if IsValid(ent) then
						if (ent:IsNPC() or ent:IsPlayer() or (ent.IsPersona && ent != ply:GetPersona())) then
							ply.Persona_EyeTarget = ent
							ply:SetNW2Entity("Persona_Target",ent)
							ply:EmitSound("cpthazama/persona5/misc/00007.wav",70,100)
						end
					else
						local ents = ply:GetPersona():FindEnemies(ply:GetPos(),2000)
						local ent = VJ_PICK(ents)
						if IsValid(ent) then
							ply.Persona_EyeTarget = ent
							ply:SetNW2Entity("Persona_Target",ent)
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

	local pFont = ScreenScale(8.5)
	local pFontBig = ScreenScale(25)
	local pFont_EXP = ScreenScale(6.5)
	local pFont_Small = ScreenScale(7)

	surface.CreateFont("Persona_Large",{
		font = "p5hatty",
		extended = false,
		size = pFontBig,
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

	surface.CreateFont("Persona",{
		font = "p5hatty",
		extended = false,
		size = pFont,
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
		size = pFont_EXP,
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

	surface.CreateFont("Persona_Small",{ -- Obsolete
		font = "p5hatty",
		extended = false,
		size = pFont_Small,
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

	local lerp_mt = 0
	local calc_mt = 0

	local lerp_xp = 0
	local calc_xp = 0

	local lerp_skill_cost = 0
	local lerp_req = 0
	
	local icons = {
		[1] = "hud_almighty",
		[2] = "hud_bless",
		[3] = "hud_curse",
		[4] = "hud_elec",
		[5] = "hud_fire",
		[6] = "hud_frost",
		[7] = "hud_gun",
		[8] = "hud_nuclear",
		[9] = "hud_phys",
		[10] = "hud_psi",
		[11] = "hud_sleep",
		[12] = "hud_wind"
	}
	
	local iconsDMG = {
		[1] = {DMG_P_ALMIGHTY},
		[2] = {DMG_P_MIRACLE,DMG_P_BLESS},
		[3] = {DMG_P_CURSE},
		[4] = {DMG_P_ELEC,DMG_PHYSGUN,DMG_SHOCK,DMG_ENERGYBEAM,DMG_PLASMA},
		[5] = {DMG_P_FIRE,DMG_BURN,DMG_SLOWBURN},
		[6] = {DMG_P_ICE},
		[7] = {DMG_P_GUN,DMG_BULLET,DMG_AIRBOAT,DMG_BUCKSHOT,DMG_SNIPER,DMG_MISSILEDEFENSE},
		[8] = {DMG_P_NUCLEAR,DMG_DISSOLVE,67108865,67110912},
		[9] = {DMG_P_PHYS,DMG_GENERIC,DMG_CRUSH,8197,DMG_SLASH,DMG_VEHICLE,DMG_FALL,DMG_CLUB,DMG_NEVERGIB},
		[10] = {DMG_P_PSI,DMG_P_PSY},
		[11] = {DMG_P_SLEEP,DMG_P_PARALYZE,DMG_P_FEAR,DMG_P_DEATH,DMG_PARALYZE},
		[12] = {DMG_P_WIND}
	}

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
		["hud_azathoth"] = "Summoning",
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

		local function DrawTexture(texture,col,posX,posY,scaleX,scaleY,rot)
			local mat = Material(texture)
			surface.SetMaterial(mat)
			surface.SetDrawColor(col.r,col.g,col.b,col.a)
			if rot then
				surface.DrawTexturedRectRotated(posX,posY,scaleX,scaleY,rot)
				return
			end
			surface.DrawTexturedRect(posX,posY,scaleX,scaleY)
		end

		local hp = ply:Health()
		local hpMax = ply:GetMaxHealth()

		if ply:GetNW2Bool("Persona_BattleMode") == true then
			local rgb = HSL((RealTime() *15 -(0 *15)),128,128)
			local BGTexture = "hud/persona/dance/bg.png"
			local HUDColor = color(rgb.r,rgb.g,rgb.b)
			local danceMat = "hud/persona/dance/bg_stars"
			local blink = math.Clamp(math.abs(math.sin(CurTime() *0.25) *255),50,100)
			local BGA = 255
			
			if hp <= hpMax *0.25 then
				HUDColor = color(230,5,5)
				BGTexture = "hud/persona/lowhealth.png"
				blink = math.Clamp(math.abs(math.sin(CurTime() *1) *255),150,200)
				BGA = math.Clamp(math.abs(math.sin(CurTime() *5) *255),100,176)
			end
			
			DrawTexture(BGTexture,color(255,255,255,BGA),0,0,ScrW(),ScrH())
			DrawTexture(danceMat .. "_cut.png",color(HUDColor.r,HUDColor.g,HUDColor.b,blink),0,0,ScrW() /5,ScrH())
			DrawTexture(danceMat .. "_cut_b.png",color(HUDColor.r,HUDColor.g,HUDColor.b,blink),ScrW() *0.8,0,ScrW() /5,ScrH())
		end

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
		local hasSkillMenu = ply:GetNW2Bool("Persona_SkillMenu")
		local skillMenu = ply.Persona_CSSkills or {}
		local meter = ply:GetPersonaMeter()
		local maxMeter = ply:GetMaxPersonaMeter()

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
		lerp_mt = Lerp(5 *FrameTime(), lerp_mt, meter)
		lerp_xp = Lerp(5 *FrameTime(), lerp_xp, xp)
		calc_xp = Lerp(5 *FrameTime(), calc_xp, perXP)
		local perHPB = lerp_hp *100 /hpMax
		local perSPB = lerp_sp *100 /spMax
		local perMTB = lerp_mt *100 /maxMeter

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

		// Meter
		local r,g,b = 255, 255, 0
		local posX = boxX
		local posY = boxHeight +50
		local len = boxX -25
		local lenBar = len -18
		local height = 30
		local bHeight = 110
		local bDrop = bHeight +30
		if persona:GetNW2Bool("Overdrive") then
			local rgb = HSL((RealTime() *350 -(0 *15)),160,160)
			r,g,b = rgb.r, rgb.g, rgb.b
		end
		if meter <= maxMeter *0.15 then
			r,g,b = 220, 0, 0
		end
		draw.RoundedBox(corners, ScrW() -posX, ScrH() -posY -bHeight, len, bDrop, bColor)
		draw.RoundedBox(corners, ScrW() -posX +10, ScrH() -posY -5, lenBar, height, color(0,0,0,150))
		draw.RoundedBox(corners, ScrW() -posX +10, ScrH() -posY -5, math.Clamp(lenBar *((perMTB /100) /(persona:GetNW2Bool("Legendary") && 2 or 1)),0,lenBar), height, color(r, g, b, 255))
		local push = 0
		local spacing = 50
		for i = 1,12 do
			local iColor = color(35,35,35,255)
			if i > 6 then
				push = spacing
			end
			if ply.PersonaElements then
				local hasWK = P_HasDamageType(ply.PersonaElements.WK,iconsDMG[i])
				local hasRES = P_HasDamageType(ply.PersonaElements.RES,iconsDMG[i])
				local hasNUL = P_HasDamageType(ply.PersonaElements.NUL,iconsDMG[i])
				local hasREF = P_HasDamageType(ply.PersonaElements.REF,iconsDMG[i])
				local hasABS = P_HasDamageType(ply.PersonaElements.ABS,iconsDMG[i])
				if hasWK then iColor = color(235,0,0,255) end -- Red
				if hasRES then iColor = color(127,0,255,255) end -- Purple
				-- if hasNUL then iColor = color(127,255,255,255) end -- Light Blue
				if hasNUL then iColor = color(150,150,150,255) end -- Light Grey
				-- if hasREF then iColor = color(225,255,0,255) end -- Yellow
				if hasREF then iColor = color(127,255,255,255) end -- Light Blue
				if hasABS then iColor = color(0,255,63,255) end -- Green
			end
			DrawTexture("hud/persona/png/stats/" .. icons[i] .. ".png",iColor,ScrW() -posX -32 +(spacing *i) -push *6, ScrH() -posY -bHeight +8 +push,35,35)
		end

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

		local function DrawTargetHealth(ent)
			if IsValid(ent) then
				local len = 200
				local height = 100
				local bColor = color(colM,colM,colM,230)

				local hp = ply:GetNW2Int("Persona_TargetHealth") or 0
				local hpMax = ent:GetMaxHealth()
				local perHP = (hp -cost) /hpMax
				lerp_e_hp = Lerp(5 *FrameTime(), lerp_e_hp, hp)
				calc_e_hp = Lerp(5 *FrameTime(), calc_e_hp, perHP)
				local perHPB = lerp_e_hp *100 /hpMax
				
				local icon = persona:GetNW2String("SpecialAttackIcon")
				local matIcon = Material("hud/persona/crosshair")
				local offset = 225
				local entPos = (ent:GetPos() +ent:OBBCenter()):ToScreen()
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
				local alpha = 255

				draw.RoundedBox(corners, posX, posY, nlen, height, color(0, 0, 0, 150))
				draw.RoundedBox(corners, posX, posY, f, height, color(r, g, b, alpha))

				local text = "Level " .. (tostring(ent:GetNW2Int("PXP_Level")) or "0")
				draw.SimpleText(text,"Persona",boxX +5,boxY +30,color(248,60,64,255))

				local text = (tostring(ent:GetNW2Int("PXP_EXP")) or "0") .. " EXP"
				draw.SimpleText(text,"PXP_EXP",boxX +5,boxY +70,color(248,60,64,255))
			end
		end

		local function DrawEntHealth(ent)
			if IsValid(ent) then
				local len = 200
				local height = 80
				local bColor = color(colM,colM,colM,230)

				local offset = 225
				local entPos = (ent:GetPos() +ent:OBBCenter()):ToScreen()
				local boxX = entPos.x -offset -35
				local boxY = entPos.y -offset -35
				draw.RoundedBox(corners,boxX,boxY +20,len,height,bColor)

				local text = "Level " .. (tostring(ent:GetNW2Int("PXP_Level")) or "0")
				draw.SimpleText(text,"Persona",boxX +5,boxY +30,color(248,60,64,255))

				local text = (tostring(ent:GetNW2Int("PXP_EXP")) or "0") .. " EXP"
				draw.SimpleText(text,"PXP_EXP",boxX +5,boxY +70,color(248,60,64,255))
			end
		end
		
		DrawTargetHealth(target)
		local bTbl = ply.BattleEntitiesTable
		-- PrintTable(ply.BattleEntitiesTable)
		if bTbl && #bTbl > 0 then
			for _,v in ipairs(bTbl) do
				if v != target then
					DrawEntHealth(v)
				end
			end
		end

		// Skill Menu
		if !hasSkillMenu then return end
		local mCount = #skillMenu
		local posX = GetConVarNumber("persona_hud_x") +350
		local posY = GetConVarNumber("persona_hud_y")
		if mCount > 13 then
			for i = 1,mCount -13 do
				posY = posY +25
			end
		end
		local len = 325
		local height = 35 +(mCount *23)
		local colM = 35
		local bColor = color(colM,colM,colM,255)
		local boxX = posX
		local boxHeight = posY
		draw.RoundedBox(corners,ScrW() -posX,ScrH() -posY,len,height,bColor)

		posX = boxX -10
		posY = boxHeight -10
		len = 325
		height = 30
		colM = 80
		bColor = color(colM,colM,colM,80)
		for i,v in pairs(skillMenu) do
			if v then
				local name = v.Name
				local cost = v.Cost
				local doHP = v.UsesHP
				if doHP then r,g,b = 107, 255, 222 else r,g,b = 255, 101, 239 end
				local strCost = doHP && " HP)" or " SP)" -- Okay GMod, this exact code causes an error if its not a local variable. Dumbest shit I've ever seen Morty
				if skillName == name then
					draw.RoundedBox(corners,ScrW() -posX -10,ScrH() -posY -5,len,height,bColor)
				end
				draw.SimpleText(name .. " (" .. cost .. strCost,"PXP_EXP",ScrW() -posX,ScrH() -posY,color(r, g, b, 255))
				posY = posY -25
			end
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

game.AddParticles("particles/persona_aura.pcf")
local pParticleList = {
	"persona_aura_blue",
	"persona_aura_red",
	"persona_aura_yellow",
	"persona_aura_purple",
	"persona_aura_velvet",
	"persona_aura_overdrive",
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