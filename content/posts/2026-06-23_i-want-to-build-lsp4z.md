+++
title = "LSP4Z をつくりたい（任意の言語サーバを動かすための選択肢について）"
date = 2026-06-23
description = "任意の言語サーバを設定だけで動かすための選択肢と、Zed で同じことができるかを調べた"

[taxonomies]
tags = ["tech", "lsp"]

[extra]
lang = "ja"
heading_hashes = true
+++

最近は Zed を好んで使っている。だが生活していると、手元にある任意の言語サーバを動かしてエディタと連携させたくなることがある。設定ファイルをゴニョゴニョするだけで好きな言語サーバを使える体験を Zed で実現できないかと思い少し調査したので、それについてまとめておく。

## Zed で言語サーバを使う正規ルート

Zed における言語サポートは拡張機能によって提供される（[Language Extensions](https://zed.dev/docs/extensions/languages)）。拡張機能で言語を宣言して tree-sitter grammar を置いておくと、Zed はそれを利用してシンタックスハイライト・括弧の対応・自動インデントといったエディタとしての基本機能を実現する。

言語サーバももちろんサポートされていて、拡張機能側では言語に対応する言語サーバを登録でき、拡張機能をインストールすればそれが利用される。

## 設定だけで任意の言語サーバを動かしたい

言語サーバを使いたければ拡張機能を用意するのが正規の方法なわけだが、それが面倒なときもある。
ここで欲しくなるのが、**設定ファイルをいじるだけで**手元にある言語サーバを使わせる体験である。

たとえば Neovim や Emacs なら、設定ファイルにせいぜい十数行の設定を書くだけで言語サーバとの連携が実現できる。特に Neovim 0.11 以降と Emacs 29 以降にはビルトインで言語クライアントが入っているため、やるべきはサーバと連携するクライアントの設定を書くことだけだ。

一方 Zed では、設定を書くだけで言語サーバを動かす機能は要望としてこそ挙がっているものの、それ以上の進展はない。「正規ルートの拡張機能を使いましょう」ということで issue も close されている。

- discussion: [The possibility to add custom language servers in configuration only · Discussion #24092](https://github.com/zed-industries/zed/discussions/24092)
- issue: [How to add custom language server · Issue #52653](https://github.com/zed-industries/zed/issues/52653)

ただ、こうした機能がないこと自体はあまり珍しいことではない。VS Code や JetBrains 系 IDE、Eclipse といった IDE/エディタは Zed と同様に、言語サポートには拡張機能/プラグインを要求する。言語サーバはあくまで拡張機能が提供する言語サポートの一部でありバックエンドであって、設定ファイルからそれを管理・制御することはできない。そういう意味ではむしろ Neovim や Emacs のような自由度重視のエディタが例外的な立ち位置にあるといえるだろう。

## 汎用クライアントというエスケープハッチ

では、Neovim / Emacs 以外のマネージド系エディタで言語サーバを使いたくなったら、個別に拡張機能/プラグインを作らないといけないのかというと、必ずしもそうではない。

**設定から任意の言語サーバを追加できる拡張機能**があればよいのだ。拡張機能がクライアントとサーバの管理を担えれば、その拡張機能の設定として言語サーバの起動やクライアントとの連携を書くだけで使えるようになる。いわば汎用クライアントというエスケープハッチである。

実際、各エディタにはこうしたプロジェクトが存在する。

- LSP4E (Eclipse) 
	- Eclipse の LSP クライアント的なプロジェクト。言語サーバとプラグインの連携に使えるほか、普通にユーザがインストールして設定すれば任意の言語サーバを動かせる
	- [Eclipse LSP4E | projects.eclipse.org](https://projects.eclipse.org/projects/technology.lsp4e)
	- [GitHub - eclipse-lsp4e/lsp4e](https://github.com/eclipse-lsp4e/lsp4e)
- LSP4IJ (JetBrains IDE 向けプラグイン) 
	- RedHat が開発しているプラグインで、任意の言語サーバを設定して使うためのツール
	- [LSP4IJ Plugin for JetBrains IDEs \| JetBrains Marketplace](https://plugins.jetbrains.com/plugin/23257-lsp4ij)
	- [GitHub - redhat-developer/lsp4ij](https://github.com/redhat-developer/lsp4ij)
- VS Code Extensions
	- VS Code 拡張では、ざっと見つかっただけでも以下がある
		- [`mjmorales.generic-lsp-proxy`](https://marketplace.visualstudio.com/items?itemName=mjmorales.generic-lsp-proxy)
		- [`maximsmol.vscode-lsp-generic`](https://marketplace.visualstudio.com/items?itemName=maximsmol.vscode-lsp-generic)
		- [`zsol.vscode-glspc`](https://marketplace.visualstudio.com/items?itemName=zsol.vscode-glspc)
		- [`MercuryTechnologiesInc.alloglot-mercury`](https://marketplace.visualstudio.com/items?itemName=MercuryTechnologiesInc.alloglot-mercury)
	- ただ、どれも大してインストールされていない。おそらく VS Code は、言語サーバを用意したあとに最初にサポートされがちなエディタであり、こうしたツールの需要が少ないのだろう。

## Zed で "LSP4Z" は作れるか

ここまで来ると当然、Zed でも同じことを考えたくなる。任意の言語サーバを動かす拡張機能、いわば *LSP4Z* とでも呼ぶべきものを作れるだろうか。

結論から言うと、現状では **作れない。**

LSP4E や LSP4IJ が成立しているのは、IDE 側にランタイムで言語サーバを動的に登録する API があるからだ。設定に基づき、プラグインがサーバをエディタへ登録する。

一方で Zed にはこの類の API がない。拡張機能は Zed から問い合わせられて答えるコールバックしか持たず、新しいサーバを push する手段が Extension API に存在しないのである。サーバと言語の対応は拡張機能のマニフェストである `extension.toml` をパースして決定され、あとから追加する経路はない。ユーザの設定ファイルである `settings.json` も、既存サーバのバイナリ上書きや優先順位の変更ができるだけで、新しいスロットを増やすことはできない。

つまり「拡張を1回入れたら、あとは設定だけで任意のサーバを追加できる」という LSP4E / LSP4IJ 的な体験は、Extension API の制約によって現状の Zed では実現できないのである。

## 手元の環境だけでいいなら Dev Extension が使える

とはいえ、自分の手元の環境で動けばいいだけなら Dev Extension を使うという抜け道がある。

手元で `extension.toml` を書いて Dev Extension として読み込めば、好きなサーバを利用できる。

同じことをやっている人がいる：[zhcn000000/zed\-customlsp](https://github.com/zhcn000000/zed-customlsp)

中身を見るとわかるが特に難しいことはしていない。言語サーバを登録して言語と紐づける設定を書いているだけだ。 Dev Extension なので手元で任意のサーバを追加できる。

## 長期的には？

言語サーバを動かすのに拡張機能が必要という割り切りを非難するつもりはないが、それはそれとして拡張機能で任意の言語サーバを動かす逃げ道はあっていいと思う。

Extension API にサーバ設定を動的に追加するものが入れば、LSP4Z とでも呼ぶべき拡張機能が作れるようになる。今のところ手元では Dev Extension で妥協してしまっているが、暇だったら Zed にリクエストを投げるかもしれない。
