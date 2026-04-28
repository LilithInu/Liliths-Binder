
SMODS.Joker{ --Lilith
    key = "lilith",
    config = {
        extra = {
            xmult = 1,
            xmult_gain = 1
        }
    },
    loc_txt = {
        ['name'] = 'Lilith',
        ['text'] = {
            "This Joker gains {X:mult,C:white} X#1# {} Mult",
            "when {C:attention}task{} is completed:",
            "Buy a {C:planet}Planet{} card",
            "#3#",
            "{C:inactive}(Currently {X:mult,C:white} X#2# {C:inactive} Mult)"
        },
        ['unlock'] = {
            [1] = 'Unlocked by default.'
        }
    },
    pos = {
        x = 6,
        y = 1
    },
    soul_pos = {
        x = 7,
        y = 1
    },
    display_size = {
        w = 71 * 1, 
        h = 95 * 1
    },
    cost = 20,
    rarity = 4,
    blueprint_compat = true,
    eternal_compat = true,
    perishable_compat = true,
    unlocked = true,
    discovered = true,
    atlas = 'CustomJokers',
    pools = { ["lilithsb_jokers"] = true },
    in_pool = function(self, args)
        return (
            not args 
            or args.source ~= 'sho' 
            or args.source == 'buf' or args.source == 'jud' or args.source == 'rif' or args.source == 'rta' or args.source == 'sou' or args.source == 'uta' or args.source == 'wra'
        )
        and true
    end,

    loc_vars = function(self, info_queue, card)
        local condition = self.condition_list[card.ability.extra.condition] or nil

        local key = self.key
        if condition then
            key = key .. '_' .. condition.key
        end

        local vars = { card.ability.extra.xmult_gain, card.ability.extra.xmult }
        condition.add_var(card, vars)

        local colors = {}
        condition.add_color(card, colors)
        vars.colours = colors

        return {
            key = key,
            vars = vars
        }
    end,

    set_ability = function(self, card, initial, delay_sprites)
        self.get_condition(self, card)
    end,

    get_random_existing_type = function(self, card, ban)
        --G.GAME.tarot_rate
        --G.GAME.playing_card_rate
        --SMODS.ConsumableTypes
        --key = 'Tarot',
        --primary_colour = G.C.SET.Tarot,
        --secondary_colour = G.C.SECONDARY_SET.Tarot,
        --card.ability.set == 'Default' or card.ability.set == 'Enhanced'
        --sendInfoMessage(inspectDepth(SMODS.ConsumableTypes['Tarot']), "step0")
        local allowed_type = LilithUtil.dictionary_to_array(SMODS.ConsumableTypes)
        allowed_type[#allowed_type + 1] = {key = 'Joker', secondary_colour = G.C.FILTER }
        --allowed_type[#allowed_type + 1] = {key = 'Default', secondary_colour = G.C.FILTER }
        --allowed_type[#allowed_type + 1] = {key = 'Enhanced', secondary_colour = G.C.FILTER }
        --allowed_type = SMODS.merge_lists(allowed_type)
        --sendInfoMessage(inspectDepth(allowed_type), "step1")
        --sendInfoMessage(inspectDepth(allowed_type), "step2")

        for i=#allowed_type,1,-1 do
            local current_type = allowed_type[i]

            --sendInfoMessage(inspect(allowed_type[i]), "step2.5")

            local rate_type = current_type.key:lower() .. "_rate"
            if card.ability.set == 'Default' or card.ability.set == 'Enhanced' then
                rate_type = "playing_card_rate"
            end
            
            if not G.GAME[rate_type] or G.GAME[rate_type] <= 0 or (ban and LilithUtil.isInArray(ban, current_type.key)) then
                table.remove(allowed_type, i)
            end
        end

        --sendInfoMessage(inspect(allowed_type), "step3")

        return pseudorandom_element(allowed_type, "lilithsb_lilith_gret")
    end,

    get_random_existing_rank = function(self, card)
        if G.playing_cards then
            local valid_rank_cards = {}
            for _, v in ipairs(G.playing_cards) do
                if not SMODS.has_no_rank(v) then
                    valid_rank_cards[#valid_rank_cards + 1] = v
                end
            end
            rank_card = { rank = 0, id = 0 }
            if valid_rank_cards[1] then
                rank_card = pseudorandom_element(valid_rank_cards, "lilithsb_lilith_grer")
                --G.GAME.current_round.rank_card.rank = rank_card.base.value
                --G.GAME.current_round.rank_card.id = rank_card.base.id
            else
                return { rank = nil, id = nil }
            end
        else
            return { rank = nil, id = nil }
        end

        return { rank = rank_card.base.value, id = rank_card.base.id }
    end,

    condition_list = {
        lil_buy = {
            key = "lil_buy",
            init = function(self, card)
                local r_type = self.get_random_existing_type(self, card)
                card.ability.extra.type = r_type.key
                card.ability.extra.color = r_type.secondary_colour
            end,
            add_var = function(card, vars)
                vars[#vars + 1] = card.ability.extra.type
            end,
            add_color = function(card, colors)
                table.insert(colors, card.ability.extra.color)
            end,
            calculate = function(self, card, context)
                if context.buying_card and not context.buying_self then
                    if context.card.ability.set == card.ability.extra.type then
                        return true
                    end
                end
                return false
            end
        },
        lil_sell = {
            key = "lil_sell",
            init = function(self, card)
                local r_type = self.get_random_existing_type(self, card)
                card.ability.extra.type = r_type.key
                card.ability.extra.color = r_type.secondary_colour
            end,
            add_var = function(card, vars)
                vars[#vars + 1] = card.ability.extra.type
            end,
            add_color = function(card, colors)
                table.insert(colors, card.ability.extra.color)
            end,
            calculate = function(self, card, context)
                if context.selling_card then
                    if context.card.ability.set == card.ability.extra.type then
                        return true
                    end
                end
                return false
            end
        },
        lil_use = {
            key = "lil_use",
            init = function(self, card)
                local r_type = self.get_random_existing_type(self, card, {"Joker"})
                card.ability.extra.type = r_type.key
                card.ability.extra.color = r_type.secondary_colour
            end,
            add_var = function(card, vars)
                vars[#vars + 1] = card.ability.extra.type
            end,
            add_color = function(card, colors)
                table.insert(colors, card.ability.extra.color)
            end,
            calculate = function(self, card, context)
                if context.using_consumeable then
                    if context.consumeable.ability.set == card.ability.extra.type then
                        return true
                    end
                end
                return false
            end
        },
        lil_score = {
            key = "lil_score",
            init = function(self, card)
                card.ability.extra.rank = self.get_random_existing_rank(self, card)
            end,
            add_var = function(card, vars)
                vars[#vars + 1] = localize((card.ability.extra.rank or {}).rank or 'Ace', 'ranks')--card.ability.extra.rank.id
            end,
            add_color = function(card, colors)
                table.insert(colors, G.C.FILTER)
            end,
            calculate = function(self, card, context)
                if context.individual and context.cardarea == G.play then
                    if context.other_card:get_id() == card.ability.extra.rank.id then
                        return true
                    end
                end
                return false
            end
        },
        lil_discard = {
            key = "lil_discard",
            init = function(self, card)
                card.ability.extra.rank = self.get_random_existing_rank(self, card)
            end,
            add_var = function(card, vars)
                vars[#vars + 1] = localize((card.ability.extra.rank or {}).rank or 'Ace', 'ranks')--card.ability.extra.rank.id
            end,
            add_color = function(card, colors)
                table.insert(colors, G.C.FILTER)
            end,
            calculate = function(self, card, context)
                if context.discard then
                    if context.other_card:get_id() == card.ability.extra.rank.id then
                        return true
                    end
                end
                return false
            end
        },
        lil_booster_opened = {
            key = "lil_booster_opened",
            init = function(self, card)
                --card.ability.extra.rank = self.get_random_existing_rank(self, card)
                local booster_kind = {}
                for k, v in ipairs(G.P_CENTER_POOLS.Booster) do
                    if (v.weight or 0) >= 0.5 then
                        booster_kind[v.kind] = v.kind
                    end
                end

                -- Spectrals are too hard to find
                booster_kind["Spectral"] = nil

                booster_kind = LilithUtil.dictionary_to_array(booster_kind)

                card.ability.extra.booster = pseudorandom_element(booster_kind, "lilithsb_lilith_grb")
            end,
            add_var = function(card, vars)
                --vars[#vars + 1] = localize((card.ability.extra.rank or {}).rank or 'Ace', 'ranks')--card.ability.extra.rank.id
                vars[#vars + 1] = card.ability.extra.booster
            end,
            add_color = function(card, colors)
                local c = G.C.BOOSTER
                if card.ability.extra.booster and card.ability.extra.booster == "Arcana" then
                    c = G.C.SECONDARY_SET.Tarot
                elseif card.ability.extra.booster and card.ability.extra.booster == "Celestial" then
                    c = G.C.SECONDARY_SET.Planet
                elseif card.ability.extra.booster and card.ability.extra.booster == "Spectral" then
                    c = G.C.SECONDARY_SET.Spectral
                elseif card.ability.extra.booster and card.ability.extra.booster == "Standard" then
                    c = G.C.FILTER
                end
                table.insert(colors, c)
                --table.insert(colors, G.C.BOOSTER)
            end,
            calculate = function(self, card, context)
                if context.open_booster then
                    --context.booster -- the booster pack center that was opened
                    -- self.ability.set == 'Booster' and self.config.center.kind == 'Celestial'
                    if context.booster.kind == card.ability.extra.booster then
                        return true
                    end
                end
                return false
            end
        },
        lil_booster_skip = {
            key = "lil_booster_skip",
            init = function(self, card)
            end,
            add_var = function(card, vars)
            end,
            add_color = function(card, colors)
                table.insert(colors, G.C.BOOSTER)
            end,
            calculate = function(self, card, context)
                if context.skipping_booster then
                    return true
                end
                return false
            end
        },
        lil_reroll = {
            key = "lil_reroll",
            init = function(self, card)
            end,
            add_var = function(card, vars)
            end,
            add_color = function(card, colors)
            end,
            calculate = function(self, card, context)
                if context.reroll_shop then
                    return true
                end
                return false
            end
        },
        lil_last_hand = {
            key = "lil_last_hand",
            init = function(self, card)
            end,
            add_var = function(card, vars)
            end,
            add_color = function(card, colors)
            end,
            calculate = function(self, card, context)
                if context.before and G.GAME.current_round.hands_left == 0 then
                    return true
                end
                return false
            end
        },
        lil_chance = {
            key = "lil_chance",
            init = function(self, card)
                card.ability.extra.odds = 3
            end,
            add_var = function(card, vars)
                local numerator, denominator = SMODS.get_probability_vars(card, 1, card.ability.extra.odds, 'lil_last_hand')
                vars[#vars + 1] = numerator
                vars[#vars + 1] = denominator
            end,
            add_color = function(card, colors)
            end,
            calculate = function(self, card, context)
                if context.before and SMODS.pseudorandom_probability(card, 'lil_last_hand', 1, card.ability.extra.odds) then
                    return true
                end
                return false
            end
        },
        lil_blind_skip = {
            key = "lil_blind_skip",
            init = function(self, card)
            end,
            add_var = function(card, vars)
            end,
            add_color = function(card, colors)
            end,
            calculate = function(self, card, context)
                if context.skip_blind then
                    return true
                end
                return false
            end
        },
        lil_add_playing_card = {
            key = "lil_add_playing_card",
            init = function(self, card)
            end,
            add_var = function(card, vars)
            end,
            add_color = function(card, colors)
            end,
            calculate = function(self, card, context)
                if context.playing_card_added then
                    return true
                end
                return false
            end
        },
        lil_suit_change = {
            key = "lil_suit_change",
            init = function(self, card)
            end,
            add_var = function(card, vars)
            end,
            add_color = function(card, colors)
            end,
            calculate = function(self, card, context)
                if context.change_suit then
                    return true
                end
                return false
            end
        },
        lil_boss_beat = {
            key = "lil_boss_beat",
            init = function(self, card)
            end,
            add_var = function(card, vars)
            end,
            add_color = function(card, colors)
            end,
            calculate = function(self, card, context)
                if context.ante_end then
                    return true
                end
                return false
            end
        },
        lil_spend = {
            key = "lil_spend",
            init = function(self, card)
                card.ability.extra.spent = 0
                card.ability.extra.spent_max = 15
            end,
            add_var = function(card, vars)
                vars[#vars + 1] = card.ability.extra.spent_max
                vars[#vars + 1] = card.ability.extra.spent
            end,
            add_color = function(card, colors)
            end,
            calculate = function(self, card, context)
                if context.money_altered and to_big(context.amount) < to_big(0) then
                    card.ability.extra.spent = card.ability.extra.spent - context.amount
                    if to_big(card.ability.extra.spent) >= to_big(card.ability.extra.spent_max) then
                        return true
                    end
                end
                return false
            end
        },
        -- Change to not most played
        lil_least_played_poker = {
            key = "lil_least_played_poker",
            init = function(self, card)
            end,
            add_var = function(card, vars)
            end,
            add_color = function(card, colors)
            end,
            calculate = function(self, card, context)
                if context.before then
                    --[[local current_played = (G.GAME.hands[context.scoring_name].played or 0) - 1
                    -- -1 otherwise you can't play hands at the same level
                    for handname, values in pairs(G.GAME.hands) do
                        if handname ~= context.scoring_name and values.played < current_played and values.visible then
                            return false
                        end
                    end

                    return true]]--
                    local play_more_than = (G.GAME.hands[context.scoring_name].played or 0)
                    for handname, values in pairs(G.GAME.hands) do
                        if handname ~= context.scoring_name and values.played >= play_more_than and SMODS.is_poker_hand_visible(handname) then
                            return true
                        end
                    end
                    return false
                end
            end
        },
        -- lil_discard
        -- lil_booster_opened
        -- lil_booster_skip
        -- lil_reroll
        -- lil_last_hand
        -- lil_chance
        -- lil_blind_skip
        -- lil_add_playing_card
        -- lil_suit_change context.change_suit
        -- lil_boss_beat context.ante_end
        -- lil_spend
        -- lil_least_played_poker
        -- lil_last_played_poker
        -- lil_random_poker
    },

    get_condition = function(self, card)
        --local list = { "lil_buy", "lil_sell", "lil_score", }
        --local random_card, index = pseudorandom_element(list, "lilithsb_lilith_cond")
        condition, key = pseudorandom_element(self.condition_list, "lilithsb_lilith_cond")

        --condition = self.condition_list.lil_booster_opened
        --key = condition.key

        card.ability.extra.condition = key
        condition.init(self, card)
        --sendInfoMessage(inspect(card.ability.extra.condition), "lily")
        --sendInfoMessage(key, "lily")
    end,
    
    calculate = function(self, card, context)
        if context.cardarea == G.jokers and context.joker_main  then
            return {
                Xmult = card.ability.extra.xmult
            }
        end

        local condition = self.condition_list[card.ability.extra.condition] or nil
        if not context.blueprint and condition.calculate(self, card, context) then
            card.ability.extra.xmult = card.ability.extra.xmult + card.ability.extra.xmult_gain
            self.get_condition(self, card)
            return {
                message = localize('k_upgrade_ex'),
                colour = G.C.MULT,
                message_card = card
            }
        end
    end
}

LilithUtil.dictionary_to_array = function(d)
    a = {}
    for key, value in pairs(d) do
        table.insert(a, value)
    end
    return a
end