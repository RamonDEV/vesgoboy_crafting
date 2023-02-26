RedEM = exports["redem_roleplay"]:RedEM()
----------------------------REDEMRP_MENU----------------------------
MenuData = {}
TriggerEvent("rdr_menu:getData",function(call)
    MenuData = call
end)
----------------------------REDEMRP_MENU----------------------------
local OpenPrompt
local PromptGroup = GetRandomIntInRange(0, 0xffffff)
local activebuttom = false

Citizen.CreateThread(function()
    SetupOpenPrompt() -- O PROMPT PRECISA FICAR FORA DO LOOP -- NESSE CASO!!!!
    while true do
        Citizen.Wait(1)
        local ped = PlayerPedId()
        local pcoords = GetEntityCoords(ped)
        local PlayerData = RedEM.GetPlayerData() -- REDEMRP:2023 PEGAR ALGUMAS FUNCÕES COMO JOB E JOBGRADE NESSE SISTEMA
        local pjob = PlayerData.job -- SETANDO VARIAVEL PARA O TRABALHO DO JOGADOR. PODE USAR DIRETO ASSIM PlayerData.job ao inves da variavel trabalho!!!!

        for ib,iv in pairs(Config.Crafting) do -- LOOP(FOR)
            local name = iv.name
            local jobcraft = iv.job
            local jobgrade = PlayerData.jobgrade
            local tablecoords = iv.tablecraft
            local between = GetDistanceBetweenCoords(pcoords, tablecoords, true)
            if between < 1.5 and not activebuttom then
                if pjob == jobcraft or jobcraft == false then
                    if IsPedOnMount(PlayerPedId()) or IsPedInAnyVehicle(PlayerPedId()) or IsPedDeadOrDying(PlayerPedId()) or IsEntityInWater(PlayerPedId()) or IsPedClimbing(PlayerPedId()) or not IsPedOnFoot(PlayerPedId()) or IsPedSittingInAnyVehicle(PlayerPedId()) then
                        MenuData.CloseAll()
                        return false
                    end
                    local label  = CreateVarString(10, 'LITERAL_STRING', name)
                    PromptSetActiveGroupThisFrame(PromptGroup, label)
                    if Citizen.InvokeNative(0xE0F65F0640EF0617,OpenPrompt) then -- UiPromptHasHoldModeCompleted 
                        activebuttom = true
                        MenuCraft(jobcraft,jobgrade)
                        Citizen.Wait(2000)
                        activebuttom = false
                    end
                end
            elseif between > 1.5 and between < 2.0 then
                MenuData.CloseAll()
            end
        end
    end
end)

function MenuCraft(jobcraft,jobgrade)
    MenuData.CloseAll()
    local elements = {}

    if jobcraft == false then
        elements = {
            {label = "Foods", value = 'foods', desc = "Cooking"},
            {label = "Drinks", value = 'drinks', desc = "Drinks"},
        }
    else
        elements = {
            {label = "Foods", value = 'foods', desc = "Cooking"},
            {label = "Drinks", value = 'drinks', desc = "Drinks"},
            {label = "Inventory", value = 'inven', desc = "Job Inventory"},
        }
        ---AQUI VOCÊ COLOCA O JOBGRADE PARA SETAR EMPREGADO DE CHEFE---
        if jobgrade > 4 then
            table.insert(elements, {label = "Hire Employees", value = "hiremployees", desc = "Hire Employees"})
            table.insert(elements, {label = "Fire an employee", value = "firemployees", desc = "Fire Employees"})
        end
    end
    
    MenuData.Open(
    'default', GetCurrentResourceName(), 'Saloon_Menu',
    {
        title    = 'Saloon',

        subtext    = 'Select a Category',

        align    = 'top-right',

        elements = elements,
    },
    function(data, menu)
        if(data.current.value == 'foods') then
            MenuCook(jobcraft,jobgrade)
        elseif(data.current.value == 'drinks') then
            MenuDrinks(jobcraft,jobgrade)
        elseif(data.current.value == 'inven') then
            menu.close()
            TriggerServerEvent("vesgoboy_craft:storage", jobcraft, 1500) -- JOB NAME AND STASH WEIGHT
        elseif(data.current.value == 'hiremployees') then
            MenuData.CloseAll()
            AddTextEntry("FMMC_MPM_TYP5", "Type Citizen ID Of Employe (must be online)")
            DisplayOnscreenKeyboard(3, "FMMC_MPM_TYP5", "", "", "", "", "", 30)
            while (UpdateOnscreenKeyboard() == 0) do
                DisableAllControlActions(0)
                Citizen.Wait(0)
            end
            if (GetOnscreenKeyboardResult()) then
                kbdRes = GetOnscreenKeyboardResult()
            else
                return
            end
            if #(kbdRes) >= 1 then
                TriggerServerEvent("vesgoboy_craft:server:HireMember", kbdRes)
            else
                RedEM.Functions.NotifyLeft("Invalid entry!", "Add a Valid Document.", "menu_textures", "menu_icon_alert", 4000)
            end
        elseif data.current.value == 'firemployees' then
            MenuData.CloseAll()
            TriggerServerEvent("vesgoboy_craft:server:GetFireList")
        end
    end,
    function(data, menu)
        menu.close()
    end)  
