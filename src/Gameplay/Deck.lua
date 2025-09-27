-- simple deck helper
local Deck = {}
Deck.__index = Deck

function Deck.new(list)
    local d = setmetatable({}, Deck)
    d.cards = {}
    for i=1,#list do table.insert(d.cards, list[i]) end
    d.discard = {}
    return d
end

local function shuffle(t)
    for i = #t, 2, -1 do
        local j = math.random(i)
        t[i], t[j] = t[j], t[i]
    end
end

function Deck:shuffle() shuffle(self.cards) end

function Deck:draw()
    if #self.cards == 0 then
        for i=1,#self.discard do table.insert(self.cards, self.discard[i]) end
        self.discard = {}
        shuffle(self.cards)
    end
    return table.remove(self.cards)
end

function Deck:discardCard(card) table.insert(self.discard, card) end

return Deck
