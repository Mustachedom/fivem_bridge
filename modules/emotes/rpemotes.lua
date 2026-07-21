Bridge = Bridge or {}
Bridge.Emote = {}

Bridge.Emote.Script = "rpemotes"
function Bridge.Emote.Play(emoteName, variant)
    exports["rpemotes"]:EmoteCommandStart(emoteName, variant)
end

function Bridge.Emote.Stop()
    exports["rpemotes"]:EmoteCancel()
end