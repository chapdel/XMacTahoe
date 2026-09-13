#!/usr/bin/env python3
"""Génère des glyphes de barre de menus style macOS Tahoe (SF Symbols-like)
pour les packs d'icônes XMacTahoe-Night / XMacTahoe-Day (dossiers */panel)
et pour les thèmes Plasma XMacTahoe-Dark / XMacTahoe-Light (icons/*.svg).
Usage : gen-tray-icons.py <racine icons/> <racine plasma/desktoptheme/> [--preview DIR]
"""
import os, sys, math, re, glob

# ---------- primitives (cellule 22x22) ----------
def arc(cx, cy, r, a0, a1):
    """arc de a0 à a1 (degrés, 0 = haut, sens horaire) -> segment de path"""
    x0 = cx + r*math.sin(math.radians(a0)); y0 = cy - r*math.cos(math.radians(a0))
    x1 = cx + r*math.sin(math.radians(a1)); y1 = cy - r*math.cos(math.radians(a1))
    large = 1 if abs(a1-a0) > 180 else 0
    return f"M{x0:.2f} {y0:.2f} A{r} {r} 0 {large} 1 {x1:.2f} {y1:.2f}"
def stroke(d, w=2.0, op=None, cls="ColorScheme-Text"):
    o = f' opacity="{op}"' if op is not None else ''
    return f'<path class="{cls}" d="{d}" fill="none" stroke="currentColor" stroke-width="{w}" stroke-linecap="round" stroke-linejoin="round"{o}/>'
def fill(d, op=None, cls="ColorScheme-Text"):
    o = f' opacity="{op}"' if op is not None else ''
    return f'<path class="{cls}" d="{d}" fill="currentColor" stroke-linejoin="round"{o}/>'
def circle(cx, cy, r, op=None, cls="ColorScheme-Text", strokew=None):
    o = f' opacity="{op}"' if op is not None else ''
    if strokew: return f'<circle class="{cls}" cx="{cx}" cy="{cy}" r="{r}" fill="none" stroke="currentColor" stroke-width="{strokew}"{o}/>'
    return f'<circle class="{cls}" cx="{cx}" cy="{cy}" r="{r}" fill="currentColor"{o}/>'
def rrect(x, y, w, h, rx, op=None, cls="ColorScheme-Text", strokew=None, fillcol=None):
    o = f' opacity="{op}"' if op is not None else ''
    if strokew: return f'<rect class="{cls}" x="{x}" y="{y}" width="{w}" height="{h}" rx="{rx}" fill="none" stroke="currentColor" stroke-width="{strokew}"{o}/>'
    fc = fillcol or "currentColor"
    return f'<rect class="{cls}" x="{x}" y="{y}" width="{w}" height="{h}" rx="{rx}" fill="{fc}"{o}/>'
DIM = 0.32
SLASH = "M4 4 L18 18"

# ---------- glyphes ----------
def wifi(level, off=False, locked=False):
    cx, cy = 11, 17.4; out = [circle(cx, cy-0.7, 1.9)]
    for i, r in enumerate((5.4, 9.0, 12.6)):
        on = level >= i+1
        out.append(stroke(arc(cx, cy, r, -50, 50), 2.3, None if on else DIM))
    if off: out.append(stroke(SLASH, 2.2))
    if locked: out.append(fill("M15.2 15.2 h5.6 v4.6 h-5.6 z M16.6 15.2 v-1.4 a1.4 1.4 0 0 1 2.8 0 v1.4", None))
    return out
def speaker(waves, muted=False):
    out = [fill("M3.6 8.3 H6.9 L11.3 4.6 V17.4 L6.9 13.7 H3.6 Z")]
    for i, r in enumerate((3.2, 6.2, 9.2)):
        if i < waves: out.append(stroke(arc(11.4, 11, r, 50, 130), 2.0))
    if muted: out.append(stroke("M14 8.6 L19 13.4 M19 8.6 L14 13.4", 2.0))
    return out
def bluetooth(active=True):
    return [stroke("M6.5 7 L15.5 15 L11 19.5 V2.5 L15.5 7 L6.5 15", 2.0, None if active else 0.45)]
def bell(badge=False, disabled=False):
    body = ("M11 2.6 c-3.1 0-5.6 2.5-5.6 5.6 v4.3 c0 0.4-0.15 0.8-0.4 1.1 L3.6 15.2 c-0.4 0.5-0.05 1.2 0.6 1.2 "
            "h13.6 c0.65 0 1-0.7 0.6-1.2 l-1.4-1.6 c-0.25-0.3-0.4-0.7-0.4-1.1 V8.2 C16.6 5.1 14.1 2.6 11 2.6 Z")
    out = [fill(body), fill("M8.8 17.8 a2.2 2.2 0 0 0 4.4 0 Z")]
    if badge: out += [circle(16.8, 5.2, 4.0, cls="ColorScheme-Background"), circle(16.8, 5.2, 2.7)]
    if disabled: out += [stroke(SLASH, 4.2, cls="ColorScheme-Background"), stroke(SLASH, 2.0)]
    return out
