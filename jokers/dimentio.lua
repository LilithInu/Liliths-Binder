
SMODS.Joker{ --Dimentio
    key = "dimentio",
    config = {
        extra = {
            pmult = 0.1
        }
    },
    loc_txt = {
        ['name'] = 'Dimentio',
        ['text'] = {
            "{X:dark_edition,C:white} ^#1# {} Mult for each",
            "{C:red}Rare{} Joker owned",
            "{C:inactive}(Currently {X:dark_edition,C:white} ^#2# {C:inactive} Mult)",
        },
        ['unlock'] = {
            [1] = 'Unlocked by default.'
        }
    },
    pos = {
        x = 4,
        y = 0
    },
    soul_pos = {
        x = 5,
        y = 0
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
        return {vars = {
            card.ability.extra.pmult,
            self.get_power(card)
        }}
    end,
    
    calculate = function(self, card, context)
        if context.cardarea == G.jokers and context.joker_main then
            return {
                e_mult = self.get_power(card)--card.ability.extra.pmult
            }
        end
    end,

    get_power = function(card)
        local count = 0
        for _, joker in ipairs(G.jokers and (G.jokers and G.jokers.cards or {}) or {}) do
            if joker.config.center.rarity == 3 then
                count = count + 1
            end
        end

        return 1 + count * card.ability.extra.pmult
    end
}

