"""Generate tokens.css from tokens.json.  Run: python3 docs/brand/gen_tokens.py"""
import json
import pathlib

here = pathlib.Path(__file__).parent
t = json.loads((here / "tokens.json").read_text(encoding="utf-8"))


def kebab(s: str) -> str:
    return "".join("-" + c.lower() if c.isupper() else c for c in s)


out = [":root {"]
for fam, scale in t["color"].items():
    if fam in ("status", "player", "material"):
        continue
    out += [f"  --{fam}-{k}: {v};" for k, v in scale.items()]
out += [f"  --material-{kebab(k)}: {v};" for k, v in t["color"]["material"].items()]
out += [f"  --status-{kebab(k)}: {v};" for k, v in t["color"]["status"].items()]
for game, sides in t["color"]["player"].items():
    out += [f"  --player-{game}-{side}: {v};" for side, v in sides.items()]
out += [f"  --{kebab(k)}: {v};" for k, v in t["theme"]["light"].items()]
out += [f"  --radius-{k}: {v}px;" for k, v in t["radius"].items()]
out += [f"  --space-{k}: {v}px;" for k, v in t["space"].items()]
out += [f"  --fs-{k}: {v}px;" for k, v in t["font"]["size"].items()]
out += [f"  --shadow-{k}: {v};" for k, v in t["shadow"].items()]
m = t["motion"]
out += [
    f"  --motion-fast: {m['fast']}ms;",
    f"  --motion-base: {m['base']}ms;",
    f"  --motion-slow: {m['slow']}ms;",
    f"  --ease-out: {m['easeOut']};",
    f"  --ease-in: {m['easeIn']};",
]
out += [f"  --motion-{kebab(k)}: {v}ms;" for k, v in m["game"].items()]
f = t["font"]
out += [
    f"  --font-ar-display: '{f['arabicDisplay']}', '{f['arabicText']}', sans-serif;",
    f"  --font-ar-text: '{f['arabicText']}', sans-serif;",
    f"  --font-ar-story: '{f['arabicStory']}', serif;",
    f"  --font-en-text: '{f['latinText']}', sans-serif;",
    f"  --font-en-story: '{f['latinStory']}', serif;",
    "}",
    "",
    "[data-theme='dark'] {",
]
out += [f"  --{kebab(k)}: {v};" for k, v in t["theme"]["dark"].items()]
out += [
    "}",
    "",
    "@media (prefers-reduced-motion: reduce) {",
    "  :root {",
]
out += [f"    --motion-{kebab(k)}: 0ms;" for k in ("pieceMove", "seedSow", "captureChainStep", "celebration", "logoIntro")]
out += ["  }", "}"]
(here / "tokens.css").write_text(
    "/* Generated from tokens.json by gen_tokens.py — do not edit by hand. */\n" + "\n".join(out) + "\n",
    encoding="utf-8",
)
