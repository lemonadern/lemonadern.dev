+++
title = "2023-02-01"
description = "経験値としての Immutable Data Modeling"
date = 2023-02-01
aliases = ["/nightly/2023/02/01/"]

[taxonomies]
tags = ["nightly"]
+++


# やったこと

- LYAHFGG! 7章つづき

## 見た

<iframe width="100%" height="315" src="https://www.youtube.com/embed/VK4GpC34fBw" title="YouTube video player" frameborder="0" allow="accelerometer; autoplay; clipboard-write; encrypted-media; gyroscope; picture-in-picture; web-share" allowfullscreen></iframe>

『和田卓人×和田省二　データベースを巡る世代間闘争』

SQLアンチパターン刊行時^[2013年（9年前）]に行われた、訳者である和田卓人さんとその父である省二さんがデータベースについて語るセッション。和田省二さんはRDBの技術者らしい。

SQLアンチパターンは読んでないけど^[読みたい]面白そうだったので見てみた。

エンティティをイベントとリソースに分ける・NULLを許容しない・書き換えを許容しないなどの考え方が出てきて少し驚いた^[何様]。このようなプラクティスはイミュータブルデータモデリングの文脈で学んだことだったから、最近出てきたプラクティスなんだろうと勝手に思っていた。でもDOAなどをやっている人はずっと昔からこういう概念を身につけていたんだろう。
こういう考え方はRDBの使い方とは別で学ばないと身につかないと思うから、世の中の開発者はどうやって身につけているのか気になる。経験値と勉強の積み重ねなんだろうか。
