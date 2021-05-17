PERSONA_BATTLETRACKS = {}

CreateConVar("vj_persona_battle","0",FCVAR_NONE,"When enabled, attacking an enemy will activate Battle Mode for you and your party.",0,1)
CreateConVar("vj_persona_battle_positions","0",FCVAR_NONE,"When enabled, all enemy targets will be pre-positioned for battle",0,1)
CreateConVar("vj_persona_battle_visible","0",FCVAR_NONE,"When enabled, only enemies that are visible will be targeted",0,1)
CreateConVar("vj_persona_battle_turns","0",FCVAR_NONE,"When enabled, players/SNPCs will take turns battling. Note this will only work with players and Persona SNPCs!",0,1)
CreateConVar("vj_persona_battle_turntime","30",FCVAR_NONE,"Amount of time the current combatant has to do their turn.",5,180)
CreateConVar("vj_persona_battle_damagetime","0.5",FCVAR_NONE,"Amount of time to give non-Persona users to deal damage after their initial hit.",0.01,10)
CreateConVar("vj_persona_battle_newcomers","1",FCVAR_NONE,"Allow more enemies to join battles at any time?",0,1)

function P_AddBattleTrack(name,dir,len,bossTrack,specific)
	bossTrack = bossTrack or false
	table.insert(PERSONA_BATTLETRACKS,{Name = name,File = dir,Length = len,BossTrack = bossTrack,Entity = specific})
	MsgN("Successfully added battle track data: " .. name .. " | " .. dir .. " | " .. len .. " seconds")
end

function P_FindBattleTracks(bossTrack,specific)
	local tbl = {}
	local ind = 0
	local canGo = true
	for _,v in pairs(PERSONA_BATTLETRACKS) do
		if specific && v.Entity && v.Entity == specific then
			return {Name=v.Name,Song=v.File,Length=v.Length}
		end
		if !canGo then return end
		if bossTrack == true && v.BossTrack == true && !v.Entity then
			table.insert(tbl,{v.Name,v.File,v.Length})
		elseif bossTrack != true && v.BossTrack != true && !v.Entity then
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
P_AddBattleTrack("Beneath The Mask (Ultimate ver.)","cpthazama/persona_shared/battlemode_10.mp3",324)

P_AddBattleTrack("Keeper Of Lust","cpthazama/persona_shared/battlemode_boss_1.mp3",243,true)
P_AddBattleTrack("Rivers In The Desert (Instrumental)","cpthazama/persona_shared/battlemode_boss_2.mp3",315,true)
P_AddBattleTrack("Will Power","cpthazama/persona_shared/battlemode_boss_3.mp3",165,true)

