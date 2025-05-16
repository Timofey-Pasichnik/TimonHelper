print('Common.lua loaded')

targets = {}
targets_counter = 0

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
    print('counter is: ' .. targets_counter)
    for guid in pairs(targets) do
        local counter = 0
        --print(guid)
        if UnitExists(guid) == 0 or UnitIsDead(guid) == 1 then
            targets[guid] = nil
        else
            counter = counter + 1
            targets_counter = counter
            --else
            --    targets[guid] = nil
        end
    end
    if arg1 == 'CHAT_MSG_COMBAT_CREATURE_VS_SELF_HITS' or arg1 == 'CHAT_MSG_COMBAT_CREATURE_VS_SELF_HITS' then
        local start_pos, end_pos = string.find(arg2, "^0x[0-9A-Fa-f]+")
        if start_pos then
            local guid = string.sub(arg2, start_pos, end_pos)
            targets[guid] = GetTime()
            --print(guid .. 'added')
        end
    --    else if arg1 == 'CHAT_MSG_COMBAT_HOSTILE_DEATH' then
    --    --print(arg2)
    --    local start_pos, end_pos = string.find(arg2, "0x[0-9A-Fa-f]+")
    --    if start_pos then
    --        local guid = string.sub(arg2, start_pos, end_pos)
    --        targets[guid] = nil
    --        --print(guid .. 'is dead')
    --    end
    --end
    end
    --    print('kek')
    --    print('arg1 ' .. arg1)
    --    print('arg2 ' .. arg2)
    --    local start_pos, end_pos = string.find(arg2, "^0x[0-9A-Fa-f]+")
    --    if start_pos then
    --        local hexValue = string.sub(arg2, start_pos, end_pos)
    --        print(hexValue)
    --    end
    --end
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