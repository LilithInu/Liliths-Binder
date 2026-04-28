
SMODS.Joker{ --Limited Edition
    key = "limited",
    config = {
        extra = {
            banned = {}
        }
    },
    loc_txt = {
        ['name'] = 'Limited Edition',
        ['text'] = {
            '{C:attention}Joker{} cards will',
            'only appear {C:attention}once{}',
            '{C:inactive,s:0.8}(#1# Jokers seen){}'
        },
        ['unlock'] = {
            [1] = 'Unlocked by default.'
        }
    },
    pos = {
        x = 9,
        y = 0
    },
    display_size = {
        w = 71 * 1, 
        h = 95 * 1
    },
    cost = 7,
    rarity = 2,
    blueprint_compat = false,
    eternal_compat = true,
    perishable_compat = true,
    unlocked = true,
    discovered = true,
    atlas = 'CustomJokers',
    pools = { ["lilithsb_jokers"] = true },

    loc_vars = function(self, info_queue, card)
        return { vars = { #card.ability.extra.banned } }
    end,
}
