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
	util.AddNetworkString("Persona_SetTurn")
	util.AddNetworkString("Persona_EndBattle")
	util.AddNetworkString("Persona_UpdateBattleData")
	util.AddNetworkString("Persona_UpdateCSBattleData")
	util.AddNetworkString("Persona_UpdateCSFriendData")
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
	net.Receive("Persona_UpdateBattleData",function(len,ply)
		local self = net.ReadEntity()
		local ply = net.ReadEntity()
		local tEnt = net.ReadEntity()
		local tblEnemies = net.ReadTable()

		-- ply.BattleEntitiesTable = tblEnemies
		-- self.CurrentTurnEntity = tEnt
	end)
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
			SafeRemoveEntity(ent)
		-- end
	end)
end
---------------------------------------------------------------------------------------------------------------------------------------------
if (CLIENT) then
	net.Receive("Persona_SetTurn",function(len,ply)
		local self = net.ReadEntity()
		local ply = net.ReadEntity()
		local newTurn = net.ReadFloat(24)
		local tEnt = net.ReadEntity()

		self.CurrentTurn = newTurn
		self.CurrentTurnEntity = tEnt
		if self.BattleEntitiesTable != nil then
			for _,v in SortedPairs(self.BattleEntitiesTable) do
				if IsValid(v) && v:IsPlayer() then
					v:ChatPrint("It is now " .. (tEnt:IsPlayer() && tEnt:Nick() or language.GetPhrase(self.CurrentTurnEntity:GetClass())) .. "'s turn!")
				end
			end
		end
	end)

	net.Receive("Persona_UpdateCSFriendData",function(len,ply)
		local self = net.ReadEntity()
		local tEnt = net.ReadEntity()
		local party = net.ReadTable()
		
		self.Party = party
	end)

	net.Receive("Persona_UpdateCSBattleData",function(len,ply)
		local self = net.ReadEntity()
		local tEnt = net.ReadEntity()

		if self.Starter.BattleEntitiesTable != nil then
			table.insert(self.Starter.BattleEntitiesTable,tEnt)
		end
	end)

	net.Receive("Persona_StartBattle",function(len,ply)
		local ent = net.ReadEntity()
		local ply = net.ReadEntity()
		local tblEnemies = net.ReadTable()

		-- self:InitializeBattle(ply,tblEnemies)
		-- self.BattleActive = true
		-- table.insert(tblEnemies,ply)
		ply.BattleEntitiesTable = tblEnemies
		ent.Starter = ply
		local boss = false
		local bossEnt = NULL
		for _,v in pairs(tblEnemies) do
			if IsValid(v) && v:GetNW2Bool("VJ_IsHugeMonster") then
				boss = true
				bossEnt = v
				break
			end
		end

		local tracks = P_FindBattleTracks(boss,boss && bossEnt:GetClass())
		local name, snd, len = tracks.Name, tracks.Song, tracks.Length
		ply:ChatPrint("Now Playing: " .. name .. " [" .. string.FormattedTime(tostring(len),"%02i:%02i") .. "]")
		ply.Persona_BattleTheme = CreateSound(ply,snd)
		ply.Persona_BattleTheme:Play()
		ply.Persona_BattleThemeTime = len
		ply.Persona_BattleThemeT = CurTime() +ply.Persona_BattleThemeTime
		ply:ConCommand("target_persona")
	end)

	local vec0 = Vector(0,0,0)
	local P_LerpAng = Angle(0,0,0)
	local P_LerpAng2 = Angle(0,0,0)
	local P_LerpVec = nil
	function ENT:Initialize()
		local hookName = "Persona_LogicBattle_Camera_" .. self:EntIndex()
		hook.Add("CalcView",hookName,function(ply,pos,angles,fov)
			if !IsValid(self) then
				hook.Remove("CalcView",hookName)
				return
			end
			if self.BattleEntitiesTable && #self.BattleEntitiesTable <= 0 then
				hook.Remove("CalcView",hookName)
				return
			end

			local ply = LocalPlayer()
			local camEnt = self:GetNW2Entity("CurrentTurnEntity")
			local usePos = self:GetNW2Bool("UsePositions")
			local useTurns = self:GetNW2Bool("TakeTurns")
			if usePos == false then hook.Remove("CalcView",hookName) return end
			if useTurns == false then hook.Remove("CalcView",hookName) return end
			if camEnt == ply then return end
			if IsValid(camEnt) then
				local persona = camEnt.GetPersona && camEnt:GetPersona() or false
				local currentSet = IsValid(persona) && persona.GetLastSet && persona:GetLastSet() or "idle"
				local showBoth = false
				if currentSet && currentSet == "range" or currentSet == "range_idle" or currentSet == "range_end" or currentSet == "melee" then
					showBoth = true
				end
				local startPos = camEnt:GetPos() +camEnt:OBBCenter()
				local targetEnt = IsValid(persona) && persona:GetNW2Entity("EyeTarget")

				P_LerpVec = P_LerpVec or startPos
				camEnt.PCam_RandomPos = camEnt.PCam_RandomPos or startPos

				local refreshRate = 2
				local tr
				if showBoth && IsValid(targetEnt) then
					local rad = targetEnt:BoundingRadius()
					tr = util.TraceHull({
						start = camEnt.PCam_RandomPos,
						endpos = (targetEnt:GetPos() +targetEnt:OBBCenter()) +targetEnt:GetForward() *(rad *-4.5) +targetEnt:GetRight() *(rad *2),
						mask = MASK_SHOT,
						filter = {camEnt,ply,targetEnt},
						mins = Vector(-8,-8,-8),
						maxs = Vector(8,8,8)
					})
					refreshRate = 4
				else
					tr = util.TraceHull({
						start = startPos,
						endpos = camEnt.PCam_RandomPos,
						mask = MASK_SHOT,
						filter = {camEnt,ply},
						mins = Vector(-8,-8,-8),
						maxs = Vector(8,8,8)
					})
				end
				local targetPos = tr.HitPos +tr.HitNormal *5
				P_LerpVec = LerpVector(FrameTime() *refreshRate,P_LerpVec,targetPos)
				P_LerpAng2 = LerpAngle(FrameTime() *15,P_LerpAng2,(startPos -P_LerpVec):Angle())
				P_LerpAng = LerpAngle(FrameTime() *15,P_LerpAng,P_LerpAng2)

				if camEnt.PCam_RandomPos:Distance(P_LerpVec) < 15 then
					local rad = IsValid(persona) && persona:BoundingRadius() *3 or camEnt:BoundingRadius() *2
					local midPos = IsValid(persona) && persona:GetPos() +persona:OBBCenter() or startPos
					camEnt.PCam_RandomPos = midPos +camEnt:GetForward() *math.random(rad *0.5,rad) +camEnt:GetRight() *math.random(-rad,rad) +camEnt:GetUp() *math.random(-rad *0.15,rad)
				end

				local view = {}
				view.origin = P_LerpVec
				view.angles = P_LerpAng
				view.fov = fov
				return view
			end
		end)

		local hookName = "Persona_LogicBattle_Halo_" .. self:EntIndex()
		hook.Add("PreDrawHalos",hookName,function()
			if !IsValid(self) then
				hook.Remove("PreDrawHalos",hookName)
				return
			end
			if self.BattleEntitiesTable && #self.BattleEntitiesTable <= 0 then
				hook.Remove("PreDrawHalos",hookName)
				return
			end
			local tblAttacker = {}
			local tblHighlight = {}
			if self.BattleEntitiesTable != nil then
				for _,v in SortedPairs(self.BattleEntitiesTable) do
					if IsValid(v) then
						if v == self.CurrentTurnEntity then
							table.insert(tblAttacker,v)
						else
							table.insert(tblHighlight,v)
						end
					end
				end
			end
			local r,g,b = GetConVarNumber("persona_dance_hud_r"), GetConVarNumber("persona_dance_hud_g"), GetConVarNumber("persona_dance_hud_b")
			halo.Add(tblHighlight,Color(r,g,b),5,5,1,true,true)
			r,g,b = 255 -r, 255 -g, 255 -b
			halo.Add(tblAttacker,Color(r,g,b),15,15,3,true,true)
		end)
	end

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

	function ENT:GetRemainingEnemies()
		local tbl = {}
		for _,v in SortedPairs(self.BattleEntitiesTable) do
			if v == self.Starter then continue end
			if VJ_HasValue(self.Party,v) then continue end
			if !IsValid(v) or IsValid(v) && v:Health() <= 0 then continue end
			table.insert(tbl,v)
		end
		return tbl
	end

	function ENT:Think()
		-- local ply = LocalPlayer()
		local ply = self.Starter
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
			if v == ply then continue end
			if !IsValid(v) or IsValid(v) && v:Health() <= 0 then
				-- print("Removed ent")
				-- table.remove(self.BattleEntitiesTable,i)
				table.remove(ply.BattleEntitiesTable,i)
			end
		end
		-- net.Start("Persona_UpdateBattleData")
			-- net.WriteEntity(self)
			-- net.WriteEntity(ply)
			-- net.WriteEntity(self.CurrentTurnEntity)
			-- net.WriteTable(self.BattleEntitiesTable)
		-- net.SendToServer()
		if #self:GetRemainingEnemies() <= 0 or ply:Health() <= 0 then
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
function ENT:UpdateParty()
	local tbl = {}
	for _,v in SortedPairs(self.Starter:GetFullParty()) do
		if VJ_HasValue(self.Party) then continue end
		if VJ_HasValue(self.BattleEntitiesTable) then continue end
		table.insert(tbl,v)
		table.insert(self.Party,v)
		table.insert(self.BattleEntitiesTable,v)
	end
	net.Start("Persona_UpdateCSFriendData")
		net.WriteEntity(self)
		net.WriteEntity(self.Starter)
		net.WriteTable(tbl)
	net.Send(self.Starter)
