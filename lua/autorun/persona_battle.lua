	--// Thanks NPP, very cool \\--

CreateConVar("vj_persona_battle","0",FCVAR_NONE,"When enabled, attacking an enemy will activate Battle Mode for you and your party.",0,1)
CreateConVar("vj_persona_battle_positions","0",FCVAR_NONE,"When enabled, all enemy targets will be pre-positioned for battle",0,1)

if SERVER then
	hook.Add("EntityTakeDamage","Persona_BattleMode",function(ent,dmginfo)
		if GetConVarNumber("vj_persona_battle") == 0 then return end
		-- if !dmginfo:GetAttacker():IsPlayer() then return end

		local attacker = dmginfo:GetAttacker()
		local dmgtype = dmginfo:GetDamageType()
		local dmg = dmginfo:GetDamage()
		local inBattle = attacker:GetNW2Bool("Persona_BattleMode")
		local positions = tobool(GetConVarNumber("vj_persona_battle_positions"))
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
				for _,v in pairs(ents.FindInSphere(ent:GetPos(),2000)) do
					if v:IsNPC() && v != ent && (v:Disposition(ent) == D_LI or v:Disposition(ent) == D_NU) then
						if #tbl >= max then
							break
						end
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
				for _,v in pairs(ents.FindInSphere(attacker:GetPos(),2000)) do
					if v:IsNPC() && v != attacker && (v:Disposition(attacker) == D_LI or v:Disposition(attacker) == D_NU) then
						if #tbl >= max then
							break
						end
						v.VJ_P_DisableChasingEnemy = v.DisableChasingEnemy
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