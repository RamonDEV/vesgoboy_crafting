RedEM = exports["redem_roleplay"]:RedEM()

RegisterNetEvent("vesgoboy_craft:storage")
AddEventHandler("vesgoboy_craft:storage",function(nomeinventario,tamanhoinventario)
    local _source = source
	TriggerClientEvent("redemrp_inventory:OpenStash", _source, nomeinventario,tamanhoinventario)
end)

RegisterNetEvent("vesgoboy_craft:crafting")
AddEventHandler("vesgoboy_craft:crafting",function(label,recipe,amount,resultitem,items)
    local _source = source
    local Player = RedEM.GetPlayer(_source)
    local data = RedEM.GetInventory()
    local itenscraft = {}
    local recipeitem = recipe
    local recipeqtd = 0

    if recipe ~= false then
        ItemInfo = data.getItemData(recipe) -- return info from config
        recipeitem = data.getItem(_source, recipe)
		recipeqtd = recipeitem.ItemAmount
        if recipeqtd < 1 then
            RedEM.Functions.NotifyLeft(_source, "Saloon", Config.Text.norecipe.." "..label, Config.Textures.cross[1], Config.Textures.cross[2], 3000)
            return false
        end
    end

    local haveitens = 0
    for i = 1, #items do
        ItemInfo = data.getItemData(items[i].name) -- return info from config
        itemcraft = data.getItem(_source,items[i].name)
        itemcraftqtd = itemcraft.ItemAmount

        if itemcraftqtd < items[i].count then
            RedEM.Functions.NotifyLeft(_source, "Saloon", Config.Text.nohaveitem.." "..ItemInfo.label, Config.Textures.cross[1], Config.Textures.cross[2], 3000)
            break
        end
        haveitens = haveitens + 1
    end

    if haveitens == #items then
        for i = 1, #items do
            itemcraft = data.getItem(_source,items[i].name)
            itemcraft.RemoveItem(items[i].count)
        end

        if amount ~= false then
            amount = amount
        else
            amount = 1
        end

        TriggerClientEvent("vesgoboy_crafting:animation",_source)
        Citizen.Wait(Config.CraftTime)

        ItemInfo = data.getItemData(resultitem) -- return info from config
        item = data.getItem(_source, resultitem)
        item.AddItem(amount)
        RedEM.Functions.NotifyLeft(_source, "Saloon", Config.Text.received.." x"..amount.." de "..ItemInfo.label, Config.Textures.tick[1], Config.Textures.tick[2], 3000)
    end 
end)

RegisterServerEvent("vesgoboy_craft:server:HireMember", function(targetId)
    local _source = source
    local user = RedEM.GetPlayer(_source)
    local job, grade = user.job, user.jobgrade
    local Employee = MySQL.query.await("SELECT * FROM characters WHERE citizenid = :citizenid", { citizenid = targetId })
    if Employee[1] then
        Employee = Employee[1]
        if Employee.citizenid == targetId then
            local jogadores = GetPlayers()
            for i,v in pairs(jogadores) do
                local Funcionario = RedEM.GetPlayer(v)
                if Funcionario.citizenid == targetId then
                    if Funcionario.job == "unemployed" then
                        Funcionario.SetJob(job)
                        Funcionario.SetJobGrade(1)
                        RedEM.Functions.NotifyLeft(_source, "Saloon", "You Hired "..Employee.firstname.." "..Employee.lastname.. "!", "menu_textures", "menu_icon_tick", 3000)
                        RedEM.Functions.NotifyLeft(v, "Saloon", "You have been hired "..Employee.firstname.." "..Employee.lastname.. " for the service "..job, "menu_textures", "menu_icon_tick", 3000)
                    else
                        RedEM.Functions.NotifyLeft(_source, "Saloon", "This player already has a job!", "menu_textures", "menu_icon_alert", 3000)
                    end
                end
            end
        end
    else
        RedEM.Functions.NotifyLeft(_source, "Saloon", "Player Not Found!", "menu_textures", "menu_icon_alert", 3000)
    end
end)

RegisterServerEvent("vesgoboy_craft:server:FireMember", function(targetId)
    local _source = source
    local user = RedEM.GetPlayer(_source)
    local job, grade = user.job, user.jobgrade

    local targetUser = RedEM.GetPlayer(targetId)
    local targetJob = targetUser.job

    if targetUser.identifier == user.identifier then
        return TriggerClientEvent("notification:vesgoboy:left",_source, "Fire Member", "You Cant Fire Yourself!", Config.Textures.alert[1], Config.Textures.alert[2], 3000)
    end

    if targetJob == job then
        if targetUser.jobgrade >= grade then
            return TriggerClientEvent("notification:vesgoboy:left",_source, "Fire Member", "You cant fire your boss!", Config.Textures.alert[1], Config.Textures.alert[2], 3000)
        end

        targetUser.SetJob("unemployed")
        targetUser.SetJobGrade(0)

        TriggerClientEvent("notification:vesgoboy:left",_source, "Fire Member", "You Fire "..targetUser.GetFirstName().." "..targetUser.GetLastName().."!", Config.Textures.alert[1], Config.Textures.alert[2], 3000)
        
        TriggerClientEvent("vesgoboy_craft:client:ViewGradeList", _source, GradeList)
    else
        TriggerClientEvent("notification:vesgoboy:left",_source, "Fire Member!", "This Member Dont Work For You!", Config.Textures.alert[1], Config.Textures.alert[2], 3000)
    end
end)

RegisterServerEvent("vesgoboy_craft:server:GetFireList", function()
    local _source = source
    local user = RedEM.GetPlayer(_source)
    local job, grade = user.GetJob(), user.GetJobGrade()

    local FireList = {}
    for _,targetId in ipairs(GetPlayers()) do
        local targetUser = RedEM.GetPlayer(targetId)
        if targetUser then
            local targetJob = targetUser.GetJob()
            if targetJob == job then
                local targetName = targetUser.GetFirstName() .. " " .. targetUser.GetLastName()
                local serverName = GetPlayerName(tonumber(targetId))
                table.insert(FireList, {char = targetName, name = serverName, id = tonumber(targetId)})
            end
        end
    end
    TriggerClientEvent("vesgoboy_craft:client:ViewFireList", _source, FireList)
end)