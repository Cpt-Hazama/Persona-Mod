AddCSLuaFile("shared.lua")
include("shared.lua")
---------------------------------------------------------------------------------------------------------------------------------------------
ENT.Bot_StopDistance = 100
ENT.Bot_Buttons = {
	[1] = {but={IN_ATTACK},dist=100,chance=1},
}
---------------------------------------------------------------------------------------------------------------------------------------------
function ENT:PersonaControls(ply,persona)
	local lmb = ply:KeyDown(IN_ATTACK)
	local rmb = ply:KeyDown(IN_ATTACK2)
	local r = ply:KeyDown(IN_RELOAD)
	if self:GetTask() == "TASK_IDLE" then
		if self.User:Crouching() && self.CurrentIdle != "low_hp" then
			self:DoIdle()
		elseif !self.User:Crouching() && self.CurrentIdle != "idle" then
			self:DoIdle()
		end
	end
	self:SetSkin(CurTime() > self.RechargeT && 0 or 1)
	if lmb then
		if self.InstaKillStage > 0 then return end
		if self:GetTask() != "TASK_ATTACK" && !self.IsArmed then
			self:SetTask("TASK_ATTACK")
			self:PlayAnimation("ghostly_wail_noXY",1)
			ply:EmitSound("cpthazama/persona5/adachi/vo/ghostly_wail_0" .. math.random(1,2) .. ".wav",85)
			self:FindTarget(ply)
			-- self:SetPos(self.User:GetPos() +self.User:GetForward() *60)
			self:SetAngles(self.User:GetAngles())
			local t = {0.9,1.4,1.9}
			for _,v in pairs(t) do
				timer.Simple(v,function()
					if IsValid(self) then
						self:MeleeAttackCode(self.Damage,210,70)
					end
				end)
			end
			timer.Simple(self:GetSequenceDuration(self,"ghostly_wail_noXY"),function()
				if IsValid(self) then
					self:DoIdle()
				end
			end)
		end
	end
	if rmb then
		if self.InstaKillStage > 0 then return end
		if !self.IsArmed && self:GetTask() != "TASK_PLAY_ANIMATION" && self:GetTask() != "TASK_ATTACK" && CurTime() > self.RechargeT then
			self.DamageBuild = 250
			self:SetTask("TASK_PLAY_ANIMATION")
			self:PlayAnimation("atk_magatsu_mandala_pre",1)
			ply:EmitSound("cpthazama/persona5/adachi/vo/curse.wav")
			timer.Simple(self:GetSequenceDuration(self,"atk_magatsu_mandala_pre"),function()
				if IsValid(self) then
					self.IsArmed = true
					self:PlayAnimation("atk_magatsu_mandala_pre_idle",1,1)
				end
			end)
		end
	end
	if self:GetTask() == "TASK_PLAY_ANIMATION" && self.IsArmed && !rmb && CurTime() > self.TimeToMazionga then
		self:MeleeAttackCode(1000,2500,180,false)
		self:PlayAnimation("atk_magatsu_mandala",1,1)
		self.TimeToMazionga = CurTime() +3.5
		self:EmitSound("beams/beamstart5.wav",90)
		local tbl = {
			"cpthazama/persona5/adachi/vo/blast.wav",
			"cpthazama/vox/adachi/kill/vbtl_pad_0#178 (pad300_0).wav",
			"cpthazama/vox/adachi/kill/vbtl_pad_0#122 (pad166_0).wav"
		}
		ply:EmitSound(VJ_PICK(tbl))
		for a = 1,5 do
			for i = 1,20 do
				timer.Simple(i *0.15,function()
					if IsValid(self) then
						self:MagatsuMandala(a,30000)
					end
				end)
			end
		end
		timer.Simple(3,function()
			if IsValid(self) then
				self.RechargeT = CurTime() +30
				self.IsArmed = false
				self:DoIdle()
			end
		end)
	end
	if r then
		if CurTime() > self.NextInstaKillT && self:GetTask() == "TASK_IDLE" && self.InstaKillStage == 0 then
			self:SetTask("TASK_PLAY_ANIMATION")
			self:PlayAnimation("atk_magatsu_mandala_pre",1)
			self.InstaKillStage = 1
			self.InstaKillTarget = NULL
			self.NextInstaKillT = CurTime() +20

			local style = math.random(1,2)
			local dur1 = SoundDuration("cpthazama/persona5/adachi/vo/instakill_start0" .. style .. ".wav")
			local dur2 = SoundDuration("cpthazama/persona5/adachi/vo/instakill_phase1_0" .. style .. ".wav")
			local dur3 = SoundDuration("cpthazama/persona5/adachi/vo/instakill_phase2_0" .. style .. ".wav")
			local delay = 3
			local dur4 = SoundDuration("cpthazama/persona5/adachi/vo/instakill_phase3_0" .. style .. ".wav")
			local prediction = dur1 +dur2 +dur3 +dur4 +delay
			self.InstaKillStyle = style

			local bloodeffect = EffectData()
			bloodeffect:SetOrigin(self:GetPos())
			bloodeffect:SetScale(225)
			bloodeffect:SetAttachment(8)
			util.Effect("P4_RedMist",bloodeffect)

			timer.Simple(dur1 -0.8,function()
				if IsValid(self) && IsValid(ply) then
					self:SetNoDraw(true)
					self.InstaKillStage = 2
					self:EmitSound("cpthazama/persona5/adachi/redmist.wav")
					self:PlayAnimation("atk_magatsu_mandala_pre_idle",1,1)
				end
			end)
			
			timer.Simple(dur1,function()
				if IsValid(self) && IsValid(ply) then
					local findEnts = ents.FindInSphere(self:GetPos(),1500)
					local entTbl = {}
					if findEnts != nil then
						for _,v in pairs(findEnts) do
							if (v != self && v != self.User) && (((v:IsNPC() or (v:IsPlayer() && v:Alive())))) && v:IsOnGround() then
								table.insert(entTbl,v)
							end
						end
					end
					local ent = VJ_PICK(entTbl)
					if IsValid(ent) then
						self.InstaKillTarget = ent
						self.InstaKillTargetPos = ent:GetPos()
						if ent:IsPlayer() then ent:Freeze(true) end
						ent:EmitSound("cpthazama/persona5/adachi/redmist_puddle.wav")

						local bloodeffect = EffectData()
						bloodeffect:SetOrigin(ent:GetPos())
						bloodeffect:SetScale(140)
						bloodeffect:SetAttachment(5)
						util.Effect("P4_RedMist",bloodeffect)
						self:PlayInstaKillTheme({self.User,ent},prediction,1)
					else
						self.InstaKillStage = 0
					end
				end
			end)
			
			timer.Simple(dur1 +1,function()
				if IsValid(self) && IsValid(ply) then
					if IsValid(self.InstaKillTarget) && self.InstaKillStage != 0 then
						local ang = self:GetAngles()
						self:SetPos(self.InstaKillTarget:GetPos() +self.InstaKillTarget:GetForward() *-100 +Vector(0,0,self.InstaKillTarget:OBBMaxs().z /2))
						self:SetAngles(Angle(ang.x,(self.InstaKillTarget:GetPos() -self:GetPos()):Angle().y,ang.z))
					end
					self:SetNoDraw(false)
					self:EmitSound("cpthazama/persona5/adachi/redmist.wav")
				end
			end)

			timer.Simple(dur1 +dur2 +dur3,function()
				if IsValid(self) && IsValid(ply) then
					if IsValid(self.InstaKillTarget) && self.InstaKillStage != 0 then
						self:PlayAnimation("atk_magatsu_mandala",1,1)
						self:EmitSound("cpthazama/persona5/adachi/blast_charge.wav",120)
						util.ScreenShake(self:GetPos(),16,100,3,5000)
					end
				end
			end)

			timer.Simple(dur1 +dur2 +dur3 +delay -0.8,function()
				if IsValid(self) && IsValid(ply) then
					if IsValid(self.InstaKillTarget) && self.InstaKillStage != 0 then
						self:PlayAnimation("atk_cross_slash",1)
						timer.Simple(self:GetSequenceDuration(self,"atk_cross_slash") -0.25,function()
							if IsValid(self) then
								self:PlayAnimation("idle",1,1)
							end
						end)
					end
				end
			end)
			
			timer.Simple(dur1 +dur2 +dur3 +delay,function()
				if IsValid(self) && IsValid(ply) then
					if IsValid(self.InstaKillTarget) && self.InstaKillStage != 0 then
						local ent = self.InstaKillTarget
						if ent:IsPlayer() then
							ent:GodDisable()
						end
						self:EmitSound("cpthazama/persona5/adachi/slash.wav",120)
						ent:SetPos(self.InstaKillTargetPos)
						if ent:IsPlayer() then ent:Freeze(false) end
						ent:SetHealth(1)
						if ent.Armor && type(ent.Armor) == "number" then
							ent.Armor = 0
						end
						if ent.Shields && type(ent.Shields) == "number" then
							ent.Shields = 0
						end
						if ent.ShieldHealth && type(ent.ShieldHealth) == "number" then
							ent.ShieldHealth = 0
						end
						ent:TakeDamage(999999999,ply,self)
						util.ScreenShake(self:GetPos(),16,100,0.5,10000)
						self.InstaKillStage = 0

						local bloodeffect = EffectData()
						bloodeffect:SetOrigin(ent:GetPos())
						bloodeffect:SetScale(200)
						bloodeffect:SetAttachment(12)
						util.Effect("P4_RedMist",bloodeffect)
					end
				end
			end)
			
			timer.Simple(dur1 +dur2 +dur3 +delay +dur4 -0.25,function()
				if IsValid(self) && IsValid(ply) then
					self:DoIdle()
				end
			end)

			self:SoundTimer(0,ply,"cpthazama/persona5/adachi/vo/instakill_start0" .. style .. ".wav")
			self:SoundTimer(dur1,ply,"cpthazama/persona5/adachi/vo/instakill_phase1_0" .. style .. ".wav")
			self:SoundTimer(dur1 +dur2,ply,"cpthazama/persona5/adachi/vo/instakill_phase2_0" .. style .. ".wav")
			self:SoundTimer(dur1 +dur2 +dur3,ply,"cpthazama/persona5/adachi/vo/instakill_phase3_0" .. style .. ".wav")
			self:SoundTimer(dur1 +dur2 +dur3 +delay +dur4 -1,ply,"cpthazama/persona5/adachi/vo/instakill_end0" .. style .. ".wav")
		end
	end
	if self.InstaKillStage == 1 then
		self:MoveToPos(self:GetPos() +Vector(0,0,-5),1.25)
	end
	if IsValid(self.InstaKillTarget) && self.InstaKillStage != 0 then
		self.InstaKillTarget:SetPos(self.InstaKillTargetPos +Vector(0,0,-(self.InstaKillTarget:OBBMaxs().z /2)))
		if self.InstaKillTarget:IsNPC() then
			self.InstaKillTarget:StopMoving()
			self.InstaKillTarget:StopMoving()
			self.InstaKillTarget:ClearSchedule()
			-- self.InstaKillTarget:ResetSequence(-1)
			self.InstaKillTarget:ResetSequence(ACT_IDLE)
		end
		SafeRemoveEntity(self.InstaKillTarget:GetActiveWeapon())
	end
