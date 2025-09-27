-- tiny event bus used by game systems and cards
local EventBus = {}
EventBus.__index = EventBus

function EventBus.new()
    local e = setmetatable({}, EventBus)
    e.listeners = {}
    return e
end

function EventBus:on(event, fn)
    self.listeners[event] = self.listeners[event] or {}
    table.insert(self.listeners[event], fn)
    return fn
end

function EventBus:off(event, fn)
    local t = self.listeners[event]
    if not t then return end
    for i = #t, 1, -1 do
        if t[i] == fn then table.remove(t, i) end
    end
end

function EventBus:emit(event, ...)
    local t = self.listeners[event]
    if not t then return end
    for _,fn in ipairs(t) do
        local ok, err = pcall(fn, ...)
        if not ok then print("EventBus error:", err) end
    end
end

return EventBus
