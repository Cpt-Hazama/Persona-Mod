PXP = {}

PXP.SetPoints = function(ply,a)
	if !ply:IsPlayer() then return end
	local oldData = PXP.GetPoints(ply)
	PXP.SetPersonaData(ply,11,a)
end

PXP.GivePoints = function(ply,a)
	if !ply:IsPlayer() then return end
	local oldData = PXP.GetPoints(ply)
	if ply:IsPlayer() then
		ply:ChatPrint("You obtained " .. a .. " Persona Points! You now have " .. oldData +a .. " Persona Points!")
		ply:EmitSound("cpthazama/persona4/ui_skillup.wav")
	end
	PXP.SetPoints(ply,oldData +a)
end

PXP.GetPoints = function(ply)
	if !ply:IsPlayer() then return end
	return PXP.GetPersonaData(ply,11)
end

PXP.SetEXP = function(ply,xp)
	if !ply:IsPlayer() then return end
	local oldXP = PXP.GetEXP(ply)
	-- ply:SetNW2Int("PXP_EXP",xp)
	PXP.SetPersonaData(ply,1,xp)
	ply:SetNW2Int("PXP_EXP",xp)
	if PXP.GetLevel(ply) < 99 && PXP.GetPersonaData(ply,1) >= PXP.GetRequiredXP(ply) then
		PXP.LevelUp(ply)
	end
	-- PXP.SavePersonaData(ply)
end

PXP.RemoveEXP = function(ply,xp) -- Old plan for Overdrive, the consistent file writing caused lag
	if !ply:IsPlayer() then return end
	local level = PXP.GetLevel(ply)
	if PXP.IsLegendary(ply) then
		xp = xp *2
	end
	PXP.SetEXP(ply,PXP.GetEXP(ply) -xp)
	PXP.CalculateRequiredXP(ply)
	if PXP.GetEXP(ply) <= 0 then
		PXP.SetLevel(ply,PXP.GetLevel(ply) -1)
		local req = PXP.CalculateRequiredXP(ply)
		PXP.SetEXP(ply,req -1)
	end
end

PXP.GiveEXP = function(ply,xp)
	if !ply:IsPlayer() then return end
	local oldXP = PXP.GetEXP(ply)
	if PXP.IsLegendary(ply) then
		xp = xp *2
	end
	if ply:IsPlayer() then
		ply:ChatPrint("Your Persona has earned " .. ((oldXP +xp) -oldXP) .. " EXP!")
		ply:EmitSound("cpthazama/persona4/ui_skillup.wav")
	end
	PXP.SetEXP(ply,oldXP +xp,true)
end

PXP.GiveRequiredEXP = function(ply)
	if !ply:IsPlayer() then return end
	PXP.SetEXP(ply,PXP.GetRequiredXP(ply),true)
end

PXP.GetEXP = function(ply)
	if !ply:IsPlayer() then return end
	return PXP.GetPersonaData(ply,1)
end

PXP.SetLegendary = function(ply)
	PXP.SetLevel(ply,0)
	PXP.CalculateRequiredXP(ply)

	local persona = ply:GetPersona()
	if IsValid(persona) then
		if persona.MakeLegendary then
			persona:MakeLegendary()
		end
		PXP.ManagePersonaStats(ply)
	end
	PXP.SetEXP(ply,0)
	PXP.SetPersonaData(ply,8,1)
end

PXP.IsLegendary = function(ply)
	if !ply:IsPlayer() then return end
	return PXP.GetPersonaData(ply,8) == 1
end

PXP.IsVelvet = function(ply)
	if !ply:IsPlayer() then return end
	return PXP.GetPersonaData(ply,8) == 2
end

