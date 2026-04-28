
SMODS.Joker{ --Triple Seven
    key = "triple_seven",
    config = {
        extra = {
            cashout = 100
        }
    },
    loc_txt = {
        ['name'] = 'Triple Seven',
        ['text'] = {
            'If {C:attention}played hand{} is',
            '{C:attention}three 7{}s, doubles money',
            'and {C:attention}randomize{} card ranks',
            '{C:inactive}(Max of {C:money}$#1#{C:inactive})'
        },
        ['unlock'] = {
            [1] = 'Unlocked by default.'
        }
    },
    pos = {
        x = 6,
        y = 0
    },
    display_size = {
        w = 71 * 1, 
        h = 95 * 1
    },
    cost = 5,
    rarity = 2,
    blueprint_compat = true,
    eternal_compat = true,
    perishable_compat = true,
    unlocked = true,
    discovered = true,
    atlas = 'CustomJokers',
    pools = { ["lilithsb_jokers"] = true },
    
    loc_vars = function(self, info_queue, card)
        return {vars = {card.ability.extra.cashout}}
    end,
    
    calculate = function(self, card, context)
        if context.cardarea == G.jokers and context.joker_main then
            if (function()
                local count = 0
                for _, playing_card in pairs(context.full_hand or {}) do
                    if playing_card:get_id() == 7 then
                        count = count + 1
                    end
                end
                return (count == 3 and #context.full_hand == 3) 
            end)() then
                --[[return {
                    
                    func = function()
                        
                        local current_dollars = G.GAME.dollars
                        local target_dollars = G.GAME.dollars + card.ability.extra.cashout
                        local dollar_value = target_dollars - current_dollars
                        ease_dollars(dollar_value)
                        card_eval_status_text(context.blueprint_card or card, 'extra', nil, nil, nil, {message = "+"..tostring(card.ability.extra.cashout), colour = G.C.MONEY})
                        return true
                    end
                }]]--
                G.GAME.dollar_buffer = (G.GAME.dollar_buffer or 0) + card.ability.extra.cashout
                SMODS.calculate_effect({
                    dollars = math.max(0, math.min(G.GAME.dollars, card.ability.extra.cashout)), -- card.ability.extra.cashout
                    trigger = 'after',
                    --delay = 0.45,
                    func = function() -- This is for timing purposes, it runs after the dollar manipulation
                        G.E_MANAGER:add_event(Event({
                            func = function()
                                G.GAME.dollar_buffer = 0
                                return true
                            end
                        }))
                    end
                }, card)

                local scored_cards = context.full_hand
                G.E_MANAGER:add_event(Event({
                    trigger = 'after',
                    delay = 2, --0.5,
                    func = function()
                        --card_eval_status_text(card, 'extra', nil, nil, nil, {message = "Gambling!", colour = G.C.ORANGE})
                        for _, playing_card in pairs(scored_cards or {}) do
                            if playing_card:get_id() == 7 then
                                --count = count + 1
                                assert(SMODS.change_base(playing_card, nil, pseudorandom_element(SMODS.Ranks, 'edit_card_rank').key))
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
                delay(1)
                --delay(0.5)
            end
        end
    end
}