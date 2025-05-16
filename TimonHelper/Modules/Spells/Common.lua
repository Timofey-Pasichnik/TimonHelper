print('Common.lua loaded')

common_spells = {
    attack = {
        action_slot = 25,
        race = races.all,
        level = 1,
        ignored_npc = {},
        ignored_types = {},
        type = spell_types.auto_attack,
        name = 'Attack',
        combat = false,
        range = ranges.melee
    },
    blood_fury = {
        action_slot = 61,
        races = races.orc,
        level = 1,
        ignored_npc = {},
        ignored_types = {},
        type = spell_types.buff,
        name = 'Blood Fury',
        combat = true,
        range = ranges.self
    }
}

function go_blood_fury()
    if my_race == races.orc then
        DoAction(common_spells.blood_fury)
    end
end

local raw_combat_log = CreateFrame("Frame")
raw_combat_log:RegisterEvent("RAW_COMBATLOG")
raw_combat_log:SetScript("OnEvent", function()
    --print(arg1)
    if arg1 == 'CHAT_MSG_COMBAT_CREATURE_VS_SELF_HITS' then
        print('kek')
        hexValue = string.match(arg2, "^0x%x+")
        print(hexValue)
    end
    --print(arg1)
    --print(arg2)
end)

aoe_mode = false
function switch_aoe()
    if aoe_mode then
        aoe_mode = false
        print('AOE mode OFF')
    else
        aoe_mode = true
        print('AOE mode ON')
    end
end