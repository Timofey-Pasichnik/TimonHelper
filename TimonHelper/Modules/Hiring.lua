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
    local party_member_guid
    local raid_members = GetNumRaidMembers()
    local no_raid_members = raid_members == 0
    local party_update
    local function AddMemberToCurrentPartyTable(person)
        party_member_guid = th.ExtractGUIDFromUnitName(person)
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
            guid = party_member_guid
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
        print(string.format('name: %s, race: %s, class: %s, level: %s, is_bot: %s, role: %s, owner: %s, guid: %s',
                party_data.name or 0,
                party_data.race or 0,
                party_data.class or 0,
                party_data.level or 0,
                party_data.is_bot or 0,
                party_data.role or 0,
                party_data.owner or 0,
                party_data.guid or 0
        ))

    end
    if th.summoning_in_progress then
        th.SummonPlayer()
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

local summoning = CreateFrame('Frame')

local warlock_invited, warlock_guid, warlock_is_nearby, warlock_summoning_started, warrior_invited,
friend_invited, friend_guid, owner_gender, warrior_guid, warlock_name, summoning_friend_name

function th.Summoning(warlock_owner, warrior_owner)
    local elapsed = 0
    if th.my_race == 'Orc' then owner_gender = 'male' else owner_gender = 'female' end
    summoning_friend_name = GetFriendInfo(1)
    ClearTarget()
    summoning:SetScript('OnUpdate', function()
        elapsed = elapsed + arg1
        if elapsed > 0.05 then
            elapsed = 0
            if current_party.counter == 1 and not warlock_invited then
                th.AddComp(warlock_owner, string.lower(th.classes.warlock), '', string.lower(th.my_race), owner_gender)
                warlock_invited = 1
            elseif current_party.counter == 2 and not warlock_guid then
                for _, party_data in current_party.setup do
                    if party_data.class and party_data.class == th.classes.warlock and party_data.is_bot and party_data.owner == th.my_name then
                        warlock_guid = party_data.guid
                        warlock_name = party_data.name
                        print('warlock guid is ' .. warlock_guid)
                        break
                    end
                end
            elseif current_party.counter == 2 and not warrior_invited then
                th.AddComp(warrior_owner, string.lower(th.classes.warrior), th.roles.mdps, string.lower(th.my_race), owner_gender)
                warrior_invited = 1
            elseif current_party.counter == 3 and not warrior_guid then
                for _, party_data in current_party.setup do
                    if party_data.class and party_data.class == th.classes.warrior and party_data.is_bot and party_data.owner == th.my_name then
                        warrior_guid = party_data.guid
                        print('warrior guid is ' .. warrior_guid)
                        break
                    end
                end
            elseif current_party.counter == 3 and warrior_guid and not friend_invited then
                InviteByName(summoning_friend_name)
                friend_invited = 1
            elseif current_party.counter > 3 and not friend_guid then
                for _, party_data in current_party.setup do
                    if party_data.name and party_data.name == summoning_friend_name then
                        friend_guid = party_data.guid
                        print('friend guid is ' .. friend_guid)
                        break
                    end
                end
            elseif current_party.counter > 3 and friend_guid and not warlock_is_nearby and th.CurrentDistanceToTarget(warlock_guid) == th.ranges.backward[3] then
                print('warlock is nearby')
                warlock_is_nearby = 1
            elseif current_party.counter > 3 and friend_guid and warlock_is_nearby and not warlock_summoning_started and not UnitExists(th.he) then
                print('Trying to target friend by his guid: ' .. friend_guid)
                TargetUnit(friend_guid)
            elseif current_party.counter > 3 and friend_guid and warlock_is_nearby and not warlock_summoning_started and UnitExists(th.he) and UnitName(th.he) == summoning_friend_name then-- and delay_after_targeting and delay_after_targeting > GetTime() + 0.15 then
                SendChatMessage('Cast Ritual of Summoning', 'WHISPER', nil, warlock_name)
                warlock_summoning_started = 1
            elseif current_party.counter > 1 and th.CurrentDistanceToTarget(friend_guid) == th.ranges.backward[3] then
                LeaveParty()
            elseif current_party.counter == 1 and th.CurrentDistanceToTarget(friend_guid) == th.ranges.backward[3] then
                summoning:SetScript('OnUpdate', nil)
                warlock_invited, warlock_guid, warlock_is_nearby, warlock_summoning_started, warrior_invited,
                friend_invited, friend_guid, owner_gender, warrior_guid, warlock_name = nil
                Logout()
            end
        end
    end)
end

function th.AssistSummon()
    if not UnitExists(th.he) or th.ExtractGUIDFromUnitName(th.he) ~= warrior_guid then
        TargetUnit(warrior_guid)
    elseif UnitExists(th.he) and th.ExtractGUIDFromUnitName(th.he) == warrior_guid then
        SendChatMessage('.z comestay')
        SendChatMessage('.z use')
    end
end