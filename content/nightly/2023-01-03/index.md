+++
title = "2023-01-03"
description = "日報がいい感じになってきた"
date = 2023-01-03
aliases = ["/nightly/2023/01/03/"]

[taxonomies]
tags = ["nightly"]

[extra]
math = true
+++


# やったこと

- 日報の改善
- 親戚とご飯
- 買い物
- 読書

日報が可愛く、使いやすくなってきた。普段から良い配色を見つけたら保存しているんだけど、今の配色はそのうちの一つ。気分で他のやつに変えるかも。

lume は文字通りそして嘘偽りなく `Static Site Generator`
なので、使っていると逆に新鮮な気持ちになる。およそフロントエンドをやっていた人間とは思えないような技術選定だけど、楽しいのでOK。将来的にはもっと下のレイヤから実装したい。

お昼は親戚と集まってご飯を食べた。正月ということで豪華な食事をお腹いっぱい食べて幸せだった。

夕方は買い物に行き、グリーンのかわいいバンドカラーシャツを買った。ずっと金欠だったので服を買ったのがめちゃくちゃ久しぶりな気がする。
本屋にも行ったけどそちらは休業していた。最悪でした。

本は、中村文則の短編集を読んでる。ここ2年くらいは技術書しか読んでいないので新鮮で楽しい。狂ったように小説ばかり読んでいた小・中学生時代を思い出した。

## 日報仲間が増えた

ishibeちゃんも[日報を始めた](https://hokuishi.be/daily)から、日報仲間が増えた。

~~日報は非中央集権だし分散型だから、俺達が _**Web3の最先端**_
と言っても過言ではないな！~~

## 日報の改善内容

今日実装した内容で、Markdownを使うときにあったら嬉しい機能はほとんどサポートできた気がする。
ちなみに、目次が必要になるほどの量の日報を書くなという自戒も込め、Anchorは付けないつもりでいる。

せっかくなので実装した機能を書いておく :point_down:

- 水色系のカラースキームにしてみた[^1]
- スタイルの調整[^2]
  - nested list が持つ疑似要素の色と形
  - リンクのスタイル
  - code 要素の背景色
  - a タグの折り返し
- 生成されるリンクが相対リンクになるようにした[^3]
- markdown 関連の修正[^4]
  - 脚注のサポート[^5]
  - url を貼るだけでリンクとして認識されるようになった
    - e.g. https://twitter.com/lemonadern
  - html タグをそのまま markdown の中に書けるようになった
    - \<code>code here\</code> => <code>code here</code>
  - emoji が使えるようになった :muscle:
    - \:bow: => :bow:
  - Typographic replacements が動くようになった
    - \(c) => (c)
  - 外部リンクは別タブで開くようになった
    - [内部リンク](../02/2023-01-02_index.md/)は同一タブのまま
  - 内部リンク時に直接mdファイルを指定できるようにした[^3]
  - Katex のサポート[^6]
    - 現状 lume のプラグインを使っているけど、 もしかしたら markdown-it
      のプラグインに移行するかも

$$
c = \pm\sqrt{a^2 + b^2}
$$

[^1]: commit:
https://github.com/lemonadern/nightly/commit/e5f163162b79d796531f9944e612d7ed5b5e6336

[^2]: commit:
https://github.com/lemonadern/nightly/commit/d12650c72997e31f5f6fd615b162bb795111db9d

[^3]: commit:
https://github.com/lemonadern/nightly/commit/b9bb02ec3192151ee651a6bafcc9bc29bf892f34

[^4]: commit:
https://github.com/lemonadern/nightly/commit/ede4758a47161632111a989ee055b94b7491c867

[^5]: 脚注うれしい！最高！やったー！

[^6]: commit:
https://github.com/lemonadern/nightly/commit/fd94839e92cbbfcbf02a8753d9d78b23dcb9b385
