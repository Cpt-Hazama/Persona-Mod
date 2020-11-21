AddCSLuaFile()
if (!file.Exists("autorun/vj_base_autorun.lua","LUA")) then return end
/*--------------------------------------------------
	=============== Battle Mode Logic Entity ===============
	*** Copyright (c) 2012-2021 by Cpt. Hazama, All rights reserved. ***
	No parts of this code or any of its contents may be reproduced, copied, modified or adapted,
	without the prior written consent of the author, unless otherwise indicated for stand-alone materials.
INFO: Used to make simple props and animate them, since prop_dynamic doesn't work properly in Garry's Mod...
--------------------------------------------------*/
---------------------------------------------------------------------------------------------------------------------------------------------
ENT.Base 			= "base_gmodentity"
ENT.Type 			= "anim"
ENT.PrintName 		= "Persona Battle Mode Entity"
ENT.Author 			= "Cpt. Hazama"
ENT.Contact 		= ""
ENT.Purpose 		= ""
ENT.Instructions 	= ""
ENT.Category		= ""

ENT.Spawnable = false
ENT.AdminOnly = false
ENT.AutomaticFrameAdvance = true
---------------------------------------------------------------------------------------------------------------------------------------------
if SERVER then
	util.AddNetworkString("Persona_StartBattle")
end
---------------------------------------------------------------------------------------------------------------------------------------------
if (CLIENT) then
	ENT.BattleActive = false
	ENT.BattleEntities = {}

	function ENT:Draw()
		-- self:DrawModel()
	end

	function ENT:DrawTranslucent()
		-- self:Draw()
	end

	function ENT:OnRemove()
		for _,v in pairs(self.BattleEntities) do
			print(v)
			if IsValid(v) && v:IsPlayer() then
				if v.Persona_BattleTheme then
					v.Persona_BattleTheme:FadeOut(2)
				end
				v:SetNW2Bool("Persona_BattleMode",false)
			end
		end
	end

	function ENT:Think()
		local ply = LocalPlayer()
		if !self.BattleActive then
			-- if IsValid(self:GetStarter()) then
				-- self:InitializeBattle(self:GetStarter())
			-- end
			return
		end
		if !self.BattleEntities[ply] then return end
		-- if ply.Persona_BattleTheme && ply.Persona_BattleTheme:IsPlaying() then
			-- ply.Persona_BattleTheme:ChangeVolume(0.5)
			-- if CurTime() > ply.Persona_BattleThemeT then
				-- ply.Persona_BattleThemeT = CurTime() +ply.Persona_BattleThemeTime
			-- end
		-- end
	end

	function ENT:InitializeBattle(ply,tblEnemies)
		self.BattleActive = true

		local snd = "cpthazama/persona5/music/battlemode_01.mp3"
		ply.Persona_BattleTheme = CreateSound(ply,snd)
		-- ply.Persona_BattleTheme:SetSoundLevel(0)
		ply.Persona_BattleTheme:Play()
		ply.Persona_BattleThemeTime = 221
		ply.Persona_BattleThemeT = CurTime() +ply.Persona_BattleThemeTime
		ply:ConCommand("target_persona")
	end

	net.Receive("Persona_StartBattle",function(len,ply)
		local self = net.ReadEntity()
		local ply = net.ReadEntity()
		local tblEnemies = net.ReadTable()

		-- self:InitializeBattle(ply,tblEnemies)
		-- self.BattleActive = true
		self.BattleEntities = tblEnemies

		local snd = "cpthazama/persona5/music/battlemode_01.mp3"
		ply.Persona_BattleTheme = CreateSound(ply,snd)
		-- ply.Persona_BattleTheme:SetSoundLevel(0)
		ply.Persona_BattleTheme:Play()
		ply.Persona_BattleThemeTime = 221
		ply.Persona_BattleThemeT = CurTime() +ply.Persona_BattleThemeTime
		ply:ConCommand("target_persona")
	end)
end
---------------------------------------------------------------------------------------------------------------------------------------------
function ENT:SetupDataTables()
	self:AddVar("Entity","Starter")
end
---------------------------------------------------------------------------------------------------------------------------------------------
function ENT:AddVar(type,name)
	self.Vars = self.Vars or {}
	self.Vars[type] = self.Vars[type] or {}
	local count = #self.Vars[type]

	self:NetworkVar(type,count,name)
end
---------------------------------------------------------------------------------------------------------------------------------------------
function ENT:StartBattle(ply,ent)
	-- self:SetStarter(ply)
	
	local tbl = {}
	if IsValid(ent) then
		table.insert(tbl,ent)
		for _,v in pairs(ents.FindInSphere(ent:GetPos(),1000)) do
			if v:IsNPC() && v != ent && v:Disposition(ent) == D_LI then
				if #tbl >= 5 then
					break
				end
				table.insert(tbl,v)
			end
		end
	end
	
	if #tbl > 0 then
		net.Start("Persona_StartBattle")
			net.WriteEntity(self)
			net.WriteEntity(ply)
			net.WriteTable(tbl)
		net.Send(ply)
		self:SetStarter(ply)
		-- self:InitializeBattle(ply,tbl)
		ply:ConCommand("summon_persona")
	else
		ply:SetNW2Bool("Persona_BattleMode",false)
	end
end
---------------------------------------------------------------------------------------------------------------------------------------------
function ENT:Initialize()
	self:SetSolid(SOLID_NONE)
end
/*--------------------------------------------------
	=============== VJ Prop Animatable Entity ===============
	*** Copyright (c) 2012-2021 by Cpt. Hazama, All rights reserved. ***
	No parts of this code or any of its contents may be reproduced, copied, modified or adapted,
	without the prior written consent of the author, unless otherwise indicated for stand-alone materials.
INFO: Used to make simple props and animate them, since prop_dynamic doesn't work properly in Garry's Mod...
--------------------------------------------------*/
