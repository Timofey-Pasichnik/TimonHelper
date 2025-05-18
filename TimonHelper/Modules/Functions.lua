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