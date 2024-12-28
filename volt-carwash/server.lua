local QBCore = exports['qb-core']:GetCoreObject()

QBCore.Functions.CreateUseableItem("cleaningkit", function(source, item)
    local Player = QBCore.Functions.GetPlayer(source)
    if Player then
        TriggerClientEvent('qb-simplecarwash:useCleaningKit', source)
    end
end)

RegisterServerEvent('qb-simplecarwash:syncDirtLevel')
AddEventHandler('qb-simplecarwash:syncDirtLevel', function(vehicleNetId)
    TriggerClientEvent('qb-simplecarwash:clientSetDirtLevel', -1, vehicleNetId)
end)
