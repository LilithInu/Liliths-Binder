
SMODS.Joker{ --Jevil
    key = "jevil",
    config = {
        extra = {
            created = {
                hearts = false,
                spades = false,
                diamonds = false,
                clubs = false,
            },
            created_final = {
                hearts = false,
                spades = false,
                diamonds = false,
                clubs = false,
            }
        }
    },
    loc_txt = {
        ['name'] = 'Jevil',
        ['text'] = {
            --"{C:green}#1# in #2#{} chance to create {C:attention}1{} {C:dark_edition}Negative{}",
            --"{C:attention}card{} per scoring {C:attention}unique suit{}",

            --"{C:green}#1# in #2#{} chance to",
            --"create {C:attention}1{} {C:dark_edition}Negative{} card",
            --"per type depending on {C:attention}suit{}"

            --"For each scored suit,",
            --"{C:green}#1# in #2#{} chance to",

            --"{C:green}#1# in #2#{} chance for each",
            --"suit to create a max of",
            --"{C:attention}1{} {C:dark_edition}Negative{} card per type",

            --"{C:green}#1# in #2#{} chance for each scoring",
            --"card to create a max of",
            --"{C:attention}1{} {C:dark_edition}Negative{} card per suit",
            
            --"{C:dark_edition}+1{} Joker- and {C:attention}+2{} consumable slots",
            --"{C:dark_edition}+1{} {C:attention}Joker{} slot and {C:attention}consumable{} slot",
            --"If played hand contains a {C:attention}Flush{},",
            --"create a card {C:attention}based on suit{}"

            --"{C:dark_edition}+1{} {C:attention}Joker{} slot and {C:attention}consumable{} slot",
            --"If played hand contains a {C:attention}Flush{},",
            --"create a {C:dark_edition}Negative{} card",
            --"{C:attention}based on suit{} once per ante"

            --"If played hand contains a {C:attention}Flush{},",
            --"create a {C:dark_edition}Negative{} card once per {C:attention}suit",
            --"Resets when {C:attention}Boss Blind{} is defeated"

            --"For each scored {C:attention}suit{}",
            --"{C:hearts}Hearts{} give {X:mult,C:white}X#1#{} Mult,",
            --"{C:spades}Spades{} give {C:chips}+#2#{} Chips,",
            --"{C:clubs}Clubs{} retrigger {C:attention}once{},",
            --"and {C:diamonds}Diamonds{} earn {C:money}$#4#{}",

            "If played hand contains a {C:attention}Flush{},",
            "create a {C:dark_edition}Negative{} card once per {C:attention}suit",
            "Resets at end of {C:attention}round{}"

            --"per scoring {C:attention}unique suit{}"
            --[["{C:hearts}Hearts{}: {C:attention}Joker{}, {C:spades}Spades{}: {C:planet}Planet{}",
            "{C:diamonds}Diamonds{}: {C:tarot}Tarot{}, {C:clubs}Clubs{}: {C:spectral}Spectral{}"]]--
        },
        ['unlock'] = {
            [1] = 'Unlocked by default.'
        }
    },
    pos = {
        x = 8,
        y = 1
    },
    soul_pos = {
        x = 9,
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
        --G.jokers.config.card_limit = G.jokers.config.card_limit
    end,
    
    --[[loc_vars = function(self, info_queue, card)
        return { vars = { card.ability.extra.xmult_gain, card.ability.extra.xmult } }
    end,]]--

    loc_vars = function(self, info_queue, card)
        local numerator, denominator = SMODS.get_probability_vars(card, 1, card.ability.extra.odds, 'lilithsb_jevil')
        local icon_spacing = 0.06
        local line_height = 0.32 * 0.8 -- 0.32
        local normal_c = G.C.UI.TEXT_INACTIVE --G.C.UI.TEXT_DARK

        local suits = { "hearts", "spades", "diamonds", "clubs" }
        for index, suit in ipairs(suits) do
            if card.ability.extra.created[suit] then
                table.remove(suits, index)
            end
        end

        local suit_nodes = {
            {n = G.UIT.T, config = {text = "(", colour = normal_c, scale = line_height}},
        };

        for i = 1, #suits do
            if suits[i] == "hearts" then
                table.insert(suit_nodes, {n = G.UIT.O, config = { object = self.create_suit_icon({x=0,y=1}), w = line_height, h = line_height }})
                table.insert(suit_nodes, {n = G.UIT.B, config = {w = icon_spacing, h = line_height}})
                table.insert(suit_nodes, {n = G.UIT.T, config = {text = "Random", colour = normal_c, scale = line_height}})
            elseif suits[i] == "spades" then
                table.insert(suit_nodes, {n = G.UIT.O, config = { object = self.create_suit_icon({x=3,y=1}), w = line_height, h = line_height }})
                table.insert(suit_nodes, {n = G.UIT.B, config = {w = icon_spacing, h = line_height}})
                table.insert(suit_nodes, {n = G.UIT.T, config = {text = "Planet", colour = normal_c, scale = line_height}})
            elseif suits[i] == "diamonds" then
                table.insert(suit_nodes, {n = G.UIT.O, config = { object = self.create_suit_icon({x=1,y=1}), w = line_height, h = line_height }})
                table.insert(suit_nodes, {n = G.UIT.B, config = {w = icon_spacing, h = line_height}})
                table.insert(suit_nodes, {n = G.UIT.T, config = {text = "Tarot", colour = normal_c, scale = line_height}})
            elseif suits[i] == "clubs" then
                table.insert(suit_nodes, {n = G.UIT.O, config = { object = self.create_suit_icon({x=2,y=1}), w = line_height, h = line_height }})
                table.insert(suit_nodes, {n = G.UIT.B, config = {w = icon_spacing, h = line_height}})
                table.insert(suit_nodes, {n = G.UIT.T, config = {text = "Spectral", colour = normal_c, scale = line_height}})
            end

            if i < #suits then
                table.insert(suit_nodes, {n = G.UIT.T, config = {text = ", ", colour = normal_c, scale = line_height}})
            end
        end

        table.insert(suit_nodes, {n = G.UIT.T, config = {text = ")", colour = normal_c, scale = line_height}})

        return {
            vars = { numerator, denominator },
            main_end = {{n = G.UIT.C, config = { align = "cm" }, nodes = {
                {n = G.UIT.R, config = { align = "cm" }, nodes = suit_nodes}
            }}}
        }
    end,

    create_suit_icon = function(pos)
        local t_s = Sprite(0,0,0.5,0.5, G.ASSET_ATLAS[("ui_"..(G.SETTINGS.colourblind_option and "2" or "1"))], {x=pos.x or 0, y=pos.y or 0})
        t_s.states.drag.can = false
        t_s.states.hover.can = false
        t_s.states.collide.can = false
        return t_s
    end,
    
    calculate = function(self, card, context)
        --if context.ante_end and not context.blueprint then
        if context.end_of_round and not context.blueprint then
            card.ability.extra.created = card.ability.extra.created or { hearts = false, spades = false, diamonds = false, clubs = false }
            card.ability.extra.created_final = card.ability.extra.created_final or { hearts = false, spades = false, diamonds = false, clubs = false }

            for suit, is_created in pairs(card.ability.extra.created) do
                card.ability.extra.created[suit] = false
                card.ability.extra.created_final[suit] = false
            end
        end

        if context.final_scoring_step and not context.blueprint then
            --card.extra.scored = {}
            for suit, is_created in pairs(card.ability.extra.created) do
                card.ability.extra.created_final[suit] = card.ability.extra.created[suit]
            end
        end

        if context.before and context.cardarea == G.jokers then
            card.ability.extra.created = card.ability.extra.created or { hearts = false, spades = false, diamonds = false, clubs = false }
            card.ability.extra.created_final = card.ability.extra.created_final or { hearts = false, spades = false, diamonds = false, clubs = false }

            local suits = {
                ['Hearts'] = 0,
                ['Diamonds'] = 0,
                ['Spades'] = 0,
                ['Clubs'] = 0
            }

            for i = 1, #context.scoring_hand do
                if SMODS.has_any_suit(context.scoring_hand[i]) then
                    for suit, suit_count in pairs(suits) do
                        suits[suit] = suits[suit] + 1
                    end
                else
                    if context.scoring_hand[i]:is_suit('Hearts') then
                        suits["Hearts"] = suits["Hearts"] + 1
                    end
                    if context.scoring_hand[i]:is_suit('Diamonds') then
                        suits["Diamonds"] = suits["Diamonds"] + 1
                    end
                    if context.scoring_hand[i]:is_suit('Spades') then
                        suits["Spades"] = suits["Spades"] + 1
                    end
                    if context.scoring_hand[i]:is_suit('Clubs') then
                        suits["Clubs"] = suits["Clubs"] + 1
                    end
                end
            end

            --sendInfoMessage(inspectDepth(suits), "lily")
            for suit, suit_count in pairs(suits) do
                if suit_count >= 5 and not card.ability.extra.created_final[suit:lower()] then
                    local pool = (suit == "Hearts" and "Consumeables") or
                        (suit == "Spades" and "Planet") or
                        (suit == "Diamonds" and "Tarot") or
                        (suit == "Clubs" and "Spectral") or "Tarot"

                    if not context.blueprint then
                        card.ability.extra.created[suit:lower()] = true
                    end

                    G.E_MANAGER:add_event(Event({
                        func = function()
                            local card = SMODS.add_card{
                                set = pool,
                                edition = "e_negative",
                                skip_materialize = false
                            }

                            if card.config.center_key == "j_joker" then
                                local list = { "c_strength", "c_pluto", "c_incantation" }
                                local random_card, index = pseudorandom_element(list, "lilithsb_seed")
                                card:set_ability(random_card)
                            end

                            card:start_materialize({G.C.PURPLE, G.C.GOLD})
                            return true
                        end,
                        trigger = "after",
                        delay = 0.5
                    }))
                end
            end
        end
    end
}

