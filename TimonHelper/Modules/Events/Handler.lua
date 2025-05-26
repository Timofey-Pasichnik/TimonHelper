event_list = {
    player_login = 'PLAYER_LOGIN',
    party_members_changed = 'PARTY_MEMBERS_CHANGED',
    chat_msg_addon = 'CHAT_MSG_ADDON',
    chat_msg_system = 'CHAT_MSG_SYSTEM'
}

local event_handler = CreateFrame('Frame')

for _, event in pairs(event_list) do
    event_handler:RegisterEvent(event)
end



event_handler:SetScript('OnEvent', function()
    if event == event_list.player_login then
        th.RunWithDelay(th.AddFriends, nil, 1)
    elseif event == event_list.party_members_changed then
        th.CheckBeforeHiring()
        th.FillCurrentPartyTable()
    elseif event == event_list.chat_msg_addon then
        th.ProcessChatMsgAddonEvent(arg1 or 0, arg2 or 0, arg3 or 0, arg4 or 0, arg5 or 0, arg6 or 0, arg7 or 0, arg8 or 0, arg9 or 0)
    elseif event == event_list.chat_msg_system then
        if string.find(arg1, 'Verad') then print('Verad found') end
    end
end)