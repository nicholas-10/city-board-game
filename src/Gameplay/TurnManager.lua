-- Controls the turn startup, end-turn, and round detection.
TurnManager = Class{}

function TurnManager:init(game)
    self.game = game
    self.players = game.players
    self.currentIndex = 1
    self.phase = "idle"
    self.roundCount = 1
    -- begin first player's turn immediately:
    self:beginTurn()
end

function TurnManager:beginTurn()
    local p = self.players[self.currentIndex]
    -- draw an action card if hand < 3
    if #p.hand < 3 then
        local c = self.game.actionDeck:draw()
        if c then table.insert(p.hand, c) end
    end
    -- activate turfs
    for _,t in ipairs(p.turfs) do
        if t.onActivate then t.onActivate(t, p, self.game) end
    end
    -- level up blueprints on map for this player's placed ones
    for i,slot in ipairs(self.game.map.slots) do
        if slot and slot.owner == p then
            if slot.level < slot.blueprint.max_level then
                slot.level = slot.level + 1
                if slot.blueprint.onLevelUp then slot.blueprint.onLevelUp(slot, p, self.game) end
            else
                if slot.blueprint.onMax then slot.blueprint.onMax(slot, p, self.game) end
            end
        end
    end
    self.phase = "player_turn"
end

function TurnManager:endTurn()
    local player = self.players[self.currentIndex]
    -- auto-play first action card if any (prototype)
    if #player.hand > 0 then
        local c = table.remove(player.hand, 1)
        if c.onPlay then c.onPlay(c, player, self.game) end
    end

    -- next player
    self.currentIndex = (self.currentIndex % #self.players) + 1
    if self.currentIndex == 1 then
        -- full round ended
        self.roundCount = self.roundCount + 1
        self.game.bidding:startRoundBidding()
    end
    self:beginTurn()
end

return TurnManager