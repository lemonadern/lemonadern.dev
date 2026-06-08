+++
title = "go install したものをアンインストールする"
date = 2026-06-08

[taxonomies]
tags = ["tech", "jot"]

[extra]
lang = "ja"
heading_hashes = true
+++

## tl;dr
- `go uninstall` コマンドは無い
- `go install` で入れたものをアンインストールしたければ実行ファイルを消そう
- 実行ファイルの場所は `$GOBIN/` か `$GOPATH/bin/` か `$HOME/go/bin/` のいずれか

## `go uninstall` は存在しない

go 製のツールは `go install` で手元にインストールして利用できる。  
こんな感じで：`go install github.com/<username>/<repo>@latest`

では、アンインストールにはどんな方法があるのだろうか。cargo だと `cargo install` でインストールしたものは `cargo uninstall` でアンインストールできるが、go のサブコマンドを眺めるかぎりでは近しい機能は無さそうだ（Go 1.26.4 時点）。

## アンインストールの方法

Go には、`go install` に対応するアンインストールのコマンドは無い。アンインストールする唯一の方法は、該当するバイナリを消すことだ。

外部ツールの実行ファイルが配置される場所は環境変数によって以下のように決まるらしい。

1. `GOBIN` が設定されている場合、その場所
2. `GOBIN` が未設定、かつ `GOPATH` が設定されている場合、 `$GOPATH/bin`
3. `GOBIN` が未設定、かつ `GOPATH` も未設定の場合、 `$HOME/go/bin`

unix 系で、かつ `GOBIN` を触っていなければおそらく `~/go/bin/` にある。

### リファレンス
`go help install` から抜粋

```
:) go help install | head
usage: go install [build flags] [packages]

Install compiles and installs the packages named by the import paths.

Executables are installed in the directory named by the GOBIN environment
variable, which defaults to $GOPATH/bin or $HOME/go/bin if the GOPATH
environment variable is not set. Executables in $GOROOT
are installed in $GOROOT/bin or $GOTOOLDIR instead of $GOBIN.
Cross compiled binaries are installed in $GOOS_$GOARCH subdirectories
of the above.

```

## あとがき
Go の管理下で入れていたツールを mise での管理に移行しようとしたところ、 `go uninstall` 無いんだ... となったのでちょっと調べた。

`npm uninstall -g` のノリで `cargo uninstall` を当たり前に使っていたゆえの驚きだったけど、普通に考えたら Rust と Go はどうせシングルバイナリになるんだし、専用のコマンドなんて無くても充分である。

専用コマンドはインストール場所を解決してくれるという楽さこそあるが、まあ労力としては誤差の範疇だろう。

こういう話題のメモ、エーアイ時代には書き残す意味も必要性もほとんど失われたなあと思う。必要云々以前に認知すらしないので調べるきっかけもないというほうが正しいか。
