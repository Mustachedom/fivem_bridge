local bridge = exports.fivem_bridge:importBridge()
for moduleName, module in pairs(bridge) do
    for functionName, func in pairs(module) do
        local globalName = moduleName .. "_" .. functionName
        if not _G[globalName] then
            _G[globalName] = func
        end
    end
end