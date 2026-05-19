+++
title = "タイポグラフィ確認用ページ"
date = 2026-04-15

[taxonomies]
tags = ["article", "test"]

[extra]
math = true
+++


## 見出し h2

### 見出し h3

#### 見出し h4

## 段落

これは通常の段落テキストです。日本語と English が混在しています。段落が複数行にわたる場合のレンダリングを確認します。Lorem ipsum dolor sit amet, consectetur adipiscing elit.

これは2つ目の段落です。

## リスト

### 箇条書き

- アイテム 1
- アイテム 2
  - ネストされたアイテム 2-1
  - ネストされたアイテム 2-2
    - さらにネスト 2-2-1
- アイテム 3

### 番号付きリスト

1. 最初のアイテム
2. 2番目のアイテム
3. 3番目のアイテム

## リンク

[通常のリンク](https://github.com/lemonadern)

段落の中に[インラインリンク](https://github.com/lemonadern)が含まれる場合のスタイルです。長いURLの折り返し確認: [https://example.com/very/long/path/that/should/break/appropriately/in/the/layout](https://example.com/very/long/path/that/should/break/appropriately/in/the/layout)

## コード

インラインコード: `const x = 42;` や `deno task build` のようなもの。

コードブロック:

```typescript
import lume from "lume/mod.ts";
import tailwindCSS from "lume/plugins/tailwindcss.ts";

const site = lume({ src: "./src" });
site.use(tailwindCSS());

export default site;
```

```bash
deno task build
deno task serve
```

## 引用

> これは blockquote です。引用文のスタイルを確認します。
> 複数行にわたる引用も確認します。

## テーブル

| 列 1 | 列 2 | 列 3 |
|------|------|------|
| セル A | セル B | セル C |
| セル D | セル E | セル F |

## 数式 (KaTeX)

インライン数式: $E = mc^2$

ブロック数式:

$$
\int_{-\infty}^{\infty} e^{-x^2} dx = \sqrt{\pi}
$$

$$
\sum_{n=1}^{\infty} \frac{1}{n^2} = \frac{\pi^2}{6}
$$

## 脚注

本文中に脚注[^1]を含む場合のレンダリングです。

[^1]: これが脚注の内容です。
