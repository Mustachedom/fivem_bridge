Bridge = Bridge or {}
Bridge.Notify = Bridge.Notify or {}
print("Notify module initialized.")
function Bridge.Notify.Send(title, message, type, time)
    assert(message, "Message is required for sending a notification.")
    if type == 'error' then
        exports['mad-thoughts']:error(message, time / 1000 or 4)
    elseif type == 'success' then
        exports['mad-thoughts']:success(message, time / 1000 or 4)
    elseif type == 'warning' then
        exports['mad-thoughts']:warning(message, time / 1000 or 4)
    else
        exports['mad-thoughts']:info(message, time / 1000 or 4)
    end
end