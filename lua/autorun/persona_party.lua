local PLY = FindMetaTable("Player")
local NPC = FindMetaTable("NPC")

function NPC:GetFullParty(ignoreMe)
	self.Persona_Party = self.Persona_Party or {}
	local tbl = {}
	for i,v in pairs(self.Persona_Party) do
		if IsValid(v) then
			if ignoreMe && v == self then continue end
			table.insert(tbl,v)
		else
			table.remove(self.Persona_Party,i)
		end
	end
	return tbl
end

function NPC:AddToParty(ent)
	if ent.VJ_CanBeAddedToParty then
		self.Persona_Party = self.Persona_Party or {}
		table.insert(self.Persona_Party,ent)
	end
end

function NPC:RemoveFromParty(ent)
	self.Persona_Party = self.Persona_Party or {}
	for i,v in pairs(self.Persona_Party) do
		if v == self then
			table.remove(self.Persona_Party,i)
			break
		end
	end
end

function NPC:ClearParty()
	self.Persona_Party = self.Persona_Party or {}
	table.Empty(self.Persona_Party)
end

function PLY:GetFullParty(ignoreMe)
	if self.Persona_NPC_Party == nil then
		self.Persona_NPC_Party = {}
	end
	if self.Persona_SV_Party == nil then
		self.Persona_SV_Party = {}
	end
	local tbl = {}
	for _,v in ipairs(self.Persona_SV_Party) do
		for _,ply in ipairs(player.GetAll()) do
			if ply:UniqueID() == v then
				table.insert(tbl,ply)
			end
		end
	end
	if ignoreMe then
		for i,v in ipairs(tbl) do
			if self == v then
				table.remove(tbl,i)
			end
		end
	end
	for i,v in pairs(tbl) do
		if !IsValid(v) then
			table.remove(tbl,i)
		end
	end
	for i,v in pairs(self.Persona_NPC_Party) do
		if !IsValid(v) then
			table.remove(self.Persona_NPC_Party,i)
		end
	end
	table.Add(tbl,self.Persona_NPC_Party)
	return tbl
end

function PLY:GetParty_NPC()
	if self.Persona_NPC_Party == nil then
		return {}
	end
	return self.Persona_NPC_Party
end

function PLY:CreateParty_NPC(ent)
	self.Persona_NPC_Party = {}
	table.insert(self.Persona_NPC_Party,ent)
	if ent.VJ_CanBeAddedToParty then
		ent.Persona_Party = ent.Persona_Party or {}
		table.insert(ent.Persona_Party,self)
	end
	ent:AddEntityRelationship(self,D_LI,99)
	ent.FollowingPlayer = false
	ent.FollowPlayer_GoingAfter = false
	ent.FollowPlayer_Entity = NULL
	ent.GuardingPosition = nil
	ent.GuardingFacePosition = nil
	ent.FollowPlayer_Entity = self
	ent.FollowingPlayer = true
	ent:PlaySoundSystem("FollowPlayer")
	ent:SetTarget(self)
	if ent:BusyWithActivity() == false then -- Face the player and then walk or run to it
		ent:StopMoving()
		ent:VJ_TASK_FACE_X("TASK_FACE_TARGET", function(x)
			x.RunCode_OnFinish = function()
				local movet = ((ent:GetPos():Distance(ent.FollowPlayer_Entity:GetPos()) < 220) and "TASK_WALK_PATH") or "TASK_RUN_PATH"
				ent:VJ_TASK_GOTO_TARGET(movet, function(y) y.CanShootWhenMoving = true y.ConstantlyFaceEnemy = true end) 
			end
		end)
	end
	if IsValid(self.Persona_BattleEntity) then self.Persona_BattleEntity:UpdateParty() end
end

