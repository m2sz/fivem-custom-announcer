local queue = {}
local showing = false

local function getTimestamp()
    local h = GetClockHours()
    local m = GetClockMinutes()
    return string.format('%02d:%02d', h, m)
end

local function dbg(...)
    if Config.Debug then
        print('[custom-ui-announcer]', ...)
    end
end

local function sanitize(payload)
    if type(payload) ~= 'table' then
        return nil
    end

    local title = tostring(payload.title or 'Server Announcement')
    local message = tostring(payload.message or '')

    if message == '' then
        return nil
    end

    local duration = tonumber(payload.duration) or Config.DefaultDuration
    if duration < 1500 then
        duration = 1500
    elseif duration > 30000 then
        duration = 30000
    end

    local annType = tostring(payload.type or 'info')
    local theme = payload.theme

    return {
        title = title,
        message = message,
        duration = duration,
        type = annType,
        sender = tostring(payload.sender or Config.AnnouncerTag),
        timestamp = getTimestamp(),
        theme = theme
    }
end

local function sendToNui(entry)
    SendNUIMessage({
        action = 'announce',
        payload = entry,
        defaults = {
            theme = Config.Theme,
            typeStyles = Config.TypeStyles
        }
    })
end

local function showNext()
    if showing or #queue == 0 then
        return
    end

    showing = true
    local nextEntry = table.remove(queue, 1)
    sendToNui(nextEntry)
end

RegisterNetEvent('custom-ui-announcer:client:announce', function(payload)
    local entry = sanitize(payload)
    if not entry then
        dbg('Rejected invalid payload.')
        return
    end

    queue[#queue + 1] = entry
    showNext()
end)

RegisterNetEvent('custom-ui-announcer:client:previewExamples', function()
    for i = 1, #Config.Examples do
        queue[#queue + 1] = sanitize(Config.Examples[i])
    end
    showNext()
end)

RegisterNUICallback('custom-ui-announcer:closed', function(_, cb)
    showing = false
    showNext()
    cb({ ok = true })
end)

RegisterCommand('previewannounceui', function()
    TriggerEvent('custom-ui-announcer:client:previewExamples')
end, false)
