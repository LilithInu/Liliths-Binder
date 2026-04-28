
SMODS.Joker{ --Estrogen
    key = "estrogen",
    loc_txt = {
        ['name'] = 'Estrogen',
        ['text'] = {
            "All scoring {C:attention}face{} cards",
            "become {C:attention}Queens{}"
        },
        ['unlock'] = {
            [1] = 'Unlocked by default.'
        }
    },
    pos = {
        x = 0,
        y = 0
    },
    display_size = {
        w = 71 * 1, 
        h = 95 * 1
    },
    cost = 5,
    rarity = 3,
    blueprint_compat = false,
    eternal_compat = true,
    perishable_compat = true,
    unlocked = true,
    discovered = true,
    atlas = 'CustomJokers',
    pools = { ["lilithsb_jokers"] = true },
    
    calculate = function(self, card, context)
        if context.before and not context.blueprint then
            local faces = 0
            for _, scored_card in pairs(context.scoring_hand) do
                if scored_card:is_face() and scored_card:get_id() ~= 12 then
                    faces = faces + 1
                    --scored_card:set_ability('m_gold', nil, true)
                end
            end
            if faces > 0 then
                G.E_MANAGER:add_event(Event({
                    func = function()
                        --card_eval_status_text(card, 'extra', nil, nil, nil, {message = "Gambling!", colour = G.C.ORANGE})
                        --[[scored_card:juice_up(0.3, 0.5)
                        play_sound('tarot1')
                        assert(SMODS.change_base(scored_card, nil, 'Queen'))
                        delay(2)
                        return true]]--
                        for _, playing_card in pairs(context.scoring_hand or {}) do
                            if playing_card:is_face() and playing_card:get_id() ~= 12 then
                                --count = count + 1
                                assert(SMODS.change_base(playing_card, nil, 'Queen'))
                                playing_card:juice_up(0.3, 0.5)
                            end
                        end
                        play_sound('tarot1')
                        delay(1)
                        return true
                    end,
                    --[[message = 'Gambling!',
                    colour = G.C.ORANGE,
                    card = card]]--
                }))
                return {
                    message = 'Estrogen!',
                    colour = HEX('ffa5b7')
                }
            end
        end
    end
}