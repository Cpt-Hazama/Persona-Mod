local PLY = FindMetaTable("Player")
local NPC = FindMetaTable("NPC")

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
	-- print(ent)
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
		table.insert(self.Persona_Party,ent:UniqueID())
	end

	function PLY:DisbandParty()
		self.Persona_Party = self.Persona_Party or {}
		for _,v in pairs(self.Persona_Party) do
			local member = player.GetByUniqueID(v)
			if member && member.Persona_HUD_Avatar then
				member.Persona_HUD_Avatar:Remove()
			end
		end
		table.Empty(self.Persona_Party)
	end

	function PLY:AddToParty(ent)
		if self.Persona_Party == nil or #self:GetParty() == 0 then
			self:CreateParty(ent)
			return
		end
		if VJ_HasValue(self.Persona_Party,ent:UniqueID()) then
			return
		end
		table.insert(self.Persona_Party,ent:UniqueID())
	end

	function PLY:RemoveFromParty(ent)
		if self.Persona_Party == nil or #self:GetParty() == 0 then
			return
		end
		for key,id in pairs(self.Persona_Party) do
			if id == ent:UniqueID() then
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

	hook.Add("HUDPaint","Persona_HUD_Party",function()
		local ply = LocalPlayer()
		local persona = ply:GetNWEntity("PersonaEntity")

		if #ply:GetParty() <= 0 then
			return
		end

		local function Persona_DrawAvatar(ply,size,posX,posY,leader)
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

		local function Persona_DrawHUD(ply,memberCount,memberPos,leader)
			if IsValid(ply) then
				local hp = ply:Health()
				local hpMax = ply:GetMaxHealth()
				local sp = ply:GetSP()
				local spMax = ply:GetMaxSP()
				local persona = PERSONA[ply:GetNWString("PersonaName")].Name

				local corners = 1
				local posX = 275
				-- local posY = math.ceil(memberPos +30 +(memberPos *0.75 +15) *(memberCount -1))
				local posY = 1150 -((110 *memberCount))
				local len = 250
				local height = 100
				local colM = 35
				local color = Color(colM,colM,colM,255)
				local boxX = posX
				local boxHeight = posY
				draw.RoundedBox(corners,ScrW() -posX,ScrH() -posY,len,height,color)
				
				Persona_DrawAvatar(ply,60,boxX,boxHeight,leader)

				local text = ply:Nick()
				local posX = boxX -5
				local posY = boxHeight -68
				local color = Color(248,60,64,255)
				draw.SimpleText(text,"PXP_EXP",ScrW() -posX,ScrH() -posY,color)

				local text = persona
				local posX = boxX -len +180
				local posY = boxHeight -10
				local color = Color(0,100,255,255)
				draw.SimpleText(text,"PXP_EXP",ScrW() -posX,ScrH() -posY,color)

				local text = "HP:"
				local posX = boxX -len +100
				local posY = boxHeight -45
				local color = Color(33,200,0,255)
				draw.SimpleText(text,"PXP_EXP",ScrW() -posX,ScrH() -posY,color)

				local text = hp < 1000 && hp or "999"
				local posX = boxX -len +50
				local posY = boxHeight -45
				local color = Color(33,200,0,255)
				draw.SimpleText(text,"PXP_EXP",ScrW() -posX,ScrH() -posY,color)

				local text = "SP:"
				local posX = boxX -len +99
				local posY = boxHeight -70
				local color = Color(200,0,255,255)
				draw.SimpleText(text,"PXP_EXP",ScrW() -posX,ScrH() -posY,color)

				local text = sp
				local posX = boxX -len +50
				local posY = boxHeight -70
				local color = Color(200,0,255,255)
				draw.SimpleText(text,"PXP_EXP",ScrW() -posX,ScrH() -posY,color)
			end
		end

		local memberCount = 0
		local memberPos = 950
		for _,v in pairs(ply:GetParty()) do
			local member = player.GetByUniqueID(v)
			if member then
				memberCount = memberCount +1
				Persona_DrawHUD(member,memberCount,memberPos,ply)
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
				if ent:GetPos():Distance(ply:GetPos()) <= 150 && ent:IsPlayer() then
					ply:AddToParty(ent)
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
				if ent:GetPos():Distance(ply:GetPos()) <= 150 && ent:IsPlayer() then
					ply:RemoveFromParty(ent)
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
			ply.Persona_PartyCommand = CurTime() +0.5
		end
	end
	concommand.Add("persona_partyclear",partyClearCommand)
end