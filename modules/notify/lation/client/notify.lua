Bridge = Bridge or {}
Bridge.Notify = Bridge.Notify or {}
print("Notify module initialized.")

function Bridge.Notify.Send(title, message, type, time)
    assert(message, "Message is required for sending a notification.")
    exports.lation_ui:notify( {
        title = title or 'Notification',
        message = message,
        type = type or 'success',
        duration = time or 5000
    })
end