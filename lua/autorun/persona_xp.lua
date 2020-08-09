PXP = {}

PXP.SetEXP = function(ply,xp)
	local oldXP = PXP.GetEXP(ply)
	-- ply:SetNWInt("PXP_EXP",xp)
	PXP.SetPersonaData(ply,1,xp)
	ply:SetNWInt("PXP_EXP",xp)
	if PXP.GetLevel(ply) < 99 && PXP.GetPersonaData(ply,1) >= PXP.GetRequiredXP(ply) then
		PXP.LevelUp(ply)
	end
	-- PXP.SavePersonaData(ply)
end

PXP.GiveEXP = function(ply,xp)
	local oldXP = PXP.GetEXP(ply)
	if ply:IsPlayer() then
		ply:ChatPrint("You've earned " .. ((oldXP +xp) -oldXP) .. " EXP!")
		ply:EmitSound("cpthazama/persona4/ui_skillup.wav")
	end
	PXP.SetEXP(ply,oldXP +xp,true)
end

PXP.GiveRequiredEXP = function(ply)
	PXP.SetEXP(ply,PXP.GetRequiredXP(ply),true)
end

PXP.GetEXP = function(ply)
	return PXP.GetPersonaData(ply,1)
end

PXP.SetLevel = function(ply,lvl,chat)
	-- ply:SetNWInt("PXP_Level",lvl)
	PXP.SetPersonaData(ply,2,lvl)
	-- if lvl != ply:GetNWInt("PXP_Level") then PXP.CalculateRequiredXP(ply) end
	if ply:IsPlayer() && chat then
		ply:ChatPrint("You're now level " .. lvl)
		ply:EmitSound("cpthazama/persona4/ui_skillup.wav")
	end
	ply:SetNWInt("PXP_Level",lvl)
	-- PXP.SavePersonaData(ply)
end

PXP.GetLevel = function(ply)
	return PXP.GetPersonaData(ply,2)
end

PXP.SetRequiredXP = function(ply,amount)
	ply:SetNWInt("PXP_RequiredEXP",amount)
	PXP.SetPersonaData(ply,6,amount)
	-- PXP.SavePersonaData(ply)
end

PXP.GetRequiredXP = function(ply)
	return PXP.GetLevel(ply) == 99 && 0 or PXP.GetPersonaData(ply,6)
end

PXP.CalculateRequiredXP = function(ply)
	-- local formula = (75 *(PXP.GetLevel(ply) -1) +200)
	local formula = PXP.GetLevel(ply) *1500
	local mRequiredXP = formula
	PXP.SetRequiredXP(ply,mRequiredXP)
end

PXP.FindRemainingXP = function(ply)
	return PXP.GetRequiredXP(ply) -PXP.GetEXP(ply)
end

PXP.ManagePersonaStats = function(ply,chat)
	local persona = ply:GetPersona()
	if IsValid(persona) then
		local add = PXP.GetLevel(ply) -persona.BaseLevel
		persona.Stats.STR = persona.BaseSTR +add
		persona.Stats.MAG = persona.BaseMAG +add
		persona.Stats.END = persona.BaseEND +add
		persona.Stats.AGI = persona.BaseAGI +add
		persona.Stats.LUC = persona.BaseLUC +add

		PXP.SavePersonaStats(ply)
	end
end

PXP.GetPersonaStats = function(ply)
	return PXP.GetPersonaData(ply,7)
end

PXP.SavePersonaStats = function(ply)
	local persona = ply:GetPersona()
	if IsValid(persona) then
		local tbl = persona.Stats
		local save = {}
		save.STR = tbl.STR
		save.MAG = tbl.MAG
		save.END = tbl.END
		save.AGI = tbl.AGI
		save.LUC = tbl.LUC
		PXP.SetPersonaData(ply,7,save)
	end
end

PXP.LevelUp = function(ply)
	if PXP.GetLevel(ply) == 99 then return end
	PXP.SetLevel(ply,PXP.GetLevel(ply) +1,true)
	PXP.CalculateRequiredXP(ply)

	local persona = ply:GetPersona()
	if IsValid(persona) then
		persona:CheckSkillLevel()
		PXP.ManagePersonaStats(ply,chat)
		-- persona:UpdateStats()
	end

	ply:EmitSound("cpthazama/persona4/ui_lvlup.wav")
	if PXP.GetPersonaData(ply,1) >= PXP.GetRequiredXP(ply) then
		PXP.LevelUp(ply)
	else
		PXP.SetEXP(ply,0)
	end
end

PXP.SetCompendium = function(ply,com)
	ply.PXP_Compendium = com
end

PXP.AddToCompendium = function(ply,persona)
	if ply.PXP_Compendium == nil then ply.PXP_Compendium = {} end
	if !VJ_HasValue(ply.PXP_Compendium,persona) then
		table.insert(ply.PXP_Compendium,persona)
		if ply:IsPlayer() then
			ply:ChatPrint("You've obtained " .. PERSONA[persona].Name .. " as a new Persona!")
			ply:EmitSound("cpthazama/persona4/ui_obtainpersona.wav")
		end
		PXP.SetPersonaData(ply,4,ply.PXP_Compendium)
	end
	-- PXP.SavePersonaData(ply,true)
end

