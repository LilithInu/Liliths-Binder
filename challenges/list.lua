-- Everything Must Go
SMODS.Challenge {
    key = 'everything_must_go_1',
    jokers = {
        { id = 'j_lilithsb_limited', eternal = true, edition = "negative" }
    },
    vouchers = {
        { id = 'v_overstock_norm' },
        { id = 'v_overstock_plus' },
        { id = 'v_reroll_surplus' }
    }
}

-- Overclocked
SMODS.Challenge {
    key = 'overclocked_1',
    jokers = {
        { id = 'j_lilithsb_timer', eternal = true, edition = "negative" }
    },
    rules = {
        custom = {
            { id = 'overclocked' },
        }
    }
}

-- Funny
SMODS.Challenge {
    key = 'gone_fishing_1',
    jokers = {
        { id = 'j_lilithsb_go_fish', eternal = true, edition = "negative" },
        { id = 'j_diet_cola' }
    },
    rules = {
        modifiers = {
            { id = "discards", value = 0 },
            { id = 'hand_size', value = 6 },
        }
    },
    restrictions = {
        banned_cards = {
            { id = "j_drunkard" },
            { id = "j_merry_andy" },
            { id = "v_wasteful" },
            { id = "v_recyclomancy" },
        }
    },
    deck = {
        type = 'Challenge Deck',
        cards = {
			{ s = "D", r = "2", e = 'm_lucky', d = "polychrome", g = "Red" },
			{ s = "D", r = "3" },
			{ s = "D", r = "4" },
			{ s = "D", r = "5" },
			{ s = "D", r = "6" },
            { s = "D", r = "7" },
            { s = "D", r = "2", e = 'm_lucky', d = "polychrome", g = "Red" },
			{ s = "D", r = "3" },
			{ s = "D", r = "4" },
			{ s = "D", r = "5" },
			{ s = "D", r = "6" },
            { s = "D", r = "7" },

			{ s = "C", r = "2", e = 'm_lucky', d = "polychrome", g = "Red" },
			{ s = "C", r = "3" },
			{ s = "C", r = "4" },
			{ s = "C", r = "5" },
			{ s = "C", r = "6" },
            { s = "C", r = "7" },
            { s = "C", r = "2", e = 'm_lucky', d = "polychrome", g = "Red" },
			{ s = "C", r = "3" },
			{ s = "C", r = "4" },
			{ s = "C", r = "5" },
			{ s = "C", r = "6" },
            { s = "C", r = "7" },

			{ s = "H", r = "2", e = 'm_lucky', d = "polychrome", g = "Red" },
			{ s = "H", r = "3" },
			{ s = "H", r = "4" },
			{ s = "H", r = "5" },
			{ s = "H", r = "6" },
            { s = "H", r = "7" },
            { s = "H", r = "2", e = 'm_lucky', d = "polychrome", g = "Red" },
			{ s = "H", r = "3" },
			{ s = "H", r = "4" },
			{ s = "H", r = "5" },
			{ s = "H", r = "6" },
            { s = "H", r = "7" },

			{ s = "S", r = "2", e = 'm_lucky', d = "polychrome", g = "Red" },
			{ s = "S", r = "3" },
			{ s = "S", r = "4" },
			{ s = "S", r = "5" },
			{ s = "S", r = "6" },
            { s = "S", r = "7" },
            { s = "S", r = "2", e = 'm_lucky', d = "polychrome", g = "Red" },
			{ s = "S", r = "3" },
			{ s = "S", r = "4" },
			{ s = "S", r = "5" },
			{ s = "S", r = "6" },
            { s = "S", r = "7" },
		},
    },
    apply = function(self, back)
        G.E_MANAGER:add_event(Event({
            func = function()
                if not next(SMODS.find_card("j_lilithsb_go_fish")) then
                    return false
                end

                SMODS.find_card("j_lilithsb_go_fish")[1].ability.extra.retriggers = "Infinite"
                return true
            end,
            blocking = false,
            --ref_table = G,
            --ref_value = "STATE_COMPLETE"
            --G.STATE_COMPLETE
        }))
        --next(SMODS.find_card("j_lilithsb_go_fish")).ability.extra.retriggers = 777
    end
}

