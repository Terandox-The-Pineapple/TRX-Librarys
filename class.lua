local class = {}

function class:_init(value)
    local obj = value
    for index, data in pairs(self) do
        obj[index] = data
    end
    obj.parent = self
    return obj
end

function class:destroy()
    self = nil
end

return { class = class }