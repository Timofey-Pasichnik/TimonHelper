th.warrior_spells = {
    charge = {
        spell_name = th.spell_names.charge,
        action_slot = '58'
    },
    battle_shout = {
        spell_name = th.spell_names.battle_shout,
        action_slot = '62'
    },
    bloodrage = {
        spell_name = th.spell_names.bloodrage,
        action_slot = '63'
    },
    hamstring = {
        spell_name = th.spell_names.hamstring,
        action_slot = '57'
    },
    rend = {
        spell_name = th.spell_names.rend,
        action_slot = '27'
    },
    overpower = {
        spell_name = th.spell_names.overpower,
        action_slot = '49'
    },
    heroic_strike = {
        spell_name = th.spell_names.heroic_strike,
        action_slot = '26'
    },
    sunder_armor = {
        spell_name = th.spell_names.sunder_armor,
        action_slot = '28'
    }
}

local function Charge()
    local charge = th.warrior_spells.charge.action_slot
    if UnitLevel(th.me) >= 4
            and IsActionInRange(charge)
            and GetActionCooldown(charge) == 0
            and IsUsableAction(charge) == 1
            and IsActionInRange(charge) == 1
            and not UnitAffectingCombat(th.me)
    then
        UseAction(charge)
    end
end

local function BloodFury()
    local blood_fury = th.common_spells.blood_fury.action_slot
    if th.my_race == th.races.orc
            and GetActionCooldown(blood_fury) == 0
            and IsUsableAction(blood_fury) == 1
            and UnitAffectingCombat(th.me)
            and UnitExists(th.he)
            and not UnitIsDead(th.he)
            and CheckInteractDistance(th.he, th.ranges.forward.closest)
    then
        UseAction(blood_fury)
    end
end

local function BattleShout()
    local battle_shout = th.warrior_spells.battle_shout.action_slot
    if GetActionCooldown(battle_shout) == 0
            and IsUsableAction(battle_shout) == 1
            and UnitAffectingCombat(th.me)
            and UnitExists(th.he)
            and not UnitIsDead(th.he)
            and CheckInteractDistance(th.he, th.ranges.forward.closest)
            and not buffed(th.spell_names.battle_shout, th.me)
            and UnitMana(th.me) >= 10
    then
        UseAction(battle_shout)
    end
end

local function Bloodrage()
    local bloodrage = th.warrior_spells.bloodrage.action_slot
    if UnitLevel(th.me) >= 10
            and GetActionCooldown(bloodrage) == 0
            and IsUsableAction(bloodrage) == 1
            and UnitAffectingCombat(th.me)
            and UnitExists(th.he)
            and not UnitIsDead(th.he)
            and CheckInteractDistance(th.he, th.ranges.forward.closest)
            and UnitHealth(th.me) / UnitHealthMax(th.me) * 100 > 50
    then
        UseAction(bloodrage)
    end
end

local function Hamstring()
    local hamstring = th.warrior_spells.hamstring.action_slot
    if UnitLevel(th.me) >= 8
            and GetActionCooldown(hamstring) == 0
            and IsUsableAction(hamstring) == 1
            and IsActionInRange(hamstring) == 1
            and UnitAffectingCombat(th.me)
            and UnitExists(th.he)
            and not UnitIsDead(th.he)
            and CheckInteractDistance(th.he, th.ranges.forward.closest)
            and not buffed(th.spell_names.hamstring, th.he)
            and UnitMana(th.me) >= 10
    then
        UseAction(hamstring)
    end
end

local function Rend()
    local rend = th.warrior_spells.rend.action_slot
    if UnitLevel(th.me) >= 4
            and GetActionCooldown(rend) == 0
            and IsUsableAction(rend) == 1
            and IsActionInRange(rend) == 1
            and UnitAffectingCombat(th.me)
            and UnitExists(th.he)
            and not UnitIsDead(th.he)
            and CheckInteractDistance(th.he, th.ranges.forward.closest)
            and not buffed(th.spell_names.rend, th.he)
            and UnitMana(th.me) >= 10
    then
        UseAction(rend)
    end
end

local function Overpower()
    local overpower = th.warrior_spells.overpower.action_slot
    if UnitLevel(th.me) >= 14
            and GetActionCooldown(overpower) == 0
            and IsUsableAction(overpower) == 1
            and IsActionInRange(overpower) == 1
            and UnitAffectingCombat(th.me)
            and UnitExists(th.he)
            and not UnitIsDead(th.he)
            and CheckInteractDistance(th.he, th.ranges.forward.closest)
            and UnitMana(th.me) >= 5
    then
        UseAction(overpower)
    end
end

local function HeroicStrike()
    local heroic_strike = th.warrior_spells.heroic_strike.action_slot
    if GetActionCooldown(heroic_strike) == 0
            and IsUsableAction(heroic_strike) == 1
            and UnitAffectingCombat(th.me)
            and UnitExists(th.he)
            and not UnitIsDead(th.he)
            and CheckInteractDistance(th.he, th.ranges.forward.closest)
            and UnitMana(th.me) >= 40
            and not IsCurrentAction(heroic_strike)
    then
        UseAction(heroic_strike)
    end
end

local function SunderArmor()
    local sunder_armor = th.warrior_spells.sunder_armor.action_slot
    if UnitLevel(th.me) >= 10
            and GetActionCooldown(sunder_armor) == 0
            and IsUsableAction(sunder_armor) == 1
            and IsActionInRange(sunder_armor) == 1
            and UnitAffectingCombat(th.me)
            and UnitExists(th.he)
            and not UnitIsDead(th.he)
            and CheckInteractDistance(th.he, th.ranges.forward.closest)
            and UnitMana(th.me) >= 10
    then
        if not buffed(th.spell_names.sunder_armor, th.he) then
            UseAction(sunder_armor)
        else
            local sunder_found, stacks_amount
            for i = 1, 40 do
                local name, stacks = UnitDebuff(th.he, i)
                if name and th.match(name, 'Warrior_Sunder', 1) then
                    sunder_found = true
                    stacks_amount = stacks
                    break
                end
            end
            if not sunder_found or stacks_amount < 5 then
                UseAction(sunder_armor)
            end

        end
    end
end

function th.WarriorRotation()
    th.SelectWarriorTarget()
    --th.SetMarks()
    th.SetMeleeAttack()
    Charge()
    BloodFury()
    BattleShout()
    Bloodrage()
    Overpower()
    Hamstring()
    Rend()
    SunderArmor()
    HeroicStrike()
    if th.targets.counters.closest > 1 then
        th.WarriorAOERotation()
    else
        th.WarriorSingleRotation()
    end
end

function th.WarriorAOERotation()

end

function th.WarriorSingleRotation()

end

function th.SelectWarriorTarget()
    local skull_guid = 'mark8'
    local moon_guid = 'mark5'
    if UnitExists(skull_guid) then
        TargetUnit(skull_guid)
    elseif th.targets.counters.closest > 0 then
        local probable_target = next(th.targets.closest)
        if probable_target then
            TargetUnit(probable_target)
        end
    elseif not UnitExists(th.he) or UnitIsDead(th.he) then
        TargetNearestEnemy()
    end
end

