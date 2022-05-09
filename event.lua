local events = {}

function add(name)
    if events[name] == nil then
        events[name] = {
        }
    else
        return false, "This event already exists."
    end
end

function addHandler(event, func)
    if events[event] == nil then
        events[event] = {}
        --   return true,"Event did not yet exist, event was added"
    end
    events[event][#events[event] + 1] = {
        ["func"] = func,
    }
end

function removeHandler(event, func)
    if events[event] == nil then
        return false, "There is no such event"
    end
    for id, data in pairs(events[event]) do
        if data.func == func then
            events[event][id] = nil
            return true, "Event handler succesfully removed"
        end
    end
    return false, ("No handlers for that function")
end

function remove(event)
    if events[event] == nil then
        return false, "No such event exists."
    end
    events[evenf] = nil
    return true, "Event (and it's handlers) succesfully removed"
end

function trigger(event, ...)
    if events[event] == nil then
        return false, "No such event exists"
    end
    for id, data in pairs(events[event]) do
        data.func(...)
    end
end

local computerCraft = {
    "char", "key", "key_up", "paste", "timer", "alarm", "task_complete", "redstone", "terminate", "disk", "disk_eject", "peripheral", "peripheral_detach", "rednet_message", "modem_message", "http_success", "http_failure", "mouse_click", "mouse_up", "mouse_scroll", "mouse_drag", "monitor_touch", "monitor_resize", "term_resize", "turtle_inventory"
}

function setupComputercraftEvents()
    for _, event in ipairs(computerCraft) do
        add(event)
    end
end

setupComputercraftEvents()

function handleCCEvents(timeOut)
    if timeOut ~= nil then
        os.startTimer(timeOut)
    end
    local event, a1, a2, a3, a4, a5 = os.pullEvent()
    trigger(event, a1, a2, a3, a4, a5)
end

return { add = add, addHandler = addHandler, removeHandler = removeHandler, remove = remove, trigger = trigger, setupComputercraftEvents = setupComputercraftEvents, handleCCEvents = handleCCEvents }
