
SMODS.Joker{ --Legacy
    key = "legacy",
    config = {
        extra = {
            high_score = 0,
            xmult = 1,
            xmult_gain = 0.5
        }
    },
    loc_txt = {
        ['name'] = 'Legacy',
        ['text'] = {
            'This Joker gains {X:mult,C:white} X#1# {} Mult',
            'per {C:attention}consecutive{} round won',
            'with more chips than the last',
            '{C:inactive}(Currently {X:mult,C:white} X#2# {C:inactive} Mult)',
            '{C:inactive,s:0.8}(Last: {X:black,C:white,s:0.8} #3# {C:inactive,s:0.8} Chips)'
        },
        ['unlock'] = {
            [1] = 'Unlocked by default.'
        }
    },
    pos = {
        x = 3,
        y = 0
    },
    display_size = {
        w = 71 * 1, 
        h = 95 * 1
    },
    cost = 7,
    rarity = 2,
    blueprint_compat = true,
    eternal_compat = true,
    perishable_compat = true,
    unlocked = true,
    discovered = true,
    atlas = 'CustomJokers',
    pools = { ["lilithsb_jokers"] = true },

    loc_vars = function(self, info_queue, card)
        return {vars = {card.ability.extra.xmult_gain, card.ability.extra.xmult, (G.GAME.chips_last or 0)}}
    end,
    
    calculate = function(self, card, context)
        if context.cardarea == G.jokers and context.joker_main  then
            return {
                Xmult = card.ability.extra.xmult
            }
        end
        if context.end_of_round and context.game_over == false and context.main_eval then
            if to_big(G.GAME.chips) >= to_big(G.GAME.chips_last) then
                card.ability.extra.xmult = card.ability.extra.xmult + card.ability.extra.xmult_gain
                return {
                    message = localize('k_upgrade_ex'),
                    colour = G.C.MULT,
                    message_card = card
                }
            else
                if card.ability.extra.xmult > 1 then
                    card.ability.extra.xmult = 1
                    return {
                        message = localize('k_reset')
                    }
                end
            end
            -- G.GAME.chips_last = G.GAME.chips
        end
    end,
}