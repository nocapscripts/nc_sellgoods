local Targets = {}

-- Model loader
function loadModel(model)
    RequestModel(model)
    while not HasModelLoaded(model) do
        Wait(0)
    end
end

-- Anim loader
function loadAnimDict(dict)
    RequestAnimDict(dict)
    while not HasAnimDictLoaded(dict) do
        Wait(0)
    end
end

-- Random model gen
function MakePedModel()
    local totalPeds = #Config.Peds
    local randomIndex = math.random(1, totalPeds)
    return Config.Peds[randomIndex]
end

-- Createpeds
function CreateBuyer(model, spawn)
    loadModel(model)
    loadAnimDict('switch@michael@parkbench_smoke_ranger')

    local pedCoords = vector3(Config.PedSpawns[spawn].x, Config.PedSpawns[spawn].y, Config.PedSpawns[spawn].z)
    local pedHeading = Config.PedSpawns[spawn].w

    local ped = CreatePed(4, model, pedCoords.x, pedCoords.y, pedCoords.z, pedHeading, true, true)
    FreezeEntityPosition(ped, true)
    SetEntityInvincible(ped, true)
    SetBlockingOfNonTemporaryEvents(ped, true)

    TaskStartScenarioInPlace(ped, 'WORLD_HUMAN_SMOKING', 0, false)

    local blip = AddBlipForCoord(pedCoords.x, pedCoords.y, pedCoords.z)
    SetBlipSprite(blip, 280)
    SetNewWaypoint(pedCoords.x, pedCoords.y)

    Targets['buyer'] = exports.ox_target:addModel(model, {
        {
            event = 'goods:Interact',
            icon = 'fa-solid fa-money-bill',
            label = 'Speak with him',
        }
    })

    return ped
end