def clipboard():
    return [rrect(5.2, 4.3, 11.6, 15.0, 2.2, strokew=1.9), rrect(8.2, 2.6, 5.6, 3.7, 1.3),
            stroke("M8.5 11.2 H13.5 M8.5 14.6 H13.5", 1.6, 0.9)]
def sun(on=True):
    out = [circle(11, 11, 3.6, strokew=1.9)]
    for k in range(8):
        a = math.radians(k*45); x0, y0 = 11+6.2*math.sin(a), 11-6.2*math.cos(a); x1, y1 = 11+8.6*math.sin(a), 11-8.6*math.cos(a)
        out.append(stroke(f"M{x0:.2f} {y0:.2f} L{x1:.2f} {y1:.2f}", 1.9))
    if not on: out = [re.sub(r'/>$', ' opacity="0.5"/>', s) for s in out]
    return out
def battery(level, charging=False, missing=False):
    out = [rrect(1.6, 6.3, 16.6, 9.4, 2.8, 0.42, strokew=1.5), rrect(19.2, 9.2, 1.7, 3.6, 0.85, 0.42)]
    if missing:
        out.append(stroke("M9.2 9.6 a1.9 1.9 0 1 1 2.7 1.7 c-0.6 0.3-0.9 0.7-0.9 1.4 M11 14.3 v0.1", 1.5, 0.8))
        return out
    w = max(1.6, 13.2*level/100.0)
    col = "#ff453a" if level <= 20 and not charging else ("#30d158" if charging else None)
    out.append(rrect(3.3, 8.0, round(w, 2), 6.0, 1.4, fillcol=col))
    if charging:
        bolt = "M11.4 5.6 L6.6 12.2 H10.1 L9.2 16.6 L14.2 9.9 H10.7 Z"
        out += [fill(bolt, cls="ColorScheme-Background"), stroke(bolt, 1.3, cls="ColorScheme-Background"), fill(bolt)]
    return out
def paperplane(muted=False, attention=False):
    out = [fill("M19.6 3.2 L3.2 9.9 c-0.7 0.3-0.7 1.2 0 1.5 l4.6 1.6 l1.6 4.8 c0.2 0.7 1.1 0.8 1.5 0.2 l2.3-3.2 l4.2 3.1 c0.6 0.4 1.4 0.1 1.5-0.6 L20.9 4.2 c0.1-0.7-0.6-1.3-1.3-1 Z M8.7 13 l9.3-7.4 l-7.6 8.6 z", None)]
    if muted: out += [stroke(SLASH, 4.0, cls="ColorScheme-Background"), stroke(SLASH, 1.9)]
    if attention: out += [circle(17.5, 5, 4.0, cls="ColorScheme-Background"), circle(17.5, 5, 2.6)]
    return out
def update_circle(count=0):
    out = [circle(11, 11, 8.0, strokew=1.9), stroke("M11 6.6 V15 M7.6 11.6 L11 15 L14.4 11.6", 1.9)]
    return out

# ---------- sortie pack d'icônes ----------
def pack_svg(elems, size, default="#ffffff", bg="#242424"):
    return ('<?xml version="1.0" encoding="UTF-8"?>\n'
            f'<svg xmlns="http://www.w3.org/2000/svg" width="{size}" height="{size}" viewBox="0 0 22 22">\n'
            f'  <defs><style type="text/css" id="current-color-scheme">.ColorScheme-Text{{color:{default};}}.ColorScheme-Background{{color:{bg};}}</style></defs>\n'
            + '\n'.join('  '+e for e in elems) + '\n</svg>\n')

def wifi_for(name):
    n = name
    if re.search(r'(-off\b|off\.svg|airplane)', n): return wifi(0, off=True)
    locked = bool(re.search(r'locked|secure|lock', n))
    m = re.search(r'-(\d{1,3})(?:-|\.|$)', n)
    lvl = 0
    if m:
        v = int(m.group(1)); lvl = 3 if v >= 90 else 2 if v >= 50 else 1 if v >= 15 else 0
    elif re.search(r'excellent|high-signal|good|connected(?!-\d)', n): lvl = 3 if re.search(r'excellent|high', n) else 2
    elif re.search(r'\bok\b|low|weak|bad', n): lvl = 1
    elif re.search(r'none|disconnected|offline|available|acquiring|no-route|idle', n): lvl = 0
    elif re.search(r'wireless(-symbolic)?\.svg$|wireless-on', n): lvl = 3
    return wifi(lvl, locked=locked)

