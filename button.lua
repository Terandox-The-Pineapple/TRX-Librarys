local idleColor = 256
local activatedColor = 8192
local backgroundColor = 32768
local textColor = 1
local buttons = {}
local monitor = nil
local debugMode = false
local monitorSide = nil

if fs.exists("event") == false then shell.run("wget https://raw.githubusercontent.com/Terandox-The-Pineapple/TRX-Librarys/main/event.lua event") end
local event = require "event"

function addButton(x, y, width, height, text, toggle, relative, idleColor, activeColor, textColor)
    if monitor == nil then
        if debugMode == true then
            print("Monitor is not yet defined! Use setMonitorSide(side)")
        end
        return false, "Monitor is not yet defined! Use setMonitorSide(side)"
    elseif x == nil or y == nil or width == nil or height == nil or text == nil then
        if debugMode == true then
            print("Not all required arguments are specified.")
        end
        return false, "Not all required arguments are specified."
    else
        buttonID = #buttons + 1
        if string.len(text) > width and relative ~= true then
            text = string.sub(text, 0, width)
        elseif string.len(text) > width * screenx then
            text = string.sub(text, 0, width * screenx)
        end
        buttons[buttonID] = { ['x'] = x, ['y'] = y, ['width'] = width, ['height'] = height, ['text'] = text, ['active'] = false, ['toggle'] = toggle, ['relative'] = relative, ['activeColor'] = activeColor, ['idleColor'] = idleColor, ['textColor'] = textColor, ['visible'] = true }
        drawAllButtons {}
        return buttonID
    end
end

function removeAllButtons()
    buttons = {}
    drawAllButtons()
end

function removeButton(buttonID)
    if monitor == nil then
        if debugMode == true then
            print("Monitor is not yet defined! Use setMonitorSide(side)")
        end
        return false, "Monitor is not yet defined! Use setMonitorSide(side)"
    else
        if buttonID == nil then
            if debugMode == true then
                print("Not all required arguments are specified.")
            end
            return false, "Not all required arguments are specified."
        else
            if buttons[buttonID] == nil then
                if debugMode == true then
                    print("That button ID does not correspond with a button!")
                end
                return false, "That button ID does not correspond with a button!"
            else
                buttons[buttonID] = { "Removed" }
            end
        end
    end
end

function drawAllButtons(tEvent)
    if monitor == nil then
        if debugMode == true then
            print("Monitor is not yet defined! Use setMonitorSide(side)")
        end
        return false, "Monitor is not yet defined! Use setMonitorSide(side)"
    else
        monitor.setBackgroundColor(backgroundColor)
        monitor.clear()
        for buttonID, buttonInfo in pairs(buttons) do
            if buttonInfo['visible'] == true then
                local x = buttonInfo['x']
                local y = buttonInfo['y']
                local width = buttonInfo['width']
                local height = buttonInfo['height']
                if buttonInfo['relative'] == true then
                    x = math.floor(x * screenx + 0.5)
                    y = math.floor(y * screeny + 0.5)
                    width = math.floor(width * screenx + 0.5)
                    height = math.floor(height * screeny + 0.5)
                end
                monitor.setCursorPos(x, y)
                if buttonInfo['active'] == true then
                    if buttonInfo['activeColor'] == nil then
                        monitor.setBackgroundColor(activatedColor)
                    else
                        monitor.setBackgroundColor(buttonInfo['activeColor'])
                    end
                else
                    if buttonInfo['idleColor'] == nil then
                        monitor.setBackgroundColor(idleColor)
                    else
                        monitor.setBackgroundColor(buttonInfo['idleColor'])
                    end
                end
                for i = 0, height - 1 do
                    monitor.setCursorPos(x, y + i)
                    for i = 1, width do
                        monitor.write(" ")
                    end
                end
                if buttonInfo['textColor'] == nil then
                    monitor.setTextColor(textColor)
                else
                    monitor.setTextColor(buttonInfo['textColor'])
                end
                stringX = x + (width / 2 - string.len(buttonInfo['text']) / 2)
                stringY = y + (math.floor(height) / 2)
                monitor.setCursorPos(stringX, stringY)
                monitor.write(buttonInfo['text'])
            end
        end
    end
    if tEvent == true then return end
    event.trigger("onButtonsDrawn", true)
end

function getButtonInfo(buttonID)
    if monitor == nil then
        if debugMode == true then
            print("Monitor is not yet defined! Use setMonitorSide(side)")
        end
        return false, "Monitor is not yet defined! Use setMonitorSide(side)"
    else
        if buttonID == nil then
            if debugMode == true then
                print("Not all required arguments are specified.")
            end
            return false, "Not all required arguments are specified."
        else
            if buttons[buttonID] == nil then
                if debugMode == true then
                    print("That button ID does not correspond with a button!")
                end
                return false, "That button ID does not correspond with a button!"
            else
                if debugMode == true then
                    for infoID, info in pairs(buttons[buttonID]) do
                        if type(info) == "boolean" then
                            if info == false then
                                info = "false"
                            else
                                info = "true"
                            end
                        elseif type(info) == "function" then
                            info = "function"
                        end
                        print(infoID .. "	:" .. info)

                    end
                end
                return buttons[buttonID]
            end
        end
    end
end

