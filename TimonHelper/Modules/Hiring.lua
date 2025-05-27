local current_party = {
    counter = 0,
    setup = {}
}

local type_of_group

local presets_types = {
    dungeon = 'dungeon'
}

function th.FillCurrentPartyTable()
    local party_members = GetNumPartyMembers()
    local party_member_str = 'party' .. party_members
    local party_member_name = UnitName(party_member_str)
    local party_member_race
    local party_member_class
    local party_member_level
    local raid_members = GetNumRaidMembers()
    local no_party_members = party_members == 0
    local no_raid_members = raid_members == 0
    local alone = no_party_members and no_raid_members
    local party_update
    local function AddMemberToCurrentPartyTable(person)
        --print('Trying to add ' .. person)
        if person == th.me then
            party_member_name = th.my_name
            party_member_race = th.my_race
            party_member_class = th.my_class
            party_member_level = th.my_level
        else
            party_member_name = UnitName(person)
            party_member_race = UnitRace(person)
            party_member_class = UnitClass(person)
            party_member_level = UnitLevel(person)
        end
        --print('its name is ' .. party_member_name)
        --print('its race is ' .. party_member_race)
        --print('its class is ' .. party_member_class)
        --print('its level is ' .. party_member_level)
        current_party.setup[party_member_name] = {
            race = party_member_race,
            class = party_member_class,
            name = party_member_name,
            level = party_member_level,
        }
    end
    if no_raid_members and current_party.counter ~= party_members + 1 then
        party_update = 1
        current_party.counter = party_members + 1
        current_party.setup = {}
        AddMemberToCurrentPartyTable(th.me)
        if party_members > 0 then
            for i = 1, party_members do
                local name = UnitName('party' .. i)
                if not name then print('Error while processing party' .. i) return end
                AddMemberToCurrentPartyTable('party' .. i)
            end
            SendAddonMessage("nexus", 'GRINFO:ALL:FULL', "BATTLEGROUND")
        end
    end
    --if party_update then
    --    print('Current party setup:')
    --    print('Members: ' .. current_party.counter)
    --    for _, party_members_data in current_party.setup do
    --        print(string.format('race: %s, class: %s, is_bot: %s, name: %s, level: %s, role: %s, spec: %s',
    --                party_members_data.race or 0,
    --                party_members_data.class or 0,
    --                party_members_data.is_bot or 0,
    --                party_members_data.name or 0,
    --                party_members_data.level or 0,
    --                party_members_data.role or 0,
    --                party_members_data.spec or 0))
    --    end
    --end
end

function th.GetPartyInfoFromCallback(data)
    print('received data: ' .. data)
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
        current_party.setup[bot_name].is_bot = 1
        current_party.setup[bot_name].role = bot_role
        current_party.setup[bot_name].owner = bot_owner

        print('Current party setup:')
        print('Members: ' .. current_party.counter)
        for _, party_members_data in current_party.setup do
            print(string.format('race: %s, class: %s, is_bot: %s, name: %s, level: %s, role: %s, spec: %s',
                    party_members_data.race or 0,
                    party_members_data.class or 0,
                    party_members_data.is_bot or 0,
                    party_members_data.name or 0,
                    party_members_data.level or 0,
                    party_members_data.role or 0,
                    party_members_data.spec or 0))
        end
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

function th.Test()
    local input_string = 'GRINFO:ALL:FULL Jeldan:Tauren:Druid:Healer:Ucsum Velchar:Undead:Rogue:MDPS:Ucsum'
end