PXP.SetLevel = function(ply,lvl,chat)
	if !ply:IsPlayer() then return end
	-- ply:SetNW2Int("PXP_Level",lvl)
	PXP.SetPersonaData(ply,2,lvl)
	-- if lvl != ply:GetNW2Int("PXP_Level") then PXP.CalculateRequiredXP(ply) end
	if ply:IsPlayer() && chat then
		ply:ChatPrint(PERSONA[ply:GetPersonaName()].Name .. " is now level " .. lvl)
		ply:EmitSound("cpthazama/persona4/ui_skillup.wav")
	end
	ply:SetNW2Int("PXP_Level",lvl)
	-- PXP.SavePersonaData(ply)
end

PXP.GetLevel = function(ply,name)
	if !ply:IsPlayer() then return end
	return PXP.GetPersonaData(ply,2,name)
end

PXP.SetPlayerLevel = function(ply,lvl,chat)
	if !ply:IsPlayer() then return end
	PXP.SetPersonaData(ply,9,lvl)
	if ply:IsPlayer() && chat then
		ply:ChatPrint("You are now level " .. lvl .. "!")
	end
	ply:SetNW2Int("PXP_Player_Level",lvl)
end

PXP.GetPlayerLevel = function(ply)
	if !ply:IsPlayer() then return end
	return PXP.GetPersonaData(ply,9)
end

PXP.SetPlayerEXP = function(ply,xp)
	if !ply:IsPlayer() then return end
	local oldXP = PXP.GetPlayerEXP(ply)
	PXP.SetPersonaData(ply,10,xp)
	ply:SetNW2Int("PXP_Player_EXP",xp)
	if PXP.GetPlayerLevel(ply) < 99 && PXP.GetPersonaData(ply,10) >= PXP.GetRequiredPlayerXP(ply) then
		PXP.PlayerLevelUp(ply)
	end
	-- PXP.SavePersonaData(ply)
end

PXP.GivePlayerEXP = function(ply,xp)
	if !ply:IsPlayer() then return end
	local oldXP = PXP.GetPlayerEXP(ply)
	if ply:IsPlayer() then
		ply:ChatPrint("You've earned " .. ((oldXP +xp) -oldXP) .. " EXP!")
		ply:EmitSound("cpthazama/persona4/ui_skillup.wav")
	end
	PXP.SetPlayerEXP(ply,oldXP +xp,true)
end

PXP.GiveRequiredPlayerEXP = function(ply)
	if !ply:IsPlayer() then return end
	PXP.SetPlayerEXP(ply,PXP.GetRequiredPlayerXP(ply),true)
end

PXP.GetPlayerEXP = function(ply)
	if !ply:IsPlayer() then return end
	return PXP.GetPersonaData(ply,10)
end

PXP.SetRequiredPlayerXP = function(ply,amount)
	if !ply:IsPlayer() then return end
	ply:SetNW2Int("PXP_Player_RequiredEXP",amount)
	-- PXP.SetPersonaData(ply,6,amount)
	-- PXP.SavePersonaData(ply)
end

PXP.GetRequiredPlayerXP = function(ply)
	if !ply:IsPlayer() then return end
	return PXP.GetPlayerLevel(ply) == 99 && 0 or ply:GetNW2Int("PXP_Player_RequiredEXP")
end

PXP.CalculateRequiredPlayerXP = function(ply)
	if !ply:IsPlayer() then return end
	local formula = PXP.GetPlayerLevel(ply) *1500
	local mRequiredXP = formula
	PXP.SetRequiredPlayerXP(ply,mRequiredXP)
end

PXP.FindRemainingPlayerXP = function(ply)
	if !ply:IsPlayer() then return end
	return PXP.GetRequiredPlayerXP(ply) -PXP.GetPlayerEXP(ply)
end

PXP.SetRequiredXP = function(ply,amount,name)
	if !ply:IsPlayer() then return end
	ply:SetNW2Int("PXP_RequiredEXP",amount)
	PXP.SetPersonaData(ply,6,amount,name)
	-- PXP.SavePersonaData(ply)
end

