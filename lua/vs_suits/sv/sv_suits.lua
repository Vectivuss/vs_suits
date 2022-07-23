local config = VectivusSuits

function pMeta:SetActiveSuit( a )
    if !isbool( a ) then return end
    self:SetNWBool( "QHasActiveSuit", a )
end

function pMeta:SetSuit( k )
    if !k then return end
    self:SetNWString( "QSuitKey", k )
end

function eMeta:SetSuitVar( k, v )
    local t = self:GetSuitVars()
    t[k] = v
    self.suitVars = t
    self:SetNWString( "QSuitVar." .. tostring( k ), v )
end

function VectivusSuits:CreateSuit( p, k )
    if !IsValid( p ) then return end
    if !p:IsPlayer() then return end
    local t = GetSuitData( k )
    if !t then return end
    if table.IsEmpty( t ) then return end

    local trace = {}
    trace.start = p:EyePos()
    trace.endpos = trace.start + p:GetAimVector() * 85
    trace.filter = p

    local tr = util.TraceLine( trace )
    local suit = ents.Create( "vs_suits" )
    suit:SetPos( tr.HitPos )
    suit:Spawn()

    suit:SetSuitVar( "suitkey", k )
    suit:SetSuitVar( "health", t.health )
    suit:SetSuitVar( "armor", t.armor )
    suit:SetSuitKey( k )
    suit:SetSuitHealth( t.health )
    suit:SetSuitArmor( t.armor )
end
concommand.Add( "vs.suit.givesuit", function( p, _, t )
    if p != NULL then return end
    local steamid = t[1]
    local suitkey = tostring( t[2] )

    local pp = player.GetBySteamID64( steamid )
    if !pp then return end
    VectivusSuits:CreateSuit( pp, suitkey )
end )

function pMeta:GiveSuit( e, k )
    local t = GetSuitData( k )
    if !istable( t ) then return end

    if t.model then self:SetModel( t.model ) end
    if t.OnEquip then t.OnEquip( self ) end

    for k, v in pairs( e:GetSuitVars() ) do
        self:SetSuitVar( k, v )
    end
    self:SetActiveSuit( true )
    self:SetSuit( k )
end

function pMeta:RemoveSuit()
    local t = self:GetSuitTable()
    if !t then return end
    if t.OnRemove then t.OnRemove( self ) end

	hook.Call( "PlayerSetModel", GAMEMODE, self )
    self:SetRunSpeed( GAMEMODE.Config.runspeed )
    self:SetActiveSuit( false )
    self:SetSuit( false )
end

hook.Add( "PlayerSpawn", "SuitSystem.PlayerSpawn", function( p ) p:RemoveSuit() end )

hook.Add( "EntityTakeDamage", "SuitSystem.SuitPoints", function( e, t )
    local p = e:IsPlayer() and e
    if !IsValid( p ) then return end
    local tt = p:GetSuitVars()
    local ttt = p:GetSuitTable() 
    if !tt then return end
    if !ttt then return end

    local hasActiveAbility = tobool( p.suitAbility )

    if ttt.OnTakeDamage then ttt.OnTakeDamage( p, t, hasActiveAbility ) end // OnTakeDamage

    if p.suitDropping then
        timer.Remove( "suitdropping." .. tostring( p ) )
        p:SetNWFloat( "SuitDroppingEnd", 0 )
        p.suitDropping = false
    end

    local inf = t:GetInflictor()
    local damage = math.Round( t:GetDamage() )

    if SH_SZ and SH_SZ:GetSafeStatus( p ) == SH_SZ.PROTECTED then t:SetDamage( 0 ) return end
    if vs and vs.shield then if p:HasShields() then t:SetDamage( 0 ) return end end
    if inf:GetClass() == "prop_physics" then t:SetDamage( 0 ) return end
    if damage <= 0 then t:SetDamage( 0 ) return end

    if tt.armor then
        tt.armor = tt.armor - damage
        if tt.armor <= 0 then
            tt.armor = 0
        else
            damage = 0
        end
        p:SetSuitVar( "armor", tt.armor )
    end

    if tt.health then
        tt.health = tt.health - damage
        if tt.health <= 0 then
            tt.health = 0
            p:RemoveSuit()
        else
            damage = 0
        end
        p:SetSuitVar( "health", tt.health )
    end

    t:SetDamage( damage )
end )

hook.Add( "canArrest", "SuitSystem.OnArrest", function( e, p )
    if !p:HasActiveSuit() then return end
    local t = p:GetSuitTable()
    if t.OnArrest then return t.OnArrest( p, e ) end
end )

hook.Add( "PlayerButtonDown", "SuitSystem.OnAbility", function( p, k )
    if !p:HasActiveSuit() then return end
    local t = p:GetSuitTable()
    local hasActiveAbility = tobool( p.suitAbility )
    if t.OnKeyPressed then t.OnKeyPressed( p, k, hasActiveAbility ) end

    if p.suitDropping then return end
    if p.suitAbility then return end
    if k != KEY_G then return end
    local abilityCooldown = t.abilitycooldown
    if !abilityCooldown then return end
    if !t.OnAbility then return end

    p.suitAbility = true
    p:SetNWFloat( "SuitAbilityEnd", CurTime() + abilityCooldown )
    t.OnAbility( p )

    timer.Create( "suitability." .. tostring( p ), abilityCooldown, 1, function()
        if !IsValid( p ) then return end
        p:SetNWFloat( "SuitAbilityEnd", 0 )
        p.suitAbility = false
    end )
end )

hook.Add( "Think", "SuitSystem.OnThink", function()
    for _, p in pairs( player.GetAll() ) do
        if !IsValid( p ) then continue end 
        if !p:HasActiveSuit() then continue end
        local t = p:GetSuitTable()
        local hasActiveAbility = tobool( p.suitAbility )
        if t.OnThink then t.OnThink( p, hasActiveAbility ) end
    end
end )

hook.Add( "PlayerSay", "SuitSystem.DropSuit", function( p, t )
    if p.suitAbility then return "" end
    if p.suitDropping then return "" end
    local commands = config.commands
    if !p:Alive() then return "" end
    if !table.HasValue( commands, string.lower( t ) ) then return end

    if !p:HasActiveSuit() then return "" end
    local t = p:GetSuitTable()
    local droptime = t.droptime or 0
    p.suitDropping = true

    p:SetNWFloat( "SuitDroppingEnd", CurTime() + droptime )
    timer.Create( "suitdropping." .. tostring( p ), droptime, 1, function()
        if !IsValid( p ) then return end
        p:SetNWFloat( "SuitDroppingEnd", 0 )

        local trace = {}
        trace.start = p:EyePos()
        trace.endpos = trace.start + p:GetAimVector() * 85
        trace.filter = p

        local tr = util.TraceLine( trace )
        local suit = ents.Create( "vs_suits" )
        suit:SetPos( tr.HitPos )
        suit:Spawn()
        p:RemoveSuit()

        for k, v in pairs( p:GetSuitVars() ) do
            suit:SetSuitVar( k, v )
            p:SetSuitVar( k, nil )
        end

        local suitVars = suit:GetSuitVars()
        suit:SetSuitKey( suitVars.suitkey )
        suit:SetSuitHealth( suitVars.health )
        suit:SetSuitArmor( suitVars.armor )

        p.suitDropping = false
    end )
    return ""
end )
