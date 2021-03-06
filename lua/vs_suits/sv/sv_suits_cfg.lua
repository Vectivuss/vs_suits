//////////////////////////////////////////////////////////////////////////////////

/////////////////////////////// Vectivus´s Suits /////////////////////////////

// Developed by Vectivus:
// http://steamcommunity.com/profiles/76561198371018204

//////////////////////////////////////////////////////////////////////////////////

local config = VectivusSuits

config.commands = { // Commands that can drop player suit
    "/dropsuit", 
    "!dropsuit",

}

// Armour Suits //
config.suit[ "bhopsuit" ] = { -- test suit

    // name of suit
    name = "BHop Suit",

    // model of the armor suit
    model = "models/player/alyx.mdl",

    // The health the suit spawns with
    health = 1500,

    // The armor the suit spawns with
    armor = 150,

    // How much each HP costs for repairing
    repair = 10,

    // How long it takes to drop armor suit
    droptime = 4,

    // How long the ability lasts
    abilitytime = 5,

    // How long the ability cooldown lasts
    abilitycooldown = 10, 

    // Description on what the ability does
    abilitydescription = "Minor sprint boost",

    OnEquip = function( p ) // player
        p:SetRunSpeed( p:GetRunSpeed() * 2 )
        p:SetNWBool( "QBhopSuit", true )
    end,

    OnRemove = function( p ) // player
        p:SetNWBool( "QBhopSuit", false )
    end,

    OnTakeDamage = function( p, t, a ) // player, CTakeDamageinfo, hasActiveAbility(bool)
        // code
    end,

    OnThink = function( p, a ) // player, hasActiveAbility(bool)
        // code
        // note: this can be dangerous if used incorrectly/inefficiently...
    end,

    OnArrest = function( p, e ) // player, arrester
        // code
        return false -- prevents player getting arrested
    end,

    OnKeyPressed = function( p, k, a ) // player, key, hasActiveAbility(bool)
        // Keys: https://wiki.facepunch.com/gmod/Enums/KEY
        // code
    end,

    OnAbilityStart = function( p ) // player
        p.__runspeed = p:GetRunSpeed()
        p:SetRunSpeed( p.__runspeed * 2 )
    end,

    OnAbilityEnd = function( p ) // player
        p:SetRunSpeed( p.__runspeed )
        p.__runspeed = nil
    end,
}


// Config ends here //
timer.Simple( 0, function() _SuitSystem_SyncAll() end ) -- IGNORE