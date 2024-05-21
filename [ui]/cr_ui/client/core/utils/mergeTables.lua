---@param baseTable table
---@param targetTable table
function mergeTables(baseTable, targetTable)
    ---@type table
    local result = {}

    for key, value in pairs(baseTable) do
        if not targetTable[key] then
            if targetTable[key] == false then
                result[key] = false
            else
                result[key] = value
            end
        else
            result[key] = targetTable[key]
        end
    end

    return result
end