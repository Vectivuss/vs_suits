if SAM_LOADED then return end
local sam, command, language = sam, sam.command, sam.language

command.set_category( "Armor Suits" )

--[[
	Give Player Suit
]]
command.new( "givesuit" )
	:SetPermission( "givesuit", "superadmin" )
	:AddArg( "player" )
    :AddArg( "text", { hint = "Suit Key", default = "" } )
	:Help( "This will set the player suit" )
	
	:OnExecute(function(ply, targets, suit )
		local target = targets[1]
		local t = GetSuitData( suit )
		if !t then return end
		if table.IsEmpty( t ) then 
			sam.player.send_message(ply, "{V} isn't a real suit.", {V=suit})
			return 
		end
		if SERVER then RunConsoleCommand( "vs.suit.givesuit", target:SteamID64(), suit ) end

		if sam.is_command_silent then return end
		sam.player.send_message(nil, "{A} gave {T} a(n) {V} suit.", {
			A = ply, T = targets, V = suit
		})
	end)
:End()

command.new( "hassuit" )
	:SetPermission( "hassuit", "admin" )
	:AddArg( "player" )
	:Help( "This will tell you if the player(s) has a suit." )
	
	:OnExecute(function(ply, targets)
		local target = targets[1]

		if !ply:HasActiveSuit() then
			sam.player.send_message(ply, "{T} doesn't have a(n) armor suit.", {T=targets})
			return
		end

		local suit = ply:GetSuitTable().name
		if sam.is_command_silent then return end
		sam.player.send_message(ply, "{T} has a(n) {V}.", {
			A = ply, T = targets, V = suit
		})
	end)
:End()