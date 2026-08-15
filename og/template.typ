// OG image template for lemonadern.dev
//
// Usage:
//   typst compile --input title="<post title>" --font-path og/fonts og/template.typ static/og/<slug>.png
//
// Renders a 1200x630 PNG with the post title, the site name, and the site
// domain. Kept intentionally understated: a quiet, mostly-monochrome
// background rather than anything saturated or "corporate" looking, in
// keeping with the tone of the blog.

#set page(
  width: 1200pt,
  height: 630pt,
  margin: 0pt,
  fill: rgb("#f7f5f1"),
)

#set text(
  font: "Noto Sans CJK JP",
  lang: "ja",
  fill: rgb("#2b2926"),
)

#let title = sys.inputs.at("title", default: "")

// BudouX-style phrase (bunsetsu) segmentation so the title wraps at natural
// linguistic boundaries instead of at arbitrary character positions.
#import "@preview/vitis:0.1.0": japanese-parser
#let title-segments = (japanese-parser.parse)(title)

// Dimensions of the title block below; shared with the fitting logic so the
// two stay in sync.
#let title-block-width = 1040pt
#let title-block-height = 380pt

// Render a list of bunsetsu segments as the boxed, bold title text used in
// the title block.
#let render-title-segments(segs) = text(size: 60pt, weight: "bold", fill: rgb("#2b2926"))[
  #for s in segs [#box[#s]]
]

// Overflow handling: if the full title doesn't fit in the title block at its
// normal size, truncate at a bunsetsu (phrase) boundary and append "…"
// instead of letting the text overflow into the rule/footer. `measure()`
// (inside `context`, per Typst 0.15) lets us try candidates against the
// actual rendered size at the real width/text style before committing to one.
#let fitted-title = context {
  let full = render-title-segments(title-segments)
  let full-size = measure(block(width: title-block-width)[#full])

  if full-size.height <= title-block-height {
    full
  } else {
    let n = title-segments.len()
    let chosen = render-title-segments(("…",))

    // Try including as many leading segments as possible (falling back
    // toward fewer), stopping at the first one that fits.
    for k in range(0, n + 1).rev() {
      let segs = title-segments.slice(0, k)
      if segs.len() == 0 {
        segs = ("…",)
      } else {
        segs.at(segs.len() - 1) += "…"
      }
      let candidate = render-title-segments(segs)
      let size = measure(block(width: title-block-width)[#candidate])
      if size.height <= title-block-height {
        chosen = candidate
        break
      }
    }

    chosen
  }
}

// Soft, very subtle vertical gradient background instead of a flat fill.
#place(
  top + left,
  rect(
    width: 100%,
    height: 100%,
    fill: gradient.linear(
      rgb("#f9f7f3"),
      rgb("#efeae2"),
      angle: 20deg,
    ),
  ),
)

// A thin accent rule near the top, echoing a minimal editorial mark.
#place(
  top + left,
  dx: 80pt,
  dy: 72pt,
  rect(width: 64pt, height: 4pt, fill: rgb("#9c8b6e")),
)

// Title block, vertically centered-ish, with generous side margins.
#place(
  top + left,
  dx: 80pt,
  dy: 120pt,
  block(
    width: title-block-width,
    height: title-block-height,
    clip: true,
    align(horizon)[#fitted-title],
  ),
)

// Footer: site name and domain, kept small and quiet.
#place(
  bottom + left,
  dx: 80pt,
  dy: -72pt,
  text(size: 24pt, weight: "medium", fill: rgb("#57524a"))[器楽的緩怠],
)

#place(
  bottom + right,
  dx: -80pt,
  dy: -72pt,
  text(size: 20pt, fill: rgb("#8a8378"))[lemonadern.dev],
)
