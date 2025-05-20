function th.IsAOEMode()
    local have_cc_monsters = false
    for item in th.target_list.all_ranges do
        for _, spell in ipairs(th.cc_spells) do
            if buffed(spell, item) then
                have_cc_monsters = true
            end
        end
        th.hostile_targets = th.hostile_targets + 1
    end
    if not have_cc_monsters and th.hostile_targets > 1 then
        th.AOE_mode = true
    end
    return th.AOE_mode
end

function th.IsCCNearby()
    if UnitExists('mark5') then
        for _, spell in ipairs(th.cc_spells) do
            if buffed(spell, item) then
                return true
            end
        end
    end
    return false
end