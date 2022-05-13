if fs.exists("class") == false then shell.run("wget https://raw.githubusercontent.com/Terandox-The-Pineapple/TRX-Librarys/main/class.lua class") end
local class_lib = require("class")
if fs.exists("table-utils") == false then shell.run("wget https://raw.githubusercontent.com/Terandox-The-Pineapple/TRX-Librarys/main/table-utils.lua table-utils") end
local table_utils = require("table-utils")

local players = {}
local enemys = {}
local others = {}
local backgrounds = {}
backgrounds.backgroundlist = {}
backgrounds.selected = 1
local menus = {}
menus.menulist = {}
menus.selected = 1
local controllers = {}
local render = {}

for x = 1, 51, 1 do
    if render[x] == nil then render[x] = {} end
    for y = 1, 19, 1 do
        if render[x][y] == nil then render[x][y] = {} end
        render[x][y].color = false
        render[x][y].text = false
    end
end

local entity = { posX = 1, posY = 1, render = table_utils.rebuild(render) }

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
    local sizeX, sizeY = self:getSize()
    for x = 1, sizeX, 1 do
        for y = 1, sizeY, 1 do
            if self.render[x][y].color ~= false or self.render[x][y].text ~= false then
                term.setCursorPos(x + (self.posX - 1), y + (self.posY - 1))
                if self.render[x][y].color ~= false then
                    term.setBackgroundColor(self.render[x][y].color)
                else
                    term.setBackgroundColor(backgrounds.backgroundlist[backgrounds.selected].render[x + (self.posX - 1)][y + (self.posY - 1)].color)
                end
                if self.render[x][y].text ~= false then
                    term.write(self.render[x][y].text)
                else
                    term.write(" ")
                end
            end
        end
    end
end

function entity:undraw()
    local sizeX, sizeY = self:getSize()
    for x = 1, sizeX, 1 do
        for y = 1, sizeY, 1 do
            if self.render[x][y].color ~= false or self.render[x][y].text ~= false then
                term.setCursorPos(x + (self.posX - 1), y + (self.posY - 1))
                term.setBackgroundColor(backgrounds.backgroundlist[backgrounds.selected].render[x + (self.posX - 1)][y + (self.posY - 1)].color)
                term.write(" ")
            end
        end
    end
end

function entity:kill()
    self:undraw()
    table_utils.removeItem(self.parent, self)
    self:destroy()
end

function entity:collision(target)
    local lastX, lastY = self:getLastPosition()
    local tLastX, tLastY = target:getLastPosition()
    local sizeX, sizeY = self:getSize()
    local tSizeX, tSizeY = target:getSize()
    for x = self.posX, lastX, 1 do
        for y = self.posY, lastY, 1 do
            for tx = target.posX, tLastX, 1 do
                for ty = target.posY, tLastY, 1 do
                    if x == tx and y == ty and (self.render[x - (self.posX - 1)][y - (self.posY - 1)].color ~= false or self.render[x - (self.posX - 1)][y - (self.posY - 1)].text ~= false) and (target.render[tx - (target.posX - 1)][ty - (target.posY - 1)].color ~= false or target.render[tx - (target.posX - 1)][ty - (target.posY - 1)].text ~= false) then
                        return true
                    end
                end
            end
        end
    end
end

entity = class_lib.class:new(entity)

local background = { render = table_utils.rebuild(render) }

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

background = class_lib.class:new(background)

local menu = { selection = {}, selected = 1 }

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

menu = class_lib.class:new(menu)

local controller = { finished = false, keys = {} }

function controller:start(p_func)
    self.finished = false
    while self.finished == false do
        parallel.waitForAny(function() self:get_key() end, p_func)
    end
end

function controller:get_key()
    while self.finished == false do
        local _, key = os.pullEvent("key")
        for index, data in pairs(self.keys) do
            if data.key == key then
                data.func()
            end
        end
    end
end

function controller:stop()
    self.finished = true
end

controller = class_lib.class:new(controller)

function add_player(posX, posY, name)
    players[name] = entity:new({ posX = posX, posY = posY, parent = players })
    return players[name]
end

function add_enemy(posX, posY, name)
    enemys[name] = entity:new({ posX = posX, posY = posY, parent = enemys })
    return enemys[name]
end

function add_other(posX, posY, name)
    others[name] = entity:new({ posX = posX, posY = posY, parent = others })
    return others[name]
end

function add_background(name)
    backgrounds.backgroundlist[name] = background:new()
    return backgrounds.backgroundlist[name]
end

function add_menu(name)
    menus.menulist[name] = menu:new()
    return menus.menulist[name]
end

function add_menu_point(target, text, color)
    local n_render = class_lib.class:t_rebuild(render)
    local index = table_utils.getIndex(menus.menulist, target)
    n_render[1][1].text = text
    if color ~= nil then
        n_render[1][1].color = color
    end
    menus.menulist[index].selection[#menus.menulist[index].selection + 1] = n_render
    return menus.menulist[index].selection[#menus.menulist[index].selection]
end

function change_background(target)
    local index = table_utils.getIndex(backgrounds.backgroundlist, target)
    backgrounds.selected = index
    backgrounds.backgroundlist[index]:draw()
end

function change_menu(target, posX, posY)
    local index = table_utils.getIndex(menus.menulist, target)
    menus.selected = index
    menus.menulist[index]:draw(posX, posY)
end

function add_controller(name)
    controllers[name] = controller:new()
    return controllers[name]
end

function add_controller_key(target, name, key, func)
    local index = table_utils.getIndex(controllers, target)
    controllers[index].keys[name] = { key = key, func = func }
    return controllers[index].keys[name]
end

return { add_player = add_player, add_enemy = add_enemy, add_other = add_other, add_background = add_background, add_menu = add_menu, add_menu_point = add_menu_point, change_background = change_background, change_menu = change_menu, add_controller = add_controller, add_controller_key = add_controller_key, players = players, enemys = enemys, others = others, backgrounds = backgrounds, menus = menus, controllers = controllers }
