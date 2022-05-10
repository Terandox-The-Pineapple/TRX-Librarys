local class = {}

function class:new(value)
    local obj = {}
    value = value or {}
    for index, data in pairs(self) do
        obj[index] = data
    end
    for index2, data2 in pairs(value) do
        obj[index2] = data2
    end
    obj.parent = self
    return obj
end

function class:destroy()
    self = nil
end

return { class = class }