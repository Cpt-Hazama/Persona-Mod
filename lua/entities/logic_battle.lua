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

ENT.BattleActive = false
ENT.BattleEntitiesTable = {}
---------------------------------------------------------------------------------------------------------------------------------------------
if SERVER then
	util.AddNetworkString("Persona_StartBattle")
	util.AddNetworkString("Persona_EndBattle")
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
	net.Receive("Persona_EndBattle",function(len,ply)
		local ent = net.ReadEntity()
		local ply = net.ReadEntity()
		local tblEnemies = net.ReadTable()
		local persona = ply:GetPersona()
		-- if ent == self then
			if IsValid(persona) then
				if persona:GetTask() != "TASK_RETURN" then
					persona:SetTask("TASK_RETURN")
					persona:OnRequestDisappear(ply)
				end
			end
			ply:SetNW2Bool("Persona_BattleMode",false)
			ent:Remove()
		-- end
	end)
end
---------------------------------------------------------------------------------------------------------------------------------------------
if (CLIENT) then

	net.Receive("Persona_StartBattle",function(len,ply)
		local ent = net.ReadEntity()
		local ply = net.ReadEntity()
		local tblEnemies = net.ReadTable()

		-- self:InitializeBattle(ply,tblEnemies)
		-- self.BattleActive = true
		ply.BattleEntitiesTable = tblEnemies
		local boss = false
		for _,v in pairs(tblEnemies) do if IsValid(v) && v:GetNW2Bool("VJ_IsHugeMonster") then boss = true break end end

		local tracks = P_FindBattleTracks(boss)
		local name, snd, len = tracks.Name, tracks.Song, tracks.Length
		ply:ChatPrint("Now Playing: " .. name .. " [" .. string.FormattedTime(tostring(len),"%02i:%02i") .. "]")
		ply.Persona_BattleTheme = CreateSound(ply,snd)
		ply.Persona_BattleTheme:Play()
		ply.Persona_BattleThemeTime = len
		ply.Persona_BattleThemeT = CurTime() +ply.Persona_BattleThemeTime
		ply:ConCommand("target_persona")
	end)

	function ENT:Draw()
		-- self:DrawModel()
	end

	function ENT:DrawTranslucent()
		-- self:Draw()
	end

	function ENT:OnRemove()
		-- print("ONREMOVED")
		for _,v in pairs(self.BattleEntitiesTable) do
			-- print(v)
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
		-- print(self.BattleActive)
		-- if !self.BattleActive then
			-- if IsValid(self:GetStarter()) then
				-- self:InitializeBattle(self:GetStarter())
			-- end
			-- net.Start("Persona_EndBattle")
				-- net.WriteEntity(self)
				-- net.WriteEntity(ply)
				-- net.WriteTable(self.BattleEntitiesTable)
			-- net.SendToServer()
			-- return
		-- end
		-- if !VJ_HasValue(self.BattleEntitiesTable,ply) then return end
		if ply.Persona_BattleTheme && CurTime() > ply.Persona_BattleThemeT then
			ply.Persona_BattleTheme:Stop()
			ply.Persona_BattleTheme:Play()
			ply.Persona_BattleThemeT = CurTime() +ply.Persona_BattleThemeTime
		end
		self.BattleEntitiesTable = ply.BattleEntitiesTable
		for i,v in pairs(self.BattleEntitiesTable) do
			if !IsValid(v) or IsValid(v) && v:Health() <= 0 then
				-- print("Removed ent")
				table.remove(self.BattleEntitiesTable,i)
			end
		end
		if #self.BattleEntitiesTable <= 0 or ply:Health() <= 0 then
			ply:SetNW2Bool("Persona_BattleMode",false)
			if ply.Persona_BattleTheme then
				ply.Persona_BattleTheme:FadeOut(2)
			end
			net.Start("Persona_EndBattle")
				net.WriteEntity(self)
				net.WriteEntity(ply)
				net.WriteTable(self.BattleEntitiesTable)
			net.SendToServer()
		else
			if !IsValid(ply:GetNW2Entity("Persona_Target")) then
				-- ply:ConCommand("target_persona") // Can cause problems
				local pick = VJ_PICK(self.BattleEntitiesTable)
				if IsValid(pick) then
					ply:SetNW2Entity("Persona_SetTarget",pick)
					ply:ConCommand("target_persona")
					-- ply.Persona_EyeTarget = pick
					-- ply:SetNW2Entity("Persona_Target",pick)
					-- ply:EmitSound("cpthazama/persona5/misc/00007.wav",70,100)
				end
			end
		end
		-- if ply.Persona_BattleTheme && ply.Persona_BattleTheme:IsPlaying() then
			-- ply.Persona_BattleTheme:ChangeVolume(0.5)
			-- if CurTime() > ply.Persona_BattleThemeT then
				-- ply.Persona_BattleThemeT = CurTime() +ply.Persona_BattleThemeTime
			-- end
		-- end
	end

	function ENT:InitializeBattle(ply,tblEnemies)
		self.BattleActive = true

		-- local snd = "cpthazama/persona5/music/battlemode_01.mp3"
		-- ply.Persona_BattleTheme = CreateSound(ply,snd)
		-- ply.Persona_BattleTheme:Play()
		-- ply.Persona_BattleThemeTime = 234
		-- ply.Persona_BattleThemeT = CurTime() +ply.Persona_BattleThemeTime
		ply:ConCommand("target_persona")
	end
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
		self.BattleActive = true
		-- self:InitializeBattle(ply,tbl)
		ply:ConCommand("summon_persona")
	else
		ply:SetNW2Bool("Persona_BattleMode",false)
	end
