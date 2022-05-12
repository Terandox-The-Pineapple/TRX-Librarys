if fs.exists("table-utils") == false then shell.run("wget https://raw.githubusercontent.com/Terandox-The-Pineapple/TRX-Librarys/main/table-utils.lua table-utils") end
local table_utils = require("table-utils")

local class = {}

function class:new(value)
    value = value or {}
    local new_class = {}
    for cindex, cdata in pairs(self) do
        if type(cdata) == "table" then
            new_class[cindex] = table_utils.rebuild(cdata)
        else
            new_class[cindex] = cdata
        end
    end
    for vindex, vdata in pairs(value) do
        if type(vdata) == "table" then
            new_class[vindex] = table_utils.rebuild(vdata)
        else
            new_class[vindex] = vdata
        end
    end
    return new_class
end

function class:destroy()
    self = nil
end

return { class = class }
