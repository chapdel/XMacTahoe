#!/usr/bin/env python3
"""Plasma/KSvg only substitutes theme colors when the <style id="current-color-scheme"> element is a direct
child of the first <defs>. Many third-party themes put it elsewhere (or duplicate it), which leaves the
hard-coded Breeze light colors (#eff0f1) in place. This tool moves it into the first <defs> and removes
duplicated "current-color-scheme-N" blocks, in place, for every .svg/.svgz under the given directories.
Usage: fix-svg-stylesheets.py <dir> [<dir> ...]
"""
import sys, os, re, gzip, glob
import xml.etree.ElementTree as ET
NS = '{http://www.w3.org/2000/svg}'
style_re = re.compile(r'<style\b[^>]*\bid="current-color-scheme"[^>]*>.*?</style>', re.S)
dup_re = re.compile(r'<style\b[^>]*\bid="current-color-scheme-\d+"[^>]*>.*?</style>\s*', re.S)
defs_open = re.compile(r'<defs\b[^>]*?(?<!/)>'); defs_empty = re.compile(r'<defs\b[^>]*?/>'); svg_open = re.compile(r'<svg\b[^>]*?>', re.S)
def ok(txt):
    try: root = ET.fromstring(txt)
    except ET.ParseError: return None
    parents = {c: p for p in root.iter() for c in p}; defs = list(root.iter(NS + 'defs'))
    for st in root.iter(NS + 'style'):
        if st.get('id') == 'current-color-scheme': return bool(defs) and parents.get(st) is defs[0]
    return True
fixed = 0
for d in sys.argv[1:]:
    for f in glob.glob(f'{d}/**/*.svg*', recursive=True):
        z = f.endswith('.svgz')
        try: raw = gzip.open(f, 'rb').read() if z else open(f, 'rb').read()
        except OSError: raw = open(f, 'rb').read(); z = False
        try: txt = raw.decode('utf-8')
        except UnicodeDecodeError: continue
        new = dup_re.sub('', txt)
        if ok(new) is False:
            m = style_re.search(new); block = m.group(0); new = new[:m.start()] + new[m.end():]
            if defs_open.search(new): dm = defs_open.search(new); new = new[:dm.end()] + '\n' + block + '\n' + new[dm.end():]
            elif defs_empty.search(new): dm = defs_empty.search(new); new = new[:dm.start()] + dm.group(0)[:-2] + '>\n' + block + '\n</defs>' + new[dm.end():]
            else: sm = svg_open.search(new); new = new[:sm.end()] + '\n<defs>\n' + block + '\n</defs>' + new[sm.end():]
        if new != txt and ok(new):
            data = new.encode('utf-8')
            if z:
                with gzip.open(f, 'wb') as g: g.write(data)
            else: open(f, 'wb').write(data)
            fixed += 1; print('fixed', os.path.relpath(f, d))
print(f'{fixed} file(s) fixed')
