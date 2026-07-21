Bridge = Bridge or {}
Bridge.Notify = {}
print("Notify module initialized.")
function Bridge.Notify.Send(src, title, message, type, time)
    assert(src, "Source is required for sending a notification.")
    assert(message, "Message is required for sending a notification.")
    if type == 'error' then
        exports['mad-thoughts']:error(src, message, time / 1000 or 4)
    elseif type == 'success' then
        exports['mad-thoughts']:success(src, message, time / 1000 or 4)
    elseif type == 'warning' then
        exports['mad-thoughts']:warning(src, message, time / 1000 or 4)
    else
        exports['mad-thoughts']:info(src, message, time / 1000 or 4)
    end
end