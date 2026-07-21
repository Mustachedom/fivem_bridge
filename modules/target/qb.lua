Bridge = Bridge or {}

Bridge.Target = {}

Bridge.Target.Script = "qb"
local scriptTargets = {}
local target = exports['qb-target']
local function compatOptions(opts)
    local distance = 0
    for i = 1, #opts do
        if opts[i].distance and distance < opts[i].distance then
            distance = opts[i].distance
        end
        if opts[i].onSelect then
            opts[i].action = opts[i].onSelect
            opts[i].onSelect = nil
        end
    end
    if distance == 0 then
        distance = 2.5
    end
    return opts, distance
end

function Bridge.Target.BoxZone(name, coords, size, options, debug)
    assert(name, "Name is required for BoxZone.")
    assert(coords, "Coords are required for BoxZone.")
    assert(options and type(options) == "table" and #options > 0, "Options are required for BoxZone.")
    local resource = GetInvokingResource() or 'fivem_bridge'
    assert(not (scriptTargets[resource] and scriptTargets[resource][name]), ("BoxZone with name '%s' already exists for resource '%s'."):format(name, resource))
    local opts, distance = compatOptions(options)
    local zone = target:AddBoxZone(name, coords, size.x, size.y, {
        name = name,
        debugPoly = debug or false,
        minZ = coords.z - (size.z or 1.0),
        maxZ = coords.z + (size.z or 1.0),
        heading = coords.w or 0.0,
    }, {
        options = opts,
        distance = distance,
    })
    scriptTargets[resource] = scriptTargets[resource] or {}
    scriptTargets[resource][name] = zone
    return zone
end

function Bridge.Target.SphereZone(name, coords, radius, options, debug)
    assert(name, "Name is required for SphereZone.")
    assert(coords, "Coords are required for SphereZone.")
    assert(options and type(options) == "table" and #options > 0, "Options are required for SphereZone.")
    local resource = GetInvokingResource() or 'fivem_bridge'
    assert(not (scriptTargets[resource] and scriptTargets[resource][name]), ("SphereZone with name '%s' already exists for resource '%s'."):format(name, resource))
    local opts, distance = compatOptions(options)
    local zone = target:AddCircleZone(name, coords, radius, {
        name = name,
        debugPoly = debug or false,
        useZ = true,
    }, {
        options = opts,
        distance = distance,
    })
    scriptTargets[resource] = scriptTargets[resource] or {}
    scriptTargets[resource][name] = zone
    return zone
end

function Bridge.Target.LocalEntity(entity, options)
    assert(entity, "Entity is required for LocalEntity.")
    assert(options and type(options) == "table" and #options > 0, "Options are required for LocalEntity.")
    local resource = GetInvokingResource() or 'fivem_bridge'
    assert(not (scriptTargets[resource] and scriptTargets[resource][entity]), ("LocalEntity with entity '%s' already exists for resource '%s'."):format(entity, resource))
    local opts, distance = compatOptions(options)
    local zone = target:AddTargetEntity(entity, {
        options = opts,
        distance = distance,
    })
    scriptTargets[resource] = scriptTargets[resource] or {}
    scriptTargets[resource][entity] = zone
    return zone
end

function Bridge.Target.TargetModel(model, options)
    assert(model, "Model is required for TargetModel.")
    assert(options and type(options) == "table" and #options > 0, "Options are required for TargetModel.")
    local resource = GetInvokingResource() or 'fivem_bridge'
    assert(not (scriptTargets[resource] and scriptTargets[resource][model]), ("TargetModel with model '%s' already exists for resource '%s'."):format(model, resource))
    local opts, distance = compatOptions(options)
    local zone = target:AddTargetModel(model, {
        options = opts,
        distance = distance,
    })
    scriptTargets[resource] = scriptTargets[resource] or {}
    scriptTargets[resource][model] = zone
    return zone
end

function Bridge.Target.TargetPed(ped, options)
    assert(ped, "Ped is required for TargetPed.")
    assert(options and type(options) == "table" and #options > 0, "Options are required for TargetPed.")
    local resource = GetInvokingResource() or 'fivem_bridge'
    assert(not (scriptTargets[resource] and scriptTargets[resource][ped]), ("TargetPed with ped '%s' already exists for resource '%s'."):format(ped, resource))
    local opts, distance = compatOptions(options)
    local zone = target:AddGlobalPed(ped, {
        options = opts,
        distance = distance,
    })
    scriptTargets[resource] = scriptTargets[resource] or {}
    scriptTargets[resource][ped] = zone
    return zone
end

function Bridge.Target.GlobalVehicle(options)
    assert(options and type(options) == "table" and #options > 0, "Options are required for GlobalVehicle.")
    local resource = GetInvokingResource() or 'fivem_bridge'
    assert(not (scriptTargets[resource] and scriptTargets[resource]["global_vehicle"]), ("GlobalVehicle already exists for resource '%s'."):format(resource))
    local opts, distance = compatOptions(options)
    local zone = target:AddGlobalVehicle({
        options = opts,
        distance = distance,
    })
    scriptTargets[resource] = scriptTargets[resource] or {}
    scriptTargets[resource]["global_vehicle"] = zone
    return zone
end

function Bridge.Target.RemoveZone(name)
    assert(name, "Name is required for RemoveZone.")
    local resource = GetInvokingResource() or 'fivem_bridge'
    if scriptTargets[resource] and scriptTargets[resource][name] then
        target:RemoveZone(name)
        scriptTargets[resource][name] = nil
    else
        error(("No zone with name '%s' found for resource '%s'."):format(name, resource))
    end
end

AddEventHandler('onResourceStop', function(resourceName)
    if scriptTargets[resourceName] then
        for name, _ in pairs(scriptTargets[resourceName]) do
            target:RemoveZone(name)
        end
        scriptTargets[resourceName] = nil
    end
end)

