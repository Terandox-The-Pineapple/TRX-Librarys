local class = {}

function class:new(value)
    value = value or {}
    local new_class = {}
    for cindex, cdata in pairs(self) do
        if type(cdata) == "table" then
            new_class[cindex] = self:t_rebuild(cdata)
        else
            new_class[cindex] = cdata
        end
    end
    for vindex, vdata in pairs(value) do
        if type(vdata) == "table" then
            new_class[vindex] = self:t_rebuild(vdata)
        else
            new_class[vindex] = vdata
        end
    end
    return new_class
end

function class:destroy()
    self = nil
end

function class:t_rebuild(my_table)
    my_table = my_table or {}
    local new_table = {}
    for index, data in pairs(my_table) do
        if type(data) == "table" then
            new_table[index] = self:t_rebuild(data)
        else
            new_table[index] = data
        end
    end
    return new_table
end

return { class = class }
