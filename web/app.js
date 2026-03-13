const layer = document.getElementById('layer');
const announcement = document.getElementById('announcement');
const glow = document.getElementById('glow');
const typeChip = document.getElementById('type-chip');
const sender = document.getElementById('sender');
const time = document.getElementById('time');
const title = document.getElementById('title');
const message = document.getElementById('message');
const icon = document.getElementById('icon');
const progress = document.getElementById('progress');

let closeTimeout = null;

function hexToRgb(hex) {
    const normalized = String(hex || '').trim().replace('#', '');
    if (!/^[0-9a-fA-F]{3}$|^[0-9a-fA-F]{6}$/.test(normalized)) {
        return '246, 201, 14';
    }

    const full = normalized.length === 3
        ? normalized.split('').map((char) => char + char).join('')
        : normalized;

    const r = parseInt(full.slice(0, 2), 16);
    const g = parseInt(full.slice(2, 4), 16);
    const b = parseInt(full.slice(4, 6), 16);
    return `${r}, ${g}, ${b}`;
}

function setCSSVars(theme) {
    const accent = theme.accent || '#f6c90e';
    document.documentElement.style.setProperty('--base-accent', accent);
    document.documentElement.style.setProperty('--accent-rgb', hexToRgb(accent));
    document.documentElement.style.setProperty('--base-bg', theme.background || 'rgba(12, 18, 27, 0.88)');
    document.documentElement.style.setProperty('--base-text', theme.text || '#f5f7fb');
    document.documentElement.style.setProperty('--base-subtext', theme.subtext || '#b8c0d4');
}

function closeAnnouncement(duration = 300) {
    if (closeTimeout) {
        clearTimeout(closeTimeout);
        closeTimeout = null;
    }

    announcement.classList.remove('show');
    announcement.classList.add('leaving');
    closeTimeout = setTimeout(() => {
        announcement.classList.remove('leaving');
        layer.classList.remove('active');
        layer.classList.add('hidden');
        fetch(`https://${GetParentResourceName()}/custom-ui-announcer:closed`, {
            method: 'POST',
            headers: {
                'Content-Type': 'application/json; charset=UTF-8'
            },
            body: JSON.stringify({})
        });
    }, duration);
}

function showAnnouncement(packet) {
    const payload = packet.payload || {};
    const defaults = packet.defaults || {};
    const typeStyles = defaults.typeStyles || {};

    const type = String(payload.type || 'info').toLowerCase();
    const style = typeStyles[type] || typeStyles.info || { icon: 'i', accent: '#4da3ff' };

    const theme = {
        ...(defaults.theme || {}),
        ...(payload.theme || {}),
        accent: style.accent || (payload.theme && payload.theme.accent) || (defaults.theme && defaults.theme.accent) || '#f6c90e'
    };

    setCSSVars(theme);

    typeChip.textContent = type.toUpperCase();
    sender.textContent = payload.sender || 'SERVER';
    time.textContent = payload.timestamp || '--:--';
    title.textContent = payload.title || 'Server Announcement';
    message.textContent = payload.message || '';
    icon.textContent = String(style.icon || 'i').slice(0, 1);

    glow.style.opacity = '0.95';

    progress.classList.remove('animate');
    progress.style.animationDuration = '0ms';
    void progress.offsetWidth;

    const duration = Number(payload.duration) || 7000;
    progress.style.animationDuration = `${duration}ms`;

    layer.classList.remove('hidden');
    layer.classList.add('active');
    announcement.classList.remove('leaving');
    announcement.classList.remove('show');

    void announcement.offsetWidth;

    requestAnimationFrame(() => {
        announcement.classList.add('show');
        progress.classList.add('animate');
    });

    if (closeTimeout) {
        clearTimeout(closeTimeout);
    }

    closeTimeout = setTimeout(() => closeAnnouncement(), duration);
}

window.addEventListener('message', (event) => {
    const data = event.data;
    if (!data || data.action !== 'announce') {
        return;
    }

    showAnnouncement(data);
});
