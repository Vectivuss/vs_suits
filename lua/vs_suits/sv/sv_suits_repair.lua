local function SuitSystem_RepairSuit( p )
    local config = VectivusSuits
    if !p:GetSuit() then return end
    local t = p:GetSuitTable()
    local tt = p:GetSuitVars()

    local npcRadius = ents.FindByClass( "vs_suits_npc" )
    local Radius = false
    for _, e in pairs( npcRadius ) do
        if p:GetPos():Distance( e:GetPos() ) < 160 then
            Radius = true
            break
        end
    end
    if !Radius then return end

    local hp = tt["health"]
    local ap = tt["armor"]
    local maxhp = t.health
    local maxap = t.armor

    local price = ( maxhp - hp ) * t.repair
    local canAfford = p:canAfford( price )

    do // checks
        if ap >= maxap then
            DarkRP.notify( p, 0, 2, "You're suit doesn't seem to damaged." )
            return
        end

        if !canAfford then
            DarkRP.notify( p, 1, 2, "You cannot afford this!" )
            return
        end

        DarkRP.notify( p, 2, 3, "Repaired '" .. t.name .. "' for '" .. DarkRP.formatMoney( price ) )
        p:addMoney( -price )
        p:SetSuitVar( "health", t.health )
        p:SetSuitVar( "armor", t.armor )
    end
end
concommand.Add( "vs.suit.repair", function( p ) SuitSystem_RepairSuit( p ) end )