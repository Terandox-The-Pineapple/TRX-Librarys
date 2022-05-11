function new(value)
    local class = value or {}

    function class.new(my_value)
        local self = my_value or {}
        setmetatable(self, { _index = class })
        return self
    end

    function class:destroy()
        self = nil
    end

    return class
end

return { new = new }
