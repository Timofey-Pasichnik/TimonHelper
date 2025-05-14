--find my race and class
my_class = UnitClass(me)
my_race = UnitRace(me)

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
--function DoAction(spell_to_cast)
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