PXP.PlayerLevelUp = function(ply)
	if !ply:IsPlayer() then return end
	if PXP.GetPlayerLevel(ply) == 99 then return end
	PXP.SetPlayerLevel(ply,PXP.GetPlayerLevel(ply) +1,true)
	PXP.CalculateRequiredPlayerXP(ply)

	ply:EmitSound("cpthazama/persona4/ui_lvlup.wav")
	local toAdd = 0
	if PXP.GetPlayerEXP(ply) > PXP.GetRequiredPlayerXP(ply) then
		toAdd = PXP.GetPlayerEXP(ply) -PXP.GetRequiredPlayerXP(ply)
	end
	PXP.SetPlayerEXP(ply,0 +toAdd)

	if ply.P_LevelUp then ply.P_LevelUp:Stop() end
	ply.P_LevelUp = CreateSound(ply,"cpthazama/persona_shared/levelup.wav")
	ply.P_LevelUp:SetSoundLevel(0)
	ply.P_LevelUp:Play()
	ply.P_LevelUp:ChangeVolume(0.35)
end

PXP.GetRequiredXP = function(ply)
	if !ply:IsPlayer() then return end
	return PXP.GetLevel(ply) == 99 && 0 or PXP.GetPersonaData(ply,6)
end

PXP.CalculateRequiredXP = function(ply,name)
	if !ply:IsPlayer() then return end
	-- local formula = (75 *(PXP.GetLevel(ply) -1) +200)
	local formula = PXP.GetLevel(ply,name) *1500
	PXP.SetRequiredXP(ply,formula,name)
	return formula
end

PXP.FindRemainingXP = function(ply)
	if !ply:IsPlayer() then return end
	return PXP.GetRequiredXP(ply) -PXP.GetEXP(ply)
end

local string_match = string.match
local string_Explode = string.Explode
local string_Replace = string.Replace
local to_number = tonumber
PXP.GetPersonaBaseStats = function(ply,persona)
	local stats = {
		LVL = 0,
		STR = 1,
		MAG = 1,
		END = 1,
		AGI = 1,
		LUC = 1,
		WK = {},
		RES = {},
		NUL = {},
		REF = {},
		ABS = {},
	}

	local name = persona or ply:GetPersonaName()
	for i,v in pairs(baseclass.Get("prop_persona_" .. name)) do
		if i == "Base" && (v != "prop_persona" && v != "prop_persona_rmd") then
			name = string_Replace(v,"prop_persona_","")
			break
		end
	end

	local f = file.Open("entities/prop_persona_" .. name .. "/init.lua","r","LUA")
		local fileData = f:Read(f:Size())
		stats.LVL = to_number(string_match(fileData, "LVL = (%d+)"))
		stats.STR = to_number(string_match(fileData, "STR = (%d+)"))
		stats.MAG = to_number(string_match(fileData, "MAG = (%d+)"))
		stats.END = to_number(string_match(fileData, "END = (%d+)"))
		stats.AGI = to_number(string_match(fileData, "AGI = (%d+)"))
		stats.LUC = to_number(string_match(fileData, "LUC = (%d+)"))

		-- stats.WK = string_Explode(",",string_match(fileData, "WK = {(.+)}")) -- It grabs everything in the string after the table, we only want the table contents
		-- stats.RES = string_Explode(",",string_match(fileData, "RES = {(.+)}"))
		-- stats.NUL = string_Explode(",",string_match(fileData, "NUL = {(.+)}"))
		-- stats.REF = string_Explode(",",string_match(fileData, "REF = {(.+)}"))
		-- stats.ABS = string_Explode(",",string_match(fileData, "ABS = {(.+)}"))
	f:Close()

	if PXP.IsLegendary(ply) then
		stats.LVL = 1
	end

	return stats
end

