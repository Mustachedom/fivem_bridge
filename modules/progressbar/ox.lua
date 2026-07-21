local preference = GetResourceKvpString('fivem_bridge:progressbar')
if not preference then
    preference = 'bar'
    SetResourceKvp('fivem_bridge:progressbar', preference)
end

RegisterCommand('changeProgressbar', function(source, args)
    local newPreference = args[1]
    if newPreference == 'bar' or newPreference == 'circle' then
        preference = newPreference
        SetResourceKvp('fivem_bridge:progressbar', preference)
        print('Progress bar preference changed to: ' .. preference)
    else
        print('Invalid preference. Use "bar" or "circle".')
    end
end, false)

TriggerEvent('chat:addSuggestion', '/changeProgressbar', 'Change the progress bar preference', {
    { name = 'preference', help = 'Enter "bar" or "circle"' }
})

Bridge = Bridge or {}
Bridge.Progressbar = {}

local function returnProps(props)
    if type(props) == 'table' then
        return {props.prop, props.proptwo}
    end
    return nil
end

function Bridge.Progressbar.Start(label, duration, animation, props, terms)
    if not label then label = "Progress" end
    if not duration then duration = 5000 end
    if type(animation) == 'string' then
        Bridge.Emotes.Play(animation)
    end
    if preference == 'bar' then
        local success = lib.progressBar({
            duration = duration,
            label = label,
            useWhileDead = terms and terms.useWhileDead or false,
            canCancel = terms and terms.canCancel or false,
            disable = terms and terms.disable or {},
            anim = type(animation) == 'table' and animation or nil,
            prop = props,
        })
        Bridge.Emotes.Stop()
        return success
    elseif preference == 'circle' then
        local success = lib.circleProgress({
            duration = duration,
            label = label,
            useWhileDead = terms and terms.useWhileDead or false,
            canCancel = terms and terms.canCancel or true,
            disable = terms and terms.disable or {},
            anim = type(animation) == 'table' and animation or nil,
            prop = returnProps(props),
        })
        Bridge.Emotes.Stop()
        return success
    end
    return nil
end