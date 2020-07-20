AddCSLuaFile("shared.lua")
include("shared.lua")
---------------------------------------------------------------------------------------------------------------------------------------------
ENT.Bot_StopDistance = 100
ENT.Bot_Buttons = {
	[1] = {but={IN_ATTACK},dist=100,chance=1},
}
ENT.Model = "models/cpthazama/persona5/persona/magatsu_izanagi.mdl"
ENT.Name = "Magatsu-Izanagi"
ENT.Aura = "jojo_aura_red"
ENT.DamageTypes = bit.bor(DMG_SLASH,DMG_CRUSH,DMG_ALWAYSGIB,DMG_P_FEAR)
---------------------------------------------------------------------------------------------------------------------------------------------
function ENT:CustomOnHitEntity(hitEnts,dmginfo)
	-- if dmginfo:GetDamageType() == DMG_P_FEAR then
		for _,v in pairs(hitEnts) do
			if IsValid(v) && v:Health() > 0 then
				self:Fear(v,15)
			end
		end
	-- end
end
---------------------------------------------------------------------------------------------------------------------------------------------
function ENT:Maziodyne_NPC(ply,enemy)
	local rmb = true
	if rmb then
		if self.InstaKillStage > 0 then return end
		if self.User:GetSP() > self.CurrentCardCost && !self.IsArmed && self:GetTask() != "TASK_PLAY_ANIMATION" && self:GetTask() != "TASK_ATTACK" && CurTime() > self.RechargeT then
			self.DamageBuild = 250
			self:TakeSP(self.CurrentCardCost)
			self:SetTask("TASK_PLAY_ANIMATION")
			self:PlayAnimation("atk_magatsu_mandala_pre",1)
			VJ_CreateSound(ply,"cpthazama/persona5/adachi/vo/curse.wav")
			if math.random(1,2) == 1 then self:DoCritical(1) end
			timer.Simple(self:GetSequenceDuration(self,"atk_magatsu_mandala_pre"),function()
				if IsValid(self) then
					self.IsArmed = true
					self:PlayAnimation("atk_magatsu_mandala_pre_idle",1,1)
					timer.Simple(self:GetSequenceDuration(self,"atk_magatsu_mandala_pre_idle"),function()
						if IsValid(self) then
							if self:GetTask() == "TASK_PLAY_ANIMATION" && self.IsArmed && CurTime() > self.TimeToMazionga then
								self:PlayAnimation("atk_magatsu_mandala",1,1)
								self.TimeToMazionga = CurTime() +3.5
								self:EmitSound("beams/beamstart5.wav",90)
								local tbl = {
									"cpthazama/persona5/adachi/vo/blast.wav",
									"cpthazama/vox/adachi/kill/vbtl_pad_0#178 (pad300_0).wav",
									"cpthazama/vox/adachi/kill/vbtl_pad_0#122 (pad166_0).wav"
								}
								VJ_CreateSound(ply,VJ_PICK(tbl))
								for a = 1,5 do
									for i = 1,20 do
										timer.Simple(i *0.15,function()
											if IsValid(self) then
												self:MaziodyneAttack(a,30000)
											end
										end)
									end
								end
								timer.Simple(3,function()
									if IsValid(self) then
										self.RechargeT = CurTime() +5
										self.IsArmed = false
										self:DoIdle()
									end
								end)
							end
						end
					end)
				end
			end)
		end
	end
end
---------------------------------------------------------------------------------------------------------------------------------------------
function ENT:PersonaControls_NPC(ply,persona)

