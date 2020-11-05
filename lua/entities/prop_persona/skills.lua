---------------------------------------------------------------------------------------------------------------------------------------------
	-- Pre-Made Skills for compatibility on all Persona --
---------------------------------------------------------------------------------------------------------------------------------------------
---------------------------------------------------------------------------------------------------------------------------------------------
function ENT:GhostlyWail(ply) // Magatsu-Izanagi Skill
	if self.User:Health() > self.User:GetMaxHealth() *self:GetMeleeCost() && self:GetTask() == "TASK_IDLE" then
		self:SetTask("TASK_ATTACK")
		self:TakeHP(self.User:GetMaxHealth() *self:GetMeleeCost())
		local tA = self:PlaySet("Ghastly Wail","melee",1)
		self:FindTarget(ply)
		self:SetAngles(self.User:GetAngles())
		if math.random(1,100) <= self.Stats.LUC && math.random(1,2) == 1 then self:DoCritical(2) end
		local t = {0.9,1.4,1.9}
		for _,v in pairs(t) do
			timer.Simple(v,function()
				if IsValid(self) then
					self:MeleeAttackCode(DMG_P_HEAVY,850,70)
				end
			end)
		end
		timer.Simple(tA,function()
			if IsValid(self) then
				self:DoIdle()
			end
		end)
	end
end
---------------------------------------------------------------------------------------------------------------------------------------------
function ENT:HassouTobi(ply)
	local skill = "Hassou Tobi"
	if self.User:Health() > self.User:GetMaxHealth() *self:GetMeleeCost() && self:GetTask() == "TASK_IDLE" then
		self:SetTask("TASK_ATTACK")
		self:TakeHP(self.User:GetMaxHealth() *self:GetMeleeCost())
		local tA = self:PlaySet(skill,"melee",1)
		self:SetAngles(self.User:GetAngles())
		if math.random(1,100) <= self.Stats.LUC && math.random(1,2) == 1 then self:DoCritical(2) end
		local tblOffset = {
			[1] = {f=0,r=350},
			[2] = {f=350,r=350},
			[3] = {f=350,r=0},
			[4] = {f=0,r=0},
			[5] = {f=350,r=0},
			[6] = {f=350,r=350},
			[7] = {f=0,r=350},
			[8] = {f=0,r=0},
		}
		for _,v in pairs(self:FindEnemies(self:GetPos(),1500)) do
			v:EmitSound("cpthazama/persona5/skills/0215.wav",80)
			local doDMG = math.random(1,10) <= 9
			local rPos = v:GetPos()
			for i = 1,8 do
				local effectdata = EffectData()
				local data = tblOffset[i]
				effectdata:SetStart(v:GetPos() +v:GetForward() *data.f +v:GetRight() *data.r)
				effectdata:SetOrigin(v:GetPos() +v:GetForward() *-data.f +v:GetRight() *-data.r)
				effectdata:SetAngles(Angle(255,0,0))
				effectdata:SetRadius(100)
				effectdata:SetHitBox(3)
				util.Effect("Persona_Slice",effectdata)
				local t = 0.3 *i
				timer.Simple(t,function()
					if IsValid(self) && IsValid(v) then
						if doDMG then self:DealDamage(v,DMG_P_MEDIUM,DMG_P_PHYS) end
						effects.BeamRingPoint(rPos +Vector(0,0,5),0.3,4,850,75,0,Color(255,0,0),{material="effects/persona/slice",framerate=20,flags=0})
						effects.BeamRingPoint(rPos +Vector(0,0,5),0.3,4,850,75,0,Color(255,0,0),{material="effects/persona/slice",framerate=20,flags=0})
					end
				end)
			end
		end
		timer.Simple(tA,function()
			if IsValid(self) && self:GetTask() == "TASK_PLAY_ANIMATION" then
				self:PlaySet(skill,"idle",1)
			end
		end)
		timer.Simple(3,function()
			if IsValid(self) then
				self:DoIdle()
			end
		end)
	end
end
---------------------------------------------------------------------------------------------------------------------------------------------
function ENT:YomiDrop(ply,persona,rmb)
	-- if rmb then
		local skill = "Yomi Drop"
		if self.InstaKillStage > 0 then return end
		if self.User:GetSP() >= self.CurrentCardCost && CurTime() > self.NextInstaKillT && self:GetTask() == "TASK_IDLE" && self.InstaKillStage == 0 then
			self:SetTask("TASK_PLAY_ANIMATION")
			local t = self:PlaySet(skill,"range_start",1)
			-- self:PlayAnimation("atk_magatsu_mandala_pre",1)
			self.InstaKillStage = 1
			self.InstaKillTarget = NULL
			self.NextInstaKillT = CurTime() +20
			self:TakeSP(self.CurrentCardCost)
			self:DoCritical(2)

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
					-- self:PlayAnimation("atk_magatsu_mandala_pre_idle",1,1)
					self:PlaySet(skill,"range_start_idle",1,1)
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
						local pUser = self.User
						if pUser:IsNPC() && pUser.VJ_IsBeingControlled then
							pUser = pUser.VJ_TheController
						end
						self:DoInstaKillTheme({pUser,ent},prediction,1)
						-- self:PlayInstaKillTheme({self.User,ent},prediction,1)
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
						-- self:PlayAnimation("atk_magatsu_mandala",1,1)
						self:PlaySet(skill,"range_idle",1,1)
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
								-- self:PlayAnimation("idle",1,1)
								self:PlaySet(skill,"range_end",1,1)
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
	-- end
end
---------------------------------------------------------------------------------------------------------------------------------------------
function ENT:VorpalBlade(ply)
	if self.User:Health() > self.User:GetMaxHealth() *self:GetMeleeCost() && self:GetTask() == "TASK_IDLE" then
		self:SetTask("TASK_ATTACK")
		self:TakeHP(self.User:GetMaxHealth() *self:GetMeleeCost())
		local tA = self:PlaySet("Vorpal Blade","melee",1)
		self:FindTarget(ply)
		self:SetAngles(self.User:GetAngles())
		if math.random(1,100) <= self.Stats.LUC && math.random(1,2) == 1 then self:DoCritical(2) end
		local t = {0.5,0.8,1.1,1.4,1.7,2}
		for _,i in pairs(t) do
			for _,v in pairs(self:FindEnemies(self:GetPos(),1500)) do
				if IsValid(v) then
					timer.Simple(i,function()
						if IsValid(v) && IsValid(self) then
							self:DealDamage(v,DMG_P_MEDIUM,bit.bor(DMG_P_PHYS,DMG_P_CURSE))
							for i = 1,math.random(1,4) do
								local effectdata = EffectData()
								local s = v:NearestPoint(self:GetAttackPosition())
								local dist = 100
								local distEx = 300
								effectdata:SetAngles(Angle(100,250,255))
								effectdata:SetRadius(4)
								effectdata:SetStart(s +Vector(math.Rand(-dist,dist),math.Rand(-dist,dist),math.Rand(-dist,dist)))
								effectdata:SetOrigin(s +Vector(math.Rand(-distEx,distEx),math.Rand(-distEx,distEx),math.Rand(-distEx,distEx)))
								util.Effect("Persona_Slice",effectdata)
							end
						end
					end)
				end
			end
		end
		timer.Simple(tA,function()
			if IsValid(self) then
				self:DoIdle()
			end
		end)
	end
end
---------------------------------------------------------------------------------------------------------------------------------------------
function ENT:OneShotKill(ply,persona)
	local skill = "One-shot Kill"
	if self.User:Health() > self.User:GetMaxHealth() *self:GetMeleeCost() && self:GetTask() == "TASK_IDLE" then
		self:SetTask("TASK_ATTACK")
		local tA = self:PlaySet(skill,"melee",1)
		self:FindTarget(ply)
		self:SetAngles(self.User:GetAngles())
		self:TakeHP(self.User:GetMaxHealth() *self:GetMeleeCost())
		if math.random(1,100) <= math.Clamp(self.Stats.LUC *2,1,99) then self:DoCritical(2) end
		for _,v in pairs(self:FindEnemies(self:GetPos(),1500)) do
			if IsValid(v) then
				v:EmitSound("cpthazama/persona5/skills/0461.wav",90)
				for i = 1,8  do
					timer.Simple(i *0.1,function()
						if IsValid(v) then
							local effectdata = EffectData()
							local s = v:NearestPoint(self:GetAttackPosition())
							local dist = math.Clamp(v:GetPos():Distance(v:GetPos() +v:OBBCenter()) *6,100,1000)
							effectdata:SetStart(s)
							effectdata:SetOrigin(s +v:GetRight() *dist)
							effectdata:SetAngles(Angle(255,255,255))
							effectdata:SetRadius(50)
							util.Effect("Persona_Slice",effectdata)

							local effectdata = EffectData()
							effectdata:SetScale(30)
							effectdata:SetOrigin(s)
							effectdata:SetAttachment(0)
							util.Effect("Persona_Hit_Bullet_Mega",effectdata)
						end
					end)
				end
				timer.Simple(SoundDuration("cpthazama/persona5/skills/0461.wav") -0.6,function()
					if IsValid(v) && IsValid(self) then
						v:EmitSound("cpthazama/persona5/skills/0725.wav",90)
						self:DealDamage(v,DMG_P_MEDIUM,DMG_P_GUN)
						local effectdata = EffectData()
						local s = v:NearestPoint(self:GetAttackPosition())
						effectdata:SetScale(math.Clamp(DMG_P_MEDIUM /3,20,300))
						effectdata:SetOrigin(s)
						util.Effect("Persona_Hit_Bullet_Mega",effectdata)
					end
				end)
			end
		end
		timer.Simple(tA,function()
			if IsValid(self) then
				self:DoIdle()
			end
		end)
	end
end
---------------------------------------------------------------------------------------------------------------------------------------------
function ENT:RiotGun(ply,persona)
	local skill = "Riot Gun"
	if self.User:Health() > self.User:GetMaxHealth() *self:GetMeleeCost() && self:GetTask() == "TASK_IDLE" then
		self:SetTask("TASK_ATTACK")
		local tA = self:PlaySet(skill,"melee",1)
		self:FindTarget(ply)
		self:SetAngles(self.User:GetAngles())
		self:TakeHP(self.User:GetMaxHealth() *self:GetMeleeCost())
		if math.random(1,100) <= self.Stats.LUC && math.random(1,2) == 1 then self:DoCritical(2) end
		for _,v in pairs(self:FindEnemies(self:GetPos(),1500)) do
			if IsValid(v) then
				v:EmitSound("cpthazama/persona5/skills/0227.wav",95)
				for i = 1,20 do
					timer.Simple(i *0.1,function()
						if IsValid(v) then
							local effectdata = EffectData()
							local s = v:GetPos() +v:OBBCenter()
							local dist = math.Clamp(v:GetPos():Distance(v:GetPos() +v:OBBCenter()) *6,250,2000)
							local start = s +Vector(math.Rand(-dist,dist),math.Rand(-dist,dist),dist)
							local tr = util.TraceLine({
								start = start,
								endpos = start +Vector(0,0,-dist *2),
							})
							effectdata:SetStart(start)
							effectdata:SetOrigin(tr.HitPos)
							effectdata:SetAngles(Angle(255,255,255))
							effectdata:SetRadius(math.random(25,35))
							util.Effect("Persona_Slice",effectdata)
						end
					end)
				end
				timer.Simple(2,function()
					if IsValid(v) && IsValid(self) then
						self:DealDamage(v,DMG_P_SEVERE,DMG_P_GUN)
						for i = 1,math.random(1,4) do
							local effectdata = EffectData()
							local s = v:NearestPoint(self:GetAttackPosition())
							local dist = 40
							effectdata:SetScale(math.Clamp(DMG_P_SEVERE /3,20,300))
							effectdata:SetOrigin(s +Vector(math.Rand(-dist,dist),math.Rand(-dist,dist),math.Rand(-dist,dist)))
							util.Effect("Persona_Hit_Bullet",effectdata)
						end
					end
				end)
			end
		end
		timer.Simple(tA,function()
			if IsValid(self) then
				self:DoIdle()
			end
		end)
	end
end
---------------------------------------------------------------------------------------------------------------------------------------------
function ENT:Bash(ply,persona)
	local skill = "Bash"
	if self.User:Health() > self.User:GetMaxHealth() *self:GetMeleeCost() && self:GetTask() == "TASK_IDLE" then
		self:SetTask("TASK_ATTACK")
		local tA = self:PlaySet(skill,"melee",1)
		self:FindTarget(ply)
		self:SetAngles(self.User:GetAngles())
		self:TakeHP(self.User:GetMaxHealth() *self:GetMeleeCost())
		if math.random(1,100) <= self.Stats.LUC && math.random(1,2) == 1 then self:DoCritical(2) end
		timer.Simple(0.8,function()
			if IsValid(self) then
				self:MeleeAttackCode(DMG_P_LIGHT,600,150)
			end
		end)
		timer.Simple(tA,function()
			if IsValid(self) then
				self:DoIdle()
			end
		end)
	end
end
---------------------------------------------------------------------------------------------------------------------------------------------
function ENT:Gigantomachia(ply,persona)
	local skill = "Gigantomachia"
	if self.User:Health() > self.User:GetMaxHealth() *self:GetMeleeCost() && self:GetTask() == "TASK_IDLE" then
		self:SetTask("TASK_ATTACK")
		local tA = self:PlaySet(skill,"melee",1)
		self:FindTarget(ply)
		self:SetAngles(self.User:GetAngles())
		self:TakeHP(self.User:GetMaxHealth() *self:GetMeleeCost())
		if math.random(1,100) <= self.Stats.LUC && math.random(1,2) == 1 then self:DoCritical(2) end
		timer.Simple(1.15,function()
			if IsValid(self) then
				self:MeleeAttackCode(DMG_P_COLOSSAL,1750,180)
			end
		end)
		timer.Simple(tA,function()
			if IsValid(self) then
				self:DoIdle()
			end
		end)
	end
end
---------------------------------------------------------------------------------------------------------------------------------------------
function ENT:Cleave(ply,persona)
	local skill = "Cleave"
	if self.User:Health() > self.User:GetMaxHealth() *self:GetMeleeCost() && self:GetTask() == "TASK_IDLE" then
		self:SetTask("TASK_ATTACK")
		local tA = self:PlaySet(skill,"melee",1)
		self:FindTarget(ply)
		self:SetAngles(self.User:GetAngles())
		self:TakeHP(self.User:GetMaxHealth() *self:GetMeleeCost())
		if math.random(1,100) <= self.Stats.LUC && math.random(1,2) == 1 then self:DoCritical(2) end
		timer.Simple(0.8,function()
			if IsValid(self) then
				self:MeleeAttackCode(DMG_P_LIGHT,600,150)
			end
		end)
		timer.Simple(tA,function()
			if IsValid(self) then
				self:DoIdle()
			end
		end)
	end
