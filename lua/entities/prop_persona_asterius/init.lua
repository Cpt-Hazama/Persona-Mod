AddCSLuaFile("shared.lua")
include("shared.lua")

ENT.Stats = {
	LVL = 56, -- Innate level
	STR = 43, -- Effectiveness of phys. attacks
	MAG = 43, -- Effectiveness of magic. attacks
	END = 32, -- Effectiveness of defense
	AGI = 32, -- Effectiveness of hit and evasion rates
	LUC = 25, -- Chance of getting a critical
	WK = {DMG_P_ICE,DMG_P_FROST},
	RES = {DMG_P_FIRE,DMG_BURN,DMG_P_PSY,DMG_P_PSI},
	NUL = {DMG_P_CURSE},
}
ENT.LegendaryMaterials = {}
ENT.LegendaryMaterials[1] = "models/cpthazama/persona4/asterius/asterius_legendary"
ENT.MovesWithUser = false
---------------------------------------------------------------------------------------------------------------------------------------------
function ENT:HandleEvents(skill,animBlock,seq,t)
	if animBlock == "melee" then
		VJ_CreateSound(self,"cpthazama/vo/labrys/sfx/asterius_roar.wav",150)
	end
	if animBlock == "range_start" then
		VJ_CreateSound(self,"cpthazama/vo/labrys/sfx/asterius_growl" .. math.random(1,2) .. ".wav",150)
	end
	if animBlock == "range" then
		VJ_CreateSound(self,"cpthazama/vo/labrys/sfx/asterius_growl3.wav",150)
	end
end
---------------------------------------------------------------------------------------------------------------------------------------------
function ENT:OnThink(ply)
	if CurTime() > self.NextPortalDMGT then
		local function Difference(a,b)
			return ((a > b) && a -b) or b -a
		end

		local function GroundDist(ent)
			local tr = util.TraceLine({
				start = ent:GetPos(),
				endpos = ent:GetPos() +Vector(0,0,1000),
				filter = {ent}
			})
			return tr.Hit && tr.HitPos:Distance(ent:GetPos()) or 0
		end

		local tbl = self:FindEnemies(self:GetPos(),350)
		if #tbl > 0 then
			for _,v in pairs(tbl) do
				if Difference(GroundDist(self),GroundDist(v)) <= 100 then
					local doactualdmg = DamageInfo()
					doactualdmg:SetDamage(5)
					doactualdmg:SetDamageType(bit.bor(DMG_DIRECT,DMG_BURN))
					doactualdmg:SetInflictor(self)
					doactualdmg:SetAttacker(IsValid(self.User) && self.User or self)
					doactualdmg:SetDamagePosition(v:NearestPoint(self:GetPos()))
					v:TakeDamageInfo(doactualdmg,IsValid(self.User) && self.User or self)
					v:Ignite(6)
				end
			end
		end
		self.NextPortalDMGT = CurTime() +1
	end
end
---------------------------------------------------------------------------------------------------------------------------------------------
function ENT:GetSpawnPosition(ply)
	return ply:GetPos() +ply:GetForward() *-350
end
---------------------------------------------------------------------------------------------------------------------------------------------
function ENT:GetIdlePosition(ply)
	return ply:GetPos() +ply:GetForward() *-350
end
---------------------------------------------------------------------------------------------------------------------------------------------
function ENT:OnRunDamageCode(dmginfo,pos,hitEnts)
	if self:GetAnimation() == self.Animations["melee"] then
		util.ScreenShake(self:GetPos(),16,100,3,4000)
		sound.Play("cpthazama/vo/labrys/sfx/asterius_impact.wav",pos,110)
	end
end
---------------------------------------------------------------------------------------------------------------------------------------------
function ENT:OnSummoned(owner)	
	self:UserSound("cpthazama/persona5/joker/0025.wav",75,100)
	
	self.NextPortalDMGT = CurTime() +1

	self:AddCard("Gigantomachia",owner:IsNPC() && 1 or 25,true,"phys")
	self:AddCard("Titanomachia",54,false,"fire")
	self:AddCard("Maragidyne",22,false,"fire")
	self:AddCard("Tetrakarn",36,false,"passive")

	self:SetCard("Titanomachia")
	self:SetCard("Gigantomachia",true)

	local v = {forward=-500,right=150,up=50}
	self.User:SetNW2Vector("Persona_CustomPos",Vector(v.right,v.forward,v.up))
end
---------------------------------------------------------------------------------------------------------------------------------------------
function ENT:OnRequestDisappear(ply)
	self:UserSound("cpthazama/persona5/joker/0" .. math.random(106,120) .. ".wav")
end