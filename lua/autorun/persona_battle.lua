	--// Thanks NPP, very cool \\--

CreateConVar("vj_persona_battle","0",FCVAR_NONE,"When enabled, attacking an enemy will activate Battle Mode for you and your party.",0,1)

if SERVER then
	hook.Add("EntityTakeDamage","Persona_BattleMode",function(ent,dmginfo)
		if GetConVarNumber("vj_persona_battle") == 0 then return end
		-- if !dmginfo:GetAttacker():IsPlayer() then return end

		-- local attacker = dmginfo:GetAttacker()
		-- local dmgtype = dmginfo:GetDamageType()
		-- local dmg = dmginfo:GetDamage()
		-- local inBattle = attacker:GetNW2Bool("Persona_BattleMode")
		-- local persona = attacker.GetPersona && attacker:GetPersona() or false
		-- if attacker:IsPlayer() && !inBattle then
			-- local ply = attacker
			-- ply:SetNW2Bool("Persona_BattleMode",true)
			-- ply.Persona_BattleEntity = ents.Create("logic_battle")
			-- ply.Persona_BattleEntity:SetPos(ply:GetPos())
			-- ply.Persona_BattleEntity:Spawn()
			-- ply.Persona_BattleEntity:StartBattle(ply,ent)
			-- print("Entered Battle!")
		-- end
	end)
end