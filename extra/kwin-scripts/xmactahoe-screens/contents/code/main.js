// XMacTahoe screen memory, in the spirit of the more consistent multi-display window positioning of
// macOS Golden Gate.
//
// Plasma does not remember where a window was on a screen that goes away: unplug a monitor and its
// windows pile onto another one, plug it back and they stay there. This script keeps, for each set
// of connected screens, the geometry of every window, and restores it when that set comes back.
//
// Everything lives in KWin's memory: window positions only matter for the current session, so there
// is no file to write and nothing to clean up. A window is matched on its application and title.
//
// Settings: kwinrc [Script-xmactahoe-screens]
//   SaveSeconds    how often the current arrangement is saved (default 45)
//   RestoreDelay   pause before restoring after a screen change, in ms (default 1500)
const saveEvery = Math.max(10, readConfig("SaveSeconds", 45)) * 1000;
const restoreDelay = Math.max(200, readConfig("RestoreDelay", 1500));
const layouts = {};          // screen signature -> { window key: geometry }
let signature = "";

function screens() {
    const names = workspace.screens.map(s => s.name + ":" + s.geometry.width + "x" + s.geometry.height);
    return names.sort().join(",");
}

function key(w) {
    return (w.resourceClass || "?") + "|" + (w.caption || "").substring(0, 60);
}

function manageable(w) {
    return w && w.normalWindow && !w.skipTaskbar && !w.deleted && !w.fullScreen && w.moveable && w.resizeable;
}

function save() {
    const snapshot = {};
    workspace.windowList().forEach(function (w) {
        if (!manageable(w) || w.minimized) return;
        const g = w.frameGeometry;
        snapshot[key(w)] = { x: g.x, y: g.y, width: g.width, height: g.height };
    });
    layouts[signature] = snapshot;
}

function restore() {
    const snapshot = layouts[signature];
    if (!snapshot) return;
    workspace.windowList().forEach(function (w) {
        if (!manageable(w)) return;
        const saved = snapshot[key(w)];
        if (!saved) return;
        const g = w.frameGeometry;
        if (g.x === saved.x && g.y === saved.y && g.width === saved.width && g.height === saved.height) return;
        // only put a window back where a screen actually is now
        const fits = workspace.screens.some(function (s) {
            const a = s.geometry;
            return saved.x + saved.width > a.x && saved.x < a.x + a.width
                && saved.y + saved.height > a.y && saved.y < a.y + a.height;
        });
        if (fits) w.frameGeometry = { x: saved.x, y: saved.y, width: saved.width, height: saved.height };
    });
}

function onScreensChanged() {
    save();                       // keep the arrangement of the set we are leaving
    signature = screens();
    const t = new QTimer();       // let Plasma finish moving panels and windows around first
    t.interval = restoreDelay;
    t.singleShot = true;
    t.timeout.connect(function () { restore(); save(); });
    t.start();
}

signature = screens();
save();

const ticker = new QTimer();
ticker.interval = saveEvery;
ticker.timeout.connect(save);
ticker.start();

workspace.screensChanged.connect(onScreensChanged);
