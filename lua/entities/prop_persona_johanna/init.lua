AddCSLuaFile("shared.lua")
include("shared.lua")
---------------------------------------------------------------------------------------------------------------------------------------------
function ENT:VajraBlast(ply)
	
end
---------------------------------------------------------------------------------------------------------------------------------------------
function ENT:Freila(ply)
	
end
---------------------------------------------------------------------------------------------------------------------------------------------
function ENT:EnergyShower(ply)
	
end
---------------------------------------------------------------------------------------------------------------------------------------------
function ENT:Diarahan(ply)
	
end
---------------------------------------------------------------------------------------------------------------------------------------------
function ENT:AtomicFlare(ply)
	
end
---------------------------------------------------------------------------------------------------------------------------------------------
function ENT:OnSummoned(ply)
	ply:EmitSound("cpthazama/persona5/joker/0009.wav")
	self.StandDistance = 999999999
	
	self:AddCard("Vajra Blast",14,true) -- Med. Phys damage to all foes
	self:AddCard("Freila",8,false) -- Med. Nuclear damage to one foe
	self:AddCard("Energy Shower",8,false) -- Cure Confuse/Fear/Despair/Rage/Brainwash
	self:AddCard("Diarahan",18,false) -- Fully restore HP
	self:AddCard("Atomic Flare",48,false) -- Sev. Nuclear damage to one foes
	self:SetCard("Freila",8)
end