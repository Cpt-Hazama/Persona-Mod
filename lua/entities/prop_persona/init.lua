AddCSLuaFile("shared.lua")
include("shared.lua")
---------------------------------------------------------------------------------------------------------------------------------------------
PERSONA_TASKS = {}
PERSONA_TASKS["TASK_NONE"] = -1
PERSONA_TASKS["TASK_RESET"] = 0
PERSONA_TASKS["TASK_IDLE"] = 1
PERSONA_TASKS["TASK_BLOCK"] = 2
PERSONA_TASKS["TASK_ATTACK"] = 3
PERSONA_TASKS["TASK_PLAY_ANIMATION"] = 4
PERSONA_TASKS["TASK_MOVE_TO_POSITION"] = 5
PERSONA_TASKS["TASK_DEATH"] = 6
PERSONA_TASKS["TASK_RETURN"] = 7
---------------------------------------------------------------------------------------------------------------------------------------------
ENT.AuraChance = 2
ENT.DamageTypes = bit.bor(DMG_SLASH,DMG_CRUSH,DMG_ALWAYSGIB)
---------------------------------------------------------------------------------------------------------------------------------------------
function ENT:Initialize()
	self:SetSolid(SOLID_OBB)
	self:SetCollisionGroup(COLLISION_GROUP_IN_VEHICLE)
	self:SetRenderMode(RENDERMODE_TRANSADD)
	
	self.CurrentTask = "TASK_NONE"
	self.CurrentTaskID = -1
	
	self.CurrentForwardAng = self:GetAngles().x
	self.CurrentSideAng = self:GetAngles().z
	
	self.NextDamageUserT = 0
	
	self:SetCritical(false)

	self.Loops = {}
	self.Flexes = {}
	
	self.NextCardSwitchT = CurTime()
end
---------------------------------------------------------------------------------------------------------------------------------------------
function ENT:DoCritical(t)
	self:SetCritical(true)
	self.User:EmitSound("cpthazama/persona5/misc/00015_streaming.wav",0.2)
	timer.Simple(t,function()
		if IsValid(self) then
			self:SetCritical(false)
		end
	end)
end
---------------------------------------------------------------------------------------------------------------------------------------------
function ENT:GetSpawnPosition(ply)
	return ply:GetPos()
end
---------------------------------------------------------------------------------------------------------------------------------------------
function ENT:GetIdlePosition(ply)
	return ply:GetPos() +ply:GetForward() *25
end
---------------------------------------------------------------------------------------------------------------------------------------------
function ENT:PersonaControls(ply,persona) end
---------------------------------------------------------------------------------------------------------------------------------------------
function ENT:ControlPersonaMovement(ply)
	local dir = Vector()
	local w = ply:KeyDown(IN_FORWARD)
	local a = ply:KeyDown(IN_MOVELEFT)
	local s = ply:KeyDown(IN_BACK)
	local d = ply:KeyDown(IN_MOVERIGHT)
	local ang = self.User:GetAngles()
	-- if !w && !a && !d && !s then
		-- self:SetAngles(self.User:GetAngles())
	-- end
	if w then
		if self.CurrentForwardAng != 15 then
			self.CurrentForwardAng = self.CurrentForwardAng +1
		end
		dir = dir +self:GetForward()
	elseif s then
		if self.CurrentForwardAng != -15 then
			self.CurrentForwardAng = self.CurrentForwardAng -1
		end
		dir = dir -self:GetForward()
	else
		if self.CurrentForwardAng != 0 then
			self.CurrentForwardAng = (self.CurrentForwardAng > 0 && self.CurrentForwardAng -1) or self.CurrentForwardAng +1
		end
	end
	if a then
		if self.CurrentSideAng != -8 then
			self.CurrentSideAng = self.CurrentSideAng -1
		end
		dir = dir -self:GetRight()
	elseif d then
		if self.CurrentSideAng != 8 then
			self.CurrentSideAng = self.CurrentSideAng +1
		end
		dir = dir +self:GetRight()
	else
		if self.CurrentSideAng != 0 then
			self.CurrentSideAng = (self.CurrentSideAng > 0 && self.CurrentSideAng -1) or self.CurrentSideAng +1
		end
	end
	self:FacePlayerAim(self.User)
	if dir:Length() > 0 then
		local tPos = self:GetPos() +dir *20
		local tracedata = {}
		tracedata.start = self:GetPos() +self:OBBCenter()
		tracedata.endpos = tPos
		tracedata.filter = {ply,self}
		local tr = util.TraceLine(tracedata)
		if !tr.Hit then
			self:MoveToPos(tPos,1.75)
		end
	end
