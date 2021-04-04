---------------------------------------------------------------------------------------------------------------------------------------------
	-- Pre-Made Skills for compatibility on all Persona --
---------------------------------------------------------------------------------------------------------------------------------------------
---------------------------------------------------------------------------------------------------------------------------------------------
---------------------------------------------------------------------------------------------------------------------------------------------
function ENT:MyriadTruths(ply,persona,d)
	local skill = d && "Myriad Mandala" or "Myriad Truths"
	if self.User:GetSP() >= self.CurrentCardCost && self:GetTask() == "TASK_IDLE" then
		self:SetTask("TASK_PLAY_ANIMATION")
		local t = self:PlaySet(skill,"range_start",1)
		self:TakeSP(self.CurrentCardCost)
		timer.Simple(t,function()
			if IsValid(self) then
				t = self:PlaySet(skill,"range",1)
				if math.random(1,100) <= self.Stats.LUC && math.random(1,2) == 1 then self:DoCritical(2) end
				timer.Simple(t,function()
					if IsValid(self) then
						t = self:PlaySet(skill,"range_idle",1)

						for _,v in pairs(self:FindEnemies(self:GetPos(),3000)) do
							if IsValid(v) && IsValid(self) then
								for i = 1,3 do
									timer.Simple(0.35 *i,function()
										if IsValid(self) && IsValid(v) then
											v:EmitSound("cpthazama/persona5/skills/0619.wav",110)
											self:DealDamage(v,DMG_P_HEAVY,d or DMG_P_ALMIGHTY,2)
											if d then
												v:EmitSound("cpthazama/persona5/skills/0064.wav",100)

												local spawnparticle = ents.Create("info_particle_system")
												spawnparticle:SetKeyValue("effect_name","vj_per_skill_curse")
												spawnparticle:SetPos(v:GetPos() +v:OBBCenter())
												spawnparticle:Spawn()
												spawnparticle:Activate()
												spawnparticle:Fire("Start","",0)
												spawnparticle:Fire("Kill","",1)
											end
										end
									end)
								end
							end
						end
						timer.Simple(t *2,function()
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
function ENT:PiercingStrike(ply,persona,d)
	local skill = "Piercing Strike"
	if self.User:GetSP() >= self.CurrentCardCost && self:GetTask() == "TASK_IDLE" then
		self:SetTask("TASK_PLAY_ANIMATION")
		local t = self:PlaySet(skill,"range_start",1)
		self:TakeSP(self.CurrentCardCost)
		timer.Simple(t,function()
			if IsValid(self) then
				t = self:PlaySet(skill,"range",1)
				timer.Simple(t,function()
					if IsValid(self) then
						t = self:PlaySet(skill,"range_idle",1)
						if math.random(1,100) <= self.Stats.LUC && math.random(1,2) == 1 then self:DoCritical(2) end

						for _,v in pairs(self:FindEnemies(self:GetPos(),1500)) do
							if IsValid(v) && IsValid(self) then
								for i = 1,10 do
									timer.Simple(0.35 *i,function()
										if IsValid(self) && IsValid(v) then
											v:EmitSound("cpthazama/persona5/skills/0619.wav",110)
											self:DealDamage(v,DMG_P_MEDIUM,DMG_P_ALMIGHTY,2)
										end
									end)
								end
							end
						end
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
end
---------------------------------------------------------------------------------------------------------------------------------------------
function ENT:MyriadMandala(ply,persona)
	self:MyriadTruths(ply,persona,DMG_P_CURSE)
end
---------------------------------------------------------------------------------------------------------------------------------------------
function ENT:DreamFog(ply,persona)
	if !IsValid(ply.Persona_EyeTarget) then
		return
	end
	local skill = "Dream Fog"
	local chance = 75
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
						if IsValid(ent) && math.random(1,100) <= chance && (ent.Persona_DreamFogT or 0) < CurTime() then
							self.User:ChatPrint("Target is now under 'Dream Fog' for 30 seconds!")
							ent:SetNW2Bool("Persona_DreamFog",true)
							ent.Persona_DreamFogT = CurTime() +30
							if ent:IsPlayer() then ent:ChatPrint("You've been put under 'Dream Fog' for 30 seconds!") end
							ParticleEffectAttach("persona_fx_dmg_death",PATTACH_POINT_FOLLOW,ent,ent:LookupAttachment("origin"))
							local hookName = "Persona_DreamFogThink_" .. ent:EntIndex()
							hook.Add("Think",hookName,function()
								if !IsValid(ent) then
									hook.Remove("Think",hookName)
									return
								end
								if CurTime() > ent.Persona_DreamFogT || ent:Health() <= 0 || (ent:IsPlayer() && !ent:Alive()) then
									ent:SetNW2Bool("Persona_DreamFog",false)
									ent:StopParticles()
									hook.Remove("Think",hookName)
									return
								end
								ent:SetNW2Bool("Persona_DreamFog",true)
								if ent:IsNPC() then
									ent:SetEnemy(NULL)
								end
								if IsValid(ent:GetPersona()) then SafeRemoveEntity(ent:GetPersona()) end
							end)
						else
							self.User:ChatPrint("Missed Target!")
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
function ENT:LifeDrain(ply,persona)
	if !IsValid(ply.Persona_EyeTarget) then
		return
	end
	local skill = "Life Drain"
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
							local hp = ent:Health()
							local take = hp -20

							ent:EmitSound("cpthazama/persona5/skills/0103.wav")
							self.User:SetHealth(math.Clamp(self.User:Health() +20,1,self.User:GetMaxHealth()))
							ent:SetHealth(math.Clamp(take,1,ent:GetMaxHealth()))

							local spawnparticle = ents.Create("info_particle_system")
							spawnparticle:SetKeyValue("effect_name","vj_per_skill_debuff_evasion")
							spawnparticle:SetPos(ent:GetPos() +ent:OBBCenter())
							spawnparticle:Spawn()
							spawnparticle:Activate()
							spawnparticle:Fire("Start","",0)
							spawnparticle:Fire("Kill","",1)
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
function ENT:SpiritDrain(ply,persona)
	if !IsValid(ply.Persona_EyeTarget) then
		return
	end
	local skill = "Spirit Drain"
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
							local sp = ent:GetSP()
							local take = sp -10

							ent:EmitSound("cpthazama/persona5/skills/0103.wav")
							self.User:SetSP(math.Clamp(self.User:GetSP() +10,1,self.User:GetMaxSP()))
							ent:SetSP(math.Clamp(take,1,ent:GetMaxSP()))

							local spawnparticle = ents.Create("info_particle_system")
							spawnparticle:SetKeyValue("effect_name","vj_per_skill_debuff_def")
							spawnparticle:SetPos(ent:GetPos() +ent:OBBCenter())
							spawnparticle:Spawn()
							spawnparticle:Activate()
							spawnparticle:Fire("Start","",0)
							spawnparticle:Fire("Kill","",1)
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
function ENT:MarinKarin(ply,persona)
	if !IsValid(ply.Persona_EyeTarget) then
		return
	end
	local skill = "Marin Karin"
	local chance = 75
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
							self:BrainWash(ent,75,100)
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
function ENT:GhostlyWail(ply) // Magatsu-Izanagi Skill
	if self.User:Health() > self.User:GetMaxHealth() *self:GetMeleeCost() && self:GetTask() == "TASK_IDLE" then
		self:SetTask("TASK_ATTACK")
		self:TakeHP(self.User:GetMaxHealth() *self:GetMeleeCost())
		local tA = self:PlaySet("Ghastly Wail","melee",1)
		self:FindTarget(ply)
		self:SetAngles(self.User:GetAngles())
		
		timer.Simple((self.StartMeleeDamageCode or 0),function()
			if IsValid(self) then
				if math.random(1,100) <= self.Stats.LUC && math.random(1,2) == 1 then self:DoCritical(2) end
				local oT = (self.FirstMeleeDamageTime or 0.9)
				local t = {oT,oT +0.5,oT +1}
				for _,v in pairs(t) do
					timer.Simple(v,function()
						if IsValid(self) then
							self:MeleeAttackCode(DMG_P_HEAVY /3,850,70,nil,"Curse",5)
						end
					end)
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
function ENT:HassouTobi(ply)
	local skill = "Hassou Tobi"
	if self.User:Health() > self.User:GetMaxHealth() *self:GetMeleeCost() && self:GetTask() == "TASK_IDLE" then
		self:SetTask("TASK_ATTACK")
		self:TakeHP(self.User:GetMaxHealth() *self:GetMeleeCost())
		local tA = self:PlaySet(skill,"melee",1)
		self:SetAngles(self.User:GetAngles())
		timer.Simple((self.StartMeleeDamageCode or 0),function()
			if IsValid(self) then
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
			end
		end)
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
			local dur1 = SoundDuration("cpthazama/vo/adachi/vo/instakill_start0" .. style .. ".wav")
			local dur2 = SoundDuration("cpthazama/vo/adachi/vo/instakill_phase1_0" .. style .. ".wav")
			local dur3 = SoundDuration("cpthazama/vo/adachi/vo/instakill_phase2_0" .. style .. ".wav")
			local delay = 3
			local dur4 = SoundDuration("cpthazama/vo/adachi/vo/instakill_phase3_0" .. style .. ".wav")
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
					self:EmitSound("cpthazama/vo/adachi/redmist.wav")
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
						ent:EmitSound("cpthazama/vo/adachi/redmist_puddle.wav")

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
					self:EmitSound("cpthazama/vo/adachi/redmist.wav")
				end
			end)

			timer.Simple(dur1 +dur2 +dur3,function()
				if IsValid(self) && IsValid(ply) then
					if IsValid(self.InstaKillTarget) && self.InstaKillStage != 0 then
						-- self:PlayAnimation("atk_magatsu_mandala",1,1)
						self:PlaySet(skill,"range_idle",1,1)
						self:EmitSound("cpthazama/vo/adachi/blast_charge.wav",120)
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
						self:EmitSound("cpthazama/vo/adachi/slash.wav",120)
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

			self:SoundTimer(0,ply,"cpthazama/vo/adachi/vo/instakill_start0" .. style .. ".wav")
			self:SoundTimer(dur1,ply,"cpthazama/vo/adachi/vo/instakill_phase1_0" .. style .. ".wav")
			self:SoundTimer(dur1 +dur2,ply,"cpthazama/vo/adachi/vo/instakill_phase2_0" .. style .. ".wav")
			self:SoundTimer(dur1 +dur2 +dur3,ply,"cpthazama/vo/adachi/vo/instakill_phase3_0" .. style .. ".wav")
			self:SoundTimer(dur1 +dur2 +dur3 +delay +dur4 -1,ply,"cpthazama/vo/adachi/vo/instakill_end0" .. style .. ".wav")
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
		timer.Simple((self.StartMeleeDamageCode or 0),function()
			if IsValid(self) then
				if math.random(1,100) <= self.Stats.LUC && math.random(1,2) == 1 then self:DoCritical(2) end
				local oT = (self.FirstMeleeDamageTime or 0.5)
				local t = {oT}
				for i = 1,5 do
					table.insert(t,oT +(0.3 *1))
				end
				-- local t = {0.5,0.8,1.1,1.4,1.7,2}
				for _,i in pairs(t) do
					for _,v in pairs(self:FindEnemies(self:GetPos(),1500)) do
						if IsValid(v) && IsValid(self) then
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
function ENT:OneShotKill(ply,persona)
	local skill = "One-shot Kill"
	if self.User:Health() > self.User:GetMaxHealth() *self:GetMeleeCost() && self:GetTask() == "TASK_IDLE" then
		self:SetTask("TASK_ATTACK")
		local tA = self:PlaySet(skill,"melee",1)
		self:FindTarget(ply)
		self:SetAngles(self.User:GetAngles())
		self:TakeHP(self.User:GetMaxHealth() *self:GetMeleeCost())
		timer.Simple((self.StartMeleeDamageCode or 0),function()
			if IsValid(self) then
				for _,v in pairs(self:FindEnemies(self:GetPos(),1500)) do
					if IsValid(v) && IsValid(self) then
						v:EmitSound("cpthazama/persona5/skills/0461.wav",90)
						for i = 1,8  do
							timer.Simple(i *0.1,function()
								if IsValid(v) && IsValid(self) then
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
									if i == 5 then
										if math.random(1,100) <= self.Stats.LUC && math.random(1,2) == 1 then self:DoCritical(2) end
									end
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
function ENT:RiotGun(ply,persona)
	local skill = "Riot Gun"
	if self.User:Health() > self.User:GetMaxHealth() *self:GetMeleeCost() && self:GetTask() == "TASK_IDLE" then
		self:SetTask("TASK_ATTACK")
		local tA = self:PlaySet(skill,"melee",1)
		self:FindTarget(ply)
		self:SetAngles(self.User:GetAngles())
		self:TakeHP(self.User:GetMaxHealth() *self:GetMeleeCost())
		timer.Simple((self.StartMeleeDamageCode or 0),function()
			if IsValid(self) then
				for _,v in pairs(self:FindEnemies(self:GetPos(),1500)) do
					if IsValid(v) && IsValid(self) then
						v:EmitSound("cpthazama/persona5/skills/0227.wav",95)
						for i = 1,20 do
							timer.Simple(i *0.1,function()
								if IsValid(v) && IsValid(self) then
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
									if i == 15 then
										if math.random(1,100) <= self.Stats.LUC && math.random(1,2) == 1 then self:DoCritical(2) end
									end
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
function ENT:Bash(ply,persona)
	local skill = "Bash"
	if self.User:Health() > self.User:GetMaxHealth() *self:GetMeleeCost() && self:GetTask() == "TASK_IDLE" then
		self:SetTask("TASK_ATTACK")
		local tA = self:PlaySet(skill,"melee",1)
		self:FindTarget(ply)
		self:SetAngles(self.User:GetAngles())
		self:TakeHP(self.User:GetMaxHealth() *self:GetMeleeCost())
		timer.Simple((self.StartMeleeDamageCode or 0),function()
			if IsValid(self) then
				if math.random(1,100) <= self.Stats.LUC && math.random(1,2) == 1 then self:DoCritical(2) end
				timer.Simple((self.FirstMeleeDamageTime or 0.8),function()
					if IsValid(self) then
						self:MeleeAttackCode(DMG_P_LIGHT,1500,150)
					end
				end)
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
		timer.Simple((self.StartMeleeDamageCode or 0),function()
			if IsValid(self) then
				if math.random(1,100) <= self.Stats.LUC && math.random(1,2) == 1 then self:DoCritical(2) end
				timer.Simple((self.FirstMeleeDamageTime or 1.15),function()
					if IsValid(self) then
						self:MeleeAttackCode(DMG_P_COLOSSAL,1750,180)
					end
				end)
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
		timer.Simple((self.StartMeleeDamageCode or 0),function()
			if IsValid(self) then
				if math.random(1,100) <= self.Stats.LUC && math.random(1,2) == 1 then self:DoCritical(2) end
				timer.Simple((self.FirstMeleeDamageTime or 0.8),function()
					if IsValid(self) then
						self:MeleeAttackCode(DMG_P_LIGHT,1500,150)
					end
				end)
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
function ENT:MegatonRaid(ply,persona)
	local skill = "Megaton Raid"
	if self.User:Health() > self.User:GetMaxHealth() *self:GetMeleeCost() && self:GetTask() == "TASK_IDLE" then
		self:SetTask("TASK_ATTACK")
		local tA = self:PlaySet(skill,"melee",1)
		self:FindTarget(ply)
		self:SetAngles(self.User:GetAngles())
		self:TakeHP(self.User:GetMaxHealth() *self:GetMeleeCost())
		timer.Simple((self.StartMeleeDamageCode or 0),function()
			if IsValid(self) then
				if math.random(1,100) <= self.Stats.LUC && math.random(1,2) == 1 then self:DoCritical(2) end
				timer.Simple((self.FirstMeleeDamageTime or 0.8),function()
					if IsValid(self) then
						self:MeleeAttackCode(DMG_P_SEVERE,1500,150)
					end
				end)
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
function ENT:HeatWave(ply,persona)
	local skill = "Heat Wave"
	if self.User:Health() > self.User:GetMaxHealth() *self:GetMeleeCost() && self:GetTask() == "TASK_IDLE" then
		self:SetTask("TASK_ATTACK")
		local tA = self:PlaySet(skill,"melee",1)
		self:FindTarget(ply)
		self:SetAngles(self.User:GetAngles())
		self:TakeHP(self.User:GetMaxHealth() *self:GetMeleeCost())
		timer.Simple((self.StartMeleeDamageCode or 0),function()
			if IsValid(self) then
				if math.random(1,100) <= self.Stats.LUC && math.random(1,2) == 1 then self:DoCritical(2) end
				timer.Simple((self.FirstMeleeDamageTime or 0.8),function()
					if IsValid(self) then
						self:MeleeAttackCode(DMG_P_MEDIUM,1500,150)
					end
				end)
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
function ENT:BlackSpot(ply,persona)
	local skill = "Black Spot"
	if self.User:Health() > self.User:GetMaxHealth() *self:GetMeleeCost() && self:GetTask() == "TASK_IDLE" then
		self:SetTask("TASK_ATTACK")
		local tA = self:PlaySet(skill,"melee",1)
		self:FindTarget(ply)
		self:SetAngles(self.User:GetAngles())
		self:TakeHP(self.User:GetMaxHealth() *self:GetMeleeCost())
		timer.Simple((self.StartMeleeDamageCode or 0),function()
			if IsValid(self) then
				if math.random(1,100) <= self.Stats.LUC && math.random(1,3) == 1 then self:DoCritical(2) end
				timer.Simple((self.FirstMeleeDamageTime or 0.8),function()
					if IsValid(self) then
						self:MeleeAttackCode(DMG_P_MEDIUM,1500,150)
					end
				end)
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
function ENT:GaleSlash(ply,persona)
	local skill = "Gale Slash"
	if self.User:Health() > self.User:GetMaxHealth() *self:GetMeleeCost() && self:GetTask() == "TASK_IDLE" then
		self:SetTask("TASK_ATTACK")
		local tA = self:PlaySet(skill,"melee",1)
		self:FindTarget(ply)
		self:SetAngles(self.User:GetAngles())
		self:TakeHP(self.User:GetMaxHealth() *self:GetMeleeCost())
		timer.Simple((self.StartMeleeDamageCode or 0),function()
			if IsValid(self) then
				if math.random(1,100) <= self.Stats.LUC && math.random(1,100) <= 5 then self:DoCritical(2) end
				timer.Simple((self.FirstMeleeDamageTime or 0.8),function()
					if IsValid(self) then
						self:MeleeAttackCode(DMG_P_LIGHT,1500,150)
					end
				end)
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
function ENT:SkullCracker(ply,persona)
	local skill = "Skull Cracker"
	if self.User:Health() > self.User:GetMaxHealth() *self:GetMeleeCost() && self:GetTask() == "TASK_IDLE" then
		self:SetTask("TASK_ATTACK")
		local tA = self:PlaySet(skill,"melee",1)
		self:FindTarget(ply)
		self:SetAngles(self.User:GetAngles())
		self:TakeHP(self.User:GetMaxHealth() *self:GetMeleeCost())
		timer.Simple((self.StartMeleeDamageCode or 0),function()
			if IsValid(self) then
				if math.random(1,100) <= self.Stats.LUC && math.random(1,100) <= 5 then self:DoCritical(2) end
				timer.Simple((self.FirstMeleeDamageTime or 0.8),function()
					if IsValid(self) then
						local tbl = self:MeleeAttackCode(DMG_P_LIGHT,1500,150)
						if #tbl > 0 then
							for _,v in pairs(tbl) do
								if IsValid(v) && math.random(1,2) == 1 then
									self:Confuse(v,15)
								end
							end
						end
					end
				end)
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
function ENT:Rampage(ply,persona)
	local skill = "Rampage"
	if self.User:Health() > self.User:GetMaxHealth() *self:GetMeleeCost() && self:GetTask() == "TASK_IDLE" then
		self:SetTask("TASK_ATTACK")
		local tA = self:PlaySet(skill,"melee",1)
		self:FindTarget(ply)
		self:SetAngles(self.User:GetAngles())
		self:TakeHP(self.User:GetMaxHealth() *self:GetMeleeCost())
		timer.Simple((self.StartMeleeDamageCode or 0),function()
			if IsValid(self) then
				if math.random(1,100) <= self.Stats.LUC && math.random(1,2) == 1 then self:DoCritical(2) end
				local t = self.FirstMeleeDamageTime or 0.8
				timer.Simple(t,function()
					if IsValid(self) then
						self:MeleeAttackCode(DMG_P_LIGHT,1500,150)
					end
				end)
				for i = 1,2 do
					if math.random(1,4) == 1 then
						timer.Simple(t +(0.25 /i),function()
							if IsValid(self) then
								self:MeleeAttackCode(DMG_P_LIGHT,1500,150)
							end
						end)
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
function ENT:RainingSeeds(ply,persona)
	local skill = "Raining Seeds"
	if self.User:Health() > self.User:GetMaxHealth() *self:GetMeleeCost() && self:GetTask() == "TASK_IDLE" then
		self:SetTask("TASK_ATTACK")
		local tA = self:PlaySet(skill,"melee",1)
		self:FindTarget(ply)
		self:SetAngles(self.User:GetAngles())
		self:TakeHP(self.User:GetMaxHealth() *self:GetMeleeCost())
		timer.Simple((self.StartMeleeDamageCode or 0),function()
			if IsValid(self) then
				if math.random(1,100) <= self.Stats.LUC && math.random(1,2) == 1 then self:DoCritical(2) end
				local t = self.FirstMeleeDamageTime or 0.8
				timer.Simple(t,function()
					if IsValid(self) then
						self:MeleeAttackCode(DMG_P_HEAVY,1500,150)
					end
				end)
				for i = 1,2 do
					if math.random(1,3) == 1 then
						timer.Simple(t +(0.25 /i),function()
							if IsValid(self) then
								self:MeleeAttackCode(DMG_P_HEAVY,1500,150)
							end
						end)
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
function ENT:Agneyastra(ply,persona)
	local skill = "Agneyastra"
	if self.User:Health() > self.User:GetMaxHealth() *self:GetMeleeCost() && self:GetTask() == "TASK_IDLE" then
		self:SetTask("TASK_ATTACK")
		local tA = self:PlaySet(skill,"melee",1)
		self:FindTarget(ply)
		self:SetAngles(self.User:GetAngles())
		self:TakeHP(self.User:GetMaxHealth() *self:GetMeleeCost())
		timer.Simple((self.StartMeleeDamageCode or 0),function()
			if IsValid(self) then
				if math.random(1,100) <= self.Stats.LUC && math.random(1,2) == 1 then self:DoCritical(2) end
				local t = self.FirstMeleeDamageTime or 0.8
				timer.Simple(t,function()
					if IsValid(self) then
						self:MeleeAttackCode(DMG_P_HEAVY,1500,150)
					end
				end)
				for i = 1,2 do
					if math.random(1,4) == 1 then
						timer.Simple(t +(0.25 /i),function()
							if IsValid(self) then
								self:MeleeAttackCode(DMG_P_HEAVY,1500,150)
							end
						end)
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
function ENT:TerrorClaw(ply,persona)
	local skill = "Terror Claw"
	if self.User:Health() > self.User:GetMaxHealth() *self:GetMeleeCost() && self:GetTask() == "TASK_IDLE" then
		self:SetTask("TASK_ATTACK")
		local tA = self:PlaySet(skill,"melee",1)
		self:FindTarget(ply)
		self:SetAngles(self.User:GetAngles())
		self:TakeHP(self.User:GetMaxHealth() *self:GetMeleeCost())
		timer.Simple((self.StartMeleeDamageCode or 0),function()
			if IsValid(self) then
				if math.random(1,100) <= self.Stats.LUC && math.random(1,2) == 1 then self:DoCritical(2) end
				timer.Simple((self.FirstMeleeDamageTime or 0.75),function()
					if IsValid(self) then
						self:MeleeAttackCode(DMG_P_MEDIUM,1500,120,nil,math.random(1,2) == 1 && "Fear" or nil,10)
					end
				end)
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
		timer.Simple((self.StartMeleeDamageCode or 0),function()
			if IsValid(self) then
				if math.random(1,100) <= self.Stats.LUC && math.random(1,2) == 1 then self:DoCritical(2) end
				timer.Simple((self.FirstMeleeDamageTime or 1.65),function()
					if IsValid(self) then
						self:MeleeAttackCode(DMG_P_COLOSSAL,1500,120)
					end
				end)
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
		timer.Simple((self.StartMeleeDamageCode or 0),function()
			if IsValid(self) then
				if math.random(1,100) <= self.Stats.LUC && math.random(1,2) == 1 then self:DoCritical(2) end
				timer.Simple((self.FirstMeleeDamageTime or 1.7),function()
					if IsValid(self) then
						self:MeleeAttackCode(DMG_P_COLOSSAL,1500,100)
					end
				end)
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
		timer.Simple((self.StartMeleeDamageCode or 0),function()
			if IsValid(self) then
				if math.random(1,100) <= self.Stats.LUC && math.random(1,2) == 1 then self:DoCritical(2) end
				timer.Simple((self.FirstMeleeDamageTime or 0.8),function()
					if IsValid(self) then
						self:MeleeAttackCode(DMG_P_MEDIUM,1500,150)
					end
				end)
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
		timer.Simple((self.StartMeleeDamageCode or 0),function()
			if IsValid(self) then
				if math.random(1,100) <= self.Stats.LUC *2.5 then self:DoCritical(2) end
				timer.Simple((self.FirstMeleeDamageTime or 1),function()
					if IsValid(self) then
						self:MeleeAttackCode(DMG_P_MEDIUM,1500,125)
					end
				end)
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
		timer.Simple((self.StartMeleeDamageCode or 0),function()
			if IsValid(self) then
				if math.random(1,100) <= self.Stats.LUC && math.random(1,2) == 1 then self:DoCritical(2) end
				timer.Simple((self.FirstMeleeDamageTime or 1.3),function()
					if IsValid(self) then
						self:MeleeAttackCode(DMG_P_COLOSSAL,1500,90)
						if self.User:IsPlayer() then
							self.User:ChatPrint("Your ATK has been greatly reduced for 5 minutes!")
						end
					end
				end)
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
		timer.Simple((self.StartMeleeDamageCode or 0),function()
			if IsValid(self) then
				if math.random(1,100) <= self.Stats.LUC && math.random(1,2) == 1 then self:DoCritical(2) end
				timer.Simple((self.FirstMeleeDamageTime or 0.8),function()
					if IsValid(self) then
						self:MeleeAttackCode(DMG_P_COLOSSAL,1500,90,DMG_P_ALMIGHTY)
					end
				end)
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
		timer.Simple((self.StartMeleeDamageCode or 0),function()
			if IsValid(self) then
				local t = (self.FirstMeleeDamageTime or 0.8)
				if math.random(1,100) <= self.Stats.LUC && math.random(1,2) == 1 then self:DoCritical(2) end
				timer.Simple(t,function()
					if IsValid(self) then
						self:MeleeAttackCode(DMG_P_HEAVY,1200,90)
					end
				end)
				timer.Simple(t +0.2,function()
					if IsValid(self) then
						self:MeleeAttackCode(DMG_P_HEAVY,1200,90)
					end
				end)
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
		timer.Simple((self.StartMeleeDamageCode or 0),function()
			if IsValid(self) then
				local t = (self.FirstMeleeDamageTime or 0.8)
				if math.random(1,100) <= self.Stats.LUC && math.random(1,2) == 1 then self:DoCritical(2) end
				timer.Simple(t,function()
					if IsValid(self) then
						self:MeleeAttackCode(DMG_P_SEVERE,1500,130)
					end
				end)
				timer.Simple(t *2,function()
					if IsValid(self) then
						self:MeleeAttackCode(DMG_P_SEVERE,1500,130)
					end
				end)
				timer.Simple(t *2 +0.1,function()
					if IsValid(self) then
						self:MeleeAttackCode(DMG_P_SEVERE,1500,130)
					end
				end)
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
		timer.Simple((self.StartMeleeDamageCode or 0),function()
			if IsValid(self) then
				local t = (self.FirstMeleeDamageTime or 0.8)
				if math.random(1,100) <= self.Stats.LUC && math.random(1,2) == 1 then self:DoCritical(2) end
				timer.Simple(t,function()
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
				timer.Simple(t *2,function()
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
				timer.Simple(t *2 +0.1,function()
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
				
				sound.Play("cpthazama/vo/adachi/blast_charge.wav",self:GetPos(),75)

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
				
				sound.Play("cpthazama/vo/adachi/blast_charge.wav",self:GetPos(),75)
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
							if IsValid(v) && IsValid(self) then
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
						if IsValid(v) && IsValid(self) then
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
								if IsValid(v) && IsValid(self) then
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
							if IsValid(v) && IsValid(self) then
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
									if IsValid(v) && IsValid(self) then
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
function ENT:Zio(ply,persona)
	if !IsValid(ply.Persona_EyeTarget) then return end

	local skill = "Zio"
	if self.User:GetSP() >= self.CurrentCardCost && self:GetTask() == "TASK_IDLE" then
		self:TakeSP(self.CurrentCardCost)
		self:SetTask("TASK_PLAY_ANIMATION")
		local t = self:PlaySet(skill,"range_start",1.5)
		timer.Simple(t,function()
			if IsValid(self) then
				t = self:PlaySet(skill,"range_start_idle",1,1)
				timer.Simple(t,function()
					if IsValid(self) then
						t = self:PlaySet(skill,"range",1)
						if math.random(1,100) <= self.Stats.LUC && math.random(1,2) == 1 then self:DoCritical(2) end
						timer.Simple(t,function()
							if IsValid(self) then
								t = self:PlaySet(skill,"range_idle",1,1)
								local v = ply.Persona_EyeTarget
								if IsValid(v) && IsValid(self) then
									self:ZioEffect(v,DMG_P_LIGHT)
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
		end)
	end
end
---------------------------------------------------------------------------------------------------------------------------------------------
function ENT:Zionga(ply,persona)
	if !IsValid(ply.Persona_EyeTarget) then return end

	local skill = "Zionga"
	if self.User:GetSP() >= self.CurrentCardCost && self:GetTask() == "TASK_IDLE" then
		self:TakeSP(self.CurrentCardCost)
		self:SetTask("TASK_PLAY_ANIMATION")
		local t = self:PlaySet(skill,"range_start",1.5)
		timer.Simple(t,function()
			if IsValid(self) then
				t = self:PlaySet(skill,"range_start_idle",1,1)
				timer.Simple(t,function()
					if IsValid(self) then
						t = self:PlaySet(skill,"range",1)
						if math.random(1,100) <= self.Stats.LUC && math.random(1,2) == 1 then self:DoCritical(2) end
						timer.Simple(t,function()
							if IsValid(self) then
								t = self:PlaySet(skill,"range_idle",1,1)
								local v = ply.Persona_EyeTarget
								if IsValid(v) && IsValid(self) then
									self:ZioEffect(v,DMG_P_MEDIUM)
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
		end)
	end
end
---------------------------------------------------------------------------------------------------------------------------------------------
function ENT:Ziodyne(ply,persona)
	if !IsValid(ply.Persona_EyeTarget) then return end

	local skill = "Ziodyne"
	if self.User:GetSP() >= self.CurrentCardCost && self:GetTask() == "TASK_IDLE" then
		self:TakeSP(self.CurrentCardCost)
		self:SetTask("TASK_PLAY_ANIMATION")
		local t = self:PlaySet(skill,"range_start",1.5)
		timer.Simple(t,function()
			if IsValid(self) then
				t = self:PlaySet(skill,"range_start_idle",1,1)
				timer.Simple(t,function()
					if IsValid(self) then
						t = self:PlaySet(skill,"range",1)
						if math.random(1,100) <= self.Stats.LUC && math.random(1,2) == 1 then self:DoCritical(2) end
						timer.Simple(t,function()
							if IsValid(self) then
								t = self:PlaySet(skill,"range_idle",1,1)
								local v = ply.Persona_EyeTarget
								if IsValid(v) && IsValid(self) then
									self:ZioEffect(v,DMG_P_HEAVY)
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
		end)
	end
end
---------------------------------------------------------------------------------------------------------------------------------------------
function ENT:ThunderReign(ply,persona)
	if !IsValid(ply.Persona_EyeTarget) then return end

	local skill = "Thunder Reign"
	if self.User:GetSP() >= self.CurrentCardCost && self:GetTask() == "TASK_IDLE" then
		self:TakeSP(self.CurrentCardCost)
		self:SetTask("TASK_PLAY_ANIMATION")
		local t = self:PlaySet(skill,"range_start",1.5)
		timer.Simple(t,function()
			if IsValid(self) then
				t = self:PlaySet(skill,"range_start_idle",1,1)
				timer.Simple(t,function()
					if IsValid(self) then
						t = self:PlaySet(skill,"range",1)
						if math.random(1,100) <= self.Stats.LUC && math.random(1,2) == 1 then self:DoCritical(2) end
						timer.Simple(t,function()
							if IsValid(self) then
								t = self:PlaySet(skill,"range_idle",1,1)
								local v = ply.Persona_EyeTarget
								if IsValid(v) && IsValid(self) then
									self:ZioEffect(v,DMG_P_SEVERE)
								end
								timer.Simple(t *2,function()
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
function ENT:Mazio(ply,persona)
	local skill = "Mazio"
	if self.User:GetSP() >= self.CurrentCardCost && self:GetTask() == "TASK_IDLE" then
		self:TakeSP(self.CurrentCardCost)
		self:SetTask("TASK_PLAY_ANIMATION")
		local t = self:PlaySet(skill,"range_start",1.5)
		timer.Simple(t,function()
			if IsValid(self) then
				t = self:PlaySet(skill,"range_start_idle",1,1)
				timer.Simple(t,function()
					if IsValid(self) then
						t = self:PlaySet(skill,"range",1)
						if math.random(1,100) <= self.Stats.LUC && math.random(1,2) == 1 then self:DoCritical(2) end
						timer.Simple(t,function()
							if IsValid(self) then
								t = self:PlaySet(skill,"range_idle",1,1)
								for _,v in pairs(self:FindEnemies(self:GetPos(),1500)) do
									if IsValid(v) && IsValid(self) then
										self:ZioEffect(v,DMG_P_LIGHT)
									end
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
		timer.Simple(t,function()
			if IsValid(self) then
				t = self:PlaySet(skill,"range_start_idle",1,1)
				timer.Simple(t,function()
					if IsValid(self) then
						t = self:PlaySet(skill,"range",1)
						if math.random(1,100) <= self.Stats.LUC && math.random(1,2) == 1 then self:DoCritical(2) end
						timer.Simple(t,function()
							if IsValid(self) then
								t = self:PlaySet(skill,"range_idle",1,1)
								for _,v in pairs(self:FindEnemies(self:GetPos(),1500)) do
									if IsValid(v) && IsValid(self) then
										self:ZioEffect(v,DMG_P_MEDIUM)
									end
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
		timer.Simple(t,function()
			if IsValid(self) then
				t = self:PlaySet(skill,"range_start_idle",1,1)
				timer.Simple(t,function()
					if IsValid(self) then
						t = self:PlaySet(skill,"range",1)
						if math.random(1,100) <= self.Stats.LUC && math.random(1,2) == 1 then self:DoCritical(2) end
						timer.Simple(t,function()
							if IsValid(self) then
								t = self:PlaySet(skill,"range_idle",1,1)
								for _,v in pairs(self:FindEnemies(self:GetPos(),1500)) do
									if IsValid(v) && IsValid(self) then
										self:ZioEffect(v,DMG_P_HEAVY)
									end
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
		end)
	end
end
---------------------------------------------------------------------------------------------------------------------------------------------
function ENT:WildThunder(ply,persona)
	local skill = "Wild Thunder"
	if self.User:GetSP() >= self.CurrentCardCost && self:GetTask() == "TASK_IDLE" then
		self:TakeSP(self.CurrentCardCost)
		self:SetTask("TASK_PLAY_ANIMATION")
		local t = self:PlaySet(skill,"range_start",1)
		timer.Simple(t,function()
			if IsValid(self) then
				t = self:PlaySet(skill,"range_start_idle",1,1)
				timer.Simple(t,function()
					if IsValid(self) then
						t = self:PlaySet(skill,"range",1)
						if math.random(1,100) <= self.Stats.LUC && math.random(1,2) == 1 then self:DoCritical(2) end
						timer.Simple(t,function()
							if IsValid(self) then
								t = self:PlaySet(skill,"range_idle",1,1)
								for _,v in pairs(self:FindEnemies(self:GetPos(),2000)) do
									if IsValid(v) && IsValid(self) then
										self:ZioEffect(v,DMG_P_SEVERE)
									end
								end
								timer.Simple(t *2,function()
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
function ENT:ColossalStorm(ply,persona)
	local skill = "Colossal Storm"
	if self.User:GetSP() >= self.CurrentCardCost && self:GetTask() == "TASK_IDLE" then
		self:TakeSP(self.CurrentCardCost)
		self:SetTask("TASK_PLAY_ANIMATION")
		local t = self:PlaySet(skill,"range_start",1)
		timer.Simple(t,function()
			if IsValid(self) then
				t = self:PlaySet(skill,"range_start_idle",1,1)
				timer.Simple(t,function()
					if IsValid(self) then
						t = self:PlaySet(skill,"range",1)
						if math.random(1,100) <= self.Stats.LUC && math.random(1,2) == 1 then self:DoCritical(2) end
						timer.Simple(t,function()
							if IsValid(self) then
								t = self:PlaySet(skill,"range_idle",1,1)
								for _,v in pairs(self:FindEnemies(self:GetPos(),2200)) do
									if IsValid(v) && IsValid(self) then
										self:ZioEffect(v,DMG_P_COLOSSAL)
									end
								end
								timer.Simple(t *2.5,function()
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
-- function ENT:EvilSmile(ply,persona,rmb)
	-- if !IsValid(ply.Persona_EyeTarget) then
		-- return
	-- end
	-- local skill = "Evil Smile"
	-- if self.User:GetSP() >= self.CurrentCardCost && self:GetTask() == "TASK_IDLE" then
		-- self:SetTask("TASK_PLAY_ANIMATION")
		-- self:TakeSP(self.CurrentCardCost)
		-- t = self:PlaySet(skill,self.Animations["special"] && "special" or "range",1)
		-- timer.Simple(0.6,function()
			-- if IsValid(self) then
				-- if !IsValid(ply.Persona_EyeTarget) then
					-- return
				-- end
				-- self:Fear(ply.Persona_EyeTarget,15)
				-- if ply:IsPlayer() then
					-- ply:ChatPrint("Target is now inflicted with fear!")
				-- end
			-- end
		-- end)
		-- timer.Simple(t,function()
			-- if IsValid(self) then
				-- self:DoIdle()
			-- end
		-- end)
	-- end
-- end
---------------------------------------------------------------------------------------------------------------------------------------------
function ENT:SummonTentacle(ply,persona,type,name)
	local skill = name
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
						if type == 1 && !IsValid(self.P_Tentacle01) then
							self.P_Tentacle01 = ents.Create("prop_vj_animatable")
							self.P_Tentacle01:SetModel("models/cpthazama/persona5/persona/azathoth_hand.mdl")
							self.P_Tentacle01:SetPos(self:GetPos() +self:GetForward() *150)
							self.P_Tentacle01:SetAngles(self:GetAngles())
							self.P_Tentacle01:Spawn()
							self.P_Tentacle01:DrawShadow(false)
							self.P_Tentacle01:SetCollisionGroup(COLLISION_GROUP_IN_VEHICLE)
							self.P_Tentacle01:SetParent(self)
							self:DeleteOnRemove(self.P_Tentacle01)
							
							self:DoChat("Summoned " .. name .. " for 3 minutes!")
							
							function self.P_Tentacle01:Think()
								self:NextThink(CurTime())
								local persona = self:GetParent()
								self.NextSkillT = self.NextSkillT or CurTime() +10
								self.DespawnT = self.DespawnT or CurTime() +180
								if CurTime() > self.DespawnT then
									for i = 1,self:GetBoneCount() -1 do
										ParticleEffect("vj_impact1_blue",self:GetBonePosition(i),Angle(math.Rand(0,360),math.Rand(0,360),math.Rand(0,360)),nil)
									end
									self:Remove()
								end
								if IsValid(persona) then
									local ply = persona.User

									if CurTime() > self.NextSkillT && math.random(1,15) == 1 then
										ply.Persona_RakukajaT = CurTime() +60
										persona:DoChat("[Tentacle of Protection] Increased DEF for 60 seconds!")
										ply:EmitSound("cpthazama/persona5/skills/0302.wav",85)

										local spawnparticle = ents.Create("info_particle_system")
										spawnparticle:SetKeyValue("effect_name","vj_per_skill_def")
										spawnparticle:SetPos(ply:GetPos())
										spawnparticle:Spawn()
										spawnparticle:Activate()
										spawnparticle:Fire("Start","",0)
										spawnparticle:Fire("Kill","",0.1)
										
										self:PlayAnimation("flinch",1,0,true)

										self.NextSkillT = CurTime() +60
									end
								end
								return true
							end
							
							function self.P_Tentacle01:PlayAnimation(anim,rate,cycle,restart)
								self:ResetSequence(anim)
								self:SetPlaybackRate(rate or 1)
								self:SetCycle(cycle or 0)
								
								local t = VJ_GetSequenceDuration(self,anim)
								if restart then
									timer.Simple(t,function()
										if IsValid(self) then
											self:PlayAnimation("idle",1,1)
										end
									end)
								end
								return t
							end
							
							local tentacle = self.P_Tentacle01
							tentacle:PlayAnimation("summon",1,0,true)
						elseif type == 2 && !IsValid(self.P_Tentacle02) then
							self.P_Tentacle02 = ents.Create("prop_vj_animatable")
							self.P_Tentacle02:SetModel("models/cpthazama/persona5/persona/azathoth_hand.mdl")
							self.P_Tentacle02:SetPos(self:GetPos() +self:GetForward() *55 +self:GetRight() *100)
							self.P_Tentacle02:SetAngles(self:GetAngles())
							self.P_Tentacle02:Spawn()
							self.P_Tentacle02:DrawShadow(false)
							self.P_Tentacle02:SetCollisionGroup(COLLISION_GROUP_IN_VEHICLE)
							self.P_Tentacle02:SetParent(self)
							self:DeleteOnRemove(self.P_Tentacle02)
							
							self:DoChat("Summoned " .. name .. " for 3 minutes!")
							
							function self.P_Tentacle02:Think()
								self:NextThink(CurTime())
								local persona = self:GetParent()
								self.NextSkillT = self.NextSkillT or CurTime() +10
								self.DespawnT = self.DespawnT or CurTime() +180
								if CurTime() > self.DespawnT then
									for i = 1,self:GetBoneCount() -1 do
										ParticleEffect("vj_impact1_blue",self:GetBonePosition(i),Angle(math.Rand(0,360),math.Rand(0,360),math.Rand(0,360)),nil)
									end
									self:Remove()
								end
								if IsValid(persona) then
									local ply = persona.User

									if CurTime() > self.NextSkillT && math.random(1,15) == 1 then
										ply:SetHealth(math.Clamp(ply:Health() +(ply:GetMaxHealth() *0.35),1,ply:GetMaxHealth()))
										persona:DoChat("[Tentacle of Healing] Restored 35% of your HP!")
										ply:EmitSound("cpthazama/persona5/skills/0302.wav",85)
										ply:RemoveAllDecals()

										local spawnparticle = ents.Create("info_particle_system")
										spawnparticle:SetKeyValue("effect_name","vj_per_skill_heal")
										spawnparticle:SetPos(ply:GetPos())
										spawnparticle:Spawn()
										spawnparticle:Activate()
										spawnparticle:Fire("Start","",0)
										spawnparticle:Fire("Kill","",0.1)
										
										self:PlayAnimation("flinch",1,0,true)

										self.NextSkillT = CurTime() +30
									end
								end
								return true
							end
							
							function self.P_Tentacle02:PlayAnimation(anim,rate,cycle,restart)
								self:ResetSequence(anim)
								self:SetPlaybackRate(rate or 1)
								self:SetCycle(cycle or 0)
								
								local t = VJ_GetSequenceDuration(self,anim)
								if restart then
									timer.Simple(t,function()
										if IsValid(self) then
											self:PlayAnimation("idle",1,1)
										end
									end)
								end
								return t
							end
							
							local tentacle = self.P_Tentacle02
							tentacle:PlayAnimation("summon",1,0,true)
						elseif type == 3 && !IsValid(self.P_Tentacle03) then
							self.P_Tentacle03 = ents.Create("prop_vj_animatable")
							self.P_Tentacle03:SetModel("models/cpthazama/persona5/persona/azathoth_hand.mdl")
							self.P_Tentacle03:SetPos(self:GetPos() +self:GetForward() *55 +self:GetRight() *-100)
							self.P_Tentacle03:SetAngles(self:GetAngles())
							self.P_Tentacle03:Spawn()
							self.P_Tentacle03:DrawShadow(false)
							self.P_Tentacle03:SetCollisionGroup(COLLISION_GROUP_IN_VEHICLE)
							self.P_Tentacle03:SetParent(self)
							self:DeleteOnRemove(self.P_Tentacle03)
							
							self:DoChat("Summoned " .. name .. " for 3 minutes!")
							
							function self.P_Tentacle03:Think()
								self:NextThink(CurTime())
								local persona = self:GetParent()
								self.NextSkillT = self.NextSkillT or CurTime() +10
								self.DespawnT = self.DespawnT or CurTime() +180
								if CurTime() > self.DespawnT then
									for i = 1,self:GetBoneCount() -1 do
										ParticleEffect("vj_impact1_blue",self:GetBonePosition(i),Angle(math.Rand(0,360),math.Rand(0,360),math.Rand(0,360)),nil)
									end
									self:Remove()
								end
								if IsValid(persona) then
									local ply = persona.User
									local ent = ply:IsNPC() && ply:GetEnemy() or ply:GetNW2Entity("Persona_Target")

									if IsValid(ent) then
										if CurTime() > self.NextSkillT && math.random(1,30) == 1 then
											ent.Persona_DebilitateT = CurTime() +60
											local spawnparticle = ents.Create("info_particle_system")
											spawnparticle:SetKeyValue("effect_name","vj_per_skill_debuff_all")
											spawnparticle:SetPos(ent:GetPos() +ent:OBBCenter())
											spawnparticle:Spawn()
											spawnparticle:Activate()
											spawnparticle:Fire("Start","",0)
											spawnparticle:Fire("Kill","",0.1)
											ent:EmitSound("cpthazama/persona5/skills/0361.wav",90)
											
											persona:DoChat("[Tentacle of Assistance] Decreased target's ATK/DEF/AGI for 1 minute!")
											
											self:PlayAnimation("attack",1,0,true)

											self.NextSkillT = CurTime() +25
										end
									end
								end
								return true
							end
							
							function self.P_Tentacle03:PlayAnimation(anim,rate,cycle,restart)
								self:ResetSequence(anim)
								self:SetPlaybackRate(rate or 1)
								self:SetCycle(cycle or 0)
								
								local t = VJ_GetSequenceDuration(self,anim)
								if restart then
									timer.Simple(t,function()
										if IsValid(self) then
											self:PlayAnimation("idle",1,1)
										end
									end)
								end
								return t
							end
							
							local tentacle = self.P_Tentacle03
							tentacle:PlayAnimation("summon",1,0,true)
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
function ENT:EvilSmile(ply,persona)
	if !IsValid(ply.Persona_EyeTarget) then
		return
	end
	local skill = "Evil Smile"
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
							if math.random(1,2) == 1 then
								self:Fear(ent,15)
								if ply:IsPlayer() then
									ply:ChatPrint("Target is now inflicted with fear!")
								end
							else
								if ply:IsPlayer() then
									ply:ChatPrint("Missed the target!")
								end
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
function ENT:DivineJudgement(ply,persona)
	local skill = "Divine Judgement"
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
										if !ent.VJ_IsHugeMonster && !ent.VJ_Persona_Boss && !(ent:IsPlayer() && ent:IsSuperAdmin()) then
											ent:SetHealth(ent:Health() /2)
										else
											self.User:ChatPrint("Attack inneffective against this boss!")
										end
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
function ENT:EternalRadiance(ply,persona)
	local skill = "Eternal Radiance"
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
							if IsValid(v) && IsValid(self) then
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
							if IsValid(v) && IsValid(self) then
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
							if IsValid(v) && IsValid(self) then
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
							if IsValid(v) && IsValid(self) then
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
function ENT:Psi(ply,persona)
	if !IsValid(ply.Persona_EyeTarget) then
		return
	end
	local skill = "Psi"
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
						local v = ply.Persona_EyeTarget
						if IsValid(v) && IsValid(self) then
							self:PsiEffect(v,DMG_P_LIGHT,4)
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
function ENT:Psio(ply,persona)
	if !IsValid(ply.Persona_EyeTarget) then
		return
	end
	local skill = "Psio"
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
						local v = ply.Persona_EyeTarget
						if IsValid(v) && IsValid(self) then
							self:PsiEffect(v,DMG_P_MEDIUM,4,nil,nil,"cpthazama/persona5/skills/0194.wav")
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
function ENT:Psiodyne(ply,persona)
	if !IsValid(ply.Persona_EyeTarget) then
		return
	end
	local skill = "Psiodyne"
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
						local v = ply.Persona_EyeTarget
						if IsValid(v) && IsValid(self) then
							self:PsiEffect(v,DMG_P_HEAVY,4,1.55,7,"cpthazama/persona5/skills/0195.wav")
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
function ENT:PsychoForce(ply,persona)
	if !IsValid(ply.Persona_EyeTarget) then
		return
	end
	local skill = "Psycho Force"
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
						local v = ply.Persona_EyeTarget
						if IsValid(v) && IsValid(self) then
							self:PsiEffect(v,DMG_P_SEVERE,5,2,12,"cpthazama/persona5/skills/0197.wav")
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
function ENT:Mapsi(ply,persona)
	local skill = "Mapsi"
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
							if IsValid(v) && IsValid(self) then
								self:PsiEffect(v,DMG_P_LIGHT,4)
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
function ENT:Mapsio(ply,persona)
	local skill = "Mapsio"
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
							if IsValid(v) && IsValid(self) then
								self:PsiEffect(v,DMG_P_MEDIUM,4,nil,nil,"cpthazama/persona5/skills/0194.wav")
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
function ENT:Mapsiodyne(ply,persona)
	local skill = "Mapsiodyne"
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
							if IsValid(v) && IsValid(self) then
								self:PsiEffect(v,DMG_P_HEAVY,4,1.55,7,"cpthazama/persona5/skills/0195.wav")
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
function ENT:PsychoBlast(ply,persona)
	local skill = "Psycho Blast"
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
						for _,v in pairs(self:FindEnemies(self:GetPos(),2500)) do
							if IsValid(v) && IsValid(self) then
								self:PsiEffect(v,DMG_P_SEVERE,5,2,12,"cpthazama/persona5/skills/0198.wav")
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
							if IsValid(v) && IsValid(self) then
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
							if IsValid(v) && IsValid(self) then
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
							if IsValid(v) && IsValid(self) then
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
									if IsValid(v) && IsValid(self) then
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
									if IsValid(v) && IsValid(self) then
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
function ENT:Kouha(ply,persona)
	if !IsValid(ply.Persona_EyeTarget) then
		return
	end
	local skill = "Kouha"
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
							self:BlessAttack(ent,DMG_P_LIGHT)
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
function ENT:Kouga(ply,persona)
	if !IsValid(ply.Persona_EyeTarget) then
		return
	end
	local skill = "Kouga"
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
							self:BlessAttack(ent,DMG_P_MEDIUM)
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
							self:BlessAttack(ent,DMG_P_HEAVY,2,"vj_per_skill_bless")
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
function ENT:Makouha(ply,persona)
	local skill = "Makouha"
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
								self:BlessAttack(ent,DMG_P_LIGHT)
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
function ENT:Makouga(ply,persona)
	local skill = "Makouga"
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
								self:BlessAttack(ent,DMG_P_MEDIUM)
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
								self:BlessAttack(ent,DMG_P_HEAVY,2,"vj_per_skill_bless")
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
function ENT:Hama(ply,persona)
	if !IsValid(ply.Persona_EyeTarget) then
		return
	end
	local skill = "Hama"
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
							self:BlessEffect(ent,4)
						end
						timer.Simple(2.25,function()
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
function ENT:Hamaon(ply,persona)
	if !IsValid(ply.Persona_EyeTarget) then
		return
	end
	local skill = "Hamaon"
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
							self:BlessEffect(ent,3)
						end
						timer.Simple(2.25,function()
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
function ENT:Mahama(ply,persona)
	local skill = "Mahama"
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
							if IsValid(v) && IsValid(self) then
								self:BlessEffect(v,4)
							end
						end
						timer.Simple(2.25,function()
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
function ENT:Mahamaon(ply,persona)
	local skill = "Mahamaon"
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
							if IsValid(v) && IsValid(self) then
								self:BlessEffect(v,3)
							end
						end
						timer.Simple(2.25,function()
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
function ENT:Mudo(ply,persona)
	if !IsValid(ply.Persona_EyeTarget) then
		return
	end
	local skill = "Mudo"
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
							self:MudoEffect(ent,4)
						end
						timer.Simple(2.25,function()
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
function ENT:Mudoon(ply,persona)
	if !IsValid(ply.Persona_EyeTarget) then
		return
	end
	local skill = "Mudoon"
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
							self:MudoEffect(ent,3)
						end
						timer.Simple(2.25,function()
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
function ENT:Mamudo(ply,persona)
	local skill = "Mamudo"
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
							if IsValid(v) && IsValid(self) then
								self:MudoEffect(v,4)
							end
						end
						timer.Simple(2.25,function()
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
function ENT:Mamudoon(ply,persona)
	if !IsValid(ply.Persona_EyeTarget) then
		return
	end
	local skill = "Mamudoon"
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
							if IsValid(v) && IsValid(self) then
								self:MudoEffect(v,3)
							end
						end
						timer.Simple(2.25,function()
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
function ENT:DieForMe(ply,persona)
	if !IsValid(ply.Persona_EyeTarget) then
		return
	end
	local skill = "Die For Me!"
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
							if IsValid(v) && IsValid(self) then
								VJ_CreateSound(v,"cpthazama/persona5/skills/0171.wav",80)
								self:MudoEffect(v,2,"vj_per_skill_curse")
							end
						end
						timer.Simple(3,function()
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
function ENT:Eiha(ply,persona)
	if !IsValid(ply.Persona_EyeTarget) then
		return
	end
	local skill = "Eiha"
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
							spawnparticle:SetKeyValue("effect_name","vj_per_skill_curse_small")
							spawnparticle:SetPos(ent:GetPos() +ent:OBBCenter())
							spawnparticle:Spawn()
							spawnparticle:Activate()
							spawnparticle:Fire("Start","",0)
							spawnparticle:Fire("Kill","",0.1)

							self:DealDamage(ent,DMG_P_LIGHT,DMG_P_CURSE,2)

							ent:EmitSound("cpthazama/persona5/skills/0064.wav",90)
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
function ENT:Eiga(ply,persona)
	if !IsValid(ply.Persona_EyeTarget) then
		return
	end
	local skill = "Eiga"
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
							spawnparticle:SetKeyValue("effect_name","vj_per_skill_curse_small")
							spawnparticle:SetPos(ent:GetPos() +ent:OBBCenter())
							spawnparticle:Spawn()
							spawnparticle:Activate()
							spawnparticle:Fire("Start","",0)
							spawnparticle:Fire("Kill","",0.1)

							self:DealDamage(ent,DMG_P_MEDIUM,DMG_P_CURSE,2)

							ent:EmitSound("cpthazama/persona5/skills/0065.wav",90)
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
function ENT:Maeiha(ply,persona)
	local skill = "Maeiha"
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
							if IsValid(v) && IsValid(self) then
								local spawnparticle = ents.Create("info_particle_system")
								spawnparticle:SetKeyValue("effect_name","vj_per_skill_curse_small")
								spawnparticle:SetPos(v:GetPos() +v:OBBCenter())
								spawnparticle:Spawn()
								spawnparticle:Activate()
								spawnparticle:Fire("Start","",0)
								spawnparticle:Fire("Kill","",1)

								self:DealDamage(v,DMG_P_LIGHT,DMG_P_CURSE,2)

								v:EmitSound("cpthazama/persona5/skills/0064.wav",90)
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
function ENT:Maeiga(ply,persona)
	local skill = "Maeiga"
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
							if IsValid(v) && IsValid(self) then
								local spawnparticle = ents.Create("info_particle_system")
								spawnparticle:SetKeyValue("effect_name","vj_per_skill_curse")
								spawnparticle:SetPos(v:GetPos() +v:OBBCenter())
								spawnparticle:Spawn()
								spawnparticle:Activate()
								spawnparticle:Fire("Start","",0)
								spawnparticle:Fire("Kill","",1)

								self:DealDamage(v,DMG_P_MEDIUM,DMG_P_CURSE,2)

								v:EmitSound("cpthazama/persona5/skills/0065.wav",90)
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
							if IsValid(v) && IsValid(self) then
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
function ENT:VelvetMandala(ply,persona)
	local skill = "Velvet Mandala"
	if self.User:GetSP() >= self.CurrentCardCost && self:GetTask() == "TASK_IDLE" then
		self:SetTask("TASK_PLAY_ANIMATION")
		self:TakeSP(self.CurrentCardCost)
		local t = self:PlaySet(skill,"range_start",1)
		timer.Simple(t,function()
			if IsValid(self) then
				t = self:PlaySet(skill,"range",1)
				timer.Simple(t,function()
					if IsValid(self) then
						t = self:PlaySet(skill,"range_idle",1,1) *7
						for _,v in pairs(self:FindEnemies(self:GetPos(),1500)) do
							if IsValid(v) && IsValid(self) then
								local pos = {
									[1] = v:GetPos() +v:GetForward() *200 +v:GetRight() *200,
									[2] = v:GetPos() +v:GetForward() *200 +v:GetRight() *-200,
									[3] = v:GetPos() +v:GetForward() *-200
								}
								for i = 1,3 do
									local spawnparticle = ents.Create("info_particle_system")
									spawnparticle:SetKeyValue("effect_name","vj_per_skill_curse_mandala")
									spawnparticle:SetPos(pos[i])
									spawnparticle:Spawn()
									spawnparticle:Activate()
									spawnparticle:Fire("Start","",0)
									spawnparticle:Fire("SetParent",v:GetName())
									v:EmitSound("cpthazama/persona5/skills/0707.wav",110)
									timer.Simple(5,function()
										if IsValid(v) then
											util.ScreenShake(v:GetPos(),15,100,3.5,1750)
											if IsValid(self) then
												self:DealDamage(v,DMG_P_HEAVY,DMG_P_CURSE,2)
												if math.random(1,2) == 1 then
													local r = math.random(1,3)
													if r == 1 then
														self:Fear(v,15)
													elseif r == 2 then
														self:Curse(v,15,1)
													else
														self:Confuse(v,15)
													end
												end
											end
										end
									end)
									timer.Simple(7,function()
										if IsValid(spawnparticle) then
											spawnparticle:Fire("Kill","",0.1)
										end
									end)
								end
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
function ENT:MagatsuMandala(ply,persona)
	local skill = "Magatsu Mandala"
	if self.User:GetSP() >= self.CurrentCardCost && self:GetTask() == "TASK_IDLE" then
		self:SetTask("TASK_PLAY_ANIMATION")
		self:TakeSP(self.CurrentCardCost)
		local t = self:PlaySet(skill,"range_start",1)
		timer.Simple(t,function()
			if IsValid(self) then
				t = self:PlaySet(skill,"range",1)
				timer.Simple(t,function()
					if IsValid(self) then
						t = self:PlaySet(skill,"range_idle",1,1) *7
						for _,v in pairs(self:FindEnemies(self:GetPos(),1500)) do
							if IsValid(v) && IsValid(self) then
								local spawnparticle = ents.Create("info_particle_system")
								spawnparticle:SetKeyValue("effect_name","vj_per_skill_curse_mandala")
								spawnparticle:SetPos(v:GetPos())
								spawnparticle:Spawn()
								spawnparticle:Activate()
								spawnparticle:Fire("Start","",0)
								spawnparticle:Fire("SetParent",v:GetName())
								v:EmitSound("cpthazama/persona5/skills/0707.wav",110)
								timer.Simple(5,function()
									if IsValid(v) then
										util.ScreenShake(v:GetPos(),15,100,3.5,1750)
										if IsValid(self) then
											self:DealDamage(v,DMG_P_HEAVY,DMG_P_CURSE,2)
											if math.random(1,2) == 1 then
												local r = math.random(1,3)
												if r == 1 then
													self:Fear(v,15)
												elseif r == 2 then
													self:Curse(v,15,1)
												else
													self:Confuse(v,15)
												end
											end
										end
									end
								end)
								timer.Simple(7,function()
									if IsValid(spawnparticle) then
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
							if IsValid(v) && IsValid(self) then
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
		timer.Simple(t,function()
			if IsValid(self) then
				t = self:PlaySet(skill,"range",1)
				if math.random(1,100) <= self.Stats.LUC && math.random(1,2) == 1 then self:DoCritical(2) end
				timer.Simple(t,function()
					if IsValid(self) then
						t = self:PlaySet(skill,"range_idle",1)
						if IsValid(ply.Persona_EyeTarget) then
							self:NuclearEffect(ply.Persona_EyeTarget,DMG_P_MEDIUM)
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
function ENT:Freidyne(ply,persona)
	local skill = "Freidyne"
	local enemy = ply.Persona_EyeTarget
	if !IsValid(enemy) then
		return
	end
	if self.User:GetSP() >= self.CurrentCardCost && self:GetTask() == "TASK_IDLE" then
		self:SetTask("TASK_PLAY_ANIMATION")
		local t = self:PlaySet(skill,"range_start",1)
		self:TakeSP(self.CurrentCardCost)
		timer.Simple(t,function()
			if IsValid(self) then
				t = self:PlaySet(skill,"range",1)
				if math.random(1,100) <= self.Stats.LUC && math.random(1,2) == 1 then self:DoCritical(2) end
				timer.Simple(t,function()
					if IsValid(self) then
						t = self:PlaySet(skill,"range_idle",1)
						if IsValid(ply.Persona_EyeTarget) then
							self:NuclearEffect(ply.Persona_EyeTarget,DMG_P_HEAVY,1.75,6)
						end

						-- local proj = ents.Create("obj_vj_per_nuclearblast")
						-- proj:SetPos(enemy:GetPos() +enemy:OBBMaxs() +Vector(0,0,400))
						-- proj:SetAngles((enemy:GetPos() +enemy:OBBCenter() -proj:GetPos()):Angle())
						-- proj:Spawn()
						-- proj.RadiusDamage = self:AdditionalInput(DMG_P_MEDIUM,2)
						-- proj.RadiusDamageType = DMG_P_NUCLEAR
						-- proj:SetOwner(self.User)
						-- proj:SetPhysicsAttacker(self.User)
						-- proj:EmitSound("cpthazama/persona5/skills/0338.wav")

						-- if IsValid(proj:GetPhysicsObject()) then
							-- proj:GetPhysicsObject():SetVelocity((enemy:GetPos() +enemy:OBBCenter() -proj:GetPos()) *300)
						-- end
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
function ENT:NuclearCrush(ply,persona)
	local skill = "Nuclear Crush"
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
							if IsValid(v) && IsValid(self) then
								self:NuclearEffect(v,DMG_P_HEAVY,1.75,6)
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
							if !IsValid(v) then continue end
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
function ENT:Dia(ply,persona)
	local skill = "Dia"
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
							ally:SetHealth(math.Clamp(ally:Health() +(ally:GetMaxHealth() *0.1),1,ally:GetMaxHealth()))
							self:DoChat("Restored 10% of " .. (ally.Nick && ally:Nick() or ally:GetName()) .. "'s HP!")
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
							self.User:SetHealth(math.Clamp(self.User:Health() +(self.User:GetMaxHealth() *0.1),1,self.User:GetMaxHealth()))
							self:DoChat("Restored 10% of your HP!")
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
							if !IsValid(v) then continue end
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
									self:SetNW2Int("SpecialAttackCost",self.CurrentCardCost)
									self.HasChaosParticle = true
									self.User:StopParticles()
									self.User:EmitSound("cpthazama/persona5/skills/0675.wav",90)
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
function ENT:Tarukaja(ply,persona)
	local skill = "Tarukaja"
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
						
						self:DoChat(CurTime() > ply.Persona_TarukajaT && "Increased ATK for 1 minute!" or "Increased ATK time extended!")

						ply.Persona_TarukajaT = CurTime() +60

						local spawnparticle = ents.Create("info_particle_system")
						spawnparticle:SetKeyValue("effect_name","vj_per_skill_atk")
						spawnparticle:SetPos(ply:GetPos())
						spawnparticle:Spawn()
						spawnparticle:Activate()
						spawnparticle:Fire("Start","",0)
						spawnparticle:Fire("Kill","",0.1)
						self:EmitSound("cpthazama/persona5/skills/0335.wav",90)
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
function ENT:Rakukaja(ply,persona)
	local skill = "Rakukaja"
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
						
						self:DoChat(CurTime() > ply.Persona_RakukajaT && "Increased DEF for 1 minute!" or "Increased DEF time extended!")

						ply.Persona_RakukajaT = CurTime() +60

						local spawnparticle = ents.Create("info_particle_system")
						spawnparticle:SetKeyValue("effect_name","vj_per_skill_def")
						spawnparticle:SetPos(ply:GetPos())
						spawnparticle:Spawn()
						spawnparticle:Activate()
						spawnparticle:Fire("Start","",0)
						spawnparticle:Fire("Kill","",0.1)
						self:EmitSound("cpthazama/persona5/skills/0335.wav",90)
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
function ENT:Sukukaja(ply,persona)
	local skill = "Sukukaja"
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
						
						self:DoChat(CurTime() > ply.Persona_SukukajaT && "Increased AGI for 1 minute!" or "Increased AGI time extended!")

						ply.Persona_SukukajaT = CurTime() +60

						local spawnparticle = ents.Create("info_particle_system")
						spawnparticle:SetKeyValue("effect_name","vj_per_skill_evasion")
						spawnparticle:SetPos(ply:GetPos())
						spawnparticle:Spawn()
						spawnparticle:Activate()
						spawnparticle:Fire("Start","",0)
						spawnparticle:Fire("Kill","",0.1)
						self:EmitSound("cpthazama/persona5/skills/0335.wav",90)
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
function ENT:Tetrakarn(ply,persona)
	local skill = "Tetrakarn"
	if ply.Persona_Tetrakarn then return end
	if self.User:GetSP() >= self.CurrentCardCost && self:GetTask() == "TASK_IDLE" then
		self:SetTask("TASK_PLAY_ANIMATION")
		self:TakeSP(self.CurrentCardCost)
		local t = self:PlaySet(skill,"range_start",1)
		timer.Simple(t,function()
			if IsValid(self) then
				t = self:PlaySet(skill,"range",1)
				VJ_CreateSound(ply,"cpthazama/persona5/skills/0370.wav",80)
				timer.Simple(t,function()
					if IsValid(self) then
						t = self:PlaySet(skill,"range_idle",1,1)
						
						self:DoChat("[Tetrakarn] Physical shield created!")

						ply.Persona_Tetrakarn = true

						local spawnparticle = ents.Create("info_particle_system")
						spawnparticle:SetKeyValue("effect_name","vj_per_skill_debuff_def")
						spawnparticle:SetPos(ply:GetPos())
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
function ENT:Makarakarn(ply,persona)
	local skill = "Makarakarn"
	if ply.Persona_Makarakarn then return end
	if self.User:GetSP() >= self.CurrentCardCost && self:GetTask() == "TASK_IDLE" then
		self:SetTask("TASK_PLAY_ANIMATION")
		self:TakeSP(self.CurrentCardCost)
		local t = self:PlaySet(skill,"range_start",1)
		timer.Simple(t,function()
			if IsValid(self) then
				t = self:PlaySet(skill,"range",1)
				VJ_CreateSound(ply,"cpthazama/persona5/skills/0370.wav",80)
				timer.Simple(t,function()
					if IsValid(self) then
						t = self:PlaySet(skill,"range_idle",1,1)
						
						self:DoChat("[Makarakarn] Magical shield created!")

						ply.Persona_Makarakarn = true

						local spawnparticle = ents.Create("info_particle_system")
						spawnparticle:SetKeyValue("effect_name","vj_per_skill_debuff_def")
						spawnparticle:SetPos(ply:GetPos())
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
function ENT:Tarunda(ply,persona,rmb)
	if !IsValid(ply.Persona_EyeTarget) then
		return
	end
	local skill = "Tarunda"
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
							if ent.Persona_TarundaT then
								self:DoChat(CurTime() > ent.Persona_TarundaT && "Decreased target's ATK for 1 minute!" or "Decreased target's ATK time extended!")
							else
								ent.Persona_TarundaT = CurTime() +60
								self:DoChat("Decreased target's ATK for 1 minute!")
							end
							ent.Persona_TarukajaT = 0
							local spawnparticle = ents.Create("info_particle_system")
							spawnparticle:SetKeyValue("effect_name","vj_per_skill_debuff_atk")
							spawnparticle:SetPos(ent:GetPos() +ent:OBBCenter())
							spawnparticle:Spawn()
							spawnparticle:Activate()
							spawnparticle:Fire("Start","",0)
							spawnparticle:Fire("Kill","",0.1)

							ent:EmitSound("cpthazama/persona5/skills/0347.wav",90)
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
function ENT:Rakunda(ply,persona,rmb)
	if !IsValid(ply.Persona_EyeTarget) then
		return
	end
	local skill = "Rakunda"
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
							if ent.Persona_RakundaT then
								self:DoChat(CurTime() > ent.Persona_RakundaT && "Decreased target's DEF for 1 minute!" or "Decreased target's ATK time extended!")
							else
								ent.Persona_RakundaT = CurTime() +60
								self:DoChat("Decreased target's DEF for 1 minute!")
							end
							ent.Persona_RakukajaT = 0
							local spawnparticle = ents.Create("info_particle_system")
							spawnparticle:SetKeyValue("effect_name","vj_per_skill_debuff_def")
							spawnparticle:SetPos(ent:GetPos() +ent:OBBCenter())
							spawnparticle:Spawn()
							spawnparticle:Activate()
							spawnparticle:Fire("Start","",0)
							spawnparticle:Fire("Kill","",0.1)

							ent:EmitSound("cpthazama/persona5/skills/0347.wav",90)
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
function ENT:Sukunda(ply,persona,rmb)
	if !IsValid(ply.Persona_EyeTarget) then
		return
	end
	local skill = "Sukunda"
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
							if ent.Persona_SukundaT then
								self:DoChat(CurTime() > ent.Persona_SukundaT && "Decreased target's AGI for 1 minute!" or "Decreased target's ATK time extended!")
							else
								ent.Persona_SukundaT = CurTime() +60
								self:DoChat("Decreased target's AGI for 1 minute!")
							end
							ent.Persona_SukukajaT = 0
							local spawnparticle = ents.Create("info_particle_system")
							spawnparticle:SetKeyValue("effect_name","vj_per_skill_debuff_evasion")
							spawnparticle:SetPos(ent:GetPos() +ent:OBBCenter())
							spawnparticle:Spawn()
							spawnparticle:Activate()
							spawnparticle:Fire("Start","",0)
							spawnparticle:Fire("Kill","",0.1)

							ent:EmitSound("cpthazama/persona5/skills/0347.wav",90)
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
								ent.Persona_TarukajaT = 0
								ent.Persona_RakukajaT = 0
								ent.Persona_SukukajaT = 0
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

						self:DoChat(CurTime() > ply.Persona_HeatRiserT && "Increased Party ATK/DEF/AGI for 1 minute!" or "Increased ATK/DEF/AGI time extended!")

						ply.Persona_HeatRiserT = CurTime() +60
						for _,v in pairs(ply:GetFullParty(true)) do
							if !IsValid(v) then continue end
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
function ENT:DoorsOfHades(ply,ent)
	local skill = "Doors of Hades"
	if self.User:GetSP() >= self.CurrentCardCost && self:GetTask() == "TASK_IDLE" then
		self:TakeSP(self.CurrentCardCost)
		self:SetTask("TASK_PLAY_ANIMATION")
		local t = self:PlaySet(skill,"range_start",1)
		timer.Simple(t,function()
			if IsValid(self) then
				t = self:PlaySet(skill,"range_start_idle",1)
				timer.Simple(t,function()
					if IsValid(self) then
						t = self:PlaySet(skill,"range",1)
						timer.Simple(2,function()
							if IsValid(self) then
								if math.random(1,100) <= self.Stats.LUC && math.random(1,2) == 1 then self:DoCritical(2) end
							end
						end)
						for _,v in pairs(self:FindEnemies(self:GetPos(),1500)) do
							if IsValid(v) && IsValid(self) then
								local effectdata = EffectData()
								effectdata:SetStart((v:GetPos() +v:GetUp() *v:GetPos():Distance(v:GetPos() +v:OBBCenter()) *8))
								util.Effect("Persona_DoorsOfHades",effectdata)

								timer.Simple(3,function()
									if IsValid(v) && IsValid(self) then
										local effectdata = EffectData()
										effectdata:SetOrigin(v:NearestPoint(v:GetPos() +v:OBBCenter()))
										effectdata:SetScale(math.Clamp(DMG_P_HEAVY /3,20,300))
										util.Effect("Persona_Hit_Cut",effectdata)
										self:DealDamage(v,DMG_P_HEAVY,DMG_P_ALMIGHTY,2)
										self:InstaKillDamage(v,3)
									end
								end)
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
function ENT:Megidola(ply,ent)
	local skill = "Megidola"
	if self.User:GetSP() >= self.CurrentCardCost && self:GetTask() == "TASK_IDLE" then
		self:TakeSP(self.CurrentCardCost)
		self:SetTask("TASK_PLAY_ANIMATION")
		local t = self:PlaySet(skill,"range_start",1)
		timer.Simple(t,function()
			if IsValid(self) then
				t = self:PlaySet(skill,"range_start_idle",1)
				timer.Simple(t,function()
					if IsValid(self) then
						t = self:PlaySet(skill,"range",1)
						if math.random(1,100) <= self.Stats.LUC && math.random(1,2) == 1 then self:DoCritical(2) end
						self:EmitSound("cpthazama/persona5/skills/0070.wav",75)
						for _,v in pairs(self:FindEnemies(self:GetPos(),1500)) do
							if IsValid(v) && IsValid(self) then
								for i = 1,3  do
									timer.Simple(i *0.4,function()
										if IsValid(v) && IsValid(self) then
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
		timer.Simple(t,function()
			if IsValid(self) then
				t = self:PlaySet("Megidolaon","range_start_idle",1)
				self:EmitSound("cpthazama/persona5/skills/0070.wav",75)
				timer.Simple(t,function()
					if IsValid(self) then
						t = self:PlaySet("Megidolaon","range",1)
						if math.random(1,100) <= self.Stats.LUC && math.random(1,2) == 1 then self:DoCritical(2) end
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
function ENT:TyrantChaos(ply)
	local ent = ply.Persona_EyeTarget
	local skill = "Tyrant Chaos"
	if !IsValid(ent) then
		return
	end
	if self.User:GetSP() >= self.CurrentCardCost && self:GetTask() == "TASK_IDLE" then
		self:TakeSP(self.CurrentCardCost)
		self:SetTask("TASK_PLAY_ANIMATION")
		local t = self:PlaySet(skill,"range_start",1)
		timer.Simple(t,function()
			if IsValid(self) then
				t = self:PlaySet(skill,"range_start_idle",1)
				t = 5
				self:EmitSound("cpthazama/persona5/skills/0070.wav",110,85)
				timer.Simple(t,function()
					if IsValid(self) then
						t = self:PlaySet(skill,"range",1)
						timer.Simple(t,function()
							if IsValid(self) then
								self:PlaySet(skill,"range_idle",1,1)
								if math.random(1,100) <= self.Stats.LUC && math.random(1,2) == 1 then self:DoCritical(2) end
								t = 8
								local ent = ent or ply.Persona_EyeTarget
								if IsValid(ent) then
									self:MegidolaonEffect(ent,DMG_P_COLOSSAL,8,150)
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
		end)
	end
end
---------------------------------------------------------------------------------------------------------------------------------------------
function ENT:BlackViper(ply)
	local ent = ply.Persona_EyeTarget
	local skill = "Black Viper"
	if !IsValid(ent) then
		return
	end
	if self.User:GetSP() >= self.CurrentCardCost && self:GetTask() == "TASK_IDLE" then
		self:TakeSP(self.CurrentCardCost)
		self:SetTask("TASK_PLAY_ANIMATION")
		local t = self:PlaySet(skill,"range_start",1)
		timer.Simple(t,function()
			if IsValid(self) then
				t = self:PlaySet(skill,"range_start_idle",1)
				timer.Simple(t,function()
					if IsValid(self) then
						t = self:PlaySet(skill,"range",1)
						timer.Simple(t,function()
							if IsValid(self) then
								t = self:PlaySet(skill,"range_idle",1,1)
								local ent = ent or ply.Persona_EyeTarget
								if IsValid(ent) then
									self:BlackViperEffect(ent,DMG_P_SEVERE)
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

				self:DoChat(CurTime() > ply.Persona_HeatRiserT && "Increased ATK/DEF/AGI for 1 minute!" or "Increased ATK/DEF/AGI time extended!")

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
						if IsValid(v) && IsValid(self) then
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
						if IsValid(v) && IsValid(self) then
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
						if IsValid(v) && IsValid(self) then
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
						if IsValid(v) && IsValid(self) then
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
						if IsValid(v) && IsValid(self) then
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
					self:DoChat("Buffed Party AGI/AGI!")
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
						if IsValid(v) && IsValid(self) then
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
						if IsValid(v) && IsValid(self) then
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