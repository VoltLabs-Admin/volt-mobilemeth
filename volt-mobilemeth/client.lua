local isCooking = false
local targetSystem = nil
local dispatchSystem = nil
local smokeParticles = {}

local function detectTargetSystem()
    if GetResourceState('ox_target') == 'started' then
        targetSystem = 'ox_target'
    elseif GetResourceState('qb-target') == 'started' then
        targetSystem = 'qb-target'
    elseif GetResourceState('qtarget') == 'started' then
        targetSystem = 'qtarget'
    else
        print("^1[ERROR]^7 No target system detected! Ensure ox_target, qb-target, or qtarget is installed.")
        targetSystem = nil
    end
end

local function detectDispatchSystem()
    if GetResourceState('ps-dispatch') == 'started' then
        dispatchSystem = 'ps-dispatch'
    elseif GetResourceState('qs-dispatch') == 'started' then
        dispatchSystem = 'qs-dispatch'
    else
        dispatchSystem = nil
    end
end

local function notifyPolice(vehicle)
    if math.random(1, 100) <= Config.PoliceAlertChance then
        if dispatchSystem == 'ps-dispatch' then
            exports['ps-dispatch']:SuspiciousActivity({
                title = "Meth Lab Activity",
                coords = GetEntityCoords(vehicle),
                description = "Suspicious activity detected near a Journey vehicle.",
                radius = 50,
                sprite = 564,
                color = 1,
                duration = 60000
            })
        elseif dispatchSystem == 'qs-dispatch' then
            exports['qs-dispatch']:SuspiciousActivity()
        else
            print("^3[INFO]^7 No dispatch system detected, skipping police alert.")
        end
    end
end

local function startSmoke(vehicle)
    RequestNamedPtfxAsset("core")
    while not HasNamedPtfxAssetLoaded("core") do
        Wait(10)
    end

    local smokeLoopActive = true

    CreateThread(function()
        while smokeLoopActive do
            UseParticleFxAssetNextCall("core")
            local particle = StartParticleFxLoopedOnEntity("exp_grd_petrol_pump", vehicle, 0.0, 0.0, 1.2, 0.0, 0.0, 0.0, 1.5, false, false, false)
            table.insert(smokeParticles, particle)

            Wait(500)
        end
    end)

    return function()
        smokeLoopActive = false
    end
end

local function stopSmoke()
    for _, particle in ipairs(smokeParticles) do
        StopParticleFxLooped(particle, false)
        RemoveParticleFx(particle, false)
    end
    smokeParticles = {}
end

local function enterJourney(vehicle)
    local ped = PlayerPedId()
    local coords = GetEntityCoords(vehicle)
    local forwardOffset = GetOffsetFromEntityInWorldCoords(vehicle, 0.0, -1.5, 0.0)

    TaskGoStraightToCoord(ped, forwardOffset.x, forwardOffset.y, forwardOffset.z, 1.0, 5000, GetEntityHeading(vehicle), 0.1)
    Wait(2000)

    RequestAnimDict("veh@std@ds@base")
    while not HasAnimDictLoaded("veh@std@ds@base") do
        Wait(10)
    end
    TaskPlayAnim(ped, "veh@std@ds@base", "hotwire", 8.0, -8.0, -1, 16, 0, 0, 0, 0)
    Wait(1000)

    local insideOffset = GetOffsetFromEntityInWorldCoords(vehicle, -0.5, -0.5, 1.0)
    SetEntityCoords(ped, insideOffset.x, insideOffset.y, insideOffset.z)
    SetEntityHeading(ped, GetEntityHeading(vehicle) + 90.0)
    ClearPedTasksImmediately(ped)
end

local function startCookingMeth(vehicle)
    if isCooking then
        TriggerEvent('ox_lib:notify', {
            title = 'Error',
            description = 'You are already cooking!',
            type = 'error'
        })
        return
    end

    isCooking = true
    local success = lib.skillCheck(
        {Config.MinigameDifficulty.easy, Config.MinigameDifficulty.medium, Config.MinigameDifficulty.hard},
        {'w', 'a', 's', 'd'}
    )

    if success then
        TriggerEvent('ox_lib:notify', {
            title = 'Success',
            description = 'Minigame passed! Starting meth production.',
            type = 'success'
        })

        local stopSmokeLoop = startSmoke(vehicle)
        notifyPolice(vehicle)

        local completed = lib.progressBar({
            duration = Config.CookingTime * 1000,
            label = "Producing Meth...",
            useWhileDead = false,
            canCancel = false,
            disable = {
                car = true,
                combat = true,
                move = true
            },
            anim = {
                dict = "amb@prop_human_bbq@male@idle_a",
                clip = "idle_b"
            }
        })

        stopSmokeLoop()
        stopSmoke()

        if completed then
            TriggerServerEvent('mobilemethlab:finishCooking', true)
        end
    else
        stopSmoke()

        if math.random(1, 100) <= Config.ExplosionChance then
            TriggerServerEvent('mobilemethlab:explodeVehicle')
        else
            TriggerEvent('ox_lib:notify', {
                title = 'Failed',
                description = 'You failed the meth-making process.',
                type = 'error'
            })
        end
    end

    isCooking = false
end

CreateThread(function()
    detectTargetSystem()
    detectDispatchSystem()

    local vehicleModel = Config.MethLabVehicle
    local label = "Start Cooking Meth"

    if not targetSystem then return end

    if targetSystem == 'ox_target' then
        exports.ox_target:addModel(vehicleModel, {
            {
                name = "start_cooking_meth",
                icon = "fas fa-flask",
                label = label,
                onSelect = function(data)
                    local vehicle = data.entity
                    enterJourney(vehicle)
                    Wait(2000)
                    startCookingMeth(vehicle)
                end
            }
        })
    elseif targetSystem == 'qb-target' or targetSystem == 'qtarget' then
        local options = {
            {
                event = "mobilemethlab:startCooking",
                icon = "fas fa-flask",
                label = label
            }
        }

        if targetSystem == 'qb-target' then
            exports['qb-target']:AddTargetModel(vehicleModel, {
                options = options,
                distance = 2.5
            })
        elseif targetSystem == 'qtarget' then
            exports['qtarget']:AddTargetModel({vehicleModel}, {
                options = options,
                distance = 2.5
            })
        end
    end
end)

RegisterNetEvent('mobilemethlab:explodeVehicle', function()
    local vehicle = GetVehiclePedIsIn(PlayerPedId(), false)

    if vehicle and GetEntityModel(vehicle) == GetHashKey(Config.MethLabVehicle) then
        AddExplosion(GetEntityCoords(vehicle), 2, 10.0, true, false, 1.0)
        DeleteVehicle(vehicle)
        TriggerEvent('ox_lib:notify', {
            title = 'Explosion!',
            description = 'The meth lab exploded!',
            type = 'error'
        })

        stopSmoke()
    end
end)
