+++
title = "ghq rm コマンドの経緯について"
date = 2026-06-09

[taxonomies]
tags = ["tech", "archaeology"]

[extra]
lang = "ja"
heading_hashes = true
+++

## tl;dr
- `ghq` には `rm` コマンドがあり、 ghq で管理しているリポジトリを削除できる
- この機能が入った時期と経緯を疑問に思ったので調べた
	- 自分の記憶では、前から要望は挙がっていたものの、個別のコマンドが無くても普通に `rm` すればよくねえかという話でリジェクトされていた気がする
	- （remove コマンドってあるのかなと思い調べたときにそれを読んで、まあたしかになと納得した記憶がある）
- 結論として、記憶どおり一度はメンテナに「新実装は不要」と判断されていた
- その後、別 Issue / PR の流れで正式に導入された（v1.5.0, 2024年2月）
	- それ以上の経緯については情報がなく不明

## ghq rm の実装が導入されたのはいつからか
2024年、1~2月の間に PR が出てマージ・リリースされた  
v1.5.0 から追加されている

- [PR #371 feat: implement `ghq rm` command](https://github.com/x-motemen/ghq/pull/371)
- [v1.5.0 (GitHub Release)](https://github.com/x-motemen/ghq/releases/tag/v1.5.0)
- [v1.5.0 (CHANGELOG)](https://github.com/x-motemen/ghq/blob/master/CHANGELOG.md#v150---2024-02-02)

## 導入までの時系列
`ghq rm` コマンドの要望は、 v1.0.0 までに issue と PR でそれぞれ一度ずつ却下されている。v1.0.0 以降に別のユーザが issue で再度要望を挙げており、そこから3年半ほど経過した v1.5.0 で突如として導入された。

導入までの時系列は次のようになっている：

- 2019-02-23: [PR #116 Add remove command](https://github.com/x-motemen/ghq/pull/116)
	- `remove` コマンドの実装提案
	- PR 作成時点の最新リリースは `v0.9.0` （2018-11-26）
	- 2019-04-27 に Songmu 氏が次のような旨を返信してクローズ
  		- `rm -rf $(ghq list --full-path --exact ...)` で実現できる
  		- 新しい実装を追加する必要はないと思う

- 2019-06-06: [Issue #184 Feature request: Remove/delete a repo](https://github.com/x-motemen/ghq/issues/184)
	- `ghq remove` が欲しいという要望
	- issue 作成時点の最新リリースは `v0.12.6` （2019-05-29）
	- Songmu 氏は `ghq list --full-path ... | xargs rm -r` で十分ではないかと返している
	- その後、2019-12-24 に次のような旨を述べてクローズしている
		- 自分はあまり必要性を感じない
		- まずは `ghq list` を強化したい
	- close 時点のリリースは `v0.17.0` （2019-12-24）

- 2020-01-05: `v1.0.0` リリース
	- [Release v1.0.0](https://github.com/x-motemen/ghq/releases/tag/v1.0.0)
	- [CHANGELOG v1.0.0](https://github.com/x-motemen/ghq/blob/master/CHANGELOG.md#v100-2020-01-05)

- 2020-09-23: [Issue #299 ghq remove|rm](https://github.com/x-motemen/ghq/issues/299)
	- `ghq rm github.com/username/repo` があると便利、という再要望
	- issue 作成時点の最新リリースは `v1.1.5` （2020-07-24）
	- この issue は約3年半後の該当機能の実装に伴い `as completed` でクローズされる

- 2024-01-26: [PR #371 feat: implement `ghq rm` command](https://github.com/x-motemen/ghq/pull/371)
	- `ghq rm` が実装される
	- PR 作成時点の最新リリースは `v1.4.2` （2023-04-16）
	- 2024-02-02 にマージ・リリース
		- [Release v1.5.0](https://github.com/x-motemen/ghq/releases/tag/v1.5.0)
		- [CHANGELOG v1.5.0](https://github.com/x-motemen/ghq/blob/master/CHANGELOG.md#v150---2024-02-02)
	- Songmu 氏が同 PR で「Released as v1.5.0.」とコメント

## 導入後の改善

導入後に入った `ghq rm` 関連の変更についても記載しておく：

- 2024-04-04: [PR #381 ghq rm to support bare option](https://github.com/x-motemen/ghq/pull/381)
	- bare repository 向けの対応
	- released in: `v1.6.0` （2024-04-04）
- 2024-07-12: [PR #390 feat(misc): support "ghq rm" completion](https://github.com/x-motemen/ghq/pull/390)
	- `ghq rm` の補完対応
	- released in: `v1.6.2` （2024-07-12）
- 2025-11-12: [PR #426 fix: accept bare flag to remove bare repositories](https://github.com/x-motemen/ghq/pull/426)
	- bare repository を削除できない問題の修正
	- released in: `v1.8.1` （2026-02-01）
- 2026-04-11: [PR #481 feat(rm): make ghq rm worktree-aware](https://github.com/x-motemen/ghq/pull/481)
	- `git worktree` を考慮した削除に改善
	- released in: `v1.10.1` （2026-04-11）

## あとがき
記憶どおり、過去に `ghq rm` の要望はリジェクトされていた。数年経ってから独立に投げられた PR がマージされたようだ。それ以上の情報はあまり得られなかった。

仕様変更とかが複雑なわけでもなく、機能が入る/入らないというだけの経緯をまとめるという暇人みたいな記事になってしまったが、ghq ユーザとしてたまに記憶と現実のコンフリクトで違和感を覚えていたところであったので、経緯をまとめられてよかった。
