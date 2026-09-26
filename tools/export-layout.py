#!/usr/bin/env python3
"""Export the current Plasma panel layout into the XMacTahoe global themes.
- dumps the live layout through plasmashell (D-Bus dumpCurrentLayoutJS)
- keeps a single desktop containment so the layout works with any number of screens
- forces the system tray spacing, strips AppGrid runtime state, rewrites theme ids
- appends the Meta shortcut for the AppGrid widget
Usage: export-layout.py [<package root>] [<installed root>]   (defaults: this package, ~/.local/share)
"""
import re, ast, os, sys, subprocess, json
raw = subprocess.run(['gdbus','call','--session','--dest','org.kde.plasmashell','--object-path','/PlasmaShell',
                      '--method','org.kde.PlasmaShell.dumpCurrentLayoutJS'], capture_output=True, text=True).stdout
m = re.search(r"\[byte (0x[0-9a-f]{2}(?:, 0x[0-9a-f]{2})*)\]", raw, re.S)
data = bytes(int(x,16) for x in m.group(1).split(', ')) if m else ast.literal_eval("b'"+re.search(r"\('(.*)',\)", raw, re.S).group(1)+"'")
txt = data.decode()
# JSON part between "var layout = " and ";\n\nplasma.loadSerializedLayout"
head, rest = txt.split('var layout = ', 1)
js, tail = rest.split('\n;\n', 1) if '\n;\n' in rest else rest.rsplit(';', 1)
layout = json.loads(js)
# one desktop only (screen 0); panels on screen 0
layout['desktops'] = [d for d in layout['desktops'] if d.get('config',{}).get('/',{}).get('lastScreen','0') == '0'][:1] or layout['desktops'][:1]
for d in layout['desktops']:
    d['config']['/']['lastScreen'] = '0'
    for k in ('ItemGeometries-1920x1080','ItemGeometriesHorizontal'):
        d['config']['/'].pop(k, None)
# panels of the first screen only: the layout script recreates them on every screen at install time
layout['panels'] = [p for p in layout['panels'] if p.get('config', {}).get('/', {}).get('lastScreen', '0') == '0']
for p in layout['panels']:
    p['config'].setdefault('/', {})['lastScreen'] = '0'
    # the live state can be transient (dock forced visible during screenshots): pin the intended modes
    p['hiding'] = 'autohide' if p.get('location') == 'bottom' else 'normal'
    for a in p['applets']:
        if a['plugin'] == 'org.kde.plasma.systemtray':
            # a macOS-like tray: no vaults, weather, KDE Connect or display widget cluttering the popup
            a['config'] = {'/General': {'extraItems': 'org.kde.plasma.clipboard,org.kde.plasma.notifications,org.kde.plasma.battery,org.kde.plasma.brightness,org.kde.plasma.networkmanagement,org.kde.plasma.bluetooth,org.kde.plasma.volume,org.kde.plasma.mediacontroller,org.kde.plasma.devicenotifier,org.kde.plasma.printmanager,org.kde.plasma.keyboardlayout,org.kde.plasma.keyboardindicator,org.kde.plasma.cameraindicator,org.kde.plasma.manage-inputmethod', 'iconSpacing': '3', 'scaleIconsToFit': 'false'}}
        for grp in list(a.get('config', {}).values()):
            for k in ('knownApps','launchCounts','favoritesPortedToKAstats','headerActionsMigrated','iconMigratedFrom17','powerButtonsMigrated'):
                grp.pop(k, None)
layout_txt = json.dumps(layout, indent=4, ensure_ascii=False).replace(os.path.expanduser('~/.local/bin'), '@XMT_BIN@')
MULTISCREEN = '\n// XMacTahoe: Plasma pins a panel to one screen, so give every screen its own menu bar and dock.\n// The AppGrid widget stays on the first screen only: the Meta shortcut needs a single live widget.\nif (screenCount > 1) {\n    var tpl = layout.panels, all = [];\n    for (var s = 0; s < screenCount; s++) {\n        for (var t = 0; t < tpl.length; t++) {\n            var p = JSON.parse(JSON.stringify(tpl[t]));\n            if (s > 0 && p.applets) {\n                var keep = [];\n                for (var a = 0; a < p.applets.length; a++) {\n                    if (p.applets[a].plugin != "dev.xarbit.appgrid") keep.push(p.applets[a]);\n                }\n                p.applets = keep;\n            }\n            all.push(p);\n        }\n    }\n    layout.panels = all;\n}\n\nplasma.loadSerializedLayout(layout);\n\n// give the copies their screen (loadSerializedLayout puts everything on the first one)\nif (screenCount > 1) {\n    var ids = panelIds.slice(0).sort(function (a, b) { return a - b; });\n    var per = ids.length / screenCount;\n    for (var i = 0; i < ids.length; i++) { panelById(ids[i]).screen = Math.floor(i / per); }\n}\n'

out = head + 'var layout = ' + layout_txt + '\n;\n' + MULTISCREEN
out += '''
// XMacTahoe: Meta shortcut (full grid) on the AppGrid widget (invisible, top bar)
for (var i = 0; i < panelIds.length; i++) {
    var ws = panelById(panelIds[i]).widgets();
    for (var j = 0; j < ws.length; j++) {
        if (ws[j].type == "dev.xarbit.appgrid") { ws[j].globalShortcut = "Meta"; }
    }
}
'''
pkg = sys.argv[1] if len(sys.argv) > 1 else os.path.dirname(os.path.dirname(os.path.abspath(__file__)))
inst = sys.argv[2] if len(sys.argv) > 2 else os.path.expanduser('~/.local/share')
for root in (pkg, inst):
    for v in ('XMacTahoe.Dark','XMacTahoe.Light'):
        p = f'{root}/plasma/look-and-feel/{v}/contents/layouts/org.kde.plasma.desktop-layout.js'
        if os.path.isdir(os.path.dirname(p)): open(p,'w').write(out)
print(f"layout exported: {len(layout['desktops'])} desktop, {len(layout['panels'])} panels, {len(out)} bytes")
