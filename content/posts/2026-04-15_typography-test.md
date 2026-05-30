+++
title = "タイポグラフィ確認用ページ"
date = 2026-04-15
description = "このブログにおいて利用可能な記法とそのレンダリング結果の一覧"

[taxonomies]
tags = ["sample"]

[extra]
math = true
mermaid = true
heading_hashes = true
+++

## 見出し

```md
### h3
#### h4
##### h5
###### h6
```

### h3
#### h4
##### h5
###### h6

## テキスト装飾

```md
**太字 (bold)**、*イタリック (italic)*、***太字イタリック***、~~打ち消し (strikethrough)~~
```

**太字 (bold)**、*イタリック (italic)*、***太字イタリック***、~~打ち消し (strikethrough)~~

## 水平線

```md
---
```

---

## 段落

```md
これは通常の段落テキストです。日本語と English が混在しています。Lorem ipsum dolor sit amet, consectetur adipiscing elit.

これは2つ目の段落です。
```

これは通常の段落テキストです。日本語と English が混在しています。Lorem ipsum dolor sit amet, consectetur adipiscing elit.

これは2つ目の段落です。

## リスト

### 箇条書き

```md
- アイテム 1
- アイテム 2
  - ネストされたアイテム 2-1
  - ネストされたアイテム 2-2
    - さらにネスト 2-2-1
- アイテム 3
```

- アイテム 1
- アイテム 2
  - ネストされたアイテム 2-1
  - ネストされたアイテム 2-2
    - さらにネスト 2-2-1
- アイテム 3

### 番号付きリスト

```md
1. 最初のアイテム
2. 2番目のアイテム
3. 3番目のアイテム
```

1. 最初のアイテム
2. 2番目のアイテム
3. 3番目のアイテム

### タスクリスト

```md
- [x] 完了済みのタスク
- [x] これも完了
- [ ] 未完了のタスク
- [ ] これも未完了
```

- [x] 完了済みのタスク
- [x] これも完了
- [ ] 未完了のタスク
- [ ] これも未完了

## リンク

```md
[通常のリンク](https://github.com/lemonadern)

段落の中に[インラインリンク](https://github.com/lemonadern)が含まれる場合のスタイルです。
```

