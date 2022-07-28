local ITEM = XeninInventory:CreateItemV2()
ITEM:SetMaxStack( 1 )
ITEM:SetModel( "models/items/item_item_crate.mdl" )

ITEM:AddDrop(function( _, _, e, t, _ )
    local data = t.data
    e:SetSuitVar( "suitkey", data["_Suitkey"] )
    e:SetSuitVar( "health", data["_SuitHealth"] )
    e:SetSuitVar( "armor", data["_SuitArmor"] )
    e:SetSuitKey( data["_Suitkey"] )
    e:SetSuitHealth( data["_SuitHealth"] )
    e:SetSuitArmor( data["_SuitArmor"] )
end )

function ITEM:GetData( e )
    return {
        _Suitkey = e:GetSuitKey(),
        _SuitHealth = e:GetSuitHealth(),
        _SuitArmor = e:GetSuitArmor(),
    }
end

function ITEM:GetName( e )
    local data = e.data or {}
    local t = GetSuitData( data["_Suitkey"] )
    if !t then return end
    if table.IsEmpty( t ) then return end
    return "Armor Suit (" .. t.name .. ")"
end

ITEM:SetDescription( function( _, e )
    local data = e.data or {}
    local t = GetSuitData( data["_Suitkey"] )
    if !t then return end
    if table.IsEmpty( t ) then return end

    local hp = data["_SuitHealth"] or 0
    local ap = data["_SuitArmor"] or 0

    local tbl = tbl or {}
    tbl[#tbl + 1 ] = "Health: " .. hp
    tbl[#tbl + 1 ] = "Armor: " .. ap

    return tbl
end )

ITEM:Register( "vs_suits" )