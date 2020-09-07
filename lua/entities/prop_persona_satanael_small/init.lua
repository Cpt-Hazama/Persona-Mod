AddCSLuaFile("shared.lua")
include("shared.lua")
---------------------------------------------------------------------------------------------------------------------------------------------
function ENT:OnSummoned(ply)
	self:UserSound("cpthazama/persona5/joker/0314.wav")
	
	self:SetModelScale(0.085,0)
	self.Scaled = true

	self:AddCard("Maeigaon",22,false,"curse")
	self:AddCard("Megidolaon",38,false,"almighty")
	-- self:AddCard("Black Viper",48,false,"almighty")
	self:AddCard("Heat Riser",30,false,"passive")
	self:AddCard("Riot Gun",24,true,"gun")
	-- self:AddCard("Sinful Shell",999,false,"almighty")

	self:SetCard("Megidolaon")
	self:SetCard("Riot Gun",true)

	local v = {forward=-650,right=200,up=200}
	ply:SetNWVector("Persona_CustomPos",Vector(v.right,v.forward,v.up))
end
---------------------------------------------------------------------------------------------------------------------------------------------
function ENT:GetSpawnPosition(ply)
	return ply:GetPos() +ply:GetForward() *-200 +ply:GetRight() *-15
end
---------------------------------------------------------------------------------------------------------------------------------------------
function ENT:GetIdlePosition(ply)
	return ply:GetPos() +ply:GetForward() *-200 +ply:GetRight() *-15
end