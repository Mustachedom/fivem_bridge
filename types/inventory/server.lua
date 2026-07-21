---@meta

Bridge = Bridge or {}

---@class InventoryBridge
---@field Script string The name of the inventory script (e.g., "qb", "ox").
---@field HasItem fun(src: integer|string, itemName: string, amount?: integer): boolean
---@field HasItems fun(src: integer|string, items: table<string, integer>): boolean
---@field AddItem fun(src: integer|string, itemName: string, amount?: integer, metadata?: table, slot?: integer, reason?: string): boolean
---@field RemoveItem fun(src: integer|string, itemName: string, amount?: integer, slot?: integer, reason?: string): boolean
---@field OpenStash fun(src: integer, stashName: string, data?: StashData)
---@field GetFreeWeight fun(src: integer|string): integer
---@field OpenPlayerInventory fun(src: integer, target: integer)
---@field GetItemCount fun(src: integer|string, itemName: string): integer
---@field OpenShop fun(src: integer, shopData: ShopData)
---@field CraftItem fun(src: integer|string, craftingData: CraftingData): boolean

---@type InventoryBridge
Bridge.Inventory = Bridge.Inventory

---@class StashData
---@field label? string
---@field slots? integer
---@field maxweight? integer

---@class ShopItem
---@field name string
---@field price number
---@field amount? integer
---@field info? table
---@field type? string
---@field slot? integer
---@field requiredJob? string|string[]

---@class ShopData
---@field name? string
---@field label? string
---@field slots? integer
---@field items ShopItem[]

---@class CraftingRecipe
---@field item string
---@field amount integer

---@class CraftingData
---@field item string
---@field amount integer
---@field recipe CraftingRecipe[]