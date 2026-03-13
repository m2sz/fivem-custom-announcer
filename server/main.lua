local function hasPermission(source)
    if source == 0 then
        return Config.AllowConsole
    end

    if not Config.RequireAcePermission then
        return true
    end

    return IsPlayerAceAllowed(source, Config.AcePermission)
end

local function splitArgs(input)
    local chunks = {}
    for chunk in string.gmatch(input or '', '([^|]+)') do
        chunks[#chunks + 1] = chunk
    end
    return chunks
end

local function trim(value)
    return (value:gsub('^%s+', ''):gsub('%s+$', ''))
end

local function parseCommandPayload(raw)
    local parts = splitArgs(raw)
    if #parts < 2 then
        return nil, 'Invalid format. Use: /' .. Config.Command .. ' title | message | type | duration(ms)'
    end

    local title = trim(parts[1])
    local message = trim(parts[2])
    local annType = trim(parts[3] or 'info')
    local duration = tonumber(trim(parts[4] or '')) or Config.DefaultDuration

    if title == '' or message == '' then
        return nil, 'Title and message are required.'
    end

    return {
        title = title,
        message = message,
        type = annType,
        duration = duration,
        sender = Config.AnnouncerTag
    }
end

local function notifySource(source, text)
    if source == 0 then
        print('[custom-ui-announcer] ' .. text)
        return
    end

    TriggerClientEvent('chat:addMessage', source, {
        color = { 255, 190, 70 },
        args = { 'UI Announcer', text }
    })
end

local function announceForAll(payload)
    TriggerClientEvent('custom-ui-announcer:client:announce', -1, payload)
end

RegisterNetEvent('custom-ui-announcer:server:announceAll', function(payload)
    local src = source
    if not hasPermission(src) then
        notifySource(src, 'Permission denied.')
        return
    end

    if type(payload) ~= 'table' then
        notifySource(src, 'Invalid payload.')
        return
    end

    announceForAll(payload)
end)

exports('announceAll', function(payload)
    if type(payload) ~= 'table' then
        return false, 'payload invalid'
    end

    announceForAll(payload)
    return true
end)

RegisterCommand(Config.Command, function(source, args, raw)
    if not hasPermission(source) then
        notifySource(source, 'Permission denied.')
        return
    end

    local rawInput = string.sub(raw, #Config.Command + 3)
    local payload, err = parseCommandPayload(rawInput)
    if not payload then
        notifySource(source, err)
        return
    end

    announceForAll(payload)
    notifySource(source, 'Announcement sent to all players.')
end, false)
