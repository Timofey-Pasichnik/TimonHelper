print('Warrior.lua loaded')

--spells
warrior_spells = {
    battle_shout = {
        action_slot = 62,
        race = races.all,
        level = 1,
        ignored_npc = {},
        ignored_types = {},
        type = spell_types.buff,
        name = 'Battle Shout',
        combat = true,
        range = ranges.self
    },
    bloodrage = {
        action_slot = 63,
        race = races.all,
        level = 10,
        ignored_npc = {},
        ignored_types = {},
        type = spell_types.buff,
        name = 'Bloodrage',
        combat = true,
        range = ranges.self
    },
    heroic_strike = {
        action_slot = 26,
        race = races.all,
        level = 1,
        ignored_npc = {},
        ignored_types = {},
        type = spell_types.queued,
        name = 'Heroic Strike',
        combat = true,
        range = ranges.melee
    },
    charge = {
        action_slot = 49,
        race = races.all,
        level = 4,
        ignored_npc = {},
        ignored_types = {},
        type = spell_types.direct,
        name = 'Charge',
        combat = false,
        range = ranges.ranged
    },
    rend = {
        action_slot = 27,
        race = races.all,
        level = 4,
        ignored_npc = {},
        ignored_types = {},
        type = spell_types.debuff,
        name = 'Rend',
        combat = true,
        range = ranges.melee
    },
    thunder_clap = {
        action_slot = 28,
        race = races.all,
        level = 6,
        ignored_npc = {},
        ignored_types = {},
        type = spell_types.clap,
        name = 'Thunder Clap',
        combat = true,
        range = ranges.melee
    },
    hamstring = {
        action_slot = 29,
        race = races.all,
        level = 8,
        ignored_npc = {},
        ignored_types = {},
        type = spell_types.debuff,
        name = 'Hamstring',
        combat = true,
        range = ranges.melee
    },
}

can_check_melee_range = true
melee_range_spell = warrior_spells.rend

function DoWarriorRotation()
    if aoe_mode then
        DoWarriorAoeRotation()
    else
        DoWarriorSingleRotation()
    end
end

function DoWarriorAoeRotation()
    TargetEnemy()
    SetAutoAttack()
    go_blood_fury()
    go_battle_shout()
    go_charge()
    go_bloodrage()
    go_rend()
    go_hamstring()
    go_heroic_strike()
end

function DoWarriorSingleRotation()
    TargetEnemy()
    SetAutoAttack()
    go_blood_fury()
    go_battle_shout()
    go_charge()
    go_bloodrage()
    go_thunder_clap()
    go_rend()
    go_hamstring()
    go_heroic_strike()
end

function go_battle_shout()
    DoAction(warrior_spells.battle_shout)
end

function go_bloodrage()
    DoAction(warrior_spells.bloodrage)
end

function go_charge()
    DoAction(warrior_spells.charge)
end

function go_rend()
    DoAction(warrior_spells.rend)
end

function go_heroic_strike()
    if UnitMana(me) > 50 then
        DoAction(warrior_spells.heroic_strike)
    end
end

function go_thunder_clap()
    if aoe_mode then
        DoAction(warrior_spells.thunder_clap)
    end
end

function go_hamstring()
    DoAction(warrior_spells.hamstring)
end