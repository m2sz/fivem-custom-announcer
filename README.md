# Custom UI Announcer

Professional NUI announcement resource for FiveM servers.
Built to deliver clean, high-visibility staff messages (restarts, warnings, events, system notices) with a modern UI and straightforward server integration.

## Key Features

- Framework-agnostic architecture (ESX, QBCore, Qbox, custom core).
- Queue-based announcement flow (no overlap, one card at a time).
- Server command, server event, and server export integration.
- Type-based visual presets (info, success, warning, danger, reboot).
- Config-driven theming (accent, background, text, subtext).
- Safe client sanitization (duration clamp and payload validation).

## Tech Stack

- Lua 5.4 (client + server)
- NUI (HTML, CSS, JavaScript)
- FiveM native event pipeline

## Resource Layout

```text
custom-ui-announcer/
|-- fxmanifest.lua
|-- config.lua
|-- client/
|   `-- main.lua
|-- server/
|   `-- main.lua
`-- web/
    |-- index.html
    |-- style.css
    `-- app.js
```

## Installation

1. Place the resource into your server resources directory.
2. Add this line to your server.cfg:

```cfg
ensure custom-ui-announcer
```

3. Optional ACE setup (recommended for production):

```cfg
add_ace group.admin customuiannouncer.use allow
```

4. Restart the resource:

```cfg
restart custom-ui-announcer
```

## Permissions

Permissions are controlled in config.lua:

- Config.RequireAcePermission = true: only players with the configured ACE can run the admin command.
- Config.RequireAcePermission = false: any player can run the command (useful for local testing).
- Config.AllowConsole = true: server console can always dispatch announcements.

## Quick Commands

Admin command format:

```text
/announceui title | message | type | duration_ms
```

Example:

```text
/announceui Restart Notice | The server will restart in 10 minutes. | reboot | 10000
```

Client-side preview:

```text
/previewannounceui
```

## API

Server event:

```lua
TriggerEvent('custom-ui-announcer:server:announceAll', {
    title = 'Staff Announcement',
    message = 'A server event starts in 5 minutes.',
    type = 'info',
    duration = 8000,
    sender = 'STAFF'
})
```

Server export:

```lua
exports['custom-ui-announcer']:announceAll({
    title = 'System Notice',
    message = 'Scheduled maintenance at 03:00.',
    type = 'warning',
    duration = 9000,
    sender = 'SYSTEM'
})
```

Direct client event:

```lua
TriggerClientEvent('custom-ui-announcer:client:announce', source, {
    title = 'Welcome',
    message = 'Enjoy your time on the server.',
    type = 'success',
    duration = 6000,
    sender = 'SERVER'
})
```

Payload contract:

- title: string (required)
- message: string (required)
- type: string (optional, default info)
- duration: number in ms (optional, default from config)
- sender: string (optional, default from config)
- theme: table (optional, per-message color override)

## Configuration Reference

Main settings in config.lua:

- Config.Debug
- Config.DefaultDuration
- Config.Command
- Config.RequireAcePermission
- Config.AcePermission
- Config.AllowConsole
- Config.AnnouncerTag
- Config.Theme
- Config.TypeStyles
- Config.Examples

## Compatibility Notes

- Works as a standalone resource with no external dependencies.
- Designed for drop-in integration in existing admin/staff workflows.
- UI does not capture user input and does not interrupt gameplay.

## Troubleshooting

- Permission denied on command:
  - Ensure ACE is configured in server.cfg, or disable Config.RequireAcePermission for testing.
- No UI visible:
  - Confirm ensure custom-ui-announcer is in server.cfg.
  - Confirm resource restarted after file changes.
- UI style not updating:
  - Clear NUI cache by restarting the resource and reconnecting.

## License

This project is licensed under MIT. See LICENSE for full text.