end
---------------------------------------------------------------------------------------------------------------------------------------------
function ENT:DefaultPersonaControls(ply,persona)
	if ply:IsPlayer() then
		if ply:KeyReleased(IN_WALK) then
			if IsValid(ply.Persona_EyeTarget) then
				ply.Persona_EyeTarget = NULL
			else
				local ent = ply:GetEyeTrace().Entity
				if IsValid(ent) && (ent:IsNPC() or ent:IsPlayer() or (ent.IsPersona && ent != persona)) then
					ply.Persona_EyeTarget = ent
					self.User:EmitSound("cpthazama/persona5/misc/00007.wav",70,100)
				end
			end
		end
		if IsValid(ply.Persona_EyeTarget) then
			ply:SetEyeAngles(LerpAngle(0.5,ply:EyeAngles(),((ply.Persona_EyeTarget:GetPos() +ply.Persona_EyeTarget:OBBCenter()) -ply:GetShootPos()):Angle()))
		end
	end
	if ply:GetPos():Distance(self:GetPos()) > self.PersonaDistance && CurTime() > self.NextDamageUserT then
		self.User:TakeDamage(1 *(ply:GetPos():Distance(self:GetPos()) /100),self.User,self.User)
		self.NextDamageUserT = CurTime() +0.25
	end
	if self:GetTask() == "TASK_IDLE" then
		-- self:MoveToPos(self.User:GetPos() +self.User:GetForward() *150,2)
		self:SetPos(self:GetIdlePosition(ply))
		self:SetColor(Color(255,255,255,150))
		self:FacePlayerAim(self.User)

		if ply:IsPlayer() then
			local w = ply:KeyDown(IN_FORWARD)
			local a = ply:KeyDown(IN_MOVELEFT)
			local d = ply:KeyDown(IN_MOVERIGHT)
			local s = ply:KeyDown(IN_BACK)
			local ang = self.User:GetAngles()
			if !w && !a && !d && !s then
				self:SetAngles(self.User:GetAngles())
			end
			if w then
				if self.CurrentForwardAng != 15 then
					self.CurrentForwardAng = self.CurrentForwardAng +1
				end
			elseif s then
				if self.CurrentForwardAng != -15 then
					self.CurrentForwardAng = self.CurrentForwardAng -1
				end
			else
				if self.CurrentForwardAng != 0 then
					self.CurrentForwardAng = (self.CurrentForwardAng > 0 && self.CurrentForwardAng -1) or self.CurrentForwardAng +1
				end
			end
			if a then
				if self.CurrentSideAng != -8 then
					self.CurrentSideAng = self.CurrentSideAng -1
				end
			elseif d then
				if self.CurrentSideAng != 8 then
					self.CurrentSideAng = self.CurrentSideAng +1
				end
			else
				if self.CurrentSideAng != 0 then
					self.CurrentSideAng = (self.CurrentSideAng > 0 && self.CurrentSideAng -1) or self.CurrentSideAng +1
				end
			end
			self:SetAngles(Angle(self.CurrentForwardAng,ang.y,self.CurrentSideAng))
		else
			self:SetAngles(self.User:GetAngles())
		end
	elseif self:GetTask() == "TASK_ATTACK" then
		if !IsValid(self.Target) then self:FindTarget(ply) end
		self:FaceTarget()
	else
		self:SetColor(Color(255,255,255,255))
	end