PXP.GetUpdatedPersonaStats = function(ply,persona)
	local persona = persona or ply:GetPersonaName()
	local baseStats = PXP.GetPersonaBaseStats(ply,persona)
	local currentLevel = PXP.GetLevel(ply)
	local add = currentLevel -baseStats.LVL
	if PXP.IsLegendary(ply) then
		add = add *2
	end

	local stats = {
		LVL = currentLevel,
		STR = baseStats.STR +add,
		MAG = baseStats.MAG +add,
		END = baseStats.END +add,
		AGI = baseStats.AGI +add,
		LUC = baseStats.LUC +add,
	}

	return stats
end

PXP.ManagePersonaStats = function(ply,persona)
	if !ply:IsPlayer() then return end

	local baseStats = PXP.GetPersonaBaseStats(ply)
	local currentLevel = PXP.GetLevel(ply)
	local add = currentLevel -baseStats.LVL
	if PXP.IsLegendary(ply) then
		add = add *2
	end

	if IsValid(persona) then
		persona.Stats.STR = math.Clamp(baseStats.STR +add,1,99)
		persona.Stats.MAG = math.Clamp(baseStats.MAG +add,1,99)
		persona.Stats.END = math.Clamp(baseStats.END +add,1,99)
		persona.Stats.AGI = math.Clamp(baseStats.AGI +add,1,99)
		persona.Stats.LUC = math.Clamp(baseStats.LUC +add,1,99)
	end

	PXP.SavePersonaStats(ply)
end

PXP.GetPersonaStats = function(ply)
	if !ply:IsPlayer() then return end
	return PXP.GetPersonaData(ply,7)
end

PXP.SavePersonaStats = function(ply,persona)
	if !ply:IsPlayer() then return end
	local stats = PXP.GetUpdatedPersonaStats(ply,persona)
	PXP.SetPersonaData(ply,7,stats)
end

PXP.LevelUp = function(ply)
	if !ply:IsPlayer() then return end
	if PXP.GetLevel(ply) == 99 then return end
	PXP.SetLevel(ply,PXP.GetLevel(ply) +1,true)
	PXP.CalculateRequiredXP(ply)

	local persona = ply:GetPersona()
	if IsValid(persona) then
		print(ply,persona,persona.CheckSkillLevel)
		if persona.CheckSkillLevel then
			persona:CheckSkillLevel()
		end
		PXP.ManagePersonaStats(ply,chat)
		-- persona:UpdateStats()
	end

	ply:EmitSound("cpthazama/persona4/ui_lvlup.wav")
	local toAdd = 0
	if PXP.GetEXP(ply) > PXP.GetRequiredXP(ply) then
		toAdd = PXP.GetEXP(ply) -PXP.GetRequiredXP(ply)
	end
	PXP.SetEXP(ply,0 +toAdd)
	-- if PXP.GetPersonaData(ply,1) >= PXP.GetRequiredXP(ply) then
		-- PXP.LevelUp(ply)
	-- else
		-- PXP.SetEXP(ply,0)
	-- end
end

PXP.SetCompendium = function(ply,com)
	if !ply:IsPlayer() then return end
	ply.PXP_Compendium = com
end

PXP.InCompendium = function(ply,findPersona)
	if PERSONA_UNLOCKALL then return true end
	if !ply:IsPlayer() then return end
	local exists = false
	for _,persona in pairs(PXP.GetCompendium(ply)) do
		-- print(persona,findPersona)
		if persona == findPersona then
			-- print("found " .. findPersona)
			exists = true
			break
		end
	end
	return exists
end

PXP.AddToCompendium = function(ply,persona)
	if !ply:IsPlayer() then return end
	if ply.PXP_Compendium == nil then ply.PXP_Compendium = PXP.ReadCompendium(ply) end
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
	if !ply:IsPlayer() then return end
	return PXP.GetPersonaData(ply,4)
end

PXP.ResetXPStats = function(ply)
	if !ply:IsPlayer() then return end
	ply:SetNW2Int("PXP_NextEXPChange",CurTime() +1)
	PXP.SetEXP(ply,0)
	PXP.SetLevel(ply,0)
	PXP.SetRequiredXP(ply,200)
	ply:ChatPrint("All Stats Reset!")