def glyph_for(fname):
    n = fname
    if n.startswith('battery'):
        charging = 'charging' in n; missing = 'missing' in n
        m = re.search(r'battery-(\d{3})', n)
        if m: lvl = int(m.group(1))
        elif re.search(r'full|charged', n): lvl = 100
        elif 'good' in n: lvl = 70
        elif 'medium' in n: lvl = 50
        elif 'low' in n: lvl = 20
        elif 'caution' in n: lvl = 10
        elif 'empty' in n: lvl = 3
        elif missing: lvl = 0
        else: return None
        return battery(lvl, charging, missing)
    if re.match(r'(network-wireless|nm-signal|network-wireless-signal)', n) and 'bluetooth' not in n: return wifi_for(n)
    if re.match(r'(network-bluetooth|bluetooth-)', n):
        return bluetooth(active=not re.search(r'disabled|inactive', n))
    if re.match(r'(audio-volume|volume-level)', n) and 'blocked' not in n and 'blocking' not in n:
        if 'muted' in n or 'off' in n or 'none' in n: return speaker(0, muted=True)
        w = 3 if 'high' in n else 2 if 'medium' in n else 1
        return speaker(w)
    if n.startswith('redshift-status') or n.startswith('display-brightness') or n == 'notification-display-brightness.svg':
        return sun(on=('off' not in n))
    if n in ('klipper.svg', 'clipman-symbolic.svg', 'clipit-trayicon.svg'): return clipboard()
    if re.match(r'notifications?-', n) or re.match(r'notifications?\.svg', n) or n == 'notification-symbolic.svg':
        return bell(badge=bool(re.search(r'new|active|unread', n)), disabled=bool(re.search(r'disabled|off', n)))
    if re.match(r'update-(none|low|medium|high)\.svg', n): return update_circle()
    if 'telegram' in n: return paperplane(muted='mute' in n, attention='attention' in n)
    return None

def write_pack(root, dark=True):
    default, bg = ("#ffffff", "#242424") if dark else ("#333333", "#f5f5f5")
    n = 0
    for sub, size in (('16x16/panel', 16), ('22x22/panel', 22), ('22x22@2x/panel', 22), ('24x24/panel', 24),
                      ('status/16', 16), ('status/22', 22), ('status/24', 24), ('status/32', 32), ('status/symbolic', 16),
                      ('status@2x/16', 16), ('status@2x/22', 22), ('status@2x/24', 24), ('status@2x/32', 32)):
        d = os.path.join(root, sub)
        if not os.path.isdir(d): continue
        names = set(os.listdir(d))
        # noms Plasma indispensables même s'ils manquent dans le pack
        for lvl in range(0, 101, 10):
            names.add(f'battery-{lvl:03d}.svg'); names.add(f'battery-{lvl:03d}-charging.svg')
        names |= {'notifications.svg', 'notifications-symbolic.svg', 'notifications-new-symbolic.svg', 'notifications-disabled.svg',
                  'network-bluetooth-activated.svg', 'network-bluetooth-inactive.svg', 'preferences-system-bluetooth.svg',
                  'preferences-system-bluetooth-activated.svg', 'preferences-system-bluetooth-inactive.svg', 'brightness-high.svg', 'brightness-low.svg',
                  'klipper-symbolic.svg', 'edit-paste-symbolic.svg', 'network-wireless-symbolic.svg', 'network-wireless-off.svg',
                  'org.telegram.desktop-symbolic.svg', 'org.telegram.desktop-mute-symbolic.svg', 'org.telegram.desktop-attention-symbolic.svg'}
        if sub.endswith('symbolic'):
            names |= {n[:-4] + '-symbolic.svg' for n in list(names) if n.endswith('.svg') and not n.endswith('-symbolic.svg')}
        for fn in sorted(names):
            if not fn.endswith('.svg'): continue
            g = glyph_for(fn.replace('preferences-system-bluetooth', 'bluetooth-x').replace('brightness-', 'display-brightness-')
                          .replace('edit-paste-symbolic.svg', 'klipper.svg').replace('klipper-symbolic.svg', 'klipper.svg'))
            if g is None: continue
            p = os.path.join(d, fn)
            if os.path.islink(p): os.unlink(p)
            open(p, 'w').write(pack_svg(g, size, default, bg)); n += 1
    return n

