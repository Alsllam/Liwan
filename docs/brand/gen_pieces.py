"""Generate the Liwan piece set (SVG) and the pieces showcase.

Run: python3 docs/brand/gen_pieces.py
Every piece is an original design: turned, glazed forms in the spirit of the
abstract chess pieces of the Islamic world, with brass collars (brass work),
and stones and seeds drawn from real playing materials of the region.
"""
import pathlib

here = pathlib.Path(__file__).parent
out_dir = here / "pieces"

GLAZE = {
    # side: (deep, body, light, outline)
    "red": ("#5E1912", "#A8302A", "#D46A5C", "#3F100B"),
    "indigo": ("#0B1020", "#22304F", "#6F80AD", "#070A14"),
}
BRASS = ("#7A5512", "#C9962E", "#F7E7BF")


def defs(p, side):
    d, b, l, _ = GLAZE[side]
    bd, bb, bl = BRASS
    return f"""<defs>
  <linearGradient id="{p}body" x1="0" x2="1" y1="0" y2="0">
    <stop offset="0" stop-color="{d}"/><stop offset=".28" stop-color="{l}"/><stop offset=".5" stop-color="{b}"/><stop offset="1" stop-color="{d}"/>
  </linearGradient>
  <linearGradient id="{p}shade" x1="0" x2="0" y1="0" y2="1">
    <stop offset="0" stop-color="#fff" stop-opacity=".18"/><stop offset=".55" stop-color="#fff" stop-opacity="0"/><stop offset="1" stop-color="#000" stop-opacity=".28"/>
  </linearGradient>
  <linearGradient id="{p}brass" x1="0" x2="1" y1="0" y2="0">
    <stop offset="0" stop-color="{bd}"/><stop offset=".3" stop-color="{bl}"/><stop offset=".55" stop-color="{bb}"/><stop offset="1" stop-color="{bd}"/>
  </linearGradient>
  <radialGradient id="{p}gem" cx=".35" cy=".3" r=".8">
    <stop offset="0" stop-color="{bl}"/><stop offset=".6" stop-color="{bb}"/><stop offset="1" stop-color="{bd}"/>
  </radialGradient>
</defs>"""


def plinth(p, side, rx=32, top=94):
    _, _, _, o = GLAZE[side]
    bot = top + 9
    return f"""<ellipse cx="50" cy="{bot + 5}" rx="{rx + 4}" ry="5" fill="#1A120D" opacity=".22"/>
  <path d="M{50 - rx} {top} V{bot} A{rx} 6 0 0 0 {50 + rx} {bot} V{top} Z" fill="url(#{p}body)" stroke="{o}" stroke-width="1"/>
  <path d="M{50 - rx} {top} V{bot} A{rx} 6 0 0 0 {50 + rx} {bot} V{top} Z" fill="url(#{p}shade)"/>
  <ellipse cx="50" cy="{top}" rx="{rx}" ry="6" fill="url(#{p}body)" stroke="{o}" stroke-width="1"/>
  <ellipse cx="50" cy="{top + 4.5}" rx="{rx - 1}" ry="1.4" fill="url(#{p}brass)" opacity=".95"/>"""


def collar(p, y, rx):
    return f"""<ellipse cx="50" cy="{y + 2.5}" rx="{rx}" ry="4.2" fill="#1A120D" opacity=".25"/>
  <ellipse cx="50" cy="{y}" rx="{rx}" ry="4.2" fill="url(#{p}brass)" stroke="{BRASS[0]}" stroke-width=".8"/>"""


def body(p, side, d):
    o = GLAZE[side][3]
    return (f'<path d="{d}" fill="url(#{p}body)" stroke="{o}" stroke-width="1.1" stroke-linejoin="round"/>'
            f'<path d="{d}" fill="url(#{p}shade)"/>')


def gloss(x, y, rx, ry, rot=-8):
    return f'<ellipse cx="{x}" cy="{y}" rx="{rx}" ry="{ry}" transform="rotate({rot} {x} {y})" fill="#fff" opacity=".22"/>'


def gem(p, cx, cy, w, h):
    return (f'<path d="M{cx} {cy - h / 2} L{cx + w / 2} {cy} L{cx} {cy + h / 2} L{cx - w / 2} {cy} Z" '
            f'fill="url(#{p}gem)" stroke="{BRASS[0]}" stroke-width=".8"/>')


def bead(p, cx, cy, r):
    return f'<circle cx="{cx}" cy="{cy}" r="{r}" fill="url(#{p}gem)" stroke="{BRASS[0]}" stroke-width=".8"/>'


