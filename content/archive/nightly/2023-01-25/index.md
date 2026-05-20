+++
title = "2023-01-25"
description = "高級言語の極致"
date = 2023-01-25
aliases = ["/nightly/2023/01/25/"]

+++


# やったこと

- LYAHFGG!
  - 5章（再帰）
  - 6章（高階関数）の途中まで

## Haskell

5章では再帰の練習として、std のリスト操作関数の再実装を主にやっていた。

ここで最後に出てきたのがクイックソート。

```hs
quickSort :: (Ord a) => [a] -> [a]
quickSort [] = []
quickSort (x : xs) =
  let biggerSorted = quickSort [a | a <- xs, a >= x]
      smallerSorted = quickSort [a | a <- xs, a < x]
   in smallerSorted ++ [x] ++ biggerSorted
```

これを見たときはけっこう感動してしまった。ポエミーに書くと :point_down: な感じ

> プログラムの意味が自分の内側に落とし込まれたその時、私は頭を殴られたような感覚をおぼえた。
> そのコードは、人間が考える「クイックソート」という概念そのものが表出したような姿でそこに現れていたのである。
> それはまさに、**メンタルモデルのハードコード**とでも形容されるべき様相を呈していた。
> プログラマとしての自分がいかに計算機の考え方に影響されていたかが強い実感としてもたらされ、私は「高級言語の成れの果てはこのようなものであろう」との確信めいた心持ちに至ったのである。

これはさすがに感情的なんだけど、言いたいことは伝わると思う。感動してます。

似たような話を違うところで見た。

> プログラマーの「代行してくれるオートマトンに手順を指示出しする」というメンタルモデルは、デザイナーの「それが何であるかを自分自身の手で宣言的に描く/書く」それとあまり相性がよろしくないので、マークアップ言語の方がデザイン向き^[https://twitter.com/_baku89/status/1618155055533928453?s=20&t=u6YiWhtT6ND0QWm63nEcHg]

わかるなあ。brack もそういうとこあるしな

## みたやつ

### Kernel/VM探検隊online part6

Ruiさんが mold リンカのCPU移植の話をしていたので見た。おもしろかった。

<iframe width="100%" height="315" src="https://www.youtube.com/embed/yuSVbuiaBuU?start=15170" title="YouTube video player" frameborder="0" allow="accelerometer; autoplay; clipboard-write; encrypted-media; gyroscope; picture-in-picture; web-share" allowfullscreen></iframe>

### 「デジデジとチマチマの狭間で」橋本麦さん 特別講演 -東京藝術大学アートDXプロジェクト-

https://vimeo.com/event/2667716/dac315c3b5

まだ見てる途中だけど面白いので貼っておく。 Lisp で書けるデザインツールの話とか。
