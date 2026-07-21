Bridge = Bridge or {}
Bridge.Notify = {}
print("Notify module initialized.")
function Bridge.Notify.Send(src, title, message, type, time)
    assert(src, "Source is required for sending a notification.")
    assert(message, "Message is required for sending a notification.")
    TriggerClientEvent('okokNotify:Alert', src, title, message, time or 4000, type or 'info', false)
end