PIECES = {
    # Shāh: a throne — wide seat, tall rounded back, brass crest and finial
    "shah": ("شاه", "Shāh", lambda p, s: "".join([
        plinth(p, s),
        body(p, s, "M25 92 C25 76 27 66 31 60 L35 59 L35 30 Q35 19 50 16 Q65 19 65 30 L65 59 L69 60 C73 66 75 76 75 92 Z"),
        f'<path d="M31 60 Q50 66 69 60" fill="none" stroke="{GLAZE[s][3]}" stroke-width="1" opacity=".7"/>',
        f'<path d="M35 59 Q50 64 65 59" fill="none" stroke="#fff" stroke-width="1" opacity=".25"/>',
        gem(p, 50, 36, 11, 17), bead(p, 50, 13, 3.6), collar(p, 91, 26), gloss(41, 42, 3.5, 13),
    ])),
    # Firzān: the counsellor — a softer, lower dome with a small crest
    "firzan": ("فرزان", "Firzān", lambda p, s: "".join([
        plinth(p, s),
        body(p, s, "M27 92 C27 74 31 62 37 56 C42 40 58 40 63 56 C69 62 73 74 73 92 Z"),
        gem(p, 50, 64, 9, 13), bead(p, 50, 38, 3.4), collar(p, 91, 25), gloss(41, 62, 3.5, 12),
        f'<ellipse cx="50" cy="56" rx="13" ry="2.4" fill="url(#{p}brass)" opacity=".9"/>',
    ])),
    # Fīl: the elephant — a full dome with two tusk knobs tipped in brass
    "fil": ("فيل", "Fīl", lambda p, s: "".join([
        plinth(p, s),
        body(p, s, "M25 92 C25 70 33 54 50 52 C67 54 75 70 75 92 Z"),
        body(p, s, "M30 54 C30 44 44 44 44 54 C44 60 30 60 30 54 Z"),
        body(p, s, "M56 54 C56 44 70 44 70 54 C70 60 56 60 56 54 Z"),
        bead(p, 37, 45, 2.6), bead(p, 63, 45, 2.6), gem(p, 50, 72, 8, 12),
        collar(p, 91, 26), gloss(40, 70, 4, 12),
    ])),
    # Faras: the horse — a dome with one forward wedge (the head), brass eye
    "faras": ("فرس", "Faras", lambda p, s: "".join([
        plinth(p, s),
        body(p, s, "M25 92 C25 70 31 58 40 56 C38 44 44 32 58 22 Q70 15 71 21 L67 32 C64 42 61 50 62 56 C70 60 75 72 75 92 Z"),
        f'<path d="M44 52 C44 42 50 32 58 26" fill="none" stroke="{GLAZE[s][3]}" stroke-width="1.2" opacity=".6"/>',
        bead(p, 61, 31, 2.4), collar(p, 91, 26), gloss(37, 72, 4, 12),
    ])),
    # Rukh: the chariot — a tower block with the classic V-cleft and a brass band
    "rukh": ("رخ", "Rukh", lambda p, s: "".join([
        plinth(p, s),
        body(p, s, "M28 92 L30 38 Q30 30 37 30 L44 30 L50 44 L56 30 L63 30 Q70 30 70 38 L72 92 Z"),
        f'<path d="M29.4 60 H70.6 V66 H29.2 Z" fill="url(#{p}brass)" stroke="{BRASS[0]}" stroke-width=".7"/>',
        gem(p, 50, 63, 6, 9), collar(p, 91, 26), gloss(39, 46, 3.2, 11),
    ])),
    # Baidaq: the foot soldier — a small faceted dome with a brass bead
    "baidaq": ("بيدق", "Baidaq", lambda p, s: "".join([
        plinth(p, s, rx=24, top=96),
        body(p, s, "M33 94 C33 82 37 72 42 67 L58 67 C63 72 67 82 67 94 Z"),
        body(p, s, "M40 67 L44 56 L56 56 L60 67 Z"),
        f'<path d="M50 56 V67 M44 56 L46 67 M56 56 L54 67" stroke="{GLAZE[s][3]}" stroke-width=".8" opacity=".55"/>',
        bead(p, 50, 52, 3.4), collar(p, 93, 19), gloss(43, 80, 3, 8),
    ])),
}


def piece_svg(key, side, inner_only=False):
    p = f"{key}-{side}-"
    ar, en, draw = PIECES[key]
    g = defs(p, side) + draw(p, side)
    if inner_only:
        return g
    return (f'<svg xmlns="http://www.w3.org/2000/svg" viewBox="0 0 100 120" role="img" aria-label="{en} ({side})">\n'
            f'<title>{ar} · {en}</title>\n{g}\n</svg>\n')


