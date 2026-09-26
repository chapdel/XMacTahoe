#!/usr/bin/env python3
"""Give the Aurorae traffic lights the glassy shading of macOS Golden Gate.

Each state of a button (active, hover, pressed, inactive) draws one flat coloured circle. This adds,
without touching the geometry: a vertical gradient on the circle (lighter at the top, deeper at the
bottom) and a specular highlight drawn as a copy of the same path filled with a radial gradient.
The pressed state is darkened and its highlight dimmed, so a click reads as a press.

Usage: tools/gloss-buttons.py [THEME_DIR ...]      (default: the package's aurorae themes)
       tools/gloss-buttons.py --revert THEME_DIR   (put the flat colours back)

Gradients use objectBoundingBox units, so they need no knowledge of the drawing's coordinates.
Running it twice is harmless: a file already processed is skipped.
"""
import os, re, sys

MARK = 'xmt-gloss'
# the traffic-light colours of the theme; everything else (glyphs, spacers) is left alone
# the traffic lights are the only coloured circles; greys (an inactive window) stay flat, as on macOS
def colourful(hex_colour):
    r, g, b = (int(hex_colour[i:i + 2], 16) for i in (0, 2, 4))
    return max(r, g, b) - min(r, g, b) > 30
STATES = ('active', 'inactive', 'pressed', 'hover', 'deactivated')


def shade(hex_colour, factor):
    """factor > 1 lightens, < 1 darkens."""
    r, g, b = (int(hex_colour[i:i + 2], 16) for i in (0, 2, 4))
    if factor >= 1:
        r, g, b = (round(c + (255 - c) * (factor - 1)) for c in (r, g, b))
    else:
        r, g, b = (round(c * factor) for c in (r, g, b))
    return '%02x%02x%02x' % (min(255, r), min(255, g), min(255, b))


def defs(colours):
    out = [f'<defs id="{MARK}">']
    for c in sorted(colours):
        out.append(f'<linearGradient id="xmtg-{c}" x1="0" y1="0" x2="0" y2="1">'
                   f'<stop offset="0" stop-color="#{shade(c, 1.22)}"/>'
                   f'<stop offset="0.55" stop-color="#{c}"/>'
                   f'<stop offset="1" stop-color="#{shade(c, 0.82)}"/></linearGradient>')
        out.append(f'<linearGradient id="xmtp-{c}" x1="0" y1="0" x2="0" y2="1">'
                   f'<stop offset="0" stop-color="#{shade(c, 0.78)}"/>'
                   f'<stop offset="1" stop-color="#{shade(c, 0.95)}"/></linearGradient>')
    out.append('<radialGradient id="xmtgloss" cx="0.5" cy="0.24" r="0.62">'
               '<stop offset="0" stop-color="#ffffff" stop-opacity="0.45"/>'
               '<stop offset="0.5" stop-color="#ffffff" stop-opacity="0.1"/>'
               '<stop offset="1" stop-color="#ffffff" stop-opacity="0"/></radialGradient>')
    out.append('</defs>')
    return '\n'.join(out)


def state_spans(text):
    """[(state name, start, end)] for every state group of the file, in document order."""
    marks = [(m.group(1), m.start()) for m in re.finditer(r'id="((?:%s)[a-z-]*center)"' % '|'.join(STATES), text)]
    spans = []
    for i, (name, start) in enumerate(marks):
        end = marks[i + 1][1] if i + 1 < len(marks) else len(text)
        spans.append((name, start, end))
    return spans


def gloss(path):
    text = open(path).read()
    if MARK in text:
        return 'already done'
    used, pieces, last = set(), [], 0
    for name, start, end in state_spans(text):
        chunk = text[start:end]
        pressed = name.startswith('pressed')
        # the circle is the first path carrying a traffic-light colour; glyphs come after it
        # the topmost coloured circle: some buttons draw a darker ring under the face
        matches = [x for x in re.finditer(r'<path\b[^>]*?fill:#([0-9a-fA-F]{6})[^>]*?/>', chunk, re.S)
                   if colourful(x.group(1).lower())]
        m = matches[-1] if matches else None
        if not m:
            continue
        element, colour = m.group(0), m.group(1).lower()
        used.add(colour)
        filled = element.replace(f'fill:#{colour}', f'fill:url(#{"xmtp" if pressed else "xmtg"}-{colour})')
        highlight = re.sub(r'\bid="[^"]*"', 'id="%s-%s"' % (MARK, name), element, count=1)
        highlight = re.sub(r'style="[^"]*"', 'style="fill:url(#xmtgloss);fill-opacity:%s;stroke:none"'
                           % ('0.35' if pressed else '0.9'), highlight, count=1)
        pieces.append(text[last:start + m.start()])
        pieces.append(filled + '\n' + highlight)
        last = start + m.end()
    if not used:
        return 'nothing to gloss'
    pieces.append(text[last:])
    out = ''.join(pieces)
    out = re.sub(r'(<svg\b[^>]*>)', r'\1\n' + defs(used), out, count=1)
    open(path, 'w').write(out)
    return f'{len(pieces) // 2} states, colours {", ".join(sorted(used))}'


def revert(path):
    text = open(path).read()
    if MARK not in text:
        return 'not glossed'
    text = re.sub(r'<defs id="%s">.*?</defs>\n?' % MARK, '', text, flags=re.S)
    text = re.sub(r'\s*<path\b[^>]*id="%s-[^"]*"[^>]*/>' % MARK, '', text)
    text = re.sub(r'fill:url\(#xmt[gp]-([0-9a-f]{6})\)', r'fill:#\1', text)
    open(path, 'w').write(text)
    return 'reverted'


def main():
    args = [a for a in sys.argv[1:] if a != '--revert']
    action = revert if '--revert' in sys.argv else gloss
    base = os.path.dirname(os.path.dirname(os.path.abspath(__file__)))
    dirs = args or [f'{base}/aurorae/themes/XMacTahoe', f'{base}/aurorae/themes/XMacTahoe-Night']
    for d in dirs:
        for name in sorted(os.listdir(d)):
            if name.endswith('.svg') and name != 'decoration.svg':
                print(f'{os.path.basename(d)}/{name}: {action(os.path.join(d, name))}')


main()
