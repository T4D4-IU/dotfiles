# Error Report: error_report_002.md

## エラー内容
`mzj-mobile`, `myhx-mobile`, `hx` などのコマンドが `zsh: command not found` となり実行できません。

## エラーの意味
現在の `apply` スクリプト (`nix run . -- macbook`) は、macOS において `nix-darwin` (システム設定) のみを適用しており、ユーザー個別のツール定義が含まれる `home-manager` の設定を適用していません。`MyHelix` や `helix` は `home-manager` モジュールとして定義されているため、システム設定だけではインストールされません。

## 修正計画
`flake.nix` 内の `applyScript` を修正し、macOS (Darwin) の判定時に `nix-darwin` の適用に加えて `home-manager` の適用も行うようにコマンドを追加します。

具体的には、以下のコマンドを `Darwin` 判定ブロックに追加します：
`nix run path:${inputs.home-manager} -- switch --flake .#$USER@$HOSTNAME`

## 完了定義 (DoD)
- [ ] `nix run . -- macbook` を実行した際、`nix-darwin` と `home-manager` の両方が順次適用されること。
- [ ] 適用後、新しいシェル（または現在のシェルで設定をリロードした後）で `hx`, `myhx-mobile`, `mzj-mobile` コマンドが認識されること。
