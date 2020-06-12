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

function PLY:GetPersonaName()
	return self:GetNWString("PersonaName")
end

function PLY:SetPersonaEntity(ent)
	self:SetNWEntity("Persona",ent)
end

function PLY:GetPersona()
	return self:GetNWEntity("Persona")
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

if SERVER then
	-- local wep = "weapon_persona_nothing"
	local wep = "weapon_jojo_nothing"
	hook.Add("Think","Persona_Think",function()
		for _,v in pairs(player.GetAll()) do
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