end

PXP.GetDataStorage = function(test)
	local dir = test && "persona/data_test/" or "persona/data/"
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

PXP.SetSocialLinkData = function(ply,char,rank)
	if !ply:IsPlayer() then return end
	local dir = PXP.GetDataStorage() .. string.gsub(ply:SteamID(),":","_")
	ply:ChatPrint("Your Social Link with " .. char .. " has increased to " .. tostring(rank) .. "!")
	ply:EmitSound("cpthazama/persona5/misc/00108_streaming.wav")
	PXP.WriteFile(dir .. "_SOCIAL_" .. char .. ".txt",val)
end

PXP.GetSocialLinkData = function(ply,char)
	if !ply:IsPlayer() then return end
	local dir = PXP.GetDataStorage() .. string.gsub(ply:SteamID(),":","_")
	return tonumber(file.Read(dir .. "_SOCIAL_" .. char .. ".txt","DATA") or 0) or 0
end

PXP.GetPersonaData = function(ply,type,sName,it)
	if !ply:IsPlayer() then return end
	it = it or 0
	local dir = PXP.GetDataStorage() .. string.gsub(ply:SteamID(),":","_")
	local name = (type >= 1 && type <= 3 or type >= 6 && type <= 8) && (sName or ply:GetPersonaName()) or nil
	local isPersona = name && (type >= 1 && type <= 3 or type >= 6 && type <= 8)
	if isPersona then
		dir = dir .. "_" .. name .. ".dat"
	else
		dir = dir .. ".dat"
	end
	local pData = PXP.ReadTable(dir)
	if pData == nil then
		if it == 0 then
			return PXP.GetPersonaData(ply,type,sName,1)
		end
		PXP.CreateSaveData(ply)
		return
	end
	if type == 5 then -- Last Persona
		if pData.PreviousPersona == nil then
			PXP.SetPersonaData(ply,5,"izanagi")
		end
		return "izanagi"
	end
	if isPersona then
		return type == 1 && pData.EXP or type == 2 && pData.Level or type == 3 && pData.Skills or type == 6 && pData.ReqEXP or type == 7 && pData.Stats or type == 8 && pData.Enhancement or nil
	end
	return type == 4 && pData.Compendium or type == 9 && pData.PlayerLevel or type == 10 && pData.PlayerEXP or type == 11 && pData.PersonaPoints or nil
end

PXP.CreateSaveData = function(ply,name)
	if !ply:IsPlayer() then return end
	local dir = PXP.GetDataStorage() .. string.gsub(ply:SteamID(),":","_")
	local dirPersona = name && dir .. "_" .. name .. ".dat" or false
	local dirPly = dir .. ".dat"
	local tbl = {
		EXP = 0,
		Level = 0,
		Skills = {},
		ReqEXP = 0,
		Stats = {},
		Enhancement = 0,
	}
	local tblPly = {
		Compendium = {"izanagi"},
		PreviousPersona = "izanagi",
		PlayerLevel = 0,
		PlayerEXP = 0,
		PersonaPoints = 0
	}
	if dirPersona then
		PXP.SaveTable(dirPersona,tbl,true)
	end
	PXP.SaveTable(dirPly,tblPly,true)
end

