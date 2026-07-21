Bridge = Bridge or {}
Bridge.Inventory = {}
local Inv = exports['qb-inventory']
Bridge.Inventory.Script = "qb"

function Bridge.Inventory.HasItem(src, itemName, amount)
    assert(src, "Source is required for checking an item.")
    assert(itemName, "Item name is required for checking an item.")
    assert(type(itemName) == 'string', "Item name must be a string.")
    if not amount then amount = 1 end
    if type(src) == 'string' and #src == 8 then
        local player = exports['qb-core']:GetPlayerByCitizenId(src)
        local hasItem = player.Functions.GetItemByName(itemName)
        return hasItem and hasItem.amount >= amount
    end
    return Inv:HasItem(src, itemName, amount)
end


function Bridge.Inventory.HasItems(src, items)
    assert(src, "Source is required for checking items.")
    assert(items, "Items table is required for checking items.")
    assert(type(items) == 'table', "Items must be provided as a table.")
    if type(src) == 'string' and #src == 8 then
        local player = exports['qb-core']:GetPlayerByCitizenId(src)
        for itemName, amount in pairs(items) do
            local hasItem = player.Functions.GetItemByName(itemName)
            if not hasItem or hasItem.amount < amount then
                return false
            end
        end
        return true
    end
    local has, need = 0,0
    for itemName, amount in pairs(items) do
        need = need + 1
        if Inv:HasItem(src, itemName, amount) then
            has = has + 1
        end
    end
    return has == need
end


function Bridge.Inventory.AddItem(src, itemName, amount, metadata, slot, reason)
    assert(src, "Source is required for adding an item.")
    assert(itemName, "Item name is required for adding an item.")
    assert(type(itemName) == 'string', "Item name must be a string.")
    if not amount then amount = 1 end
    return Inv:AddItem(src, itemName, amount, slot, metadata, reason)
end

function Bridge.Inventory.RemoveItem(src, itemName, amount, slot, reason)
    assert(src, "Source is required for removing an item.")
    assert(itemName, "Item name is required for removing an item.")
    assert(type(itemName) == 'string', "Item name must be a string.")
    if not amount then amount = 1 end
    return Inv:RemoveItem(src, itemName, amount, slot, reason)
end

function Bridge.Inventory.OpenStash(src, stashName, data)
    assert(src, "Source is required for opening a stash.")
    assert(stashName, "Stash name is required for opening a stash.")
    assert(type(stashName) == 'string', "Stash name must be a string.")
    local newData = {
        label = data and data.label or "Stash",
        slots = data and data.slots or 20,
        maxweight = data and data.maxweight or 1000000,
    }
    Inv:OpenInventory(src, stashName, newData)
end

function Bridge.Inventory.GetFreeWeight(src)
    assert(src, "Source is required for getting free weight.")
    return exports['qb-inventory']:GetFreeWeight(src)
end

function Bridge.Inventory.OpenPlayerInventory(src, target)
    assert(src, "Source is required for opening player inventory.")
    assert(target, "Target is required for opening player inventory.")
    assert(type(src) == "number" and type(target) == "number", "Source and target must be numbers.")
    Inv:OpenInventory(src, target)
end

function Bridge.Inventory.GetItemCount(src, itemName)
    assert(src, "Source is required for getting item count.")
    assert(itemName, "Item name is required for getting item count.")
    assert(type(itemName) == 'string', "Item name must be a string.")
    if type(src) == 'string' and #src == 8 then
        local player = exports['qb-core']:GetPlayerByCitizenId(src)
        local item = player.Functions.GetItemByName(itemName)
        return item and item.amount or 0
    end
    return Inv:GetItemCount(src, itemName)
end

function Bridge.Inventory.OpenShop(src, shopData)
    assert(src, "Source is required for opening a shop.")
    assert(shopData, "Shop data is required for opening a shop.")
    assert(type(shopData) == 'table', "Shop data must be provided as a table.")
    assert(shopData.items, "Shop data must include items.")
    Inv:CreateShop({
        name = shopData.name or "Shop",
        label = shopData.label or "Shop",
        slots = shopData.slots or 20,
        items = shopData.items,
    })
    Inv:OpenShop(src, shopData.name or "Shop")
end

function Bridge.Inventory.CraftItem(src, craftingData)
    assert(src, "Source is required for crafting an item.")
    assert(craftingData, "Crafting data is required for crafting an item.")
    assert(type(craftingData) == 'table', "Crafting data must be provided as a table.")
    assert(craftingData.item, "Crafting data must include the item to craft.")
    assert(craftingData.amount, "Crafting data must include the amount to craft.")
    assert(craftingData.recipe, "Crafting data must include the recipe.")
    local need, has, failedAlert = 0,0, {}
    for k, v in pairs(craftingData.recipe) do
        need = need + 1
        local hasItem = Bridge.Inventory.HasItem(src, v.item, v.amount)
        if hasItem then
            has = has + 1
        else
            table.insert(failedAlert, 'You Need ' .. v.amount .. ' x ' .. v.item)
        end
    end
    if has ~= need then
        for _, alert in pairs(failedAlert) do
            Bridge.Notify.Send(src, 'Missing Items', alert, "error")
        end
        return false
    end
    for k, v in pairs(craftingData.recipe) do
       if not Bridge.Inventory.RemoveItem(src, v.item, v.amount) then
            Bridge.Notify.Send(src, 'Missing Items', 'Failed to remove required items for crafting.', "error")
            return false
        end
    end
    return Bridge.Inventory.AddItem(src, craftingData.item, craftingData.amount)
end