// XMacTahoe dock attention.
// Plasma reveals an auto-hidden dock while any window demands attention (Telegram with unread
// messages, a finished download...) and keeps it on screen until that window is opened. macOS shows
// its hidden Dock only for a short bounce. This script clears the attention request after a few
// seconds, so the dock shows briefly and hides again; app badges (unread counts) are not affected.
// Setting: kwinrc [Script-xmactahoe-attention] RevealSeconds (default 5).
const delay = Math.max(1, readConfig("RevealSeconds", 5)) * 1000;
const timers = new Map();

function schedule(w) {
    if (timers.has(w)) return;
    const t = new QTimer();
    t.interval = delay;
    t.singleShot = true;
    t.timeout.connect(function () {
        timers.delete(w);
        if (w.demandsAttention && !w.active) w.demandsAttention = false;
    });
    timers.set(w, t);
    t.start();
}

function watch(w) {
    if (!w || !w.normalWindow) return;
    w.demandsAttentionChanged.connect(function () {
        if (w.demandsAttention) schedule(w);
        else if (timers.has(w)) { timers.get(w).stop(); timers.delete(w); }
    });
    if (w.demandsAttention) schedule(w);
}

workspace.windowList().forEach(watch);
workspace.windowAdded.connect(watch);
workspace.windowRemoved.connect(function (w) { if (timers.has(w)) { timers.get(w).stop(); timers.delete(w); } });
