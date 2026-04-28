--local fish_ranks = nil
-- SMODS.last_hand.full_hand you don't need to do this

SMODS.Joker{ --Go Fish
    key = "go_fish",
    config = {
        extra = {
            retriggers = 52
        }
    },
    loc_txt = {
        ['name'] = 'Go Fish',
        ['text'] = {
            'After hand is played,',
            '{C:attention}draw an extra card{}',
            'If its {C:attention}rank matches{} a card',
            'in played hand {C:attention}trigger again{}',
            '{C:inactive,s:0.8}(#1# retriggers left)'
        },
        ['unlock'] = {
            [1] = 'Unlocked by default.'
        }
    },
    pos = {
        x = 7,
        y = 0
    },
    display_size = {
        w = 71 * 1, 
        h = 95 * 1
    },
    cost = 8,
    rarity = 3,
    blueprint_compat = true,
    eternal_compat = true,
    perishable_compat = true,
    unlocked = true,
    discovered = true,
    atlas = 'CustomJokers',
    pools = { ["lilithsb_jokers"] = true },

    loc_vars = function(self, info_queue, card)
        return { vars = { card.ability.extra.retriggers } }
    end,

    calculate = function(self, card, context)
        if context.after and context.full_hand and not context.blueprint and not context.end_of_round and G.GAME.current_round.hands_left ~= 0 then
            card.ability.extra.fish_ranks = {}
            for _, c in ipairs(context.full_hand) do
                card.ability.extra.fish_ranks[c.base.value] = true
            end
        end

        if context.end_of_round and context.game_over == false and context.main_eval and not context.blueprint then
            card.ability.extra.fish_ranks = nil
        end

        if context.after_hand and card.ability.extra and card.ability.extra.fish_ranks and G.GAME.current_round.any_hand_drawn and G.GAME.facing_blind then
            local chain_count = 0
            -- Top of the deck - hand_space
            local deck_index = #G.deck.cards - context.card_drawn

            local trigger_card = context.blueprint_card or card

            while deck_index > 0 and (type(card.ability.extra.retriggers) ~= "number" or card.ability.extra.retriggers > 0) do
                local next_card = G.deck.cards[deck_index]

                -- First draw always happens
                if chain_count == 0 then
                    chain_count = 1
                    --deck_index = deck_index - 1
                    if not card.ability.extra.fish_ranks[next_card.base.value] then
                        break
                    end
                else
                    -- Subsequent draws only if rank matches
                    if card.ability.extra.fish_ranks[next_card.base.value] then
                        if type(card.ability.extra.retriggers) == "number" then
                            card.ability.extra.retriggers = card.ability.extra.retriggers - 1
                        end
                        chain_count = chain_count + 1
                        deck_index = deck_index - 1
                    else
                        break
                    end
                end
            end

            if chain_count > 0 then
                if G.GAME.chips < G.GAME.blind.chips then
                    for i = 1, chain_count do
                        if #G.deck.cards > 0 then
                            if i == chain_count then
                                card_eval_status_text(trigger_card, 'extra', nil, nil, nil, {message = "Go Fish!", colour = G.C.RED})
                            else
                                card_eval_status_text(trigger_card, 'extra', nil, nil, nil, {message = "One More!", colour = G.C.ORANGE})
                            end
                            draw_card(G.deck, G.hand, 0, 'up')
                        end
                    end

                    if type(card.ability.extra.retriggers) == "number" and card.ability.extra.retriggers <= 0 then
                        SMODS.destroy_cards(card, true, nil, true)
                        card_eval_status_text(trigger_card, 'extra', nil, nil, nil, {message = "Overfished!", colour = G.C.RED})
                    end
                end
            end

            context.card_drawn = context.card_drawn + chain_count
            --card.ability.extra.fish_ranks = nil
            --chain_count = 0
            --if not context.blueprint then
            --    card.ability.extra.fish_ranks = nil
            --end
        end
        
        -- Reset after triggering ability
        if context.after_hand_post and card.ability.extra and card.ability.extra.fish_ranks and G.GAME.current_round.any_hand_drawn and G.GAME.facing_blind then
            card.ability.extra.fish_ranks = nil
        end
    end
}

local global_hand_space = 0

-- Hook draw_from_deck_to_hand
local old_draw_from_deck_to_hand = G.FUNCS.draw_from_deck_to_hand
function G.FUNCS:draw_from_deck_to_hand(e)
    local r = old_draw_from_deck_to_hand(self, e)

    SMODS.calculate_context({after_hand = true, card_drawn = global_hand_space})

    SMODS.calculate_context({after_hand_post = true, card_drawn = global_hand_space})

    return r
end

function draw_extra_effect_lilith(hand_space)
    global_hand_space = hand_space
    return ret
end