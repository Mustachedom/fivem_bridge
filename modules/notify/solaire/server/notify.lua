Bridge = Bridge or {}
Bridge.Notify = {}

function Bridge.Notify.Send(src, data)
    assert(src, "Source is required for sending a notification.")
    assert(type(data) == "table", "Data must be a table.")
    assert(data.message, "Message is required for sending a notification.")
    exports.solaire_notify:Send(src, {
        title = data.title or "Notification",
        message = data.message,
        type = data.type or 'info',
        duration = data.time or 5000
    })
end