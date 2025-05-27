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

function th.RunWithDelay(command_to_execute, arguments_for_command, delay_before_execute)
    local timer_frame = CreateFrame('Frame')
    local timer = 0
    timer_frame:SetScript('OnUpdate', function()
        timer = timer + arg1
        if timer >= delay_before_execute then
            timer = 0
            command_to_execute(arguments_for_command)
            timer_frame:SetScript('OnUpdate', nil)
        end
    end)
end

function string.split(string_to_split, pattern)
    local split_string = {}
    local start_index = 1
    local found_string
    while start_index do
        delimeter_index = string.find(string_to_split, pattern, start_index)
        if delimeter_index then
            found_string = string.sub(string_to_split, start_index, delimeter_index - 1)
            table.insert(split_string, found_string)
            start_index = delimeter_index + 1
        else
            found_string = string.sub(string_to_split, start_index)
            table.insert(split_string, found_string)
            start_index = nil
        end
    end
    return split_string
end

function string.match(string_to_match, pattern)
    local matched_results = {}
    local start_index = 1
    local end_index
    local found_string
    while start_index do
        start_index, end_index = string.find(string_to_match, pattern, start_index)
        if start_index then
            found_string = string.sub(string_to_match, start_index, end_index)
            table.insert(matched_results, found_string)
            start_index = end_index + 1
        else
            start_index = nil
        end
    end
    return matched_results
end

function table.length(table_to_calculate)
    local length = 0
    for _ in pairs(table_to_calculate) do
        length = length + 1
    end
    return length
end