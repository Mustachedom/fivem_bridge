Bridge = Bridge or {}
Bridge.Notify = {}
print("Notify module initialized.")
function Bridge.Notify.Send(src, title, message, type, time)
    assert(src, "Source is required for sending a notification.")
    assert(message, "Message is required for sending a notification.")
    TriggerClientEvent('lation_ui:notify', src, {
        title = title or 'Notification',
        message = message,
        type = type or 'success',
        duration = time or 5000
    })
end