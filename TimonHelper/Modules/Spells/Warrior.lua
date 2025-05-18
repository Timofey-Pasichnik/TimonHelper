th.warrior_spells = {
    charge = {
        spell_name = th.spell_names.charge,
        action_slot = '58'
    }
}

function th.WarriorRotation()
    th.SelectWarriorTarget()
    th.SetMarks()
    th.SetMeleeAttack()
    if th.hostile_targets > 1 and (not th.IsCCNearby() or (th.IsCCNearby() and not CheckInteractDistance('mark5', 3))) then
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
    if th.hostile_targets == 0 and (not UnitExists(he) or UnitIsDead(he)) then
        TargetNearestEnemy()
    end
    if th.hostile_targets >0 and UnitExists('mark8') and not UnitIsDead('mark8') then
        TargetUnit('mark8')
    else
        TargetNearestEnemy()
    end
end