function PLY:AddToParty_NPC(ent)
	self:ChatPrint("Sent Party Invite To " .. ent:GetName() .. "!")

	net.Start("persona_party_npc")
		net.WriteEntity(self)
		net.WriteEntity(ent)
		net.WriteBool(false)
	net.Send(self)

	if self.Persona_NPC_Party == nil or #self:GetParty_NPC() == 0 then
		self:CreateParty_NPC(ent)
		return
	end
	if VJ_HasValue(self.Persona_NPC_Party,ent) then
		return
	end
	table.insert(self.Persona_NPC_Party,ent)
	if ent.VJ_CanBeAddedToParty then
		ent.Persona_Party = ent.Persona_Party or {}
		table.insert(ent.Persona_Party,self)
	end
	ent:AddEntityRelationship(self,D_LI,99)
	ent.FollowingPlayer = false
	ent.FollowPlayer_GoingAfter = false
	ent.FollowPlayer_Entity = NULL
	ent.GuardingPosition = nil
	ent.GuardingFacePosition = nil
	ent.FollowPlayer_Entity = self
	ent.FollowingPlayer = true
	ent:PlaySoundSystem("FollowPlayer")
	ent:SetTarget(self)
	if ent:BusyWithActivity() == false then -- Face the player and then walk or run to it
		ent:StopMoving()
		ent:VJ_TASK_FACE_X("TASK_FACE_TARGET", function(x)
			x.RunCode_OnFinish = function()
				local movet = ((ent:GetPos():Distance(ent.FollowPlayer_Entity:GetPos()) < 220) and "TASK_WALK_PATH") or "TASK_RUN_PATH"
				ent:VJ_TASK_GOTO_TARGET(movet, function(y) y.CanShootWhenMoving = true y.ConstantlyFaceEnemy = true end) 
			end
		end)
	end
	if IsValid(self.Persona_BattleEntity) then self.Persona_BattleEntity:UpdateParty() end
end

function PLY:RemoveFromParty_NPC(ent)
	self:ChatPrint("Removed " .. ent:GetName() .. " From The Party!")

	net.Start("persona_party_npc")
		net.WriteEntity(self)
		net.WriteEntity(ent)
		net.WriteBool(true)
	net.Send(self)

	if self.Persona_NPC_Party == nil or #self:GetParty_NPC() == 0 then
		return
	end
	for i,v in pairs(self.Persona_NPC_Party) do
		if v == ent then
			table.remove(self.Persona_NPC_Party,i)
			break
		end
	end
	if ent.VJ_CanBeAddedToParty then
		ent.Persona_Party = ent.Persona_Party or {}
		for i,v in pairs(ent.Persona_Party) do
			if v == self then
				table.remove(ent.Persona_Party,i)
				break
			end
		end
	end
	ent:FollowPlayerReset()
end

function PLY:ClearParty_NPC()
	self:ChatPrint("Cleared Party!")
	self.Persona_NPC_Party = self.Persona_NPC_Party or {}
	for pi,ent in pairs(self.Persona_NPC_Party) do
		if IsValid(ent) then
			if ent.VJ_CanBeAddedToParty then
				ent.Persona_Party = ent.Persona_Party or {}
				for i,v in pairs(ent.Persona_Party) do
					if v == self then
						table.remove(ent.Persona_Party,i)
						break
					end
				end
			end
			ent:FollowPlayerReset()
		end
	end
	table.Empty(self.Persona_NPC_Party)
	net.Start("persona_party_npc")
		net.WriteEntity(self)
		net.WriteEntity(Entity(0))
		net.WriteBool(false)
	net.Send(self)
end

function PLY:GetParty()
	if self.Persona_SV_Party == nil then
		return {}
	end
	return self.Persona_SV_Party
end

function PLY:CreateParty(ent)
	self.Persona_SV_Party = {}
	table.insert(self.Persona_SV_Party,ent:UniqueID())
end

function PLY:AddToParty(ent)
	if ent:IsNPC() then
		self:AddToParty_NPC(ent)
		return
	end
	net.Start("persona_party")
		net.WriteEntity(self)
		net.WriteEntity(ent)
		net.WriteBool(false)
	net.Send(self)

	self:ChatPrint("Sent Party Invite To " .. ent:Nick() .. "!")

	if self.Persona_SV_Party == nil or #self:GetParty() == 0 then
		self:CreateParty(ent)
		return
	end
	if VJ_HasValue(self.Persona_SV_Party,ent:UniqueID()) then
		return
	end
	table.insert(self.Persona_SV_Party,ent:UniqueID())
	-- print("ADD")
end

function PLY:RemoveFromParty(ent)
	if ent:IsNPC() then
		self:RemoveFromParty_NPC(ent)
		return
	end
	-- print(ent)
	net.Start("persona_party")
		net.WriteEntity(self)
		net.WriteEntity(ent)
		net.WriteBool(true)
	net.Send(self)

	self:ChatPrint("Removed " .. ent:Nick() .. " From The Party!")

	if self.Persona_SV_Party == nil or #self:GetParty() == 0 then
		return
	end
	for key,id in pairs(self.Persona_SV_Party) do
		if id == ent:UniqueID() then
			table.remove(self.Persona_SV_Party,key)
			break
		end
	end
	-- print("REMOVE")
end

