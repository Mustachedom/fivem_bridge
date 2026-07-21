Bridge = Bridge or {}
Bridge.Notify = Bridge.Notify or {}
print("Notify module initialized.")

function Bridge.Notify.Send(title, message, type, time)
    assert(message, "Message is required for sending a notification.")
    TriggerClientEvent('esx:showNotification', -1, message, type or 'info', time or 5000)
end