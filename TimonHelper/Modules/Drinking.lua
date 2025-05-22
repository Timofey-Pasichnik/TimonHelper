test_drink = 'test_drink'

local potions = {
    health_potions = {
        [1] = {
            name = th.potions.healing_potion,
            level = 12,
            min_points = 280,
            max_points = 360
        },
        [2] = {
            name = th.potions.lesser_healing_potion,
            level = 3,
            min_points = 140,
            max_points = 180
        },
        [3] = {
            name = th.potions.minor_healing_potion,
            level = 1,
            min_points = 70,
            max_points = 90
        },
    }
}

function th.DrinkPotion()
    local amount_hp_pct = UnitHealth(th.me) / UnitHealthMax(th.me) * 100
    local health_to_full = UnitHealthMax(th.me) - UnitHealth(th.me)
    if amount_hp_pct < 30 then
        for potion_key, potion_data in pairs(potions.health_potions) do
            local points = (potion_data.min_points + potion_data.max_points) / 2
            if health_to_full > points then
                if GetItemCooldown(potion_data.name) and GetItemCooldown(potion_data.name) == 0 then
                    use(potion_data.name)
                end
            end
        end

    end
end