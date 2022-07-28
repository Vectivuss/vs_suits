for i=12, 50 do
	surface.CreateFont( "vs.suit.ui."..i, { font = "Purista", size = i }) 
	surface.CreateFont( "vs.suit.uib."..i, { font = "Purista", size = i, weight = 1024 })
end

ArmourSuitsDFrameVGUI = ArmourSuitsDFrameVGUI or {}
ArmourSuitsDPanelVGUI = ArmourSuitsDPanelVGUI or {}
concommand.Add( "vs.suit", function( p )
    if !p:GetSuit() then return end
    local t = p:GetSuitTable()

    local w, h = ScrW(), ScrH()
    local W, H = w*.5, h*.65
	local closeIcon = Material( "vs_suits/close.png", "noclamp smooth" )

    local hp = p:GetSuitVars( "health" )
    local ap = p:GetSuitVars( "armor" )
    local maxhp = t.health
    local maxap = t.armor

    if IsValid( ArmourSuitsDFrameVGUI ) then ArmourSuitsDFrameVGUI:Remove() end
    if IsValid( ArmourSuitsDPanelVGUI ) then ArmourSuitsDPanelVGUI:Remove() end

    local DFrame = vgui.Create( "DFrame" )
    ArmourSuitsDFrameVGUI = DFrame
    DFrame:MakePopup()
	DFrame:SetKeyboardInputEnabled( false )
    DFrame:SetAlpha( 0 )
	DFrame:AlphaTo( 255, .1, .05 )
    DFrame:SetTitle( "" )
    DFrame:DockPadding( 0, 0, 0, 0 )
    DFrame:SetSize( w, h )
    DFrame:SetDraggable( false )
    DFrame.Close = function( s ) 
        if s.CLOSE then return end
        s.CLOSE = true
		s:SetMouseInputEnabled( false )
		s:SetKeyboardInputEnabled( false )
		s:AlphaTo( 0, .51, 0, function() s:Remove() end )
	end
    DFrame.OnMousePressed = function( s, k )
		if k == MOUSE_LEFT or k == MOUSE_RIGHT then
			s:Close()
		end
	end
    DFrame.Think = function( s )
        if input.IsKeyDown( KEY_TAB ) then s:Close() end
    end
    DFrame.Paint = function( s, w, h )
        draw.RoundedBox( 0, 0, 0, w, h, Color( 0, 0, 0, 128 ) )
    end
    local ArmorSuit = vgui.Create( "DPanel" )
    ArmourSuitsDPanelVGUI = ArmorSuit
    ArmorSuit:MakePopup()
    ArmorSuit:SetKeyboardInputEnabled( false )
    ArmorSuit:SetAlpha( 0 )
	ArmorSuit:AlphaTo( 255, .1, .05 )
    ArmorSuit:SetSize( W, H )
    ArmorSuit:Center()
    ArmorSuit.Close = function( s )
        if s.CLOSE then return end
        s.CLOSE = true
		s:SetMouseInputEnabled( false )
		s:SetKeyboardInputEnabled( false )
        s:Remove()
	end
    ArmorSuit.Think = function( s )
        if DFrame.CLOSE then s:Close() end
    end
    ArmorSuit.Paint = function( s, w, h )
        draw.RoundedBox( 8, 0, 0, w, h, Color( 155, 155, 155, 100 ) )
        draw.RoundedBox( 8, 1, 1, w-2, h-2, Color( 16, 8, 21, 250 ) )
    end

    local DPanel = vgui.Create( "DPanel", ArmorSuit )
    DPanel:Dock( TOP )
    DPanel:DockMargin( 1, 2, 1, 0 )
    DPanel:SetTall( H*.08 )
    DPanel.Paint = function( s, w, h )
        surface.SetDrawColor( 100, 100, 100 )
        surface.DrawRect( 0, h-1, w, h-1 )
        draw.SimpleText( "Armor Suits", "vs.suit.uib.42", w*.5, h*.1, color_white, TEXT_ALIGN_CENTER, TEXT_ALIGN_TOP )
    end

    local DButton = vgui.Create( "DButton", DPanel )
    DButton:Dock( RIGHT )
    DButton:SetWide( H*.08 )
    DButton:SetText( "" )
    DButton.Paint = function( s, w, h )
		if s:IsHovered() then
			surface.SetDrawColor( 233, 42, 74 )
		else
			surface.SetDrawColor( 200, 200, 200 )
		end
		surface.SetMaterial( closeIcon )
		surface.DrawTexturedRectRotated( w/2, h/2, h*.65, h*.65, 0 )
    end
    DButton.DoClick = function()
        surface.PlaySound( "buttons/button15.wav" )
        DFrame:Close()
    end

    // Playermodel //
    local DArmorSuitModel = vgui.Create( "DPanel", ArmorSuit )
    DArmorSuitModel:Dock( LEFT )
    DArmorSuitModel:DockMargin( H*.02, H*.02, 0, H*.02 )
    DArmorSuitModel:SetWide( H*.4 )
    DArmorSuitModel.Paint = function( s, w, h )
        draw.RoundedBoxEx( 8, 0, 0, w, h, Color( 155, 155, 155, 100 ), true, false, true, false )
        draw.RoundedBoxEx( 8, 1, 1, w-2, h-2, Color( 16, 8, 21, 250 ), true, false, true, false )
    end

    local DModelPanel = vgui.Create( "DModelPanel", DArmorSuitModel )
    DModelPanel:Dock( FILL )
    DModelPanel:DockMargin( 0, -H*.12, 0, 0 )
    DModelPanel:SetModel( p:GetModel() )
    DModelPanel:SetFOV( w/1920 * 31 )
    function DModelPanel:LayoutEntity( e ) end

    local DPanel = vgui.Create( "DPanel", DArmorSuitModel )
    DPanel:Dock( BOTTOM )
    DPanel:SetTall( H*.05 )
    DPanel.Paint = function( s, w, h )
        draw.SimpleText( t.name, "vs.suit.ui.28", w*.5, 0, color_white, TEXT_ALIGN_CENTER, TEXT_ALIGN_TOP )
    end
    // Playermodel //

    local DPanel = vgui.Create( "DPanel", ArmorSuit )
    DPanel:Dock( RIGHT )
    DPanel:DockMargin( 0, H*.02, H*.02, H*.02 )
    DPanel:SetWide( H*.9 )
    DPanel.Paint = function( s, w, h )
        draw.RoundedBoxEx( 8, 0, 0, w, h, Color( 155, 155, 155, 100 ), false, true, false, true )
        draw.RoundedBoxEx( 8, 1, 1, w-2, h-2, Color( 16, 8, 21, 250 ), false, true, false, true )

        local x, y = h*.03, h*.02
        local __, yy = draw.SimpleText( "Health : " .. hp, "vs.suit.ui.22", x, y, color_white, TEXT_ALIGN_LEFT, TEXT_ALIGN_TOP )
        y = y + yy + ( h*.01 )
        local __, yy = draw.SimpleText( "Armor : " .. ap, "vs.suit.ui.22", x, y, color_white, TEXT_ALIGN_LEFT, TEXT_ALIGN_TOP )
        y = y + yy + ( h*.01 )
        local __, yy = draw.SimpleText( "Ability : " .. t.abilitydescription, "vs.suit.ui.22", x, y, color_white, TEXT_ALIGN_LEFT, TEXT_ALIGN_TOP )
        y = y + yy + ( h*.01 )
    end

    local price = ( maxhp - hp ) * t.repair
    local canAfford = p:canAfford( price )
    local DButton = vgui.Create( "DButton", DPanel )
    DButton:Dock( BOTTOM )
    DButton:SetTall( H*.065 )
    DButton:SetText( "" )
    DButton.Paint = function( s, w, h )
        draw.RoundedBoxEx( 8, 0, 0, w, h, Color( 155, 155, 155, 100 ), false, false, false, true )
        if s:IsHovered() then
            draw.RoundedBoxEx( 8, 1, 1, w-2, h-2, Color( 22, 13, 26, 250 ), false, false, false, true )
        else
            draw.RoundedBoxEx( 8, 1, 1, w-2, h-2, Color( 16, 8, 21, 250 ), false, false, false, true )
        end

        if s:IsHovered() then
            if canAfford then
                draw.SimpleText( DarkRP.formatMoney( price ), "vs.suit.ui.28", w*.5, h*.5, Color( 71, 238, 65 ), TEXT_ALIGN_CENTER, TEXT_ALIGN_CENTER )
            else
                draw.SimpleText( DarkRP.formatMoney( price ), "vs.suit.ui.28", w*.5, h*.5, Color( 200, 0, 0 ), TEXT_ALIGN_CENTER, TEXT_ALIGN_CENTER )
            end
        else
            draw.SimpleText( "Repair: " .. t.name, "vs.suit.ui.28", w*.5, h*.5, color_white, TEXT_ALIGN_CENTER, TEXT_ALIGN_CENTER )
        end
    end
    DButton.DoClick = function()
        surface.PlaySound( "buttons/button14.wav" )
        RunConsoleCommand( "vs.suit.repair" )
    end

    DFrame:ShowCloseButton( false )
end )