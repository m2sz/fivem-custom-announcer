Config = {}

Config.Debug = false
Config.DefaultDuration = 7000
Config.Command = 'announceui'
Config.RequireAcePermission = true
Config.AcePermission = 'customuiannouncer.use'
Config.AllowConsole = true
Config.AnnouncerTag = 'SERVER'

Config.Theme = {
    accent = '#f6c90e',
    background = 'rgba(12, 18, 27, 0.88)',
    text = '#f5f7fb',
    subtext = '#b8c0d4'
}

Config.TypeStyles = {
    info = {
        icon = 'i',
        accent = '#4da3ff'
    },
    success = {
        icon = 'v',
        accent = '#3dcc91'
    },
    warning = {
        icon = '!',
        accent = '#ffb020'
    },
    danger = {
        icon = 'x',
        accent = '#ff5a67'
    },
    reboot = {
        icon = 'R',
        accent = '#d58cff'
    }
}

Config.Examples = {
    {
        title = 'Scheduled Restart',
        message = 'The server will restart in 10 minutes. Please move to a safe location.',
        type = 'reboot',
        duration = 10000
    },
    {
        title = 'Staff Information',
        message = 'A server event will begin at Central Plaza in 5 minutes.',
        type = 'info',
        duration = 7000
    }
}