end
---------------------------------------------------------------------------------------------------------------------------------------------
function ENT:MagatsuMandala(att,dist)
	local pos = self:GetAttachment(att).Pos
	local tr = util.TraceLine({
		start = pos,
		endpos = pos +self:GetForward() *dist,
	})
	if tr.Hit then
		util.ParticleTracerEx("fo4_libertyprime_laser",pos,tr.HitPos,false,self:EntIndex(),att)
		sound.Play("ambient/energy/weld" .. math.random(1,2) .. ".wav",tr.HitPos,90)
		if tr.Entity && tr.Entity:Health() && tr.Entity:Health() > 0 then
			local dmginfo = DamageInfo()
			dmginfo:SetDamage(5)
			dmginfo:SetAttacker(self.User)
			dmginfo:SetInflictor(self)
			dmginfo:SetDamageType(bit.bor(DMG_DISSOLVE,DMG_ENERGYBEAM))
			dmginfo:SetDamagePosition(tr.Entity:NearestPoint(tr.HitPos))
			tr.Entity:TakeDamageInfo(dmginfo)
		end
	end
end
---------------------------------------------------------------------------------------------------------------------------------------------
function ENT:DoIdle()
	self:SetTask("TASK_IDLE")
	self.CurrentIdle = self.User:Crouching() && "low_hp" or "idle"
	self:PlayAnimation(self.CurrentIdle,1,1)
