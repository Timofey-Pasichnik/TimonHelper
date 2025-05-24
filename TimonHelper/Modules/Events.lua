event_list = {
    player_login = 'PLAYER_LOGIN',
}

local event_handler = CreateFrame('Frame')

for _, event in pairs(event_list) do
    event_handler:RegisterEvent(event)
end

event_handler:SetScript('OnEvent', function()
    if event == event_list.player_login then
        th.RunWithDelay(th.AddFriends, nil, 1)
    end
end)