end
---------------------------------------------------------------------------------------------------------------------------------------------
function ENT:Initialize()
	self:SetSolid(SOLID_NONE)
	self:SetModel("models/props_borealis/bluebarrel001.mdl")
	self:SetNoDraw(true)
	self:DrawShadow(false)
	self.UsePositions = tobool(GetConVarNumber("vj_persona_battle_positions"))
	self.Sets = {}
	self.Sets[1] = {f=300,r=0}
	self.Sets[2] = {f=400,r=200}
	self.Sets[3] = {f=400,r=-200}
	self.Sets[4] = {f=400,r=400}
	self.Sets[5] = {f=400,r=-400}
	self.Sets[6] = {f=500,r=0}
	self.Sets[7] = {f=650,r=0} -- Some fallback shit, idk how this even happens
	
	self.CurrentTurn = 0
	self.CurrentTurnEntity = NULL
	
	self:SetNW2Bool("UsePositions",self.UsePositions)
	self:SetNW2Bool("TakeTurns",tobool(GetConVarNumber("vj_persona_battle_turns")))
	self:SetNW2Int("TurnTime",CurTime() +GetConVarNumber("vj_persona_battle_turntime"))
	if IsValid(self.Starter) then self.Starter:SetNW2Entity("BattleEnt",self) end
	
	self.Party = {}
	self:UpdateParty()
	
	if GetConVarNumber("vj_persona_battle_newcomers") == 0 then
		local hookName = "Persona_LogicBattle_Think_" .. self:EntIndex()
		hook.Add("Think",hookName,function()
			if !IsValid(self) then
				hook.Remove("Think",hookName)
				return
			end
			if !IsValid(self.Starter) then
				hook.Remove("Think",hookName)
				return
			end
			local tbl = self.Starter.BattleEntitiesTable
			if tbl != nil && table.Count(tbl) > 0 then
				for _,v in SortedPairs(ents.GetAll()) do
					if VJ_HasValue(tbl,v) then -- Ignore entities in battle mode
						continue
					end
					if v.GetEnemy then -- Has the GetEnemy() function, must be a NPC or nextbot
						if IsValid(v:GetEnemy()) && VJ_HasValue(tbl,v:GetEnemy()) then
							if v.SetEnemy then
								v:SetEnemy(NULL)
							end
						end
					end
				end
			end
		end)
	end
