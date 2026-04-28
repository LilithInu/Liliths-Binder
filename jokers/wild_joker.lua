
SMODS.Joker{ --Wild Joker
    key = "wild_joker",
    config = {
        extra = {
            repetitions = 2
        }
    },
    loc_txt = {
        ['name'] = 'Wild Joker',
        ['text'] = {
            --'Retrigger all played {C:attention}Wild{}',
            --'{C:attention}Card{}sm {C:attention}#1#{} additional times'
            --'cards {C:attention}#1#{} additional times'
            'All played {C:attention}Wild Card{}',
            'retrigger {C:attention}#1#{}',
            'additional times'
        },
        ['unlock'] = {
            [1] = 'Unlocked by default.'
        }
    },
    pos = {
        x = 5,
        y = 1
    },
    display_size = {
        w = 71 * 1, 
        h = 95 * 1
    },
    cost = 6,
    rarity = 2,
    blueprint_compat = true,
    eternal_compat = true,
    perishable_compat = true,
    unlocked = true,
    discovered = true,
    atlas = 'CustomJokers',
    pools = { ["lilithsb_jokers"] = true },
    
    loc_vars = function(self, info_queue, card)
        info_queue[#info_queue + 1] = G.P_CENTERS.m_wild
        return { vars = { card.ability.extra.repetitions } }
    end,

    in_pool = function(self, args)
        for _, playing_card in ipairs(G.playing_cards or {}) do
            if SMODS.has_enhancement(playing_card, 'm_wild') then
                return true
            end
        end
        return false
    end,
    
    calculate = function(self, card, context)
        if context.repetition and context.cardarea == G.play and context.other_card and SMODS.has_enhancement(context.other_card, 'm_wild') then
            return {
                repetitions = card.ability.extra.repetitions
            }
        end
    end,
}