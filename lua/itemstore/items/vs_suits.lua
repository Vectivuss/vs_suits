ITEM.Name = "Armor Suit"
ITEM.Description = "A form of protection from damage"
ITEM.Model = "models/items/item_item_crate.mdl"
ITEM.Stackable = false
ITEM.DropStack = false
ITEM.Base = "base_darkrp"

function ITEM:GetName()
    local k = self:GetData( "SuitKey" )
    local t = GetSuitData( k )
    if !k then return end
    return "Armor Suit (" .. t.name .. ")"
end

function ITEM:GetDescription()
    local k = self:GetData( "SuitKey" )
    local health = self:GetData( "Health" )
    local armor = self:GetData( "Armor" )
    local t = GetSuitData( k )
    if !k then return end
    return t.name .. "\n\n" .. "Health: " .. health .. "\n" .. "Armor: " .. armor
end

function ITEM:CanPickup( p, e )
	return true
end

function ITEM:CanMerge( e )
	return false
end

function ITEM:SaveData( e )
    self:SetData( "SuitKey", e:GetSuitKey() )
    self:SetData( "Health", e:GetSuitHealth() )
    self:SetData( "Armor", e:GetSuitArmor() )
end

function ITEM:LoadData( e )
    e:SetSuitVar( "suitkey", self:GetData( "SuitKey" ) )
    e:SetSuitVar( "health", self:GetData( "Health" ) )
    e:SetSuitVar( "armor", self:GetData( "Armor" ) )
end
