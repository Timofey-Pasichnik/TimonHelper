th.targets = {
    closest = {},
    close = {},
    far = {},
    farther = {},
    farthest = {},
    all_ranges = {},
    counters = {
        all_ranges = 0,
        closest = 0,
        close = 0,
        far = 0,
        farther = 0,
        farthest = 0
    }
}

local cc_priority_list = {
    ['Ragefire Chasm'] = {
        ['Ragefire Shaman'] = 1
    }
}

--local function CanAddTargetToTargetsList(target)
--    return target
--            and UnitExists(target)
--            and UnitReaction(target, th.me) < 5
--            and not UnitIsDead(target)
--            and UnitAffectingCombat(target)
--            and (UnitHealth(target) == UnitHealthMax(target) or UnitIsTappedByPlayer(target))
--            and not th.target_list.all_ranges[target].guid
--end

local function CanAttackFightingTarget(target)
    return target
            and UnitExists(target)
            and UnitReaction(target, th.me) < 5
            and not UnitIsDead(target)
            and UnitAffectingCombat(target)
end

--local function CanAttackNonFightingTarget(target)
--    return UnitExists(target)
--            and UnitReaction(target, th.me) < 5
--            and not UnitIsDead(target)
--            and not UnitAffectingCombat(target)
--end

local involved_targets = CreateFrame('Frame')
involved_targets:RegisterEvent('RAW_COMBATLOG')
involved_targets:SetScript('OnEvent', function()
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
    --if not th.targets.counters.all_ranges == 0 then
        th.targets = {
            closest = {},
            close = {},
            far = {},
            farther = {},
            farthest = {},
            all_ranges = {},
            counters = {
                all_ranges = 0,
                closest = 0,
                close = 0,
                far = 0,
                farther = 0,
                farthest = 0
            }
        }
        --print(string.format('Clearing table. Targets now: total: %s, closest: %s, close: %s, far: %s, farther: %s, farthest: %s',
        --        th.targets.counters.all_ranges,
        --        th.targets.counters.closest,
        --        th.targets.counters.close,
        --        th.targets.counters.far,
        --        th.targets.counters.farther,
        --        th.targets.counters.farthest)
        --)
    --end
end)

function EditHostileTargetTable(participant, action)
    if CanAttackFightingTarget(participant) then
        local distance_name, distance_index = th.CurrentDistanceToTarget(participant)
        if not th.targets.all_ranges[participant] then
            --check if target not in list and calculate distance
            th.targets.all_ranges[participant] = {}
            th.targets[distance_name][participant] = {}
            th.targets.all_ranges[participant].guid = participant
            th.targets.counters.all_ranges = th.targets.counters.all_ranges + 1
            th.targets[distance_name][participant].guid = participant
            th.targets.all_ranges[participant].range = distance_index
            th.targets.counters[distance_name] = th.targets.counters[distance_name] + 1
            print(string.format('Added target. Targets now: total: %s, closest: %s, close: %s, far: %s, farther: %s, farthest: %s',
                    th.targets.counters.all_ranges,
                    th.targets.counters.closest,
                    th.targets.counters.close,
                    th.targets.counters.far,
                    th.targets.counters.farther,
                    th.targets.counters.farthest)
            )
        else
            local current_range_in_table_int = th.targets.all_ranges[participant].range
            local current_range_in_table_name = th.ranges.backward[current_range_in_table_int]
            if current_range_in_table_int ~= distance_index then
                --check if target in list changed their distance
                if not th.targets[distance_name][participant] then
                    th.targets[distance_name][participant] = {}
                end
                th.targets.all_ranges[participant].range = distance_index
                th.targets[current_range_in_table_name][participant].guid = nil
                th.targets.counters[current_range_in_table_name] = th.targets.counters[current_range_in_table_name] - 1
                th.targets[distance_name][participant].guid = participant
                th.targets.counters[distance_name] = th.targets.counters[distance_name] + 1
                print(string.format('Target changed range. Targets now: total: %s, closest: %s, close: %s, far: %s, farther: %s, farthest: %s',
                        th.targets.counters.all_ranges,
                        th.targets.counters.closest,
                        th.targets.counters.close,
                        th.targets.counters.far,
                        th.targets.counters.farther,
                        th.targets.counters.farthest)
                )
            end
        end

    end
    if action == 'CHAT_MSG_COMBAT_HOSTILE_DEATH' and th.targets.all_ranges[participant] then
        --if target dies, remove it from all target lists and unassign raid mark
        local current_range_in_table_int = th.targets.all_ranges[participant].range
        local current_range_in_table_name = th.ranges.backward[current_range_in_table_int]
        th.targets.all_ranges[participant] = nil
        th.targets.counters.all_ranges = th.targets.counters.all_ranges - 1
        th.targets[current_range_in_table_name][participant] = nil
        th.targets.counters[current_range_in_table_name] = th.targets.counters[current_range_in_table_name] - 1
        print(string.format('Target dead. Targets now: total: %s, closest: %s, close: %s, far: %s, farther: %s, farthest: %s',
                th.targets.counters.all_ranges,
                th.targets.counters.closest,
                th.targets.counters.close,
                th.targets.counters.far,
                th.targets.counters.farther,
                th.targets.counters.farthest)
        )
        SetRaidTarget(participant, 0)
        if UnitExists(th.he) and th.ExtractGUIDFromUnitName(th.he) == participant then
            ClearTarget()
        end
    end