# ---- Dama stones (ivory stone / ebony), sheikh = two stacked + brass ring
STONE = {"ivory": ("#B9A487", "#EFE6D6", "#FFFDF8", "#8C7860"), "ebony": ("#0E0A08", "#2A211C", "#6B5A4C", "#000")}


def stone_svg(color, sheikh=False, inner_only=False):
    d, b, l, o = STONE[color]
    p = f"stone-{color}-{'k' if sheikh else 'm'}-"
    bd, bb, bl = BRASS
    defs_ = f"""<defs>
  <radialGradient id="{p}top" cx=".38" cy=".3" r=".85"><stop offset="0" stop-color="{l}"/><stop offset=".55" stop-color="{b}"/><stop offset="1" stop-color="{d}"/></radialGradient>
  <linearGradient id="{p}side" x1="0" x2="1"><stop offset="0" stop-color="{d}"/><stop offset=".3" stop-color="{b}"/><stop offset="1" stop-color="{d}"/></linearGradient>
  <linearGradient id="{p}brass" x1="0" x2="1"><stop offset="0" stop-color="{bd}"/><stop offset=".3" stop-color="{bl}"/><stop offset=".55" stop-color="{bb}"/><stop offset="1" stop-color="{bd}"/></linearGradient>
</defs>"""

    def disc(cy):
        return (f'<path d="M14 {cy} V{cy + 9} A36 13 0 0 0 86 {cy + 9} V{cy} Z" fill="url(#{p}side)" stroke="{o}" stroke-width=".8"/>'
                f'<ellipse cx="50" cy="{cy}" rx="36" ry="13" fill="url(#{p}top)" stroke="{o}" stroke-width=".8"/>'
                f'<ellipse cx="50" cy="{cy}" rx="25" ry="8.6" fill="none" stroke="{d}" stroke-width="1.2" opacity=".55"/>'
                f'<ellipse cx="50" cy="{cy + .8}" rx="25" ry="8.6" fill="none" stroke="#fff" stroke-width=".8" opacity=".35"/>')

    g = f'<ellipse cx="50" cy="{86}" rx="40" ry="9" fill="#1A120D" opacity=".22"/>'
    if sheikh:
        g += disc(66)
        g += f'<path d="M14 64 V66 A36 13 0 0 0 86 66 V64 A36 13 0 0 1 14 64 Z" fill="url(#{p}brass)"/>'
        g += disc(52)
        g += f'<path d="M50 45 L56 52 L50 59 L44 52 Z" fill="url(#{p}brass)" stroke="{bd}" stroke-width=".7"/>'
    else:
        g += disc(64)
        g += f'<circle cx="50" cy="64" r="3.2" fill="url(#{p}brass)" stroke="{bd}" stroke-width=".6"/>'
    g = defs_ + g
    if inner_only:
        return g
    name = "شيخ · Sheikh" if sheikh else "حجر · Stone"
    return f'<svg xmlns="http://www.w3.org/2000/svg" viewBox="0 0 100 100" role="img"><title>{name} ({color})</title>\n{g}\n</svg>\n'


