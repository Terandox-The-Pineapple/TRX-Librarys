local class = {}

function class:new(value, classes)
    local obj = {}
    value = value or {}
    classes = classes or {}
    for index, data in pairs(self) do
        obj[index] = data
    end
    for index2, data2 in pairs(value) do
        obj[index2] = data2
    end
    for index3, data3 in pairs(classes) do
        if type(data3) == "function" then
            obj[index3] = data3()
        end
    end
    obj.parent = self
    return obj
end

function class:destroy()
    self = nil
end

return { class = class }