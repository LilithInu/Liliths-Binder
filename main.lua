LilithUtil = {}

SMODS.Atlas({
    key = "modicon", 
    path = "ModIcon.png", 
    px = 34,
    py = 34,
    atlas_table = "ASSET_ATLAS"
})

SMODS.Atlas({
    key = "balatro", 
    path = "balatro.png", 
    px = 333,
    py = 216,
    prefix_config = { key = false },
    atlas_table = "ASSET_ATLAS"
})

SMODS.Atlas({
    key = "CustomJokers", 
    path = "CustomJokers.png", 
    px = 71,
    py = 95, 
    atlas_table = "ASSET_ATLAS"
})

SMODS.Atlas({
    key = "CollectorCard", 
    path = "CollectorCard.png", 
    px = 71,
    py = 95, 
    atlas_table = "ASSET_ATLAS"
})

SMODS.Atlas({
    key = "MarxWings", 
    path = "MarxWings.png", 
    px = 103,
    py = 95, 
    atlas_table = "ASSET_ATLAS"
})

local NFS = require("nativefs")
to_big = to_big or function(a) return a end
lenient_bignum = lenient_bignum or function(a) return a end

local jokerIndexList = {2,1,4,3}

local function load_jokers_folder()
    --[[local mod_path = SMODS.current_mod.path
    local jokers_path = mod_path .. "/jokers"
    local files = NFS.getDirectoryItemsInfo(jokers_path)
    for i = 1, #jokerIndexList do
        local file_name = files[jokerIndexList[i] ].name
        if file_name:sub(-4) == ".lua" then
            assert(SMODS.load_file("jokers/" .. file_name))()
        endm
    end--]]
    assert(SMODS.load_file("jokers/receipt.lua"))()
    assert(SMODS.load_file("jokers/timer.lua"))()
    assert(SMODS.load_file("jokers/syzygy.lua"))()
    assert(SMODS.load_file("jokers/sleight.lua"))()
    assert(SMODS.load_file("jokers/collector.lua"))()
    assert(SMODS.load_file("jokers/triple_seven.lua"))()
    assert(SMODS.load_file("jokers/wild_joker.lua"))()
    assert(SMODS.load_file("jokers/legacy.lua"))()
    assert(SMODS.load_file("jokers/limited.lua"))()
    assert(SMODS.load_file("jokers/go_fish.lua"))()
    assert(SMODS.load_file("jokers/estrogen.lua"))()
    assert(SMODS.load_file("jokers/lilith.lua"))()
    assert(SMODS.load_file("jokers/marx.lua"))()
    assert(SMODS.load_file("jokers/dimentio.lua"))()
    assert(SMODS.load_file("jokers/jevil.lua"))()
end

--[[local consumableIndexList = {1}

local function load_consumables_folder()
    local mod_path = SMODS.current_mod.path
    local consumables_path = mod_path .. "/consumables"
    local files = NFS.getDirectoryItemsInfo(consumables_path)
    local set_file_number = #files + 1
    for i = 1, #files do
        if files[i].name == "sets.lua" then
            assert(SMODS.load_file("consumables/sets.lua"))()
            set_file_number = i
        end
    end    
    for i = 1, #consumableIndexList do
        local j = consumableIndexList[i]
        if j >= set_file_number then 
            j = j + 1
        end
        local file_name = files[j].name
        if file_name:sub(-4) == ".lua" then
            assert(SMODS.load_file("consumables/" .. file_name))()
        end
    end
end

local deckIndexList = {1}

local function load_decks_folder()
    local mod_path = SMODS.current_mod.path
    local decks_path = mod_path .. "/decks"
    local files = NFS.getDirectoryItemsInfo(decks_path)
    for i = 1, #deckIndexList do
        local file_name = files[deckIndexList[i] ].name
        if file_name:sub(-4) == ".lua" then
            assert(SMODS.load_file("decks/" .. file_name))()
        end
    end
end]]--

