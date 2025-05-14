function UpdateComp()
    local comp_updated = 0
    update_comp = CreateFrame("Frame")
    update_comp:RegisterEvent("PARTY_MEMBERS_CHANGED")
    update_comp:SetScript("OnEvent", function()
        print('kek')
        if comp_updated == 0 then
            if GetNumPartyMembers() > 0 then
                LeaveParty()
            end
            if GetNumPartyMembers == 0 then
                comp_class, comp_spec, comp_race, comp_gender = CompDecider()
                SendChatMessage('.z addinvite ' .. my_name .. ' ' .. 't0d ' .. comp_class .. ' ' .. comp_spec .. ' ' .. comp_race .. ' ' .. comp_gender)
                comp_updated = 1
            end
        end
        --if GetNumPartyMembers() > 0 then
        --    print('party changed')
        --end

    end)
    --if GetNumPartyMembers() > 0 then
    --    LeaveParty()
    --else
    --    if GetNumPartyMembers() == 0 then
    --        comp_class, comp_spec, comp_race, comp_gender = CompDecider()
    --        SendChatMessage('.z addinvite ' .. my_name .. ' ' .. 't0d ' .. comp_class .. ' ' .. comp_spec .. ' ' .. comp_race .. ' ' .. comp_gender)
    --        print('.z addinvite ' .. my_name .. ' ' .. 't0d ' .. comp_class .. ' ' .. comp_spec .. ' ' .. comp_race .. ' ' .. comp_gender)
    --    end
    --end
end

function CompDecider()
    if my_race == races.orc and my_class == classes.warrior then
        return string.lower(classes.shaman), specializations.healer, string.lower(races.orc), genders.female
    end
end