-- Game controller ties everything together
local Data = require 'src.DataDrivenDesign'
local Deck = require 'src.Gameplay.Deck'    -- require returns module table, but our Deck is returned directly
local Map = require 'src.Gameplay.Map'
local Player = require 'src.Gameplay.Player'
local TurnManager = require 'src.Gameplay.TurnManager'
local Bidding = require 'src.Gameplay.Bidding'
local EventBus = require 'src.Util.EventBus'

local Game = Class{}

function Game:init()
    -- eventbus instance
    self.eventbus = EventBus.new()

    -- decks (we wrap tables with our Deck module)
    self.actionDeck = Deck.new(Data.action_cards)
    self.blueprintDeck = Deck.new(Data.blueprints)
    self.turfDeck = Deck.new(Data.turf_cards)
    self.actionDeck:shuffle()
    self.blueprintDeck:shuffle()
    self.turfDeck:shuffle()

    -- players (hotseat 4)
    self.players = {}
    for i=1,4 do
        local p = Player(i, "Player "..i, 30)
        -- initial deal: 2 action, 2 blueprints, 3 turfs to reserves
        for j=1,2 do table.insert(p.hand, (self.actionDeck:draw())) end
        for j=1,2 do table.insert(p.reserve_blueprints, (self.blueprintDeck:draw())) end
        for j=1,3 do table.insert(p.reserve_turfs, (self.turfDeck:draw())) end
        table.insert(self.players, p)
    end

    -- map
    self.map = Map(6)

    -- bidding
    self.bidding = Bidding(self)

    -- turn manager
    self.turnManager = TurnManager(self)

    -- quick UI state for prototype
    self.mapArea = { x = 20, y = 20, w = VIRTUAL_WIDTH*0.6 - 40, h = VIRTUAL_HEIGHT*0.7 - 40 }
end

function Game:update(dt)
    -- timer / animation updates are handled by global Timer
    -- nothing to do for now; extend as needed
end

function Game:render()
    -- draw map area
    love.graphics.setColor(0.95,0.95,0.98)
    love.graphics.rectangle("fill", self.mapArea.x, self.mapArea.y, self.mapArea.w, self.mapArea.h)
    love.graphics.setColor(0,0,0)
    love.graphics.print("Map", self.mapArea.x+8, self.mapArea.y+8)
    self.map:draw(self.mapArea.x+10, self.mapArea.y+30, self.mapArea.w-20, self.mapArea.h-40)

    -- draw players bottom
    local py = VIRTUAL_HEIGHT - 140
    for i,p in ipairs(self.players) do
        local px = 20 + (i-1) * 300
        -- small panels for players (reuse Panel if desired)
        love.graphics.setColor(0.88,0.88,0.88)
        love.graphics.rectangle("fill", px, py, 280, 120)
        love.graphics.setColor(0,0,0)
        love.graphics.print(p.name, px+6, py+6)
        love.graphics.print("Money: "..p.money, px+6, py+26)
        love.graphics.print("Hand: "..#p.hand.."  Blueprints reserve: "..#p.reserve_blueprints, px+6, py+46)
        love.graphics.print("Turfs reserve: "..#p.reserve_turfs.."  Active turfs: "..#p.turfs, px+6, py+66)
        if i == self.turnManager.currentIndex then
            love.graphics.rectangle("line", px, py, 280, 120)
        end
    end

    -- Draw bidding UI if active
    if self.bidding.active then
        self.bidding:render(VIRTUAL_WIDTH*0.65, 120, VIRTUAL_WIDTH*0.32, VIRTUAL_HEIGHT*0.6)
    end

    -- instructions
    love.graphics.setColor(0,0,0)
    love.graphics.print("Click empty slot to build first blueprint from reserve. Press [space] to end current player's turn.", VIRTUAL_WIDTH*0.62, 32)
    love.graphics.setColor(1,1,1)
end

function Game:mousepressed(x,y,button)
    -- map build logic: click slot to build first blueprint in reserve
    local mx, my = push:toGame(x,y) -- convert window coords to virtual (if you use push)
    if not mx then mx, my = x, y end
    local slot = self.map:slotAtPosition(mx, my, self.mapArea.x+10, self.mapArea.y+30, self.mapArea.w-20, self.mapArea.h-40)
    if slot then
        local player = self.players[self.turnManager.currentIndex]
        local bp = player.reserve_blueprints[1]
        if bp and player:canAfford(bp.cost) and self.map:isEmpty(slot) then
            player.money = player.money - (bp.cost or 0)
            self.map:placeBlueprint(slot, bp, player)
            table.remove(player.reserve_blueprints, 1)
            print(player.name.." built "..bp.name.." on slot "..slot)
        else
            print("Can't build: no blueprint or cannot afford or slot occupied")
        end
    end

    -- handle bidding click input (prototype: increment/decrement)
    if self.bidding.active then
        -- map simple click zones to increase/decrease bids:
        local bx, by, bw, bh = VIRTUAL_WIDTH*0.65, 120, VIRTUAL_WIDTH*0.32, VIRTUAL_HEIGHT*0.6
        for i=1,#self.players do
            local py = by + 60 + (i-1)*34
            if mx > bx + 140 and mx < bx + 170 and my > py and my < py+20 then
                self.bidding:setBid(i, (self.bidding.bids[i] or 0) + 1)
            elseif mx > bx + 170 and mx < bx + 200 and my > py and my < py+20 then
                self.bidding:setBid(i, (self.bidding.bids[i] or 0) - 1)
            end
        end
        -- finalize button area
        if mx > bx + bw - 120 and mx < bx + bw - 10 and my > by + bh - 60 and my < by + bh - 20 then
            self.bidding:finalize()
        end
    end
end

function Game:keypressed(key)
    if key == 'space' then
        self.turnManager:endTurn()
    end
end

return Game
