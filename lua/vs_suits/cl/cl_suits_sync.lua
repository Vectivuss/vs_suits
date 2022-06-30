VectivusSuits = VectivusSuits or {}
VectivusSuits.suit = VectivusSuits.suit or {}
timer.Simple( 0, function() RunConsoleCommand( "vs.suit.sync" ) end )
net.Receive( "vs.suit.sync", function() VectivusSuits.suit = net.ReadTable() end )