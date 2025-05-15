print('Warrior.lua loaded')

--spells

--ActionBar page 1: slots 1 to 12 -- Note exceptions below for other classes
--ActionBar page 2: slots 13 to 24
--
--ActionBar page 3 (Right ActionBar): slots 25 to 36
--ActionBar page 4 (Right ActionBar 2): slots 37 to 48
--
--ActionBar page 5 (Bottom Right ActionBar): slots 49 to 60
--ActionBar page 6 (Bottom Left ActionBar): slots 61 to 72
--
--
--Warrior Bonus Action Bars
--
--ActionBar page 1 Battle Stance: slots 73 to 84
--ActionBar page 1 Defensive Stance: slots 85 to 96
--ActionBar page 1 Berserker Stance: slots 97 to 108
--
--
--Druid Bonus Action Bars
--
--ActionBar page 1 Cat Form: slots 73 to 84
--ActionBar page 1 Prowl: slots 85 to 96
--ActionBar page 1 Bear Form: slots 97 to 108
--ActionBar page 1 Moonkin Form: slots 109 to 120
--
--
--Rogue Bonus Action Bars
--
--ActionBar page 1 Stealth: slots 73 to 84
--
--
--Priest Bonus Action Bars
--
--ActionBar page 1 Shadowform: slots 73 to 84
--
--
--Target Possessed Action Bar
--
--ActionBar page 1 Possess: slots 121-132

warrior_spells = {
    battle_shout = {
        action_slot = 62,
        race = races.all,
        level = 1,
        ignored_npc = {},
        ignored_types = {},
        type = spell_types.buff,
        spell_name = 'Battle Shout',
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
        spell_name = 'Heroic Strike',
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
        spell_name = 'Battle Shout',
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
        spell_name = 'Rend',
        combat = true,
        range = ranges.melee
    }
}

can_check_melee_range = true
melee_range_spell = warrior_spells.rend

function DoWarriorRotation()
    TargetEnemy()
    SetAutoAttack()
    go_blood_fury()
    go_battle_shout()
    go_charge()
    go_rend()
    go_heroic_strike()
end

function go_battle_shout()
    DoAction(warrior_spells.battle_shout)
end

function go_charge()
    DoAction(warrior_spells.charge)
end

function go_rend()
    DoAction(warrior_spells.rend)
end

function go_heroic_strike()
    DoAction(warrior_spells.heroic_strike)
end