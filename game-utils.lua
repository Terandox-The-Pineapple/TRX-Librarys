local players = {}
local enemys = {}
local others = {}
local backgrounds = {}
backgrounds.backgroundlist = {}
backgrounds.selected = 1
local menus = {}
menus.menulist = {}
menus.selected = 1
local render = {}

function render._new(para)
    local self = para or {}
    setmetatable(self, { _index = render })
    return self
end

function render:init()
    for x = 1, 51, 1 do
        if self[x] == nil then self[x] = {} end
        for y = 1, 19, 1 do
            if self[x][y] == nil then self[x][y] = {} end
            self[x][y].color = false
            self[x][y].text = false
        end
    end
end

setmetatable(render, { _call = render._new })

local entity = { posX = 1, posY = 1, render = false }

function entity._new(para)
    local self = para or {}
    setmetatable(self, { _index = entity })
    return self
end

function entity:getSize()
    local sizeX = 0
    local sizeY = 0
    for x = 1, 51, 1 do
        local countY = 0
        for y = 1, 19.1 do
            local countX = 0
            if self.render[x][y].color ~= false or self.render[x][y].text ~= false then countY = countY + 1 end
            for inner_x = 1, 51, 1 do
                if self.render[inner_x][y].color ~= false or self.render[inner_x][y].text ~= false then countX = countX + 1 end
            end
            if countX > sizeX then sizeX = countX end
        end
        if countY > sizeY then sizeY = countY end
    end
    return sizeX, sizeY
end

function entity:moveRight()
    local sizeX, sizeY = self:getSize()
    if self.posX <= (51 - sizeX) then self.posX = self.posX + 1 end
end

function entity:moveLeft()
    if self.posX > 1 then self.posX = self.posX - 1 end
end

function entity:moveUp()
    if self.posY > 1 then self.posY = self.posY - 1 end
end

function entity:moveDown()
    local sizeX, sizeY = self:getSize()
    if self.posY <= (19 - sizeY) then self.posY = self.posY + 1 end
end

function entity:getLastPosition()
    local sizeX, sizeY = self:getSize()
    return self.posX + (sizeX - 1), self.posY + (sizeY - 1)
end

function entity:draw()
    local lastX, lastY = self:getLastPosition()
    local countX = 1
    local countY = 1
    for x = 1, 51, 1 do
        local is_in = false
        for y = 1, 19, 1 do
            if x >= self.posX and x <= lastX and y >= self.posY and y <= lastY then
                term.setCursorPos(x, y)
                if self.render[countX][countY].color ~= false and self.render[countX][countY].text ~= false then
                    term.setBackgroundColor(self.render[countX][countY].color)
                    term.write(self.render[countX][countY].text)
                elseif self.render[countX][countY].text ~= false then
                    term.setBackgroundColor(backgrounds.backgroundlist[backgrounds.selected].render[x][y].color)
                    term.write(self.render[countX][countY].text)
                end
                countY = countY + 1
                is_in = true
            end
        end
        countY = 1
        if x >= self.posX and x <= lastX and is_in then countX = countX + 1 end
    end
end

function entity:kill()
    t_removeItem(self.parent, self)
    self:destroy()
end

function entity:collision(target)
    local lastX, lastY = self:getLastPosition()
    local tLastX, tLastY = target:getLastPosition()
    for x = self.posX, lastX, 1 do
        for y = self.posY, lastY, 1 do
            for tx = target.posX, tLastX, 1 do
                for ty = target.posY, tLastY, 1 do
                    if x == tx and y == ty and (self.render[x][y].color ~= false or self.render[x][y].text ~= false) and (target.render[tx][ty].color ~= false or target.render[tx][ty].text ~= false) then
                        return true
                    end
                end
            end
        end
    end
end

setmetatable(entity, { _call = entity._new })

local background = { render = false }

function background._new(para)
    local self = para or {}
    setmetatable(self, { _index = background })
    return self
end

