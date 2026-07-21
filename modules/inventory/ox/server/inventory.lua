Bridge = Bridge or {}
Bridge.Inventory = {}
local Inv = exports.ox_inventory
Bridge.Inventory.Script = "ox"
function Bridge.Inventory.HasItem(src, itemName, amount)
    assert(src, "Source is required for checking an item.")
    assert(itemName, "Item name is required for checking an item.")
    assert(type(itemName) == 'string', "Item name must be a string.")
    if not amount then amount = 1 end
    return Inv:GetItemCount(src, itemName) >= amount
end


function Bridge.Inventory.HasItems(src, items)
    assert(src, "Source is required for checking items.")
    assert(items, "Items table is required for checking items.")
    assert(type(items) == 'table', "Items must be provided as a table.")
    local need, has = 0,0
    for itemName, amount in pairs(items) do
        need = need + 1
        if Bridge.Inventory.HasItem(src, itemName, amount) then
            has = has + 1
        end
    end
    return has == need
end

local function canCarry(src, itemName, amount)
    return Inv:CanCarryItem(src, itemName, amount)
end

function Bridge.Inventory.AddItem(src, itemName, amount, metadata, slot, reason)
    assert(src, "Source is required for adding an item.")
    assert(itemName, "Item name is required for adding an item.")
    assert(type(itemName) == 'string', "Item name must be a string.")
    if not amount then amount = 1 end
    assert(canCarry(src, itemName, amount), "Cannot carry item.")
    return Inv:AddItem(src, itemName, amount, metadata, slot, reason)
end

function Bridge.Inventory.RemoveItem(src, itemName, amount, slot)
    assert(src, "Source is required for removing an item.")
    assert(itemName, "Item name is required for removing an item.")
    assert(type(itemName) == 'string', "Item name must be a string.")
    if not amount then amount = 1 end
    return Inv:RemoveItem(src, itemName, amount, slot)
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
    exports.ox_inventory:RegisterStash(stashName, newData.label, newData.slots, newData.maxweight)
    ---TODO: Add an event to open the stash for the player
end

function Bridge.Inventory.GetFreeWeight(src)
    assert(src, "Source is required for getting free weight.")
    local canCarry, free = Inv:CanCarryWeight(src, 0)
    return free
end

function Bridge.Inventory.OpenPlayerInventory(src, target)
    assert(src, "Source is required for opening player inventory.")
    assert(target, "Target is required for opening player inventory.")
    assert(type(src) == "number" and type(target) == "number", "Source and target must be numbers.")
    Inv:forceOpenInventory(src, 'player', target)
end

function Bridge.Inventory.GetItemCount(src, itemName)
    assert(src, "Source is required for getting item count.")
    assert(itemName, "Item name is required for getting item count.")
    assert(type(itemName) == 'string', "Item name must be a string.")
    return Inv:GetItemCount(src, itemName)
end

function Bridge.Inventory.OpenShop(src, shopData)
    assert(src, "Source is required for opening a shop.")
    assert(shopData, "Shop data is required for opening a shop.")
    assert(type(shopData) == 'table', "Shop data must be provided as a table.")
    assert(shopData.items, "Shop data must include items.")
    Inv:RegisterShop({
        name = shopData.name or "Shop",
        inventory = shopData.items,
    })
    --TODO: Add an event to open the shop for the player
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