if SERVER then
    VectivusSuits = VectivusSuits or {}
    VectivusSuits.suit = VectivusSuits.suit or {}
	resource.AddFile( "materials/vs_suits/close.png" )
	resource.AddFile( "resource/fonts/Purista.ttf" )
end

local path = "vs_suits/"
local _, folders = file.Find( path .. "*", "LUA" )

print("///////////////// Vectivus´s Suits - MOUNTING /////////////////\n" )
for _, folder in SortedPairs( folders, true ) do
    // MOUNT SERVER FILES
    for __, f in SortedPairs( file.Find( path .. folder .. "/sv_*.lua", "LUA" ), true ) do
        print( "[	Vectivus´s Suits - Initialize:	]", folder, f )
        timer.Simple( 0, function() include( path .. folder .. "/" .. f ) end )
    end
    // MOUNT SHARED FILES
    for __, f in SortedPairs( file.Find( path .. folder .. "/sh_*.lua", "LUA" ), true ) do
        print( "[	Vectivus´s Suits - Initialize:	]", folder, f )
        if SERVER then AddCSLuaFile( path .. folder .. "/" .. f ) end
        include( path .. folder .. "/" .. f )
    end
    // MOUNT CLIENT FILES
    for __, f in SortedPairs( file.Find( path .. folder .. "/cl_*.lua", "LUA" ), true ) do
        print( "[	Vectivus´s Suits - Initialize:	]", folder, f )
        if SERVER then AddCSLuaFile( path .. folder .. "/" .. f ) end
        if CLIENT then include( path .. folder .. "/" .. f ) end
    end
end
print("\n///////////////// Vectivus´s Suits - MOUNTED! /////////////////" )