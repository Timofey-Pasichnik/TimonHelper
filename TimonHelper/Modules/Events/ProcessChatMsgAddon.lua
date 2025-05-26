function th.ProcessChatMsgAddonEvent(prefix, text, channel, sender, target, zone_channel_id, local_id, name, instance_id)
    local matching_pattern = th.match(prefix, 'GRINFO:ALL:FULL.*', 1)
    if matching_pattern then
        th.GetPartyInfoFromCallback(matching_pattern)
    end
    --print('=========================')
    --print('prefix is: ' .. prefix)
    --print('text is: ' .. text)
    --print('channel is: ' .. channel)
    --print('sender is: ' .. sender)
    --print('target is: ' .. target)
    --print('zone_channel_id is: ' .. zone_channel_id)
    --print('local_id is: ' .. local_id)
    --print('name is: ' .. name)
    --print('instance_id is: ' .. instance_id)
end