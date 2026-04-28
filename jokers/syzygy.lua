
SMODS.Joker{ --Syzygy
    key = "syzygy",
    config = {
        extra = {}
    },
    loc_txt = {
        ['name'] = 'Syzygy',
        ['text'] = {
            --'Adds {C:blue}Chips{} and {C:red}Mult{} of all',
            --'other {C:attention}poker hands{} contained',
            --'in played hand'
            'Add {C:blue}Chips{} of all other',
            '{C:attention}poker hands{} contained',
            'in played hand'
        },
        ['unlock'] = {
            [1] = 'Unlocked by default.'
        }
    },
    pos = {
        x = 2,
        y = 0
    },
    display_size = {
        w = 71 * 1, 
        h = 95 * 1
    },
    cost = 6,
    rarity = 1,
    blueprint_compat = true,
    eternal_compat = true,
    perishable_compat = true,
    unlocked = true,
    discovered = true,
    atlas = 'CustomJokers',
    pools = { ["lilithsb_jokers"] = true },

    loc_vars = function(self, info_queue, card)
        if not (G and G.hand and G.hand.highlighted) then
            return {}
        end

        local line_height = 0.32
        --local poker_hand = G.FUNCS.get_poker_hand_info(G.hand.highlighted)
        --sendInfoMessage(inspectDepth(poker_hand))
        --sendInfoMessage(poker_hand)
        local text, loc_disp_text, poker_hands, scoring_hand, disp_text = G.FUNCS.get_poker_hand_info(G.hand.highlighted)

        if #G.hand.highlighted <= 0 then
            return {}
        end

        local chips_amount = self.get_amount_chips(text, poker_hands)

        main_end = {
            {n = G.UIT.R, config = { align = "cm" }, nodes = {
                { n = G.UIT.T, config = {text = "(", colour = G.C.UI.TEXT_INACTIVE, scale = line_height} },
                { n = G.UIT.T, config = {text = loc_disp_text, colour = G.C.UI.TEXT_INACTIVE, scale = line_height} },
                { n = G.UIT.T, config = {text = " +", colour = G.C.CHIPS, scale = line_height} },
                { n = G.UIT.T, config = {text = tostring(chips_amount), colour = G.C.CHIPS, scale = line_height} },
                { n = G.UIT.T, config = {text = " Chips", colour = G.C.UI.TEXT_INACTIVE, scale = line_height} },
                { n = G.UIT.T, config = {text = ")", colour = G.C.UI.TEXT_INACTIVE, scale = line_height} },
            }},
        }

        return {
            main_end = main_end,
            --vars = { card.ability.extra.tick_down, card.ability.extra.tick_up }
        }
    end,
    
    calculate = function(self, card, context)
        if context.cardarea == G.jokers and context.joker_main then
            local chips = self.get_amount_chips(context.scoring_name, context.poker_hands)
            if chips then
                return {
                    chips = chips
                }
            end
        end
    end,

    get_amount_chips = function(current_hand, poker_hands)
        local chips = to_big(0)

        for handname, _ in pairs(poker_hands) do
            if handname ~= "top" and next(poker_hands[handname]) and G.GAME.hands[handname] and handname ~= current_hand then
                chips = to_big(chips) + to_big(G.GAME.hands[handname].chips)
            end
        end

        return chips
    end,
}