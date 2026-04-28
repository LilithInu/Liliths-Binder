
SMODS.Joker{ --Collector
    key = "collector",
    config = {
        extra = {
            xmult = 1.5,
            list = { 14, 13, 12, 11, 10, 9, 8, 7, 6, 5, 4, 3, 2 },
            visual_list = { 14, 13, 12, 11, 10, 9, 8, 7, 6, 5, 4, 3, 2 },
        }
    },
    loc_txt = {
        ['name'] = 'Collector',
        --[[['text'] = {
            '{X:mult,C:white} X#1# {} Mult for every',
            '{C:attention}unique rank{} scored this ante',
            "{s:0.7,C:inactive} #2# {}",
        },]]--
        --[[['text'] = {
            '{X:mult,C:white} X#1# {} Mult for every',
            '{C:attention}unique rank{} scored this ante',
            "{s:0.7,C:inactive} #2# {}",
        },]]--
        ['text'] = {
            --'{X:mult,C:white} X#1# {} Mult for',
            --'each {C:attention}unique rank{}',
            --'scored this ante',
            --'{s:0.7,C:inactive} #2# {}',

            'Each playing card {C:attention}rank',
            'gives {X:mult,C:white}X#1#{} Mult when',
            'first scored this Ante'

            --'Each played card gives',
            --'{X:mult,C:white}X#1#{} Mult if {C:attention}rank{} scored',
            --'for the first time this Ante'
        },
        ['unlock'] = {
            [1] = 'Unlocked by default.'
        }
    },
    pos = {
        x = 8,
        y = 0,
        --draw = function(self, card) --don't draw shine
        --end,
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
        text = "("
        -- iterate the array
        for i = 1, #card.ability.extra.list do
            list_rank = card.ability.extra.list[i]
            if list_rank == 14 then list_rank = 'A'
            elseif list_rank == 13 then list_rank = 'K'
            elseif list_rank == 12 then list_rank = 'Q'
            elseif list_rank == 11 then list_rank = 'J' end
            text = text .. list_rank
            if i ~= #card.ability.extra.list then
                text = text .. ', '
            end
        end
        text = text .. ')'
        if #card.ability.extra.list < 1 then
            text = 'All collected!'
        end

        local text_top = nil
        local text_bot = nil
        local text_cutoff = 20
        local text_len = string.len(text)

        if text_len > text_cutoff then
            while string.sub(text, text_cutoff, text_cutoff) ~= " " and text_cutoff < text_len do
                text_cutoff = text_cutoff + 1
            end
            text_top = string.sub(text, 1, text_cutoff - 1)
            text_bot = string.sub(text, text_cutoff + 1)
        else
            text_top = text
        end

        local main_end = {}
        local line_height = 0.32 --* 0.8--0.7

        if text_top then
            table.insert(main_end,
                {n = G.UIT.R, config = { align = "cm" }, nodes = {
                    { n = G.UIT.T, config = {text = text_top, colour = G.C.UI.TEXT_INACTIVE, scale = line_height} },
                }}
            )
        end

        if text_bot then
            table.insert(main_end, {n = G.UIT.R, config = { align = "cm" }, nodes = {
                {n = G.UIT.B, config = {w = 1, h = 0.03}}
            }})

            table.insert(main_end,
                {n = G.UIT.R, config = { align = "cm" }, nodes = {
                    { n = G.UIT.T, config = {text = text_bot, colour = G.C.UI.TEXT_INACTIVE, scale = line_height} },
                }}
            )
        end

        return {
            vars = { card.ability.extra.xmult, text },
            main_end = {{n = G.UIT.C, config = { align = "cm" }, nodes = main_end}}
            --main_end
        }
    end,
    
    calculate = function(self, card, context)
        card.extra = (card.extra or {scored = {}})

        if context.individual and context.cardarea == G.play then
            if isInArray(card.ability.extra.list, context.other_card:get_id()) or card.extra.scored[context.other_card] then
                card.extra.scored[context.other_card] = true -- Allows retriggers

                table.remove(card.ability.extra.list, findIndex(card.ability.extra.list, context.other_card:get_id()))

                local rank = context.other_card:get_id()
                local list = card.ability.extra.visual_list
                G.E_MANAGER:add_event(Event({
                    func = function()
                        table.remove(list, findIndex(list, rank))
                        return true
                    end,
                }))
                return {
                    Xmult = card.ability.extra.xmult
                }
            end
        end
        if context.final_scoring_step then
            card.extra.scored = {}
        end
        if context.ante_end and not context.blueprint and #card.ability.extra.list < 13 then
            card.ability.extra.list = { 14, 13, 12, 11, 10, 9, 8, 7, 6, 5, 4, 3, 2 }
            --card.extra.scored = {}
            G.E_MANAGER:add_event(Event({
                func = function()
                    card.ability.extra.visual_list = { 14, 13, 12, 11, 10, 9, 8, 7, 6, 5, 4, 3, 2 }
                    return true
                end,
            }))
            return {
				message = 'Reset!',
				colour = G.C.FILTER,
				card = card
			}
        end
    end,

    --[[set_sprites = function(self, card, front)
        card.children.collected_card = Sprite(card.T.x-40, card.T.y, card.T.w*2, card.T.h, G.ASSET_ATLAS[self.atlas], {x = 1, y = 0})
        card.children.collected_card.role.draw_major = card
        card.children.collected_card.states.hover.can = false
        card.children.collected_card.states.click.can = false
    end]]--
}

SMODS.DrawStep{
    key = 'collector_extra',
    order = 25,
    func = function(self)
        --sendInfoMessage(inspect(self), "lily")
        if G.collector_sprite and self.config and self.config.center_key and self.config.center_key == "j_lilithsb_collector" then
            for i = 1, #G.collector_sprite do
                local rank = i
                if rank == 1 then rank = 14 end
                if (self.ability.extra.visual_list and not isInArray(self.ability.extra.visual_list, rank)) or not self.ability.extra.visual_list then
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

                    G.collector_sprite[i].role.draw_major = self

                    G.collector_sprite[i]:draw_shader(shader or 'dissolve', nil, send, nil, self.children.center)

                    if edition and edition.negative then
                        G.collector_sprite[i]:draw_shader('negative_shine', nil, send, nil, self.children.center)
                    end
                end
            end
        end
    end,
    conditions = {vortex = false, facing = 'front'},
}

isInArray = function (array, item)
    for i = 1, #array do
        if array[i] == item then
            return true
        end
    end
    return false
end

findIndex = function (array, item)
    for i = 1, #array do
        if array[i] == item then
            return i
        end
    end
    return -1
end