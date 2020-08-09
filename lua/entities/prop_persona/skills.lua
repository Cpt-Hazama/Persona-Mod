---------------------------------------------------------------------------------------------------------------------------------------------
	-- Pre-Made Skills for compatibility on all Persona --
---------------------------------------------------------------------------------------------------------------------------------------------
---------------------------------------------------------------------------------------------------------------------------------------------
function ENT:GhostlyWail(ply) // Magatsu-Izanagi Skill
	if self.User:Health() > self.User:GetMaxHealth() *self:GetMeleeCost() && self:GetTask() == "TASK_IDLE" then
		self:SetTask("TASK_ATTACK")
		self:TakeHP(self.User:GetMaxHealth() *self:GetMeleeCost())
		local tA = self:PlaySet("Ghostly Wail","melee",1)
		self:FindTarget(ply)
		self:SetAngles(self.User:GetAngles())
		if math.random(1,100) <= self.Stats.LUC then self:DoCritical(1) end
		local t = {0.9,1.4,1.9}
		for _,v in pairs(t) do
			timer.Simple(v,function()
				if IsValid(self) then
					self:MeleeAttackCode(DMG_P_HEAVY,210,70)
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
function ENT:VorpalBlade(ply)
	if self.User:Health() > self.User:GetMaxHealth() *self:GetMeleeCost() && self:GetTask() == "TASK_IDLE" then
		self:SetTask("TASK_ATTACK")
		self:TakeHP(self.User:GetMaxHealth() *self:GetMeleeCost())
		local tA = self:PlaySet("Vorpal Blade","melee",1)
		self:FindTarget(ply)
		self:SetAngles(self.User:GetAngles())
		if math.random(1,100) <= self.Stats.LUC then self:DoCritical(1) end
		local t = {0.5,0.8,1.1,1.4,1.7,2}
		for _,i in pairs(t) do
			for _,v in pairs(self:FindEnemies(self:GetPos(),1500)) do
				if IsValid(v) then
					timer.Simple(i,function()
						if IsValid(v) && IsValid(self) then
							self:DealDamage(v,DMG_P_MEDIUM,bit.bor(DMG_P_PHYS,DMG_P_CURSE))
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
		if math.random(1,100) <= math.Clamp(self.Stats.LUC *2,1,99) then self:DoCritical(1) end
		for _,v in pairs(self:FindEnemies(self:GetPos(),1500)) do
			if IsValid(v) then
				v:EmitSound("cpthazama/persona5/skills/0461.wav",90)
				timer.Simple(SoundDuration("cpthazama/persona5/skills/0461.wav") -0.6,function()
					if IsValid(v) && IsValid(self) then
						v:EmitSound("cpthazama/persona5/skills/0725.wav",90)
						self:DealDamage(v,DMG_P_MEDIUM,DMG_P_GUN)
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
		if math.random(1,100) <= self.Stats.LUC then self:DoCritical(1) end
		for _,v in pairs(self:FindEnemies(self:GetPos(),1500)) do
			if IsValid(v) then
				v:EmitSound("cpthazama/persona5/skills/0227.wav",95)
				timer.Simple(2,function()
					if IsValid(v) && IsValid(self) then
						self:DealDamage(v,DMG_P_SEVERE,DMG_P_GUN)
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
function ENT:Cleave(ply,persona)
	local skill = "Cleave"
	if self.User:Health() > self.User:GetMaxHealth() *self:GetMeleeCost() && self:GetTask() == "TASK_IDLE" then
		self:SetTask("TASK_ATTACK")
		local tA = self:PlaySet(skill,"melee",1)
		self:FindTarget(ply)
		self:SetAngles(self.User:GetAngles())
		self:TakeHP(self.User:GetMaxHealth() *self:GetMeleeCost())
		if math.random(1,100) <= self.Stats.LUC then self:DoCritical(1) end
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
function ENT:CrossSlash(ply,persona) // Izanagi Skill
	local skill = "Cross Slash"
	if self.User:Health() > self.User:GetMaxHealth() *self:GetMeleeCost() && self:GetTask() == "TASK_IDLE" then
		self:SetTask("TASK_ATTACK")
		local tA = self:PlaySet(skill,"melee",1)
		self:FindTarget(ply)
		self:SetAngles(self.User:GetAngles())
		self:TakeHP(self.User:GetMaxHealth() *self:GetMeleeCost())
		if math.random(1,100) <= self.Stats.LUC then self:DoCritical(1) end
		timer.Simple(0.8,function()
			if IsValid(self) then
				self:MeleeAttackCode(DMG_P_HEAVY,600,150)
			end
		end)
		timer.Simple(1,function()
			if IsValid(self) then
				self:MeleeAttackCode(DMG_P_HEAVY,600,150)
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
		if math.random(1,100) <= self.Stats.LUC then self:DoCritical(1) end
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
function ENT:Teleport()
	local skill = "Teleport"
	if self.User:GetSP() >= self.CurrentCardCost && self:GetTask() == "TASK_IDLE" then
		self:TakeSP(self.CurrentCardCost)
		self:SetTask("TASK_PLAY_ANIMATION")
		local t = self:PlaySet(skill,"range_start",1)
		self:SetAngles(self.User:GetAngles())
		local tr = self:UserTrace(2000)
		local pos = tr.HitPos +tr.HitNormal *8
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
		if math.random(1,100) <= self.Stats.LUC then self:DoCritical(1) end
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
		if math.random(1,100) <= self.Stats.LUC then self:DoCritical(1) end
		timer.Simple(t,function()
			if IsValid(self) then
				t = self:PlaySet(skill,"range_start_idle",1,1)
				timer.Simple(0.15,function()
					if IsValid(self) then
						t = self:PlaySet(skill,"range",1)
						local v = ply.Persona_EyeTarget
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
		if math.random(1,100) <= self.Stats.LUC then self:DoCritical(1) end
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
		if math.random(1,100) <= self.Stats.LUC then self:DoCritical(1) end
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
		if math.random(1,100) <= self.Stats.LUC then self:DoCritical(1) end
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
		if math.random(1,100) <= self.Stats.LUC then self:DoCritical(1) end
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
				-- if ply.Persona_EyeTarget:Visible(self) then
					self:Fear(ply.Persona_EyeTarget,15)
					ply:ChatPrint("Target is now inflicted with fear!")
				-- end
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
		if math.random(1,100) <= self.Stats.LUC then self:DoCritical(1) end
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
function ENT:Charge(ply,persona)
	if self.User:GetSP() >= self.CurrentCardCost /*&& CurTime() > self.ChargedT*/ && self:GetTask() == "TASK_IDLE" then
		self:SetTask("TASK_PLAY_ANIMATION")
		self:TakeSP(self.CurrentCardCost)
		local t = self:PlaySet("Charge","range_start",1)
		timer.Simple(t,function()
			if IsValid(self) then
				t = self:PlaySet("Charge","range",1)
				timer.Simple(t,function()
					if IsValid(self) then
						t = self:PlaySet("Charge","range_idle",1,1)

						self:DoChat(CurTime() > self.ChargedT && "Double Physical damage for 1 minute!" or "Double Physical damage time extended!")

						self.ChargedT = CurTime() +60
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
	if self.User:GetSP() >= self.CurrentCardCost /*&& CurTime() > self.FocusedT*/ && self:GetTask() == "TASK_IDLE" then
		self:SetTask("TASK_PLAY_ANIMATION")
		self:TakeSP(self.CurrentCardCost)
		local t = self:PlaySet("Concentrate","range_start",1)
		timer.Simple(t,function()
			if IsValid(self) then
				t = self:PlaySet("Concentrate","range",1)
				timer.Simple(t,function()
					if IsValid(self) then
						t = self:PlaySet("Concentrate","range_idle",1,1)
						self:DoChat(CurTime() > self.FocusedT && "Double Magic damage for 1 minute!" or "Double Magic damage time extended!")

						self.FocusedT = CurTime() +60
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
						self:DoChat("Fully restored HP and cured all ailments!")
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

								self:DoChat(CurTime() > self.ChaosT && "All attacks increased, SP cost doubled, defense decreased for 1 minute!" or "All attacks increased, SP cost doubled, defense decreased time extended!")

								self.ChaosT = CurTime() +60

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
	if self.User:GetSP() >= self.CurrentCardCost /*&& CurTime() > self.HeatRiserT*/ && self:GetTask() == "TASK_IDLE" then
		self:SetTask("TASK_PLAY_ANIMATION")
		self:TakeSP(self.CurrentCardCost)
		local t = self:PlaySet("Heat Riser","range_start",1)
		timer.Simple(t,function()
			if IsValid(self) then
				t = self:PlaySet("Heat Riser","range",1)
				timer.Simple(t,function()
					if IsValid(self) then
						t = self:PlaySet("Heat Riser","range_idle",1,1)

						self:DoChat(CurTime() > self.HeatRiserT && "Increased ATK/DEF/Evasion for 1 minute!" or "Increased ATK/DEF/Evasion time extended!")

						self.HeatRiserT = CurTime() +60
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
		if math.random(1,100) <= self.Stats.LUC then self:DoCritical(1) end
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