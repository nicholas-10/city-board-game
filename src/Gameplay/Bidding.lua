-- Simple closed-bid implementation: players enter hidden bids, reveal, highest pays and gets blueprint, top 3 get turfs in order.
Bidding = Class{}

function Bidding:init(game)
    self.game = game
    self.active = false
    self.bids = {}
    self.targets = {}
end

function Bidding:startRoundBidding()
    if self.active then return end
    self.active = true
    self.bids = {}
    -- pick 1 blueprint and 3 turfs
    self.targets.blueprint = self.game.blueprintDeck:draw()
    self.targets.turfs = { self.game.turfDeck:draw(), self.game.turfDeck:draw(), self.game.turfDeck:draw() }
    print("[Bidding] blueprint:", (self.targets.blueprint and self.targets.blueprint.name) or "none")
    -- initialize bids to 0
    for i=1,#self.game.players do self.bids[i] = 0 end
end

-- set bid for a player (prototype uses numeric increment UI)
function Bidding:setBid(playerIndex, amount)
    self.bids[playerIndex] = math.max(0, math.floor(amount or 0))
end

-- finalize: determine winners, transfer cards and money
function Bidding:finalize()
    -- find highest bid index
    local highest, idx = -1, nil
    for i=1,#self.bids do
        if self.bids[i] > highest then highest = self.bids[i]; idx = i end
    end
    if idx and highest > 0 then
        local winner = self.game.players[idx]
        if winner.money >= highest then
            winner.money = winner.money - highest
            table.insert(winner.reserve_blueprints, self.targets.blueprint)
            print(winner.name.." bought blueprint "..self.targets.blueprint.name.." for "..highest)
        else
            print(winner.name.." could not pay the bid; blueprint returned.")
            self.game.blueprintDeck:discardCard(self.targets.blueprint)
        end
    else
        -- no bids -> discard blueprint
        if self.targets.blueprint then self.game.blueprintDeck:discardCard(self.targets.blueprint) end
    end

    -- top 3 bidders pick turfs (descending)
    local entries = {}
    for i=1,#self.bids do table.insert(entries, { idx=i, bid=self.bids[i] }) end
    table.sort(entries, function(a,b) return a.bid > b.bid end)

    for pick=1,3 do
        local e = entries[pick]
        if e and e.bid > 0 and self.targets.turfs[pick] then
            local p = self.game.players[e.idx]
            table.insert(p.reserve_turfs, self.targets.turfs[pick])
            print(p.name .. " receives turf " .. self.targets.turfs[pick].name .. " (bid "..e.bid..")")
        else
            -- discard
            if self.targets.turfs[pick] then self.game.turfDeck:discardCard(self.targets.turfs[pick]) end
        end
    end

    self.active = false
    self.targets = {}
    self.bids = {}
end

function Bidding:render(x,y,w,h)
    if not self.active then return end
    love.graphics.setColor(0.98,0.95,0.88)
    love.graphics.rectangle("fill", x,y,w,h)
    love.graphics.setColor(0,0,0)
    love.graphics.print("Bidding Phase", x+10, y+10)
    love.graphics.print("Blueprint: "..(self.targets.blueprint and self.targets.blueprint.name or "none"), x+10, y+34)
    for i,p in ipairs(self.game.players) do
        local py = y + 60 + (i-1)*34
        love.graphics.print(p.name .. " bid: "..(self.bids[i] or 0), x+10, py)
    end
    love.graphics.setColor(1,1,1)
end

return Bidding
