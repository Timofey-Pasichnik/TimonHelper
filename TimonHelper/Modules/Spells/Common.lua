th.common_spells = {
    attack = {
        spell_name = th.spell_names.attack,
        action_slot = 25
    }
}

function th.SetMeleeAttack()
    local attack = th.common_spells.attack.action_slot
    if not IsCurrentAction(th.common_spells.attack.action_slot) then
        UseAction(th.common_spells.attack.action_slot)
    end
end