function PLY:ClearParty()
	self:ClearParty_NPC()
	net.Start("persona_party")
		net.WriteEntity(self)
		net.WriteEntity(Entity(0))
		net.WriteBool(false)
	net.Send(self)

	self:ChatPrint("Cleared Party!")

	self.Persona_SV_Party = self.Persona_SV_Party or {}
	table.Empty(self.Persona_SV_Party)
	-- print("CLEAR")
end

if CLIENT then
	net.Receive("persona_party_npc",function(len,pl)
		local ply = net.ReadEntity()
		local member = net.ReadEntity()
		local remove = net.ReadBool()

		if member == Entity(0) then
			ply:DisbandParty()
			ply:EmitSound("cpthazama/persona5/misc/00102.wav")
			return
		end
		if remove == true then
			ply:RemoveFromParty(member)
			ply:EmitSound("cpthazama/persona5/misc/00101.wav")
			return
		end
		ply:AddToParty(member)
		ply:EmitSound("cpthazama/persona5/misc/00100.wav")
	end)

	net.Receive("persona_party",function(len,pl)
		local ply = net.ReadEntity()
		local member = net.ReadEntity()
		local remove = net.ReadBool()

		if member == Entity(0) then
			ply:DisbandParty()
			ply:EmitSound("cpthazama/persona5/misc/00102.wav")
			return
		end
		if remove == true then
			ply:RemoveFromParty(member)
			ply:EmitSound("cpthazama/persona5/misc/00101.wav")
			return
		end
		ply:AddToParty(member)
		ply:EmitSound("cpthazama/persona5/misc/00100.wav")
	end)

	local PLY = FindMetaTable("Player")

	function PLY:CreateParty(ent)
		self.Persona_Party = {}
		table.insert(self.Persona_Party,ent:IsPlayer() && ent:UniqueID() or ent)
	end

	function PLY:DisbandParty()
		self.Persona_Party = self.Persona_Party or {}
		for _,v in pairs(self.Persona_Party) do
			-- if v:IsPlayer() then
			if type(v) == "string" then
				local member = player.GetByUniqueID(v)
				if member && member.Persona_HUD_Avatar then
					member.Persona_HUD_Avatar:Remove()
				end
			else
				if IsValid(v) && v.Persona_HUD_Avatar then
					member.Persona_HUD_Avatar:Remove()
				end
			end
		end
		table.Empty(self.Persona_Party)
	end

	function PLY:AddToParty(ent)
		if self.Persona_Party == nil or #self:GetParty() == 0 then
			self:CreateParty(ent)
			return
		end
		if VJ_HasValue(self.Persona_Party,ent:IsPlayer() && ent:UniqueID() or ent) then
			return
		end
		table.insert(self.Persona_Party,ent:IsPlayer() && ent:UniqueID() or ent)
	end

	function PLY:RemoveFromParty(ent)
		if self.Persona_Party == nil or #self:GetParty() == 0 then
			return
		end
		for key,id in pairs(self.Persona_Party) do
			if ent:IsPlayer() && id == ent:UniqueID() or ent:IsNPC() && id == ent then
				if ent.Persona_HUD_Avatar then
					ent.Persona_HUD_Avatar:Remove()
				end
				table.remove(self.Persona_Party,key)
				break
			end
		end
	end

	function PLY:GetParty()
		if self.Persona_Party == nil then
			return {}
		end
		return self.Persona_Party
	end

	hook.Add("EntityRemoved","Persona_Party_NPC",function(ent)
		local ply = LocalPlayer()
		if !IsValid(ply) then return end
		if ent:IsNPC() && ply:GetParty() then
			if VJ_HasValue(ply.Persona_Party,ent) then
				ply:RemoveFromParty(ent)
				ply:EmitSound("cpthazama/persona5/misc/00101.wav")
			end
		end
	end)
	
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

	local color = Color
	hook.Add("HUDPaint","Persona_HUD_Party",function()
		local ply = LocalPlayer()
		local persona = ply:GetNW2Entity("PersonaEntity")

		if #ply:GetParty() <= 0 then
			return
		end

		local function Persona_DrawAvatar(ply,size,posX,posY,leader)
			if ply:IsNPC() then
				if !VJ_HasValue(leader.Persona_Party,ply) then
					return
				end
				local png = "materials/entities/" .. ply:GetClass() .. ".png"
				local vmt = "materials/vgui/entities/" .. ply:GetClass() .. ".vmt"
				local iconExists = file.Exists("GAME",png)
				local icon = png
					surface.SetMaterial(Material(icon) or Material(vmt))
					surface.SetDrawColor(255,255,255,255)
					surface.DrawTexturedRect(ScrW() -posX,ScrH() -posY,size,size)
			else
				if !IsValid(ply.Persona_HUD_Avatar) then
					ply.Persona_HUD_Avatar = vgui.Create("AvatarImage",Panel)
					ply.Persona_HUD_Avatar:SetPos(ScrW() -posX,ScrH() -posY)
					ply.Persona_HUD_Avatar:SetSize(size,size)
					ply.Persona_HUD_Avatar:SetPlayer(ply,size)
					ply.Persona_HUD_Avatar:ParentToHUD()
					ply.Persona_HUD_Avatar.Size = size
					ply.Persona_HUD_Avatar.PosX = posX
					ply.Persona_HUD_Avatar.PosY = posY
				else
					if !VJ_HasValue(leader.Persona_Party,ply:UniqueID()) then
						ply.Persona_HUD_Avatar:Remove()
					end
					if ply.Persona_HUD_Avatar.Size != size || ply.Persona_HUD_Avatar.PosX != posX || ply.Persona_HUD_Avatar.PosY != posY then
						ply.Persona_HUD_Avatar:Remove()
					end
				end
			end
		end

		local function Persona_DrawHUD(ply,memberCount,memberPos,leader)
			if IsValid(ply) then
				local personaEnt = ply:GetNW2Entity("PersonaEntity")
				local hp = ply:Health()
				local hpMax = ply:GetMaxHealth()
				local sp = ply:GetSP()
				local spMax = ply:GetMaxSP()
				local usesHP = IsValid(personaEnt) && personaEnt:GetNW2Bool("SpecialAttackUsesHP") or false
				local cost = IsValid(personaEnt) && personaEnt:GetNW2Int("SpecialAttackCost") or 0
				local lvl = ply:GetNW2Int("PXP_Level")
				local persona = ply:IsPlayer() && PERSONA[ply:GetNW2String("PersonaName")].Name or (ply:GetPersonaName() && PERSONA[ply:GetPersonaName()] && PERSONA[ply:GetPersonaName()].Name or ply:GetPersonaName() or "BLANK")

				local corners = 1
				local posX = 340
				-- local posY = math.ceil(memberPos +30 +(memberPos *0.75 +15) *(memberCount -1))
				local posY = 1450 -((110 *memberCount))
				local len = posX -15
				local height = 100
				local colM = 35
				local boxX = posX
				local boxHeight = posY
				draw.RoundedBox(corners,ScrW() -posX,ScrH() -posY,len,height,color(colM,colM,colM,255))

				if ply.csp_lerp_hp == nil then
					ply.csp_lerp_hp = 1
					ply.csp_lerp_sp = 1
				end
				ply.csp_lerp_hp = Lerp(5 *FrameTime(), ply.csp_lerp_hp, hp)
				ply.csp_lerp_sp = Lerp(5 *FrameTime(), ply.csp_lerp_sp, sp)
				local perHPB = ply.csp_lerp_hp *100 /hpMax
				local perSPB = ply.csp_lerp_sp *100 /spMax
				
				Persona_DrawAvatar(ply,90,boxX -5,boxHeight -5,leader)

				local r,g,b = 107, 255, 222
				local posX = boxX -105
				local posY = posY -5
				local len = posX -25
				local height = 20

				// HP Bar
				local f = math.Clamp(perHPB *0.01 *len,0,len)
				draw.RoundedBox(corners, ScrW() -posX, ScrH() -posY, len, height, color(0, 0, 0, 150))
				draw.RoundedBox(corners, ScrW() -posX, ScrH() -posY, f, height, color(r, g, b, 255))
				
				r,g,b = 255, 101, 239
				if usesHP then
					r,g,b = 107, 255, 222
				end
				local posX = boxX -105
				local posY = posY -25
				local len = posX -25
				local height = 20

				// SP Bar
				draw.RoundedBox(corners, ScrW() -posX, ScrH() -posY, len, height, color(0, 0, 0, 150))
				draw.RoundedBox(corners, ScrW() -posX, ScrH() -posY, math.Clamp(perSPB *0.01 *len,0,len), height, color(r, g, b, 255))

				r,g,b = 200, 0, 0
				local text = "Level " .. lvl
				local posX = boxX -105
				local posY = posY -30
				local canShowXP = true
				if lvl == 99 then
					text = "MAX"
					local rgb = HSL((RealTime() *150 -(0 *15)),128,128)
					r,g,b = rgb.r, rgb.g, rgb.b
					canShowXP = false
				end
				draw.SimpleText(text,"Persona",ScrW() -posX,ScrH() -posY,color(r, g, b, 255))

				-- r,g,b = 200, 0, 0
				-- local text = ply:IsPlayer() && ply:Nick() or language.GetPhrase(ply:GetClass())
				-- local posX = boxX -105
				-- local posY = posY -40
				-- draw.SimpleText(text,"PXP_EXP",ScrW() -posX,ScrH() -posY,color(r, g, b, 255))

				-- local text = ply:IsPlayer() && ply:Nick() or language.GetPhrase(ply:GetClass())
				-- local posX = boxX -5
				-- local posY = boxHeight -68
				-- local color = Color(248,60,64,255)
				-- draw.SimpleText(text,"PXP_EXP",ScrW() -posX,ScrH() -posY,color)

				-- local text = persona
				-- local posX = boxX -len +180
				-- local posY = boxHeight -10
				-- local color = Color(0,100,255,255)
				-- draw.SimpleText(text,"PXP_EXP",ScrW() -posX,ScrH() -posY,color)

				-- local text = "HP:"
				-- local posX = boxX -len +100
				-- local posY = boxHeight -45
				-- local color = Color(33,200,0,255)
				-- draw.SimpleText(text,"PXP_EXP",ScrW() -posX,ScrH() -posY,color)

				-- local text = hp < 1000 && hp or "999"
				-- local posX = boxX -len +50
				-- local posY = boxHeight -45
				-- local color = Color(33,200,0,255)
				-- draw.SimpleText(text,"PXP_EXP",ScrW() -posX,ScrH() -posY,color)

				-- local text = "SP:"
				-- local posX = boxX -len +99
				-- local posY = boxHeight -70
				-- local color = Color(200,0,255,255)
				-- draw.SimpleText(text,"PXP_EXP",ScrW() -posX,ScrH() -posY,color)

				-- local text = sp
				-- local posX = boxX -len +50
				-- local posY = boxHeight -70
				-- local color = Color(200,0,255,255)
				-- draw.SimpleText(text,"PXP_EXP",ScrW() -posX,ScrH() -posY,color)

				-- local text = "LVL " .. lvl
				-- local posX = boxX -len +180
				-- local posY = boxHeight -40
				-- local color = Color(200,0,255,255)
				-- draw.SimpleText(text,"Persona_Small",ScrW() -posX,ScrH() -posY,color)
			end
		end

		local memberCount = 0
		local memberPos = 950
		for _,v in pairs(ply:GetParty()) do
			if type(v) != "string" && v:IsNPC() then
				memberCount = memberCount +1
				Persona_DrawHUD(v,memberCount,memberPos,ply)
			else
				local member = player.GetByUniqueID(v)
				if member then
					memberCount = memberCount +1
					Persona_DrawHUD(member,memberCount,memberPos,ply)
				end
			end
		end
	end)
