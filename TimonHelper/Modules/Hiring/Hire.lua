print('Hire.lua loaded')

function UpdateComp()
    local elapsed = 0
    if GetNumPartyMembers() > 0 then
        comp_name = UnitName('party1')
    else
        comp_name = 'null'
    end

    local update_comp = CreateFrame("Frame")
    update_comp:SetScript("OnUpdate", function()
        elapsed = elapsed + arg1
        if elapsed > 0.5 then
            elapsed = 0
            if GetNumPartyMembers() > 0 then
                if comp_name == UnitName('party1') then
                    LeaveParty()
                else
                    update_comp:SetScript("OnUpdate", nil)
                end
            else
                local command = string.format(".z addinvite %s t0d %s %s default %s %s",
                        my_name, GetCompanionData()
                )
                --print(command)
                SendChatMessage(command)
            end

        end
    end)
end

function GetCompanionData()
    if my_race == races.orc and my_class == classes.warrior then
        return
            string.lower(classes.shaman),
            specializations.healer,
            string.lower(races.orc),
            genders.male
        else if my_race == races.human and my_class == classes.rogue then
            return
                string.lower(classes.priest),
                specializations.healer,
                string.lower(races.human),
                genders.female
        end
    end
end