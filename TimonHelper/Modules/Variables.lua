th = {}
th.me = 'player'
th.he = 'target'
th.my_name = UnitName(th.me)
th.my_class = UnitClass(th.me)
th.classes = {
    warrior = 'Warrior',
    shaman = 'Shaman',
    druid = 'Druid',
    mage = 'Mage',
    rogue = 'Rogue'
}
th.roles = {
    healer = 'healer',
    tank = 'tank',
    rangedps = 'rangedps',
    mdps = 'mdps'
}
th.genders = {
    male = 'male',
    female = 'female'
}
th.my_race = UnitRace(th.me)
th.races = {
    orc = 'Orc',
    tauren = 'Tauren',
    undead = 'Undead'
}
th.ranges = {
    forward = {
        closest = 3,
        close = 1,
        far = 2,
        farther = 4,
        farthest = 5
    },
    backward = {
        [3] = 'closest',
        [1] = 'close',
        [2] = 'far',
        [4] = 'farther',
        [5] = 'farthest'
    }
}

th.cc_spells = {}
th.spell_names = {
    attack = 'Attack',
    charge = 'Charge',
    blood_fury = 'Blood Fury',
    battle_shout = 'Battle Shout',
    bloodrage = 'Bloodrage',
    hamstring = 'Hamstring',
    rend = 'Rend',
    overpower = 'Overpower',
    heroic_strike = 'Heroic Strike',
    sunder_armor = 'Sunder Armor',
    demoralizing_shout = 'Demoralizing Shout',
    thunder_clap = 'Thunder Clap'
}
th.potions = {
    minor_healing_potion = 'Minor Healing Potion',
    lesser_healing_potion = 'Lesser Healing Potion',
    healing_potion = 'Healing Potion'
}
th.AOE_mode = false
th.hostile_targets = 0