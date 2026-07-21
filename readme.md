# Usage

`fivem_bridge` exposes every function as an export. Pick whichever pattern fits how much of the bridge you actually need.

## 1. Direct export call

No setup — call straight through the export.

```lua
local Player = exports.fivem_bridge:GetPlayer(src)
```

## 2. Inject the whole bridge

Prefer working with `Bridge.Framework.X` / `Bridge.Inventory.X` syntax? Pull the full bridge table once and reuse it.

```lua
local Bridge = exports.fivem_bridge:Bridge()
local Player = Bridge.Framework.GetPlayer(src)
```

Simplest to read, but it loads every module even if you only touch one or two functions.

## 3. Lazy-load specific modules

Only need a couple of modules? Ask for those by name and skip the rest.

```lua
local Framework, Inventory = exports.fivem_bridge:Modules({'Framework', 'Inventory'})

local Player = Framework.GetPlayer(src)
local removedItem = Inventory.RemoveItem(src, 'lockpick', 1)
```

## 4. Hardcoded functions via injector

For the fastest path with zero export overhead, add the injector to your `fxmanifest.lua`:

```lua
shared_scripts {
    '@fivem_bridge/injector.lua',
}
```

Then call functions directly as globals, no `exports` call at all:

```lua
local Player = Framework_GetPlayer(src)
local removedItem = Inventory_RemoveItem(src, 'lockpick', 1)
```

## Which one should I use?

| Method | Setup | Best for |
|---|---|---|
| Direct export | None | One-off calls, quick scripts |
| `Bridge()` | One call | Resources that touch most modules |
| `Modules({...})` | One call | Resources that only need a few modules |
| Injector globals | Manifest entry | Performance-sensitive or high-frequency calls |
