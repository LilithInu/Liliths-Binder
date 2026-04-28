
SMODS.Joker{ --Marx
    key = "marx",
    config = {
        extra = {
            xmult = 1.5,
            xmult_gain = 0.05 --0.1
        }
    },
    loc_txt = {
        ['name'] = 'Marx',
        ['text'] = {
            'Scoring cards give {X:mult,C:white} X#1# {} Mult',
            '{C:attention}Destroy all scoring cards{}',
            'and gain {X:mult,C:white} X#2# {} Mult per card',
        },
        ['unlock'] = {
            [1] = 'Unlocked by default.'
        }
    },
    pos = {
        x = 0,
        y = 1
    },
    soul_pos = {
        x = 1,
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
    
    calculate = function(self, card, context)
        if context.individual and context.cardarea == G.play then
            return {
                xmult = card.ability.extra.xmult
            }
        end
        if context.destroy_card and not context.blueprint then
            --LilithUtil.isInArray(context.full_hand, context.destroy_card)
            --G.GAME.current_round.hands_played == 0 and 
            if LilithUtil.isInArray(context.scoring_hand, context.destroy_card) then
                card.ability.extra.xmult = card.ability.extra.xmult + card.ability.extra.xmult_gain
                return {
                    message = localize('k_upgrade_ex'),
                    colour = G.C.MULT,
                    message_card = card,
                    remove = true
                }
            end
        end
    end,

    loc_vars = function(self, info_queue, card)
        return { vars = { card.ability.extra.xmult, card.ability.extra.xmult_gain } }
    end,
}

SMODS.DrawStep{
    key = 'marx_wings',
    order = 48,---11,
    func = function(self)
        --sendInfoMessage(inspect(self), "lily")
        if G.marx_wings_sprite and self.config and self.config.center_key and self.config.center_key == "j_lilithsb_marx" then
            --sendInfoMessage(inspectDepth(G.marx_wings_sprite), "lily")
            --lol()
            G.marx_wings_sprite.role.draw_major = self
            --Sprite:draw_shader(_shader, _shadow_height, _send, _no_tilt, other_obj, ms, mr, mx, my, cusmtom_shader, tilt_shadow)
            -- 36px one unit, card double 71px
            --sendInfoMessage(inspect(self.children.center.VT), "lily")
            --sendInfoMessage(ocpzjecpz)
            --local cezz = {}
            --cezz[1].lol = 21
            --sendInfoMessage(self.children.center.VT.scale, "lily")
            G.marx_wings_sprite:draw_shader('dissolve', nil, nil, nil, self.children.center, nil, nil, -((103-71)/2)/36, nil, nil, nil) -- -16/36
        end
    end,
    conditions = {vortex = false, facing = 'front'},
}
