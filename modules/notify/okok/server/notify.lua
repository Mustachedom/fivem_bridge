Bridge = Bridge or {}
Bridge.Notify = {}
function Bridge.Notify.Send(src, data)
    assert(src, "Source is required for sending a notification.")
    assert(type(data) == "table", "Data must be a table.")
    assert(data.message, "Message is required for sending a notification.")
    TriggerClientEvent('okokNotify:Alert', src, data.title or "Notification", data.message, data.time or 4000, data.type or 'info', false)
end