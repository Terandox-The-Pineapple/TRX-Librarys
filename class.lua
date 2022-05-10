local class = {}

function class:new(value, generate)
    local obj = {}
    local gen = self.generate or {}
    generate = generate or {}
    value = value or {}
    classes = classes or {}
    for index, data in pairs(self) do
        obj[index] = data
    end
    for index2, data2 in pairs(value) do
        obj[index2] = data2
    end
    for index3, data3 in pairs(generate) do
        if type(data3) == "function" then
            gen[index3] = data3
        end
    end
    for genindex, gendata in pairs(gen) do
        obj[genindex] = gendata()
    end
    obj.generate = gen
    obj.parent = self
    return obj
end

function class:destroy()
    self = nil
end

return { class = class }