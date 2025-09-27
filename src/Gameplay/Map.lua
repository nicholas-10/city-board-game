-- Map with N slots
Map = Class{}

function Map:init(slotCount)
    self.slotCount = slotCount or 6
    self.slots = {}
    for i=1,self.slotCount do self.slots[i] = nil end
end

function Map:isEmpty(i) return self.slots[i] == nil end

function Map:placeBlueprint(slotIndex, blueprint, owner)
    if not self:isEmpty(slotIndex) then return false end
    local inst = { blueprint = blueprint, owner = owner, level = 1 }
    self.slots[slotIndex] = inst
    table.insert(owner.blueprints, inst)
    return true
end

function Map:draw(x,y,w,h)
    local cols = math.min(3, self.slotCount)
    local rows = math.ceil(self.slotCount / cols)
    local sw = (w - 8) / cols
    local sh = (h - 8) / rows
    love.graphics.setColor(0.98,0.98,0.98)
    for i=1,self.slotCount do
        local col = ((i-1) % cols)
        local row = math.floor((i-1)/cols)
        local sx = x + col * sw
        local sy = y + row * sh
        love.graphics.setColor(0.9,0.9,0.95)
        love.graphics.rectangle("fill", sx+4, sy+4, sw-8, sh-8)
        love.graphics.setColor(0,0,0)
        if self.slots[i] then
            local inst = self.slots[i]
            love.graphics.print(inst.blueprint.name .. " L"..inst.level, sx+10, sy+10)
            love.graphics.print("Owner: "..inst.owner.name, sx+10, sy+28)
        else
            love.graphics.print("Empty slot "..i, sx+10, sy+10)
        end
    end
    love.graphics.setColor(1,1,1)
end

function Map:slotAtPosition(mx,my, x,y,w,h)
    local cols = math.min(3, self.slotCount)
    local rows = math.ceil(self.slotCount / cols)
    local sw = (w - 8) / cols
    local sh = (h - 8) / rows
    for i=1,self.slotCount do
        local col = ((i-1) % cols)
        local row = math.floor((i-1)/cols)
        local sx = x + col * sw
        local sy = y + row * sh
        if mx > sx+4 and mx < sx+4 + sw-8 and my > sy+4 and my < sy+4 + sh-8 then
            return i
        end
    end
    return nil
end

return Map
