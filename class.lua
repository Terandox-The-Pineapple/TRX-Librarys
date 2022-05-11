local class = {}

function class:new(value)
    local new_self = value
    setmetatable(new_self, { _index = self })
    return new_self
end

function class:destroy()
    self = nil
end

return { class = class }
