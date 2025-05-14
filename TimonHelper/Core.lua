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
    if not IsCurrentAction(spells.Warrior.attack.action_slot) then
        UseAction(spells.Warrior.attack.action_slot)
    end
end

--check conditions
function DoAction(spell_to_cast)
    --print('Doing ' .. spell_to_cast.spell_name)
    local spell_action_slot = spell_to_cast.action_slot
    local spell_type = spell_to_cast.type
    local spell_name = spell_to_cast.spell_name
    local required_combat = spell_to_cast.combat
    local required_level = spell_to_cast.level
    local cooldown_ready = GetActionCooldown(spell_to_cast.action_slot) == 0
    if UnitLevel(me) >= required_level then
        --print('Lvl req available')
        if required_combat and UnitAffectingCombat(me) then
            --print('im in combat')
            if cooldown_ready then
               CastSpellByName(spell_name)
            end
        end
    end
end
--    if IsAction
--end

--choose rotation
function ChooseRotation()
    if my_class == classes.warrior then
        DoWarriorRotation()
    end
end



--main macro
function Battle()
    ChooseRotation()
end
