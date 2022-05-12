function getIndex(table, item)
    for index, value in pairs(table) do
        if item == value then
            return index
        end
    end
    return false
end

function removeItem(r_table, item)
    local index = getIndex(r_table, item)
    if index ~= false then return table.remove(r_table, index)
    else return false end
end

function rebuild(my_table)
    my_table = my_table or {}
    local new_table = {}
    for index, data in pairs(my_table) do
        if type(data) == "table" then
            new_table[index] = rebuild(data)
        else
            new_table[index] = data
        end
    end
    return new_table
end

return { getIndex = getIndex, removeItem = removeItem, rebuild = rebuild }
