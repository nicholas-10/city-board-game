-- Player class
Player = Class{}

function Player:init(index, name, money)
    self.index = index
    self.name = name or ("Player "..tostring(index))
    self.money = money or 30
    self.hand = {}              -- action cards in hand
    self.reserve_blueprints = {}-- blueprints owned but not placed
    self.reserve_turfs = {}     -- turf cards in reserve
    self.turfs = {}             -- active turfs (deployed)
    self.blueprints = {}        -- placed blueprint instances (map instances)
    self.bids = {}              -- scratch for bidding
end

function Player:canAfford(amount) return self.money >= (amount or 0) end

function Player:drawHandCount() return #self.hand end

return Player