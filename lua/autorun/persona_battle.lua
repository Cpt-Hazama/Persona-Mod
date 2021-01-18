	--// Thanks NPP, very cool \\--

CreateConVar("vj_persona_battle","0",FCVAR_NONE,"When enabled, attacking an enemy will activate Battle Mode for you and your party.",0,1)
CreateConVar("vj_persona_battle_positions","0",FCVAR_NONE,"When enabled, all enemy targets will be pre-positioned for battle",0,1)
CreateConVar("vj_persona_battle_visible","0",FCVAR_NONE,"When enabled, only enemies that are visible will be targeted",0,1)

PERSONA_BATTLETRACKS = {}

function P_AddBattleTrack(name,dir,len,bossTrack)
	bossTrack = bossTrack or false
	table.insert(PERSONA_BATTLETRACKS,{Name = name,File = dir,Length = len,BossTrack = bossTrack})
	MsgN("Successfully added battle track data: " .. name .. " | " .. dir .. " | " .. len .. " seconds")
end

function P_FindBattleTracks(bossTrack)
	local tbl = {}
	local ind = 0
	for _,v in pairs(PERSONA_BATTLETRACKS) do
		if bossTrack == true && v.BossTrack == true then
			table.insert(tbl,{v.Name,v.File,v.Length})
		elseif bossTrack != true && v.BossTrack != true then
			table.insert(tbl,{v.Name,v.File,v.Length})
		end
	end
	ind = math.random(1,#tbl)
	return {Name=tbl[ind][1], Song=tbl[ind][2], Length=tbl[ind][3]}
end

function P_GetBattleTrack(dir,useName)
	for _,v in pairs(PERSONA_BATTLETRACKS) do
		if useName then
			if v.Name == dir then
				return v
			end
			return
		end
		if v.File == dir then
			return v
		end
	end
end

P_AddBattleTrack("Last Surprise","cpthazama/persona_shared/battlemode_1.mp3",235)
P_AddBattleTrack("Groovy","cpthazama/persona_shared/battlemode_2.mp3",221)
P_AddBattleTrack("Mass Destruction","cpthazama/persona_shared/battlemode_3.mp3",206)
P_AddBattleTrack("Mass Destruction FES","cpthazama/persona_shared/battlemode_4.mp3",195)
P_AddBattleTrack("Wiping All Out","cpthazama/persona_shared/battlemode_5.mp3",160)
P_AddBattleTrack("Reach Out To The Truth","cpthazama/persona_shared/battlemode_6.mp3",168)
P_AddBattleTrack("Time To Make History","cpthazama/persona_shared/battlemode_7.mp3",171)
P_AddBattleTrack("Take Over","cpthazama/persona_shared/battlemode_8.mp3",226)
P_AddBattleTrack("Reach Out To The Truth (Arena ver.)","cpthazama/persona_shared/battlemode_9.mp3",134)

P_AddBattleTrack("Keeper Of Lust","cpthazama/persona_shared/battlemode_boss_1.mp3",243,true)
P_AddBattleTrack("Rivers In The Desert (Instrumental)","cpthazama/persona_shared/battlemode_boss_2.mp3",315,true)
P_AddBattleTrack("Will Power","cpthazama/persona_shared/battlemode_boss_3.mp3",165,true)

if SERVER then
	hook.Add("EntityTakeDamage","Persona_BattleMode",function(ent,dmginfo)
		if GetConVarNumber("vj_persona_battle") == 0 then return end
		-- if !dmginfo:GetAttacker():IsPlayer() then return end

		local attacker = dmginfo:GetAttacker() or dmginfo:GetInflictor()
		local dmgtype = dmginfo:GetDamageType()
		local dmg = dmginfo:GetDamage()
		local inBattle = IsValid(attacker) && attacker:GetNW2Bool("Persona_BattleMode") or false
		local positions = tobool(GetConVarNumber("vj_persona_battle_positions"))
		local vis = tobool(GetConVarNumber("vj_persona_battle_visible"))
		local max = positions && 5 or 15
		-- local persona = attacker.GetPersona && attacker:GetPersona() or false
		if attacker:IsPlayer() && !inBattle && (ent:IsNPC() or ent:IsPlayer() or ent:IsNextBot()) then
			dmginfo:SetDamage(0)
			local ply = attacker
			ply:SetNW2Bool("Persona_BattleMode",true)
			ply.Persona_BattleEntity = ents.Create("logic_battle")
			ply.Persona_BattleEntity:SetPos(ply:GetPos())
			ply.Persona_BattleEntity:SetAngles(Angle(0,ply:GetAngles().y,0))
			ply.Persona_BattleEntity:Spawn()
			ply.Persona_BattleEntity.Starter = ply
			local tbl = {}
			if IsValid(ent) then
				table.insert(tbl,ent)
				ent:SetNW2Bool("VJ_IsHugeMonster",ent.VJ_IsHugeMonster)
				for _,v in pairs(ents.FindInSphere(ent:GetPos(),2000)) do
					if v:IsNPC() && v != ent && (v:Disposition(ent) == D_LI or v:Disposition(ent) == D_NU) then
						if #tbl >= max then
							break
						end
						if vis && !ply:Visible(v) then continue end
						if v.IsPersonaShadow && !v.MetaVerseMode then
							v:Transform(true,ply)
						end
						v:SetNW2Bool("VJ_IsHugeMonster",v.VJ_IsHugeMonster)
						table.insert(tbl,v)
					end
				end
			end
			
			if #tbl > 0 then
				ply.BattleEntitiesTable = tbl
				net.Start("Persona_StartBattle")
					net.WriteEntity(ply.Persona_BattleEntity)
					net.WriteEntity(ply)
					net.WriteTable(tbl)
				net.Send(ply)
				ply:ConCommand("summon_persona")
			else
				ply:SetNW2Bool("Persona_BattleMode",false)
			end
		elseif attacker:IsNPC() && ent:IsPlayer() && ent:GetNW2Bool("Persona_BattleMode") == false then
			dmginfo:SetDamage(0)
			local ply = ent
			ply:SetNW2Bool("Persona_BattleMode",true)
			ply.Persona_BattleEntity = ents.Create("logic_battle")
			ply.Persona_BattleEntity:SetPos(ply:GetPos())
			ply.Persona_BattleEntity:SetAngles(Angle(0,(attacker:GetPos() -ply:GetPos()):Angle().y,0))
			ply.Persona_BattleEntity:Spawn()
			ply.Persona_BattleEntity.Starter = ply
			local tbl = {}
			if IsValid(attacker) then
				table.insert(tbl,attacker)
				attacker:SetNW2Bool("VJ_IsHugeMonster",attacker.VJ_IsHugeMonster)
				for _,v in pairs(ents.FindInSphere(attacker:GetPos(),2000)) do
					if v:IsNPC() && v != attacker && (v:Disposition(attacker) == D_LI or v:Disposition(attacker) == D_NU) then
						if #tbl >= max then
							break
						end
						if vis && !ply:Visible(v) then continue end
						v.VJ_P_DisableChasingEnemy = v.DisableChasingEnemy
						if v.IsPersonaShadow && !v.MetaVerseMode then
							v:Transform(true,ply)
						end
						v:SetNW2Bool("VJ_IsHugeMonster",v.VJ_IsHugeMonster)
						table.insert(tbl,v)
					end
				end
			end
			
			if #tbl > 0 then
				ply.BattleEntitiesTable = tbl
				net.Start("Persona_StartBattle")
					net.WriteEntity(ply.Persona_BattleEntity)
					net.WriteEntity(ply)
					net.WriteTable(tbl)
				net.Send(ply)
				ply:ConCommand("summon_persona")
			else
				ply:SetNW2Bool("Persona_BattleMode",false)
			end
		end
	end)
end