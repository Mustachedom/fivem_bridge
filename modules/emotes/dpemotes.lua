Bridge = Bridge or {}
Bridge.Emote = {}

Bridge.Emote.Script = "dpemotes"
function Bridge.Emote.Play(emoteName, variant)
    TriggerEvent('animations:client:EmoteCommandStart', {emoteName, variant})
end

function Bridge.Emote.Stop()
    TriggerEvent('animations:client:EmoteCommandStart', {"c"})
end