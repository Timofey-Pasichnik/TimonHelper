common_spells = {
    Common = {
        attack = {
            action_slot = 25,
            race = races.all,
            level = 1,
            ignored_npc = {},
            ignored_types = {},
            type = spell_types.auto_attack,
            spell_name = 'Attack',
            combat = false
        },
        blood_fury = {
            action_slot = 61,
            races = races.orc,
            level = 1,
            ignored_npc = {},
            ignored_types = {},
            type = spell_types.buff,
            spell_name = 'Blood Fury',
            combat = true
        }
    }
}

function go_blood_fury()
    DoAction(spells.Common.blood_fury)
end