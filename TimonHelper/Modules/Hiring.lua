local current_party = {
    counter = 0,
    setup = {}
}

local type_of_group

local presets_types = {
    dungeon = 'dungeon'
}

function th.FillCurrentPartyTable()
    --print('ima filin script')
    local party_members = GetNumPartyMembers()
    local raid_members = GetNumRaidMembers()
    local no_party_members = party_members == 0
    local no_raid_members = raid_members == 0
    local alone = no_party_members and no_raid_members
    local event_duplicate = alone and current_party.counter == 1
            or not alone and no_raid_members and party_members == current_party.counter - 1
            or not alone and not no_raid_members and raid_members == current_party.counter
    if not event_duplicate then
        if raid_members == 0 and party_members == 0 and current_party.counter == 0 then
            current_party.counter = 1
            current_party.setup[th.my_name] = {
                race = th.my_race,
                class = th.my_class,
                is_bot = nil,
                name = th.my_name,
                level = th.my_level,
                role = 'player',
                spec = 'player'
            }
        end
        if raid_members == 0 and party_members > 0 and current_party.counter ~= party_members + 1 then
            print('party_members: ' .. party_members + 1)
            print('current_party.counter: ' .. current_party.counter)
            local party_member_str = 'party' .. party_members
            local party_member_name = UnitName(party_member_str)
            print('party_member_name is ' .. party_member_name)
            local party_member_race = UnitRace(party_member_str)
            print('party_member_race ' .. party_member_race)
            local party_member_class = UnitClass(party_member_str)
            print('party_member_class is ' .. party_member_class)
            local party_member_level = UnitLevel(party_member_str)
            print('party_member_level is ' .. party_member_level)
            current_party.counter = current_party.counter + 1
            current_party.setup[party_member_name] = {
                race = party_member_race or 0,
                class = party_member_class or 0,
                name = party_member_name or 0,
                level = party_member_level or 0
            }
            SendAddonMessage('nexus', 'GRINFO:ALL:FULL', 'BATTLEGROUND')
            print('party_member_str is: ' .. party_member_str)
        end
        print('Current party setup is: ')
        print('Members total: ' .. current_party.counter)
        for _, party_members_data in current_party.setup do
            print('Name: ' .. party_members_data.name)
        end
    end
end

function th.GetPartyInfoFromCallback(data)
    local temp_substring = data
    local space_position = string.find(data, ' ')
    local start_position = 1
    local end_position
    temp_substring = string.sub(temp_substring, space_position + 1)
    end_position = string.find(temp_substring, ':') - 1
    local bot_name = string.sub(temp_substring, start_position, end_position)
    temp_substring = string.sub(temp_substring, end_position + 2)
    end_position = string.find(temp_substring, ':') - 1
    local bot_race = string.sub(temp_substring, start_position, end_position)
    temp_substring = string.sub(temp_substring, end_position + 2)
    end_position = string.find(temp_substring, ':') - 1
    local bot_class = string.sub(temp_substring, start_position, end_position)
    temp_substring = string.sub(temp_substring, end_position + 2)
    end_position = string.find(temp_substring, ':') - 1
    local bot_role = string.sub(temp_substring, start_position, end_position)
    temp_substring = string.sub(temp_substring, end_position + 2)
    local bot_owner = string.sub(temp_substring, start_position)
    if bot_name and bot_race and bot_class and bot_role and bot_owner and current_party.setup[bot_name] then
        --print('kek')
    end
end

function th.CheckBeforeHiring()
    if type_of_group and presets_types[type_of_group] then
        th.HireComps(type_of_group)
    end
end

local dungeon_presets = {
    orc_warrior = {
        party_1 = {
            class = string.lower(th.classes.shaman),
            role = th.roles.healer,
            race = string.lower(th.races.orc),
            gender = th.genders.male,
            owner = 'Chanini'
        },
        party_2 = {
            class = string.lower(th.classes.druid),
            role = th.roles.tank,
            race = string.lower(th.races.tauren),
            gender = th.genders.male,
            owner = 'Daia'
        },
        party_3 = {
            class = string.lower(th.classes.mage),
            role = th.roles.rangedps,
            race = string.lower(th.races.undead),
            gender = th.genders.male,
            owner = 'Giamar'
        },
        party_4 = {
            class = string.lower(th.classes.rogue),
            role = th.roles.mdps,
            race = string.lower(th.races.undead),
            gender = th.genders.male,
            owner = 'Hwan'
        },

    }
}

local function HiringLogic(preset)
    local index = GetNumPartyMembers() + 1
    if not index_to_hire then
        index_to_hire = index
    end
    if index == index_to_hire then
        local party_index = 'party_' .. index
        SendChatMessage(string.format('.z addinvite %s t0d %s %s default %s %s',
                th.my_name,
                --preset[party_index].owner,
                preset[party_index].class,
                preset[party_index].role,
                preset[party_index].race,
                preset[party_index].gender)
        )
        index_to_hire = index_to_hire + 1
        if index_to_hire > 4 and type_of_group == 'dungeon' then
            type_of_group = nil
        end
    end
end

function th.HireComps(preset)
    if presets_types[preset] then
        type_of_group = preset
        if preset == presets_types.dungeon then
            if th.my_race == th.races.orc and th.my_class == th.classes.warrior then
                HiringLogic(dungeon_presets.orc_warrior)
            end
        end
    end
end

function th.SummonPlayer(summoning_comp_owner, assist_owner)
    print('kek')
end