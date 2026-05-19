+++
title = "Markdown Check"
description = "A playground page to verify serene's Markdown rendering."
date = 2026-05-19
updated = 2026-05-19

[taxonomies]
tags = ["markdown", "theme-check"]

[extra]
lang = "ja"
toc = true
copy = true
math = true
mermaid = true
comment = false
reaction = false
+++

`serene` の Markdown 表示確認用ページです。スタイル調整のたびにここを見れば、主要な要素の崩れをまとめて確認できます。

## Paragraphs

普通の段落です。日本語の文章量が少しある状態で、行間や文字サイズ、リンクの色がどう見えるかを確認します。[外部リンク](https://www.getzola.org/) もここで見ます。

強調は *italic*、**bold**、***bold italic***、インラインコードは `let answer = 42` です。

## Headings

### Heading Three

TOC の階層、見出し間の余白、アンカーリンクの位置を確認します。

#### Heading Four

必要なら h4 以降の見え方もここで見るようにします。

## Lists

- unordered list
- second item
- third item with `inline code`

1. ordered list
2. second item
3. third item

- mixed content
  - nested item
  - another nested item

## Blockquote

> 引用です。
> 複数行で続いたときの余白と左線の見え方を見ます。

## Code

```ts
type Post = {
  title: string;
  tags: string[];
};

const post: Post = {
  title: "Markdown Check",
  tags: ["zola", "serene"],
};

console.log(post);
```

```rust
fn main() {
    println!("hello, serene");
}
```

## Table

| name | role | note |
| --- | --- | --- |
| Zola | SSG | one binary |
| Serene | Theme | minimal |
| This page | Fixture | visual check |

## Footnote

脚注の確認です。[^footnote]

[^footnote]: 脚注本文です。

## Alerts

> [!NOTE]
> GitHub alerts がテーマ上でどう見えるかを確認します。

> [!WARNING]
> 強い注意表示の見た目もここで確認します。

## Math

インライン数式 $e^{i\pi} + 1 = 0$ と、ブロック数式:

$$
\int_0^1 x^2 dx = \frac{1}{3}
$$

## Mermaid

{% mermaid() %}
flowchart TD
    A[Write sample page] --> B[Open in browser]
    B --> C[Adjust styles]
    C --> D[Repeat]
{% end %}

## Horizontal Rule

---

## Image

画像を後で見たいときはここに追加します。今はダミーとして終了です。
