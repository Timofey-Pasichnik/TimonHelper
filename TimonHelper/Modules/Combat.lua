function th.SetMeleeAttack()
    local attack = th.common_spells.attack.action_slot
    if not IsCurrentAction(attack) then
        UseAction(attack)
    end
end