end
---------------------------------------------------------------------------------------------------------------------------------------------
function ENT:Laevateinn(ply,persona)
	local skill = "Laevateinn"
	if self.User:Health() > self.User:GetMaxHealth() *self:GetMeleeCost() && self:GetTask() == "TASK_IDLE" then
		self:SetTask("TASK_ATTACK")
		local tA = self:PlaySet(skill,"melee",1)
		self:FindTarget(ply)
		self:SetAngles(self.User:GetAngles())
		self:TakeHP(self.User:GetMaxHealth() *self:GetMeleeCost())
		if math.random(1,100) <= self.Stats.LUC && math.random(1,2) == 1 then self:DoCritical(2) end
		timer.Simple(1.65,function()
			if IsValid(self) then
				self:MeleeAttackCode(DMG_P_COLOSSAL,1000,120)
			end
		end)
		timer.Simple(tA,function()
			if IsValid(self) then
				self:DoIdle()
			end
		end)
	end
end
---------------------------------------------------------------------------------------------------------------------------------------------
function ENT:GodsHand(ply,persona)
	local skill = "God's Hand"
	if self.User:Health() > self.User:GetMaxHealth() *self:GetMeleeCost() && self:GetTask() == "TASK_IDLE" then
		self:SetTask("TASK_ATTACK")
		local tA = self:PlaySet(skill,"melee",1)
		self:FindTarget(ply)
		self:SetAngles(self.User:GetAngles())
		self:TakeHP(self.User:GetMaxHealth() *self:GetMeleeCost())
		if math.random(1,100) <= self.Stats.LUC && math.random(1,2) == 1 then self:DoCritical(2) end
		timer.Simple(1.7,function()
			if IsValid(self) then
				self:MeleeAttackCode(DMG_P_COLOSSAL,1000,100)
			end
		end)
		timer.Simple(tA,function()
			if IsValid(self) then
				self:DoIdle()
			end
		end)
	end
end
---------------------------------------------------------------------------------------------------------------------------------------------
function ENT:VajraBlast(ply,persona)
	local skill = "Vajra Blast"
	if self.User:Health() > self.User:GetMaxHealth() *self:GetMeleeCost() && self:GetTask() == "TASK_IDLE" then
		self:SetTask("TASK_ATTACK")
		local tA = self:PlaySet(skill,"melee",1)
		self:FindTarget(ply)
		self:SetAngles(self.User:GetAngles())
		self:TakeHP(self.User:GetMaxHealth() *self:GetMeleeCost())
		if math.random(1,100) <= self.Stats.LUC && math.random(1,2) == 1 then self:DoCritical(2) end
		timer.Simple(0.8,function()
			if IsValid(self) then
				self:MeleeAttackCode(DMG_P_MEDIUM,600,150)
			end
		end)
		timer.Simple(tA,function()
			if IsValid(self) then
				self:DoIdle()
			end
		end)
	end
end
---------------------------------------------------------------------------------------------------------------------------------------------
function ENT:MiraclePunch(ply,persona)
	local skill = "Miracle Punch"
	if self.User:Health() > self.User:GetMaxHealth() *self:GetMeleeCost() && self:GetTask() == "TASK_IDLE" then
		self:SetTask("TASK_ATTACK")
		local tA = self:PlaySet(skill,"melee",1)
		self:FindTarget(ply)
		self:SetAngles(self.User:GetAngles())
		self:TakeHP(self.User:GetMaxHealth() *self:GetMeleeCost())
		if math.random(1,100) <= self.Stats.LUC *2.5 then self:DoCritical(2) end
		timer.Simple(1,function()
			if IsValid(self) then
				self:MeleeAttackCode(DMG_P_MEDIUM,600,125)
			end
		end)
		timer.Simple(tA,function()
			if IsValid(self) then
				self:DoIdle()
			end
		end)
	end
end
---------------------------------------------------------------------------------------------------------------------------------------------
function ENT:BeastWeaver(ply,persona)
	local skill = "Beast Weaver"
	if self.User:Health() > self.User:GetMaxHealth() *self:GetMeleeCost() && self:GetTask() == "TASK_IDLE" then
		self:SetTask("TASK_ATTACK")
		local tA = self:PlaySet(skill,"melee",1)
		self:FindTarget(ply)
		self:SetAngles(self.User:GetAngles())
		self:TakeHP(self.User:GetMaxHealth() *self:GetMeleeCost())
		if math.random(1,100) <= self.Stats.LUC && math.random(1,2) == 1 then self:DoCritical(2) end
		timer.Simple(1.3,function()
			if IsValid(self) then
				self:MeleeAttackCode(DMG_P_COLOSSAL,1200,90)
				self.User:ChatPrint("Your ATK has been greatly reduced for 5 minutes!")
			end
		end)
		timer.Simple(tA,function()
			if IsValid(self) then
				self:DoIdle()
				self.User.Persona_TarundaT = CurTime() +300
			end
		end)
	end
end
---------------------------------------------------------------------------------------------------------------------------------------------
function ENT:AlmightySlash(ply,persona)
	local skill = "Almighty Slash"
	if self.User:Health() > self.User:GetMaxHealth() *self:GetMeleeCost() && self:GetTask() == "TASK_IDLE" then
		self:SetTask("TASK_ATTACK")
		local tA = self:PlaySet(skill,"melee",1)
		self:FindTarget(ply)
		self:SetAngles(self.User:GetAngles())
		self:TakeHP(self.User:GetMaxHealth() *self:GetMeleeCost())
		if math.random(1,100) <= self.Stats.LUC && math.random(1,2) == 1 then self:DoCritical(2) end
		timer.Simple(0.8,function()
			if IsValid(self) then
				self:MeleeAttackCode(DMG_P_COLOSSAL,850,90,DMG_P_ALMIGHTY)
			end
		end)
		timer.Simple(tA,function()
			if IsValid(self) then
				self:DoIdle()
			end
		end)
	end
end
---------------------------------------------------------------------------------------------------------------------------------------------
function ENT:CrossSlash(ply,persona) // Izanagi Skill
	local skill = "Cross Slash"
	if self.User:Health() > self.User:GetMaxHealth() *self:GetMeleeCost() && self:GetTask() == "TASK_IDLE" then
		self:SetTask("TASK_ATTACK")
		local tA = self:PlaySet(skill,"melee",1)
		self:FindTarget(ply)
		self:SetAngles(self.User:GetAngles())
		self:TakeHP(self.User:GetMaxHealth() *self:GetMeleeCost())
		if math.random(1,100) <= self.Stats.LUC && math.random(1,2) == 1 then self:DoCritical(2) end
		timer.Simple(0.8,function()
			if IsValid(self) then
				self:MeleeAttackCode(DMG_P_HEAVY,600,90)
			end
		end)
		timer.Simple(1,function()
			if IsValid(self) then
				self:MeleeAttackCode(DMG_P_HEAVY,600,90)
			end
		end)
		timer.Simple(tA,function()
			if IsValid(self) then
				self:DoIdle()
			end
		end)
	end
end
---------------------------------------------------------------------------------------------------------------------------------------------
function ENT:HeavensBlade(ply,persona) // Izanagi-no-Okami Skill
	if self.User:Health() > self.User:GetMaxHealth() *self:GetMeleeCost() && self:GetTask() == "TASK_IDLE" then
		self:SetTask("TASK_ATTACK")
		local tA = self:PlaySet("Heaven's Blade","melee",1)
		self:FindTarget(ply)
		self:SetAngles(self.User:GetAngles())
		self:TakeHP(self.User:GetMaxHealth() *self:GetMeleeCost())
		if math.random(1,100) <= self.Stats.LUC && math.random(1,2) == 1 then self:DoCritical(2) end
		timer.Simple(0.8,function()
			if IsValid(self) then
				self:MeleeAttackCode(DMG_P_SEVERE,1500,130)
			end
		end)
		timer.Simple(1.65,function()
			if IsValid(self) then
				self:MeleeAttackCode(DMG_P_SEVERE,1500,130)
			end
		end)
		timer.Simple(1.9,function()
			if IsValid(self) then
				self:MeleeAttackCode(DMG_P_SEVERE,1500,130)
			end
		end)
		timer.Simple(tA,function()
			if IsValid(self) then
				self:DoIdle()
			end
		end)
	end
end
---------------------------------------------------------------------------------------------------------------------------------------------
function ENT:MagatsuBlade(ply,persona) // Magatsu-Izanagi-no-Okami Skill
	if self.User:Health() > self.User:GetMaxHealth() *self:GetMeleeCost() && self:GetTask() == "TASK_IDLE" then
		self:SetTask("TASK_ATTACK")
		local tA = self:PlaySet("Magatsu Blade","melee",1)
		self:FindTarget(ply)
		self:SetAngles(self.User:GetAngles())
		self:TakeHP(self.User:GetMaxHealth() *self:GetMeleeCost())
		if math.random(1,100) <= self.Stats.LUC && math.random(1,2) == 1 then self:DoCritical(2) end
		timer.Simple(0.8,function()
			if IsValid(self) then
				local hents = self:MeleeAttackCode(DMG_P_HEAVY,1500,130)
				if #hents > 0 then
					for _,v in pairs(hents) do
						if IsValid(v) && math.random(1,4) == 1 then
							local spawnparticle = ents.Create("info_particle_system")
							spawnparticle:SetKeyValue("effect_name","vj_per_skill_curse")
							spawnparticle:SetPos(v:GetPos() +v:OBBCenter())
							spawnparticle:Spawn()
							spawnparticle:Activate()
							spawnparticle:Fire("Start","",0)
							spawnparticle:Fire("Kill","",1)

							self:DealDamage(v,DMG_P_MEDIUM,DMG_P_CURSE,2)

							v:EmitSound("cpthazama/persona5/skills/0067.wav",90)
						end
					end
				end
			end
		end)
		timer.Simple(1.65,function()
			if IsValid(self) then
				local hents = self:MeleeAttackCode(DMG_P_HEAVY,1500,130)
				if #hents > 0 then
					for _,v in pairs(hents) do
						if IsValid(v) && math.random(1,4) == 1 then
							local spawnparticle = ents.Create("info_particle_system")
							spawnparticle:SetKeyValue("effect_name","vj_per_skill_curse")
							spawnparticle:SetPos(v:GetPos() +v:OBBCenter())
							spawnparticle:Spawn()
							spawnparticle:Activate()
							spawnparticle:Fire("Start","",0)
							spawnparticle:Fire("Kill","",1)

							self:DealDamage(v,DMG_P_MEDIUM,DMG_P_CURSE,2)

							v:EmitSound("cpthazama/persona5/skills/0067.wav",90)
						end
					end
				end
			end
		end)
		timer.Simple(1.9,function()
			if IsValid(self) then
				local hents = self:MeleeAttackCode(DMG_P_HEAVY,1500,130)
				if #hents > 0 then
					for _,v in pairs(hents) do
						if IsValid(v) && math.random(1,4) == 1 then
							local spawnparticle = ents.Create("info_particle_system")
							spawnparticle:SetKeyValue("effect_name","vj_per_skill_curse")
							spawnparticle:SetPos(v:GetPos() +v:OBBCenter())
							spawnparticle:Spawn()
							spawnparticle:Activate()
							spawnparticle:Fire("Start","",0)
							spawnparticle:Fire("Kill","",1)

							self:DealDamage(v,DMG_P_MEDIUM,DMG_P_CURSE,2)

							v:EmitSound("cpthazama/persona5/skills/0067.wav",90)
						end
					end
				end
			end
		end)
		timer.Simple(tA,function()
			if IsValid(self) then
				self:DoIdle()
			end
		end)
	end
end
---------------------------------------------------------------------------------------------------------------------------------------------
function ENT:Teleport()
	local skill = "Teleport"
	if self.User:GetSP() >= self.CurrentCardCost && self:GetTask() == "TASK_IDLE" then
		self:TakeSP(self.CurrentCardCost)
		self:SetTask("TASK_PLAY_ANIMATION")
		local t = self:PlaySet(skill,"range_start",1)
		self:SetAngles(self.User:GetAngles())
		local tr = self:UserTrace(2000)
		local pos = tr.HitPos +tr.HitNormal *self.User:OBBMaxs()
		timer.Simple(t,function()
			if IsValid(self) then
				t = self:PlaySet(skill,"range_end",1)

				local bloodeffect = EffectData()
				bloodeffect:SetOrigin(self:GetPos() +self:OBBCenter())
				bloodeffect:SetScale(225)
				bloodeffect:SetAttachment(1)
				util.Effect("P4_RedMist",bloodeffect)

				local bloodeffect = EffectData()
				bloodeffect:SetOrigin(self.User:GetPos() +self.User:OBBCenter())
				bloodeffect:SetScale(225)
				bloodeffect:SetAttachment(1)
				util.Effect("P4_RedMist",bloodeffect)
				
				sound.Play("cpthazama/persona5/adachi/blast_charge.wav",self:GetPos(),75)

				self.User:SetPos(pos)
				self:SetPos(self:GetIdlePosition(self.User))

				local bloodeffect = EffectData()
				bloodeffect:SetOrigin(self:GetPos() +self:OBBCenter())
				bloodeffect:SetScale(225)
				bloodeffect:SetAttachment(1)
				util.Effect("P4_RedMist",bloodeffect)

				local bloodeffect = EffectData()
				bloodeffect:SetOrigin(self.User:GetPos() +self.User:OBBCenter())
				bloodeffect:SetScale(225)
				bloodeffect:SetAttachment(1)
				util.Effect("P4_RedMist",bloodeffect)
				
				sound.Play("cpthazama/persona5/adachi/blast_charge.wav",self:GetPos(),75)
				timer.Simple(t,function()
					if IsValid(self) then
						self:DoIdle()
					end
				end)
			end
		end)
	end
end
---------------------------------------------------------------------------------------------------------------------------------------------
function ENT:Garu(ply,persona)
	local skill = "Garu"
	if self.User:GetSP() >= self.CurrentCardCost && self:GetTask() == "TASK_IDLE" then
		self:TakeSP(self.CurrentCardCost)
		self:SetTask("TASK_PLAY_ANIMATION")
		local t = self:PlaySet(skill,"range_start",1)
		if math.random(1,100) <= self.Stats.LUC && math.random(1,2) == 1 then self:DoCritical(2) end
		timer.Simple(t,function()
			if IsValid(self) then
				t = self:PlaySet(skill,"range_start_idle",1,1)
				timer.Simple(0.15,function()
					if IsValid(self) then
						t = self:PlaySet(skill,"range",1)
						local v = ply.Persona_EyeTarget
						local spawnparticle = ents.Create("info_particle_system")
						spawnparticle:SetKeyValue("effect_name","vj_per_skill_garu")
						spawnparticle:SetPos(v:GetPos() +v:OBBCenter())
						spawnparticle:Spawn()
						spawnparticle:Activate()
						spawnparticle:Fire("Start","",0)
						spawnparticle:Fire("SetParent",v:GetName())
						v:EmitSound("cpthazama/persona5/skills/0031.wav",90,90)
						timer.Simple(2,function()
							if IsValid(spawnparticle) then
								spawnparticle:Fire("Kill","",0.1)
							end
							if IsValid(v) then
								self:DealDamage(v,DMG_P_HEAVY,DMG_P_WIND)
							end
						end)
						timer.Simple(t,function()
							if IsValid(self) then
								t = self:PlaySet(skill,"range_idle",1,1)
								timer.Simple(2,function()
									if IsValid(self) then
										t = self:PlaySet(skill,"range_end",1)
										timer.Simple(t,function()
											if IsValid(self) then
												self:DoIdle()
											end
										end)
									end
								end)
							end
						end)
					end
				end)
			end
		end)
	end