# ---- Mancala seeds: pebble, date pit, cowrie, pearl
def seeds_svg():
    return """<svg xmlns="http://www.w3.org/2000/svg" viewBox="0 0 240 60" role="img"><title>Seeds · بذور: pebble, date pit, cowrie, pearl</title>
<defs>
  <radialGradient id="sd-pebble" cx=".35" cy=".3" r=".9"><stop offset="0" stop-color="#E6D8C3"/><stop offset=".6" stop-color="#A8917A"/><stop offset="1" stop-color="#5C4A3D"/></radialGradient>
  <radialGradient id="sd-date" cx=".35" cy=".3" r=".9"><stop offset="0" stop-color="#B07A4E"/><stop offset=".6" stop-color="#6B4428"/><stop offset="1" stop-color="#3A2414"/></radialGradient>
  <radialGradient id="sd-cowrie" cx=".35" cy=".3" r=".9"><stop offset="0" stop-color="#FFFDF8"/><stop offset=".6" stop-color="#EDE3D1"/><stop offset="1" stop-color="#B9A487"/></radialGradient>
  <radialGradient id="sd-pearl" cx=".35" cy=".3" r=".8"><stop offset="0" stop-color="#FFFFFF"/><stop offset=".5" stop-color="#F4EFE6"/><stop offset=".85" stop-color="#D9CFE0"/><stop offset="1" stop-color="#A99FB4"/></radialGradient>
</defs>
<g opacity=".2" fill="#1A120D"><ellipse cx="30" cy="48" rx="16" ry="4"/><ellipse cx="90" cy="48" rx="18" ry="4"/><ellipse cx="150" cy="48" rx="17" ry="4"/><ellipse cx="210" cy="48" rx="13" ry="4"/></g>
<ellipse cx="30" cy="32" rx="16" ry="13" fill="url(#sd-pebble)"/><ellipse cx="25" cy="26" rx="5" ry="3" fill="#fff" opacity=".35"/>
<ellipse cx="90" cy="32" rx="20" ry="10" fill="url(#sd-date)"/><path d="M73 32 Q90 28 107 32" stroke="#2A170B" stroke-width="1.6" fill="none" opacity=".7"/><ellipse cx="83" cy="27" rx="6" ry="2" fill="#fff" opacity=".25"/>
<ellipse cx="150" cy="32" rx="18" ry="13" fill="url(#sd-cowrie)"/><path d="M134 34 Q150 30 166 34" stroke="#8C7860" stroke-width="2.2" fill="none" stroke-linecap="round"/><path d="M138 33 v3 M144 32 v3 M150 31.5 v3 M156 32 v3 M162 33 v3" stroke="#8C7860" stroke-width="1"/>
<circle cx="210" cy="32" r="13" fill="url(#sd-pearl)"/><ellipse cx="205" cy="26" rx="4.5" ry="3" fill="#fff" opacity=".7"/>
</svg>
"""


def write_all():
    for key in PIECES:
        for side in GLAZE:
            (out_dir / f"shatranj-{key}-{side}.svg").write_text(piece_svg(key, side), encoding="utf-8")
    for color in STONE:
        (out_dir / f"dama-stone-{color}.svg").write_text(stone_svg(color), encoding="utf-8")
        (out_dir / f"dama-sheikh-{color}.svg").write_text(stone_svg(color, sheikh=True), encoding="utf-8")
    (out_dir / "mancala-seeds.svg").write_text(seeds_svg(), encoding="utf-8")
    old = out_dir / "shatranj-concept.svg"
    if old.exists():
        old.unlink()


def showcase():
    """A board in the starting position (decision Shatranj D2: shāh on e-file)."""
    sq = 64
    back = ["rukh", "faras", "fil", "firzan", "shah", "fil", "faras", "rukh"]
    cells = []
    for r in range(8):
        for f in range(8):
            cells.append(f'<rect x="{f * sq}" y="{r * sq}" width="{sq}" height="{sq}" fill="none" stroke="#22304F" stroke-opacity=".35" stroke-width="1.2"/>')
    pieces = []

    def place(key, side, f, r):  # r: 0 = top rank (8)
        x, y = f * sq + 2, r * sq - 14
        pieces.append(f'<svg x="{x}" y="{y}" width="60" height="72" viewBox="0 0 100 120">{piece_svg(key, side, True).replace("id=\"", f"id=\"b{f}{r}").replace("url(#", f"url(#b{f}{r}")}</svg>')

    for f, k in enumerate(back):
        place(k, "indigo", f, 0)
        place("baidaq", "indigo", f, 1)
    for f, k in enumerate(back):
        place("baidaq", "red", f, 6)
        place(k, "red", f, 7)
    tri = "".join(f'<path d="M{i * 16} 0 l8 -9 l8 9 z" fill="#9B2C22"/>' for i in range(32))
    tri_i = "".join(f'<path d="M{i * 16 + 8} 0 l4 -5 l4 5 z" fill="#C9962E"/>' for i in range(32))
    board = (f'<rect x="-24" y="-24" width="{8 * sq + 48}" height="{8 * sq + 48}" rx="14" fill="#E9DCC6"/>'
             f'<rect x="-6" y="-6" width="{8 * sq + 12}" height="{8 * sq + 12}" fill="#F3EADB" stroke="#22304F" stroke-opacity=".5"/>'
             f'<g transform="translate(0 {8 * sq + 20})">{tri}{tri_i}</g><g transform="translate({8 * sq} -20) rotate(180)">{tri}{tri_i}</g>')
    return (f'<svg xmlns="http://www.w3.org/2000/svg" viewBox="-30 -30 {8 * sq + 60} {8 * sq + 60}" role="img">'
            f'<title>Shatranj — starting position on the sadu-cloth board</title>{board}{"".join(cells)}{"".join(pieces)}</svg>\n')


if __name__ == "__main__":
    write_all()
    (out_dir / "shatranj-board-showcase.svg").write_text(showcase(), encoding="utf-8")
