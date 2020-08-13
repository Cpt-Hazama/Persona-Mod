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
ENT.Animations = {}
ENT.Animations["idle"] = "idle"
ENT.Animations["idle_low"] = "low_hp"
ENT.Animations["melee"] = "ghostly_wail_noXY"
ENT.Animations["range_start"] = "atk_magatsu_mandala_pre"
ENT.Animations["range_start_idle"] = "atk_magatsu_mandala_pre_idle"
ENT.Animations["range"] = "atk_magatsu_mandala_start"
ENT.Animations["range_idle"] = "atk_magatsu_mandala"
ENT.Animations["range_end"] = "atk_magatsu_mandala_end"
ENT.Animations["special"] = "evileye"
---------------------------------------------------------------------------------------------------------------------------------------------
ENT.Stats = {
	LVL = 77, -- Innate level
	STR = 65, -- Effectiveness of phys. attacks
	MAG = 55, -- Effectiveness of magic. attacks
	END = 66, -- Effectiveness of defense
	AGI = 45, -- Effectiveness of hit and evasion rates
	LUC = 45, -- Chance of getting a critical
	WK = {},
	RES = {},
	NUL = {DMG_P_CURSE,DMG_P_BLESS,DMG_P_MIRACLE},
}
---------------------------------------------------------------------------------------------------------------------------------------------
ENT.LeveledSkills = {
	{Level = 90, Name = "Yomi Drop", Cost = 100, UsesHP = false, Icon = "phys"},
	{Level = 83, Name = "Heat Riser", Cost = 30, UsesHP = false, Icon = "passive"},
	{Level = 80, Name = "Megidolaon", Cost = 38, UsesHP = false, Icon = "almighty"},
	{Level = 78, Name = "Maziodyne", Cost = 22, UsesHP = false, Icon = "elec"},
}
ENT.LegendaryMaterials = {}
ENT.LegendaryMaterials[1] = "models/cpthazama/persona5/magatsuizanagi/magatsuizanagi_legendary"
ENT.LegendaryMaterials[2] = "models/cpthazama/persona5/magatsuizanagi/magatsuizanagi_fx2_legendary"
ENT.LegendaryMaterials[3] = "models/cpthazama/persona5/magatsuizanagi/magatsuizanagi_classic_legendary"
ENT.LegendaryMaterials[4] = "models/cpthazama/persona5/magatsuizanagi/magatsuizanagi_classic_fx_legendary"
---------------------------------------------------------------------------------------------------------------------------------------------
function ENT:HandleEvents(skill,animBlock,seq,t)
	if skill == "Ghostly Wail" then
		if animBlock == "melee" then
			self.User:EmitSound("cpthazama/persona5/adachi/vo/ghostly_wail_0" .. math.random(1,2) .. ".wav",85)
		end
	end
end
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
		if self.User:GetSP() >= self.CurrentCardCost && !self.IsArmed && self:GetTask() != "TASK_PLAY_ANIMATION" && self:GetTask() != "TASK_ATTACK" && CurTime() > self.RechargeT then
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
							if self:GetTask() == "TASK_PLAY_ANIMATION" && self.IsArmed then
								self:PlayAnimation("atk_magatsu_mandala",1,1)
								-- self.TimeToMazionga = CurTime() +3.5
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
	-- self:SetSkin(CurTime() > self.RechargeT && 0 or 1)
	if rmb then
		-- if self.InstaKillStage > 0 then return end
		if self:GetCard() == "Yomi Drop" then
			self:InstaKill(ply,persona,rmb)
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
function ENT:InstaKill(ply,persona,rmb)
	if rmb then
		if self.InstaKillStage > 0 then return end
		if self.User:GetSP() >= self.CurrentCardCost && CurTime() > self.NextInstaKillT && self:GetTask() == "TASK_IDLE" && self.InstaKillStage == 0 then
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
						self:DoInstaKillTheme({self.User,ent},prediction,1)
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
	self.RechargeT = CurTime()
	self.NextInstaKillT = CurTime()
	self.InstaKillTarget = NULL
	self.InstaKillTargetPos = Vector(0,0,0)
	self.IsArmed = false
	self.InstaKillStage = 0
	self.InstaKillStyle = 0
	self.Magatsu = true
	
	self:SetCritical(false)

	self.Damage = 400

	-- self:AddCard("Maziodyne",22,false,"elec")
	-- self:AddCard("Heat Riser",30,false,"passive")
	self:AddCard("Magatsu Mandala",30,false,"curse")
	self:AddCard("Ghastly Wail",19,true,"almighty")
	self:AddCard("Evil Smile",12,false,"sleep")
	self:AddCard("Charge",15,false,"passive")
	-- self:AddCard("Megidolaon",38,false,"almighty")
	-- self:AddCard("Yomi Drop",100,false,"phys")

	self:SetCard("Evil Smile")
	self:SetCard("Ghastly Wail",true)

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