+++
title = "サイトをリニューアルしました2026春"
date = 2026-05-21

[taxonomies]
tags = ["tech"]

[extra]
lang = "ja"
heading_hashes = true
+++

このサイト [lemonadern.dev](https://lemonadern.dev/) をリニューアルした。

リポジトリは[こちら](https://github.com/lemonadern/lemonadern.dev)。

## Lume 時代

[前のブログ](https://github.com/lemonadern/lume-blog)は Deno の SSG であるところの [Lume](https://lume.land/) を使って作ったものだった。2022年から2023年の年越しで作ったサイトなので3年半くらい動いていたことになる。（動いていた、と言っても GitHub Pages に置いてあっただけだが）

その間に Deno は1回、 Lume は2回にわたりメジャーバージョンを更新し、普通についていくのがしんどくなっていた。4月に一度 AI を使って[メンテした](https://sizu.me/lemonadern/posts/oev7hbzmx1od)が、虚無の作業ではあった。

## Zola へ移行

ただの静的サイトなんて放置したところで脆弱性なんてないに等しいわけだし、化石のまま置いておいても対して問題にはならない。でも復旧時に余計な作業が増えるのは避けたいとは感じていた。他で忙しいときは個人サイトなんて触れないので、もっと枯れた、あるいはシンプルな SSG に移行したい気持ちがあった。

ということで Hugo や Jekyll などの大御所を見ていたが、 結局 Rust 製の [Zola](https://www.getzola.org/) を使うことにした。 Rust 製といってもワンバイナリなので Rust が顔を出してくることはなく、メンテが大変ってこともなさそう。

### テンプレートエンジン

Zola のテンプレートエンジンは [Tera](https://keats.github.io/tera/) というやつだが、見た目は Jinja2 とか Django のテンプレートっぽいので馴染みはある。基本的に AI に書かせてるので細かい違いはわからない。

### TOML front matter

ユーザ視点で特徴的なのは Markdown の front matter が toml なこと。ここは Rust エコシステムみがある。けっこう珍しい気がするがこのへんの相互変換は大した作業じゃないので気にしていない。正直 YAML より TOML のほうが好きだし。

### Theme

Zola にはテーマ機能があり、今回は [serene](https://github.com/isunjn/serene) というやつを使わせてもらった。めっちゃシンプルで気に入っている。スタイルは継承しつつ色々カスタマイズを入れていて、 ToC の現在位置ハイライトを入れたりモバイルにも ToC を追加したり、前後記事へのリンクを入れたり、見出しのレベルを表示できるオプションを入れたり、細かいところを挙げればキリがないが色々やった。まだ favicon とかは用意してないいないものの概ね満足行くレベルになったので公開という運びになりました。

## 以前のコンテンツ

以前のサイトに置いていた内容はこのサイトでも[アーカイブ](/archive/)として残している。リダイレクトも設定してあるのでリンク切れとかも無いはずです。


## おわりに

今後はここで記事を書いていく予定です。[RSS](/posts/feed.xml) で更新をお待ちください。