function setButtonInfo(buttonID, infoID, info)
    if monitor == nil then
        if debugMode == true then
            print("Monitor is not yet defined! Use setMonitorSide(side)")
        end
        return false, "Monitor is not yet defined! Use setMonitorSide(side)"
    else
        if buttonID == nil then
            if debugMode == true then
                print("Not all required arguments are specified.")
            end
            return false, "Not all required arguments are specified."
        else
            if buttons[buttonID] == nil then
                if debugMode == true then
                    print("That button ID does not correspond with a button!")
                end
                return false, "That button ID does not correspond with a button!"
            else
                buttons[buttonID][infoID] = info
            end
        end
    end
end

function setVisible(buttonID, bool)
    if monitor == nil then
        if debugMode == true then
            print("Monitor is not yet defined! Use setMonitorSide(side)")
        end
        return false, "Monitor is not yet defined! Use setMonitorSide(side)"
    else
        if buttonID == nil then
            if debugMode == true then
                print("Not all required arguments are specified.")
            end
            return false, "Not all required arguments are specified."
        else
            if buttons[buttonID] == nil then
                if debugMode == true then
                    print("That button ID does not correspond with a button!")
                end
                return false, "That button ID does not correspond with a button!"
            else
                buttons[buttonID]['visible'] = bool
            end
        end
    end
    --drawAllButtons()
end

function run(side, clickX, clickY)
    for buttonID, buttonInfo in pairs(buttons) do
        local x = buttonInfo['x']
        local y = buttonInfo['y']
        local width = buttonInfo['width']
        local height = buttonInfo['height']
        if buttonInfo['relative'] == true then
            x = math.floor(x * screenx + 0.5)
            y = math.floor(y * screeny + 0.5)
            width = math.floor(width * screenx + 0.5)
            height = math.floor(height * screeny + 0.5)
        end
        if debugMode == true then
            print("Pos:" .. x .. "," .. y)
        end
        if clickX >= x and clickX <= x + width and clickY >= y and clickY <= y + height and buttonInfo['visible'] == true then
            if debugMode == true then
                print("Clicked :" .. buttonID)
            end
            if buttonInfo['toggle'] == true then
                buttonInfo['active'] = not buttonInfo['active']
                drawAllButtons()
                if buttonInfo['active'] == true then
                    event.trigger("onButtonClick", buttonID, true)
                else
                    event.trigger("onButtonClick", buttonID, false)
                end
            else
                buttonInfo['active'] = true
                drawAllButtons()
                event.trigger("onButtonClick", buttonID)
                sleep(0)
                if buttonInfo ~= nil then
                    buttonInfo['active'] = false
                end
                drawAllButtons()
            end

        end
    end
end

event.addHandler("monitor_touch", run)
event.addHandler("mouse_click", run)

function resised(side)
    if side == monitorSide then
        setMonitorSide(side)
        drawAllButtons()
    end
end

event.addHandler("monitor_resize", resised)

--[[
function updateButtonPositions()
	for buttonID,buttonInfo in pairs(buttons) do
		if buttonInfo['relative']==true then
			x=
			y=
			width=
			height=
			x=math.floor(x*screenx+0.5)
			y=math.floor(y*screeny+0.5)
			width=math.floor(width*screenx+0.5)
			height=math.floor(height*screeny+0.5)
		end		
	end
end
]]

function setMonitorSide(side)
    if side == nil then
        if debugMode == true then
            print("Not all required arguments are specified.")
        end
        return false, "Not all required arguments are specified."
    else
        monitor = peripheral.wrap(side)
        screenx, screeny = monitor.getSize()
        monitorSide = side
    end
end

function setMonitor(peripheral)
    if peripheral == nil then
        if debugMode == true then
            print("Not all required arguments are specified.")
        end
        return false, "Not all required arguments are specified."
    else
        monitor = peripheral
        screenx, screeny = monitor.getSize()
        monitorSide = peripheral
    end
end

function setDebugMode(bool)
    if bool == nil then
        if debugMode == true then
            print("Not all required arguments are specified.")
        end
        return false, "Not all required arguments are specified."
    else
        debugMode = bool
    end
end

function setIdleColor(color)
    if color == nil then
        if debugMode == true then
            print("Not all required arguments are specified.")
        end
        return false, "Not all required arguments are specified."
    else
        idleColor = color
        drawAllButtons()
    end
end

function setActiveColor(color)
    if color == nil then
        if debugMode == true then
            print("Not all required arguments are specified.")
        end
        return false, "Not all required arguments are specified."
    else
        activatedColor = color
        drawAllButtons()
    end
end

function setBackgroundColor(color)
    if color == nil then
        if debugMode == true then
            print("Not all required arguments are specified.")
        end
        return false, "Not all required arguments are specified."
    else
        backgroundColor = color
        drawAllButtons()
    end
end

function setTextColor(color)
    if color == nil then
        if debugMode == true then
            print("Not all required arguments are specified.")
        end
        return false, "Not all required arguments are specified."
    else
        textColor = color
        drawAllButtons()
    end
end

return { addButton = addButton, removeAllButtons = removeAllButtons, removeButton = removeButton, drawAllButtons = drawAllButtons, getButtonInfo = getButtonInfo, setButtonInfo = setButtonInfo, setVisible = setVisible, run = run, resised = resised, setMonitorSide = setMonitorSide, setMonitor = setMonitor, setDebugMode = setDebugMode, setIdleColor = setIdleColor, setActiveColor = setActiveColor, setBackgroundColor = setBackgroundColor, setTextColor = setTextColor }