-- Zero-G
SMODS.Challenge {
    key = 'zero_g_1',
    jokers = {
        { id = 'j_lilithsb_syzygy', eternal = true },
        { id = 'j_supernova', eternal = true },
        { id = 'j_constellation', eternal = true },
        { id = 'j_satellite', eternal = true },
        { id = 'j_rocket', eternal = true },
        { id = 'j_astronomer', eternal = true },
    },
    rules = {
        modifiers = {
            { id = 'joker_slots', value = 6 },
        }
    },
}

-- Lilith Says
SMODS.Challenge {
    key = 'lilith_says_1',
    jokers = {
        { id = 'j_lilithsb_lilith', eternal = true, edition = "negative" },
        { id = 'j_perkeo', edition = "negative" },
    }
}

-- Dimentio Challenge
SMODS.Challenge {
    key = 'the_ultimate_show_1',
    jokers = {
        { id = 'j_lilithsb_dimentio', eternal = true, edition = "negative" }
    },
    rules = {
        custom = {
            { id = 'only_rare' },
            { id = 'only_boss_blind' },
            --{ id = 'scaling_faster_i' }
        },
        modifiers = {
            { id = "dollars", value = 8 }
        }
    },
    deck = {
        --enhancement = "m_lucky"
    },
    apply = function(self, back)
        G.GAME["common_mod"] = 0
        G.GAME["uncommon_mod"] = 0
        G.GAME.round_resets.blind_states["Small"] = "Hide"
        G.GAME.round_resets.blind_states["Big"] = "Hide"
    end
}

-- Marx Challenge
SMODS.Challenge {
    key = 'marx_soul_1',
    jokers = {
        { id = 'j_lilithsb_marx', eternal = true, edition = "negative" }
    },
    rules = {
        custom = {
            --{ id = 'no_reward' },
            --{ id = 'no_extra_hand_money' },
            --{ id = 'no_interest' },
            { id = 'ante_scaling', value = 5 },
            { id = 'scaling_faster_ii' },
            { id = 'money_per_card_destroyed', value = 4 },
        }
    },
    restrictions = {
        banned_cards = {
            { id = "v_magic_trick" },
            { id = "v_illusion" },
            { id = 'v_seed_money' },
            { id = 'v_money_tree' },
            { id = 'p_standard_normal_1', ids = {
                'p_standard_normal_1', 'p_standard_normal_2',
                'p_standard_normal_3', 'p_standard_normal_4',
                'p_standard_jumbo_1', 'p_standard_jumbo_2',
                'p_standard_mega_1', 'p_standard_mega_2' }
            },
        },
        banned_tags = {
            { id = 'tag_standard' },
        }
    },
    apply = function(self, back)
        G.GAME.starting_params.ante_scaling = self.rules.custom[1].value or 1
        G.GAME.modifiers.scaling = (G.GAME.modifiers.scaling or 1) + 2
    end,
    calculate = function(self, context)
        if context.remove_playing_cards and G.GAME.modifiers.money_per_card_destroyed then
            local cards_removed = 0
            for _, removed_card in ipairs(context.removed) do
                cards_removed = cards_removed + 1
            end
            if cards_removed > 0 then
                return {
                    dollars = G.GAME.modifiers.money_per_card_destroyed * cards_removed,
                    func = function() -- This is for timing purposes, it runs after the dollar manipulation
                        G.E_MANAGER:add_event(Event({
                            func = function()
                                G.GAME.dollar_buffer = 0
                                return true
                            end
                        }))
                    end
                }
            end
        end
    end
}

-- Jevil Challenge
SMODS.Challenge {
    key = 'the_world_revolving_1',
    jokers = {
        { id = 'j_lilithsb_jevil', eternal = true, edition = "negative" },
        { id = 'j_lilithsb_jevil', eternal = true, edition = "negative" }
    },
    rules = {
        custom = {
            { id = 'no_shop' },
        }
    },
    restrictions = {
        banned_cards = {
            { id = "j_credit_card" },
            { id = "j_chaos" },
            --{ id = "j_red_card" },
            --{ id = "j_hallucination" },
            { id = "j_flash" },
            { id = "j_astronomer" },
            { id = "j_lilithsb_receipt" },
        },
        banned_tags = {
            { id = 'tag_uncommon' },
            { id = 'tag_rare' },
            { id = 'tag_negative' },
            { id = 'tag_foil' },
            { id = 'tag_holo' },
            { id = 'tag_polychrome' },
            { id = 'tag_voucher' },
            { id = 'tag_coupon' },
            { id = 'tag_d_six' },
        }
    },
    apply = function(self, back)
        --[[G.GAME.modifiers.lilithsb_negative_rate = self.rules.custom[1].value
        SMODS.Edition:take_ownership("negative", {
			get_weight = function(self)
				return self.weight * (G.GAME.modifiers.lilithsb_negative_rate or 1)
			end,
		}, true)]]--
    end
}