[通常のリンク](https://github.com/lemonadern)

段落の中に[インラインリンク](https://github.com/lemonadern)が含まれる場合のスタイルです。

## コード

### インラインコード

```md
`const x = 42;` や `deno task build`
```

`const x = 42;` や `deno task build`

### コードブロック

````md
```typescript
import lume from "lume/mod.ts";
import tailwindCSS from "lume/plugins/tailwindcss.ts";

const site = lume({ src: "./src" });
site.use(tailwindCSS());

export default site;
```
````

```typescript
import lume from "lume/mod.ts";
import tailwindCSS from "lume/plugins/tailwindcss.ts";

const site = lume({ src: "./src" });
site.use(tailwindCSS());

export default site;
```

### ファイル名アノテーション付き

````md
```typescript,name=lume.config.ts
import lume from "lume/mod.ts";
import tailwindCSS from "lume/plugins/tailwindcss.ts";

const site = lume({ src: "./src" });
site.use(tailwindCSS());

export default site;
```
````

```typescript,name=lume.config.ts
import lume from "lume/mod.ts";
import tailwindCSS from "lume/plugins/tailwindcss.ts";

const site = lume({ src: "./src" });
site.use(tailwindCSS());

export default site;
```

## 引用

```md
> これは blockquote です。引用文のスタイルを確認します。  
> 複数行にわたる引用も確認します。
```

> これは blockquote です。引用文のスタイルを確認します。  
> 複数行にわたる引用も確認します。

### ネストした引用

```md
> ネストした引用の外側
> > ネストした引用の内側
> > > さらに深いネスト
```

> ネストした引用の外側
> > ネストした引用の内側
> > > さらに深いネスト

## テーブル

```md
| 列 1   | 列 2   | 列 3   |
|--------|--------|--------|
| セル A | セル B | セル C |
| セル D | セル E | セル F |
```

| 列 1   | 列 2   | 列 3   |
|--------|--------|--------|
| セル A | セル B | セル C |
| セル D | セル E | セル F |

## 数式 (KaTeX)

### インライン数式

```md
$E = mc^2$
```

$E = mc^2$

### ブロック数式

```md
$$
\int_{-\infty}^{\infty} e^{-x^2} dx = \sqrt{\pi}
$$
```

$$
\int_{-\infty}^{\infty} e^{-x^2} dx = \sqrt{\pi}
$$

## コールアウト

<!-- コードブロック内のショートコード記法は {%/* ... */%} でエスケープしている。そのままだと Zola がコードブロック内でも展開してしまうため。 -->

### note

```
{%/* note() */%}
これは **note** です。Markdown も使えます。
{%/* end */%}
```

{% note() %}
これは **note** です。Markdown も使えます。
{% end %}

### tip

```
{%/* tip() */%}
これは **tip** です。
{%/* end */%}
```

{% tip() %}
これは **tip** です。
{% end %}

### warning

```
{%/* warning() */%}
これは **warning** です。
{%/* end */%}
```

{% warning() %}
これは **warning** です。
{% end %}

### important

```
{%/* important() */%}
これは **important** です。
{%/* end */%}
```

{% important() %}
これは **important** です。
{% end %}

### caution

```
{%/* caution() */%}
これは **caution** です。
{%/* end */%}
```

{% caution() %}
これは **caution** です。
{% end %}

### タイトル付き

```
{%/* warning(title="注意") */%}
`title` 引数を渡すとタイトルが付きます。
{%/* end */%}
```

{% warning(title="注意") %}
`title` 引数を渡すとタイトルが付きます。
{% end %}

## Mermaid

### flowchart

```
{%/* mermaid() */%}
flowchart LR
    A[開始] --> B{条件}
    B -->|Yes| C[処理 A]
    B -->|No| D[処理 B]
    C --> E[終了]
    D --> E
{%/* end */%}
```

{% mermaid() %}
flowchart LR
    A[開始] --> B{条件}
    B -->|Yes| C[処理 A]
    B -->|No| D[処理 B]
    C --> E[終了]
    D --> E
{% end %}

### sequenceDiagram

```
{%/* mermaid() */%}
sequenceDiagram
    participant ブラウザ
    participant サーバ
    ブラウザ->>サーバ: GET /api/data
    サーバ-->>ブラウザ: 200 OK
{%/* end */%}
```

{% mermaid() %}
sequenceDiagram
    participant ブラウザ
    participant サーバ
    ブラウザ->>サーバ: GET /api/data
    サーバ-->>ブラウザ: 200 OK
{% end %}

## 脚注

```md
本文中に脚注[^1]を含む場合のレンダリングです。

[^1]: これが脚注の内容です。
```

本文中に脚注[^1]を含む場合のレンダリングです。

[^1]: これが脚注の内容です。

## 傍点

```
{%/* bouten() */%}傍点をつけたいテキスト{%/* end */%}

人は生まれながらにして{%/* bouten() */%}自由{%/* end */%}であり、かつ至る所で鎖につながれている。自分が他人の主人であると思っているものも、実はその人々以上に奴隷なのだ。どうしてこのような変化が起きたのか。わたしには分からない。何がそれを{%/* bouten() */%}正当なものたらしめる{%/* end */%}か。わたしはこの問題に答えることができると信ずる。
```

{% bouten() %}傍点をつけたいテキスト{% end %}

人は生まれながらにして{% bouten() %}自由{% end %}であり、かつ至る所で鎖につながれている。自分が他人の主人であると思っているものも、実はその人々以上に奴隷なのだ。どうしてこのような変化が起きたのか。わたしには分からない。何がそれを{% bouten() %}正当なものたらしめる{% end %}か。わたしはこの問題に答えることができると信ずる。
