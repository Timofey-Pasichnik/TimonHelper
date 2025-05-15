print('Core.lua loaded')
--find my race and class
my_class = UnitClass(me)
my_race = UnitRace(me)
my_name = UnitName(me)

print('TimonHelper: loaded configuration ' .. my_race .. ' ' .. my_class)

--targeting
function TargetEnemy()
    if not UnitExists(he) then
        TargetNearestEnemy()
    end
end

--attack
function SetAutoAttack()
    if not IsCurrentAction(common_spells.attack.action_slot) then
        UseAction(common_spells.attack.action_slot)
    end
end

--check conditions
function DoAction(spell_to_cast)
    spell_action_slot = spell_to_cast.action_slot
    spell_type = spell_to_cast.type
    spell_name = spell_to_cast.name
    required_combat = spell_to_cast.combat
    required_level = spell_to_cast.level
    cooldown_ready = GetActionCooldown(spell_action_slot) == 0
    spell_usable = IsUsableAction(spell_action_slot)
    spell_queued = IsCurrentAction(spell_action_slot)
    required_melee_range = spell_to_cast.range == ranges.melee
    range_ok = IsActionInRange(spell_action_slot)
    required_range = spell_to_cast.range == ranges.ranged
    melee_range_ok = (not can_check_melee_range and CheckTargetInteractDistance(he, 3)) or IsActionInRange(melee_range_spell.action_slot)
    if UnitLevel(me) >= required_level then
        if (spell_type == spell_types.buff and required_combat and UnitAffectingCombat(me) and cooldown_ready and spell_usable and not buffed(spell_name, me)) or
                (spell_type == spell_types.debuff and required_combat and UnitAffectingCombat(me) and cooldown_ready and spell_usable and required_melee_range and melee_range_ok and not buffed(spell_name, he)) or
                (spell_type == spell_types.queued and required_combat and UnitAffectingCombat(me) and cooldown_ready and spell_usable and not spell_queued and required_melee_range and melee_range_ok) or
                (spell_type == spell_types.combo and required_combat and UnitAffectingCombat(me) and cooldown_ready and spell_usable and required_melee_range and melee_range_ok) or
                (spell_type == spell_types.direct and required_combat and UnitAffectingCombat(me) and cooldown_ready and spell_usable and required_melee_range  and melee_range_ok) or
                (spell_type == spell_types.direct and not required_combat and not UnitAffectingCombat(me) and cooldown_ready and spell_usable and required_range and range_ok) then
            CastSpellByName(spell_name)
        end
    end
end

--choose rotation
function ChooseRotation()
    if my_class == classes.warrior then
        DoWarriorRotation()
    else
        if my_class == classes.rogue then
            DoRogueRotation()
        end
    end
end

--main macro
function Battle()
    ChooseRotation()
end