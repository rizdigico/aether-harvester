--!strict
-- Pure personal-base placement rules shared by the server and tests.

local BaseRules = {}

BaseRules.GRID_SIZE = 4
BaseRules.MIN_COORDINATE = -7
BaseRules.MAX_COORDINATE = 7
BaseRules.MAX_DECORATIONS = 30

function BaseRules.IsValidCoordinate(value: any): boolean
    return type(value) == "number"
        and value == value
        and value >= BaseRules.MIN_COORDINATE
        and value <= BaseRules.MAX_COORDINATE
        and value == math.floor(value)
end

function BaseRules.IsValidRotation(value: any): boolean
    return type(value) == "number"
        and value == value
        and value >= 0
        and value <= 270
        and value == math.floor(value)
        and value % 90 == 0
end

function BaseRules.CanPlace(decorationCount: any): boolean
    return type(decorationCount) == "number"
        and decorationCount == decorationCount
        and decorationCount >= 0
        and decorationCount < BaseRules.MAX_DECORATIONS
        and decorationCount == math.floor(decorationCount)
end

return BaseRules