function background:draw()
    for x = 1, 51, 1 do
        for y = 1, 19, 1 do
            term.setCursorPos(x, y)
            if self.render[x][y].color ~= false then
                term.setBackgroundColor(self.render[x][y].color)
            else
                term.setBackgroundColor(colours.black)
            end
            if self.render[x][y].text ~= false then
                term.write(self.render[x][y].text)
            else
                term.write(" ")
            end
        end
    end
end

setmetatable(background, { _call = background._new })

local menu = { selection = {}, selected = 1 }

function menu._new(para)
    local self = para or {}
    setmetatable(self, { _index = menu })
    return self
end

function menu:draw(posX, posY)
    local my_posY, my_posX = posY, posX
    for index, point in pairs(self.selection) do
        term.setCursorPos(my_posX, my_posY)
        if point[1][1].color ~= false then
            term.setBackgroundColor(point[1][1].color)
        else
            term.setBackgroundColor(backgrounds.backgroundlist[backgrounds.selected].render[my_posX][my_posY].color)
        end
        if index == self.selected then
            term.setTextColor(colours.green)
        end
        if point[1][1].text ~= false then
            term.write(point[1][1].text)
        else
            term.write("Default Text")
        end
        term.setTextColor(colours.black)
        my_posY = my_posY + 2
    end
end

function menu:up()
    if self.selected > 1 then
        self.selected = self.selected - 1
    else
        self.selected = #self.selection
    end
end

function menu:down()
    if self.selected < #self.selection then
        self.selected = self.selected + 1
    else
        self.selected = 1
    end
end

setmetatable(menu, { _call = menu._new })

function t_getIndex(table, item)
    for index, value in pairs(table) do
        if item == value then
            return index
        end
    end
    return false
end

function t_removeIndex(table, index)
    local new_table = {}
    for i, value in pairs(table) do
        if i ~= index then
            if type(i) == "number" then
                new_table[#new_table + 1] = table[i]
            else
                new_table[i] = table[i]
            end
        end
    end
    table = new_table
    return table
end

function t_removeItem(table, item)
    local index = t_getIndex(table, item)
    return t_removeIndex(table, index)
end

function add_player(posX, posY, name)
    players[name] = entity({ posX = posX, posY = posY, render = render() })
    players[name].render:init()
    return players[name]
end

function add_enemy(posX, posY, name)
    enemys[name] = entity({ posX = posX, posY = posY, render = render() })
    enemys[name].render:init()
    return enemys[name]
end

function add_other(posX, posY, name)
    others[name] = entity({ posX = posX, posY = posY, render = render() })
    others[name].render:init()
    return others[name]
end

function add_background(name)
    backgrounds.backgroundlist[name] = background({ render = render() })
    backgrounds.backgroundlist[name].render:init()
    return backgrounds.backgroundlist[name]
end

function add_menu(name)
    menus.menulist[name] = menu()
    return menus.menulist[name]
end

function add_menu_point(target, text, color)
    local n_render = render()
    n_render:init()
    local index = t_getIndex(menus.menulist, target)
    n_render[1][1].text = text
    if color ~= nil then
        n_render[1][1].color = color
    end
    menus.menulist[index].selection[#menus.menulist[index].selection + 1] = n_render
    return menus.menulist[index].selection[#menus.menulist[index].selection]
end

function change_background(target)
    local index = t_getIndex(backgrounds.backgroundlist, target)
    backgrounds.selected = index
    backgrounds.backgroundlist[index]:draw()
end

function change_menu(target, posX, posY)
    local index = t_getIndex(menus.menulist, target)
    menus.selected = index
    menus.menulist[index]:draw(posX, posY)
end

return { t_getIndex = t_getIndex, t_removeIndex = t_removeIndex, t_removeItem = t_removeItem, add_player = add_player, add_enemy = add_enemy, add_other = add_other, add_background = add_background, add_menu = add_menu, add_menu_point = add_menu_point, change_background = change_background, change_menu = change_menu }
