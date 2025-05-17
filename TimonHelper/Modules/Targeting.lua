th.target_list = {}

local involved_targets = CreateFrame('Frame')
involved_targets:RegisterEvent('RAW_COMBATLOG')
involved_targets:SetScript('OnEvent', function()
    print(arg1)
    print(arg2)
    local participants = {}
    local first_participant = th.match(arg2, '0x[A-Z0-9]+', 1)
    if first_participant then
        table.insert(participants, first_participant)
    end
    local second_participant = th.match(arg2, '0x[A-Z0-9]+', 2)
    if second_participant then
        table.insert(participants, second_participant)
    end
    for _, participant in ipairs(participants) do
        EditHostileTargetTable(participant, arg1)
    end
    th.IsAOEMode()
    th.SetMarks()
end)

local clear_target_list = CreateFrame('Frame')
clear_target_list:RegisterEvent('PLAYER_REGEN_ENABLED')
clear_target_list:SetScript('OnEvent', function()
    th.target_list = {}
    print('wiping table')
end)

function EditHostileTargetTable(participant, action)
    if participant
            and UnitExists(participant)
            and UnitReaction(participant, me) < 5
            and not UnitIsDead(participant)
            and UnitAffectingCombat(participant)
            and UnitIsTappedByPlayer(participant)
            and not th.target_list[participant]
    then
        th.target_list[participant] = participant
        print(participant .. ' added')
    end
    if action == 'CHAT_MSG_COMBAT_HOSTILE_DEATH' and th.target_list[participant] then
        th.target_list[participant] = nil
    end
end

function th.SetMarks()
    if th.hostile_targets == 0 and UnitExists(he) then
        SetRaidTarget(he, 8)
    else
        for item in th.target_list do
            if UnitExists(item) and not UnitIsDead(item) then
                if th.hostile_targets == 1 then
                    highest_hp_id = item
                else
                    if th.hostile_targets > 1 and not UnitExists('mark5') then
                        local lowest_monster_hp = 1000000000
                        local lowest_hp_id = ''
                        local highest_monster_hp = 0
                        local highest_hp_id = ''
                        if UnitHealth(item) < lowest_monster_hp then
                            lowest_monster_hp = UnitHealth(item)
                            lowest_hp_id = item
                        end
                        if UnitHealth(item) > highest_monster_hp and item ~= lowest_hp_id then
                            highest_monster_hp = UnitHealth(item)
                            highest_hp_id = item
                        end
                    end
                end
            end
        end
        if highest_hp_id then
            SetRaidTarget(highest_hp_id, 8) --skull
        end
        if lowest_hp_id and not UnitExists('mark5') then
            SetRaidTarget(lowest_hp_id, 5) --moon
        end
    end
end