end
---------------------------------------------------------------------------------------------------------------------------------------------
function ENT:GetSetPos(i,rev)
	local rowMax = #self.Sets -1
	local row = math.Clamp(math.Round(i /rowMax),1,50)
	local targetI = i
	if targetI > rowMax then
		for x = 1,99 do
			if targetI <= rowMax then
				break
			end
			targetI = targetI -rowMax
		end
	end
	if targetI == nil or targetI == 0 then
		targetI = #self.Sets
	end
	local set = self.Sets[targetI]
	return self:GetPos() +self:GetForward() *(((rev && set.f *-1) or set.f) *row) +self:GetRight() *(((rev && set.r *-1) or set.r) /**row */) +Vector(0,0,10)
end
---------------------------------------------------------------------------------------------------------------------------------------------
function ENT:GetCurrentTurn()
	return self.CurrentTurn
end
---------------------------------------------------------------------------------------------------------------------------------------------
function ENT:NextCurrentTurn(didChange)
	if !self:GetNW2Bool("TakeTurns") then return end
	self:SetNW2Int("TurnTime",CurTime() +GetConVarNumber("vj_persona_battle_turntime"))
	for i,v in SortedPairs(self.Starter.BattleEntitiesTable) do
		if IsValid(v) then
			if v:IsNPC() && v.IsVJBaseSNPC then
				-- v.DisableChasingEnemy = self.UsePositions
				-- v.HasMeleeAttack = false
				-- v.HasRangeAttack = false
				-- v.HasLeapAttack = false
				-- v.HasGrenadeAttack = false
				-- v.CanUseSecondaryOnWeaponAttack = false
				-- v.NextWeaponAttackT = 999999999
				-- v:SetState(self.UsePositions && VJ_STATE_ONLY_ANIMATION or nil)
				v:SetState(self.UsePositions && VJ_STATE_FREEZE or nil)
				-- print("Set values to false",v)
				-- Entity(1):ChatPrint(v:GetState() == VJ_STATE_FREEZE && "Set " .. tostring(v) .. "'s state to FREEZE!" or "Unable to set " .. tostring(v) .. "'s state to FREEZE!")
			end
			self:SetCombatPos(i,v)
		end
	end
	self.CurrentTurn = didChange && self.CurrentTurn or self.CurrentTurn +1
	if self.CurrentTurn > #self.Starter.BattleEntitiesTable then
		self.CurrentTurn = 1
	end
	self.CurrentTurnEntity = self.Starter.BattleEntitiesTable[self.CurrentTurn]
	local newEnt = self.CurrentTurnEntity -- newEnt
	self:SetNW2Entity("CurrentTurnEntity",newEnt)
	self:SetNW2Vector("CurrentTurnEntity_Cam",Vector(math.random(-200,200),math.random(50,200),math.random(10,50)))
	if IsValid(newEnt) && newEnt:IsNPC() && newEnt.IsVJBaseSNPC then
		-- newEnt.DisableChasingEnemy = newEnt:GetNW2Bool("VJ_P_DisableChasingEnemy")
		-- newEnt.HasMeleeAttack = newEnt:GetNW2Bool("VJ_P_HasMeleeAttack")
		-- newEnt.HasRangeAttack = newEnt:GetNW2Bool("VJ_P_HasRangeAttack")
		-- newEnt.HasLeapAttack = newEnt:GetNW2Bool("VJ_P_HasLeapAttack")
		-- newEnt.HasGrenadeAttack = newEnt:GetNW2Bool("VJ_P_HasGrenadeAttack")
		-- newEnt.CanUseSecondaryOnWeaponAttack = newEnt:GetNW2Bool("VJ_P_CanUseSecondaryOnWeaponAttack")
		-- if CurTime() > newEnt:GetNW2Int("VJ_P_NextWeaponAttackT") then
			-- newEnt.NextWeaponAttackT = 0
		-- end
		if newEnt.IsVJBaseSNPC && self.UsePositions then newEnt:SetState() end
		-- print("Set values to their originals",newEnt.DisableChasingEnemy,newEnt.HasMeleeAttack,newEnt.HasRangeAttack,newEnt.HasLeapAttack)
	end
	net.Start("Persona_SetTurn")
		net.WriteEntity(self)
		net.WriteEntity(self.Starter)
		net.WriteFloat(self.CurrentTurn,24)
		net.WriteEntity(self.CurrentTurnEntity)
	net.Send(self.Starter)