# ---------- sortie thème Plasma ----------
def theme_file(entries, default="#dedede", bg="#242424"):
    """entries: liste (id, elems) -> un SVG multi-éléments, ids 22-22-<id> et <id>"""
    cols = 8; cell = 26; rows = math.ceil(len(entries)*2/cols)
    W, H = cols*cell, rows*cell
    parts = [f'<svg xmlns="http://www.w3.org/2000/svg" width="{W}" height="{H}" viewBox="0 0 {W} {H}">',
             f'  <defs><style type="text/css" id="current-color-scheme">.ColorScheme-Text{{color:{default};}}.ColorScheme-Background{{color:{bg};}}</style></defs>']
    k = 0
    for iid, elems in entries:
        for pref in ('22-22-', ''):
            x, y = (k % cols)*cell, (k // cols)*cell; k += 1
            parts.append(f'  <g id="{pref}{iid}" class="ColorScheme-Text" transform="translate({x},{y})">')
            parts.append('    <rect x="0" y="0" width="22" height="22" fill="none"/>')
            parts += ['    '+e for e in elems]
            parts.append('  </g>')
    parts.append('</svg>')
    return '\n'.join(parts) + '\n'

def write_theme(themedir, dark=True):
    default, bg = ("#dedede", "#242424") if dark else ("#232629", "#f5f5f5")
    files = {}
    net = []
    for lvl in (0, 20, 40, 60, 80, 100):
        for suf in ('', '-locked', '-limited'):
            net.append((f'network-wireless-{lvl}{suf}', wifi_for(f'network-wireless-{lvl}{suf}.svg')))
        net.append((f'network-wireless-connected-{lvl if lvl else "00"}', wifi_for(f'network-wireless-{lvl}.svg')))
    net += [('network-wireless', wifi(3)), ('network-wireless-on', wifi(3)), ('network-wireless-off', wifi(0, off=True)),
            ('network-wireless-disconnected', wifi(0)), ('network-wireless-available', wifi(0)),
            ('network-bluetooth', bluetooth()), ('network-bluetooth-activated', bluetooth()), ('network-bluetooth-activated-locked', bluetooth())]
    files['network.svg'] = net
    files['audio.svg'] = [('audio-volume-high', speaker(3)), ('audio-volume-medium', speaker(2)), ('audio-volume-low', speaker(1)), ('audio-volume-muted', speaker(0, True))]
    files['notification.svg'] = [('notification-inactive', bell()), ('notification-empty', bell()), ('notification-active', bell(badge=True)),
                                 ('notification-disabled', bell(disabled=True)), ('notification-progress-active', bell(badge=True)), ('notification-progress-inactive', bell())]
    files['klipper.svg'] = [('klipper', clipboard())]
    files['redshift.svg'] = [('redshift-status-on', sun(True)), ('redshift-status-off', sun(False))]
    files['brightness.svg'] = [('brightness-high', sun(True)), ('brightness-low', sun(True))]
    files['battery.svg'] = [(f'battery-{l:03d}{c}', battery(l, c != '')) for l in range(0, 101, 10) for c in ('', '-charging')] + [('battery-missing', battery(0, missing=True))]
    files['preferences.svg'] = None  # laissé tel quel (contient d'autres icônes)
    d = os.path.join(themedir, 'icons'); os.makedirs(d, exist_ok=True); n = 0
    for fn, entries in files.items():
        if entries is None: continue
        for old in (fn, fn + 'z'):
            p = os.path.join(d, old)
            if os.path.exists(p): os.remove(p)
        open(os.path.join(d, fn), 'w').write(theme_file(entries, default, bg)); n += 1
    return n

if __name__ == '__main__':
    icons_root, theme_root = sys.argv[1], sys.argv[2]
    prev = sys.argv[sys.argv.index('--preview')+1] if '--preview' in sys.argv else None
    tot = 0
    for pack, dark in (('XMacTahoe-Night', True), ('XMacTahoe-Day', False)):
        r = os.path.join(icons_root, pack)
        if os.path.isdir(r): k = write_pack(r, dark); tot += k; print(f'{pack}: {k} icônes')
    for th, dark in (('XMacTahoe-Dark', True), ('XMacTahoe-Light', False)):
        r = os.path.join(theme_root, th)
        if os.path.isdir(r): k = write_theme(r, dark); print(f'{th}: {k} fichiers icons/')
    if prev:
        os.makedirs(prev, exist_ok=True)
        samples = {'wifi100': wifi(3), 'wifi40': wifi(1), 'wifioff': wifi(0, off=True), 'vol-high': speaker(3), 'vol-muted': speaker(0, True),
                   'bluetooth': bluetooth(), 'bell': bell(), 'bell-badge': bell(badge=True), 'clipboard': clipboard(), 'sun': sun(),
                   'bat100': battery(100), 'bat60': battery(60), 'bat15': battery(15), 'bat60-chg': battery(60, True), 'update': update_circle()}
        for k, v in samples.items(): open(os.path.join(prev, k + '.svg'), 'w').write(pack_svg(v, 22))
        print('aperçu:', prev)
