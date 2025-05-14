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

--check cooldowns


--attack
function SetAutoAttack()
    if not IsCurrentAction(common_spells.Common.attack.action_slot) then
        UseAction(common_spells.Common.attack.action_slot)
    end
end

--check conditions
function DoAction(spell_to_cast)
    local spell_action_slot = spell_to_cast.action_slot
    local spell_type = spell_to_cast.type
    local spell_name = spell_to_cast.spell_name
    local required_combat = spell_to_cast.combat
    local required_level = spell_to_cast.level
    local cooldown_ready = GetActionCooldown(spell_action_slot) == 0
    local spell_usable = IsUsableAction(spell_action_slot)
    local spell_queued = IsCurrentAction(spell_action_slot)
    local range_ok = not can_check_melee_range or IsActionInRange(melee_range_spell)
    if UnitLevel(me) >= required_level then
        if (spell_type == spell_types.buff and required_combat and UnitAffectingCombat(me) and cooldown_ready and spell_usable and not buffed(spell_name)) or
                (spell_type == spell_types.queued and required_combat and UnitAffectingCombat(me) and cooldown_ready and spell_usable and not spell_queued and range_ok) or
                (spell_type == spell_types.combo and required_combat and UnitAffectingCombat(me) and cooldown_ready and spell_usable and range_ok) or
                (spell_type == spell_types.direct and required_combat and UnitAffectingCombat(me) and cooldown_ready and spell_usable and range_ok) then
            CastSpellByName(spell_name)
        end
    end
end
--    if IsAction
--end

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