end

function th.SetMarks()
    local skull_int = 8
    local moon_int = 5
    local diamond_int = 3
    local skull_str = 'mark8'
    local moon_str = 'mark5'
    local diamond_str = 'mark3'
    local skull_guid
    local moon_guid
    local diamond_guid
    if UnitExists(skull_str) and not UnitIsDead(skull_str) then
        skull_guid = th.ExtractGUIDFromUnitName(skull_str)
    end
    if UnitExists(moon_str) and not UnitIsDead(moon_str) then
        moon_guid = th.ExtractGUIDFromUnitName(moon_str)
    end
    if UnitExists(diamond_str) and not UnitIsDead(diamond_str) then
        diamond_guid = th.ExtractGUIDFromUnitName(diamond_str)
    end
    if th.targets.counters.all_ranges == 0 and CanAttackFightingTarget(th.he) then
        SetRaidTarget(th.he, skull_int)
    elseif th.targets.counters.all_ranges == 1 then
        SetRaidTarget(next(th.targets.all_ranges), skull_int)
    elseif th.targets.counters.all_ranges > 1 then
        for guid in th.targets.all_ranges do
            if not moon_guid and cc_priority_list[GetZoneText()][UnitName(guid)] then
                moon_guid = guid
                SetRaidTarget(moon_guid, moon_int)
                break
            elseif moon_guid and cc_priority_list[GetZoneText()][UnitName(guid)] and not cc_priority_list[GetZoneText()][UnitName(moon_guid)] then
                moon_guid = guid
                SetRaidTarget(moon_guid, moon_int)
                break
            elseif not skull_guid and (th.targets.closest[guid] or th.targets.close[guid]) and (not moon_guid or moon_guid ~= guid) then
                skull_guid = guid
                SetRaidTarget(skull_guid, skull_int)
                break
            elseif not moon_guid and (UnitCreatureType(guid) == 'Humanoid' or UnitCreatureType(guid) == 'Beast') then
                moon_guid = guid
                SetRaidTarget(moon_guid, moon_int)
                break
            elseif not moon_guid and (not skull_guid or guid ~= skull_guid) then
                moon_guid = guid
                SetRaidTarget(moon_guid, moon_int)
                break
            end
        end
    end
end

