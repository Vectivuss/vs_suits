local p = LocalPlayer()

/* This is a place to where you can put CL code for your armor suits Abilities */

// bhop suit //
hook.Add( "StartCommand", "auto.jump", function( p, c )
    if !p:GetNWBool( "QBhopSuit", false ) then return end
	if bit.band( c:GetButtons(), IN_JUMP ) ~= 0 then
		if not p:IsOnGround() then
			c:SetButtons( bit.band( c:GetButtons(), bit.bnot( IN_JUMP ) ) )
		end
	end
end )
// bhop suit //