end

function MenuCook(jobcraft,jobgrade)
    MenuData.CloseAll()
    local elements = {}
    if jobcraft == false then
        for ib,iv in pairs(Config.FoodsNoJob) do
            local labelitem = iv.label
            local recipe = iv.recipe
            local amount = iv.amount
            local desc = iv.desc
            local resultitem = iv.resultitem
            local items = iv.items

            table.insert(elements, {
                label = labelitem, 
                recipe = recipe,
                amount = amount,
                desc = "Produce<br>"..labelitem,
                subdesc = "Ingredients<br><span style='color:red; font-size:20px;'>"..desc.."</span>",
                resultitem = resultitem,
                items = items,
                value = ib,
            })
        end
    else
        for ib,iv in pairs(Config.Foods) do
            local labelitem = iv.label
            local recipe = iv.recipe
            local amount = iv.amount
            local desc = iv.desc
            local resultitem = iv.resultitem
            local items = iv.items

            table.insert(elements, {
                label = labelitem, 
                recipe = recipe,
                amount = amount,
                desc = "Produce<br>"..labelitem,
                subdesc = "Ingredients<br><span style='color:red; font-size:20px;'>"..desc.."</span>",
                resultitem = resultitem,
                items = items,
                value = ib,
            })
        end
    end
    MenuData.Open(
    'default', GetCurrentResourceName(), 'Saloon_Menu',
    {
        title    = 'Saloon',

        subtext    = 'Select Your Production',

        align    = 'top-right',

        elements = elements,
    },
    function(data, menu)
        if(data.current.value) then
            TriggerServerEvent("vesgoboy_craft:crafting",data.current.label,data.current.recipe,data.current.amount,data.current.resultitem,data.current.items)
        end
    end,
    function(data, menu)
        menu.close()
        MenuCraft(jobcraft,jobgrade)
    end)  
end

function MenuDrinks(jobcraft,jobgrade)
    MenuData.CloseAll()
    local elements = {}

    if jobcraft == false then
        for ib,iv in pairs(Config.DrinksNoJob) do
            local labelitem = iv.label
            local recipe = iv.recipe
            local amount = iv.amount
            local desc = iv.desc
            local resultitem = iv.resultitem
            local items = iv.items

            table.insert(elements, {
                label = labelitem, 
                recipe = recipe,
                amount = amount,
                desc = "Produce<br>"..labelitem,
                subdesc = "Ingredients<br><span style='color:red; font-size:20px;'>"..desc.."</span>",
                resultitem = resultitem,
                items = items,
                value = ib,
            })
        end
    else
        for ib,iv in pairs(Config.Drinks) do
            local labelitem = iv.label
            local recipe = iv.recipe
            local amount = iv.amount
            local desc = iv.desc
            local resultitem = iv.resultitem
            local items = iv.items

            table.insert(elements, {
                label = labelitem, 
                recipe = recipe,
                amount = amount,
                desc = "Produce<br>"..labelitem,
                subdesc = "Ingredients<br><span style='color:red; font-size:20px;'>"..desc.."</span>",
                resultitem = resultitem,
                items = items,
                value = ib,
            })
        end
    end
    MenuData.Open(
    'default', GetCurrentResourceName(), 'Saloon_Menu',
    {
        title    = 'Saloon',

        subtext    = 'Select Your Production',

        align    = 'top-right',

        elements = elements,
    },
    function(data, menu)
        if(data.current.value) then
            TriggerServerEvent("vesgoboy_craft:crafting",data.current.label,data.current.recipe,data.current.amount,data.current.resultitem,data.current.items)
        end
    end,
    function(data, menu)
        menu.close()
        MenuCraft(jobcraft,jobgrade)
    end)  