end
---------------------------------------------------------------------------------------------------------------------------------------------
function ENT:SetCombatPos(i,v)
	local pos = self:GetSetPos(i,v == self.Starter or VJ_HasValue(self.Party,v))
	if v:GetPos() != pos then
		v:SetPos(pos)
	end
end
---------------------------------------------------------------------------------------------------------------------------------------------
function ENT:Think()
	local usePos = self.UsePositions
	local useTurns = self:GetNW2Bool("TakeTurns")
	local currentEnt = self.CurrentTurnEntity
	
	self.BattleEntitiesTable = self.Starter.BattleEntitiesTable

	for i,v in SortedPairs(self.Starter.BattleEntitiesTable) do
		if v == self.Starter then continue end
		if !IsValid(v) or IsValid(v) && v:Health() <= 0 then
			table.remove(self.Starter.BattleEntitiesTable,i)
			if v == self.CurrentTurnEntity then -- Current combatant died/got removed, change turns
				self:NextCurrentTurn(true)
			end
		end
	end
	
	if useTurns then
		if self:GetNW2Int("TurnTime") < CurTime() then
			self:NextCurrentTurn()
		end
	end
	for i,v in SortedPairs(self.Starter.BattleEntitiesTable) do
		if IsValid(v) && v:Health() > 0 /*&& self.Starter != v*/ then
			-- print(i,v)
			if usePos then
				if useTurns && currentEnt == v then
					if v.IsVJBaseSNPC then
						if v:GetState() == VJ_STATE_FREEZE then
							v:SetState()
						end
					end
					continue
				end
				-- local pos = self:GetSetPos(i,v == self.Starter or VJ_HasValue(self.Party,v))
				-- print(v,i,pos)
				-- if v:GetPos() != pos then
					-- v:SetPos(pos)
				-- end
				if v:IsNPC() && v:IsMoving() then
					v:StopMoving()
					v:ClearSchedule()
					v:ClearGoal()
				end
				if v.IsVJBaseSNPC then
					-- v.DisableChasingEnemy = true
					-- v:SetState(VJ_STATE_ONLY_ANIMATION)
					v:SetState(VJ_STATE_FREEZE)
				end
			end
		end
	end
end
---------------------------------------------------------------------------------------------------------------------------------------------
function ENT:OnRemove()
	local usePos = self.UsePositions
	for i,v in pairs(self.Starter.BattleEntitiesTable) do
		if IsValid(v) && v:Health() > 0 && self.Starter != v then
			-- if usePos then v.DisableChasingEnemy = v:GetNW2Bool("VJ_P_DisableChasingEnemy") end
			-- v.HasMeleeAttack = v:GetNW2Bool("VJ_P_HasMeleeAttack")
			-- v.HasRangeAttack = v:GetNW2Bool("VJ_P_HasRangeAttack")
			-- v.HasLeapAttack = v:GetNW2Bool("VJ_P_HasLeapAttack")
			-- v.HasGrenadeAttack = v:GetNW2Bool("VJ_P_HasGrenadeAttack")
			-- v.CanUseSecondaryOnWeaponAttack = v:GetNW2Bool("VJ_P_CanUseSecondaryOnWeaponAttack")
			-- v.NextWeaponAttackT = 0
			v:SetState()
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