end
---------------------------------------------------------------------------------------------------------------------------------------------
function ENT:Garudyne(ply,persona)
	local skill = "Garudyne"
	if self.User:GetSP() >= self.CurrentCardCost && self:GetTask() == "TASK_IDLE" then
		self:TakeSP(self.CurrentCardCost)
		self:SetTask("TASK_PLAY_ANIMATION")
		local t = self:PlaySet(skill,"range_start",1)
		if math.random(1,100) <= self.Stats.LUC && math.random(1,2) == 1 then self:DoCritical(2) end
		timer.Simple(t,function()
			if IsValid(self) then
				t = self:PlaySet(skill,"range_start_idle",1,1)
				timer.Simple(0.15,function()
					if IsValid(self) then
						t = self:PlaySet(skill,"range",1)
						local v = ply.Persona_EyeTarget
						if IsValid(v) then
							local spawnparticle = ents.Create("info_particle_system")
							spawnparticle:SetKeyValue("effect_name","vj_per_skill_garudyne")
							spawnparticle:SetPos(v:GetPos())
							spawnparticle:SetParent(v)
							spawnparticle:Spawn()
							spawnparticle:Activate()
							spawnparticle:Fire("Start","",0)
							spawnparticle:Fire("SetParent",v:GetName())
							v:EmitSound("cpthazama/persona5/skills/0035.wav",90,90)
							timer.Simple(3,function()
								if IsValid(spawnparticle) then
									spawnparticle:Fire("Kill","",0.1)
								end
								if IsValid(v) then
									self:DealDamage(v,DMG_P_HEAVY,DMG_P_WIND)
								end
							end)
						end
						timer.Simple(t,function()
							if IsValid(self) then
								t = self:PlaySet(skill,"range_idle",1,1)
								timer.Simple(4,function()
									if IsValid(self) then
										t = self:PlaySet(skill,"range_end",1)
										timer.Simple(t,function()
											if IsValid(self) then
												self:DoIdle()
											end
										end)
									end
								end)
							end
						end)
					end
				end)
			end
		end)
	end
end
---------------------------------------------------------------------------------------------------------------------------------------------
function ENT:Magarudyne(ply,persona)
	local skill = "Magarudyne"
	if self.User:GetSP() >= self.CurrentCardCost && self:GetTask() == "TASK_IDLE" then
		self:TakeSP(self.CurrentCardCost)
		self:SetTask("TASK_PLAY_ANIMATION")
		local t = self:PlaySet(skill,"range_start",1)
		if math.random(1,100) <= self.Stats.LUC && math.random(1,2) == 1 then self:DoCritical(2) end
		timer.Simple(t,function()
			if IsValid(self) then
				t = self:PlaySet(skill,"range_start_idle",1,1)
				timer.Simple(t,function()
					if IsValid(self) then
						t = self:PlaySet(skill,"range",1)
						for _,v in pairs(self:FindEnemies(self:GetPos(),1500)) do
							if IsValid(v) then
								local spawnparticle = ents.Create("info_particle_system")
								spawnparticle:SetKeyValue("effect_name","vj_per_skill_garudyne")
								spawnparticle:SetPos(v:GetPos())
								spawnparticle:SetParent(v)
								spawnparticle:Spawn()
								spawnparticle:Activate()
								spawnparticle:Fire("Start","",0)
								spawnparticle:Fire("SetParent",v:GetName())
								v:EmitSound("cpthazama/persona5/skills/0035.wav",90,90)
								timer.Simple(3,function()
									if IsValid(spawnparticle) then
										spawnparticle:Fire("Kill","",0.1)
									end
									if IsValid(v) then
										self:DealDamage(v,DMG_P_HEAVY,DMG_P_WIND)
									end
								end)
							end
						end
						timer.Simple(t,function()
							if IsValid(self) then
								t = self:PlaySet(skill,"range_idle",1,1)
								timer.Simple(4,function()
									if IsValid(self) then
										t = self:PlaySet(skill,"range_end",1)
										timer.Simple(t,function()
											if IsValid(self) then
												self:DoIdle()
											end
										end)
									end
								end)
							end
						end)
					end
				end)
			end
		end)
	end
end
---------------------------------------------------------------------------------------------------------------------------------------------
function ENT:Zionga(ply,persona)
	local skill = "Zionga"
	if self.User:GetSP() >= self.CurrentCardCost && self:GetTask() == "TASK_IDLE" then
		self:TakeSP(self.CurrentCardCost)
		self:SetTask("TASK_PLAY_ANIMATION")
		local t = self:PlaySet(skill,"range_start",1.5)
		-- ply:EmitSound("cpthazama/persona5/adachi/vo/curse.wav")
		if math.random(1,100) <= self.Stats.LUC && math.random(1,2) == 1 then self:DoCritical(2) end
		timer.Simple(t -(t *0.5),function()
			if IsValid(self) then
				t = self:PlaySet(skill,"range_start_idle",1,1)
				timer.Simple(0.5,function()
					if IsValid(self) then
						t = self:PlaySet(skill,"range",1)
						timer.Simple(t,function()
							if IsValid(self) then
								t = self:PlaySet(skill,"range_idle",1,1)
								self:EmitSound("beams/beamstart5.wav",90)
								-- local tbl = {
									-- "cpthazama/persona5/adachi/vo/blast.wav",
									-- "cpthazama/vox/adachi/kill/vbtl_pad_0#178 (pad300_0).wav",
									-- "cpthazama/vox/adachi/kill/vbtl_pad_0#122 (pad166_0).wav"
								-- }
								-- ply:EmitSound(VJ_PICK(tbl))
								self.ZioCount = 0
								for a = 1,3 do
									for i = 1,10 do
										self.ZioCount = self.ZioCount +1
										timer.Simple(i *0.15,function()
											if IsValid(self) then
												self:MaziodyneAttack(a,30000,self.Magatsu && "fo4_libertyprime_laser" or nil)
											end
										end)
									end
								end
								timer.Simple(1.5,function()
									if IsValid(self) then
										t = self:PlaySet(skill,"range_end",1)
										timer.Simple(t,function()
											if IsValid(self) then
												self:DoIdle()
											end
										end)
									end
								end)
							end
						end)
					end
				end)
			end
		end)
	end
end
---------------------------------------------------------------------------------------------------------------------------------------------
function ENT:Mazionga(ply,persona)
	local skill = "Mazionga"
	if self.User:GetSP() >= self.CurrentCardCost && self:GetTask() == "TASK_IDLE" then
		self:TakeSP(self.CurrentCardCost)
		self:SetTask("TASK_PLAY_ANIMATION")
		local t = self:PlaySet(skill,"range_start",1.5)
		-- ply:EmitSound("cpthazama/persona5/adachi/vo/curse.wav")
		if math.random(1,100) <= self.Stats.LUC && math.random(1,2) == 1 then self:DoCritical(2) end
		timer.Simple(t -(t *0.5),function()
			if IsValid(self) then
				t = self:PlaySet(skill,"range_start_idle",1,1)
				timer.Simple(0.5,function()
					if IsValid(self) then
						t = self:PlaySet(skill,"range",1)
						timer.Simple(t,function()
							if IsValid(self) then
								t = self:PlaySet(skill,"range_idle",1,1)
								self:EmitSound("beams/beamstart5.wav",90)
								-- local tbl = {
									-- "cpthazama/persona5/adachi/vo/blast.wav",
									-- "cpthazama/vox/adachi/kill/vbtl_pad_0#178 (pad300_0).wav",
									-- "cpthazama/vox/adachi/kill/vbtl_pad_0#122 (pad166_0).wav"
								-- }
								-- ply:EmitSound(VJ_PICK(tbl))
								self.ZioCount = 0
								for a = 1,5 do
									-- local target = VJ_PICK(self:FindEnemies(self:GetPos(),7000))
									for i = 1,10 do
										self.ZioCount = self.ZioCount +1
										timer.Simple(i *0.15,function()
											if IsValid(self) then
												self:MaziodyneAttack(a,30000,self.Magatsu && "fo4_libertyprime_laser" or nil)
											end
										end)
									end
								end
								timer.Simple(1.5,function()
									if IsValid(self) then
										t = self:PlaySet(skill,"range_end",1)
										timer.Simple(t,function()
											if IsValid(self) then
												self:DoIdle()
											end
										end)
									end
								end)
							end
						end)
					end
				end)
			end
		end)
	end
end
---------------------------------------------------------------------------------------------------------------------------------------------
function ENT:Maziodyne(ply,persona)
	local skill = "Maziodyne"
	if self.User:GetSP() >= self.CurrentCardCost && self:GetTask() == "TASK_IDLE" then
		self:TakeSP(self.CurrentCardCost)
		self:SetTask("TASK_PLAY_ANIMATION")
		local t = self:PlaySet(skill,"range_start",1)
		-- ply:EmitSound("cpthazama/persona5/adachi/vo/curse.wav")
		if math.random(1,100) <= self.Stats.LUC && math.random(1,2) == 1 then self:DoCritical(2) end
		timer.Simple(t,function()
			if IsValid(self) then
				t = self:PlaySet(skill,"range_start_idle",1,1)
				timer.Simple(0.5,function()
					if IsValid(self) then
						t = self:PlaySet(skill,"range",1)
						timer.Simple(t,function()
							if IsValid(self) then
								t = self:PlaySet(skill,"range_idle",1,1)
								self:EmitSound("beams/beamstart5.wav",90)
								-- local tbl = {
									-- "cpthazama/persona5/adachi/vo/blast.wav",
									-- "cpthazama/vox/adachi/kill/vbtl_pad_0#178 (pad300_0).wav",
									-- "cpthazama/vox/adachi/kill/vbtl_pad_0#122 (pad166_0).wav"
								-- }
								-- ply:EmitSound(VJ_PICK(tbl))
								self.ZioCount = 0
								for a = 1,5 do
									local target = VJ_PICK(self:FindEnemies(self:GetPos(),7000))
									for i = 1,20 do
										self.ZioCount = self.ZioCount +1
										timer.Simple(i *0.15,function()
											if IsValid(self) then
												self:MaziodyneAttack(a,30000,self.Magatsu && "fo4_libertyprime_laser" or nil,target)
											end
										end)
									end
								end
								timer.Simple(3,function()
									if IsValid(self) then
										t = self:PlaySet(skill,"range_end",1)
										timer.Simple(t,function()
											if IsValid(self) then
												self:DoIdle()
											end
										end)
									end
								end)
							end
						end)
					end
				end)
			end
		end)
	end
