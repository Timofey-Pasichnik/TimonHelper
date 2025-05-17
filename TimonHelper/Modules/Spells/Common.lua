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
    local counter = 0
    for _ in pairs(targets) do
        counter = counter + 1
    end
    print('counter is: ' .. targets_counter)
    targets_counter = counter
    if targets_counter > 1 then
        aoe_mode = true
    else
        aoe_mode = false
    end

    if arg1 == 'CHAT_MSG_COMBAT_CREATURE_VS_SELF_HITS' or arg1 == 'CHAT_MSG_COMBAT_CREATURE_VS_SELF_HITS' then
        local start_pos, end_pos = string.find(arg2, "^0x[0-9A-Fa-f]+")
        if start_pos then
            local guid = string.sub(arg2, start_pos, end_pos)
            targets[guid] = GetTime()
        end
    else
        if arg1 == 'CHAT_MSG_COMBAT_HOSTILE_DEATH' then
            local start_pos, end_pos = string.find(arg2, "0x[0-9A-Fa-f]+")
            if start_pos then
                local guid = string.sub(arg2, start_pos, end_pos)
                targets[guid] = nil
            end
        end
    end
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