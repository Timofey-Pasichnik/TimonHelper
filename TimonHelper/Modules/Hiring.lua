local current_party = {
    counter = 0,
    setup = {}
}

local type_of_group

local presets_types = {
    dungeon = 'dungeon'
}

function th.AddComp(owner, class, role, race, gender)
    SendChatMessage(string.format('.z addinvite %s t0d %s %s default %s %s',
    owner, class, role, race, gender))
end

--SendChatMessage(string.format('.z addinvite %s t0d %s %s default %s %s',
--th.my_name,
----preset[party_index].owner,
--preset[party_index].class,
--preset[party_index].role,
--preset[party_index].race,
--preset[party_index].gender)


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
end

function th.GetPartyInfoFromCallback(data)
    local bot_info = string.split(data, ' ')
    for index, bot in ipairs(bot_info) do
        if index > 1 then
            bot_data = string.split(bot, ':')
            bot_name = bot_data[1]
            bot_role = bot_data[4]
            bot_owner = bot_data[5]
            if current_party.setup[bot_name] then
                current_party.setup[bot_name].is_bot = 1
                current_party.setup[bot_name].role = bot_role
                current_party.setup[bot_name].owner = bot_owner
            end
        end
    end
    print('Members in group: ' .. current_party.counter)
    for _, party_data in current_party.setup do
        print(string.format('name: %s, race: %s, class: %s, level: %s, is_bot: %s, role: %s, owner: %s',
                party_data.name or 0,
                party_data.race or 0,
                party_data.class or 0,
                party_data.level or 0,
                party_data.is_bot or 0,
                party_data.role or 0,
                party_data.owner or 0
        ))

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
        th.AddComp(th.my_name, preset[party_index].class, preset[party_index].role, preset[party_index].race, preset[party_index].gender)
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


local warlock_name
local warrior_name
local friend_name
local summoning_char_party_id
local warlock_char_party_id
local warrior_char_party_id
local smart_case = 0
function th.SummonPlayer(summoning_comp_owner, assist_owner)
    if not friend_name then friend_name = GetFriendInfo(1) end
    local horde = th.my_race == 'Orc' or th.my_race == 'Undead' or th.my_race == 'Tauren' or th.my_race == 'Troll'
    local alliance = not horde
    local summoning_comp_owner_race
    if horde then
        summoning_comp_owner_race = string.lower(th.races.undead)
    else
        summoning_comp_owner_race = string.lower(th.races.human)
    end
    if smart_case == 0 and GetNumPartyMembers() == 0 then
        th.AddComp(summoning_comp_owner, string.lower(th.classes.warlock), th.roles.rangedps, summoning_comp_owner_race, th.genders.male)
        smart_case = 1
    elseif smart_case == 1 and GetNumPartyMembers() == 1 then
        th.AddComp(assist_owner, string.lower(th.classes.warrior), th.roles.mdps, summoning_comp_owner_race, th.genders.male)
        smart_case = 2
    elseif smart_case == 2 and GetNumPartyMembers() == 2 then
        InviteByName(friend_name)
        smart_case = 3
    elseif smart_case == 3 and GetNumPartyMembers() > 2 then
        if not warlock_name and not warrior_name then
            for _, current_party_data in current_party.setup do
                if current_party_data.owner
                        and current_party_data.owner == th.my_name
                        and current_party_data.level == 20
                        and current_party_data.is_bot
                        and current_party_data.class == th.classes.warlock
                then
                    warlock_name = current_party_data.name
                elseif current_party_data.owner
                        and current_party_data.owner == th.my_name
                        and current_party_data.level == 3
                        and current_party_data.is_bot
                        and current_party_data.class == th.classes.warrior
                then
                    warrior_name = current_party_data.name
                end
            end
        end
        smart_case = 4
    elseif smart_case == 4 and warlock_name and warrior_name then
        for i = 1, GetNumPartyMembers() do
            if UnitName('party' .. i) == friend_name then summoning_char_party_id = 'party' .. i end
        end
        smart_case = 5
    elseif smart_case == 5 and summoning_char_party_id then
        TargetUnit(summoning_char_party_id)
        smart_case = 6
    elseif smart_case == 6 and UnitName(th.he) == friend_name then
        SendChatMessage('cast Ritual of Summoning','whisper', 'orcish', warlock_name)
        smart_case = 7
    elseif smart_case == 7 then
        for i = 1, GetNumPartyMembers() do
            if UnitName('party' .. i) == warrior_name then warrior_char_party_id = 'party' .. i end
        end
        smart_case = 8
    elseif smart_case ==8 and warrior_char_party_id then
        TargetUnit(warrior_char_party_id)
        smart_case = 9
    elseif smart_case == 9 and UnitName(th.he) == warrior_name then
        SendChatMessage('.z comestay')
        th.RunWithDelay(SendChatMessage, '.z use', 1)
        smart_case = 10
    elseif smart_case == 10 and th.CurrentDistanceToTarget(summoning_char_party_id) == th.ranges.forward.closest then
        warlock_name = nil
        warrior_name = nil
        friend_name = nil
        summoning_char_party_id = nil
        warlock_char_party_id = nil
        warrior_char_party_id = nil
        LeaveParty()
        th.RunWithDelay(LeaveParty, nil, 1)
        smart_case = 11
        elseif smart_case == 11 and GetNumPartyMembers() == 0 then
            smart_case = 0
            ForceQuit()
    end
end
