AddCSLuaFile("shared.lua")
include("shared.lua")
---------------------------------------------------------------------------------------------------------------------------------------------
ENT.Bot_StopDistance = 100
ENT.Bot_Buttons = {
	[1] = {but={IN_ATTACK},dist=100,chance=1},
}
ENT.DamageTypes = bit.bor(DMG_SLASH,DMG_CRUSH,DMG_ALWAYSGIB,DMG_P_FEAR)
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
	-- self:SetSkin(CurTime() > self.RechargeT && 0 or 1)
	if lmb then
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
		if self:GetCard() == "Maziodyne" then
			self:Maziodyne(ply,persona,rmb)
		elseif self:GetCard() == "Heat Riser" then
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
		end
	end
	if r && CurTime() > self.NextCardSwitchT then
		if self:GetCard() == "Maziodyne" then
			self:SetCard("Heat Riser")
		elseif self:GetCard() == "Heat Riser" then
			self:SetCard("Megidolaon")
		elseif self:GetCard() == "Megidolaon" then
			self:SetCard("Maziodyne")
		end
	end
end
---------------------------------------------------------------------------------------------------------------------------------------------
function ENT:Maziodyne(ply,persona,rmb)
	local rmb = ply:KeyDown(IN_ATTACK2)
	if rmb then
		if self.User:GetSP() > self.CurrentCardCost && !self.IsArmed && self:GetTask() != "TASK_PLAY_ANIMATION" && self:GetTask() != "TASK_ATTACK" && CurTime() > self.RechargeT then
			self.DamageBuild = 250
			self:TakeSP(self.CurrentCardCost)
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
							self:MagatsuMandala(a,30000)
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
	self.IsArmed = false
	self.HeatRiserT = CurTime()

	self.Damage = 400
	
	self:SetSkin(1)

	self:AddCard("Maziodyne",22,false)
	self:AddCard("Heat Riser",30,false)
	self:AddCard("Megidolaon",60,false)
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