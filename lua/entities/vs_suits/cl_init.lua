include( "shared.lua" )

local gradientUp = Material( "gui/gradient_up" )
local gradientDown = Material( "gui/gradient_down" )
function ENT:Draw()
	self:DrawModel()

	local k = self:GetSuitVars( "suitkey" ) or false
	local t = GetSuitData( k )
	local p = LocalPlayer()
	if !k then return end

	if p:GetPos():Distance( self:GetPos() ) > 250 then return end

	local pos = self:GetPos() + Vector( 0, 0, self:OBBMaxs().z ) + Vector(0,0,math.sin(CurTime()*1+self:EntIndex()))
	local ang = p:EyeAngles()

	ang:RotateAroundAxis( ang:Right(), 90 )
	ang:RotateAroundAxis( ang:Up(), -90 )
	pos = pos + Vector( 0, 0, 16 )

	cam.Start3D2D( pos, ang, 0.1 )
		draw.RoundedBox( 0, -200, 0, 400, 90, Color( 0, 0, 0, 155 ) )
		surface.SetDrawColor( 210, 39, 76 )
		surface.SetMaterial( gradientDown )
		surface.DrawTexturedRect( -200, 0, 400, 10 )
		surface.SetDrawColor( 210, 39, 76 )
		surface.SetMaterial( gradientUp )
		surface.DrawTexturedRect( -200, 80, 400, 10 )
		draw.SimpleText( t.name or "Armor Suit", "vs.suit.uib.50", 0, 45, color_white, TEXT_ALIGN_CENTER, TEXT_ALIGN_CENTER )
	cam.End3D2D()
end