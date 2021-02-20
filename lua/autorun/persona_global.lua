PERSONA_COSTUMES = {}
PERSONA_SONGS = {}
PERSONA_SONGANIMATIONS = {}

function PGM()
	return gmod.GetGamemode()
end

function IsPersonaGamemode()
	return PGM().Name == "Persona"
end

function GetDancerFlexData(seqID,ent) -- Get a really good randomly generated facial flex set? Get the data with this!
	local ent = ent or Entity(1)
	local tbl = ent:GetNW2Entity("Persona_Dancer").RandomFlex
	local sequenceID = seqID or 1 -- ACT_IDLE or aka Preview
	for k,v in SortedPairs(tbl[sequenceID]) do
		local frame = k
		for i,d in pairs(v) do
			print(frame .. ",{Name='" .. d.Name .. "',Value=" .. d.Value .. ",Speed=" .. d.Speed .. "}")
		end
	end
end

function P_AddCostume(dancer,data)
	local canAdd = true
	if !PERSONA_COSTUMES then
		PERSONA_COSTUMES = {}
	end
	if !PERSONA_COSTUMES[dancer] then
		PERSONA_COSTUMES[dancer] = {}
	end
	for _,v in pairs(PERSONA_COSTUMES[dancer]) do
		if v.Name == data.Name then
			canAdd = false
		end
	end
	if canAdd then
		table.insert(PERSONA_COSTUMES[dancer],data)
	end
end

function P_GetAvailableCostumes(dancer)
	local data = false
	if !PERSONA_COSTUMES then return end
	if !PERSONA_COSTUMES[dancer] then return end
	if #PERSONA_COSTUMES[dancer] > 0 then
		data = PERSONA_COSTUMES[dancer]
	end
	return data
end

function P_GetCostumeData(dancer,name)
	local data = {Name = "N/A", Model = "", Offset = 0, ReqSong = nil, ReqScore = 0}
	local tbl = PERSONA_COSTUMES[dancer]
	if !tbl then /*MsgN("No costume data exists for the specified dancer!")*/ return end
	for _,v in pairs(tbl) do
		if v.Name == name then
			data = v
		end
	end
	return data
end

function P_AddSong(dancer,songData,animData)
	local canAdd = true
	if !PERSONA_SONGS then
		PERSONA_SONGS = {}
	end
	if !PERSONA_SONGANIMATIONS then
		PERSONA_SONGANIMATIONS = {}
	end
	if !PERSONA_SONGS[dancer] then
		PERSONA_SONGS[dancer] = {}
	end
	if !PERSONA_SONGANIMATIONS[dancer] then
		PERSONA_SONGANIMATIONS[dancer] = {}
	end
	for _,v in pairs(PERSONA_SONGS[dancer]) do
		if v.name == songData.name then
			canAdd = false
		end
	end
	if canAdd then
		table.insert(PERSONA_SONGS[dancer],songData)
		table.insert(PERSONA_SONGANIMATIONS[dancer],animData)
	end
end

function P_GetAvailableSongs(dancer)
	local data = false
	local songData = false
	local animData = false
	if !PERSONA_SONGS then return end
	if !PERSONA_SONGS[dancer] then return end
	if !PERSONA_SONGANIMATIONS then return end
	if !PERSONA_SONGANIMATIONS[dancer] then return end
	if #PERSONA_SONGS[dancer] > 0 && #PERSONA_SONGANIMATIONS[dancer] > 0 then
		data = {SongData = PERSONA_SONGS[dancer], AnimData = PERSONA_SONGANIMATIONS[dancer]}
	end
	return data
end