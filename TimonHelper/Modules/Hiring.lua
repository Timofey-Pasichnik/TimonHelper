local type_of_group

local presets_types = {
    dungeon = 'dungeon'
}

local hiring_frame = CreateFrame('Frame')
hiring_frame:RegisterEvent('PARTY_MEMBERS_CHANGED')
hiring_frame:SetScript('OnEvent', function()
    if type_of_group and presets_types[type_of_group] then
        --print('current party length is ' .. GetNumPartyMembers())
        th.HireComps(type_of_group)
    end
end)

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
    --print('Trying to hire member with index ' .. index)
    --print('Time of calling is ' .. GetTime())
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
        --print('type_of_group now is ' .. type_of_group)
        if preset == presets_types.dungeon then
            if th.my_race == th.races.orc and th.my_class == th.classes.warrior then
                HiringLogic(dungeon_presets.orc_warrior)
            end
        end
    end
end