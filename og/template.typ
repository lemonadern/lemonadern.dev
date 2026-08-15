// OG image template for lemonadern.dev
//
// Usage:
//   typst compile --input title="<post title>" --input tags="tag1 tag2" --font-path og/fonts og/template.typ static/og/<slug>.png
//
// Renders a 1200x630 PNG with the post's tags, title, and the site name /
// domain. Palette follows the Serene theme's own steel-blue identity (see
// themes/serene/screenshot.png) rather than an unrelated color scheme. The
// title is set in bold to read clearly at a glance, while the tags and
// footer stay in the regular weight to keep them secondary.

#set page(
  width: 1200pt,
  height: 630pt,
  margin: 0pt,
  fill: rgb("#fbfcfe"),
)

// Palette sampled from themes/serene/screenshot.png: a cool, muted steel
// blue (#59719f-ish) used for the hero background, links, and tags in the
// theme's own screenshots, against near-white cards and near-black text.
#let color-bg-1 = rgb("#fbfcfe")
#let color-bg-2 = rgb("#eef1f6")
#let color-text = rgb("#262b33")
#let color-accent = rgb("#5b74a0")
#let color-tag = rgb("#5b74a0")
#let color-footer-primary = rgb("#384357")
#let color-footer-secondary = rgb("#7689ae")

#set text(
  font: "Noto Sans CJK JP",
  lang: "ja",
  fill: color-text,
)

#let title = sys.inputs.at("title", default: "")
#let tags-raw = sys.inputs.at("tags", default: "")
#let tag-list = tags-raw.split(" ").filter(t => t.len() > 0)
#let has-tags = tag-list.len() > 0

// BudouX-style phrase (bunsetsu) segmentation so the title wraps at natural
// linguistic boundaries instead of at arbitrary character positions.
#import "@preview/vitis:0.1.0": japanese-parser
#let title-segments = (japanese-parser.parse)(title)

// Dimensions of the title block below; shared with the fitting logic so the
// two stay in sync.
#let title-block-width = 1040pt
#let title-block-height = 380pt
#let tag-gap = 40pt

// Render the tag row, e.g. "#tech   #lsp   #zed".
#let render-tags() = text(size: 26pt, weight: "regular", fill: color-tag)[
  #tag-list.map(t => "#" + t).join("    ")
]

// Render a list of bunsetsu segments as the boxed title text used in the
// title block. Bold weight so the title reads clearly as the focal point.
#let render-title-segments(segs) = text(size: 60pt, weight: "bold", fill: color-text)[
  #for s in segs [#box[#s]]
]

// Overflow handling: if the full title doesn't fit in the title block at its
// normal size, truncate at a bunsetsu (phrase) boundary and append "…"
// instead of letting the text overflow into the rule/footer. `measure()`
// (inside `context`, per Typst 0.15) lets us try candidates against the
// actual rendered size at the real width/text style before committing to one.
// The available height is reduced by the tag row (when present), so the
// title never fights the tags for space.
#let fitted-title = context {
  // Space the tag row reserves within the title block (0 when there are no
  // tags), so the title-fitting logic below sees the true available height.
  let tags-reserved-height = if has-tags {
    measure(block(width: title-block-width)[#render-tags()]).height + tag-gap
  } else {
    0pt
  }
  let title-fit-height = title-block-height - tags-reserved-height

  let full = render-title-segments(title-segments)
  let full-size = measure(block(width: title-block-width)[#full])

  if full-size.height <= title-fit-height {
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
      if size.height <= title-fit-height {
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
      color-bg-1,
      color-bg-2,
      angle: 20deg,
    ),
  ),
)

// A thin accent rule near the top, echoing a minimal editorial mark.
#place(
  top + left,
  dx: 80pt,
  dy: 72pt,
  rect(width: 64pt, height: 4pt, fill: color-accent),
)

// Title block (with an optional tag row underneath), vertically
// centered-ish, with generous side margins.
#place(
  top + left,
  dx: 80pt,
  dy: 120pt,
  block(
    width: title-block-width,
    height: title-block-height,
    clip: true,
    align(horizon)[
      #if has-tags {
        stack(spacing: tag-gap, fitted-title, render-tags())
      } else {
        fitted-title
      }
    ],
  ),
)

// Footer: site name and domain. Larger and more present than before, but
// still clearly secondary to the title.
#place(
  bottom + left,
  dx: 80pt,
  dy: -72pt,
  text(size: 42pt, weight: "regular", fill: color-footer-primary)[器楽的緩怠],
)

#place(
  bottom + right,
  dx: -80pt,
  dy: -72pt,
  text(size: 32pt, weight: "regular", fill: color-footer-secondary)[lemonadern.dev],
)
