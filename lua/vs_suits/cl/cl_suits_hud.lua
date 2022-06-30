// Armor Suit HUD //

local gradientUp = Material( "gui/gradient_up" )
local gradientDown = Material( "gui/gradient_down" )

local lerpHP = 0
local lerpAP = 0
hook.Add( "HUDPaint", "SuitSystem.HUD", function()
    local p, w, h = LocalPlayer(), ScrW(), ScrH()
    if !IsValid( p ) then return end
    if !p:HasActiveSuit() then return end
    local t = p:GetSuitTable()
    if !t then return end

    local suit = t.name or ""
    local maxhp = t.health or 0
    local maxap = t.armor or 0

    local suithealth = p:GetSuitVars( "health" ) or 0
    local suitarmor = p:GetSuitVars( "armor" ) or 0

    local maxs = suithealth + suitarmor
    local amaxs = (maxhp + maxap) + maxs

    lerpHP = Lerp( FrameTime() * 2, lerpHP, suithealth )
    lerpAP = Lerp( FrameTime() * 2, lerpAP, suitarmor )

    local x, y = w*.375, h*.07
    local W, H =  w*.25, h*.02

    local hpw = math.Clamp( ( lerpHP / amaxs * 2 ) * W, 0, W )
    local apw = math.Clamp( ( lerpAP / amaxs * 2 ) * W, 0, W - hpw )

    draw.RoundedBox( 8, x, y, W, H, Color( 0, 0, 0, 240 ) )
    draw.RoundedBoxEx( 8, x + 2, y + 1, hpw, H -3, Color( 238, 23, 69, 225 ), true, false, true, false )
    draw.RoundedBoxEx( 8, x + hpw, y + 1, apw - 2, H -3, Color( 78, 144, 243, 225 ), false, true, false, true )

    draw.SimpleText( suit, "uib.25", w*.5, h*.045, color_white, TEXT_ALIGN_CENTER, TEXT_ALIGN_TOP )
    draw.SimpleText( math.ceil( math.Clamp( lerpHP, 0, maxhp ) ) .. " HP", "uib.18", w*.4, h*.072, color_white, TEXT_ALIGN_CENTER, TEXT_ALIGN_TOP )
    draw.SimpleText( math.ceil( math.Clamp( lerpAP, 0, maxap ) ) .. " AP", "uib.18", w*.6, h*.072, color_white, TEXT_ALIGN_CENTER, TEXT_ALIGN_TOP )

    // Armor Ability //
    local cooldown = t.abilitycooldown
    local i = p:GetNWFloat( "SuitAbilityEnd", 0 )
    if i <= 0 then  return end
    local f = math.Clamp( math.Remap( i-CurTime(), 0, cooldown, 0, 1 ), 0, 1 )

    surface.SetDrawColor( 255, 255, 255 )
    surface.DrawRect( w*.454, h*.12, h*.18 *f, 2 )
    
    draw.SimpleText( "Active Cooldown...", "uib.20", w*.505, h*.1, color_white, TEXT_ALIGN_CENTER, TEXT_ALIGN_TOP )
    // Armor Ability //

end )
// Armor Suit HUD //

// Armor Suit Drop HUD //
hook.Add( "HUDPaint", "SuitSystem.DropHUD", function()
    local p, w, h = LocalPlayer(), ScrW(), ScrH()
    if !IsValid( p ) then return end
    if !p:HasActiveSuit() then return end
    local t = p:GetSuitTable()
    local droptime = t.droptime or 0
    local x, y = w*.418, h*.94
    local i = p:GetNWFloat( "SuitDroppingEnd", 0 )
    if i <= 0 then return end
    local f = math.Clamp( math.Remap( i-CurTime(), 0, droptime, 0, 1 ), 0, 1 )

    surface.SetDrawColor( 255, 255, 255 )
    surface.DrawRect( x, y, h*.3 *f, 2 )

    draw.SimpleText( "Dropping...", "uib.20", x + ( h*.155), y - ( h*.022 ), color_white, TEXT_ALIGN_CENTER, TEXT_ALIGN_TOP )

    draw.SimpleText( math.Clamp( math.Round(i-CurTime(), 1), 0, 999999 ), "uib.20", x + ( h*.155), y + ( h*.012 ), color_white, TEXT_ALIGN_CENTER, TEXT_ALIGN_TOP )
end )
// Armor Suit Drop HUD //