end
---------------------------------------------------------------------------------------------------------------------------------------------
function ENT:PersonaControls(ply,persona)
	if ply:IsNPC() then
		self:PersonaControls_NPC(ply,persona)
		return
	end
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
	-- self:SetSkin(CurTime() > self.RechargeT && 0 or 1)
	if lmb then
		if self.InstaKillStage > 0 then return end
		if self:GetTask() != "TASK_ATTACK" && !self.IsArmed then
			self:SetTask("TASK_ATTACK")
			self:PlayAnimation("ghostly_wail_noXY",1)
			if math.random(1,5) == 1 then self:DoCritical(1) end
			ply:EmitSound("cpthazama/persona5/adachi/vo/ghostly_wail_0" .. math.random(1,2) .. ".wav",85)
			self:FindTarget(ply)
			-- self:SetPos(self.User:GetPos() +self.User:GetForward() *60)
			self:SetAngles(self.User:GetAngles())
			local t = {0.9,1.4,1.9}
			for _,v in pairs(t) do
				timer.Simple(v,function()
					if IsValid(self) then
						self:MeleeAttackCode(self.HeatRiserT > CurTime() && self.Damage *1.5 or self.Damage,210,70)
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
		-- if self.InstaKillStage > 0 then return end
		if self:GetCard() == "Maziodyne" then
			self:Maziodyne(ply,persona,rmb)
		elseif self:GetCard() == "Evil Smile" then
			self:EvilSmile(ply,persona,rmb)
		elseif self:GetCard() == "Heat Riser" then
			if self.InstaKillStage > 0 then return end
			if self.User:GetSP() > self.CurrentCardCost && CurTime() > self.HeatRiserT && self:GetTask() != "TASK_PLAY_ANIMATION" then
				self:SetTask("TASK_PLAY_ANIMATION")
				self:TakeSP(self.CurrentCardCost)
				self:PlayAnimation("atk_magatsu_mandala_pre",1)
				timer.Simple(self:GetSequenceDuration(self,"atk_magatsu_mandala_pre"),function()
					if IsValid(self) then
						self:PlayAnimation("atk_magatsu_mandala",0.4,1)
						self.HeatRiserT = CurTime() +60
						self:EmitSound("cpthazama/persona5/skills/0361.wav",85)
						self.User:ChatPrint("Buffed melee attacks and evasion for 1 minute!")
						timer.Simple(self:GetSequenceDuration(self,"atk_magatsu_mandala") +(self:GetSequenceDuration(self,"atk_magatsu_mandala") *0.4),function()
							if IsValid(self) then
								self:PlayAnimation("atk_magatsu_mandala_end",1)
								timer.Simple(self:GetSequenceDuration(self,"atk_magatsu_mandala_end"),function()
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
		elseif self:GetCard() == "Yomi Drop" then
			self:InstaKill(ply,persona,rmb)
		end
	end
	if r && CurTime() > self.NextCardSwitchT then
		if self:GetCard() == "Maziodyne" then
			self:SetCard("Heat Riser")
		elseif self:GetCard() == "Heat Riser" then
			self:SetCard("Evil Smile")
		elseif self:GetCard() == "Evil Smile" then
			self:SetCard("Yomi Drop")
		elseif self:GetCard() == "Yomi Drop" then
			self:SetCard("Maziodyne")
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
function ENT:Maziodyne(ply,persona,rmb)
	local rmb = ply:KeyDown(IN_ATTACK2)
	if rmb then
		if self.InstaKillStage > 0 then return end
		if self.User:GetSP() > self.CurrentCardCost && !self.IsArmed && self:GetTask() != "TASK_PLAY_ANIMATION" && self:GetTask() != "TASK_ATTACK" && CurTime() > self.RechargeT then
			self.DamageBuild = 250
			self:TakeSP(self.CurrentCardCost)
			self:SetTask("TASK_PLAY_ANIMATION")
			self:PlayAnimation("atk_magatsu_mandala_pre",1)
			ply:EmitSound("cpthazama/persona5/adachi/vo/curse.wav")
			if math.random(1,2) == 1 then self:DoCritical(1) end
			timer.Simple(self:GetSequenceDuration(self,"atk_magatsu_mandala_pre"),function()
				if IsValid(self) then
					self.IsArmed = true
					self:PlayAnimation("atk_magatsu_mandala_pre_idle",1,1)
				end
			end)
		end
		if self:GetTask() == "TASK_PLAY_ANIMATION" && self.IsArmed && CurTime() > self.TimeToMazionga then
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
							self:MaziodyneAttack(a,30000)
						end
					end)
				end
			end
			timer.Simple(3,function()
				if IsValid(self) then
					self.RechargeT = CurTime() +5
					self.IsArmed = false
					self:DoIdle()
				end
			end)
		end
	end
end
---------------------------------------------------------------------------------------------------------------------------------------------
function ENT:InstaKill(ply,persona,rmb)
	if rmb then
		if self.InstaKillStage > 0 then return end
		if self.User:GetSP() > self.CurrentCardCost && CurTime() > self.NextInstaKillT && self:GetTask() == "TASK_IDLE" && self.InstaKillStage == 0 then
			self:SetTask("TASK_PLAY_ANIMATION")
			self:PlayAnimation("atk_magatsu_mandala_pre",1)
			self.InstaKillStage = 1
			self.InstaKillTarget = NULL
			self.NextInstaKillT = CurTime() +20
			self:TakeSP(self.CurrentCardCost)
			self:DoCritical(1)

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
end
---------------------------------------------------------------------------------------------------------------------------------------------
function ENT:EvilSmile(ply,persona,rmb)
	if !IsValid(ply.Persona_EyeTarget) then
		return
	end
	if self.InstaKillStage > 0 then
		return
	end
	if self.User:GetSP() > self.CurrentCardCost && self:GetTask() != "TASK_PLAY_ANIMATION" then
		self:SetTask("TASK_PLAY_ANIMATION")
		self:TakeSP(self.CurrentCardCost)
		self:PlayAnimation("evileye",1)
		ply:EmitSound("cpthazama/vox/adachi/kill/vbtl_pad_0#178 (pad300_0).wav",72)
		timer.Simple(0.6,function()
			if IsValid(self) then
				if !IsValid(ply.Persona_EyeTarget) then
					return
				end
				self:Fear(ply.Persona_EyeTarget,15)
				ply:ChatPrint("Target is now feared!")
			end
		end)
		timer.Simple(self:GetSequenceDuration(self,"evileye"),function()
			if IsValid(self) then
				self:SetTask("TASK_IDLE")
				self:DoIdle()
			end
		end)
	end
end
---------------------------------------------------------------------------------------------------------------------------------------------
function ENT:MaziodyneAttack(att,dist)
	local pos = self:GetAttachment(att).Pos
	local tr = util.TraceLine({
		start = pos,
		endpos = pos +self:GetForward() *dist,
	})
	self:EmitSound("cpthazama/persona5/adachi/elec_charge.wav",75)
	if tr.Hit then
		util.ParticleTracerEx("fo4_libertyprime_laser",pos,tr.HitPos,false,self:EntIndex(),att) // maziodyne_blue
		sound.Play("cpthazama/persona5/adachi/elec.wav",tr.HitPos,90)
		if tr.Entity && tr.Entity:Health() && tr.Entity:Health() > 0 then
			local dmginfo = DamageInfo()
			dmginfo:SetDamage(self:GetCritical() && 5 *2 or 5)
			dmginfo:SetAttacker(self.User)
			dmginfo:SetInflictor(self)
			dmginfo:SetDamageType(bit.bor(DMG_DISSOLVE,DMG_ENERGYBEAM,DMG_P_ELEC))
			dmginfo:SetDamagePosition(tr.Entity:NearestPoint(tr.HitPos))
			tr.Entity:TakeDamageInfo(dmginfo)
		end
	end
end
---------------------------------------------------------------------------------------------------------------------------------------------
function ENT:DoIdle()
	self:SetTask("TASK_IDLE")
	self.CurrentIdle = self.User:IsPlayer() && self.User:Crouching() && "low_hp" or "idle"
	self:PlayAnimation(self.CurrentIdle,1,1)
end
---------------------------------------------------------------------------------------------------------------------------------------------
function ENT:GetAttackPosition()
	return self:GetTask() == "TASK_ATTACK" && self:GetPos() +self:OBBCenter() +self:GetForward() *675 or self:GetPos() +self:OBBCenter()
end
---------------------------------------------------------------------------------------------------------------------------------------------
function ENT:GetSpawnPosition(ply)
	if ply:IsPlayer() then
		return ply:GetPos() +ply:GetForward() *(ply:Crouching() && -10 or -50) +ply:GetRight() *(ply:Crouching() && -10 or 0)
	else
		return ply:GetPos() +ply:GetForward() *-50
	end
end
---------------------------------------------------------------------------------------------------------------------------------------------
function ENT:GetIdlePosition(ply)
	if ply:IsPlayer() then
		return ply:GetPos() +ply:GetForward() *(ply:Crouching() && -10 or -50) +ply:GetRight() *(ply:Crouching() && -10 or 0)
	else
		return ply:GetPos() +ply:GetForward() *-50
	end
end
---------------------------------------------------------------------------------------------------------------------------------------------
function ENT:OnSummoned(ply)
	if ply:IsPlayer() then ply:EmitSound("cpthazama/persona5/adachi/vo/summon_0" .. math.random(1,8) .. ".wav") end
	self:SetModel(self.Model)
	self.PersonaDistance = 999999999 -- 40 meters
	self.TimeToMazionga = CurTime() +2
	self.RechargeT = CurTime()
	self.NextInstaKillT = CurTime()
	self.InstaKillTarget = NULL
	self.InstaKillTargetPos = Vector(0,0,0)
	self.IsArmed = false
	self.InstaKillStage = 0
	self.InstaKillStyle = 0
	self.HeatRiserT = CurTime()
	
	self:SetCritical(false)

	self.Damage = 400

	self:AddCard("Maziodyne",22,false)
	self:AddCard("Heat Riser",30,false)
	self:AddCard("Magatsu Mandala",30,false)
	self:AddCard("Evil Smile",12,false)
	self:AddCard("Yomi Drop",100,false)
	self:SetCard("Maziodyne")

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