end
if SERVER then
---------------------------------------------------------------------------------------------------------------------------------------------
function ENT:Initialize()
	self:SetSolid(SOLID_NONE)
	self:SetModel("models/props_borealis/bluebarrel001.mdl")
	self:SetNoDraw(true)
	self:DrawShadow(false)
	self.UsePositions = tobool(GetConVarNumber("vj_persona_battle_positions"))
	self.Positions = {}
	self.Positions[1] = self:GetPos() +self:GetForward() *400
	self.Positions[2] = self:GetPos() +self:GetForward() *475 +self:GetRight() *250
	self.Positions[3] = self:GetPos() +self:GetForward() *475 +self:GetRight() *-250
	self.Positions[4] = self:GetPos() +self:GetForward() *500 +self:GetRight() *350
	self.Positions[5] = self:GetPos() +self:GetForward() *500 +self:GetRight() *-350
end
---------------------------------------------------------------------------------------------------------------------------------------------
function ENT:Think()
	if !self.UsePositions then return end
	for i,v in pairs(self.Starter.BattleEntitiesTable) do
		if IsValid(v) && v:Health() > 0 && self.Starter != v then
			local pos = self.Positions[i]
			if v:GetPos() != pos then
				v:SetPos(pos)
			end
			v.DisableChasingEnemy = true
		end
	end
end
---------------------------------------------------------------------------------------------------------------------------------------------
function ENT:OnRemove()
	if !self.UsePositions then return end
	for i,v in pairs(self.Starter.BattleEntitiesTable) do
		if IsValid(v) && v:Health() > 0 && self.Starter != v then
			v.DisableChasingEnemy = v.VJ_P_DisableChasingEnemy
		end
	end
end
end
/*--------------------------------------------------
	=============== VJ Prop Animatable Entity ===============
	*** Copyright (c) 2012-2021 by Cpt. Hazama, All rights reserved. ***
	No parts of this code or any of its contents may be reproduced, copied, modified or adapted,
	without the prior written consent of the author, unless otherwise indicated for stand-alone materials.
INFO: Used to make simple props and animate them, since prop_dynamic doesn't work properly in Garry's Mod...
--------------------------------------------------*/
