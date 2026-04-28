
SMODS.Joker{ --Timer
    key = "timer",
    config = {
        extra = {
            starting = 30,
            counter_dt = 0,
            counter = 30,
            tick_down = 1,
            tick_up = 30
        }
    },
    loc_txt = {
        ['name'] = 'Timer',
        ['text'] = {
            --'{C:mult}-#1#{} Mult per second',
            --'since owned',
            --'{C:mult}-#1#{} Mult every',
            --'{C:attention}#3#{} seconds since owned',
            'Every #3#',
            'since owned, {C:mult}-#1#{} Mult',
            '{C:mult}+#2#{} Mult after {C:attention}Blind{}'
        },
        ['unlock'] = {
            [1] = 'Unlocked by default.'
        }
    },
    pos = {
        x = 3,
        y = 1
    },
    pixel_size = {
        w = 71,
        h = 71
    },
    cost = 6,
    rarity = 1,
    blueprint_compat = false,
    eternal_compat = true,
    perishable_compat = true,
    unlocked = true,
    discovered = true,
    atlas = 'CustomJokers',
    pools = { ["lilithsb_jokers"] = true },

    calculate = function(self, card, context)
        if context.joker_main then
            return {
                -- Just to make it ever so slightly accurate
                mult = math.max(card.ability.extra.counter - 1, 0)
            }
        end

        --to_big(G.SETTINGS.GAMESPEED) == to_big(4)

        if context.end_of_round and context.game_over == false and context.main_eval and not context.blueprint then
            return {
                func = function()
                    --if not (card.ability.extra.dead or false) then
                    --    card.ability.extra.counter = card.ability.extra.counter + card.ability.extra.tick_up
                    --end
                    G.E_MANAGER:add_event(Event({
                        func = function()
                            if not (card.ability.extra.dead or false) then
                                card.ability.extra.counter = card.ability.extra.counter + card.ability.extra.tick_up
                            end
                            return true
                        end,
                        trigger = 'after'
                        --blockable = false
                    }))
                end,
                message = 'Rewound!',
				colour = G.C.MULT,
				card = card
            }
        end
    end,

    loc_vars = function(self, info_queue, card)
        local line_height = 0.32
        main_start = {
            {n = G.UIT.R, config = { align = "cm" }, nodes = {
                { n = G.UIT.T, config = {text = "+", colour = G.C.MULT, scale = line_height} },
                { n = G.UIT.T, config = { ref_table = card.ability.extra, ref_value = "counter", colour = G.C.MULT, scale = 0.32 } },
                { n = G.UIT.T, config = {text = " Mult", colour = G.C.UI.TEXT_DARK, scale = line_height} },
            }},
            --{ n = G.UIT.T, config = { ref_table = card.ability.extra, ref_value = "counter", colour = G.C.UI.TEXT_DARK, scale = 0.32 } },
        }
        return {
            main_start = main_start,
            vars = { card.ability.extra.tick_down, card.ability.extra.tick_up, get_seconds_text() }
        }
    end
}

function get_seconds_amount()
    return 4/G.SETTINGS.GAMESPEED
end

function get_seconds_text()
    local sec = get_seconds_amount()
    if sec == 1 then
        return 'second'
    end

    return sec .. ' seconds'
end

SMODS.DrawStep{
    key = 'timer_dial',
    order = 25,---11,
    func = function(self)
        if G.timer_dial_sprite and self.config and self.config.center_key and self.config.center_key == "j_lilithsb_timer" then
            local shader = nil

            local edition = self.delay_edition or self.edition
            if edition then
                for k, v in pairs(G.P_CENTER_POOLS.Edition) do
                    if edition[v.key:sub(3)] and v.shader then
                        shader = v.shader
                    end
                end
            end

            local send = nil
            if shader == 'dissolve' then
                send = self.ARGS.send_to_shader
            end

            G.timer_dial_sprite.role.draw_major = self
            --Sprite:draw_shader(_shader, _shadow_height, _send, _no_tilt, other_obj, ms, mr, mx, my, cusmtom_shader, tilt_shadow)
            -- 36px one unit, card double 71px
            G.timer_dial_sprite:draw_shader(shader or 'dissolve', nil, send, nil, self.children.center, -0.05, math.rad(math.max(math.min(self.ability.extra.counter, 60), 0)/60*360), nil, nil, nil, nil)
            
            if edition and edition.negative then
                G.timer_dial_sprite:draw_shader('negative_shine', nil, send, nil, self.children.center, -0.05, math.rad(math.max(math.min(self.ability.extra.counter, 60), 0)/60*360), nil, nil, nil, nil)
            end
        end
    end,
    conditions = {vortex = false, facing = 'front'},
}

--Game:update hook
local upd = Game.update
function Game:update(dt)
	upd(self, dt)

    if G.jokers and not G.SETTINGS.paused then
        for _, joker in ipairs(G.jokers and (G.jokers and G.jokers.cards or {}) or {}) do
            if joker.config and joker.config.center_key and joker.config.center_key == "j_lilithsb_timer" then
                joker.ability.extra.counter_dt = joker.ability.extra.counter_dt + dt * (G.SETTINGS.GAMESPEED/4)
                while joker.ability.extra.counter_dt > 1 do
                    joker.ability.extra.counter_dt = joker.ability.extra.counter_dt - 1
                    joker.ability.extra.counter = joker.ability.extra.counter - joker.ability.extra.tick_down
                end

                if joker.ability.extra.counter <= 0 and not (joker.ability.extra.dead or false) then
                    joker.ability.extra.dead = true
                    SMODS.destroy_cards(joker, true, nil, true)
                    card_eval_status_text(joker, 'extra', nil, nil, nil, {message = "Ding!", colour = G.C.RED})
                    if G.GAME.modifiers.overclocked then
                        G.STATE = G.STATES.GAME_OVER
                        if not G.GAME.won and not G.GAME.seeded and not G.GAME.challenge then
                            G.PROFILES[G.SETTINGS.profile].high_scores.current_streak.amt = 0
                        end
                        G:save_settings()
                        G.FILE_HANDLER.force = true
                        G.STATE_COMPLETE = false
                    end
                end
            end
        end
    end
end