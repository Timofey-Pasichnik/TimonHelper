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
    Warrior = {
        attack = {
            action_slot = 25,
            race = races.all,
            level = 1,
            ignored_npc = {},
            ignored_types = {},
            type = spell_types.auto_attack
        }
    }
}

function DoWarriorRotation()
    TargetEnemy()
    SetAutoAttack()
end