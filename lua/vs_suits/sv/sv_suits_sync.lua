util.AddNetworkString( "vs.suit.sync" )

local function ShieldSystem_SyncData()
	local t = {}
	for k, v in pairs( GetAllSuitData() ) do
		for kk, vv in pairs( v ) do
			t[k] = t[k] or {}
			t[k][kk] = TypeID(vv) != TYPE_FUNCTION and vv or nil
		end
	end
	return t
end

function SuitSystem_Sync( p )
	if !IsValid( p ) then return end
	net.Start( "vs.suit.sync" )
		net.WriteTable( ShieldSystem_SyncData() )
	net.Send( p )
end
concommand.Add( "vs.suit.sync", function( p ) SuitSystem_Sync( p ) end )

function _SuitSystem_SyncAll()
	for _, p in pairs( player.GetAll() ) do
        if !IsValid( p ) then continue end
		SuitSystem_Sync( p )
	end
end