end

if SERVER then
	local function partyCommand(ply)
		ply.Persona_PartyCommand = ply.Persona_PartyCommand or CurTime()
		if ply:Alive() then
			if CurTime() > ply.Persona_PartyCommand then
				local ent = ply:GetEyeTrace().Entity
				if ent:GetPos():Distance(ply:GetPos()) <= 300 then
					if ent:IsPlayer() then
						ply:AddToParty(ent)
					else
						ply:AddToParty_NPC(ent)
					end
				end
				ply.Persona_PartyCommand = CurTime() +0.5
			end
		end
	end
	concommand.Add("persona_party",partyCommand)

	local function partyRemoveCommand(ply)
		ply.Persona_PartyCommand = ply.Persona_PartyCommand or CurTime()
		if ply:Alive() then
			if CurTime() > ply.Persona_PartyCommand then
				local ent = ply:GetEyeTrace().Entity
				if ent:GetPos():Distance(ply:GetPos()) <= 300 then
					if ent:IsPlayer() then
						ply:RemoveFromParty(ent)
					else
						ply:RemoveFromParty_NPC(ent)
					end
				end
				ply.Persona_PartyCommand = CurTime() +0.5
			end
		end
	end
	concommand.Add("persona_partyremove",partyRemoveCommand)

	local function partyClearCommand(ply)
		ply.Persona_PartyCommand = ply.Persona_PartyCommand or CurTime()
		if CurTime() > ply.Persona_PartyCommand then
			ply:ClearParty()
			ply:ClearParty_NPC()
			ply.Persona_PartyCommand = CurTime() +0.5
		end
	end
	concommand.Add("persona_partyclear",partyClearCommand)
end