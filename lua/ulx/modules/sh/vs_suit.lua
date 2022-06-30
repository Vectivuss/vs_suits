if ( !istable( ULib ) ) then return end

local CATEGORY_NAME = "Armor Suits"

--[[
	Give Player Suit
]]
function ulx.givesuit( calling_ply, target_plys, suit )
	for i=1, #target_plys do
		local target = target_plys[ i ]
		local t = GetSuitData( suit )
		if !t then return end
		if table.IsEmpty( t ) then 
			ULib.tsayError( calling_ply, suit .. " isn't a real suit.", true )
			return 
		end
		if SERVER then RunConsoleCommand( "vs.suit.givesuit", target:SteamID64(), suit ) end
	end

	ulx.fancyLogAdmin( calling_ply, "#A gave #T a(n) #s suit.", target_plys, suit )
end

local givesuit = ulx.command( CATEGORY_NAME, "ulx givesuit", ulx.givesuit, "!givesuit" )
givesuit:addParam{ type=ULib.cmds.PlayersArg }
givesuit:addParam{ type=ULib.cmds.StringArg, hint="Suit Key", ULib.cmds.takeRestOfLine }
givesuit:defaultAccess( ULib.ACCESS_SUPERADMIN )
givesuit:help( "This will set the player suit" )

--[[
	Get Player Suit
]]
function ulx.hassuit( calling_ply, target_plys )
	local suit
	for i=1, #target_plys do
		local target = target_plys[ i ]
		suit = target:GetSuitTable()["name"]

		if !target:HasActiveSuit() then
			ULib.tsayError( calling_ply, target:Name() .. " doesn't have a(n) armor suit.", true )
			return
		end
	end
	ulx.fancyLogAdmin( calling_ply, "#T has a(n) #s.", target_plys, suit )
end

local hassuit = ulx.command( CATEGORY_NAME, "ulx hassuit", ulx.hassuit, "!hassuit" )
hassuit:addParam{ type=ULib.cmds.PlayersArg }
hassuit:defaultAccess( ULib.ACCESS_ADMIN )
hassuit:help( "This will tell you if the player(s) has a suit." )