--        if not moon_guid then
--            --print('test')
--            if 1 == 1 then
--                for guid in th.targets.all_ranges do
--                    if cc_priority_list[UnitName(guid)] then
--                        moon_guid = guid
--                        SetRaidTarget(moon_guid, moon_int)
--                        break
--                    end
--                end
--            elseif th.targets.counters.closest == 1 and next(th.targets.closest) and not UnitIsDead(next(th.targets.closest)) then
--                skull_guid = next(th.targets.closest)
--                SetRaidTarget(skull_guid, skull_int)
--                for guid in th.targets.all_ranges do
--                    if guid ~= skull_guid then
--                        moon_guid = guid
--                        SetRaidTarget(moon_guid, moon_int)
--                        break
--                    end
--                end
--            end
--        else
--            for guid in th.targets.all_ranges do
--                if guid ~= moon_guid then
--                    skull_guid = guid
--                    SetRaidTarget(skull_guid, skull_int)
--                    break
--                end
--            end
--        end
--    elseif th.targets.counters.all_ranges == 3 then
--        if moon_guid and skull_guid and not diamond_guid then
--            for guid in th.targets.all_ranges do
--                if (guid ~= moon_guid and guid ~= skull_guid) then
--                    diamond_guid = guid
--                    SetRaidTarget(diamond_guid, diamond_int)
--                    break
--                end
--            end
--        end
--    end
--end
--    local skull_guid = nil
--    local moon_guid = nil
--    local skull_id = 8
--    local moon_id = 5
--
--    if th.hostile_targets == 0 then
--        if CanAttackNonFightingTarget(th.he) then
--            skull_guid = th.ExtractGUIDFromUnitName(th.he)
--        end
--    end
--    if th.hostile_targets == 1 then
--        if next(th.target_list) then
--            local target =  next(th.target_list)
--            if CanAttackFightingTarget(target) then
--                skull_guid = th.ExtractGUIDFromUnitName(th.he)
--            end
--        end
--    end
--    if th.hostile_targets > 1 then --set moon first in this case
--        for target in th.target_list do
--            --if not CheckInteractDistance(target, th.ranges.closest) and
--
--        end
--        local close_range_index = 3--farthest 4, then 2, then 1 and closest is 3
--        local appropriate_skull_target
--        for target in th.target_list do
--            if CheckInteractDistance(target, close_range_index)
--
--            end
--        end
--    end
--    if skull_guid then
--        SetRaidTarget(skull_guid, skull_id)
--    end
--    ----set up skull
--    --if th.hostile_targets == 0 and UnitExists(he) then
--    --    skull_guid = th.ExtractGUIDFromUnitName(he)
--    --end
--    --
--    --if th.hostile_targets == 1 and next(th.target_list) and UnitExists(next(th.target_list)) and not UnitIsDead(next(th.target_list)) then
--    --    skull_guid = next(th.target_list)
--    --end
--    --
--    --if th.hostile_targets > 1 then
--    --    local lowest_monster_hp = 1000000000
--    --    local highest_monster_hp = 0
--    --    for target in th.target_list do
--    --        if UnitExists(target) and not UnitIsDead(target) then
--    --            if UnitHealth(target) < lowest_monster_hp and target ~= th.ExtractGUIDFromUnitName('mark5') then
--    --                lowest_monster_hp = UnitHealth(target)
--    --                skull_guid = target
--    --            end
--    --            if UnitHealth(target) > highest_monster_hp and (UnitCreatureType(target) == 'Humanoid' or UnitCreatureType(target) == 'Beast') then
--    --                highest_monster_hp = UnitHealth(target)
--    --                moon_guid = target
--    --            end
--    --        end
--    --    end
--    --end
--    --if skull_guid then
--    --    SetRaidTarget(skull_guid, 8) --skull
--    --end
--    --if moon_guid and (not UnitExists('mark5') or UnitIsDead('mark5')) then
--    --    SetRaidTarget(moon_guid, 5) -- moon
--    --end
--end