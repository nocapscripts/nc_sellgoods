local Core = exports.redux_fw:GetCoreObject()

-- Callback to get vehicle trunk items
-- This currently not working i dont know why 
lib.callback.register('goods:server:GetVehicleInventory', function(source, inv)
    local player = Core.Functions.GetPlayerFromId(source)
    local inventoryId = tostring(inv)

    print("Attempting to retrieve inventory with ID:", inventoryId)

    local items = exports.ox_inventory:GetInventoryItems(inventoryId, false)


    if player then
        print("Items in Inventory:", json.encode(items))
        return items or nil
    else
        print("Failed to retrieve items from inventory:", inventoryId)
        return {}
    end
end)



function RemoveItems(inv, item)
  
    exports.ox_inventory:RemoveItem(inv, item.name, item.count, nil, nil, true)
end


RegisterNetEvent('goods:RemoveItems', function(inv, item)

    RemoveItems(inv, item)
end)
