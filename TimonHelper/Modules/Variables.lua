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

th.cc_spells = {}
th.spell_names = {
    attack = 'Attack',
    charge = 'Charge'
}
th.AOE_mode = false
th.hostile_targets = 0