P_AddBattleTrack("Yaldabaoth","cpthazama/persona5/music/Yaldabaoth.mp3",180,true,"npc_vj_per_yaldabaoth")

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
		local persona = IsValid(attacker:GetNW2Entity("PersonaEntity"))
		local battleEnt = (attacker:IsPlayer() && attacker.GetBattleEntity && IsValid(attacker:GetBattleEntity()) && attacker:GetBattleEntity()) or (attacker:IsNPC() && ent:IsPlayer() && (ent.GetBattleEntity && IsValid(ent:GetBattleEntity()) && ent:GetBattleEntity())) or false
		
		if battleEnt then
			if GetConVarNumber("vj_persona_battle_newcomers") == 1 then
				if (ent:IsNPC() or ent:IsPlayer() or ent:IsNextBot()) && !IsValid(ent:GetBattleEntity()) then
					ent:SetNW2Bool("VJ_IsHugeMonster",ent.VJ_IsHugeMonster)
					ent:SetNW2Bool("VJ_IsHugeMonster",ent.VJ_IsHugeMonster)
					ent:SetNW2Bool("VJ_P_DisableChasingEnemy",ent.DisableChasingEnemy)
					ent:SetNW2Bool("VJ_P_HasMeleeAttack",ent.HasMeleeAttack)
					ent:SetNW2Bool("VJ_P_HasRangeAttack",ent.HasRangeAttack)
					ent:SetNW2Bool("VJ_P_HasLeapAttack",ent.HasLeapAttack)
					ent:SetNW2Bool("VJ_P_HasGrenadeAttack",ent.HasGrenadeAttack)
					ent:SetNW2Bool("VJ_P_CanUseSecondaryOnWeaponAttack",ent.CanUseSecondaryOnWeaponAttack)
					ent:SetNW2Int("VJ_P_NextWeaponAttackT",ent.NextWeaponAttackT)
					ent.Persona_BattleEntity = attacker.Persona_BattleEntity
					table.insert(battleEnt.Starter.BattleEntitiesTable,ent)
					net.Start("Persona_UpdateCSBattleData")
						net.WriteEntity(battleEnt)
						net.WriteEntity(ent)
					net.Send(attacker)
					if ent.IsVJBaseSNPC then
						ent.DisableChasingEnemy = battleEnt.UsePositions
						ent.HasMeleeAttack = false
						ent.HasRangeAttack = false
						ent.HasLeapAttack = false
						ent.HasGrenadeAttack = false
						ent.CanUseSecondaryOnWeaponAttack = false
						ent.NextWeaponAttackT = 999999999
						ent:SetState(battleEnt.UsePositions && VJ_STATE_ONLY_ANIMATION or nil)
					end
				elseif attacker:IsNPC() && ent:IsPlayer() && !IsValid(attacker:GetBattleEntity()) then
					attacker:SetNW2Bool("VJ_IsHugeMonster",attacker.VJ_IsHugeMonster)
					attacker:SetNW2Bool("VJ_IsHugeMonster",attacker.VJ_IsHugeMonster)
					attacker:SetNW2Bool("VJ_P_DisableChasingEnemy",attacker.DisableChasingEnemy)
					attacker:SetNW2Bool("VJ_P_HasMeleeAttack",attacker.HasMeleeAttack)
					attacker:SetNW2Bool("VJ_P_HasRangeAttack",attacker.HasRangeAttack)
					attacker:SetNW2Bool("VJ_P_HasLeapAttack",attacker.HasLeapAttack)
					attacker:SetNW2Bool("VJ_P_HasGrenadeAttack",attacker.HasGrenadeAttack)
					attacker:SetNW2Bool("VJ_P_CanUseSecondaryOnWeaponAttack",attacker.CanUseSecondaryOnWeaponAttack)
					attacker:SetNW2Int("VJ_P_NextWeaponAttackT",attacker.NextWeaponAttackT)
					attacker.Persona_BattleEntity = ent.Persona_BattleEntity
					table.insert(battleEnt.Starter.BattleEntitiesTable,attacker)
					net.Start("Persona_UpdateCSBattleData")
						net.WriteEntity(battleEnt)
						net.WriteEntity(attacker)
					net.Send(ent)
					if attacker.IsVJBaseSNPC then
						attacker.DisableChasingEnemy = battleEnt.UsePositions
						attacker.HasMeleeAttack = false
						attacker.HasRangeAttack = false
						attacker.HasLeapAttack = false
						attacker.HasGrenadeAttack = false
						attacker.CanUseSecondaryOnWeaponAttack = false
						attacker.NextWeaponAttackT = 999999999
						attacker:SetState(battleEnt.UsePositions && VJ_STATE_ONLY_ANIMATION or nil)
					end
				end
			end
			-- print("Found battleEnt!")
			-- print(attacker,attacker:GetCurrentBattleTurnEntity(),attacker:GetCurrentBattleTurnEntity() == attacker)
			if battleEnt:GetNW2Bool("TakeTurns") then
				if attacker:GetCurrentBattleTurnEntity() == attacker then
					-- print("I AM THE ATTACKER!")
					if persona then return end -- Personas have Battle Mode code built into them, no need for this extra code
					attacker.Persona_LastBattleDMGT = attacker.Persona_LastBattleDMGT or false
					if attacker.Persona_LastBattleDMGT == false then
						attacker.Persona_LastBattleDMGT = CurTime() +GetConVarNumber("vj_persona_battle_damagetime")
						timer.Simple(GetConVarNumber("vj_persona_battle_damagetime"),function()
							if IsValid(battleEnt) then
								if IsValid(attacker) then
									attacker.Persona_LastBattleDMGT = false
									if attacker:GetCurrentBattleTurnEntity() != attacker then
										return -- Something happened, the battleEnt already changed turns
									end
								end
								battleEnt:NextCurrentTurn()
							end
						end)
					end
					if CurTime() > attacker.Persona_LastBattleDMGT then -- Give them some time to get all possible hits in
						-- print("I DONT HAVE A PERSONA, NEXT TURN!")
						battleEnt:NextCurrentTurn()
						attacker.Persona_LastBattleDMGT = false
					end
				else
					-- print("NOT MY TURN!! SCALING!!!")
					dmginfo:SetDamage(0)
				end
			end
			return
		end

		if attacker:IsPlayer() && !inBattle && (ent:IsNPC() or ent:IsPlayer() or ent:IsNextBot()) then
			dmginfo:SetDamage(0)
			local ply = attacker
			ply:SetNW2Bool("Persona_BattleMode",true)
			ply.Persona_BattleEntity = ents.Create("logic_battle")
			ply.Persona_BattleEntity:SetPos(ply:GetPos())
			ply.Persona_BattleEntity:SetAngles(Angle(0,ply:GetAngles().y,0))
			ply.Persona_BattleEntity.Starter = ply
			ply.Persona_BattleEntity:Spawn()
			local tbl = {}
			if IsValid(ent) then
				table.insert(tbl,ply)
				table.insert(tbl,ent)
				ent:SetNW2Bool("VJ_IsHugeMonster",ent.VJ_IsHugeMonster)
				ent:SetNW2Bool("VJ_IsHugeMonster",ent.VJ_IsHugeMonster)
				ent:SetNW2Bool("VJ_P_DisableChasingEnemy",ent.DisableChasingEnemy)
				ent:SetNW2Bool("VJ_P_HasMeleeAttack",ent.HasMeleeAttack)
				ent:SetNW2Bool("VJ_P_HasRangeAttack",ent.HasRangeAttack)
				ent:SetNW2Bool("VJ_P_HasLeapAttack",ent.HasLeapAttack)
				ent:SetNW2Bool("VJ_P_HasGrenadeAttack",ent.HasGrenadeAttack)
				ent:SetNW2Bool("VJ_P_CanUseSecondaryOnWeaponAttack",ent.CanUseSecondaryOnWeaponAttack)
				ent:SetNW2Int("VJ_P_NextWeaponAttackT",ent.NextWeaponAttackT)
				ent.Persona_BattleEntity = ply.Persona_BattleEntity
				for _,v in pairs(ents.FindInSphere(ent:GetPos(),2000)) do
					if v:IsNPC() && v != ent && (v:Disposition(ent) == D_LI or v:Disposition(ent) == D_NU) then
						-- if #tbl >= max then
							-- break
						-- end
						if vis && !ply:Visible(v) then continue end
						if v.IsPersonaShadow && !v.MetaVerseMode then
							v:Transform(true,ply)
						end
						v:SetNW2Bool("VJ_IsHugeMonster",v.VJ_IsHugeMonster)
						v.Persona_BattleEntity = ply.Persona_BattleEntity
						v:SetNW2Bool("VJ_P_DisableChasingEnemy",v.DisableChasingEnemy)
						v:SetNW2Bool("VJ_P_HasMeleeAttack",v.HasMeleeAttack)
						v:SetNW2Bool("VJ_P_HasRangeAttack",v.HasRangeAttack)
						v:SetNW2Bool("VJ_P_HasLeapAttack",v.HasLeapAttack)
						v:SetNW2Bool("VJ_P_HasGrenadeAttack",v.HasGrenadeAttack)
						v:SetNW2Bool("VJ_P_CanUseSecondaryOnWeaponAttack",v.CanUseSecondaryOnWeaponAttack)
						v:SetNW2Int("VJ_P_NextWeaponAttackT",v.NextWeaponAttackT)
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
			if ply.Persona_BattleEntity:GetNW2Bool("TakeTurns") then
				ply.Persona_BattleEntity:NextCurrentTurn()
			end
		elseif attacker:IsNPC() && ent:IsPlayer() && ent:GetNW2Bool("Persona_BattleMode") == false then
			dmginfo:SetDamage(0)
			local ply = ent
			ply:SetNW2Bool("Persona_BattleMode",true)
			ply.Persona_BattleEntity = ents.Create("logic_battle")
			ply.Persona_BattleEntity:SetPos(ply:GetPos())
			ply.Persona_BattleEntity:SetAngles(Angle(0,(attacker:GetPos() -ply:GetPos()):Angle().y,0))
			ply.Persona_BattleEntity.Starter = ply
			ply.Persona_BattleEntity:Spawn()
			local tbl = {}
			if IsValid(attacker) then
				table.insert(tbl,attacker)
				attacker:SetNW2Bool("VJ_IsHugeMonster",attacker.VJ_IsHugeMonster)
				attacker:SetNW2Bool("VJ_P_DisableChasingEnemy",attacker.DisableChasingEnemy)
				attacker:SetNW2Bool("VJ_P_HasMeleeAttack",attacker.HasMeleeAttack)
				attacker:SetNW2Bool("VJ_P_HasRangeAttack",attacker.HasRangeAttack)
				attacker:SetNW2Bool("VJ_P_HasLeapAttack",attacker.HasLeapAttack)
				attacker:SetNW2Bool("VJ_P_HasGrenadeAttack",attacker.HasGrenadeAttack)
				attacker:SetNW2Bool("VJ_P_CanUseSecondaryOnWeaponAttack",attacker.CanUseSecondaryOnWeaponAttack)
				attacker:SetNW2Int("VJ_P_NextWeaponAttackT",attacker.NextWeaponAttackT)
				attacker.Persona_BattleEntity = ply.Persona_BattleEntity
				for _,v in pairs(ents.FindInSphere(attacker:GetPos(),2000)) do
					if v:IsNPC() && v != attacker && (v:Disposition(attacker) == D_LI or v:Disposition(attacker) == D_NU) then
						-- if #tbl >= max then
							-- break
						-- end
						if vis && !ply:Visible(v) then continue end
						v:SetNW2Bool("VJ_P_DisableChasingEnemy",v.DisableChasingEnemy)
						v:SetNW2Bool("VJ_P_HasMeleeAttack",v.HasMeleeAttack)
						v:SetNW2Bool("VJ_P_HasRangeAttack",v.HasRangeAttack)
						v:SetNW2Bool("VJ_P_HasLeapAttack",v.HasLeapAttack)
						v:SetNW2Bool("VJ_P_HasGrenadeAttack",v.HasGrenadeAttack)
						v:SetNW2Bool("VJ_P_CanUseSecondaryOnWeaponAttack",v.CanUseSecondaryOnWeaponAttack)
						v:SetNW2Int("VJ_P_NextWeaponAttackT",v.NextWeaponAttackT)
						if v.IsPersonaShadow && !v.MetaVerseMode then
							v:Transform(true,ply)
						end
						v.Persona_BattleEntity = ply.Persona_BattleEntity
						v:SetNW2Bool("VJ_IsHugeMonster",v.VJ_IsHugeMonster)
						table.insert(tbl,v)
					end
				end
			end
			
			if #tbl > 0 then
				ply.BattleEntitiesTable = tbl
				table.insert(tbl,ply)
				net.Start("Persona_StartBattle")
					net.WriteEntity(ply.Persona_BattleEntity)
					net.WriteEntity(ply)
					net.WriteTable(tbl)
				net.Send(ply)
				ply:ConCommand("summon_persona")
			else
				ply:SetNW2Bool("Persona_BattleMode",false)
			end
			if ply.Persona_BattleEntity:GetNW2Bool("TakeTurns") then
				ply.Persona_BattleEntity:NextCurrentTurn()
			end
		end
	end)
end