end
---------------------------------------------------------------------------------------------------------------------------------------------
function ENT:GetAttackPosition()
	return self:GetTask() == "TASK_ATTACK" && self:GetPos() +self:OBBCenter() +self:GetForward() *675 or self:GetPos() +self:OBBCenter()
end
---------------------------------------------------------------------------------------------------------------------------------------------
function ENT:GetSpawnPosition(ply)
	return ply:GetPos() +ply:GetForward() *(ply:Crouching() && -10 or -50) +ply:GetRight() *(ply:Crouching() && -10 or 0)
end
---------------------------------------------------------------------------------------------------------------------------------------------
function ENT:GetIdlePosition(ply)
	return ply:GetPos() +ply:GetForward() *(ply:Crouching() && -10 or -50) +ply:GetRight() *(ply:Crouching() && -10 or 0)
end
---------------------------------------------------------------------------------------------------------------------------------------------
function ENT:OnSummoned(ply)
	ply:EmitSound("cpthazama/persona5/adachi/vo/summon_0" .. math.random(1,8) .. ".wav")
	self.StandDistance = 393.7 *4 -- 40 meters
	self.TimeToMazionga = CurTime() +2
	self.RechargeT = CurTime()
	self.NextInstaKillT = CurTime()
	self.InstaKillTarget = NULL
	self.InstaKillTargetPos = Vector(0,0,0)
	self.IsArmed = false
	self.InstaKillStage = 0
	self.InstaKillStyle = 0

	self.Damage = 400
	
	self:SetNWString("SpecialAttack","Ziodyne")

	local v = {forward=-200,right=80,up=50}
	ply:SetNWVector("Persona_CustomPos",Vector(v.right,v.forward,v.up))
end
---------------------------------------------------------------------------------------------------------------------------------------------
function ENT:OnRequestDisappear(ply)
	-- ply:EmitSound("cpthazama/persona5/joker/0" .. math.random(106,120) .. ".wav")
	local tbl = {
		"cpthazama/vox/adachi/kill/vbtl_pad_0#98 (pad152).wav",
		"cpthazama/vox/adachi/kill/vbtl_pad_0#96 (pad150).wav",
		"cpthazama/vox/adachi/kill/vbtl_pad_0#179 (pad300_1).wav",
		"cpthazama/vox/adachi/kill/vbtl_pad_0#180 (pad300_2).wav",
	}
	ply:EmitSound(VJ_PICK(tbl))
end