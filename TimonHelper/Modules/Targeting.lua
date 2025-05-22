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
        ['Oggleflint'] = 2,
        ['Ragefire Shaman'] = 1
    }
}

local function CanAttackFightingTarget(target)
    return target
            and UnitExists(target)
            and UnitReaction(target, th.me) < 5
            and not UnitIsDead(target)
            and UnitAffectingCombat(target)
end

function CanAttackTarget(target)
    return target
            and UnitExists(target)
            and UnitReaction(target, th.me) < 5
            and not UnitIsDead(target)
end

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
    th.SetMarks()
end)

local clear_target_list = CreateFrame('Frame')
clear_target_list:RegisterEvent('PLAYER_REGEN_ENABLED')
clear_target_list:SetScript('OnEvent', function()
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
    if action == 'CHAT_MSG_COMBAT_HOSTILE_DEATH' then
        SetRaidTarget(participant, 0)
        if UnitExists(th.he) and th.ExtractGUIDFromUnitName(th.he) == participant then
            ClearTarget()
        end
        if th.targets.all_ranges[participant] then
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
        end
    end
end


local lowest_monster_hp

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
        skull_guid = th.ExtractGUIDFromUnitName(th.he)
        SetRaidTarget(skull_guid, skull_int)
        lowest_monster_hp = UnitHealth(th.he)
    elseif th.targets.counters.all_ranges == 1 then
        skull_guid = next(th.targets.all_ranges)
        lowest_monster_hp = UnitHealth(skull_guid)
    elseif th.targets.counters.all_ranges > 1 then
        for guid in th.targets.all_ranges do
            if not moon_guid and cc_priority_list[GetZoneText()][UnitName(guid)] then
                moon_guid = guid
                break
            elseif moon_guid and cc_priority_list[GetZoneText()][UnitName(guid)] and not cc_priority_list[GetZoneText()][UnitName(moon_guid)] then
                moon_guid = guid
                break
            elseif moon_guid and cc_priority_list[GetZoneText()][UnitName(guid)]
                    and cc_priority_list[GetZoneText()][UnitName(moon_guid)]
                    and cc_priority_list[GetZoneText()][UnitName(guid)] > cc_priority_list[GetZoneText()][UnitName(moon_guid)] then
                moon_guid = guid
                break
            elseif not moon_guid and (UnitCreatureType(guid) == 'Humanoid' or UnitCreatureType(guid) == 'Beast') then
                moon_guid = guid
                break
            elseif not moon_guid and (not skull_guid or guid ~= skull_guid) then
                moon_guid = guid
                break
            elseif not skull_guid and (th.targets.closest[guid] or th.targets.close[guid]) and (not moon_guid or moon_guid ~= guid) and not lowest_monster_guid and UnitHealth(guid) > 0 then
                skull_guid = guid
                lowest_monster_hp = UnitHealth(guid)
            elseif skull_guid and (th.targets.closest[guid] or th.targets.close[guid]) and (not moon_guid or moon_guid ~= guid) and UnitHealth(guid) < UnitHealth(skull_guid) and UnitHealth(guid) > 0 then
                skull_guid = guid
                lowest_monster_hp = UnitHealth(guid)
            end
        end
        if moon_guid then SetRaidTarget(moon_guid, moon_int) end
    end
    if skull_guid then SetRaidTarget(skull_guid, skull_int) end

end