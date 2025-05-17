function th.WarriorRotation()
    if th.IsAOEMode() then
        th.WarriorAOERotation()
    else
        th.WarriorSingleRotation()
    end
end

function th.WarriorAOERotation()

end

function th.WarriorSingleRotation()
    th.SelectWarriorTarget()
end

function th.SelectWarriorTarget()
    local me_in_combat = UnitAffectingCombat(me)
    local he_in_combat = UnitAffectingCombat(he)
    local have_target = UnitExists(he)
    if not me_in_combat and not have_target then
        TargetNearestEnemy()
    end
end