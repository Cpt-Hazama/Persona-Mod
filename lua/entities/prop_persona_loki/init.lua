AddCSLuaFile("shared.lua")
include("shared.lua")
---------------------------------------------------------------------------------------------------------------------------------------------
ENT.Model = "models/cpthazama/persona5/persona/loki.mdl"
ENT.Name = "Loki"
ENT.Aura = "jojo_aura_red"
ENT.DamageTypes = DMG_P_PHYS
---------------------------------------------------------------------------------------------------------------------------------------------
ENT.Animations = {}
ENT.Animations["idle"] = "idle"
ENT.Animations["idle_low"] = "idle"
ENT.Animations["melee"] = "attack"
ENT.Animations["range_start"] = "range_start"
ENT.Animations["range_start_idle"] = "range_pre_idle"
ENT.Animations["range"] = "range"
ENT.Animations["range_idle"] = "range_loop"
ENT.Animations["range_end"] = "range_end"
---------------------------------------------------------------------------------------------------------------------------------------------
ENT.Stats = {
	LVL = 75, -- Innate level
	STR = 53, -- Effectiveness of phys. attacks
	MAG = 47, -- Effectiveness of magic. attacks
	END = 46, -- Effectiveness of defense
	AGI = 47, -- Effectiveness of hit and evasion rates
	LUC = 39, -- Chance of getting a critical
	WK = {DMG_P_BLESS},
	RES = {},
	NUL = {DMG_P_CURSE},
}
---------------------------------------------------------------------------------------------------------------------------------------------
function ENT:HandleEvents(skill,animBlock,seq,t)
	local ply = self.User
	if ply:IsNPC() && ply:GetClass() == "npc_vj_per_akechi" then
		if skill == "Call of Chaos" then
			if animBlock == "range_start" then
				VJ_CreateSound(ply,"cpthazama/persona5/akechi/blackmask/00027_streaming [1].wav",78)
			end
			if animBlock == "range" then
				VJ_CreateSound(ply,"cpthazama/persona5/akechi/blackmask/00029_streaming [1].wav",78)
			end
			if animBlock == "range_idle" then
				VJ_CreateSound(ply,"cpthazama/persona5/akechi/blackmask/00020_streaming [1].wav",85)
			end
		end
	end
end
---------------------------------------------------------------------------------------------------------------------------------------------
function ENT:GetSpawnPosition(ply)
	return ply:GetPos() +ply:GetForward() *-60
end
---------------------------------------------------------------------------------------------------------------------------------------------
function ENT:GetIdlePosition(ply)
	return ply:GetPos() +ply:GetForward() *-60
end
---------------------------------------------------------------------------------------------------------------------------------------------
function ENT:GetAttackPosition()
	return self.AttackPosition or self:GetPos() +self:OBBCenter()
end
---------------------------------------------------------------------------------------------------------------------------------------------
function ENT:CustomOnHitEntity(entities,dmginfo)
	for _,v in pairs(entities) do
		if IsValid(v) then
			VJ_EmitSound(v,"cpthazama/persona5/misc/00050.wav",75)
			if v:Health() > 0 then
				self:Curse(v,10,5)
			end
		end
	end
end
---------------------------------------------------------------------------------------------------------------------------------------------
function ENT:PersonaControls(ply,persona)
	if ply:IsNPC() then
		return
	end
	local lmb = ply:KeyDown(IN_ATTACK)
	local rmb = ply:KeyDown(IN_ATTACK2)
	local r = ply:KeyDown(IN_RELOAD)
end
---------------------------------------------------------------------------------------------------------------------------------------------
function ENT:Laevateinn(owner,enemy)
	if self.User:Health() > self.User:GetMaxHealth() *self:GetMeleeCost() && self:GetTask() == "TASK_IDLE" then
		self:SetTask("TASK_ATTACK")
		if self.User:IsNPC() then
			owner:VJ_ACT_PLAYACTIVITY("persona_attack",true,false,false)
			VJ_CreateSound(owner,owner.SoundTbl_PersonaAttack,80)
		end
		local t = self:PlaySet("Laevateinn","melee",1)
		self.Target = enemy
		self:SetAngles(self.User:GetAngles())
		self:TakeHP(self.User:GetMaxHealth() *self:GetMeleeCost())
		timer.Simple(1.65,function()
			if IsValid(self) then
				self.AttackPosition = IsValid(enemy) && enemy:GetPos() or nil
				self:MeleeAttackCode(DMG_P_COLOSSAL,300,120)
			end
		end)
		timer.Simple(t,function()
			if IsValid(self) then
				self:DoIdle()
			end
		end)
	end
end
---------------------------------------------------------------------------------------------------------------------------------------------
function ENT:OnSummoned(owner)
	if !IsValid(self.User) then
		self.User = owner
	end
	self:SetModel(self.Model)
	if owner:IsNPC() then VJ_CreateSound(owner,owner.SoundTbl_Persona,78) end
	self.PersonaDistance = 999999999
	
	self:AddCard("Laevateinn",25,true,"almighty")
	self:AddCard("Megidolaon",38,false,"almighty")
	self:AddCard("Debilitate",30,false,"passive")
	self:AddCard("Eigaon",12,false,"curse")
	self:AddCard("Charge",15,false,"passive")
	self:AddCard("Call of Chaos",100,false,"passive")

	self:SetCard("Charge")
	self:SetCard("Laevateinn",true)

	local v = {forward=-200,right=80,up=50}
	self.User:SetNWVector("Persona_CustomPos",Vector(v.right,v.forward,v.up))
end
---------------------------------------------------------------------------------------------------------------------------------------------
function ENT:RequestAura(ply,aura)
	self:EmitSound("cpthazama/persona5/misc/00118.wav",75,100)
	ParticleEffectAttach(aura,PATTACH_POINT_FOLLOW,self,self:LookupAttachment("origin"))
	ParticleEffectAttach(aura,PATTACH_POINT_FOLLOW,ply,ply:LookupAttachment("origin"))
	local fx = EffectData()
	fx:SetOrigin(self:GetIdlePosition(ply))
	fx:SetScale(80)
	util.Effect("JoJo_Summon",fx)
end