Bridge = Bridge or {}
Bridge.Emote = {}

Bridge.Emote.Script = "scully"
function Bridge.Emote.Play(emoteName, variant)
    exports.scully_emotemenu:playEmoteByCommand(emoteName, variant)
end

function Bridge.Emote.Stop()
    exports.scully_emotemenu:cancelEmote()
end