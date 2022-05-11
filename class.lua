function new(value)
    local class = value or {}

    function class:new(my_value)
        local new_self = my_value or {}
        setmetatable(new_self, { _index = self })
        return new_self
    end

    function class:destroy()
        self = nil
    end

    return class
end

return { new = new }
