ENT.Base 			= "base_gmodentity"
ENT.Type 			= "anim"
ENT.PrintName 		= ""
ENT.Author 			= "Cpt. Hazama"
ENT.Contact 		= ""
ENT.Purpose 		= ""
ENT.Instructions 	= ""
ENT.Category		= ""

ENT.Spawnable = false
ENT.AdminOnly = false
ENT.AutomaticFrameAdvance = true

ENT.IsPersona = true

ENT.AllowFading = false
---------------------------------------------------------------------------------------------------------------------------------------------
if SERVER then
	util.AddNetworkString("Persona_SetName")
	util.AddNetworkString("Persona_InstaKill")
	util.AddNetworkString("Persona_UpdateCards")
	util.AddNetworkString("Persona_Elements")
	
	/*
	self:DoDefaultAnimation(1,"Cleave",function(self) print("meleedmg") end,{A=0,B=0.8})
	self:DoDefaultAnimation(2,"Charge",{
		["range_start"] = function(self)
			// Code here
		end,
		["range_start_idle"] = function(self)
			// Code here
		end,
		["range"] = function(self)
			// Code here
		end,
		["range_idle"] = function(self)
			// Code here
		end,
		["range_end"] = function(self)
			// Code here
		end,
	})
	*/
	function ENT:DoDefaultAnimation(type,skill,tableCode,defTable)
		if type == 1 then
			if self.User:Health() > self.User:GetMaxHealth() *self:GetMeleeCost() && self:GetTask() == "TASK_IDLE" then
				def1 = defTable.A or 0
				def2 = defTable.B or 0.8
				self:SetTask("TASK_ATTACK")
				self:TakeHP(self.User:GetMaxHealth() *self:GetMeleeCost())
				self:SetAngles(self.User:GetAngles())
				local t = self:PlaySet(skill,"melee",1)
				timer.Simple((self.StartMeleeDamageCode or def1),function()
					if IsValid(self) then
						if math.random(1,100) <= self.Stats.LUC && math.random(1,2) == 1 then self:DoCritical(2) end
						timer.Simple((self.FirstMeleeDamageTime or def2),function()
							if IsValid(self) then
								if tableCode then
									tableCode(self)
								end
							end
						end)
					end
				end)
				timer.Simple(t,function()
					if IsValid(self) then
						self:DoIdle()
					end
				end)
			end
		else
			if self.User:GetSP() >= self.CurrentCardCost && self:GetTask() == "TASK_IDLE" then
				self:TakeSP(self.CurrentCardCost)
				self:SetTask("TASK_PLAY_ANIMATION")
				local t = self:PlaySet(skill,"range_start",1)
				if tableCode["range_start"] then tableCode["range_start"](self) end
				timer.Simple(t,function()
					if IsValid(self) then
						t = self:PlaySet(skill,"range_start_idle",1,1)
						if tableCode["range_start_idle"] then tableCode["range_start_idle"](self) end
						timer.Simple(t,function()
							if IsValid(self) then
								t = self:PlaySet(skill,"range",1)
								if tableCode["range"] then tableCode["range"](self) end
								timer.Simple(t,function()
									if IsValid(self) then
										t = self:PlaySet(skill,"range_idle",1,1)
										if tableCode["range_idle"] then tableCode["range_idle"](self) end
										timer.Simple(t,function()
											if IsValid(self) then
												t = self:PlaySet(skill,"range_end",1)
												if tableCode["range_end"] then tableCode["range_end"](self) end
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
	end
end
---------------------------------------------------------------------------------------------------------------------------------------------
-- if CLIENT then
	-- net.Receive("Persona_UpdateCards",function(len)
		-- local tb = net.ReadTable()

		-- self.CardTable = tb
	-- end)
-- end
---------------------------------------------------------------------------------------------------------------------------------------------
function ENT:HandleEvents(skill,animBlock,seq,t)
	// Custom code here
	/*
		skill = The Skill in which this was called from
		animBlock = The pre-set name in the Animations table for the sequence
		seq = The sequence that has just been set to play
		t = The length of the sequence in seconds
	*/
end
---------------------------------------------------------------------------------------------------------------------------------------------
function ENT:SetupDataTables()
	self:NetworkVar("Bool",0,"Critical")
	self:NetworkVar("Bool",0,"CriticalFX")
	self:NetworkVar("Int",0,"LVL")
	self:NetworkVar("Int",1,"STR")
	self:NetworkVar("Int",2,"MAG")
	self:NetworkVar("Int",3,"END")
	self:NetworkVar("Int",4,"AGI")
	self:NetworkVar("Int",5,"LUC")
	self:NetworkVar("String",0,"LastSet")
end
---------------------------------------------------------------------------------------------------------------------------------------------
function ENT:SetFeedName(name,class)
	net.Start("Persona_SetName")
		net.WriteString(name)
		net.WriteString(class)
	net.Broadcast()
	self.FeedName = name
end
---------------------------------------------------------------------------------------------------------------------------------------------
function ENT:DoInstaKillTheme(ents,t,ft)
	for _,v in pairs(ents) do
		if IsValid(v) && v:IsPlayer() then
			net.Start("Persona_InstaKill")
				net.WriteEntity(v)
				net.WriteInt(t,32)
				net.WriteInt(ft,32)
			net.Broadcast()
		end
	end
end
---------------------------------------------------------------------------------------------------------------------------------------------
if CLIENT then
	function ENT:Draw()
		-- local name = "PersonaMod_FixOutlines_" .. self:EntIndex()
		-- local ent = self
		self:DrawModel()
		-- hook.Add("RenderScreenspaceEffects",name,function()
			-- if !IsValid(ent) then
				-- hook.Remove("RenderScreenspaceEffects",name)
				-- return
			-- end
			-- cam.Start3D(EyePos(),EyeAngles())
				-- render.SetBlend(1)
				-- render.MaterialOverride(Material("models/cpthazama/persona_shared/glow_red"))
				-- ent:DrawModel()
				-- render.MaterialOverride(0)
				-- render.SetBlend(1)
			-- cam.End3D()
		-- end)
	end

	net.Receive("Persona_SetName",function(len)
		local name = net.ReadString()
		local class = net.ReadString()

		language.Add(class,name)
		killicon.Add(class,"HUD/killicons/default",Color(255,80,0,255))
	end)

	net.Receive("Persona_Elements",function(len,pl)
		local ply = net.ReadEntity()
		local WK = net.ReadTable()
		local RES = net.ReadTable()
		local NUL = net.ReadTable()
		local REF = net.ReadTable()
		local ABS = net.ReadTable()

		ply.PersonaElements = {}
		ply.PersonaElements.WK = WK or {}
		ply.PersonaElements.RES = RES or {}
		ply.PersonaElements.NUL = NUL or {}
		ply.PersonaElements.REF = REF or {}
		ply.PersonaElements.ABS = ABS or {}
	end)

	net.Receive("Persona_InstaKill",function(len)
		local v = net.ReadEntity()
		local t = net.ReadInt(32)
		local ft = net.ReadInt(32)

		if v.InstaKillTheme then v.InstaKillTheme:Stop() end
		v.InstaKillTheme = CreateSound(v,"cpthazama/persona5/instakill.wav")
		v.InstaKillTheme:SetSoundLevel(0)
		v.InstaKillTheme:Play()
		v.InstaKillTheme:ChangeVolume(1)
		v.InstaKillThemeID = v.InstaKillThemeID && v.InstaKillThemeID +1 or 1
		local id = v.InstaKillThemeID
		timer.Simple(t,function()
			if v.InstaKillTheme && v.InstaKillTheme:IsPlaying() && v.InstaKillThemeID == id then
				v.InstaKillTheme:FadeOut(ft)
			end
		end)
	end)
end
---------------------------------------------------------------------------------------------------------------------------------------------
function ENT:FadeIn()
	self:SetColor(Color(255,255,255,0))
	self:SetRenderMode(RENDERMODE_TRANSADD)
	self:SetKeyValue("RenderFX",kRenderFxSolidSlow)
end
---------------------------------------------------------------------------------------------------------------------------------------------
function ENT:FadeOut()
	self:SetColor(Color(255,255,255,255))
	self:SetRenderMode(RENDERMODE_TRANSADD)
	self:SetKeyValue("RenderFX",kRenderFxFadeSlow)
end
---------------------------------------------------------------------------------------------------------------------------------------------
function ENT:IsMyTurn()
	local ply = self.User
	local battleEnt = ply:GetBattleEntity()
	if !IsValid(battleEnt) then return true end -- Not in Battle Mode, just attack like normal
	if battleEnt:GetNW2Bool("TakeTurns") == false then return true end -- Not taking turns, attack like normal
	return ply:GetCurrentBattleTurnEntity() == ply -- Current selected entity in the turn table matches my user
end
---------------------------------------------------------------------------------------------------------------------------------------------
function ENT:OnFinishedAttack(skill)
	local ply = self.User
	local battleEnt = ply:GetBattleEntity()
	if IsValid(ply) && IsValid(battleEnt) then
		battleEnt:NextCurrentTurn()
	end
end
---------------------------------------------------------------------------------------------------------------------------------------------
local string_find = string.find
--
function ENT:PlaySet(skill,name,rate,cycle)
	local ply = self.User
	local battleEnt = ply:GetBattleEntity()
	local seq = self.Animations[name]

	self:SetLastSet(name)
	if IsValid(ply) && ply:IsPlayer() && IsValid(battleEnt) then
		if string_find(name,"range") or name == "melee" then
			net.Start("Persona_Battle_DoClose")
				net.WriteEntity(ply)
			net.Send(ply)
		end
	end

	if name == "melee" then
		-- timer.Simple(self:GetSequenceDuration(self,self.Animations["melee"]) *0.5,function()
			-- if IsValid(self) && IsValid(self.User) then
				-- local battleEnt = self.User:GetNW2Entity("BattleEnt")
				-- local target = self.User:GetNW2Entity("Persona_Target")
				-- if IsValid(battleEnt) && IsValid(target) then
					-- battleEnt:SetNW2Entity("CurrentTurnEntity",target)
				-- end
			-- end
		-- end)
		timer.Simple(self:GetSequenceDuration(self,self.Animations["melee"]),function()
			if IsValid(self) then self:OnFinishedAttack(skill) end
		end)
	end
	-- if name == "range_idle" then
		-- if IsValid(self) && IsValid(self.User) then
			-- local battleEnt = self.User:GetNW2Entity("BattleEnt")
			-- local target = self.User:GetNW2Entity("Persona_Target")
			-- if IsValid(battleEnt) && IsValid(target) then
				-- battleEnt:SetNW2Entity("CurrentTurnEntity",target)
			-- end
		-- end
	-- end
	if name == "range_end" then
		timer.Simple(self:GetSequenceDuration(self,self.Animations["range_end"]),function()
			if IsValid(self) then self:OnFinishedAttack(skill) end
		end)
	end
	if self.AllowFading then
		if name == "idle" then
			self:FadeIn()
		end
		if name == "melee" then
			timer.Simple(self:GetSequenceDuration(self,self.Animations["melee"]) *0.65,function()
				if IsValid(self) then self:FadeOut() end
			end)
		end
		if name == "range_end" then
			-- self:FadeOut()
			local t = self:GetSequenceDuration(self,seq)
			timer.Simple(t *0.3,function()
				if IsValid(self) then self:FadeOut() end
			end)
			timer.Simple(t -0.01,function()
				if IsValid(self) then self:FadeIn() end
			end)
		end
	end
	return self:PlayAnimation(seq,rate,cycle,name,skill)
end
---------------------------------------------------------------------------------------------------------------------------------------------
function ENT:PlayAnimation(seq,rate,cycle,tbName,skill)
	self:ResetSequence(seq)
	self:SetPlaybackRate(rate)
	self:SetCycle(cycle or 0)
	local t = self:GetSequenceDuration(self,seq)
	self:HandleEvents(skill or "BLANK",tbName or "N/A",seq,t)
	if IsValid(self.User) && self.User:IsNPC() && self.User.OnPersonaAnimation then
		self.User:OnPersonaAnimation(self,skill or "BLANK",tbName or "N/A",seq,t)
	end
	return t
end
---------------------------------------------------------------------------------------------------------------------------------------------
function ENT:GetSequenceDuration(argent,actname)
	if isnumber(actname) then
		return argent:SequenceDuration(argent:SelectWeightedSequence(actname))
	elseif isstring(actname) then
		return argent:SequenceDuration(argent:LookupSequence(actname))
	end
	return 0
end
---------------------------------------------------------------------------------------------------------------------------------------------
function ENT:GetAnimation()
	return self:GetSequenceName(self:GetSequence())
end
---------------------------------------------------------------------------------------------------------------------------------------------
function ENT:SetTask(task)
	self.CurrentTask = task
	self.CurrentTaskID = PERSONA_TASKS[task]
end
---------------------------------------------------------------------------------------------------------------------------------------------
function ENT:GetTask()
	return self.CurrentTask
end
---------------------------------------------------------------------------------------------------------------------------------------------
function ENT:GetTaskID()
	return self.CurrentTaskID
end
---------------------------------------------------------------------------------------------------------------------------------------------
function ENT:UserSound(snd,vol,pitch)
	if IsValid(self.User) && self.User:IsPlayer() then
		self.User:EmitSound(snd,vol or 75,pitch or 100)
	end
end
---------------------------------------------------------------------------------------------------------------------------------------------
if (CLIENT) then
	-- function ENT:Draw()
		-- self:DrawModel()
	-- end
	
	function ENT:DrawTranslucent()
		self:Draw()
	end
end
---------------------------------------------------------------------------------------------------------------------------------------------
sound.Add({
	name = "PERSONA_MEGIDOLAON",
	channel = CHAN_STATIC,
	volume = 1.0,
	level = 125,
	sound = "cpthazama/persona5/skills/megidolaon.wav"
})