PXP.SetPersonaData = function(ply,type,val,sName)
	if !ply:IsPlayer() then return end
	local dir = PXP.GetDataStorage() .. string.gsub(ply:SteamID(),":","_")
	local name = (type >= 1 && type <= 3 or type >= 6 && type <= 8) && (sName or ply:GetPersonaName()) or nil
	local tbl = {
		EXP = (type == 1 && val) or PXP.GetPersonaData(ply,1) or 0,
		Level = (type == 2 && val) or PXP.GetPersonaData(ply,2) or 0,
		Skills = (type == 3 && val) or PXP.GetPersonaData(ply,3) or {},
		ReqEXP = (type == 6 && val) or PXP.GetPersonaData(ply,6) or 0,
		Stats = (type == 7 && val) or PXP.GetPersonaData(ply,7) or {},
		Enhancement = (type == 8 && val) or PXP.GetPersonaData(ply,8) or 0,
	}
	local tblPly = {
		Compendium = (type == 4 && val) or PXP.GetPersonaData(ply,4) or {"izanagi"},
		PreviousPersona = (type == 5 && val) or PXP.GetPersonaData(ply,5) or "izanagi",
		PlayerLevel = (type == 9 && val) or PXP.GetPersonaData(ply,9) or 0,
		PlayerEXP = (type == 10 && val) or PXP.GetPersonaData(ply,10) or 0,
		PersonaPoints = (type == 11 && val) or PXP.GetPersonaData(ply,11) or 0
	}

	local isPersona = name && (type >= 1 && type <= 3 or type >= 6 && type <= 8)
	if isPersona then -- Persona Data
		dir = dir .. "_" .. name .. ".dat"
	else
		dir = dir .. ".dat"
	end
	PXP.SaveTable(dir,isPersona && tbl or tblPly,true)
end

PXP.SavePersonaData = function(ply,exp,level,cards)
	if !ply:IsPlayer() then return end
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
	if !ply:IsPlayer() then return end
	return PXP.GetPersonaData(ply,4) or {}
end

PXP.ReadCompendium_Legacy = function(ply)
	if !ply:IsPlayer() then return end
	return PXP.ReadDataTable(PXP.GetDataStorage() .. string.gsub(ply:SteamID(),":","_") .. "_COMPENDIUM.txt")
end

if SERVER then
	PXP.GetDanceDataStorage = function()
		local dir = "persona/dance/"
		file.CreateDir(dir)
		return dir
	end

	PXP.GetDanceData = function(ply,song) -- Obsolete
		if !ply:IsPlayer() then return end
		local dir = PXP.GetDanceDataStorage() .. string.gsub(ply:SteamID(),":","_")
		-- MsgN("Loading Dance Data For " .. song)
		song = string.lower(song)
		local toReturn = tonumber(file.Read(dir .. "_" .. song .. ".txt","DATA") or 0) or 0
		if toReturn == nil then toReturn = 0 end
		return toReturn
	end

	PXP.SaveDanceData = function(ply,song,val) -- Obsolete
		if !ply:IsPlayer() then return end
		local dir = PXP.GetDanceDataStorage() .. string.gsub(ply:SteamID(),":","_")
		-- MsgN("Saving Dance Data For " .. song)
		song = string.lower(song)
		PXP.WriteFile(dir .. "_" .. song .. ".txt",val)
	end
end

PXP.WriteFile = function(dir,cont) -- Obsolete
	file.Write(dir,P_LZMA(tostring(cont),true))
end

PXP.WriteTable = function(dir,name,cont,erase) -- Obsolete
	if erase then
		file.Write(dir,util.TableToJSON({Name = name,Set = cont},true))
		return
	end
	file.Append(dir,util.TableToJSON({Name = name,Set = cont},true))
end

PXP.SaveTable = function(dir,table,erase) -- New Function
	table = P_LZMA(table,true)
	if erase then
		file.Write(dir,table)
		return
	end
	file.Append(dir,table)
end

PXP.ReadTable = function(sFile) -- New Function
	local data = file.Read(sFile,"DATA")
	if data == nil then return end
	local decompressed = P_LZMA(data)
	return (decompressed != nil && util.JSONToTable(decompressed)) or util.JSONToTable(data)
end

PXP.ReadDataTable = function(dir) -- Obsolete
	local data = file.Read(dir,"DATA")
	if data == nil then return end
	local json = util.JSONToTable(data)
	local tbData = {}
	if json && json.Name && json.Set then
		for _,v in pairs(json.Set) do
			table.insert(tbData,v)
		end
	end
	return tbData
end