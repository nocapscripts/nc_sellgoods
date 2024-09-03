local Core = exports.redux_fw:GetCoreObject()

local DealerVehicle = nil


-- Functions
function NPCInteractWithStorage(vehicle)
    print(json.encode(vehicle))
    local vehicleStorageId =  Core.Functions.GetPlate(vehicle)
    local items = lib.callback.await('goods:server:GetVehicleInventory', false, vehicleStorageId)
    exports.ox_inventory:openInventory('trunk', vehicleStorageId)
    if #items > 0 then

        local luck = math.random(2)
        if luck == 1 then
            local paymentAmount = CalculatePayment(items)
            TriggerServerEvent('goods:AddItem', 'money', paymentAmount)
            TriggerServerEvent('goods:RemoveItem', vehicleStorageId, items)
            TriggerEvent('DoLongHudText', "NPC bought the items for $" .. paymentAmount)
        else
            TriggerEvent('DoLongHudText', "NPC rejected the items!")
            DeletePed(npc)
            Wait(1000)
            local newNpcModel = MakePedModel()
            local newNpc = SpawnNPC(newNpcModel, math.random(3))
        end
    else
        TriggerEvent('DoLongHudText', "Storage is empty!")
    end
end

function CalculatePayment(items)
    local totalValue = 0
    for _, item in pairs(items) do
        local itemValue = GetItemValue(item.name) 
        totalValue = totalValue + (itemValue * item.count)
    end
    return totalValue
end

-- Example function to get item value (replace with your own logic)
function GetItemValue(itemName)
    local itemValues = {
        ['phone'] = 100,
        ['diamond'] = 200,
        ['burger'] = 50,
    }
    return itemValues[itemName] or 0
end

-- Debug commands
RegisterCommand('npcstorage', function(source, args, rawCommand)
    
    local pedModel = MakePedModel()
    local npc = CreateBuyer(pedModel, math.random(3))

end, false)

RegisterCommand('carbox', function(source, args, rawCommand)
    local playerPed = PlayerPedId()
    local playerCoords = GetEntityCoords(playerPed)

    local vehicle = lib.getClosestVehicle(playerCoords, 3.0, false)
    local vehicleStorageId =  Core.Functions.GetPlate(vehicle)
    
    local items = lib.callback.await('goods:server:GetVehicleInventory', false, vehicleStorageId)

end, false)


-- Events
RegisterNetEvent('goods:Interact', function()
    local playerPed = PlayerPedId()
    local playerCoords = GetEntityCoords(playerPed)

    local vehicle = lib.getClosestVehicle(playerCoords, 3.0, false)

    if vehicle and DoesEntityExist(vehicle) then
        NPCInteractWithStorage(vehicle)
    else
        TriggerEvent('DoLongHudText', "No vehicle nearby!", 2)
    end



end)




