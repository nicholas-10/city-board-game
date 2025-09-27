-- DataDrivenDesign.lua
-- Minimal data-driven card definitions. Replace callbacks with more complex logic later.

local M = {}

-- Action cards (simple examples)
M.action_cards = {
    { id = "act_gain5", name = "Gain 5", desc = "Gain 5 money",
      onPlay = function(card, player, game) player.money = player.money + 5 end
    },
    { id = "act_steal3", name = "Steal 3", desc = "Steal 3 from next player",
      onPlay = function(card, player, game)
        local nextIdx = (player.index % #game.players) + 1
        local target = game.players[nextIdx]
        local amount = math.min(3, target.money)
        target.money = target.money - amount
        player.money = player.money + amount
      end
    }
}

-- Blueprints (placed on map)
M.blueprints = {
    { id = "bp_shop", name = "Shop", cost = 6, max_level = 3,
      onLevelUp = function(inst, owner, game) owner.money = owner.money + 1 end,
      onMax = function(inst, owner, game) owner.money = owner.money + 3 end
    },
    { id = "bp_factory", name = "Factory", cost = 10, max_level = 4,
      onLevelUp = function(inst, owner, game) owner.money = owner.money + 2 end,
      onMax = function(inst, owner, game) owner.money = owner.money + 5 end
    }
}

-- Turf cards (passive effects each turn)
M.turf_cards = {
    { id = "turf_small", name = "Small Turf", desc = "Gives +1 money on activation",
      onActivate = function(turf, player, game) player.money = player.money + 1 end
    },
    { id = "turf_medium", name = "Medium Turf", desc = "Gives +2 money",
      onActivate = function(turf, player, game) player.money = player.money + 2 end
    },
    { id = "turf_big", name = "Big Turf", desc = "Gives +3 money",
      onActivate = function(turf, player, game) player.money = player.money + 3 end
    }
}

return M
