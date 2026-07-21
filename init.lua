Bridge = {}


local function resolvePath(filePath)
    local path = filePath:gsub('%.', '/')
    return path .. '.lua'
end

local function loadFile(resource, path)
    local content = LoadResourceFile(resource, path)
    if not content then return nil end

    local chunk, err = load(content, ('@@%s/%s'):format(resource, path))
    if not chunk then
        error(("Error loading '%s': %s"):format(path, err))
    end

    return chunk
end

local function requireFile(filePath, resource)
    if type(filePath) ~= 'string' then
        error(("module name must be a string (got %s)"):format(type(filePath)))
    end
    resource = resource or (GetInvokingResource() or "fivem_bridge")

    local key = resource .. ':' .. filePath
    local path = resolvePath(filePath)
    local chunk = loadFile(resource, path)

    if not chunk then
        error(("module '%s' not found in resource '%s'"):format(filePath, resource))
    end
    return chunk()
end

exports('require', requireFile)

local function importBridge(moduleName)
    if not moduleName then
        return Bridge
    end
    if type(moduleName) ~= "table" then
        error(("Expected table or nil, got %s"):format(type(moduleName)))
    end
    local nested = {}
    for i = 1, #moduleName do
        if Bridge[moduleName[i]] then
            nested = Bridge[moduleName[i]]
        else
            return nil
        end
    end
    return table.unpack(nested)
end

exports('importBridge', importBridge)
local config = requireFile('settings', 'fivem_bridge')
local loader = {
    framework = {
        client = 'modules.framework.' .. config.framework .. '.client.framework',
        server = 'modules.framework.' .. config.framework .. '.server.framework'
    },
    inventory = {
        client = 'modules.inventory.' .. config.inventory .. '.client.inventory',
        server = 'modules.inventory.' .. config.inventory .. '.server.inventory'
    },
    target = {
        client = 'modules.target.' .. config.target,
    },
    notify = {
        client = 'modules.notify.' .. config.Notify .. '.client.notify',
        server = 'modules.notify.' .. config.Notify .. '.server.notify'
    },
    progressbar = {
        client = 'modules.progressbar.' .. config.progressbar,
    },
    emotes = {
        client = 'modules.emotes.' .. config.emotes,
    },
    banking = {
        server = 'modules.banking.' .. config.banking
    }
}

for module, side in pairs(loader) do
    if IsDuplicityVersion() and side.server then
        requireFile(side.server, 'fivem_bridge')
    elseif not IsDuplicityVersion() and side.client then
        requireFile(side.client, 'fivem_bridge')
    end
end