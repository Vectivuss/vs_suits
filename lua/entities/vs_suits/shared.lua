ENT.Type = "anim"
ENT.Base = "base_gmodentity"
ENT.PrintName = "Armor Suit"
ENT.Author = "Vectivus"
ENT.Category = "Vectivus´s Suits"
ENT.Spawnable = false

function ENT:SetupDataTables()
    self:NetworkVar( "String", 0, "SuitKey" )
    self:NetworkVar( "Int", 1, "SuitHealth" )
    self:NetworkVar( "Int", 2, "SuitArmor" )
end