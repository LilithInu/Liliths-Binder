
SMODS.Joker{ --Sleight of Hand
    key = "sleight",
    config = {
        extra = {}
    },
    loc_txt = {
        ['name'] = 'Sleight of Hand',
        ['text'] = {
            'Played cards are shuffled',
            'back into the {C:attention}deck{}',
        },
        ['unlock'] = {
            [1] = 'Unlocked by default.'
        }
    },
    pos = {
        x = 1,
        y = 0
    },
    display_size = {
        w = 71 * 1, 
        h = 95 * 1
    },
    cost = 4,
    rarity = 1,
    blueprint_compat = false,
    eternal_compat = true,
    perishable_compat = true,
    unlocked = true,
    discovered = true,
    atlas = 'CustomJokers',
    pools = { ["lilithsb_jokers"] = true },

    --loc_vars = function(self, info_queue, card)
    --    return {vars = {card.ability.extra.xmult_gain, card.ability.extra.xmult, (G.GAME.chips_last or 0)}}
    --end,
    
    calculate = function(self, card, context)
    end,
}

local oldfromplaytodiscard = G.FUNCS.draw_from_play_to_discard
function G.FUNCS:draw_from_play_to_discard(e)
    -- Check if the joker is present
    if next(SMODS.find_card('j_lilithsb_sleight')) then
        local play_count = #G.play.cards
        local it = 1
        for k, v in ipairs(G.play.cards) do
            if (not v.shattered) and (not v.destroyed) then 
                -- draw_card(from, to, percent, dir, sort, card, delay, mute, stay_flipped, vol, discarded_only)
                draw_card(G.play,G.deck, it*100/play_count,'down', false, v)
                it = it + 1
            end
        end
        G.E_MANAGER:add_event(Event({
            --trigger = 'after',
            func = function()
                G.deck:shuffle("lilithsb_sleight")
                --play_sound('card1', 1, 1.4)
                if #G.deck.cards >= 1 then
                    G.deck.cards[1]:juice_up(0.05, 0.02)
                end
                return true
            end
        }))
        return
    end

    -- Old function
    return oldfromplaytodiscard(self, e)
end