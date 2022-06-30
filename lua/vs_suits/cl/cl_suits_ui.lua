for i=12, 50 do
	surface.CreateFont( "ui."..i, { font = "Arial", size = i }) 
	surface.CreateFont( "uib."..i, { font = "Arial", size = i, weight = 1024 })
end

concommand.Add( "vs.suit", function( p )
    local w, h = ScrW(), ScrH()
    if !p:GetSuit() then return end
    local t = p:GetSuitTable()

    local hp = p:GetSuitVars( "health" )
    local ap = p:GetSuitVars( "armor" )
    local maxhp = t.health
    local maxap = t.armor

    local DFrame = vgui.Create( "DFrame" )
    DFrame:SetTitle( "" )
    DFrame:DockPadding( 0, 0, 0, 0 )
    DFrame:MakePopup()
    DFrame:SetSize( w*.45, h*.6 )
    DFrame:Center()
    DFrame.Think = function( s )
        if input.IsKeyDown( KEY_TAB ) then s:Close() end
    end
    DFrame.Paint = function( s, w, h )
        draw.RoundedBox( 0, 0, 0, w, h, Color( 46, 55, 85 ) )
    end

    DFrame:ShowCloseButton( false )

    local DPanel = vgui.Create( "DPanel", DFrame )
    DPanel:Dock( TOP )
    DPanel:SetTall( h*.05 )
    DPanel.Paint = function( s, w, h )
        draw.RoundedBox( 0, 0, 0, w, h, Color( 0, 0, 0, 88 ) )
        draw.SimpleText( "Armor Suits", "uib.22", w*.015, h*.3, color_white, TEXT_ALIGN_LEFT, TEXT_ALIGN_TOP )
    end

    local DButton = vgui.Create( "DButton", DPanel )
    DButton:Dock( RIGHT )
    DButton:SetWide( h*.045 )
    DButton:SetText( "" )
    DButton.Paint = function( s, w, h )
        if s:IsHovered() then
            draw.SimpleText( "X", "uib.30", w*.5, h*.5, Color( 255, 0, 0 ), TEXT_ALIGN_CENTER, TEXT_ALIGN_CENTER )
        else
            draw.SimpleText( "X", "uib.30", w*.5, h*.5, color_white, TEXT_ALIGN_CENTER, TEXT_ALIGN_CENTER )
        end
    end
    DButton.DoClick = function()
        DFrame:Close()
    end

    local SuitModelPanel = vgui.Create( "DPanel", DFrame )
    SuitModelPanel:Dock( LEFT )
    SuitModelPanel:SetWide( h*.3 )
    SuitModelPanel.Paint = function( s, w, h )
        draw.RoundedBox( 0, 0, 0, w, h, Color( 0, 0, 0, 66 ) )
    end

    local DPanel = vgui.Create( "DPanel", SuitModelPanel )
    DPanel:Dock( BOTTOM )
    DPanel:SetTall( h*.05 )
    DPanel.Paint = function( s, w, h )
        draw.SimpleText( t.name or "", "uib.20", w*.5, h*.5, color_white, TEXT_ALIGN_CENTER, TEXT_ALIGN_CENTER )
    end

    local DModelPanel = vgui.Create( "DModelPanel", SuitModelPanel )
    DModelPanel:Dock( FILL )
    DModelPanel:DockMargin( 0, 0, 0, h*.05 )
    DModelPanel:SetModel( p:GetModel() )
    DModelPanel:SetFOV( 1920/w * 45 )
    function DModelPanel:LayoutEntity() return end -- disables default rotation

    local DPanel = vgui.Create( "DPanel", DFrame )
    DPanel:Dock( FILL )
    DPanel.Think = function()
        hp = p:GetSuitVars( "health" )
        ap = p:GetSuitVars( "armor" )
    end
    DPanel.Paint = function( s, w, h )
        local x, y = w*.02, h*.02

        local _, yy = draw.SimpleText( "Health: " .. hp, "uib.20", x, y, color_white, TEXT_ALIGN_LEFT, TEXT_ALIGN_TOP )
        y = y + yy * 1.5

        local _, yy = draw.SimpleText( "Armor: " .. ap, "uib.20", x, y, color_white, TEXT_ALIGN_LEFT, TEXT_ALIGN_TOP )
        y = y + yy
    end

    local price = ( maxhp - hp ) * t.repair
    local canAfford = p:canAfford( price )
    local DButton = vgui.Create( "DButton", DPanel )
    DButton:Dock( BOTTOM )
    DButton:SetTall( h*.04 )
    DButton:SetText( "" )
    DButton.Paint = function( s, w, h )
        draw.RoundedBox( 0, 0, 0, w, h, Color( 0, 0, 0, 128 ) )
        if s:IsHovered() then
            if canAfford then
                draw.SimpleText( DarkRP.formatMoney( price ), "uib.20", w*.5, h*.5, Color( 71, 238, 65 ), TEXT_ALIGN_CENTER, TEXT_ALIGN_CENTER )
            else
                draw.SimpleText( DarkRP.formatMoney( price ), "uib.20", w*.5, h*.5, Color( 200, 0, 0 ), TEXT_ALIGN_CENTER, TEXT_ALIGN_CENTER )
            end
        else
            draw.SimpleText( "Repair " .. t.name, "uib.20", w*.5, h*.5, color_white, TEXT_ALIGN_CENTER, TEXT_ALIGN_CENTER )
        end
    end
    DButton.DoClick = function()
        RunConsoleCommand( "vs.suit.repair" )
    end
end )