PXP.GetCompendium = function(ply)
	return PXP.GetPersonaData(ply,4)
end

PXP.ResetXPStats = function(ply)
	ply:SetNWInt("PXP_NextEXPChange",CurTime() +1)
	PXP.SetEXP(ply,0)
	PXP.SetLevel(ply,0)
	PXP.SetRequiredXP(ply,200)
	ply:ChatPrint("All Stats Reset!")
end

PXP.GetDataStorage = function()
	local dir = "persona/data/"
	file.CreateDir(dir)
	return dir
end

PXP.DataExists = function(ent,tbData)
	local count = 0
	for _,v in pairs(tbData) do
		if file.Exists(v,"DATA") then
			count = count +1
		end
	end
	return count == #tbData
end

PXP.GetPersonaData = function(ply,type)
	local name = ply:GetPersonaName() or PXP.GetPersonaData(ply,5)
	local dir = PXP.GetDataStorage() .. string.gsub(ply:SteamID(),":","_")
	if type == 5 then -- Last Persona
		local persona = file.Read(dir .. "_PERSONA.txt","DATA")
		if persona == nil then
			PXP.WriteFile(dir .. "_PERSONA.txt","izanagi")
			persona = "izanagi"
		end
		return persona
	end
	if name then
		if type == 1 then -- EXP
			return tonumber(file.Read(dir .. "_" .. name .. "_EXP.txt","DATA") or 0) or 0
		elseif type == 2 then -- Level
			return tonumber(file.Read(dir .. "_" .. name .. "_LEVEL.txt","DATA") or 0) or 0
		elseif type == 3 then -- Skills
			return PXP.ReadDataTable(dir .. "_" .. name .. "_SKILLS.txt","DATA") or {}
		elseif type == 4 then -- Compendium
			return PXP.ReadDataTable(dir .. "_" .. name .. "_COMPENDIUM.txt","DATA") or {}
		elseif type == 6 then -- Req
			return tonumber(file.Read(dir .. "_" .. name .. "_REQ.txt","DATA") or 0) or 0
		elseif type == 7 then -- Stats
			return PXP.ReadDataTable(dir .. "_" .. name .. "_STATS.txt","DATA") or {}
		end
	end
end

PXP.SetPersonaData = function(ply,type,val)
	local name = ply:GetPersonaName() or PXP.GetPersonaData(ply,5)
	local dir = PXP.GetDataStorage() .. string.gsub(ply:SteamID(),":","_")
	if type == 5 then -- Last Persona
		PXP.WriteFile(dir .. "_PERSONA.txt",val)
		return
	end
	if name then
		if type == 1 then -- EXP
			PXP.WriteFile(dir .. "_" .. ply:GetPersonaName() .. "_EXP.txt",val)
			ply:SetNWInt("PXP_EXP",val)
		elseif type == 2 then -- Level
			PXP.WriteFile(dir .. "_" .. ply:GetPersonaName() .. "_LEVEL.txt",val)
			ply:SetNWInt("PXP_Level",val)
		elseif type == 3 then -- Skills
			PXP.WriteTable(dir .. "_" .. ply:GetPersonaName() .. "_SKILLS.txt","Skills",val,true)
		elseif type == 4 then -- Compendium
			PXP.WriteTable(dir .. "_COMPENDIUM.txt","Compendium",val,true)
		elseif type == 6 then -- Req
			PXP.WriteFile(dir .. "_" .. ply:GetPersonaName() .. "_REQ.txt",val)
			ply:SetNWInt("PXP_RequiredEXP",val)
		elseif type == 7 then -- Stats
			PXP.WriteTable(dir .. "_" .. ply:GetPersonaName() .. "_STATS.txt","Stats",val,true)
		end
	end
end

PXP.SavePersonaData = function(ply,exp,level,cards)
	local dir = PXP.GetDataStorage() .. string.gsub(ply:SteamID(),":","_")

	PXP.SetPersonaData(ply,1,exp)
	PXP.SetEXP(ply,exp)
	PXP.SetPersonaData(ply,2,level)
	PXP.SetLevel(ply,level)
	PXP.SetPersonaData(ply,3,cards)
	PXP.SetPersonaData(ply,4,ply.PXP_Compendium)
	PXP.CalculateRequiredXP(ply)
	PXP.ManagePersonaStats(ply)
	PXP.SavePersonaStats(ply)
end

PXP.ReadCompendium = function(ply)
	return PXP.ReadDataTable(PXP.GetDataStorage() .. string.gsub(ply:SteamID(),":","_") .. "_COMPENDIUM.txt")
end

PXP.WriteFile = function(dir,cont)
	file.Write(dir,tostring(cont))
end

PXP.WriteTable = function(dir,name,cont,erase)
	if erase then
		file.Write(dir,util.TableToJSON({Name = name,Set = cont},true))
		return
	end
	file.Append(dir,util.TableToJSON({Name = name,Set = cont},true))
end

PXP.ReadDataTable = function(dir)
	local data = file.Read(dir,"DATA")
	if tbl == nil then return end
	local json = util.JSONToTable(data)
	local tbData = {}
	if json && json.Name && json.Set then
		for _,v in pairs(json.Set) do
			table.insert(tbData,v)
		end
	end
	return tbData
end