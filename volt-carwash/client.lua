local QBCore = exports['qb-core']:GetCoreObject()

local isWashing = false

RegisterNetEvent('qb-simplecarwash:useCleaningKit', function()
    if isWashing then
        QBCore.Functions.Notify("You are already washing a car.", "error")
        return
    end

    local ped = PlayerPedId()
    local vehicle = QBCore.Functions.GetClosestVehicle()

    if vehicle == 0 or not DoesEntityExist(vehicle) then
        QBCore.Functions.Notify("No vehicle nearby to clean.", "error")
        return
    end

    local playerData = QBCore.Functions.GetPlayerData()
    if not Config.AllowedJobs[playerData.job.name] then
        QBCore.Functions.Notify("Your job does not allow you to clean vehicles.", "error")
        return
    end

    isWashing = true

    QBCore.Functions.Progressbar("washing_vehicle", "Washing the vehicle...", Config.WashTime * 1000, false, true, {
        disableMovement = true,
        disableCarMovement = true,
        disableMouse = false,
        disableCombat = true,
    }, {
        animDict = "timetable@floyd@clean_kitchen@base",
        anim = "base",
        flags = 49,
    }, {}, {}, function() 

        local vehicleNetId = NetworkGetNetworkIdFromEntity(vehicle)
        TriggerServerEvent('qb-simplecarwash:syncDirtLevel', vehicleNetId)
        
        ClearPedTasks(ped)
        QBCore.Functions.Notify("The vehicle is now clean!", "success")
        isWashing = false
    end, function() -- On Cancel
        ClearPedTasks(ped)
        QBCore.Functions.Notify("You stopped washing the vehicle.", "error")
        isWashing = false
    end)
end)

RegisterNetEvent('qb-simplecarwash:clientSetDirtLevel', function(vehicleNetId)
    local vehicle = NetworkGetEntityFromNetworkId(vehicleNetId)
    if DoesEntityExist(vehicle) then
        SetVehicleDirtLevel(vehicle, 0.0) 
    end
end)
