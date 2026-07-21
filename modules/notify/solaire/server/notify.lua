Bridge = Bridge or {}
Bridge.Notify = {}
print("Notify module initialized.")
function Bridge.Notify.Send(src, title, message, type, time)
    assert(src, "Source is required for sending a notification.")
    assert(message, "Message is required for sending a notification.")
    exports.solaire_notify:Send(src, {
        title = title or "Notification",
        message = message,
        type = type or 'info',
        duration = time or 5000
    })
end