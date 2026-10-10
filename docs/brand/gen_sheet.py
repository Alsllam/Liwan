"""Build brand-sheet.html from tokens.json and the SVGs.  Run: python3 docs/brand/gen_sheet.py"""
import json
import pathlib

here = pathlib.Path(__file__).parent
t = json.loads((here / "tokens.json").read_text(encoding="utf-8"))
svg = lambda p: (here / p).read_text(encoding="utf-8")
c = t["color"]


def lum(h):
    r, g, b = (int(h[i : i + 2], 16) / 255 for i in (1, 3, 5))
    f = lambda x: x / 12.92 if x <= 0.03928 else ((x + 0.055) / 1.055) ** 2.4
    return 0.2126 * f(r) + 0.7152 * f(g) + 0.0722 * f(b)


def swatches(name, scale, label):
    cells = "".join(
        f'<div class="sw" style="background:{v};color:{"#FFF" if lum(v) < 0.2 else "#2A1E17"}"><b>{k}</b><span>{v}</span></div>'
        for k, v in scale.items()
    )
    return f'<div class="scale"><h4>{label}</h4><div class="sws">{cells}</div></div>'


def board_shatranj():
    cells = "".join(
        f'<rect x="{8 + x * 26}" y="{8 + y * 26}" width="26" height="26" fill="none" stroke="#22304F" stroke-opacity=".45"/>'
        for x in range(6) for y in range(4)
    )
    tri = "".join(f'<path d="M{8 + i * 13} 120 l6.5 -8 l6.5 8 z" fill="#9B2C22"/>' for i in range(12))
    dots = '<circle cx="73" cy="47" r="4" fill="#C9962E"/><circle cx="99" cy="73" r="4" fill="#C9962E"/>'
    return f'<svg viewBox="0 0 172 124" width="344"><rect x="2" y="2" width="168" height="120" rx="6" fill="#F3EADB"/>{cells}{tri}{dots}</svg>'


def board_mancala():
    pits = "".join(
        f'<ellipse cx="{22 + i * 22}" cy="{30 + r * 40}" rx="9" ry="13" fill="#4E3220"/>' for i in range(7) for r in range(2)
    )
    seeds = "".join(f'<circle cx="{18 + (k % 2) * 7}" cy="{24 + (k // 2) * 6}" r="2.6" fill="#F4EFE6"/>' for k in range(5))
    glow = '<rect x="8" y="54" width="156" height="34" rx="17" fill="#DDB65E" fill-opacity=".22"/>'
    return f'<svg viewBox="0 0 172 100" width="344"><rect x="2" y="6" width="168" height="88" rx="14" fill="#7A4E2D"/>{glow}{pits}{seeds}</svg>'


