+++
title = "2023-02-02"
description = "日本語訳しないほうが良いときもある"
date = 2023-02-02
aliases = ["/nightly/2023/02/02/"]

+++


# やったこと

- NN 3h
- LYAHFGG! 7章

# TIL

TIL: `Today I Learned` の略

## index の複数系：indexes と indecies の使い分け

- データベースの文脈での index （索引）の複数形は indexes
- 配列の添字の意味のときは indices (indicator の複数形とも)

参考：
[index の複数形は indexes なのか indices なのか - 猫でもわかるWebプログラミングと副業](https://www.utakata.work/entry/2016/02/02/105959)

## リレーションとリレーションシップの意味

RDBにおけるリレーションとリレーションシップは異なる概念だけど、誤用されがちという話

雑まとめ↓

| 意味                       | spell        | カタカナ表記       | 慣習的な日本語訳 |
| -------------------------- | ------------ | ------------------ | ---------------- |
| テーブルにおける行の集まり | relation     | リレーション       | 関係             |
| リレーションどうしの関係   | relationship | リレーションシップ | 関連             |

RDBのことを何となく勉強してテーブル設計を考え始めたら、リレーションシップのことをリレーションだと思ってしまうのも無理はない気がする。まあ、このあたりを議論する段になったときに誤用している人がいたら教えてあげるくらいでいいと思う。

## 代理キーと代替キー ： alternate key と surrogate key

- 代理キー (alternate key)： PKの代わりになりうる（一意の識別子だが）
  、PKでないもののこと
- 代替キー (surrogate key)： 一意性確保のためだけに生成された属性としての
  PKのこと
  - 人工キー(artilicial key)とも呼ばれる
  - 自然キー(natural key)に対する定義

このあたりは厳密な定義があるわけではないみたいで、文脈によって上述の定義に当てはまらないこともあるっぽい。

例えば、人工キーのことを alternate key と呼ぶこともある。

コッド博士の定義では、人工キーは、利用者が知ることのない（提示されたり、問い合わせに使ったりしない）キーであることが要求されるが、自動生成していれば人工キーと呼ぶ場合も多い。

## mkdir -p

mkdir はデフォルトで一段階のディレクトリしか作成できないが、 `-p`
オプションをつけると、複数階層のディレクトリを一気に作成できる。

デフォルトでは複数階層のディレクトリを作成できない :point_down:

```
$ mkdir first/second/
mkdir: cannot create directory ‘first/second/’: No such file or directory
```

`-p` オプションをつけると、複数階層のディレクトリを一気に作成できる :point_down:

```
$ mkdir -p first/second/
```

# 思ったこと

今日は英語関連の TIL が多かった。

index の複数系は、Haskell やってて `elemIndices`
関数を見て不思議に思ったので調べた。

relation と relationship がそれぞれ関係と関連と訳されたり、alternate key と
surrogate key
が代理キーと代替キーになるの、日本語訳の限界を感じる。英語のまま使おう。
