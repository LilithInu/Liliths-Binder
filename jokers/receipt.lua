
SMODS.Joker{ --Receipt
    key = "receipt",
    config = {
        extra = {}
    },
    loc_txt = {
        ['name'] = 'Receipt',
        ['text'] = {
            [1] = 'Doubles the {C:attention}sell value{} of',
            [2] = 'cards bought in the shop',
            --[3] = "{C:inactive}(Max of original cost)"
        },
        ['unlock'] = {
            [1] = 'Unlocked by default.'
        }
    },
    pos = {
        x = 2,
        y = 1
    },
    display_size = {
        w = 71 * 1, 
        h = 95 * 1
    },
    cost = 6,
    rarity = 1,
    blueprint_compat = false,
    eternal_compat = true,
    perishable_compat = true,
    unlocked = true,
    discovered = true,
    atlas = 'CustomJokers',
    pools = { ["lilithsb_jokers"] = true },
    
    calculate = function(self, card, context)
        if context.buying_card and context.card and not (context.card == card) and not context.blueprint then
            --[[local sell = context.card.sell_cost * 2
            local max_cost = context.card.cost

            sell = math.min(sell, max_cost)
            sell = sell - math.floor(max_cost/2)]]--
            local sell = (context.card.sell_cost) * 2
            local max_cost = context.card.cost

            sell = math.min(sell, max_cost)
            sell = sell - (context.card.sell_cost - context.card.ability.extra_value)

            context.card.ability.extra_value = sell --context.card.sell_cost
            context.card:set_cost()
        end
    end
}