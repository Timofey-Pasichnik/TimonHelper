print('Rogue.lua loaded')
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

spells = {
    Rogue = {
        sinister_strike = {
            action_slot = 26,
            race = races.all,
            level = 1,
            ignored_npc = {},
            ignored_types = {},
            type = spell_types.direct,
            spell_name = 'Sinister Strike',
            combat = true
        },
        eviscerate = {
            action_slot = 27,
            race = races.all,
            level = 1,
            ignored_npc = {},
            ignored_types = {},
            type = spell_types.combo,
            spell_name = 'Eviscerate',
            combat = true,
            damage = {
                {6, 10},
                {11, 15},
                {16, 20},
                {21, 25},
                {26, 30}
            }
        }
    }
}

can_check_melee_range = true
melee_range_spell = spells.Rogue.sinister_strike.action_slot

function DoRogueRotation()
    TargetEnemy()
    SetAutoAttack()
    go_blood_fury()
    go_eviscerate()
    go_sinister_strike()
end

function go_eviscerate()
    local combo_points = GetComboPoints()
    if combo_points > 0 then
        local min_eviscerate_dmg = spells.Rogue.eviscerate.damage[combo_points][1]
        local max_eviscerate_dmg = spells.Rogue.eviscerate.damage[combo_points][2]
        local avg_eviscerate_dmg = (min_eviscerate_dmg + max_eviscerate_dmg) / 2
        if (avg_eviscerate_dmg > UnitHealth(he)) or combo_points == 5 then
            DoAction(spells.Rogue.eviscerate)
        end
    end
end

function go_sinister_strike()
    DoAction(spells.Rogue.sinister_strike)
end