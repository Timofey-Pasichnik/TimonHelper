th.target_list = {}

local involved_targets = CreateFrame('Frame')
involved_targets:RegisterEvent('RAW_COMBATLOG')
involved_targets:SetScript('OnEvent', function()
    --print(arg1)
    --print(arg2)
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
    --th.IsAOEMode()
    th.SetMarks()
end)

local clear_target_list = CreateFrame('Frame')
clear_target_list:RegisterEvent('PLAYER_REGEN_ENABLED')
clear_target_list:SetScript('OnEvent', function()
    th.target_list = {}
    th.hostile_targets = 0
    print('Clearing table. Targets now: ' .. th.hostile_targets)
end)

function EditHostileTargetTable(participant, action)
    if participant
            and UnitExists(participant)
            and UnitReaction(participant, th.me) < 5
            and not UnitIsDead(participant)
            and UnitAffectingCombat(participant)
            and (UnitHealth(participant) == UnitHealthMax(participant) or UnitIsTappedByPlayer(participant))
            and not th.target_list[participant]
    then
        th.target_list[participant] = participant
        th.hostile_targets = th.hostile_targets + 1
        print('Adding target. Targets now: ' .. th.hostile_targets)
    end
    if action == 'CHAT_MSG_COMBAT_HOSTILE_DEATH' and th.target_list[participant] then
        th.target_list[participant] = nil
        th.hostile_targets = th.hostile_targets - 1
        print('NPC dead. Targets now: ' .. th.hostile_targets)
    end
end

function th.SetMarks()
    local skull_guid = nil
    local moon_guid = nil
    if th.hostile_targets == 0 and UnitExists(he) then
        skull_guid = th.ExtractGUIDFromUnitName(he)
    end
    if th.hostile_targets == 1 and next(th.target_list) and UnitExists(next(th.target_list)) and not UnitIsDead(next(th.target_list)) then
        skull_guid = next(th.target_list)
    end
    if th.hostile_targets > 1 then
        local lowest_monster_hp = 1000000000
        local highest_monster_hp = 0
        for target in th.target_list do
            if UnitExists(target) and not UnitIsDead(target) then
                if UnitHealth(target) < lowest_monster_hp and target ~= th.ExtractGUIDFromUnitName('mark5') then
                    lowest_monster_hp = UnitHealth(target)
                    skull_guid = target
                end
                if UnitHealth(target) > highest_monster_hp and (UnitCreatureType(target) == 'Humanoid' or UnitCreatureType(target) == 'Beast') then
                    highest_monster_hp = UnitHealth(target)
                    moon_guid = target
                end
            end
        end
    end
    if skull_guid then
        SetRaidTarget(skull_guid, 8) --skull
    end
    if moon_guid and (not UnitExists('mark5') or UnitIsDead('mark5')) then
        SetRaidTarget(moon_guid, 5) -- moon
    end
end