local function load_challenges()
    assert(SMODS.load_file("challenges/list.lua"))()
end

load_jokers_folder()
--load_consumables_folder()
--load_decks_folder()
load_challenges()

SMODS.current_mod.optional_features = function()
    return {
        cardareas = {} 
    }
end

-- Load sprites
local oldmainmenu = Game.main_menu
function Game:main_menu(change_context)
    local g = oldmainmenu(self, change_context)

    local width_pos = 10
    G.collector_sprite = {}
    for i = 1, 13 do
        foo = {}
        G.collector_sprite[i] = SMODS.create_sprite(0, 0, G.CARD_W, G.CARD_H, 'lilithsb_CollectorCard', {x = (i-1) % width_pos, y = math.floor((i-1) / width_pos)})
    end
    --G.collector_sprite = SMODS.create_sprite(0, 0, G.CARD_W, G.CARD_H, 'lilithsb_CollectorCard', {x = 0, y = 0})

    G.marx_wings_sprite = SMODS.create_sprite(16, 0, 103, G.CARD_H, 'lilithsb_MarxWings', {x = 0, y = 0})

    G.timer_dial_sprite = SMODS.create_sprite(0, 0, G.CARD_W, G.CARD_W, 'lilithsb_CustomJokers', {x = 4, y = 1})

    return g
end

function LilithUtil.banned_joker(center)
    if center and center.set == 'Joker' and next(SMODS.find_card('j_lilithsb_limited')) then
        --printAllFields(SMODS.find_card('j_lilithsb_limited')[1])
        --printAllFields(center.key)
        local limited_list = SMODS.find_card('j_lilithsb_limited')
        for k, v in pairs(limited_list) do
            --sendInfoMessage("k " .. k .. "; vtype " .. type(v), "lily")
            --printAllFields(v.ability.extram)
            -- Ban the card if it's in at least one of the limited jokers
            --printAllFields(v.ability.extra.banned)
            --sendInfoMessage(center.key, "lily")
            if LilithUtil.isInArray(v.ability.extra.banned, center.key) then
                --sendInfoMessage("Card banned" .. center.key, "lily")
                return true
            end
        end
        --G.jokers.cards[next(SMODS.find_card('j_lilithsb_limited'))].ability.extra.hi = 3
        --next(SMODS.find_card('j_lilithsb_limited')).ability.extra.hi = 3
        --sendInfoMessage(printObj(SMODS.find_card('j_lilithsb_limited'),4,""), "MyInfoLogger")
    end
    return false
end

function LilithUtil.card_created(card)
    --printAllFields(card.ability)
    --sendInfoMessage("Card created" .. card.ability.set, "lily")
    if card.ability.set == "Joker" then
        local limited_list = SMODS.find_card('j_lilithsb_limited')
        for k, v in pairs(limited_list) do
            -- Add the new card to the list of the banned ones
            v.ability.extra.banned[#v.ability.extra.banned+1] = card.config.center.key
            --sendInfoMessage(readableTable(v.ability.extra.banned), "lily")
            --LilithUtil.isInArray(v.ability.extra.banned, center.key)
        end
    end
end

function LilithUtil.whenPoolEmpty(_type, rarity, _legendary, _append)
    if _type == 'Joker' and next(SMODS.find_card('j_lilithsb_limited')) and rarity < 3 and not _legendary then
        return true
    end
end

-- Reroll the joker if it's rarity pool is empty to be a level above (Jimbo if already rare/legendary)
function LilithUtil.doPoolReroll(_type, rarity, _legendary, _append)
    old_rarity = rarity
    rarity = (rarity == 1 and "Uncommon") or (rarity == 2 and "Rare") or "Rare"
    --sendInfoMessage(old_rarity .. " -> " .. rarity, "lily")
    return get_current_pool(_type, rarity, _legendary, _append)
end

function LilithUtil.isInArray(array, item)
    for i = 1, #array do
        if array[i] == item then
            return true
        end
    end
    return false
end
