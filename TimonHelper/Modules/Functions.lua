function th.match(test_string, pattern, index)
    local results = {}  -- Таблица для хранения всех совпадений
    local start_pos = 1  -- Начинаем поиск с начала строки

    while true do
        local match_start, match_end = string.find(test_string, pattern, start_pos)
        if not match_start then break end  -- Выход, если совпадений больше нет

        local match = string.sub(test_string, match_start, match_end)
        table.insert(results, match)  -- Добавляем найденное совпадение в таблицу
        start_pos = match_end + 1  -- Продолжаем поиск с позиции после текущего совпадения
    end

    if table.getn(results) > 0 then
        return results[index]  -- Возвращаем все найденные совпадения
    else
        return nil
    end
end

function th.ExtractGUIDFromUnitName(target)
    local _, guid = UnitExists(target)
    return guid
end

function th.CurrentDistanceToTarget(target)
    local distance_name
    local distance_index
    if UnitExists(target) then
        if CheckInteractDistance(target, th.ranges.forward.closest) then
            distance_name = th.ranges.backward[th.ranges.forward.closest]
            distance_index = th.ranges.forward.closest
        elseif CheckInteractDistance(target, th.ranges.forward.close) then
            distance_name = th.ranges.backward[th.ranges.forward.close]
            distance_index = th.ranges.forward.close
        elseif CheckInteractDistance(target, th.ranges.forward.far) then
            distance_name = th.ranges.backward[th.ranges.forward.far]
            distance_index = th.ranges.forward.far
        elseif CheckInteractDistance(target, th.ranges.forward.farther) then
            distance_name = th.ranges.backward[th.ranges.forward.farther]
            distance_index = th.ranges.forward.farther
        else
            distance_name = th.ranges.backward[th.ranges.forward.farthest]
            distance_index = th.ranges.forward.farthest
        end
        return distance_name, distance_index
    end
end

function test_elsif(number)
    local given_number
    if number == 1 then
        given_number = 1
    elseif number == 2 then
        given_number = 2
    else
        given_number = 3
    end
    return given_number
end