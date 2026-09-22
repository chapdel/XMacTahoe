#!/usr/bin/env python3
"""Consistency checks for the XMacTahoe package (run locally or in CI). Exit code 1 on failure."""
import os, sys, gzip, json, re, subprocess, glob
import xml.etree.ElementTree as ET
B = sys.argv[1] if len(sys.argv) > 1 else os.path.dirname(os.path.dirname(os.path.abspath(__file__)))
errors = []
def err(m): errors.append(m); print('FAIL', m)
def ok(m): print('ok  ', m)
# 1-2. syntax of every script, found by shebang (bash -n / compile without writing __pycache__)
scripts = ['install.sh', 'uninstall.sh'] + sorted(glob.glob(f'{B}/bin/*') + glob.glob(f'{B}/extra/xmactahoe-*') + glob.glob(f'{B}/extra/kde-desktop-repair') + glob.glob(f'{B}/tools/*'))
for sh in scripts:
    p = sh if os.path.isabs(sh) else f'{B}/{sh}'; rel = os.path.relpath(p, B)
    if not os.path.isfile(p): continue
    first = open(p, errors='replace').readline()
    if 'bash' in first:
        r = subprocess.run(['bash', '-n', p], capture_output=True, text=True)
        (ok if r.returncode == 0 else err)(f'bash -n {rel}' + ('' if r.returncode == 0 else ': ' + r.stderr.strip()))
    elif 'python' in first or p.endswith('.py'):
        try: compile(open(p).read(), p, 'exec'); ok(f'python syntax {rel}')
        except SyntaxError as e: err(f'python syntax {rel}: {e}')
# 2b. nothing personal or non-redistributable in the package
for f in glob.glob(f'{B}/plasma/look-and-feel/*/contents/layouts/*.js') + [x for x in scripts if os.path.isfile(x if os.path.isabs(x) else f'{B}/{x}')]:
    p = f if os.path.isabs(f) else f'{B}/{f}'
    if re.search(r'/home/[a-z]', open(p, errors='replace').read()): err(f'personal path in {os.path.relpath(p, B)}')
rpms = glob.glob(f'{B}/**/*.rpm', recursive=True)
(err if rpms else ok)('no bundled RPM' + (f': {rpms}' if rpms else ''))
for lic in ['LICENSE', 'THIRD_PARTY.md', 'fonts/Inter-OFL.txt', 'fonts/JetBrainsMono-OFL.txt', 'licenses/MIT-MacTahoe-gtk-theme.txt', 'licenses/LGPL-3.0-MacTahoe-kde.txt', 'licenses/GPL-2.0.txt']:
    (ok if os.path.exists(f'{B}/{lic}') else err)(f'license file {lic}')
# 3. every defaults entry points to something that exists in the package
names = {
    'plasma': {os.path.basename(p) for p in glob.glob(f'{B}/plasma/desktoptheme/*')},
    'colors': {os.path.basename(p)[:-7] for p in glob.glob(f'{B}/color-schemes/*.colors')},
    'icons': {os.path.basename(p) for p in glob.glob(f'{B}/icons/*')},
    'aurorae': {os.path.basename(p) for p in glob.glob(f'{B}/aurorae/themes/*')},
    'wallpapers': {os.path.basename(p) for p in glob.glob(f'{B}/wallpapers/*')},
    'lnf': {os.path.basename(p) for p in glob.glob(f'{B}/plasma/look-and-feel/*')},
}
for d in sorted(glob.glob(f'{B}/plasma/look-and-feel/XMacTahoe.*/contents/defaults')):
    txt = open(d).read(); v = d.split('/')[-3]
    checks = [(r'\[kdeglobals\]\[General\]\s*\nColorScheme=(\S+)', 'colors'), (r'\[kdeglobals\]\[Icons\]\s*\nTheme=(\S+)', 'icons'),
              (r'\[kcminputrc\]\[Mouse\]\s*\ncursorTheme=(\S+)', 'icons'), (r'theme=__aurorae__svg__(\S+)', 'aurorae'),
              (r'\[plasmarc\]\[Theme\]\s*\nname=(\S+)', 'plasma'), (r'\[Wallpaper\]\s*\nImage=(\S+)', 'wallpapers'), (r'\[ksplashrc\]\[KSplash\][^\[]*Theme=(\S+)', 'lnf')]
    for rx, kind in checks:
        m = re.search(rx, txt)
        if not m: err(f'{v}: missing entry for {kind}'); continue
        (ok if m.group(1) in names[kind] else err)(f'{v}: {kind} {m.group(1)}' + ('' if m.group(1) in names[kind] else ' not in package'))
