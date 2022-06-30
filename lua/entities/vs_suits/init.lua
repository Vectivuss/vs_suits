AddCSLuaFile( "cl_init.lua" )
AddCSLuaFile( "shared.lua" )
include( "shared.lua" )

function ENT:Initialize()
    self:SetModel( "models/items/item_item_crate.mdl" )
    self:PhysicsInit( SOLID_VPHYSICS )
    self:SetMoveType( MOVETYPE_VPHYSICS )
    self:SetSolid( SOLID_VPHYSICS )
    self:SetUseType( SIMPLE_USE )

    local phys = self:GetPhysicsObject()
    if phys then
        phys:Wake()
    end
end

function ENT:Use( p )
    if self.USED then return end
    if p:HasActiveSuit() then return end
    local k = self:GetSuitVars()
    self:Remove()
    self.USED = true
    if !k then return end
    if table.IsEmpty( k ) then return end
    if !k.suitkey or k.suitkey == "" then return end
    p:GiveSuit( self, k.suitkey )
end