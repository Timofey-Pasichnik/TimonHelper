--global variables
me = 'player'
he = 'target'
my_class = UnitClass(me)
my_race = UnitRace(me)

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



--main macro
function Battle()
    TargetEnemy()
end
