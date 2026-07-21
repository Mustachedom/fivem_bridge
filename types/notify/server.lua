---@meta

Bridge = Bridge or {}

---@class NotifyBridge
---@field Send fun(src: integer|string, title?: string, message: string, type?: NotifyType, time?: integer)

---@type NotifyBridge
Bridge.Notify = Bridge.Notify


---@alias NotifyType
---| "info"
---| "success"
---| "error"
---| "warning"