end
---------------------------------------------------------------------------------------------------------------------------------------------
function ENT:EvilSmile(ply,persona,rmb)
	if !IsValid(ply.Persona_EyeTarget) then
		return
	end
	local skill = "Evil Smile"
	if self.User:GetSP() >= self.CurrentCardCost && self:GetTask() == "TASK_IDLE" then
		self:SetTask("TASK_PLAY_ANIMATION")
		self:TakeSP(self.CurrentCardCost)
		t = self:PlaySet(skill,self.Animations["special"] && "special" or "range",1)
		-- ply:EmitSound("cpthazama/persona5/adachi/vo/evilsmile.wav",72)
		timer.Simple(0.6,function()
			if IsValid(self) then
				if !IsValid(ply.Persona_EyeTarget) then
					return
				end
				self:Fear(ply.Persona_EyeTarget,15)
				if ply:IsPlayer() then
					ply:ChatPrint("Target is now inflicted with fear!")
				end
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
function ENT:Kougaon(ply,persona)
	if !IsValid(ply.Persona_EyeTarget) then
		return
	end
	local skill = "Kougaon"
	if self.User:GetSP() >= self.CurrentCardCost && self:GetTask() == "TASK_IDLE" then
		self:SetTask("TASK_PLAY_ANIMATION")
		self:TakeSP(self.CurrentCardCost)
		local t = self:PlaySet(skill,"range_start",1)
		timer.Simple(t,function()
			if IsValid(self) then
				t = self:PlaySet(skill,"range",1)
				timer.Simple(t,function()
					if IsValid(self) then
						t = self:PlaySet(skill,"range_idle",1,1)
						local ent = ply.Persona_EyeTarget
						if IsValid(ent) then
							local spawnparticle = ents.Create("info_particle_system")
							spawnparticle:SetKeyValue("effect_name","vj_per_skill_bless")
							spawnparticle:SetPos(ent:GetPos() +ent:OBBCenter())
							spawnparticle:SetParent(ent)
							spawnparticle:Spawn()
							spawnparticle:Activate()
							spawnparticle:Fire("Start","",0)
							spawnparticle:Fire("SetParent",ent:GetName())
							timer.Simple(2,function()
								if IsValid(self) && IsValid(ent) then
									self:DealDamage(ent,DMG_P_HEAVY,DMG_P_BLESS,2)
									ent:EmitSound("cpthazama/persona5/skills/0055.wav",90)
									spawnparticle:Fire("Kill","",0.1)
								end
							end)
						end
						timer.Simple(t,function()
							if IsValid(self) then
								t = self:PlaySet(skill,"range_end",1)
								timer.Simple(t,function()
									if IsValid(self) then
										self:SetTask("TASK_IDLE")
										self:DoIdle()
									end
								end)
							end
						end)
					end
				end)
			end
		end)
	end
end
---------------------------------------------------------------------------------------------------------------------------------------------
function ENT:Makougaon(ply,persona)
	local skill = "Makougaon"
	if self.User:GetSP() >= self.CurrentCardCost && self:GetTask() == "TASK_IDLE" then
		self:SetTask("TASK_PLAY_ANIMATION")
		self:TakeSP(self.CurrentCardCost)
		local t = self:PlaySet(skill,"range_start",1)
		timer.Simple(t,function()
			if IsValid(self) then
				t = self:PlaySet(skill,"range",1)
				timer.Simple(t,function()
					if IsValid(self) then
						t = self:PlaySet(skill,"range_idle",1,1)
						for _,ent in pairs(self:FindEnemies(self:GetPos(),1500)) do
							if IsValid(ent) then
								local spawnparticle = ents.Create("info_particle_system")
								spawnparticle:SetKeyValue("effect_name","vj_per_skill_bless")
								spawnparticle:SetPos(ent:GetPos() +ent:OBBCenter())
								spawnparticle:SetParent(ent)
								spawnparticle:Spawn()
								spawnparticle:Activate()
								spawnparticle:Fire("Start","",0)
								spawnparticle:Fire("SetParent",ent:GetName())
								timer.Simple(2,function()
									if IsValid(self) && IsValid(ent) then
										self:DealDamage(ent,DMG_P_HEAVY,DMG_P_BLESS,2)
										ent:EmitSound("cpthazama/persona5/skills/0055.wav",90)
										spawnparticle:Fire("Kill","",0.1)
									end
								end)
							end
						end
						timer.Simple(t,function()
							if IsValid(self) then
								t = self:PlaySet(skill,"range_end",1)
								timer.Simple(t,function()
									if IsValid(self) then
										self:SetTask("TASK_IDLE")
										self:DoIdle()
									end
								end)
							end
						end)
					end
				end)
			end
		end)
	end
end
---------------------------------------------------------------------------------------------------------------------------------------------
function ENT:Bufu(ply,persona)
	if !IsValid(ply.Persona_EyeTarget) then
		return
	end
	local skill = "Bufu"
	if self.User:GetSP() >= self.CurrentCardCost && self:GetTask() == "TASK_IDLE" then
		self:SetTask("TASK_PLAY_ANIMATION")
		self:TakeSP(self.CurrentCardCost)
		local t = self:PlaySet(skill,"range_start",1)
		timer.Simple(t,function()
			if IsValid(self) then
				t = self:PlaySet(skill,"range",1)
				timer.Simple(t,function()
					if IsValid(self) then
						t = self:PlaySet(skill,"range_idle",1,1)
						local ent = ply.Persona_EyeTarget
						if IsValid(ent) then
							self:IceEffect(ent,DMG_P_LIGHT)
						end
						timer.Simple(t,function()
							if IsValid(self) then
								t = self:PlaySet(skill,"range_end",1)
								timer.Simple(t,function()
									if IsValid(self) then
										self:SetTask("TASK_IDLE")
										self:DoIdle()
									end
								end)
							end
						end)
					end
				end)
			end
		end)
	end
end
---------------------------------------------------------------------------------------------------------------------------------------------
function ENT:Bufula(ply,persona)
	if !IsValid(ply.Persona_EyeTarget) then
		return
	end
	local skill = "Bufula"
	if self.User:GetSP() >= self.CurrentCardCost && self:GetTask() == "TASK_IDLE" then
		self:SetTask("TASK_PLAY_ANIMATION")
		self:TakeSP(self.CurrentCardCost)
		local t = self:PlaySet(skill,"range_start",1)
		timer.Simple(t,function()
			if IsValid(self) then
				t = self:PlaySet(skill,"range",1)
				timer.Simple(t,function()
					if IsValid(self) then
						t = self:PlaySet(skill,"range_idle",1,1)
						local ent = ply.Persona_EyeTarget
						if IsValid(ent) then
							self:IceEffect(ent,DMG_P_MEDIUM,1.25)
						end
						timer.Simple(t,function()
							if IsValid(self) then
								t = self:PlaySet(skill,"range_end",1)
								timer.Simple(t,function()
									if IsValid(self) then
										self:SetTask("TASK_IDLE")
										self:DoIdle()
									end
								end)
							end
						end)
					end
				end)
			end
		end)
	end
end
---------------------------------------------------------------------------------------------------------------------------------------------
function ENT:Bufudyne(ply,persona)
	if !IsValid(ply.Persona_EyeTarget) then
		return
	end
	local skill = "Bufudyne"
	if self.User:GetSP() >= self.CurrentCardCost && self:GetTask() == "TASK_IDLE" then
		self:SetTask("TASK_PLAY_ANIMATION")
		self:TakeSP(self.CurrentCardCost)
		local t = self:PlaySet(skill,"range_start",1)
		timer.Simple(t,function()
			if IsValid(self) then
				t = self:PlaySet(skill,"range",1)
				timer.Simple(t,function()
					if IsValid(self) then
						t = self:PlaySet(skill,"range_idle",1,1)
						local ent = ply.Persona_EyeTarget
						if IsValid(ent) then
							self:IceEffect(ent,DMG_P_HEAVY,1.5)
						end
						timer.Simple(t,function()
							if IsValid(self) then
								t = self:PlaySet(skill,"range_end",1)
								timer.Simple(t,function()
									if IsValid(self) then
										self:SetTask("TASK_IDLE")
										self:DoIdle()
									end
								end)
							end
						end)
					end
				end)
			end
		end)
	end
end
---------------------------------------------------------------------------------------------------------------------------------------------
function ENT:DiamondDust(ply,persona)
	if !IsValid(ply.Persona_EyeTarget) then
		return
	end
	local skill = "Diamond Dust"
	if self.User:GetSP() >= self.CurrentCardCost && self:GetTask() == "TASK_IDLE" then
		self:SetTask("TASK_PLAY_ANIMATION")
		self:TakeSP(self.CurrentCardCost)
		local t = self:PlaySet(skill,"range_start",1)
		timer.Simple(t,function()
			if IsValid(self) then
				t = self:PlaySet(skill,"range",1)
				timer.Simple(t,function()
					if IsValid(self) then
						t = self:PlaySet(skill,"range_idle",1,1)
						local ent = ply.Persona_EyeTarget
						if IsValid(ent) then
							self:IceEffect(ent,DMG_P_SEVERE,2.5)
						end
						t = 3
						timer.Simple(t,function()
							if IsValid(self) then
								t = self:PlaySet(skill,"range_end",1)
								timer.Simple(t,function()
									if IsValid(self) then
										self:SetTask("TASK_IDLE")
										self:DoIdle()
									end
								end)
							end
						end)
					end
				end)
			end
		end)
	end
end
---------------------------------------------------------------------------------------------------------------------------------------------
function ENT:Mabufu(ply,persona)
	local skill = "Mabufu"
	if self.User:GetSP() >= self.CurrentCardCost && self:GetTask() == "TASK_IDLE" then
		self:SetTask("TASK_PLAY_ANIMATION")
		self:TakeSP(self.CurrentCardCost)
		local t = self:PlaySet(skill,"range_start",1)
		timer.Simple(t,function()
			if IsValid(self) then
				t = self:PlaySet(skill,"range",1)
				timer.Simple(t,function()
					if IsValid(self) then
						t = self:PlaySet(skill,"range_idle",1,1)
						for _,v in pairs(self:FindEnemies(self:GetPos(),1500)) do
							if IsValid(v) then
								self:IceEffect(v,DMG_P_LIGHT)
							end
						end
						timer.Simple(t,function()
							if IsValid(self) then
								t = self:PlaySet(skill,"range_end",1)
								timer.Simple(t,function()
									if IsValid(self) then
										self:SetTask("TASK_IDLE")
										self:DoIdle()
									end
								end)
							end
						end)
					end
				end)
			end
		end)
	end
end
---------------------------------------------------------------------------------------------------------------------------------------------
function ENT:Mabufula(ply,persona)
	local skill = "Mabufula"
	if self.User:GetSP() >= self.CurrentCardCost && self:GetTask() == "TASK_IDLE" then
		self:SetTask("TASK_PLAY_ANIMATION")
		self:TakeSP(self.CurrentCardCost)
		local t = self:PlaySet(skill,"range_start",1)
		timer.Simple(t,function()
			if IsValid(self) then
				t = self:PlaySet(skill,"range",1)
				timer.Simple(t,function()
					if IsValid(self) then
						t = self:PlaySet(skill,"range_idle",1,1)
						for _,v in pairs(self:FindEnemies(self:GetPos(),1500)) do
							if IsValid(v) then
								self:IceEffect(v,DMG_P_MEDIUM,1.25)
							end
						end
						timer.Simple(t,function()
							if IsValid(self) then
								t = self:PlaySet(skill,"range_end",1)
								timer.Simple(t,function()
									if IsValid(self) then
										self:SetTask("TASK_IDLE")
										self:DoIdle()
									end
								end)
							end
						end)
					end
				end)
			end
		end)
	end
end
---------------------------------------------------------------------------------------------------------------------------------------------
function ENT:Mabufudyne(ply,persona)
	local skill = "Mabufudyne"
	if self.User:GetSP() >= self.CurrentCardCost && self:GetTask() == "TASK_IDLE" then
		self:SetTask("TASK_PLAY_ANIMATION")
		self:TakeSP(self.CurrentCardCost)
		local t = self:PlaySet(skill,"range_start",1)
		timer.Simple(t,function()
			if IsValid(self) then
				t = self:PlaySet(skill,"range",1)
				timer.Simple(t,function()
					if IsValid(self) then
						t = self:PlaySet(skill,"range_idle",1,1)
						for _,v in pairs(self:FindEnemies(self:GetPos(),1500)) do
							if IsValid(v) then
								self:IceEffect(v,DMG_P_HEAVY,1.5)
							end
						end
						timer.Simple(t,function()
							if IsValid(self) then
								t = self:PlaySet(skill,"range_end",1)
								timer.Simple(t,function()
									if IsValid(self) then
										self:SetTask("TASK_IDLE")
										self:DoIdle()
									end
								end)
							end
						end)
					end
				end)
			end
		end)
	end
end
---------------------------------------------------------------------------------------------------------------------------------------------
function ENT:IceAge(ply,persona)
	local skill = "Ice Age"
	if self.User:GetSP() >= self.CurrentCardCost && self:GetTask() == "TASK_IDLE" then
		self:SetTask("TASK_PLAY_ANIMATION")
		self:TakeSP(self.CurrentCardCost)
		local t = self:PlaySet(skill,"range_start",1)
		timer.Simple(t,function()
			if IsValid(self) then
				t = self:PlaySet(skill,"range",1)
				timer.Simple(t,function()
					if IsValid(self) then
						t = self:PlaySet(skill,"range_idle",1,1)
						for _,v in pairs(self:FindEnemies(self:GetPos(),1500)) do
							if IsValid(v) then
								self:IceEffect(v,DMG_P_SEVERE,2.5)
							end
						end
						t = 3
						timer.Simple(t,function()
							if IsValid(self) then
								t = self:PlaySet(skill,"range_end",1)
								timer.Simple(t,function()
									if IsValid(self) then
										self:SetTask("TASK_IDLE")
										self:DoIdle()
									end
								end)
							end
						end)
					end
				end)
			end
		end)
	end
end
---------------------------------------------------------------------------------------------------------------------------------------------
function ENT:Agi(ply,persona)
	if !IsValid(ply.Persona_EyeTarget) then
		return
	end
	local skill = "Agi"
	if self.User:GetSP() >= self.CurrentCardCost && self:GetTask() == "TASK_IDLE" then
		self:SetTask("TASK_PLAY_ANIMATION")
		self:TakeSP(self.CurrentCardCost)
		local t = self:PlaySet(skill,"range_start",1)
		timer.Simple(t,function()
			if IsValid(self) then
				t = self:PlaySet(skill,"range",1)
				timer.Simple(t,function()
					if IsValid(self) then
						t = self:PlaySet(skill,"range_idle",1,1)
						local ent = ply.Persona_EyeTarget
						if IsValid(ent) then
							self:AgiEffect(ent,DMG_P_LIGHT)
						end
						t = 3
						timer.Simple(t,function()
							if IsValid(self) then
								t = self:PlaySet(skill,"range_end",1)
								timer.Simple(t,function()
									if IsValid(self) then
										self:SetTask("TASK_IDLE")
										self:DoIdle()
									end
								end)
							end
						end)
					end
				end)
			end
		end)
	end
end
---------------------------------------------------------------------------------------------------------------------------------------------
function ENT:Agilao(ply,persona)
	if !IsValid(ply.Persona_EyeTarget) then
		return
	end
	local skill = "Agilao"
	if self.User:GetSP() >= self.CurrentCardCost && self:GetTask() == "TASK_IDLE" then
		self:SetTask("TASK_PLAY_ANIMATION")
		self:TakeSP(self.CurrentCardCost)
		local t = self:PlaySet(skill,"range_start",1)
		timer.Simple(t,function()
			if IsValid(self) then
				t = self:PlaySet(skill,"range",1)
				timer.Simple(t,function()
					if IsValid(self) then
						t = self:PlaySet(skill,"range_idle",1,1)
						local ent = ply.Persona_EyeTarget
						if IsValid(ent) then
							self:AgiEffect(ent,DMG_P_MEDIUM)
						end
						t = 3
						timer.Simple(t,function()
							if IsValid(self) then
								t = self:PlaySet(skill,"range_end",1)
								timer.Simple(t,function()
									if IsValid(self) then
										self:SetTask("TASK_IDLE")
										self:DoIdle()
									end
								end)
							end
						end)
					end
				end)
			end
		end)
	end
end
---------------------------------------------------------------------------------------------------------------------------------------------
function ENT:Inferno(ply,persona)
	if !IsValid(ply.Persona_EyeTarget) then
		return
	end
	local skill = "Inferno"
	if self.User:GetSP() >= self.CurrentCardCost && self:GetTask() == "TASK_IDLE" then
		self:SetTask("TASK_PLAY_ANIMATION")
		self:TakeSP(self.CurrentCardCost)
		local t = self:PlaySet(skill,"range_start",1)
		timer.Simple(t,function()
			if IsValid(self) then
				t = self:PlaySet(skill,"range",1)
				timer.Simple(t,function()
					if IsValid(self) then
						t = self:PlaySet(skill,"range_idle",1,1)
						local ent = ply.Persona_EyeTarget
						if IsValid(ent) then
							self:AgiEffect(ent,DMG_P_SEVERE,2.75,true)
						end
						t = 3
						timer.Simple(t,function()
							if IsValid(self) then
								t = self:PlaySet(skill,"range_end",1)
								timer.Simple(t,function()
									if IsValid(self) then
										self:SetTask("TASK_IDLE")
										self:DoIdle()
									end
								end)
							end
						end)
					end
				end)
			end
		end)
	end
end
---------------------------------------------------------------------------------------------------------------------------------------------
function ENT:Agidyne(ply,persona)
	if !IsValid(ply.Persona_EyeTarget) then
		return
	end
	local skill = "Agidyne"
	if self.User:GetSP() >= self.CurrentCardCost && self:GetTask() == "TASK_IDLE" then
		self:SetTask("TASK_PLAY_ANIMATION")
		self:TakeSP(self.CurrentCardCost)
		local t = self:PlaySet(skill,"range_start",1)
		timer.Simple(t,function()
			if IsValid(self) then
				t = self:PlaySet(skill,"range",1)
				timer.Simple(t,function()
					if IsValid(self) then
						t = self:PlaySet(skill,"range_idle",1,1)
						local ent = ply.Persona_EyeTarget
						if IsValid(ent) then
							self:AgiEffect(ent,DMG_P_HEAVY)
						end
						t = 3
						timer.Simple(t,function()
							if IsValid(self) then
								t = self:PlaySet(skill,"range_end",1)
								timer.Simple(t,function()
									if IsValid(self) then
										self:SetTask("TASK_IDLE")
										self:DoIdle()
									end
								end)
							end
						end)
					end
				end)
			end
		end)
	end
end
---------------------------------------------------------------------------------------------------------------------------------------------
function ENT:Maragi(ply,persona)
	local skill = "Maragi"
	if self.User:GetSP() >= self.CurrentCardCost && self:GetTask() == "TASK_IDLE" then
		self:SetTask("TASK_PLAY_ANIMATION")
		self:TakeSP(self.CurrentCardCost)
		local t = self:PlaySet(skill,"range_start",1)
		timer.Simple(t,function()
			if IsValid(self) then
				t = self:PlaySet(skill,"range",1)
				timer.Simple(t,function()
					if IsValid(self) then
						t = self:PlaySet(skill,"range_idle",1,1)
						for _,v in pairs(self:FindEnemies(self:GetPos(),1500)) do
							if IsValid(v) then
								self:AgiEffect(v,DMG_P_LIGHT)
							end
						end
						timer.Simple(t,function()
							if IsValid(self) then
								t = self:PlaySet(skill,"range_end",1)
								timer.Simple(t,function()
									if IsValid(self) then
										self:SetTask("TASK_IDLE")
										self:DoIdle()
									end
								end)
							end
						end)
					end
				end)
			end
		end)
	end
end
---------------------------------------------------------------------------------------------------------------------------------------------
function ENT:Maragion(ply,persona)
	local skill = "Maragion"
	if self.User:GetSP() >= self.CurrentCardCost && self:GetTask() == "TASK_IDLE" then
		self:SetTask("TASK_PLAY_ANIMATION")
		self:TakeSP(self.CurrentCardCost)
		local t = self:PlaySet(skill,"range_start",1)
		timer.Simple(t,function()
			if IsValid(self) then
				t = self:PlaySet(skill,"range",1)
				timer.Simple(t,function()
					if IsValid(self) then
						t = self:PlaySet(skill,"range_idle",1,1)
						for _,v in pairs(self:FindEnemies(self:GetPos(),1500)) do
							if IsValid(v) then
								self:AgiEffect(v,DMG_P_MEDIUM)
							end
						end
						t = 3
						timer.Simple(t,function()
							if IsValid(self) then
								t = self:PlaySet(skill,"range_end",1)
								timer.Simple(t,function()
									if IsValid(self) then
										self:SetTask("TASK_IDLE")
										self:DoIdle()
									end
								end)
							end
						end)
					end
				end)
			end
		end)
	end
end
---------------------------------------------------------------------------------------------------------------------------------------------
function ENT:Maragidyne(ply,persona)
	local skill = "Maragidyne"
	if self.User:GetSP() >= self.CurrentCardCost && self:GetTask() == "TASK_IDLE" then
		self:SetTask("TASK_PLAY_ANIMATION")
		self:TakeSP(self.CurrentCardCost)
		local t = self:PlaySet(skill,"range_start",1)
		timer.Simple(t,function()
			if IsValid(self) then
				t = self:PlaySet(skill,"range",1)
				timer.Simple(t,function()
					if IsValid(self) then
						t = self:PlaySet(skill,"range_idle",1,1)
						for _,v in pairs(self:FindEnemies(self:GetPos(),1500)) do
							if IsValid(v) then
								self:AgiEffect(v,DMG_P_HEAVY)
							end
						end
						t = 3
						timer.Simple(t,function()
							if IsValid(self) then
								t = self:PlaySet(skill,"range_end",1)
								timer.Simple(t,function()
									if IsValid(self) then
										self:SetTask("TASK_IDLE")
										self:DoIdle()
									end
								end)
							end
						end)
					end
				end)
			end
		end)
	end
end
---------------------------------------------------------------------------------------------------------------------------------------------
function ENT:Titanomachia(ply,persona)
	local skill = "Titanomachia"
	if self.User:GetSP() >= self.CurrentCardCost && self:GetTask() == "TASK_IDLE" then
		self:SetTask("TASK_PLAY_ANIMATION")
		self:TakeSP(self.CurrentCardCost)
		local t = self:PlaySet(skill,"range_start",1)
		timer.Simple(t,function()
			if IsValid(self) then
				t = self:PlaySet(skill,"range_start_idle",1,1)
				timer.Simple(4,function()
					if IsValid(self) then
						t = self:PlaySet(skill,"range",1)
						timer.Simple(t,function()
							if IsValid(self) then
								t = self:PlaySet(skill,"range_idle",1,1)
								for _,v in pairs(self:FindEnemies(self:GetPos(),2500)) do
									if IsValid(v) then
										self:AgiEffect(v,DMG_P_SEVERE,2.75,true)
									end
								end
								t = 4
								timer.Simple(t,function()
									if IsValid(self) then
										t = self:PlaySet(skill,"range_end",1)
										timer.Simple(t,function()
											if IsValid(self) then
												self:SetTask("TASK_IDLE")
												self:DoIdle()
											end
										end)
									end
								end)
							end
						end)
					end
				end)
			end
		end)
	end
end
---------------------------------------------------------------------------------------------------------------------------------------------
function ENT:BlazingHell(ply,persona)
	local skill = "Blazing Hell"
	if self.User:GetSP() >= self.CurrentCardCost && self:GetTask() == "TASK_IDLE" then
		self:SetTask("TASK_PLAY_ANIMATION")
		self:TakeSP(self.CurrentCardCost)
		local t = self:PlaySet(skill,"range_start",1)
		timer.Simple(t,function()
			if IsValid(self) then
				t = self:PlaySet(skill,"range_start_idle",1,1)
				timer.Simple(4,function()
					if IsValid(self) then
						t = self:PlaySet(skill,"range",1)
						timer.Simple(t,function()
							if IsValid(self) then
								t = self:PlaySet(skill,"range_idle",1,1)
								for _,v in pairs(self:FindEnemies(self:GetPos(),2500)) do
									if IsValid(v) then
										self:AgiEffect(v,DMG_P_SEVERE,2.5,true)
									end
								end
								t = 3.25
								timer.Simple(t,function()
									if IsValid(self) then
										t = self:PlaySet(skill,"range_end",1)
										timer.Simple(t,function()
											if IsValid(self) then
												self:SetTask("TASK_IDLE")
												self:DoIdle()
											end
										end)
									end
								end)
							end
						end)
					end
				end)
			end
		end)
	end
end
---------------------------------------------------------------------------------------------------------------------------------------------
function ENT:Eigaon(ply,persona)
	if !IsValid(ply.Persona_EyeTarget) then
		return
	end
	local skill = "Eigaon"
	if self.User:GetSP() >= self.CurrentCardCost && self:GetTask() == "TASK_IDLE" then
		self:SetTask("TASK_PLAY_ANIMATION")
		self:TakeSP(self.CurrentCardCost)
		local t = self:PlaySet(skill,"range_start",1)
		timer.Simple(t,function()
			if IsValid(self) then
				t = self:PlaySet(skill,"range",1)
				timer.Simple(t,function()
					if IsValid(self) then
						t = self:PlaySet(skill,"range_idle",1,1)
						local ent = ply.Persona_EyeTarget
						if IsValid(ent) then
							local spawnparticle = ents.Create("info_particle_system")
							spawnparticle:SetKeyValue("effect_name","vj_per_skill_curse")
							spawnparticle:SetPos(ent:GetPos() +ent:OBBCenter())
							spawnparticle:Spawn()
							spawnparticle:Activate()
							spawnparticle:Fire("Start","",0)
							spawnparticle:Fire("Kill","",0.1)

							self:DealDamage(ent,DMG_P_HEAVY,DMG_P_CURSE,2)

							ent:EmitSound("cpthazama/persona5/skills/0067.wav",90)
						end
						timer.Simple(t,function()
							if IsValid(self) then
								t = self:PlaySet(skill,"range_end",1)
								timer.Simple(t,function()
									if IsValid(self) then
										self:SetTask("TASK_IDLE")
										self:DoIdle()
									end
								end)
							end
						end)
					end
				end)
			end
		end)
	end
end
---------------------------------------------------------------------------------------------------------------------------------------------
function ENT:Maeigaon(ply,persona)
	local skill = "Maeigaon"
	if self.User:GetSP() >= self.CurrentCardCost && self:GetTask() == "TASK_IDLE" then
		self:SetTask("TASK_PLAY_ANIMATION")
		self:TakeSP(self.CurrentCardCost)
		local t = self:PlaySet(skill,"range_start",1)
		timer.Simple(t,function()
			if IsValid(self) then
				t = self:PlaySet(skill,"range",1)
				timer.Simple(t,function()
					if IsValid(self) then
						t = self:PlaySet(skill,"range_idle",1,1)
						for _,v in pairs(self:FindEnemies(self:GetPos(),1500)) do
							if IsValid(v) then
								local spawnparticle = ents.Create("info_particle_system")
								spawnparticle:SetKeyValue("effect_name","vj_per_skill_curse")
								spawnparticle:SetPos(v:GetPos() +v:OBBCenter())
								spawnparticle:Spawn()
								spawnparticle:Activate()
								spawnparticle:Fire("Start","",0)
								spawnparticle:Fire("Kill","",1)

								self:DealDamage(v,DMG_P_HEAVY,DMG_P_CURSE,2)

								v:EmitSound("cpthazama/persona5/skills/0067.wav",90)
							end
						end
						timer.Simple(t,function()
							if IsValid(self) then
								t = self:PlaySet(skill,"range_end",1)
								timer.Simple(t,function()
									if IsValid(self) then
										self:SetTask("TASK_IDLE")
										self:DoIdle()
									end
								end)
							end
						end)
					end
				end)
			end
		end)
	end
end
---------------------------------------------------------------------------------------------------------------------------------------------
function ENT:AbyssalWings(ply,persona)
	local skill = "Abyssal Wings"
	if self.User:GetSP() >= self.CurrentCardCost && self:GetTask() == "TASK_IDLE" then
		self:SetTask("TASK_PLAY_ANIMATION")
		self:TakeSP(self.CurrentCardCost)
		local t = self:PlaySet(skill,"range_start",1)
		timer.Simple(t,function()
			if IsValid(self) then
				t = self:PlaySet(skill,"range",1)
				timer.Simple(t,function()
					if IsValid(self) then
						t = self:PlaySet(skill,"range_idle",1,1)
						for _,v in pairs(self:FindEnemies(self:GetPos(),1500)) do
							if IsValid(v) then
								for i = 1,4 do
									local spawnparticle = ents.Create("info_particle_system")
									spawnparticle:SetKeyValue("effect_name","vj_per_skill_curse")
									spawnparticle:SetPos(v:GetPos() +v:OBBCenter() +v:GetRight() *math.Rand(-250,250) +v:GetForward() *math.Rand(-250,250))
									spawnparticle:Spawn()
									spawnparticle:Activate()
									spawnparticle:Fire("Start","",0)
									spawnparticle:Fire("Kill","",1)
								end

								self:DealDamage(v,DMG_P_SEVERE,DMG_P_CURSE,2)

								v:EmitSound("cpthazama/persona5/skills/0069.wav",90)
							end
						end
						timer.Simple(t,function()
							if IsValid(self) then
								t = self:PlaySet(skill,"range_end",1)
								timer.Simple(t,function()
									if IsValid(self) then
										self:SetTask("TASK_IDLE")
										self:DoIdle()
									end
								end)
							end
						end)
					end
				end)
			end
		end)
	end
end
---------------------------------------------------------------------------------------------------------------------------------------------
function ENT:Debilitate(ply,persona,rmb)
	if !IsValid(ply.Persona_EyeTarget) then
		return
	end
	local skill = "Debilitate"
	if self.User:GetSP() >= self.CurrentCardCost && self:GetTask() == "TASK_IDLE" then
		self:SetTask("TASK_PLAY_ANIMATION")
		self:TakeSP(self.CurrentCardCost)
		local t = self:PlaySet(skill,"range_start",1)
		timer.Simple(t,function()
			if IsValid(self) then
				t = self:PlaySet(skill,"range",1)
				timer.Simple(t,function()
					if IsValid(self) then
						t = self:PlaySet(skill,"range_idle",1,1)
						local ent = ply.Persona_EyeTarget
						if IsValid(ent) then
							-- if ent:Visible(self) then
								if ent.Persona_DebilitateT then
									self:DoChat(CurTime() > ent.Persona_DebilitateT && "Decreased target's ATK/DEF/Evasion for 1 minute!" or "Decreased target's ATK/DEF/Evasion time extended!")
								else
									ent.Persona_DebilitateT = CurTime() +60
									self:DoChat("Decreased target's ATK/DEF/Evasion for 1 minute!")
								end
								local spawnparticle = ents.Create("info_particle_system")
								spawnparticle:SetKeyValue("effect_name","vj_per_skill_debuff_all")
								spawnparticle:SetPos(ent:GetPos() +ent:OBBCenter())
								spawnparticle:Spawn()
								spawnparticle:Activate()
								spawnparticle:Fire("Start","",0)
								spawnparticle:Fire("Kill","",0.1)

								ent:EmitSound("cpthazama/persona5/skills/0361.wav",90)
							-- end
						end
						timer.Simple(t,function()
							if IsValid(self) then
								t = self:PlaySet(skill,"range_end",1)
								timer.Simple(t,function()
									if IsValid(self) then
										self:SetTask("TASK_IDLE")
										self:DoIdle()
									end
								end)
							end
						end)
					end
				end)
			end
		end)
	end
end
---------------------------------------------------------------------------------------------------------------------------------------------
function ENT:MyriadTruths(ply,persona)
	if self.User:GetSP() >= self.CurrentCardCost && self:GetTask() == "TASK_IDLE" then
		self:SetTask("TASK_PLAY_ANIMATION")
		local t = self:PlaySet("Myriad Truths","range_start",1)
		self:TakeSP(self.CurrentCardCost)
		if math.random(1,100) <= self.Stats.LUC && math.random(1,2) == 1 then self:DoCritical(2) end
		timer.Simple(t,function()
			if IsValid(self) then
				t = self:PlaySet("Myriad Truths","range",1)
				timer.Simple(t,function()
					if IsValid(self) then
						t = self:PlaySet("Myriad Truths","range_idle",1)
						local tb = {
							[1] = self:GetUp() *350,
							[2] = self:GetUp() *310 +self:GetRight() *50,
							[3] = self:GetUp() *270 +self:GetRight() *100,
							[4] = self:GetUp() *230 +self:GetRight() *150,
							[5] = self:GetUp() *190 +self:GetRight() *200,
							[6] = self:GetUp() *310 +self:GetRight() *-50,
							[7] = self:GetUp() *270 +self:GetRight() *-100,
							[8] = self:GetUp() *230 +self:GetRight() *-150,
							[9] = self:GetUp() *190 +self:GetRight() *-200,
						}
						for i = 1,9 do
							local proj = ents.Create("obj_vj_per_okamiblast")
							proj:SetPos(self:GetPos() +self:OBBCenter() +tb[i])
							proj:SetAngles(IsValid(self:UserTrace().Entity) && (self:UserTrace().Entity:GetPos() +self:UserTrace().Entity:OBBCenter() -proj:GetPos()):Angle() or (self:UserTrace().HitPos -self:GetPos() +self:OBBCenter()):Angle())
							proj:Spawn()
							proj.RadiusDamage = self:AdditionalInput(DMG_P_SEVERE,2)
							proj.RadiusDamage = proj.RadiusDamage *1.25 // Automatic boost
							proj:SetOwner(self.User)
							proj:SetPhysicsAttacker(self.User)
							proj:EmitSound("cpthazama/persona5/skills/0338.wav")
							
							if IsValid(proj:GetPhysicsObject()) then
								proj:GetPhysicsObject():SetVelocity(IsValid(self:UserTrace().Entity) && (self:UserTrace().Entity:GetPos() +self:UserTrace().Entity:OBBCenter() -proj:GetPos()) *5000 or (self:UserTrace().HitPos -proj:GetPos()) *5000)
							end
						end
						timer.Simple(t,function()
							if IsValid(self) then
								t = self:PlaySet("Myriad Truths","range_end",1)
								timer.Simple(t,function()
									if IsValid(self) then
										self:DoIdle()
									end
								end)
							end
						end)
					end
				end)
			end
		end)
	end
end
---------------------------------------------------------------------------------------------------------------------------------------------
function ENT:MyriadMandala(ply,persona)
	if self.User:GetSP() >= self.CurrentCardCost && self:GetTask() == "TASK_IDLE" then
		self:SetTask("TASK_PLAY_ANIMATION")
		local t = self:PlaySet("Myriad Mandala","range_start",1)
		self:TakeSP(self.CurrentCardCost)
		if math.random(1,100) <= self.Stats.LUC && math.random(1,2) == 1 then self:DoCritical(2) end
		timer.Simple(t,function()
			if IsValid(self) then
				t = self:PlaySet("Myriad Mandala","range",1)
				timer.Simple(t,function()
					if IsValid(self) then
						t = self:PlaySet("Myriad Mandala","range_idle",1)
						local tb = {
							[1] = self:GetUp() *350,
							[2] = self:GetUp() *310 +self:GetRight() *50,
							[3] = self:GetUp() *270 +self:GetRight() *100,
							[4] = self:GetUp() *230 +self:GetRight() *150,
							[5] = self:GetUp() *190 +self:GetRight() *200,
							[6] = self:GetUp() *310 +self:GetRight() *-50,
							[7] = self:GetUp() *270 +self:GetRight() *-100,
							[8] = self:GetUp() *230 +self:GetRight() *-150,
							[9] = self:GetUp() *190 +self:GetRight() *-200,
						}
						for i = 1,9 do
							local proj = ents.Create("obj_vj_per_okamiblast")
							proj:SetPos(self:GetPos() +self:OBBCenter() +tb[i])
							proj:SetAngles(IsValid(self:UserTrace().Entity) && (self:UserTrace().Entity:GetPos() +self:UserTrace().Entity:OBBCenter() -proj:GetPos()):Angle() or (self:UserTrace().HitPos -self:GetPos() +self:OBBCenter()):Angle())
							proj:SetNWBool("Magatsu",true)
							proj:Spawn()
							proj.RadiusDamage = self:AdditionalInput(DMG_P_HEAVY,2)
							proj.RadiusDamage = proj.RadiusDamage *1.25 // Automatic boost
							proj.RadiusDamageType = DMG_P_CURSE
							proj:SetOwner(self.User)
							proj:SetPhysicsAttacker(self.User)
							proj:EmitSound("cpthazama/persona5/skills/0338.wav")
							
							if IsValid(proj:GetPhysicsObject()) then
								proj:GetPhysicsObject():SetVelocity(IsValid(self:UserTrace().Entity) && (self:UserTrace().Entity:GetPos() +self:UserTrace().Entity:OBBCenter() -proj:GetPos()) *5000 or (self:UserTrace().HitPos -proj:GetPos()) *5000)
							end
						end
						timer.Simple(t,function()
							if IsValid(self) then
								t = self:PlaySet("Myriad Mandala","range_end",1)
								timer.Simple(t,function()
									if IsValid(self) then
										self:DoIdle()
									end
								end)
							end
						end)
					end
				end)
			end
		end)
	end
end
---------------------------------------------------------------------------------------------------------------------------------------------
function ENT:Freila(ply,persona)
	local skill = "Freila"
	local enemy = ply.Persona_EyeTarget
	if !IsValid(enemy) then
		return
	end
	if self.User:GetSP() >= self.CurrentCardCost && self:GetTask() == "TASK_IDLE" then
		self:SetTask("TASK_PLAY_ANIMATION")
		local t = self:PlaySet(skill,"range_start",1)
		self:TakeSP(self.CurrentCardCost)
		if math.random(1,100) <= self.Stats.LUC && math.random(1,2) == 1 then self:DoCritical(2) end
		timer.Simple(t,function()
			if IsValid(self) then
				t = self:PlaySet(skill,"range",1)
				timer.Simple(t,function()
					if IsValid(self) && IsValid(enemy) then
						t = self:PlaySet(skill,"range_idle",1)

						local proj = ents.Create("obj_vj_per_nuclearblast")
						proj:SetPos(enemy:GetPos() +enemy:OBBMaxs() +Vector(0,0,400))
						proj:SetAngles((enemy:GetPos() +enemy:OBBCenter() -proj:GetPos()):Angle())
						proj:Spawn()
						proj.RadiusDamage = self:AdditionalInput(DMG_P_MEDIUM,2)
						proj.RadiusDamageType = DMG_P_NUCLEAR
						proj:SetOwner(self.User)
						proj:SetPhysicsAttacker(self.User)
						proj:EmitSound("cpthazama/persona5/skills/0338.wav")

						if IsValid(proj:GetPhysicsObject()) then
							proj:GetPhysicsObject():SetVelocity((enemy:GetPos() +enemy:OBBCenter() -proj:GetPos()) *300)
						end
						timer.Simple(t,function()
							if IsValid(self) then
								t = self:PlaySet(skill,"range_end",1)
								timer.Simple(t,function()
									if IsValid(self) then
										self:DoIdle()
									end
								end)
							end
						end)
					end
				end)
			end
		end)
	end
end
---------------------------------------------------------------------------------------------------------------------------------------------
function ENT:Charge(ply,persona)
	if self.User:GetSP() >= self.CurrentCardCost /*&& CurTime() > ply.Persona_ChargedT*/ && self:GetTask() == "TASK_IDLE" then
		self:SetTask("TASK_PLAY_ANIMATION")
		self:TakeSP(self.CurrentCardCost)
		local t = self:PlaySet("Charge","range_start",1)
		timer.Simple(t,function()
			if IsValid(self) then
				t = self:PlaySet("Charge","range",1)
				timer.Simple(t,function()
					if IsValid(self) then
						t = self:PlaySet("Charge","range_idle",1,1)

						self:DoChat(CurTime() > ply.Persona_ChargedT && "Double Physical damage for 1 minute!" or "Double Physical damage time extended!")

						ply.Persona_ChargedT = CurTime() +60
						self:EmitSound("cpthazama/persona5/skills/0361.wav",90)

						local spawnparticle = ents.Create("info_particle_system")
						spawnparticle:SetKeyValue("effect_name","vj_per_skill_atk")
						spawnparticle:SetPos(self:GetPos())
						spawnparticle:Spawn()
						spawnparticle:Activate()
						spawnparticle:Fire("Start","",0)
						spawnparticle:Fire("Kill","",0.1)

						local spawnparticle = ents.Create("info_particle_system")
						spawnparticle:SetKeyValue("effect_name","vj_per_skill_atk")
						spawnparticle:SetPos(self.User:GetPos())
						spawnparticle:Spawn()
						spawnparticle:Activate()
						spawnparticle:Fire("Start","",0)
						spawnparticle:Fire("Kill","",0.1)

						timer.Simple(t,function()
							if IsValid(self) then
								t = self:PlaySet("Charge","range_end",1)
								timer.Simple(t,function()
									if IsValid(self) then
										self:SetTask("TASK_IDLE")
										self:DoIdle()
									end
								end)
							end
						end)
					end
				end)
			end
		end)
	end
end
---------------------------------------------------------------------------------------------------------------------------------------------
function ENT:Concentrate(ply,persona)
	if self.User:GetSP() >= self.CurrentCardCost /*&& CurTime() > ply.Persona_FocusedT*/ && self:GetTask() == "TASK_IDLE" then
		self:SetTask("TASK_PLAY_ANIMATION")
		self:TakeSP(self.CurrentCardCost)
		local t = self:PlaySet("Concentrate","range_start",1)
		timer.Simple(t,function()
			if IsValid(self) then
				t = self:PlaySet("Concentrate","range",1)
				timer.Simple(t,function()
					if IsValid(self) then
						t = self:PlaySet("Concentrate","range_idle",1,1)
						self:DoChat(CurTime() > ply.Persona_FocusedT && "Double Magic damage for 1 minute!" or "Double Magic damage time extended!")

						ply.Persona_FocusedT = CurTime() +60
						self:EmitSound("cpthazama/persona5/skills/0361.wav",90)

						local spawnparticle = ents.Create("info_particle_system")
						spawnparticle:SetKeyValue("effect_name","vj_per_skill_def")
						spawnparticle:SetPos(self:GetPos())
						spawnparticle:Spawn()
						spawnparticle:Activate()
						spawnparticle:Fire("Start","",0)
						spawnparticle:Fire("Kill","",0.1)

						local spawnparticle = ents.Create("info_particle_system")
						spawnparticle:SetKeyValue("effect_name","vj_per_skill_def")
						spawnparticle:SetPos(self.User:GetPos())
						spawnparticle:Spawn()
						spawnparticle:Activate()
						spawnparticle:Fire("Start","",0)
						spawnparticle:Fire("Kill","",0.1)

						timer.Simple(t,function()
							if IsValid(self) then
								t = self:PlaySet("Concentrate","range_end",1)
								timer.Simple(t,function()
									if IsValid(self) then
										self:SetTask("TASK_IDLE")
										self:DoIdle()
									end
								end)
							end
						end)
					end
				end)
			end
		end)
	end
end
---------------------------------------------------------------------------------------------------------------------------------------------
function ENT:Salvation(ply,persona)
	local skill = "Salvation"
	if self.User:GetSP() >= self.CurrentCardCost && self:GetTask() == "TASK_IDLE" then
		self:SetTask("TASK_PLAY_ANIMATION")
		self:TakeSP(self.CurrentCardCost)
		local t = self:PlaySet(skill,"range_start",1)
		timer.Simple(t,function()
			if IsValid(self) then
				t = self:PlaySet(skill,"range",1)
				timer.Simple(t,function()
					if IsValid(self) then
						t = self:PlaySet(skill,"range_idle",1,1)
						self.User:SetHealth(self.User:GetMaxHealth())
						for _,v in pairs(self.User:GetFullParty(true)) do
							v:SetHealth(v:GetMaxHealth())
							v:EmitSound("cpthazama/persona5/skills/0318.wav",85)
							v:RemoveAllDecals()

							local spawnparticle = ents.Create("info_particle_system")
							spawnparticle:SetKeyValue("effect_name","vj_per_skill_heal_mega")
							spawnparticle:SetPos(v:GetPos())
							spawnparticle:Spawn()
							spawnparticle:Activate()
							spawnparticle:Fire("Start","",0)
							spawnparticle:Fire("Kill","",0.1)
						end
						self.User:RemoveAllDecals()
						self:DoChat("Fully restored Party HP and cured all ailments!")
						self:EmitSound("cpthazama/persona5/skills/0318.wav",85)

						local spawnparticle = ents.Create("info_particle_system")
						spawnparticle:SetKeyValue("effect_name","vj_per_skill_heal_mega")
						spawnparticle:SetPos(self.User:GetPos())
						spawnparticle:Spawn()
						spawnparticle:Activate()
						spawnparticle:Fire("Start","",0)
						spawnparticle:Fire("Kill","",0.1)
						timer.Simple(t,function()
							if IsValid(self) then
								t = self:PlaySet(skill,"range_end",1)
								timer.Simple(t,function()
									if IsValid(self) then
										self:SetTask("TASK_IDLE")
										self:DoIdle()
									end
								end)
							end
						end)
					end
				end)
			end
		end)
	end
end
---------------------------------------------------------------------------------------------------------------------------------------------
function ENT:Cadenza(ply,persona)
	local skill = "Cadenza"
	if self.User:GetSP() >= self.CurrentCardCost && self:GetTask() == "TASK_IDLE" then
		self:SetTask("TASK_PLAY_ANIMATION")
		self:TakeSP(self.CurrentCardCost)
		local t = self:PlaySet(skill,"range_start",1)
		timer.Simple(t,function()
			if IsValid(self) then
				t = self:PlaySet(skill,"range",1)
				timer.Simple(t,function()
					if IsValid(self) then
						t = self:PlaySet(skill,"range_idle",1,1)
						local party = self.User:GetFullParty(true)
						local ally = NULL
						if #party > 0 then
							ally = VJ_PICK(party)
						end
						if self.User:Health() > self.User:GetMaxHealth() *0.65 && IsValid(ally) then
							ally:SetHealth(math.Clamp(ally:Health() +(ally:GetMaxHealth() *0.5),1,ally:GetMaxHealth()))
							self:DoChat("Restored 50% of " .. (ally.Nick && ally:Nick() or ally:GetName()) .. "'s HP!")
							ally:EmitSound("cpthazama/persona5/skills/0302.wav",85)
							ally:RemoveAllDecals()

							local spawnparticle = ents.Create("info_particle_system")
							spawnparticle:SetKeyValue("effect_name","vj_per_skill_heal")
							spawnparticle:SetPos(ally:GetPos())
							spawnparticle:Spawn()
							spawnparticle:Activate()
							spawnparticle:Fire("Start","",0)
							spawnparticle:Fire("Kill","",0.1)
						else
							self.User:SetHealth(math.Clamp(self.User:Health() +(self.User:GetMaxHealth() *0.5),1,self.User:GetMaxHealth()))
							self:DoChat("Restored 50% of your HP!")
							self:EmitSound("cpthazama/persona5/skills/0302.wav",85)
							self.User:RemoveAllDecals()

							local spawnparticle = ents.Create("info_particle_system")
							spawnparticle:SetKeyValue("effect_name","vj_per_skill_heal")
							spawnparticle:SetPos(self.User:GetPos())
							spawnparticle:Spawn()
							spawnparticle:Activate()
							spawnparticle:Fire("Start","",0)
							spawnparticle:Fire("Kill","",0.1)
						end
						timer.Simple(t,function()
							if IsValid(self) then
								t = self:PlaySet(skill,"range_end",1)
								timer.Simple(t,function()
									if IsValid(self) then
										self:SetTask("TASK_IDLE")
										self:DoIdle()
									end
								end)
							end
						end)
					end
				end)
			end
		end)
	end
end
---------------------------------------------------------------------------------------------------------------------------------------------
function ENT:Diarama(ply,persona)
	local skill = "Diarama"
	if self.User:GetSP() >= self.CurrentCardCost && self:GetTask() == "TASK_IDLE" then
		self:SetTask("TASK_PLAY_ANIMATION")
		self:TakeSP(self.CurrentCardCost)
		local t = self:PlaySet(skill,"range_start",1)
		timer.Simple(t,function()
			if IsValid(self) then
				t = self:PlaySet(skill,"range",1)
				timer.Simple(t,function()
					if IsValid(self) then
						t = self:PlaySet(skill,"range_idle",1,1)
						local party = self.User:GetFullParty(true)
						local ally = NULL
						if #party > 0 then
							ally = VJ_PICK(party)
						end
						if self.User:Health() > self.User:GetMaxHealth() *0.65 && IsValid(ally) then
							ally:SetHealth(math.Clamp(ally:Health() +(ally:GetMaxHealth() *0.2),1,ally:GetMaxHealth()))
							self:DoChat("Restored 20% of " .. (ally.Nick && ally:Nick() or ally:GetName()) .. "'s HP!")
							ally:EmitSound("cpthazama/persona5/skills/0302.wav",85)
							ally:RemoveAllDecals()

							local spawnparticle = ents.Create("info_particle_system")
							spawnparticle:SetKeyValue("effect_name","vj_per_skill_heal")
							spawnparticle:SetPos(ally:GetPos())
							spawnparticle:Spawn()
							spawnparticle:Activate()
							spawnparticle:Fire("Start","",0)
							spawnparticle:Fire("Kill","",0.1)
						else
							self.User:SetHealth(math.Clamp(self.User:Health() +(self.User:GetMaxHealth() *0.2),1,self.User:GetMaxHealth()))
							self:DoChat("Restored 20% of your HP!")
							self:EmitSound("cpthazama/persona5/skills/0302.wav",85)
							self.User:RemoveAllDecals()

							local spawnparticle = ents.Create("info_particle_system")
							spawnparticle:SetKeyValue("effect_name","vj_per_skill_heal")
							spawnparticle:SetPos(self.User:GetPos())
							spawnparticle:Spawn()
							spawnparticle:Activate()
							spawnparticle:Fire("Start","",0)
							spawnparticle:Fire("Kill","",0.1)
						end

						timer.Simple(t,function()
							if IsValid(self) then
								t = self:PlaySet(skill,"range_end",1)
								timer.Simple(t,function()
									if IsValid(self) then
										self:SetTask("TASK_IDLE")
										self:DoIdle()
									end
								end)
							end
						end)
					end
				end)
			end
		end)
	end
end
---------------------------------------------------------------------------------------------------------------------------------------------
function ENT:Diarahan(ply,persona)
	local skill = "Diarahan"
	if self.User:GetSP() >= self.CurrentCardCost && self:GetTask() == "TASK_IDLE" then
		self:SetTask("TASK_PLAY_ANIMATION")
		self:TakeSP(self.CurrentCardCost)
		local t = self:PlaySet(skill,"range_start",1)
		timer.Simple(t,function()
			if IsValid(self) then
				t = self:PlaySet(skill,"range",1)
				timer.Simple(t,function()
					if IsValid(self) then
						t = self:PlaySet(skill,"range_idle",1,1)
						local party = self.User:GetFullParty(true)
						local ally = NULL
						if #party > 0 then
							ally = VJ_PICK(party)
						end
						if self.User:Health() > self.User:GetMaxHealth() *0.65 && IsValid(ally) then
							ally:SetHealth(ally:GetMaxHealth())
							self:DoChat("Fully restored " .. (ally.Nick && ally:Nick() or ally:GetName()) .. "'s HP!")
							ally:EmitSound("cpthazama/persona5/skills/0302.wav",85)
							ally:RemoveAllDecals()

							local spawnparticle = ents.Create("info_particle_system")
							spawnparticle:SetKeyValue("effect_name","vj_per_skill_heal_mega")
							spawnparticle:SetPos(ally:GetPos())
							spawnparticle:Spawn()
							spawnparticle:Activate()
							spawnparticle:Fire("Start","",0)
							spawnparticle:Fire("Kill","",0.1)
						else
							self.User:SetHealth(self.User:GetMaxHealth())
							self:DoChat("Fully restored HP!")
							self:EmitSound("cpthazama/persona5/skills/0302.wav",85)
							self.User:RemoveAllDecals()

							local spawnparticle = ents.Create("info_particle_system")
							spawnparticle:SetKeyValue("effect_name","vj_per_skill_heal_mega")
							spawnparticle:SetPos(self.User:GetPos())
							spawnparticle:Spawn()
							spawnparticle:Activate()
							spawnparticle:Fire("Start","",0)
							spawnparticle:Fire("Kill","",0.1)
						end
						timer.Simple(t,function()
							if IsValid(self) then
								t = self:PlaySet(skill,"range_end",1)
								timer.Simple(t,function()
									if IsValid(self) then
										self:SetTask("TASK_IDLE")
										self:DoIdle()
									end
								end)
							end
						end)
					end
				end)
			end
		end)
	end
end
---------------------------------------------------------------------------------------------------------------------------------------------
function ENT:Mediarahan(ply,persona)
	local skill = "Mediarahan"
	if self.User:GetSP() >= self.CurrentCardCost && self:GetTask() == "TASK_IDLE" then
		self:SetTask("TASK_PLAY_ANIMATION")
		self:TakeSP(self.CurrentCardCost)
		local t = self:PlaySet(skill,"range_start",1)
		timer.Simple(t,function()
			if IsValid(self) then
				t = self:PlaySet(skill,"range",1)
				timer.Simple(t,function()
					if IsValid(self) then
						t = self:PlaySet(skill,"range_idle",1,1)
						self.User:SetHealth(self.User:GetMaxHealth())
						for _,v in pairs(self.User:GetFullParty(true)) do
							v:SetHealth(v:GetMaxHealth())
							v:EmitSound("cpthazama/persona5/skills/0302.wav",85)
							v:RemoveAllDecals()

							local spawnparticle = ents.Create("info_particle_system")
							spawnparticle:SetKeyValue("effect_name","vj_per_skill_heal_mega")
							spawnparticle:SetPos(v:GetPos())
							spawnparticle:Spawn()
							spawnparticle:Activate()
							spawnparticle:Fire("Start","",0)
							spawnparticle:Fire("Kill","",0.1)
						end
						self.User:RemoveAllDecals()
						self:DoChat("Fully restored Party HP!")
						self:EmitSound("cpthazama/persona5/skills/0302.wav",85)

						local spawnparticle = ents.Create("info_particle_system")
						spawnparticle:SetKeyValue("effect_name","vj_per_skill_heal_mega")
						spawnparticle:SetPos(self.User:GetPos())
						spawnparticle:Spawn()
						spawnparticle:Activate()
						spawnparticle:Fire("Start","",0)
						spawnparticle:Fire("Kill","",0.1)
						timer.Simple(t,function()
							if IsValid(self) then
								t = self:PlaySet(skill,"range_end",1)
								timer.Simple(t,function()
									if IsValid(self) then
										self:SetTask("TASK_IDLE")
										self:DoIdle()
									end
								end)
							end
						end)
					end
				end)
			end
		end)
	end
end
---------------------------------------------------------------------------------------------------------------------------------------------
function ENT:CallOfChaos(ply,persona) // Loki Skill
	local skill = "Call of Chaos"
	if self.User:GetSP() >= self.CurrentCardCost && self:GetTask() == "TASK_IDLE" then
		self:SetTask("TASK_PLAY_ANIMATION")
		self:TakeSP(self.CurrentCardCost)
		local t = self:PlaySet(skill,"range_start",1)
		timer.Simple(t,function()
			if IsValid(self) then
				t = self:PlaySet(skill,"range_start_idle",1,1)
				timer.Simple(t *3,function()
					if IsValid(self) then
						t = self:PlaySet(skill,"range",1)
						self.User:EmitSound("cpthazama/persona5/skills/0068.wav",90)
						timer.Simple(t,function()
							if IsValid(self) then
								t = self:PlaySet(skill,"range_idle",1,1)

								self:DoChat(CurTime() > ply.Persona_ChaosT && "All attacks increased, SP cost doubled, defense decreased for 1 minute!" or "All attacks increased, SP cost doubled, defense decreased time extended!")

								ply.Persona_ChaosT = CurTime() +60

								local spawnparticle = ents.Create("info_particle_system")
								spawnparticle:SetKeyValue("effect_name","vj_per_skill_curse")
								spawnparticle:SetPos(self.User:GetPos())
								spawnparticle:Spawn()
								spawnparticle:Activate()
								spawnparticle:Fire("Start","",0)
								spawnparticle:Fire("Kill","",0.1)
								
								if !self.HasChaosParticle then
									if !self.CurrentCardUsesHP then
										self.CurrentCardCost = self.CurrentCardCost *2
									end
									self:SetNWInt("SpecialAttackCost",self.CurrentCardCost)
									self.HasChaosParticle = true
									self.User:StopParticles()
									ParticleEffectAttach("vj_per_skill_chaos",PATTACH_POINT_FOLLOW,ply,ply:LookupAttachment("origin"))
								end

								timer.Simple(t,function()
									if IsValid(self) then
										t = self:PlaySet(skill,"range_end",1)
										timer.Simple(t,function()
											if IsValid(self) then
												self:SetTask("TASK_IDLE")
												self:DoIdle()
											end
										end)
									end
								end)
							end
						end)
					end
				end)
			end
		end)
	end
end
---------------------------------------------------------------------------------------------------------------------------------------------
function ENT:HeatRiser(ply,persona)
	if self.User:GetSP() >= self.CurrentCardCost /*&& CurTime() > ply.Persona_HeatRiserT*/ && self:GetTask() == "TASK_IDLE" then
		self:SetTask("TASK_PLAY_ANIMATION")
		self:TakeSP(self.CurrentCardCost)
		local t = self:PlaySet("Heat Riser","range_start",1)
		timer.Simple(t,function()
			if IsValid(self) then
				t = self:PlaySet("Heat Riser","range",1)
				timer.Simple(t,function()
					if IsValid(self) then
						t = self:PlaySet("Heat Riser","range_idle",1,1)

						self:DoChat(CurTime() > ply.Persona_HeatRiserT && "Increased Party ATK/DEF/Evasion for 1 minute!" or "Increased ATK/DEF/Evasion time extended!")

						ply.Persona_HeatRiserT = CurTime() +60
						for _,v in pairs(ply:GetFullParty(true)) do
							v.Persona_HeatRiserT = CurTime() +60
							v:EmitSound("cpthazama/persona5/skills/0343.wav",90)

							local spawnparticle = ents.Create("info_particle_system")
							spawnparticle:SetKeyValue("effect_name","vj_per_skill_heatriser")
							spawnparticle:SetPos(v:GetPos())
							spawnparticle:Spawn()
							spawnparticle:Activate()
							spawnparticle:Fire("Start","",0)
							spawnparticle:Fire("Kill","",0.1)
						end
						self:EmitSound("cpthazama/persona5/skills/0343.wav",90)
						-- self:EmitSound("cpthazama/persona5/skills/0361.wav",90)

						local spawnparticle = ents.Create("info_particle_system")
						spawnparticle:SetKeyValue("effect_name","vj_per_skill_heatriser")
						spawnparticle:SetPos(self:GetPos())
						spawnparticle:Spawn()
						spawnparticle:Activate()
						spawnparticle:Fire("Start","",0)
						spawnparticle:Fire("Kill","",0.1)

						local spawnparticle = ents.Create("info_particle_system")
						spawnparticle:SetKeyValue("effect_name","vj_per_skill_heatriser")
						spawnparticle:SetPos(self.User:GetPos())
						spawnparticle:Spawn()
						spawnparticle:Activate()
						spawnparticle:Fire("Start","",0)
						spawnparticle:Fire("Kill","",0.1)

						timer.Simple(t,function()
							if IsValid(self) then
								t = self:PlaySet("Heat Riser","range_end",1)
								timer.Simple(t,function()
									if IsValid(self) then
										self:SetTask("TASK_IDLE")
										self:DoIdle()
									end
								end)
							end
						end)
					end
				end)
			end
		end)
	end
end
---------------------------------------------------------------------------------------------------------------------------------------------
function ENT:Megidola(ply,ent)
	local skill = "Megidola"
	if self.User:GetSP() >= self.CurrentCardCost && self:GetTask() == "TASK_IDLE" then
		self:TakeSP(self.CurrentCardCost)
		self:SetTask("TASK_PLAY_ANIMATION")
		local t = self:PlaySet(skill,"range_start",1)
		if math.random(1,100) <= self.Stats.LUC && math.random(1,2) == 1 then self:DoCritical(2) end
		timer.Simple(t,function()
			if IsValid(self) then
				t = self:PlaySet(skill,"range_start_idle",1)
				timer.Simple(t,function()
					if IsValid(self) then
						t = self:PlaySet(skill,"range",1)
						self:EmitSound("cpthazama/persona5/skills/0070.wav",75)
						for _,v in pairs(self:FindEnemies(self:GetPos(),1500)) do
							if IsValid(v) then
								for i = 1,3  do
									timer.Simple(i *0.4,function()
										if IsValid(v) then
											local effectdata = EffectData()
											local dist = math.Clamp(v:GetPos():Distance(v:GetPos() +v:OBBCenter()) *5,100,1000)
											local s = (v:GetPos() +v:GetUp() *v:GetPos():Distance(v:GetPos() +v:OBBCenter()))
											s = s +Vector(math.Rand(-300,300),math.Rand(-300,300),dist)
											effectdata:SetStart(s)
											effectdata:SetOrigin(v:GetPos() +v:OBBCenter())
											effectdata:SetEntity(v)
											util.Effect("Persona_Megidola",effectdata)

											timer.Simple(3,function()
												if IsValid(v) && IsValid(self) then
													self:DealDamage(v,DMG_P_SEVERE,DMG_P_ALMIGHTY,2)
												end
											end)
										end
									end)
								end
							end
						end
						timer.Simple(t,function()
							if IsValid(self) then
								self:PlaySet(skill,"range_idle",1,1)
								t = 4
								timer.Simple(t,function()
									if IsValid(self) then
										t = self:PlaySet(skill,"range_end",1)
										timer.Simple(t,function()
											if IsValid(self) then
												self:DoIdle()
											end
										end)
									end
								end)
							end
						end)
					end
				end)
			end
		end)
	end
end
---------------------------------------------------------------------------------------------------------------------------------------------
function ENT:Megidolaon(ply,ent)
	local rmb = ply:IsPlayer() && ply:KeyDown(IN_ATTACK2) or true
	local ent = ent or ply.Persona_EyeTarget
	if !IsValid(ent) then
		return
	end
	if self.User:GetSP() >= self.CurrentCardCost && self:GetTask() == "TASK_IDLE" then
		self:TakeSP(self.CurrentCardCost)
		self:SetTask("TASK_PLAY_ANIMATION")
		local t = self:PlaySet("Megidolaon","range_start",1)
		if math.random(1,100) <= self.Stats.LUC && math.random(1,2) == 1 then self:DoCritical(2) end
		timer.Simple(t,function()
			if IsValid(self) then
				t = self:PlaySet("Megidolaon","range_start_idle",1)
				self:EmitSound("cpthazama/persona5/skills/0070.wav",75)
				timer.Simple(t,function()
					if IsValid(self) then
						t = self:PlaySet("Megidolaon","range",1)
						local ent = ent or ply.Persona_EyeTarget
						if IsValid(ent) then
							self:MegidolaonEffect(ent)
						end
						timer.Simple(t,function()
							if IsValid(self) then
								-- t = self:PlaySet("Megidolaon","range_idle",1,1) *5
								self:PlaySet("Megidolaon","range_idle",1,1)
								t = 4
								timer.Simple(t,function()
									if IsValid(self) then
										t = self:PlaySet("Megidolaon","range_end",1)
										timer.Simple(t,function()
											if IsValid(self) then
												self:DoIdle()
											end
										end)
									end
								end)
							end
						end)
					end
				end)
			end
		end)
	end
end
---------------------------------------------------------------------------------------------------------------------------------------------
function ENT:SinfulShell(ply,persona)
	local ent = ply.Persona_EyeTarget
	if !IsValid(ent) then
		return
	end
	local skill = "Sinful Shell"
	if self.User:GetSP() >= self.CurrentCardCost && self:GetTask() == "TASK_IDLE" then
		self:TakeSP(self.CurrentCardCost)
		self:SetTask("TASK_PLAY_ANIMATION")
		local t = self:PlaySet(skill,"range_start",1)
		if math.random(1,100) <= self.Stats.LUC && math.random(1,2) == 1 then self:DoCritical(2) end
		timer.Simple(t,function()
			if IsValid(self) then
				t = self:PlaySet(skill,"range",1)

				self:DoChat(CurTime() > ply.Persona_HeatRiserT && "Increased ATK/DEF/Evasion for 1 minute!" or "Increased ATK/DEF/Evasion time extended!")

				ply.Persona_HeatRiserT = CurTime() +60
				self:EmitSound("cpthazama/persona5/skills/0343.wav",90)

				local spawnparticle = ents.Create("info_particle_system")
				spawnparticle:SetKeyValue("effect_name","vj_per_skill_heatriser")
				spawnparticle:SetPos(self:GetPos())
				spawnparticle:Spawn()
				spawnparticle:Activate()
				spawnparticle:Fire("Start","",0)
				spawnparticle:Fire("Kill","",0.1)

				local spawnparticle = ents.Create("info_particle_system")
				spawnparticle:SetKeyValue("effect_name","vj_per_skill_heatriser")
				spawnparticle:SetPos(self.User:GetPos())
				spawnparticle:Spawn()
				spawnparticle:Activate()
				spawnparticle:Fire("Start","",0)
				spawnparticle:Fire("Kill","",0.1)
				timer.Simple(t,function()
					if IsValid(self) then
						t = self:PlaySet(skill,"range_end",1)
						timer.Simple(t,function()
							if IsValid(self) then
								t = self:PlaySet(skill,"melee",1)
								timer.Simple(1,function()
									if IsValid(self) then
										local ent = ent or ply.Persona_EyeTarget

										local proj = ents.Create("obj_vj_per_sinfulshell")
										proj:SetPos(self:GetAttachment(1).Pos or self:GetPos() +self:OBBCenter())
										proj:SetAngles(IsValid(ent) && (ent:GetPos() +ent:OBBCenter() -proj:GetPos()):Angle())
										proj:Spawn()
										if self.Scaled then
											proj:SetModelScale(0.25,0)
										end
										proj.Persona = self
										proj:SetOwner(self.User)
										proj:SetPhysicsAttacker(self.User)
										proj:EmitSound("cpthazama/persona5/skills/0338.wav")
										
										if IsValid(proj:GetPhysicsObject()) then
											proj:GetPhysicsObject():SetVelocity(IsValid(ent) && (ent:GetPos() +ent:OBBCenter() -proj:GetPos()) *5000)
										end
									end
								end)
								timer.Simple(t,function()
									if IsValid(self) then
										self:DoIdle()
									end
								end)
							end
						end)
					end
				end)
			end
		end)
	end
end
---------------------------------------------------------------------------------------------------------------------------------------------
function ENT:RecoverHPEX(ply,persona)
	local skill = "Recover HP EX"
	if self.User:GetSP() >= self.CurrentCardCost && self:GetTask() == "TASK_IDLE" then
		self:SetTask("TASK_PLAY_ANIMATION")
		self:TakeSP(self.CurrentCardCost)
		local t = self:PlaySet(skill,"range",1)
		timer.Simple(t /4,function()
			if IsValid(self) then
				local allies = self.User:GetFullParty()
				if allies && #allies > 0 then
					for _,v in ipairs(allies) do
						if IsValid(v) then
							v:SetHealth(v:GetMaxHealth())
							VJ_EmitSound(v,"cpthazama/persona5/skills/0302.wav",85)

							local spawnparticle = ents.Create("info_particle_system")
							spawnparticle:SetKeyValue("effect_name","vj_per_skill_heal_mega")
							spawnparticle:SetPos(v:GetPos())
							spawnparticle:Spawn()
							spawnparticle:Activate()
							spawnparticle:Fire("Start","",0)
							spawnparticle:Fire("Kill","",0.1)
						end
					end
					self:DoChat("Fully restored Party HP!")
				end
				timer.Simple(t,function()
					if IsValid(self) then
						self:SetTask("TASK_IDLE")
						self:DoIdle()
					end
				end)
			end
		end)
	end
end
---------------------------------------------------------------------------------------------------------------------------------------------
function ENT:RecoverSPEX(ply,persona)
	local skill = "Recover SP EX"
	if self.User:GetSP() >= self.CurrentCardCost && self:GetTask() == "TASK_IDLE" then
		self:SetTask("TASK_PLAY_ANIMATION")
		self:TakeSP(self.CurrentCardCost)
		local t = self:PlaySet(skill,"range",1)
		timer.Simple(t /4,function()
			if IsValid(self) then
				local allies = self.User:GetFullParty()
				if allies && #allies > 0 then
					for _,v in ipairs(allies) do
						if IsValid(v) then
							v:SetSP(v:GetMaxSP())
							VJ_EmitSound(v,"cpthazama/persona5/skills/0302.wav",85)

							local spawnparticle = ents.Create("info_particle_system")
							spawnparticle:SetKeyValue("effect_name","vj_per_skill_def")
							spawnparticle:SetPos(v:GetPos())
							spawnparticle:Spawn()
							spawnparticle:Activate()
							spawnparticle:Fire("Start","",0)
							spawnparticle:Fire("Kill","",0.1)
						end
					end
					self:DoChat("Fully restored Party SP!")
				end
				timer.Simple(t,function()
					if IsValid(self) then
						self:SetTask("TASK_IDLE")
						self:DoIdle()
					end
				end)
			end
		end)
	end
end
---------------------------------------------------------------------------------------------------------------------------------------------
function ENT:MinorBuff(ply,persona)
	local skill = "Minor Buff"
	if self.User:GetSP() >= self.CurrentCardCost && self:GetTask() == "TASK_IDLE" then
		self:SetTask("TASK_PLAY_ANIMATION")
		self:TakeSP(self.CurrentCardCost)
		local t = self:PlaySet(skill,"range",1)
		timer.Simple(t /4,function()
			if IsValid(self) then
				local allies = self.User:GetFullParty()
				if allies && #allies > 0 then
					for _,v in ipairs(allies) do
						if IsValid(v) then
							v.Persona_TarukajaT = CurTime() +60
							-- VJ_EmitSound(v,"cpthazama/persona5/skills/0302.wav",85)

							local spawnparticle = ents.Create("info_particle_system")
							spawnparticle:SetKeyValue("effect_name","vj_per_skill_atk")
							spawnparticle:SetPos(v:GetPos())
							spawnparticle:Spawn()
							spawnparticle:Activate()
							spawnparticle:Fire("Start","",0)
							spawnparticle:Fire("Kill","",0.1)
						end
					end
					self:DoChat("Buffed Party ATK!")
				end
				timer.Simple(t,function()
					if IsValid(self) then
						self:SetTask("TASK_IDLE")
						self:DoIdle()
					end
				end)
			end
		end)
	end
end
---------------------------------------------------------------------------------------------------------------------------------------------
function ENT:MinorShield(ply,persona)
	local skill = "Minor Shield"
	if self.User:GetSP() >= self.CurrentCardCost && self:GetTask() == "TASK_IDLE" then
		self:SetTask("TASK_PLAY_ANIMATION")
		self:TakeSP(self.CurrentCardCost)
		local t = self:PlaySet(skill,"range",1)
		timer.Simple(t /4,function()
			if IsValid(self) then
				local allies = self.User:GetFullParty()
				if allies && #allies > 0 then
					for _,v in ipairs(allies) do
						if IsValid(v) then
							v.Persona_RakukajaT = CurTime() +60
							-- VJ_EmitSound(v,"cpthazama/persona5/skills/0302.wav",85)

							local spawnparticle = ents.Create("info_particle_system")
							spawnparticle:SetKeyValue("effect_name","vj_per_skill_def")
							spawnparticle:SetPos(v:GetPos())
							spawnparticle:Spawn()
							spawnparticle:Activate()
							spawnparticle:Fire("Start","",0)
							spawnparticle:Fire("Kill","",0.1)
						end
					end
					self:DoChat("Buffed Party DEF!")
				end
				timer.Simple(t,function()
					if IsValid(self) then
						self:SetTask("TASK_IDLE")
						self:DoIdle()
					end
				end)
			end
		end)
	end
end
---------------------------------------------------------------------------------------------------------------------------------------------
function ENT:MinorAwareness(ply,persona)
	local skill = "Minor Awareness"
	if self.User:GetSP() >= self.CurrentCardCost && self:GetTask() == "TASK_IDLE" then
		self:SetTask("TASK_PLAY_ANIMATION")
		self:TakeSP(self.CurrentCardCost)
		local t = self:PlaySet(skill,"range",1)
		timer.Simple(t /4,function()
			if IsValid(self) then
				local allies = self.User:GetFullParty()
				if allies && #allies > 0 then
					for _,v in ipairs(allies) do
						if IsValid(v) then
							v.Persona_SukukajaT = CurTime() +60
							-- VJ_EmitSound(v,"cpthazama/persona5/skills/0302.wav",85)

							local spawnparticle = ents.Create("info_particle_system")
							spawnparticle:SetKeyValue("effect_name","vj_per_skill_evasion")
							spawnparticle:SetPos(v:GetPos())
							spawnparticle:Spawn()
							spawnparticle:Activate()
							spawnparticle:Fire("Start","",0)
							spawnparticle:Fire("Kill","",0.1)
						end
					end
					self:DoChat("Buffed Party AGI/Evasion!")
				end
				timer.Simple(t,function()
					if IsValid(self) then
						self:SetTask("TASK_IDLE")
						self:DoIdle()
					end
				end)
			end
		end)
	end
end
---------------------------------------------------------------------------------------------------------------------------------------------
function ENT:PowerUp(ply,persona)
	local skill = "Power Up"
	if self.User:GetSP() >= self.CurrentCardCost && self:GetTask() == "TASK_IDLE" then
		self:SetTask("TASK_PLAY_ANIMATION")
		self:TakeSP(self.CurrentCardCost)
		local t = self:PlaySet(skill,"range",1)
		timer.Simple(t /4,function()
			if IsValid(self) then
				local allies = self.User:GetFullParty()
				if allies && #allies > 0 then
					for _,v in ipairs(allies) do
						if IsValid(v) then
							v.Persona_HeatRiserT = CurTime() +60
							-- VJ_EmitSound(v,"cpthazama/persona5/skills/0302.wav",85)

							local spawnparticle = ents.Create("info_particle_system")
							spawnparticle:SetKeyValue("effect_name","vj_per_skill_heatriser")
							spawnparticle:SetPos(v:GetPos())
							spawnparticle:Spawn()
							spawnparticle:Activate()
							spawnparticle:Fire("Start","",0)
							spawnparticle:Fire("Kill","",0.1)
						end
					end
					self:DoChat("Buffed Party ATK/DEF/AGI/Accuracy!")
				end
				timer.Simple(t,function()
					if IsValid(self) then
						self:SetTask("TASK_IDLE")
						self:DoIdle()
					end
				end)
			end
		end)
	end
end
---------------------------------------------------------------------------------------------------------------------------------------------
function ENT:UltimateCharge(ply,persona)
	local skill = "Ultimate Charge"
	if self.User:GetSP() >= self.CurrentCardCost && self:GetTask() == "TASK_IDLE" then
		self:SetTask("TASK_PLAY_ANIMATION")
		self:TakeSP(self.CurrentCardCost)
		local t = self:PlaySet(skill,"range",1)
		timer.Simple(t /4,function()
			if IsValid(self) then
				local allies = self.User:GetFullParty()
				if allies && #allies > 0 then
					for _,v in ipairs(allies) do
						if IsValid(v) then
							v.Persona_ChargedT = CurTime() +30
							v.Persona_FocusedT = CurTime() +30
							-- VJ_EmitSound(v,"cpthazama/persona5/skills/0302.wav",85)

							local spawnparticle = ents.Create("info_particle_system")
							spawnparticle:SetKeyValue("effect_name","vj_per_skill_atk")
							spawnparticle:SetPos(v:GetPos())
							spawnparticle:Spawn()
							spawnparticle:Activate()
							spawnparticle:Fire("Start","",0)
							spawnparticle:Fire("Kill","",0.1)

							local spawnparticle = ents.Create("info_particle_system")
							spawnparticle:SetKeyValue("effect_name","vj_per_skill_def")
							spawnparticle:SetPos(v:GetPos())
							spawnparticle:Spawn()
							spawnparticle:Activate()
							spawnparticle:Fire("Start","",0)
							spawnparticle:Fire("Kill","",0.1)
						end
					end
					self:DoChat("Buffed Party Physical/Magic Damage!")
				end
				timer.Simple(t,function()
					if IsValid(self) then
						self:SetTask("TASK_IDLE")
						self:DoIdle()
					end
				end)
			end
		end)
	end
end