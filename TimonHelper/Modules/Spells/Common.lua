th.common_spells = {
    attack = {
        spell_name = th.spell_names.attack,
        action_slot = 25
    },
    blood_fury = {
        spell_name = th.spell_names.blood_fury,
        action_slot = '61'
    }
}

function th.SetMeleeAttack()
    local attack = th.common_spells.attack.action_slot
    if not IsCurrentAction(attack) then
        UseAction(attack)
    end
end

function th.AmmoEquipped()
    local ammo_texture = GetInventoryItemTexture(th.me, 0)
    if ammo_texture and th.match(ammo_texture, 'Arrow', 1) then
        return 'Arrows'
    else
        return 0
    end
end

function th.RangedEquipped()
    local ranged_texture = GetInventoryItemTexture(th.me, 18)
    if ranged_texture and th.match(ranged_texture, 'Crossbow', 1) then
        return 'Crossbow'
    else
        return 0
    end
end

function th.Shoot()
    local arrows_equipped = th.AmmoEquipped()
    local ranged_equipped = th.RangedEquipped()
    if arrows_equipped == 'Arrows' and ranged_equipped == 'Crossbow' then
        CastSpellByName('Shoot Crossbow')
    end
end