end
---------------------------------------------------------------------------------------------------------------------------------------------
function ENT:Think()
	if IsValid(self.User) then
		if !self.User:Alive() then
			self:Remove()
		end
		if self:GetTask() == "TASK_RETURN" then
			local dist = self.User:GetPos():Distance(self:GetPos())
			self:FacePlayerAim(self.User)
			local speed = 30
			if dist <= 170 then
				speed = 15
			end
			self:MoveToPos(self.User:GetPos(),speed)
			if dist <= 10 then
				self.User:EmitSound("cpthazama/persona5/persona_disapper.wav",65)
				SafeRemoveEntity(self)
			end
			return
		end
		self:PersonaControls(self.User,self.Stand)
		if self.ControlType == 2 then
			self:ControlPersonaMovement(self.User)
		else
			self:DefaultPersonaControls(self.User,self.Stand)
		end
	else
		self:Remove()
	end
	self:NextThink(CurTime())
	return true
end
---------------------------------------------------------------------------------------------------------------------------------------------
function ENT:RequestAura(ply,aura)
	self:EmitSound("cpthazama/persona5/misc/00118.wav",75,100)
	if math.random(1,self.AuraChance) == 1 then ParticleEffectAttach(aura,PATTACH_POINT_FOLLOW,self,self:LookupAttachment("origin")) end
	ParticleEffectAttach(aura,PATTACH_POINT_FOLLOW,ply,ply:LookupAttachment("origin"))
	local fx = EffectData()
	fx:SetOrigin(self:GetIdlePosition(ply))
	fx:SetScale(80)
	util.Effect("JoJo_Summon",fx)
end
---------------------------------------------------------------------------------------------------------------------------------------------
function ENT:OnSummoned(ply) end
---------------------------------------------------------------------------------------------------------------------------------------------
function ENT:OnRequestDisappear(ply) end
---------------------------------------------------------------------------------------------------------------------------------------------
function ENT:DoIdle()
	self:SetTask("TASK_IDLE")
	self:PlayAnimation("idle",1,1)
end
---------------------------------------------------------------------------------------------------------------------------------------------
function ENT:AddCard(name,req,isHP)
	self.Cards = self.Cards or {}
	self.Cards[name] = {}
	self.Cards[name].Cost = req
	self.Cards[name].UsesHP = isHP
end
---------------------------------------------------------------------------------------------------------------------------------------------
function ENT:SetCard(name)
	if self.Cards[name] then
		self:SetNWString("SpecialAttack",name)
		self:SetNWInt("SpecialAttackCost",self.Cards[name].Cost)
		self:SetNWBool("SpecialAttackUsesHP",self.Cards[name].UsesHP or false)
		self.CurrentCardCost = self.Cards[name].Cost
		self.CurrentCardUsesHP = self.Cards[name].UsesHP
	end
	self.NextCardSwitchT = CurTime() +1
end
---------------------------------------------------------------------------------------------------------------------------------------------
function ENT:GetCard()
	return self:GetNWString("SpecialAttack")
end
---------------------------------------------------------------------------------------------------------------------------------------------
function ENT:TakeSP(sp)
	if self.User:HasGodMode() then return end
	self.User:SetSP(math.Clamp(self.User:GetSP() -sp,0,999))
end
---------------------------------------------------------------------------------------------------------------------------------------------
function ENT:TakeHP(hp)
	if self.User:HasGodMode() then return end
	self.User:SetHealth(self.User:Health() -hp)
end
---------------------------------------------------------------------------------------------------------------------------------------------
function ENT:AddLoop(snd,sndlevel)
	local lp = CreateSound(self,snd)
	lp:SetSoundLevel(sndlevel)
	table.insert(self.Loops,lp)
	return lp
end
---------------------------------------------------------------------------------------------------------------------------------------------
function ENT:MoveToPos(pos,speed)
	local dir = (pos -self:GetPos()):GetNormal()
	self:SetPos(self:GetPos() +dir *speed)
end
---------------------------------------------------------------------------------------------------------------------------------------------
function ENT:DoGesture(seq,speed)
	local gest = self:AddGestureSequence(self:LookupSequence(seq))
	self:SetLayerPriority(gest,2)
	self:SetLayerPlaybackRate(gest,speed)
