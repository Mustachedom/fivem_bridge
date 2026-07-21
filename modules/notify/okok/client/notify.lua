Bridge = Bridge or {}
Bridge.Notify = Bridge.Notify or {}
print("Notify module initialized.")
function Bridge.Notify.Send(title, message, type, time)
    assert(message, "Message is required for sending a notification.")

    exports['okokNotify']:Alert(title, message, time or 5000, type or 'info', false)
end