end

function SetupOpenPrompt()
    Citizen.CreateThread(function()
        local str = 'Enter Menu'
        OpenPrompt = PromptRegisterBegin()
        PromptSetControlAction(OpenPrompt, 0xCEFD9220) -- E --==BOTÃO==--
        str = CreateVarString(10, 'LITERAL_STRING', str)
        PromptSetText(OpenPrompt, str)
        PromptSetEnabled(OpenPrompt, 1) -- 1 verdaeiro 0 falso
        PromptSetVisible(OpenPrompt, 1) -- 1 verdaeiro 0 falso
		PromptSetHoldMode(OpenPrompt, 5) -- UiPromptHasHoldModeCompleted -- SEGUNDOS
		PromptSetGroup(OpenPrompt, PromptGroup)
		PromptRegisterEnd(OpenPrompt)
    end)
end

FiringPlayer = nil
FiringIdentifier = nil
FiringCharID = nil
FiringName = nil

RegisterNetEvent("vesgoboy_craft:client:ViewFireList", function(FireList)
    MenuData.CloseAll()
    local elements = {}
    for k,v in ipairs(FireList) do
        table.insert(elements, {label = v.char, value = v.id, desc = "Fire Employees?"})
    end

    MenuData.Open('default', GetCurrentResourceName(), 'bossmenu_firelist', {
        title = "Fire Employees",
        subtext = "List of Employees <span style=\"color:lightgreen\">ONLINE</span>",
        align = 'top-right',
        elements = elements,
    },
    function(data, menu)
        FiringPlayer = data.current.value
        FiringName = data.current.label

        local elements = {
            {label = "Confirm", value = 'confirm', desc = "Fire "..FiringName.."?"},
            {label = "Cancel", value = 'cancel', desc = "Dont Fire Member."},
        }

        MenuData.Open('default', GetCurrentResourceName(), 'bossmenu_firelistconfirm', {
            title = "Fire Employees",
            subtext = "You Sure?",
            align = 'top-right',
            elements = elements,
        },
        function(data, menu)
            if data.current.value == "confirm" then
                menu.close()
                TriggerServerEvent("vesgoboy_craft:server:FireMember", FiringPlayer)
            elseif data.current.value == "cancel" then
                menu.close()
            end
        end,
        function(data, menu)
            menu.close()
        end)
    end,
    function(data, menu)
        menu.close()
    end)
end)

RegisterNetEvent('vesgoboy_crafting:animation')
AddEventHandler('vesgoboy_crafting:animation', function() 
    local playerPed = PlayerPedId()
    timer = true
    FreezeEntityPosition(playerPed, true)
    TaskStartScenarioInPlace(playerPed, GetHashKey('WORLD_HUMAN_CLEAN_TABLE'), Config.CraftTime, true, false, false, false)
    exports.redemrp_progressbars:DisplayProgressBar(Config.CraftTime, "Manufacturing...")
    ClearPedTasks(playerPed)
    FreezeEntityPosition(playerPed, false)
    timer = false
end)

Citizen.CreateThread(function()
	while true do
		Citizen.Wait(1)
		if timer == true then
            if IsPedDeadOrDying(PlayerPedId()) then
                timer = false
                return false
            end
			MenuData.CloseAll()
			DisableControlAction(0, 0xB03A913B, true)
			DisableControlAction(0, 0xB2F377E8, true) -- Attack
			DisableControlAction(0, 0xC1989F95, true) -- Attack 2
			DisableControlAction(0, 0x07CE1E61, true) -- Melee Attack 1
			DisableControlAction(0, 0xF84FA74F, true) -- MOUSE2
			DisableControlAction(0, 0xCEE12B50, true) -- MOUSE3
			DisableControlAction(0, 0x8FFC75D6, true) -- Shift
			DisableControlAction(0, 0xD9D0E1C0, true) -- SPACE
            DisableControlAction(0, 0xCEFD9220, true) -- E
            DisableControlAction(0, 0xF3830D8E, true) -- J
            DisableControlAction(0, 0x80F28E95, true) -- L
            DisableControlAction(0, 0xDB096B85, true) -- CTRL
            DisableControlAction(0, 0xE30CD707, true) -- R
			DisableControlAction(0, 0x4CC0E2FE, true) -- B
			DisableControlAction(0, 0xC1989F95, true) -- I
            TriggerEvent("redemrp_inventory:closeinv")
		end
	end
end)