end
---------------------------------------------------------------------------------------------------------------------------------------------
function ENT:UserTrace(maxDist)
	if maxDist then
		local tracedata = {}
		tracedata.start = self.User:EyePos()
		tracedata.endpos = self.User:EyePos() +self.User:EyeAngles():Forward() *maxDist
		tracedata.filter = {self.User,self}
		local tr = util.TraceLine(tracedata)
		
		-- util.ParticleTracerEx("Weapon_Combine_Ion_Cannon_Beam",tr.StartPos,tr.HitPos,false,self.User:EntIndex(),0)

		return tr
	end
	local tracedata = {}
	tracedata.start = self.User:EyePos()
	tracedata.endpos = self.User:GetEyeTrace().HitPos
	tracedata.filter = {self.User,self}
	local tr = util.TraceLine(tracedata)

	return tr
end
---------------------------------------------------------------------------------------------------------------------------------------------
function ENT:FindTarget(ply)
	if ply:IsPlayer() then
		local tracedata = {}
		tracedata.start = ply:EyePos()
		tracedata.endpos = ply:GetEyeTrace().HitPos
		tracedata.filter = {ply,self}
		local tr = util.TraceLine(tracedata)
		local ent = tr.Entity
	else
		ent = ply:GetEnemy()
	end
	
	self.Target = IsValid(ent) && (ent:IsNPC() or ent:IsPlayer()) && ent
end
---------------------------------------------------------------------------------------------------------------------------------------------
function ENT:FaceTarget()
	if IsValid(self.Target) then
		local ang = self:GetAngles()
		self:SetAngles(Angle(ang.x,(self.Target:GetPos() -self:GetPos()):Angle().y,ang.z))
	end
end
---------------------------------------------------------------------------------------------------------------------------------------------
function ENT:FacePlayerAim(ply)
	if IsValid(self.Target) then
		local ang = self:GetAngles()
		self:SetAngles(Angle(ang.x,(self.Target:GetPos() -self:GetPos()):Angle().y,ang.z))
		return
	end

	if ply:IsPlayer() then
		local tracedata = {}
		tracedata.start = ply:EyePos()
		tracedata.endpos = ply:GetEyeTrace().HitPos
		tracedata.filter = {ply,self}
		local tr = util.TraceLine(tracedata)

		local ang = self:GetAngles()
		self:SetAngles(Angle(ang.x,(tr.HitPos -self:GetPos()):Angle().y,ang.z))
		self:SetPoseParameter("aim_pitch",ply:GetPoseParameter("aim_pitch"))
		self:SetPoseParameter("aim_yaw",ply:GetPoseParameter("aim_yaw"))
		self:SetPoseParameter("head_pitch",ply:GetPoseParameter("head_pitch"))
		self:SetPoseParameter("head_yaw",ply:GetPoseParameter("head_yaw"))
	end
end
---------------------------------------------------------------------------------------------------------------------------------------------
function ENT:GetAttackPosition()
	return self:GetPos() +self:OBBCenter()
end
---------------------------------------------------------------------------------------------------------------------------------------------
function ENT:MeleeAttackCode(dmg,dmgdist,rad,snd)
	local AttackDist = dmgdist
	local FindEnts = ents.FindInSphere(self:GetAttackPosition(),AttackDist)
	local hitentity = false
	local hitEnts = {}
	local snd = snd or true
	local doactualdmg = DamageInfo()
	if FindEnts != nil then
		for _,v in pairs(FindEnts) do
			if (v != self && v != self.User) && (((v:IsNPC() or (v:IsPlayer() && v:Alive()))) or v:GetClass() == "func_breakable_surf" or v:GetClass() == "prop_physics") then
				if (self:GetForward():Dot((Vector(v:GetPos().x,v:GetPos().y,0) - Vector(self:GetPos().x,self:GetPos().y,0)):GetNormalized()) > math.cos(math.rad(rad))) then
					doactualdmg:SetDamage(self:GetCritical() && dmg *2 or dmg)
					doactualdmg:SetDamageType(self.DamageTypes)
					doactualdmg:SetDamageForce(self:GetForward() *((doactualdmg:GetDamage() +100) *70))
					doactualdmg:SetInflictor(self)
					doactualdmg:SetAttacker(self.User)
					v:TakeDamageInfo(doactualdmg,self.User)
					if v:IsPlayer() then
						v:ViewPunch(Angle(math.random(-1,1) *dmg,math.random(-1,1) *dmg,math.random(-1,1) *dmg))
					end
					hitentity = true
					table.insert(hitEnts,v)
					if snd then v:EmitSound("cpthazama/persona5/misc/00051.wav",math.random(60,72),math.random(100,120)) end
					
					-- if v:GetClass() == "prop_physics" then
						local phys = v:GetPhysicsObject()
						if IsValid(phys) then
							phys:ApplyForceCenter(v:GetPos() +self:GetForward() *phys:GetMass() *(dmg *20) +self:GetUp() *phys:GetMass() *(dmg))
						end
					-- end
				end
			end
		end
	end
	if hitentity then
		if self.CustomOnHitEntity then self:CustomOnHitEntity(hitEnts,doactualdmg) end
	else
		self:EmitSound("npc/zombie/claw_miss1.wav",math.random(50,65),math.random(100,125))
		if self.CustomOnMissEntity then self:CustomOnMissEntity() end
	end
