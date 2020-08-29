TOOL.Name = "Select Costume"
TOOL.Tab = "Persona"
TOOL.Category = "Tools"
TOOL.Command = nil -- The console command to execute upon being selected in the Q menu.
---------------------------------------------------------------------------------------------------------------------------------------------
if (CLIENT) then
	language.Add("tool.vjstool_persona_costume.name","Select Costume")
	language.Add("tool.vjstool_persona_costume.desc","Cycle through a character's costumes")
	language.Add("tool.vjstool_persona_costume.0","LMB - Cycle Costumes | RMB - Get Next Costume Name")
end
---------------------------------------------------------------------------------------------------------------------------------------------
function TOOL:LeftClick(tr)
	if (CLIENT) then return true end
	if !tr.Entity:IsNPC() then return end
	if !tr.Entity.VJ_PersonaNPC then return end
	if !tr.Entity.CostumeList then
		self:GetOwner():ChatPrint("No Costumes exist for this Character!")
		return
	end

	tr.Entity:UpdateCostume(self:GetOwner())
	return true
end
---------------------------------------------------------------------------------------------------------------------------------------------
function TOOL:RightClick(tr)
	if (CLIENT) then return true end
	if !tr.Entity:IsNPC() then return end
	if !tr.Entity.VJ_PersonaNPC then return end
	if !tr.Entity.CostumeList then
		self:GetOwner():ChatPrint("No Costumes exist for this Character!")
		return
	end
	
	self:GetOwner():ChatPrint("Next Costume: " .. tr.Entity:GetNextCostume().Name)
	return true
end
---------------------------------------------------------------------------------------------------------------------------------------------
function TOOL:Reload(tr)
	if (CLIENT) then
		return true
	end
end