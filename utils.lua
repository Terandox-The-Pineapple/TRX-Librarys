function split(sourceString, splittingChar, index)
    results = {}
    currentWord = ""
    for i = 1, string.len(sourceString) do
        letter = string.sub(sourceString, i, i)
        if letter == splittingChar then
            results[#results + 1] = currentWord
            currentWord = ""
        else
            currentWord = currentWord .. letter
        end
    end
    results[#results + 1] = currentWord
    return results[index]
end

function getSplits(sourceString, splittingChar)
    results = {}
    currentWord = ""
    for i = 1, string.len(sourceString) do
        letter = string.sub(sourceString, i, i)
        if letter == splittingChar then
            results[#results + 1] = currentWord
            currentWord = ""
        else
            currentWord = currentWord .. letter
        end
    end
    results[#results + 1] = currentWord
    return results
end

if fs.exists("eventN") == false then shell.run("pastebin get 09wrEpXA eventN") end
local event = require "eventN"

local timers = {}

function setTimer(func, timeOut, count, ...)
    local id = os.startTimer(timeOut)
    timers[id] = { func = func, args = { ... }, timeOut = timeOut, count = count, executed = 0, id = id }
    return id
end

function handleTimers(timer)
    if timers[timer] == nil then return end
    local tableTimer = timers[timer]
    tableTimer.func(table.unpack(table.args or {}))
    tableTimer.executed = tableTimer.executed + 1
    if tableTimer.executed < tableTimer.count or tableTimer.count == 0 then
        timers[os.startTimer(tableTimer.timeOut)] = tableTimer
    end
    timers[timer] = nil
end

event.addHandler("timer", handleTimers)


function killTimer(id)
    for i, timer in pairs(timers) do
        if timer.id == id then
            timers[i] = nil
        end
    end
end

local isReading = false
local readCache = ""
local readPos = { x = 0, y = y }

function read(length)
    isReading = true
    readCache = ""
    event.addHandler("key", handleReadKey)
    event.addHandler("char", handleReadChar)
    event.addHandler("paste", handleReadPaste)
    readPos.x, readPos.y = term.getCursorPos()
    readPos.length = length or term.getSize()
    term.setCursorBlink(true)
    writeReadString()
    while isReading do
        event.handleCCEvents()
    end
    cancelRead()
    return readCache
end

function handleReadKey(key, held)
    if key == keys.backspace then
        readCache = string.sub(readCache, 0, string.len(readCache) - 1)
    elseif key == keys.enter then
        isReading = false
    end
    writeReadString()
end

function handleReadChar(typedLetter)
    readCache = readCache .. typedLetter
    writeReadString()
end

function handleReadPaste(pastedString)
    readCache = readCache .. pastedString
    writeReadString()
end

function getReadString()
    return readCache
end

function writeReadString()
    event.trigger("onReadUpdate", readCache)
    term.setCursorPos(readPos.x, readPos.y)
    term.setBackgroundColor(colors.white)
    term.setTextColor(colors.black)
    local readCache = readCache
    if string.len(readCache) > readPos.length then
        readCache = string.sub(readCache, string.len(readCache) - readPos.length + 1, string.len(readCache) + 1)
    end
    term.write(readCache)
    if string.len(readCache) - 1 < readPos.length then
        local x, y = term.getCursorPos()
        for i = string.len(readCache), readPos.length do
            term.write(" ")
        end
        term.setCursorPos(x, y)
    end
end

function cancelRead()
    isReading = false
    term.setCursorBlink(false)
    event.removeHandler("key", handleReadKey)
    event.removeHandler("char", handleReadChar)
    event.removeHandler("paste", handleReadPaste)
    return readCache
end

return { split = split, getSplits = getSplits, setTimer = setTimer, handleTimers = handleTimers, killTimer = killTimer, read = read, handleReadKey = handleReadKey, handleReadChar = handleReadChar, handleReadPaste = handleReadPaste, getReadString = getReadString, writeReadString = writeReadString, cancelRead = cancelRead }
