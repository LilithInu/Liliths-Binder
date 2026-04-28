
SMODS.Consumable {
    key = 'dosha',
    set = 'Spectral',
    pos = { x = 0, y = 0 },
    config = { 
        extra = {
            dollars0 = 10000   
        } 
    },
    loc_txt = {
        name = 'Dosha',
        text = {
            [1] = 'Gain {E:1,C:money}$10000{}'
        }
    },
    cost = 3,
    unlocked = true,
    discovered = true,
    hidden = true,
    can_repeat_soul = false,
    atlas = 'CustomConsumables',
    use = function(self, card, area, copier)
        local used_card = copier or card
        G.E_MANAGER:add_event(Event({
            trigger = 'after',
            delay = 0.4,
            func = function()
                
                local current_dollars = G.GAME.dollars
                local target_dollars = G.GAME.dollars + 10000
                local dollar_value = target_dollars - current_dollars
                ease_dollars(dollar_value, true)
                return true
            end
        }))
        delay(0.6)
    end,
    can_use = function(self, card)
        return true
    end
}