html = f"""<!doctype html>
<html lang="ar" dir="rtl"><head><meta charset="utf-8"><meta name="viewport" content="width=device-width,initial-scale=1">
<title>Liwan Brand Sheet</title>
<!--FONTS--><link href="https://fonts.googleapis.com/css2?family=Amiri&family=IBM+Plex+Sans+Arabic:wght@400;600&family=IBM+Plex+Sans:wght@400;600&family=Reem+Kufi:wght@600&display=swap" rel="stylesheet"><!--/FONTS-->
<style>
:root{{--ink:#2A1E17;--muted:#7A6656;--surface:#FBF6EE;--sunken:#F3EADB}}
body{{margin:0;background:var(--surface);color:var(--ink);font-family:'IBM Plex Sans Arabic','IBM Plex Sans',sans-serif;line-height:1.7}}
main{{max-width:1080px;margin:auto;padding:32px 16px}}
h1{{font-family:'Reem Kufi',sans-serif;font-size:36px;margin:0}} h2{{font-family:'Reem Kufi',sans-serif;font-size:24px;margin:40px 0 12px;color:#9B2C22}}
h4{{margin:12px 0 6px;font-size:14px;color:var(--muted)}}
.band{{height:14px;background:repeating-linear-gradient(90deg,#9B2C22 0 14px,#22304F 14px 28px,#FBF6EE 28px 42px,#C9962E 42px 56px)}}
.row{{display:flex;flex-wrap:wrap;gap:24px;align-items:center}} .card{{background:#fff;border-radius:12px;padding:20px;box-shadow:{t['shadow']['sm']}}}
.dark{{background:#14161F;color:#F3EADB}} .sws{{display:flex;flex-wrap:wrap}} .sw{{width:84px;height:64px;padding:6px;box-sizing:border-box;font-size:11px;display:flex;flex-direction:column;justify-content:space-between;direction:ltr}}
.sw span{{font-family:'IBM Plex Sans',monospace;opacity:.85}} .en{{direction:ltr;font-family:'IBM Plex Sans',sans-serif}}
.kufi{{font-family:'Reem Kufi',sans-serif;font-size:30px}} .story{{font-family:Amiri,serif;font-size:20px}}
table{{border-collapse:collapse;font-size:14px}} td,th{{padding:6px 12px;border-bottom:1px solid #E6D8C3;text-align:start}}
</style></head><body><div class="band"></div><main>
<div class="row"><div style="width:96px">{svg('logo/logo-mark.svg')}</div><div><h1>ليوان · Liwan</h1><div style="color:var(--muted)">هوية العلامة — Brand kit v0.1 (draft)</div></div></div>

<h2>الشعار · Logo</h2>
<div class="row">
 <div class="card" style="width:300px">{svg('logo/logo-ar.svg')}</div>
 <div class="card" style="width:300px">{svg('logo/logo-en.svg')}</div>
 <div class="card dark" style="width:80px;color:#D3A443">{svg('logo/logo-mono.svg')}</div>
 <div class="card"><span style="display:inline-block;width:16px">{svg('logo/favicon.svg')}</span> <span style="display:inline-block;width:32px">{svg('logo/logo-mark.svg')}</span> <span style="display:inline-block;width:64px">{svg('logo/logo-mark.svg')}</span></div>
</div>

<h2>الألوان · Color</h2>
{swatches('sadu', c['sadu'], 'السدو الأحمر · Sadu red (primary)')}
{swatches('brass', c['brass'], 'النحاس · Brass (accent)')}
{swatches('palm', c['palm'], 'النخل · Palm (secondary)')}
{swatches('indigo', c['indigo'], 'نيلي الليل · Indigo night')}
{swatches('neutral', c['neutral'], 'محايدات دافئة · Warm neutrals')}
{swatches('material', c['material'], 'خامات الرقع والقطع · Board and piece materials')}

<h2>الخطوط · Type</h2>
<div class="card">
 <div class="kufi">الشطرنج · المنقلة · الدامة</div>
 <div>Reem Kufi — عناوين وأسماء الألعاب</div><hr style="border:0;border-top:1px solid #E6D8C3">
 <div style="font-size:18px">حرّك الفرس إلى المربع المضيء، ثم انتظر ردّ خصمك.</div>
 <div class="en" style="font-size:18px">Move the faras to the glowing square, then wait for your opponent.</div>
 <div style="color:var(--muted)">IBM Plex Sans Arabic + IBM Plex Sans — UI, tutorials, rules</div><hr style="border:0;border-top:1px solid #E6D8C3">
 <div class="story">تُروى حكاية أنّ الصولي كان يلعب الشطرنج بين يدي الخلفاء في بغداد…</div>
 <div style="color:var(--muted)">Amiri — heritage stories</div>
</div>

<h2>الرقع والقطع · Boards and pieces (concept)</h2>
<div class="row">
 <div class="card">{board_shatranj()}<h4>Shatranj — unchequered sadu-cloth grid, brass legal-move dots</h4></div>
 <div class="card">{board_mancala()}<h4>Manqala — carved wood, active row glow</h4></div>
</div>
<div class="card" style="margin-top:16px">
 <div class="row" style="gap:4px">{''.join(f'<span style="width:110px">{svg(f"pieces/shatranj-{k}-red.svg")}</span>' for k in ("shah","firzan","fil","faras","rukh","baidaq"))}</div>
 <div class="row" style="gap:4px">{''.join(f'<span style="width:110px">{svg(f"pieces/shatranj-{k}-indigo.svg")}</span>' for k in ("shah","firzan","fil","faras","rukh","baidaq"))}</div>
 <h4>قطع الشطرنج: شاه · فرزان · فيل · فرس · رخ · بيدق — original turned, glazed pieces with brass collars</h4>
</div>
<div class="row" style="margin-top:16px">
 <div class="card"><div class="row" style="gap:8px">{''.join(f'<span style="width:96px">{svg(f"pieces/dama-{n}.svg")}</span>' for n in ("stone-ivory","sheikh-ivory","stone-ebony","sheikh-ebony"))}</div><h4>الدامة: حجر وشيخ — ivory stone and ebony; the sheikh is two stacked stones with a brass ring</h4></div>
 <div class="card"><div style="width:300px">{svg("pieces/mancala-seeds.svg")}</div><h4>بذور المنقلة: حصى · نوى تمر · ودع · لؤلؤ</h4></div>
</div>
<div class="card" style="margin-top:16px;max-width:560px">{svg("pieces/shatranj-board-showcase.svg")}<h4>Shatranj starting position on the sadu-cloth board</h4></div>

<h2>الحركة · Motion</h2>
<table class="en"><tr><th>Token</th><th>ms</th></tr>
{''.join(f'<tr><td>{k}</td><td>{v}</td></tr>' for k, v in t['motion']['game'].items())}
</table>
</main><div class="band"></div></body></html>
"""
(here / "brand-sheet.html").write_text(html, encoding="utf-8")