-- Nightmare Challenge
SMODS.Challenge {
    key = 'nightmare_1',
    rules = {
        custom = {
            { id = 'set_constant_shop_ante', value = 3 },
            { id = 'set_constant_reroll_ante', value = 3 }
        }
    },
    deck = {
        type = 'Challenge Deck'
        --enhancement = "m_lucky"
    },
    apply = function(self, back)
        --[[G.GAME["common_mod"] = 0
        G.GAME["uncommon_mod"] = 0
        G.GAME.round_resets.blind_states["Small"] = "Hide"
        G.GAME.round_resets.blind_states["Big"] = "Hide"]]--
    end,
    calculate = function(self, context)
        --load_shop_jokers
        if context.modify_shop_card then
            --sendInfoMessage(inspect(context.card))
            --context.card:remove()
        end
        if context.ending_shop then
            -- Save current shop state
            G.GAME.saved_shop = G.GAME.saved_shop or {}
            G.GAME.saved_shop.jokers = {}
            G.GAME.saved_shop.boosters = {}
            G.GAME.saved_shop.vouchers = {}

            -- Jokers
            for i = 1, #G.shop_jokers.cards do
                local card = G.shop_jokers.cards[i]

                --sendInfoMessage(G.shop_jokers.cards[i].config.center.key, "lily")

                table.insert(G.GAME.saved_shop.jokers, {
                    key = card.config.center.key,
                    set = card.ability.set,
                    edition = card.edition and card.edition.key,
                    seal = card.seal
                    --card.config.center.key
                })

                -- A playing card
                if card.ability.set == "Default" or card.ability.set == "Enhanced" then
                    -- Enhancements are already covered by keys
                    G.GAME.saved_shop.jokers[#G.GAME.saved_shop.jokers-1].rank = card.base.value
                    G.GAME.saved_shop.jokers[#G.GAME.saved_shop.jokers-1].suit = card.base.suit
                end

                --Stickers???
                -- card.ability.rental or card.ability.perishable or SMODS.is_eternal(card, trigger)
            end

            -- Boosters
            for i = 1, #G.shop_booster.cards do
                local booster = G.shop_booster.cards[i]
                
                table.insert(G.GAME.saved_shop.boosters, {
                    key = booster.config.center.key
                })
            end

            -- Vouchers
            for i = 1, #G.shop_vouchers.cards do
                local voucher = G.shop_vouchers.cards[i]
                
                table.insert(G.GAME.saved_shop.vouchers, {
                    key = voucher.config.center.key
                })
            end

            --G.GAME.saved_shop.reroll_cost = G.GAME.current_round.reroll_cost
            if G.GAME.modifiers.set_constant_reroll_ante and
            G.GAME.round_resets.ante > G.GAME.modifiers.set_constant_reroll_ante then
                G.GAME.round_resets.reroll_cost = G.GAME.current_round.reroll_cost
            end
            --G.GAME.round_resets.reroll_cost

            --G.load_shop_jokers = true
            --G.load_shop_booster = truem

            -- Jokers
            --G.shop_jokers.cards

            --sendInfoMessage(inspect(G.shop_jokers.cards))
            --sendInfoMessage(inspectDepth(G.GAME.saved_shop.jokers))
        end
        if context.starting_shop then
            --sendInfoMessage(inspect(G.shop_jokers.cards))
        end
        if context.reroll_shop then
            --sendInfoMessage(inspect(G.shop_jokers.cards))
        end
    end
}

LilithUtil.custom_restock_msg = function(line)
    if G.GAME.modifiers.set_constant_shop_ante and
    G.GAME.round_resets.ante > G.GAME.modifiers.set_constant_shop_ante then
        local text = {'NIGHTMARE', 'MODE', 'IS ON'}
        return text[line]
    end

    return nil
end

LilithUtil.custom_shop_start = function()
    if G.GAME.modifiers.set_constant_reroll_ante and
    G.GAME.round_resets.ante > G.GAME.modifiers.set_constant_reroll_ante then
        if G.GAME.saved_shop and G.GAME.saved_shop.reroll_cost then
            G.GAME.round_resets.reroll_cost = G.GAME.saved_shop.reroll_cost
        end
    end

    if G.GAME.modifiers.set_constant_shop_ante and
    G.GAME.round_resets.ante > G.GAME.modifiers.set_constant_shop_ante then
        -- Loading from a save, cancel everything!
        if G.load_shop_jokers then
            return false
        end

        -- Don't do it until at least one shop has been seen
        if G.GAME.saved_shop then
            if G.GAME.saved_shop.jokers then
                for i = 1, #G.GAME.saved_shop.jokers do
                    local data = G.GAME.saved_shop.jokers[i]

                    local card = SMODS.create_card({
                        key = data.key,
                        set = data.set,
                        edition = data.edition,
                        seal = data.seal,
                        rank = data.rank,
                        suit = data.suit,
                        key_append = 'sho' -- just in case??
                    })

                    -- Price/Buy UI with extra params from UI_definitions:l802
                    create_shop_card_ui(card, card.type, G.shop_jokers)

                    -- Tag stuff (Negative, Poly, Foil and free yknow)
                    G.E_MANAGER:add_event(Event({
                        func = (function()
                            for k, v in ipairs(G.GAME.tags) do
                                if v:apply_to_run({type = 'store_joker_modify', card = card}) then break end
                            end
                            return true
                        end)
                    }))

                    -- Put it in the correct spot
                    G.shop_jokers:emplace(card)
                end
            end

            if G.GAME.saved_shop.boosters then
                for i = 1, #G.GAME.saved_shop.boosters do
                    local data = G.GAME.saved_shop.boosters[i]

                    SMODS.add_booster_to_shop(data.key, true)
                end
            end

            if G.GAME.saved_shop.vouchers then
                for i = 1, #G.GAME.saved_shop.vouchers do
                    local data = G.GAME.saved_shop.vouchers[i]

                    SMODS.add_voucher_to_shop(data.key, true)
                end
            end
        else
            return false -- Generate the regular shop if a shop hasn't been visited yet
        end

        -- Extra normal tag stuff
        for i = 1, #G.GAME.tags do
            G.GAME.tags[i]:apply_to_run({type = 'voucher_add'})
        end
        for i = 1, #G.GAME.tags do
            G.GAME.tags[i]:apply_to_run({type = 'shop_final_pass'})
        end

        -- Normal shop begin stuff
        SMODS.calculate_context({starting_shop = true})
        G.CONTROLLER:snap_to({node = G.shop:get_UIE_by_ID('next_round_button')})
        G.E_MANAGER:add_event(Event({ func = function() save_run(); return true end}))

        return true -- Cancel normal shop generation
    end
end

-- Jevil Challenge
SMODS.Challenge {
    key = 'lilith_bullshit_1',
    jokers = {
        { id = 'j_lilithsb_receipt', eternal = true, edition = "negative" },
        { id = 'j_lilithsb_timer', eternal = true, edition = "negative" },
        { id = 'j_lilithsb_syzygy', eternal = true, edition = "negative" },
        { id = 'j_lilithsb_sleight', eternal = true, edition = "negative" },
        { id = 'j_lilithsb_collector', eternal = true, edition = "negative" },
        { id = 'j_lilithsb_triple_seven', eternal = true, edition = "negative" },
        { id = 'j_lilithsb_wild_joker', eternal = true, edition = "negative" },
        { id = 'j_lilithsb_legacy', eternal = true, edition = "negative" },
        { id = 'j_lilithsb_limited', eternal = true, edition = "negative" },
        { id = 'j_lilithsb_go_fish', eternal = true, edition = "negative" },
        { id = 'j_lilithsb_estrogen', eternal = true, edition = "negative" },
        { id = 'j_lilithsb_lilith', eternal = true, edition = "negative" },
        { id = 'j_lilithsb_jevil', eternal = true, edition = "negative" },
        { id = 'j_lilithsb_marx', eternal = true, edition = "negative" },
        { id = 'j_lilithsb_dimentio', eternal = true, edition = "negative" },
    }
}