end
---------------------------------------------------------------------------------------------------------------------------------------------
function ENT:SoundTimer(t,ent,snd)
	timer.Simple(t,function()
		if IsValid(ent) then
			ent:EmitSound(snd)
		end
	end)
end
---------------------------------------------------------------------------------------------------------------------------------------------
function ENT:OnKilledEnemy(ent) end
---------------------------------------------------------------------------------------------------------------------------------------------
function ENT:Curse(ent,t,dmg)
	ent.Persona_DMG_Curse = CurTime() +t
	ParticleEffectAttach("persona_fx_dmg_fear",PATTACH_POINT_FOLLOW,ent,ent:LookupAttachment("origin"))
	for i = 1, t do
		timer.Simple(i,function()
			if IsValid(ent) then
				local dmginfo = DamageInfo()
				dmginfo:SetDamage(dmg)
				dmginfo:SetDamageType(DMG_P_CURSE)
				dmginfo:SetInflictor(IsValid(self) && self or ent)
				dmginfo:SetAttacker(IsValid(self) && IsValid(self.User) && self.User or ent)
				ent:TakeDamageInfo(dmginfo,IsValid(self) && IsValid(self.User) && self.User or ent)
			end
		end)
	end
	timer.Simple(t +0.15,function()
		if IsValid(ent) then
			if CurTime() > ent.Persona_DMG_Curse then
				ent:StopParticles()
			end
		end
	end)
end
---------------------------------------------------------------------------------------------------------------------------------------------
function ENT:Fear(ent,t)
	local prevDisp = ent:Disposition(self.User) != D_FR && ent:Disposition(self.User) or D_NU
	ent.Persona_DMG_Fear = CurTime() +t
	ParticleEffectAttach("persona_fx_dmg_fear",PATTACH_POINT_FOLLOW,ent,ent:LookupAttachment("origin"))
	ent:AddEntityRelationship(self.User,D_FR,99)
	timer.Simple(t +0.15,function()
		if IsValid(ent) then
			if CurTime() > ent.Persona_DMG_Fear then
				ent:StopParticles()
				if IsValid(self) && IsValid(self.User) then
					ent:AddEntityRelationship(self.User,prevDisp,99)
				end
			end
		end
	end)
end
---------------------------------------------------------------------------------------------------------------------------------------------
hook.Add("OnNPCKilled","Persona_NPCKilled",function(ent,killer,weapon)
	if killer:IsPlayer() then
		local persona = killer:GetPersona()
		if IsValid(persona) then
			persona:OnKilledEnemy(ent)
		end
	end
end)
---------------------------------------------------------------------------------------------------------------------------------------------
hook.Add("PlayerDeath","Persona_PlayerKilled",function(ent,killer,weapon)
	if killer:IsPlayer() && killer != ent then
		local persona = killer:GetPersona()
		if IsValid(persona) then
			persona:OnKilledEnemy(ent)
		end
	end
end)
---------------------------------------------------------------------------------------------------------------------------------------------
function ENT:WhenRemoved() end
---------------------------------------------------------------------------------------------------------------------------------------------
function ENT:OnRemove()
	if IsValid(self.User) then
		self.User:SetNWVector("Persona_CustomPos",Vector(0,0,0))
		self.User:StopParticles()
	end
	self:StopParticles()
	self:WhenRemoved()
	for _,v in pairs(self.Loops) do
		if v then
			v:Stop()
		end
	end
end