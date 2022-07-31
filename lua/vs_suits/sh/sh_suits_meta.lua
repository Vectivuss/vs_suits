pMeta = FindMetaTable( "Player" )
eMeta = FindMetaTable( "Entity" )

function pMeta:HasActiveSuit()
    return self:GetNWBool( "QHasActiveSuit", false )
end

function pMeta:HasActiveAbility()
    return self:GetNWBool( "QHasActiveAbility", false )
end

function pMeta:GetAbilityCooldown()
    return self:GetNWBool( "QGetAbilityCooldown", false )
end

function pMeta:GetSuit()
    if !self:HasActiveSuit() then return end
    return self:GetNWString( "QSuitKey", "" )
end

function pMeta:GetSuitTable()
    if !self:HasActiveSuit() then return end
    local k = self:GetSuit()
    local t = GetAllSuitData()[k or ""] or {}
    return t
end

function eMeta:GetSuitVars( k )
    if SERVER then
        return self.suitVars or {}
    end
    return self:GetNWString( "QSuitVar." .. tostring( k ), "" )
end

function GetAllSuitData()
    return VectivusSuits.suit or {}
end

function GetSuitData( k )
    local t = GetAllSuitData()
    return t[k or ""] or {}
end