# 4. Aurorae rc file named after the theme
for t in glob.glob(f'{B}/aurorae/themes/*'):
    n = os.path.basename(t); (ok if os.path.exists(f'{t}/{n}rc') else err)(f'aurorae {n}: {n}rc present')
# 5. Kvantum theme files consistent
for k in ('XMacTahoe', 'XMacTahoeDark'):
    (ok if os.path.exists(f'{B}/Kvantum/XMacTahoe/{k}.kvconfig') and os.path.exists(f'{B}/Kvantum/XMacTahoe/{k}.svg') else err)(f'kvantum {k}: kvconfig + svg')
# 6. Plasma theme SVGs parse and keep the color-scheme stylesheet inside <defs>
bad = 0; count = 0
for f in glob.glob(f'{B}/plasma/desktoptheme/XMacTahoe-*/**/*.svg*', recursive=True):
    try:
        raw = gzip.open(f, 'rb').read() if f.endswith('.svgz') else open(f, 'rb').read()
    except OSError:
        raw = open(f, 'rb').read()
    try:
        root = ET.fromstring(raw); count += 1
    except ET.ParseError as e:
        bad += 1; err(f'svg parse {os.path.relpath(f, B)}: {e}'); continue
    if b'current-color-scheme' in raw:
        ns = '{http://www.w3.org/2000/svg}'; parents = {c: p for p in root.iter() for c in p}
        defs = list(root.iter(ns + 'defs'))
        st = [e for e in root.iter(ns + 'style') if e.get('id') == 'current-color-scheme']
        if st and (not defs or parents.get(st[0]) is not defs[0]): bad += 1; err(f'stylesheet outside first <defs>: {os.path.relpath(f, B)}')
ok(f'{count} Plasma theme SVG parsed, {bad} problems')
# 7. layouts parse as JS (node) and reference bundled widgets
node = subprocess.run(['which', 'node'], capture_output=True).returncode == 0
bundled = {os.path.basename(p) for p in glob.glob(f'{B}/plasma/plasmoids/*')} | {'dev.xarbit.appgrid'}
for l in glob.glob(f'{B}/plasma/look-and-feel/*/contents/layouts/*.js'):
    if node:
        r = subprocess.run(['node', '--check', l], capture_output=True, text=True); (ok if r.returncode == 0 else err)(f'node --check {os.path.relpath(l, B)}')
    txt = open(l).read()
    for plug in set(re.findall(r'"plugin": "([^"]+)"', txt)):
        if not plug.startswith('org.kde.') and plug not in bundled: err(f'layout references non-bundled widget {plug}')
    ok(f'{os.path.relpath(l, B)}: widgets referenced are bundled or from Plasma')
# 7b. KWin scripts parse as JavaScript and carry metadata
for k in glob.glob(f'{B}/extra/kwin-scripts/*/'):
    js = os.path.join(k, 'contents/code/main.js'); md = os.path.join(k, 'metadata.json')
    (ok if os.path.exists(js) and os.path.exists(md) else err)(f'kwin script {os.path.basename(k.rstrip("/"))}: main.js + metadata.json')
    if node and os.path.exists(js):
        r = subprocess.run(['node', '--check', js], capture_output=True, text=True); (ok if r.returncode == 0 else err)(f'node --check {os.path.relpath(js, B)}')
# 8. tray icon generator runs on a scratch copy
import tempfile, shutil
with tempfile.TemporaryDirectory() as td:
    for p in ('XMacTahoe-Night',):
        src = f'{B}/icons/{p}'
        if os.path.isdir(src): shutil.copytree(f'{src}/status', f'{td}/{p}/status', symlinks=True); open(f'{td}/{p}/index.theme', 'w').write('[Icon Theme]\nName=x\n')
    r = subprocess.run([sys.executable, f'{B}/tools/gen-tray-icons.py', td, '/nonexistent'], capture_output=True, text=True)
    (ok if r.returncode == 0 else err)('gen-tray-icons.py runs' + ('' if r.returncode == 0 else ': ' + r.stderr[-300:]))
print('\n' + ('ALL CHECKS PASSED' if not errors else f'{len(errors)} FAILURE(S)'))
sys.exit(1 if errors else 0)
